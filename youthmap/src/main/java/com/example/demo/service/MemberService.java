package com.example.demo.service;

import com.example.demo.model.MemberModel;

public interface MemberService {

    // 회원가입
    void register(MemberModel member);

    // 아이디 중복 확인
    boolean isIdDuplicate(String memId);
    
    // 아이디 조회 
    MemberModel findByMemId(String memId);
    
    // 회원 수정 
    void updateMember(MemberModel member);
    
    //비밀번호 변경
    void updatePassword(MemberModel member);
    
    //회원 탈퇴 
    public void updateMemberStatus(MemberModel member);
    
    //oauth  
    MemberModel findByOauthId(String oauthId);

    void updateOauthId(MemberModel member);

    
    
    
}
