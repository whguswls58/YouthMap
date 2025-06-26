package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.model.MemberModel;
import com.example.demo.model.Board;
import com.example.demo.model.Comment;
import com.example.demo.service.AdminService;
import java.util.*;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	private  AdminService adminService;

    // 관리자 대시보드
    @GetMapping("/dashboard")
    public String adminDashboard(HttpSession session, Model model) {
        // 일반 로그인 세션에서 관리자 권한 확인
        MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
        if (loginMember == null || !"ADMIN".equals(loginMember.getMemType())) {
            return "redirect:/login";
        }

        model.addAttribute("userCount", adminService.getUserCount());
        model.addAttribute("postCount", adminService.getPostCount());
        model.addAttribute("commentCount", adminService.getCommentCount());
        model.addAttribute("restaurantCount", adminService.getRestaurantCount());
        model.addAttribute("policyCount", adminService.getPolicyCount());
        model.addAttribute("cultureCount", adminService.getCultureCount());

        return "admin/dashboard";
    }

    // 게시물 관리 목록
    @GetMapping("/posts")
    public String adminPosts(HttpSession session, Model model,
                           @RequestParam(value = "page", defaultValue = "1") int page,
                           @RequestParam(value = "search", required = false) String search) {
        // 일반 로그인 세션에서 관리자 권한 확인
        MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
        if (loginMember == null || !"ADMIN".equals(loginMember.getMemType())) {
            return "redirect:/login";
        }

        int limit = 10; // 페이지당 10개
        int startRow = (page - 1) * limit + 1;
        int endRow = page * limit;
        
        // 페이징 파라미터 설정 (Board.xml의 list 쿼리와 맞춤)
        Map<String, Object> params = new HashMap<>();
        params.put("startRow", startRow);
        params.put("endRow", endRow);
        params.put("excludeCategory", "공지"); // 공지사항 제외
        params.put("search", search); // 검색 조건 추가
        
        // 게시물 목록 조회 (공지사항 제외)
        List<Board> boardlist = adminService.getPostsWithPaging(params);
        
        // 전체 게시물 수 조회 (공지사항 제외, 페이징 계산용)
        int totalPosts = adminService.getPostCountExcludeNoticesWithSearch(search);
        int totalPages = (int) Math.ceil((double) totalPosts / limit);
        
        // 페이징 범위 계산
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);
        
        model.addAttribute("boardlist", boardlist);
        model.addAttribute("page", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("listcount", totalPosts);
        model.addAttribute("search", search);
        
        return "admin/posts";
    }

    // 게시물 상세 보기
    @GetMapping("/posts/view")
    public String adminPostView(@RequestParam("no") int boardNo,
                               HttpSession session, Model model) {
        // 일반 로그인 세션에서 관리자 권한 확인
        MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
        if (loginMember == null || !"ADMIN".equals(loginMember.getMemType())) {
            return "redirect:/login";
        }

        Board board = adminService.getPostDetail(boardNo);
        if (board == null) {
            return "redirect:/admin/posts";
        }

        // 게시물의 댓글 목록 조회
        List<Comment> comments = adminService.getCommentsByBoardNo(boardNo);

        model.addAttribute("board", board);
        model.addAttribute("comments", comments);
        return "admin/post-view";
    }

    // 댓글 삭제
    @PostMapping("/comments/delete")
    public String deleteComment(@RequestParam("commentNo") int commentNo,
                               HttpSession session) {
        // 일반 로그인 세션에서 관리자 권한 확인
        MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
        if (loginMember == null || !"ADMIN".equals(loginMember.getMemType())) {
            return "redirect:/login";
        }

        adminService.deleteComment(commentNo);
        return "redirect:/admin/posts";
    }

    // 로그아웃
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
    
    // ===== 공지사항 관리 =====
    
    // 공지사항 목록
    @GetMapping("/list")
    public String adminNotices(HttpSession session, Model model,
                             @RequestParam(value = "page", defaultValue = "1") int page) {
        // 일반 로그인 세션에서 관리자 권한 확인
        MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
        if (loginMember == null || !"ADMIN".equals(loginMember.getMemType())) {
            return "redirect:/login";
        }

        int limit = 10;
        int startRow = (page - 1) * limit + 1;
        int endRow = page * limit;
        
        Map<String, Object> params = new HashMap<>();
        params.put("startRow", startRow);
        params.put("endRow", endRow);
        params.put("category", "공지"); // 공지사항만 조회
        
        List<Board> noticelist = adminService.getPostsWithPaging(params);
        int totalNotices = adminService.getNoticeCount();
        int totalPages = (int) Math.ceil((double) totalNotices / limit);
        
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);
        
        model.addAttribute("noticelist", noticelist);
        model.addAttribute("page", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("listcount", totalNotices);
        
        return "admin/list";
    }
    
    // 공지사항 작성 폼
    @GetMapping("/list/write")
    public String noticeWriteForm(HttpSession session) {
        // 일반 로그인 세션에서 관리자 권한 확인
        MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
        if (loginMember == null || !"ADMIN".equals(loginMember.getMemType())) {
            return "redirect:/login";
        }
        return "admin/write";
    }
    
    // 공지사항 작성 처리
    @PostMapping("/list/write")
    public String noticeWrite(@RequestParam("boardSubject") String boardSubject,
                             @RequestParam("boardContent") String boardContent,
                             HttpSession session) {
        // 일반 로그인 세션에서 관리자 권한 확인
        MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
        if (loginMember == null || !"ADMIN".equals(loginMember.getMemType())) {
            return "redirect:/login";
        }
        
        adminService.insertNotice(boardSubject, boardContent, loginMember.getMemNo());
        
        return "redirect:/admin/list";
    }
    
    // 공지사항 상세 보기
    @GetMapping("/list/view")
    public String noticeView(@RequestParam("no") int boardNo,
                            HttpSession session, Model model) {
        // 일반 로그인 세션에서 관리자 권한 확인
        MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
        if (loginMember == null || !"ADMIN".equals(loginMember.getMemType())) {
            return "redirect:/login";
        }

        Board notice = adminService.getPostDetail(boardNo);
        if (notice == null || !"공지".equals(notice.getBoardCategory())) {
            return "redirect:/admin/list";
        }

        model.addAttribute("notice", notice);
        return "admin/view";
    }
    
    // 공지사항 수정 폼
    @GetMapping("/list/edit")
    public String noticeEditForm(@RequestParam("no") int boardNo,
                                HttpSession session, Model model) {
        // 일반 로그인 세션에서 관리자 권한 확인
        MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
        if (loginMember == null || !"ADMIN".equals(loginMember.getMemType())) {
            return "redirect:/login";
        }

        Board notice = adminService.getPostDetail(boardNo);
        if (notice == null || !"공지".equals(notice.getBoardCategory())) {
            return "redirect:/admin/list";
        }

        model.addAttribute("notice", notice);
        return "admin/edit";
    }
    
    // 공지사항 수정 처리
    @PostMapping("/list/edit")
    public String noticeEdit(@RequestParam("boardNo") int boardNo,
                            @RequestParam("boardSubject") String boardSubject,
                            @RequestParam("boardContent") String boardContent,
                            HttpSession session) {
        // 일반 로그인 세션에서 관리자 권한 확인
        MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
        if (loginMember == null || !"ADMIN".equals(loginMember.getMemType())) {
            return "redirect:/login";
        }
        
        Board notice = adminService.getPostDetail(boardNo);
        if (notice == null || !"공지".equals(notice.getBoardCategory())) {
            return "redirect:/admin/list";
        }
        
        adminService.updateNotice(boardNo, boardSubject, boardContent);
        return "redirect:/admin/list";
    }
    
    // 공지사항 삭제 확인
    @GetMapping("/list/delete")
    public String noticeDeleteConfirm(@RequestParam("no") int boardNo,
                                     HttpSession session, Model model) {
        // 일반 로그인 세션에서 관리자 권한 확인
        MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
        if (loginMember == null || !"ADMIN".equals(loginMember.getMemType())) {
            return "redirect:/login";
        }

        Board notice = adminService.getPostDetail(boardNo);
        if (notice == null || !"공지".equals(notice.getBoardCategory())) {
            return "redirect:/admin/list";
        }

        model.addAttribute("notice", notice);
        return "admin/delete";
    }
    
    // 공지사항 삭제 처리
    @PostMapping("/list/delete")
    public String noticeDelete(@RequestParam("boardNo") int boardNo,
                              HttpSession session) {
        // 일반 로그인 세션에서 관리자 권한 확인
        MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
        if (loginMember == null || !"ADMIN".equals(loginMember.getMemType())) {
            return "redirect:/login";
        }
        
        Board notice = adminService.getPostDetail(boardNo);
        if (notice == null || !"공지".equals(notice.getBoardCategory())) {
            return "redirect:/admin/list";
        }
        
        adminService.deleteNotice(boardNo);
        return "redirect:/admin/list";
    }
}

