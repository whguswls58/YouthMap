package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.model.Comment;
import com.example.demo.model.MemberModel;
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
        try {
            System.out.println("댓글 목록 요청 - boardNo: " + boardNo);
            List<Comment> comments = commentService.list(boardNo);
            System.out.println("댓글 목록 결과: " + comments);
            return comments;
        } catch (Exception e) {
            System.out.println("댓글 목록 조회 중 예외 발생: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // ✅ 2. 댓글 등록
    @PostMapping
    public String addComment(@RequestBody Comment comment, HttpSession session) {
        System.out.println("=== 댓글 등록 시작 ===");
        System.out.println("받은 댓글 데이터: " + comment);
        System.out.println("boardNo: " + comment.getBoardNo());
        System.out.println("commContent: " + comment.getCommContent());
        
        // Spring Security에서 설정한 세션 정보 사용
        MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
        
        System.out.println("세션 loginMember: " + (loginMember != null ? loginMember.getMemId() : "null"));
        System.out.println("세션 memberNo: " + (loginMember != null ? loginMember.getMemNo() : "null"));
        
        if (loginMember == null) {
            System.out.println("댓글 등록 실패: 로그인 정보 없음");
            return "fail";
        }
        
        // 세션에서 사용자 정보 설정
        comment.setMemId(loginMember.getMemId());
        comment.setMemNo(loginMember.getMemNo().intValue());
        System.out.println("댓글 등록 - memId: " + comment.getMemId() + ", memNo: " + comment.getMemNo() + ", boardNo: " + comment.getBoardNo() + ", content: " + comment.getCommContent());
        
        try {
            int result = commentService.insert(comment);
            System.out.println("댓글 등록 결과: " + result);
            if (result == 1) {
                System.out.println("댓글 등록 성공!");
                return "success";
            } else {
                System.out.println("댓글 등록 실패: result = " + result);
                return "fail";
            }
        } catch (Exception e) {
            System.out.println("댓글 등록 중 예외 발생: " + e.getMessage());
            e.printStackTrace();
            return "fail";
        }
    }

    // ✅ 3. 댓글 삭제
    @DeleteMapping("/{commNo}")
    public String deleteComment(@PathVariable("commNo") int commNo, HttpSession session) {
        // Spring Security에서 설정한 세션 정보 사용
        MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
        
        if (loginMember == null) {
            System.out.println("댓글 삭제 실패: 로그인 정보 없음");
            return "fail"; // 로그인 안 됨
        }
        
        String memId = loginMember.getMemId();
        String memType = loginMember.getMemType();

        // 🔍 댓글 정보 조회
        Comment comment = commentService.getCommentByNo(commNo);

        if (comment == null) {
            System.out.println("❌ 댓글 조회 실패 (null 반환)");
            return "fail";
        }

        // 🔐 본인이거나 관리자면 삭제 허용
        if (!memId.equals(comment.getMemId()) && !"ADMIN".equals(memType)) {
            System.out.println("❌ 댓글 삭제 권한 없음 - 본인: " + memId + ", 댓글작성자: " + comment.getMemId());
            return "fail";
        }

        int result = commentService.delete(commNo);
        return result == 1 ? "success" : "fail";
    }
}