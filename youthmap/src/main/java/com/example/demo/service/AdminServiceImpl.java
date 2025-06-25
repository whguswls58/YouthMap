package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dao.AdminDao;
import com.example.demo.dao.BoardDao;
import com.example.demo.dao.CommentDao;
import com.example.demo.model.AdminMemberModel;
import com.example.demo.model.Board;
import com.example.demo.model.Comment;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminDao adminMapper;
    
    @Autowired
    private BoardDao boardDao;
    
    @Autowired
    private CommentDao commentDao;

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
    public int getRestaurantCount() {
        return adminMapper.countRestaurants();
    }

    @Override
    public int getPolicyCount() {
        return adminMapper.countPolicy();
    }

    @Override
    public int getCultureCount() {
        return adminMapper.countCulture();
    }
    
    
  

    @Override
    public List<AdminMemberModel> findAllMembers() {
        return adminMapper.findAllMembers();
    }
    
    @Override
    public List<AdminMemberModel> getAllMemberSummary() {
        return adminMapper.findAllMembers();
    }
    
    @Override
    public List<Board> getAllPosts() {
        return boardDao.getAllPosts();
    }
    
    @Override
    public List<Board> getPostsWithPaging(Map<String, Object> params) {
        return boardDao.list(params);
    }
    
    @Override
    public List<Board> getTopNotices() {
        return boardDao.getTopNotices();
    }
    
    @Override
    public Board getPostDetail(int boardNo) {
        return boardDao.content(boardNo);
    }
    
    @Override
    public List<Comment> getCommentsByBoardNo(int boardNo) {
        return commentDao.list(boardNo);
    }
    
    @Override
    public void deleteComment(int commentNo) {
        commentDao.delete(commentNo);
    }
    
    @Override
    public boolean validateAdminLogin(String adminId, String adminPass) {
        // 하드코딩된 관리자 계정
        if ("admin".equals(adminId) && "adminabc".equals(adminPass)) {
            System.out.println("✅ 관리자 로그인 성공: " + adminId);
            return true;
        }
        
        System.out.println("❌ 관리자 로그인 실패: " + adminId);
        return false;
    }

} 