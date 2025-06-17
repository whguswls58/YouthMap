package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.model.AdminMemberModel;

@Mapper
public interface AdminDao {

    int countUsers();

    int countPosts();

    int countComments();
    
    List<AdminMemberModel> findAllMembers();
    
    String getMemberStatus(Long memNo);
    void updateMemberStatus(@Param("memNo") Long memNo, @Param("status") String status);
}
