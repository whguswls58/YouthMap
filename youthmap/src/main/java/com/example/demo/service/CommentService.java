package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dao.CommentDao;
import com.example.demo.model.Comment;

@Service
public class CommentService {

    @Autowired
    private CommentDao commentDao;

    // 댓글 등록
    public int insert(Comment comment) {
        return commentDao.insert(comment);
    }

    // 댓글 목록 조회
    public List<Comment> list(int boardNo) {
        return commentDao.list(boardNo);
    }

    // 댓글 삭제
    public int delete(int commNo) {
        return commentDao.delete(commNo);
    }
    
    public Comment getCommentByNo(int commNo) {
        return commentDao.getCommentByNo(commNo);
    }
}