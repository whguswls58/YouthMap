package com.example.demo.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.model.AdminMemberModel;

@Mapper
public interface AdminDao {

    int countUsers();

    int countPosts();

    int countComments();
    
    int countRestaurants();
    
    int countPolicy();
    
    int countCulture();
    
    List<AdminMemberModel> findAllMembers();
    
    String getMemberStatus(Long memNo);
    void updateMemberStatus(@Param("memNo") Long memNo, @Param("status") String status);

}
