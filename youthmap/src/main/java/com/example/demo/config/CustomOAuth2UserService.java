package com.example.demo.config;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Map;

import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.example.demo.model.MemberModel;
import com.example.demo.service.MemberService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final MemberService memberService;
    private final HttpSession session;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);
        String regId    = userRequest.getClientRegistration().getRegistrationId(); // "google" or "naver"
        String oauthId  = null;
        String email    = null;
        String name     = null;

        if ("google".equals(regId)) {
            oauthId = oAuth2User.getAttribute("sub");
            email   = oAuth2User.getAttribute("email");
            name    = oAuth2User.getAttribute("name");

        } else if ("naver".equals(regId)) {
            @SuppressWarnings("unchecked")
            Map<String,Object> resp = (Map<String,Object>)oAuth2User.getAttributes().get("response");
            if (resp != null) {
                oauthId = (String) resp.get("id");
                // email은 옵션 처리: 없으면 null
                email   = (String) resp.get("email");
                name    = (String) resp.get("name");
            }
        }

        // oauthId 만 필수
        if (oauthId == null) {
            throw new OAuth2AuthenticationException("OAuth ID 정보가 없습니다.");
        }

        // 1) 기존에 oauthId 등록된 사용자 있는지
        MemberModel member = memberService.findByOauthId(oauthId);

        if (member == null) {
            // 사용할 memId 결정
            String memId = email != null
                           ? email
                           : regId + "_" + oauthId; 

            // 2) memId(email 또는 generated)로 중복 확인
            member = memberService.findByMemId(memId);
            if (member != null) {
                // 이미 있으면 oauthId만 업데이트
                member.setOauthId(oauthId);
                memberService.updateOauthId(member);

            } else {
                // 완전 신규 회원
                member = new MemberModel();
                member.setMemId(memId);
                member.setMemPass("OAUTH_DUMMY");
                member.setMemName(name);
                member.setMemType(regId.toUpperCase());   // GOOGLE 또는 NAVER
                member.setMemStatus("ACTIVE");
                member.setOauthId(oauthId);

                // 이메일이 있으면 memMail에도 저장
                if (email != null) {
                    member.setMemMail(email);
                }

                // 네이버만 생년월일, 성별 추가 처리
                if ("naver".equals(regId)) {
                    String gender    = (String) ((Map<String,Object>)oAuth2User.getAttributes().get("response")).get("gender");
                    String birthyear = (String) ((Map<String,Object>)oAuth2User.getAttributes().get("response")).get("birthyear");
                    String birthday  = (String) ((Map<String,Object>)oAuth2User.getAttributes().get("response")).get("birthday");
                    if (birthyear != null && birthday != null) {
                        try {
                            LocalDate bd = LocalDate.parse(birthyear + "-" + birthday);
                            member.setBirthDate(bd);
                        } catch (DateTimeParseException e) {
                            // 파싱 실패 로그만 남기고 진행
                            System.out.println("생일 파싱 실패: " + birthyear + "-" + birthday);
                        }
                    }
                    if (gender != null) {
                        member.setMemGen(gender);
                    }
                }

                memberService.register(member);
            }
        }

        // 세션에 로그인 정보 저장
        session.setAttribute("loginMember", member);
        session.setAttribute("memberNo", member.getMemNo());
        
        // ✅ OAuth2 로그인 시에도 세션 시간 설정
        session.setMaxInactiveInterval(30 * 60); // 30분 (1800초)
        session.setAttribute("loginStartTime", System.currentTimeMillis());
        
        System.out.println("=== OAuth2 로그인 성공 ===");
        System.out.println("세션에 loginStartTime: " + session.getAttribute("loginStartTime"));

        return oAuth2User;
    }
}

