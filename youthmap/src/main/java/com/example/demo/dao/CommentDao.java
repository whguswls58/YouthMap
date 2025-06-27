package com.example.demo.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Comment;

@Mapper
public interface CommentDao {

    int insert(Comment comment);            // 댓글 등록

    List<Comment> list(int boardNo);        // 해당 게시글의 댓글 목록

    int delete(int commNo);                 // 댓글 삭제
    
    public Comment getCommentByNo(int commNo);
    
    int update(Comment comment);            // 댓글 수정
    
    // 내 댓글 조회
    List<Comment> getMyComments(Map<String, Object> params);
}