package com.example.demo.service;

import java.util.List;
import java.util.Map;

import com.example.demo.model.AdminMemberModel;
import com.example.demo.model.Board;
import com.example.demo.model.Comment;

public interface AdminService {
    int getUserCount();
    int getPostCount();
    int getCommentCount();
    int getRestaurantCount();
    int getPolicyCount();
    int getCultureCount();
    
    //회원정보 불러오
    List<AdminMemberModel> getAllMemberSummary();
    //회원 정보찾기 
    List<AdminMemberModel> findAllMembers();
    
    // 게시물 목록 조회
    List<Board> getAllPosts();
    
    // 페이징된 게시물 목록 조회
    List<Board> getPostsWithPaging(Map<String, Object> params);
    
    // 공지사항 조회
    List<Board> getTopNotices();
    
    // 게시물 상세 조회
    Board getPostDetail(int boardNo);
    
    // 댓글 목록 조회
    List<Comment> getCommentsByBoardNo(int boardNo);
    
    // 댓글 삭제
    void deleteComment(int commentNo);
    
    // 관리자 로그인 검증
    boolean validateAdminLogin(String adminId, String adminPass);

}
