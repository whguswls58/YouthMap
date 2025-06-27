package com.example.demo.service;

import java.util.List;
import java.util.Map;

import com.example.demo.model.AdminMemberModel;
import com.example.demo.model.Board;
import com.example.demo.model.Comment;
import com.example.demo.model.MemberModel;

public interface AdminService {
    
    // 회원 관리
    List<AdminMemberModel> getAllMemberSummary();
    
    // 게시물 관리
    List<Board> getAllPosts();
    List<Board> getPostsWithPaging(Map<String, Object> params);
    
    // 통계
    int getUserCount();
    int getPostCount();
    int getPostCountExcludeNotices();
    int getCommentCount();
    int getRestaurantCount();
    int getPolicyCount();
    int getCultureCount();
    int getNoticeCount();
    
    // 게시물 상세
    Board getPostDetail(int boardNo);
    
    // 댓글 관리
    List<Comment> getCommentsByBoardNo(int boardNo);
    void deleteComment(int commentNo);
    
    // 공지사항 관리
    void insertNotice(String boardSubject, String boardContent, Long memNo);
    void updateNotice(int boardNo, String boardSubject, String boardContent);
    void deleteNotice(int boardNo);
    
    // 사용되지 않는 관리자 로그인 관련 메서드들
    boolean validateAdminLogin(String adminId, String adminPass);
    MemberModel getAdminInfo(String adminId, String adminPass);
}
