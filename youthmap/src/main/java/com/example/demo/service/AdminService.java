package com.example.demo.service;

import java.util.List;

import com.example.demo.model.AdminMemberModel;

public interface AdminService {
    int getUserCount();
    int getPostCount();
    int getCommentCount();
    
    //회원정보 불러오
    List<AdminMemberModel> getAllMemberSummary();
    //회원 정보찾기 
    List<AdminMemberModel> findAllMembers();
}
