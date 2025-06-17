package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.demo.dao.MemberMapper;
import com.example.demo.model.MemberModel;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {

    private final MemberMapper memberMapper;
    
    @Autowired
    private ApplicationContext applicationContext;

    @Override
    public void register(MemberModel member) {
        // 비밀번호 암호화
        PasswordEncoder passwordEncoder = applicationContext.getBean(PasswordEncoder.class);
        String encodedPassword = passwordEncoder.encode(member.getMemPass());
        member.setMemPass(encodedPassword);
        
        System.out.println("회원가입 - 원본 비밀번호 길이: " + member.getMemPass().length());
        System.out.println("회원가입 - 암호화된 비밀번호 길이: " + encodedPassword.length());
        
        memberMapper.insertMember(member);
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
