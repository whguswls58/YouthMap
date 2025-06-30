package com.example.demo.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.model.AdminMemberModel;
import com.example.demo.model.MemberModel;

@Mapper
public interface AdminDao {

    int countUsers();

    int countPosts();

    int countComments();
    
    int countRestaurants();
    
    int countPolicy();
    
    int countCulture();
    
    // 공지사항 제외한 게시물 수 조회
    int countPostsExcludeNotices();
    
    // 검색 조건에 따른 공지사항 제외한 게시물 수 조회
    int countPostsExcludeNoticesWithSearch(@Param("search") String search);
    
    // 공지사항 수 조회
    int countNotices();
    
    List<AdminMemberModel> findAllMembers();
    
    // 검색 조건에 따른 회원 수 조회
    int countMembersWithSearch(@Param("search") String search);
    
    // 검색 조건과 페이징을 적용한 회원 목록 조회
    List<AdminMemberModel> findMembersWithPaging(Map<String, Object> params);
    
    //String getMemberStatus(Long memNo);
    //void updateMemberStatus(@Param("memNo") Long memNo, @Param("status") String status);

    // 관리자 로그인 검증
    MemberModel validateAdminLogin(@Param("memId") String memId, @Param("memPass") String memPass);

}
