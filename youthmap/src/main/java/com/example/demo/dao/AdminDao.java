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
    
    // 공지사항 수 조회
    int countNotices();
    
    List<AdminMemberModel> findAllMembers();
    
    //String getMemberStatus(Long memNo);
    //void updateMemberStatus(@Param("memNo") Long memNo, @Param("status") String status);

    // 관리자 로그인 검증
    MemberModel validateAdminLogin(@Param("memId") String memId, @Param("memPass") String memPass);

}
