package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dao.AdminMapper;
import com.example.demo.model.AdminMemberModel;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminMapper adminMapper;

    @Override
    public int getUserCount() {
        return adminMapper.countUsers();
    }

    @Override
    public int getPostCount() {
        return adminMapper.countPosts();
    }

    @Override
    public int getCommentCount() {
        return adminMapper.countComments();
    }
  

    @Override
    public List<AdminMemberModel> findAllMembers() {
        return adminMapper.findAllMembers();
    }
    
    @Override
    public List<AdminMemberModel> getAllMemberSummary() {
        return adminMapper.findAllMembers(); // Mapper에 있는 SQL 실행
    }
    
}
