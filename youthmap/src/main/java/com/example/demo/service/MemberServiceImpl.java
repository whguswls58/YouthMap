package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.demo.dao.MemberDao;
import com.example.demo.model.MemberModel;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {

    private final MemberDao memberMapper;
    
    @Autowired
    private ApplicationContext applicationContext;

    @Override
    public void register(MemberModel member) {
        System.out.println("=== MemberService.register 시작 ===");
        System.out.println("저장할 member 데이터: " + member);
        
        try {
            // 비밀번호를 평문 그대로 저장 (암호화 제거)
            System.out.println("DB insert 시작...");
            memberMapper.insertMember(member);
            System.out.println("DB insert 완료");
        } catch (Exception e) {
            System.out.println("DB insert 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            throw e; // 예외를 다시 던져서 컨트롤러에서 처리하도록 함
        }
    }

    @Override
    public boolean isIdDuplicate(String memId) {
        System.out.println("서비스 - 중복검사 memId: '" + memId + "'");
        System.out.println("서비스 - 중복검사 memId 길이: " + (memId != null ? memId.length() : 0));
        
        // 실제 카운트 결과 확인
        int count = memberMapper.countByMemId(memId);
        System.out.println("서비스 - DB에서 조회된 카운트: " + count);
        
        // 중복이면 true, 사용가능하면 false 반환
        boolean result = count > 0;
        System.out.println("서비스 - 중복검사 결과: " + result + " (true=중복, false=사용가능)");
        return result;
    }

    @Override
    public MemberModel findByMemId(String memId) {
    	System.out.println("받은 memId: " + memId);
        return memberMapper.findByMemId(memId);
    }
    
    @Override
    public void updateMember(MemberModel member) {
        memberMapper.updateMember(member);
    }

    @Override
    public void updatePassword(MemberModel member) {
        memberMapper.updatePassword(member);
    }

    @Override
    public void updateMemberStatus(MemberModel member) {
        memberMapper.updateMemberStatus(member);
    }

    @Override
    public MemberModel findByOauthId(String oauthId) {
        return memberMapper.findByOauthId(oauthId);
    }
    
    @Override
    public void updateOauthId(MemberModel member) {
        memberMapper.updateOauthId(member);
    }

   


}
