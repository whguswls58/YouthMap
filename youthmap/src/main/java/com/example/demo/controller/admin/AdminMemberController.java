package com.example.demo.controller.admin;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.model.AdminMemberModel;
import com.example.demo.service.AdminService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminMemberController {

    private final AdminService adminService;

    @GetMapping("/users")
    public String memberList(HttpSession session, Model model) {
        if (session.getAttribute("adminLogin") == null) {
            return "redirect:/admin/login";
        }

        List<AdminMemberModel> members = adminService.getAllMemberSummary();
        model.addAttribute("members", members);

        return "admin/users";
    }
}
