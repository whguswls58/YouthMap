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
import com.example.demo.model.MemberModel;

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
    public List<AdminMemberModel> getAllMemberSummary() {
        return adminMapper.findAllMembers();
    }
    
    @Override
    public List<AdminMemberModel> getMembersWithPaging(Map<String, Object> params) {
        return adminMapper.findMembersWithPaging(params);
    }
    
    @Override
    public int getMemberCountWithSearch(String search) {
        return adminMapper.countMembersWithSearch(search);
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
    public int getPostCountExcludeNotices() {
        return adminMapper.countPostsExcludeNotices();
    }
    
    @Override
    public int getPostCountExcludeNoticesWithSearch(String search) {
        return adminMapper.countPostsExcludeNoticesWithSearch(search);
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
        try {
            MemberModel adminMember = adminMapper.validateAdminLogin(adminId, adminPass);
            return adminMember != null;
        } catch (Exception e) {
            return false;
        }
    }
    
    @Override
    public MemberModel getAdminInfo(String adminId, String adminPass) {
        return adminMapper.validateAdminLogin(adminId, adminPass);
    }
    
    // ===== 공지사항 관리 =====
    
    @Override
    public int getNoticeCount() {
        return adminMapper.countNotices();
    }
    
    @Override
    public void insertNotice(String boardSubject, String boardContent, Long memNo) {
        Board notice = new Board();
        notice.setBoardSubject(boardSubject);
        notice.setBoardContent(boardContent);
        notice.setBoardCategory("공지");
        notice.setMemNo(memNo.intValue());
        boardDao.insert(notice);
    }
    
    @Override
    public void updateNotice(int boardNo, String boardSubject, String boardContent) {
        Board notice = new Board();
        notice.setBoardNo(boardNo);
        notice.setBoardSubject(boardSubject);
        notice.setBoardContent(boardContent);
        notice.setBoardCategory("공지");
        boardDao.update(notice);
    }
    
    @Override
    public void deleteNotice(int boardNo) {
        boardDao.delete(boardNo);
    }

} 