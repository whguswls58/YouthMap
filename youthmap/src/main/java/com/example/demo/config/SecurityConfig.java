package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import com.example.demo.model.MemberModel;
import com.example.demo.service.MemberService;

import jakarta.servlet.DispatcherType;
import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig {

    private final CustomOAuth2UserService  oauth2UserService;
    private final CustomUserDetailsService userDetailsService;
    private final MemberService memberService;

    // 평문 비밀번호를 위한 PasswordEncoder Bean
    @Bean
    public PasswordEncoder passwordEncoder() {
        return NoOpPasswordEncoder.getInstance();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    	// 1) 내부 포워드된 뷰(JSP) 요청과 에러 요청도 모두 열어두기
        http.authorizeHttpRequests(auth -> auth
            .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll()
            .requestMatchers(
                "/", "/home",
                "/login", "/login?error=true", "/login?logout",
                "/register", "/register-success",
                "/check-id",
                "/css/**", "/js/**", "/images/**", "/img/**",
                // 게시판 조회 관련 - 인증 없이 접근 가능
                "/board", "/boardlist", "/boardview",
                // 댓글 목록 조회 - 인증 없이 접근 가능
                "/api/comments/*",
                // 정책, 문화, 맛집 관련 - 인증 없이 접근 가능
                "/policy/**", "/culture/**", "/food/**"
            ).permitAll()
            // 글쓰기, 수정, 삭제, 댓글 등록/삭제 관련 - 인증 필요
            .requestMatchers("/boardwrite", "/boardupdateform", "/boardupdate", "/boarddelete", "/boarddeleteform", "/api/comments").authenticated()
            .anyRequest().authenticated()
        );

        // 2) 폼 로그인: 페이지와 처리 URL 모두 열어두기
        http.formLogin(form -> form
            .loginPage("/login")
            .loginProcessingUrl("/login")
            .usernameParameter("memId")
            .passwordParameter("memPass")
            .permitAll()
            .successHandler((req, res, auth) -> {
                // 로그인 성공 처리
                String memId = auth.getName();
                MemberModel member = memberService.findByMemId(memId);
                
                // 디버깅: 로그인 성공 후 memType 확인
                System.out.println("=== 로그인 성공 핸들러 ===");
                System.out.println("로그인 성공 - memId: " + memId + ", memType: " + member.getMemType());
                System.out.println("세션 ID: " + req.getSession().getId());
                
                req.getSession().setAttribute("loginMember", member);
                req.getSession().setAttribute("memberNo", member.getMemNo());
                
                System.out.println("세션에 저장된 loginMember: " + req.getSession().getAttribute("loginMember"));
                System.out.println("세션에 저장된 memberNo: " + req.getSession().getAttribute("memberNo"));
                System.out.println("=== 로그인 성공 핸들러 완료 ===");
                
                // 이전 페이지로 리다이렉트 (기본값은 /home)
                String targetUrl = req.getSession().getAttribute("SPRING_SECURITY_SAVED_REQUEST") != null ? 
                    "/boardlist" : "/home";
                res.sendRedirect(targetUrl);
            })
            .failureUrl("/login?error=true")
        );

        // 3) 인증 실패 시 처리
        http.exceptionHandling(ex -> ex
            .authenticationEntryPoint((request, response, authException) -> {
                System.out.println("=== 인증 실패 ===");
                System.out.println("요청 URL: " + request.getRequestURI());
                System.out.println("인증 예외: " + authException.getMessage());
                response.sendRedirect("/login?error=unauthorized");
            })
        );

        // 4) OAuth2 로그인
        http.oauth2Login(oauth2 -> oauth2
            .loginPage("/login")
            .userInfoEndpoint(u -> u.userService(oauth2UserService))
            .defaultSuccessUrl("/home", true)
            .failureUrl("/login?error=true")
        );

        // 5) 로그아웃
        http.logout(logout -> logout
            .logoutUrl("/logout")
            .logoutSuccessUrl("/login?logout")
            .permitAll()
        );

        // 6) 세션 관리 설정
        http.sessionManagement(session -> session
            .maximumSessions(1)  // 동일 사용자의 최대 세션 수
            .maxSessionsPreventsLogin(false)  // 기존 세션 무효화
        );

        // 7) 평문 비밀번호 비교용 Provider
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());
        http.authenticationProvider(authProvider);

        // CSRF는 필요시 켜 주세요
        http.csrf(csrf -> csrf.disable());

        return http.build();
    }
}