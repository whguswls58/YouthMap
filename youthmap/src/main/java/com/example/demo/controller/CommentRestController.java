package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.example.demo.model.Comment;
import com.example.demo.service.CommentService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/comments")
public class CommentRestController {

    @Autowired
    private CommentService commentService;

    // ✅ 1. 댓글 목록 가져오기
    @GetMapping("/{boardNo}")
    public List<Comment> getComments(@PathVariable("boardNo") int boardNo) {
        return commentService.list(boardNo);
    }

    // ✅ 2. 댓글 등록
    @PostMapping
    public String addComment(@RequestBody Comment comment) {
        int result = commentService.insert(comment);
        return result == 1 ? "success" : "fail";
    }

    // ✅ 3. 댓글 삭제
    @DeleteMapping("/{commNo}")
    public String deleteComment(@PathVariable("commNo") int commNo, HttpSession session) {
        String memId = (String) session.getAttribute("memId");
        String memRole = (String) session.getAttribute("memRole");

        if (memId == null) return "fail"; // 로그인 안 됨

        // 🔍 댓글 정보 조회
        Comment comment = commentService.getCommentByNo(commNo);

        if (comment == null) {
            System.out.println("❌ 댓글 조회 실패 (null 반환)");
            return "fail";
        }

        // 🔐 본인이거나 관리자면 삭제 허용
        if (!memId.equals(comment.getMemId()) && !"ADMIN".equals(memRole)) {
            return "fail";
        }

        int result = commentService.delete(commNo);
        return result == 1 ? "success" : "fail";
    }
}