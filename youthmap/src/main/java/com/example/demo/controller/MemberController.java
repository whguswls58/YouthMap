package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.model.MemberModel;
import com.example.demo.service.MemberService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MemberController {

	private final MemberService memberService;

	// 회원가입 페이지
	@GetMapping("/register")
	public String showRegisterForm() {
		return "member/register";
	}

	@GetMapping("/check-id")
	@ResponseBody
	public boolean checkIdDuplicate(@RequestParam("memId") String memId) {
	    // 디버깅: 중복검사 요청 확인
	    System.out.println("아이디 중복검사 요청: " + memId);
	    
	    // 데이터베이스에 실제로 해당 아이디가 있는지 확인
	    MemberModel existingMember = memberService.findByMemId(memId);
	    System.out.println("DB에서 조회된 회원: " + (existingMember != null ? existingMember.getMemId() : "null"));
	    
	    // 중복이면 true, 사용가능하면 false 반환
	    boolean result = memberService.isIdDuplicate(memId);
	    System.out.println("중복검사 결과: " + result + " (true=중복, false=사용가능)");
	    
	    return result;
	}


	@PostMapping("/register")
	public String register(@RequestParam("emailId") String emailId, @RequestParam("emailDomain") String emailDomain,
		  @RequestParam("phonePrefix") String phonePrefix, @RequestParam("phoneMiddle") String phoneMiddle, 
		  @RequestParam("phoneLast") String phoneLast, @ModelAttribute MemberModel member, Model model) {
 
	   // 아이디 중복 체크
	   if (memberService.isIdDuplicate(member.getMemId())) {
		  model.addAttribute("error", "이미 존재하는 아이디입니다.");
		  return "member/register";
	   }
 
	   // 이메일 조합해서 저장
	   String fullEmail = emailId + "@" + emailDomain;
	   member.setMemMail(fullEmail);
 
	   // 핸드폰번호 조합해서 저장
	   String fullPhone = phonePrefix + "-" + phoneMiddle + "-" + phoneLast;
	   member.setMemNum(fullPhone);
 
	   // 일반 회원가입이므로 memType을 LOCAL로 설정
	   member.setMemType("LOCAL");
	   
	   // 디버깅: memType 설정 확인
	   System.out.println("회원가입 - 설정된 memType: " + member.getMemType());
 
	   // 회원가입 처리
	   memberService.register(member);
 
	   // 가입 성공 메시지 전달
	   return "redirect:/register-success";
	}
 
	@GetMapping("/register-success")
	public String registerSuccess() {
	   return "member/register-success";
	}

	// 로그인 페이지
	@GetMapping("/login")
	public String showLoginForm(@RequestParam(value = "error", required = false) String error,
	                           Model model) {
		if (error != null) {
			model.addAttribute("error", "로그인이 필요합니다.");
		}
		return "member/login";
	}

	// 로그인 처리
	/*
	 * @PostMapping("/login") public String login(@RequestParam("memId") String
	 * memId, @RequestParam("memPass") String memPass, HttpSession session, Model
	 * model) { MemberModel member = memberService.findByMemId(memId);
	 * 
	 * if (member != null && "ACTIVE".equalsIgnoreCase(member.getMemStatus()) &&
	 * memPass.equals(member.getMemPass())) {
	 * 
	 * // 로그인 성공 시 세션에 두 가지 저장 session.setAttribute("loginMember", member); // 전체 정보
	 * session.setAttribute("memberNo", member.getMemNo()); // 마이페이지 조회용
	 * 
	 * return "redirect:/home"; }
	 * 
	 * model.addAttribute("error", "아이디 또는 비밀번호가 틀렸습니다."); return "member/login"; }
	 */

	// 로그아웃 처리
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/login?logout";
	}

	// 회원정보 수정
	@GetMapping("/edit")
	public String showEditForm(HttpSession session, Model model) {
		MemberModel member = (MemberModel) session.getAttribute("loginMember");

		// 로그인 안 한 경우
		if (member == null) {
			return "redirect:/login";
		}

		// 소셜 로그인 회원이면 수정 차단 (GOOGLE, NAVER 등)
		if (member.getMemType() != null && !"LOCAL".equals(member.getMemType())) {
			return "redirect:/mypage?error=socialUserCannotEdit";
		}

		model.addAttribute("member", member);
		return "member/edit";
	}

	// 회원정보 수정 처리
	@PostMapping("/edit")
	public String updateMemberInfo(@RequestParam("currentPass") String currentPass,
			@RequestParam(value = "newPass", required = false) String newPass, @RequestParam("memMail") String memMail,
			@RequestParam("memAddress") String memAddress, @RequestParam("memAddDetail") String memAddDetail,
			@RequestParam("phonePrefix") String phonePrefix, @RequestParam("phoneMiddle") String phoneMiddle, 
			@RequestParam("phoneLast") String phoneLast, HttpSession session, Model model) {

		MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");

		if (loginMember == null) {
			return "redirect:/login";
		}

		// 소셜 로그인 회원이면 수정 차단 (GOOGLE, NAVER 등)
		if (loginMember.getMemType() != null && !"LOCAL".equals(loginMember.getMemType())) {
			return "redirect:/mypage?error=socialUserCannotEdit";
		}

		// 비밀번호 검증
		if (!currentPass.equals(loginMember.getMemPass())) {
			model.addAttribute("error", "비밀번호가 틀립니다.");
			model.addAttribute("member", loginMember);
			return "member/edit";
		}

		// 변경된 값 설정
		if (newPass != null && !newPass.isEmpty()) {
			loginMember.setMemPass(newPass);
		}
		loginMember.setMemMail(memMail);
		loginMember.setMemAddress(memAddress);
		loginMember.setMemAddDetail(memAddDetail);

		// 핸드폰번호 조합해서 저장
		String fullPhone = phonePrefix + "-" + phoneMiddle + "-" + phoneLast;
		loginMember.setMemNum(fullPhone);

		// DB 업데이트
		memberService.updateMember(loginMember);

		// 세션 갱신
		session.setAttribute("loginMember", loginMember);

		return "redirect:/mypage";
	}

	// 회원 탈퇴
	@PostMapping("/withdraw")
	public String withdrawMember(HttpSession session) {
		MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");

		if (loginMember == null) {
			return "redirect:/login";
		}

		// 상태값 변경
		loginMember.setMemStatus("WITHDRAWN");

		// DB 반영
		memberService.updateMemberStatus(loginMember);

		// 세션 초기화
		session.invalidate();

		return "redirect:/home?withdrawSuccess=true"; // 메인 페이지로 이동
	}
	
	@GetMapping("/edit_pass")
	public String showChangePasswordPage(Model model, HttpSession session) {
	    MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
	    
	    // 로그인 체크
	    if (loginMember == null) {
	        return "redirect:/login";
	    }
	    
	    // 소셜 로그인 회원이면 수정 차단
	    if (loginMember.getMemType() != null && !"LOCAL".equals(loginMember.getMemType())) {
	        return "redirect:/mypage?error=socialUserCannotEdit";
	    }
	    
	    model.addAttribute("member", loginMember);
	    return "member/edit_pass";
	}

	// 비밀번호 변경 처리
	@PostMapping("/edit_pass")
	public String changePassword(@RequestParam("currentPassword") String currentPass,
	                            @RequestParam("newPassword") String newPass,
	                            @RequestParam("confirmPassword") String confirmPass,
	                            HttpSession session, Model model) {
	    
	    MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
	    
	    // 로그인 체크
	    if (loginMember == null) {
	        return "redirect:/login";
	    }
	    
	    // 소셜 로그인 회원이면 수정 차단
	    if (loginMember.getMemType() != null && !"LOCAL".equals(loginMember.getMemType())) {
	        return "redirect:/mypage?error=socialUserCannotEdit";
	    }
	    
	    // 현재 비밀번호 검증
	    if (!currentPass.equals(loginMember.getMemPass())) {
	        model.addAttribute("error", "현재 비밀번호가 틀렸습니다.");
	        model.addAttribute("member", loginMember);
	        return "member/edit_pass";
	    }
	    
	    // 새 비밀번호와 확인 비밀번호 일치 검증
	    if (!newPass.equals(confirmPass)) {
	        model.addAttribute("error", "새 비밀번호와 확인 비밀번호가 일치하지 않습니다.");
	        model.addAttribute("member", loginMember);
	        return "member/edit_pass";
	    }
	    
	    // 새 비밀번호가 현재 비밀번호와 같은지 검증
	    if (currentPass.equals(newPass)) {
	        model.addAttribute("error", "새 비밀번호는 현재 비밀번호와 달라야 합니다.");
	        model.addAttribute("member", loginMember);
	        return "member/edit_pass";
	    }
	    
	    // 비밀번호 변경
	    loginMember.setMemPass(newPass);
	    memberService.updateMember(loginMember);
	    
	    // 세션 갱신
	    session.setAttribute("loginMember", loginMember);
	    
	    // 성공 메시지와 함께 edit_pass 페이지로 리다이렉트
	    return "redirect:/edit_pass?success=passwordChanged";
	}

}