package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;

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
                // 정책 관련 - 인증 없이 접근 가능
                "/policy/**", "/policyMain", "/policyContent", "/policyListJson",
                // 문화 관련 - 인증 없이 접근 가능
                "/culture/**", "/culturemain", "/exhibitionlist", "/exhibitioncont", 
                "/performancelist", "/performancecont", "/eventlist", "/eventcont", "/allList", "/miniList",
                // 맛집 관련 - 인증 없이 접근 가능
                "/res_main", "/restaurants", "/restaurantDetail", "/restaurantsearch", "/collectAll"
            ).permitAll()
            // 마이페이지 관련 - 인증 필요
            .requestMatchers("/mypage/**").authenticated()
            // 관리자 관련 - 인증 필요
            .requestMatchers("/admin/**").authenticated()
            // 글쓰기, 수정, 삭제, 댓글 등록/삭제 관련 - 인증 필요
            .requestMatchers("/boardwrite", "/boardupdateform", "/boardupdate", "/boarddelete", "/boarddeleteform", "/api/comments").authenticated()
            // 나머지 모든 요청은 인증 없이 접근 가능
            .anyRequest().permitAll()
        );

        // 2) 폼 로그인: 페이지와 처리 URL 모두 열어두기
        http.formLogin(form -> form
            .loginPage("/login")
            .loginProcessingUrl("/login")
            .usernameParameter("memId")
            .passwordParameter("memPass")
            .defaultSuccessUrl("/home", true) // true는 항상 defaultSuccessUrl로 이동
            .permitAll()
            .successHandler((request, response, authentication) -> {
                // 로그인 성공 처리
                String memId = authentication.getName();
                MemberModel member = memberService.findByMemId(memId);
                
                request.getSession().setAttribute("loginMember", member);
                request.getSession().setAttribute("memberNo", member.getMemNo());
                // ✅ 로그인 시간 기록 및 세션 유효 시간 설정 (30분)
                request.getSession().setMaxInactiveInterval(30 * 60); // 1800초
                request.getSession().setAttribute("loginStartTime", System.currentTimeMillis());

                System.out.println("=== 로그인 성공 핸들러 ===");
                System.out.println("세션에 loginStartTime: " + request.getSession().getAttribute("loginStartTime"));
                System.out.println("로그인한 사용자 타입: " + member.getMemType());
                
                // 관리자 계정이면 대시보드로, 일반 사용자는 홈으로 리다이렉트
                if ("ADMIN".equals(member.getMemType())) {
                    System.out.println("관리자 로그인 - 대시보드로 리다이렉트");
                    response.sendRedirect("/admin/dashboard");
                } else {
                    System.out.println("일반 사용자 로그인 - 홈으로 리다이렉트");
                    response.sendRedirect("/home");
                }
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
            .successHandler((request, response, authentication) -> {
                // OAuth2 로그인 성공 처리
                // CustomOAuth2UserService에서 이미 세션에 사용자 정보 저장됨
                MemberModel member = (MemberModel) request.getSession().getAttribute("loginMember");
                
                System.out.println("=== OAuth2 로그인 성공 핸들러 ===");
                System.out.println("로그인한 사용자 타입: " + member.getMemType());
                
                // 관리자 계정이면 대시보드로, 일반 사용자는 홈으로 리다이렉트
                if ("ADMIN".equals(member.getMemType())) {
                    System.out.println("OAuth2 관리자 로그인 - 대시보드로 리다이렉트");
                    response.sendRedirect("/admin/dashboard");
                } else {
                    System.out.println("OAuth2 일반 사용자 로그인 - 홈으로 리다이렉트");
                    response.sendRedirect("/home");
                }
            })
            .failureUrl("/login?error=true")
        );

     // 5) 로그아웃
        http.logout(logout -> logout
            .logoutUrl("/logout")
            .logoutSuccessHandler(new SimpleUrlLogoutSuccessHandler() {{
                // 로그아웃 직전 Referer URL로 돌려보냄
                setUseReferer(true);
            }})
            .invalidateHttpSession(true)
            .deleteCookies("JSESSIONID")
            .permitAll()
        );

        // 6) 세션 관리 설정
        http.sessionManagement(session -> session
            .maximumSessions(1) // 동시 로그인 제한
            .expiredUrl("/login?error=expired")
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