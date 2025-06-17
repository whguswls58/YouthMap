package com.example.demo.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.model.MemberModel;

@Mapper
public interface MemberMapper {

    // 회원가입
    void insertMember(MemberModel member);

    // 로그인용 회원 조회
    MemberModel findByMemId(String memId);

    // 아이디 중복 확인
    int countByMemId(@Param("memId") String memId);
    
    // 회원 번호(memNo)를 기준으로 회원 기본 정보 조회
    MemberModel selectMemberInfo(@Param("memNo") Long memNo);

    // 회원이 작성한 게시물 개수 조회
    int countPostsByMember(@Param("memNo") Long memNo);

    // 회원이 작성한 댓글 개수 조회
    int countCommentsByMember(@Param("memNo") Long memNo);
    
    //회원 정보 수정 
    void updateMember(MemberModel member);
    
    //회원 탈퇴 
    void updateMemberStatus(MemberModel member);
    
    //oauth 로그
    MemberModel findByOauthId(String oauthId);
    
    //아이디 중복
    void updateOauthId(MemberModel member);



}
