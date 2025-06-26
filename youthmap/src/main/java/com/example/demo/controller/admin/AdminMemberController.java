package com.example.demo.controller.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.model.AdminMemberModel;
import com.example.demo.model.MemberModel;
import com.example.demo.service.AdminService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminMemberController {

    private final AdminService adminService;

    @GetMapping("/users")
    public String memberList(HttpSession session, Model model,
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
        
        // 페이징 파라미터 설정
        Map<String, Object> params = new HashMap<>();
        params.put("startRow", startRow);
        params.put("endRow", endRow);
        params.put("search", search);
        
        // 회원 목록 조회
        List<AdminMemberModel> members = adminService.getMembersWithPaging(params);
        
        // 전체 회원 수 조회 (검색 조건 적용)
        int totalMembers = adminService.getMemberCountWithSearch(search);
        int totalPages = (int) Math.ceil((double) totalMembers / limit);
        
        // 페이징 범위 계산
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);
        
        model.addAttribute("members", members);
        model.addAttribute("page", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("search", search);

        return "admin/users";
    }
}
