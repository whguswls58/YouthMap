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
        try {
            System.out.println("CommentService.insert 호출 - comment: " + comment);
            int result = commentDao.insert(comment);
            System.out.println("CommentService.insert 결과: " + result);
            return result;
        } catch (Exception e) {
            System.out.println("CommentService.insert 예외 발생: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    // 댓글 목록 조회
    public List<Comment> list(int boardNo) {
        try {
            System.out.println("CommentService.list 호출 - boardNo: " + boardNo);
            List<Comment> result = commentDao.list(boardNo);
            System.out.println("CommentService.list 결과 개수: " + (result != null ? result.size() : 0));
            return result;
        } catch (Exception e) {
            System.out.println("CommentService.list 예외 발생: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    // 댓글 삭제
    public int delete(int commNo) {
        try {
            System.out.println("CommentService.delete 호출 - commNo: " + commNo);
            int result = commentDao.delete(commNo);
            System.out.println("CommentService.delete 결과: " + result);
            return result;
        } catch (Exception e) {
            System.out.println("CommentService.delete 예외 발생: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
    
    public Comment getCommentByNo(int commNo) {
        try {
            System.out.println("CommentService.getCommentByNo 호출 - commNo: " + commNo);
            Comment result = commentDao.getCommentByNo(commNo);
            System.out.println("CommentService.getCommentByNo 결과: " + result);
            return result;
        } catch (Exception e) {
            System.out.println("CommentService.getCommentByNo 예외 발생: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
}