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

    // BCrypt 암호화를 위한 PasswordEncoder Bean
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
                "/css/**", "/js/**", "/images/**"
            ).permitAll()
            .anyRequest().authenticated()
        );

        // 2) 폼 로그인: 페이지와 처리 URL 모두 열어두기
        http.formLogin(form -> form
            .loginPage("/login")
            .loginProcessingUrl("/login")
            .usernameParameter("memId")
            .passwordParameter("memPass")
            .permitAll()    // ← 이 한 줄이 핵심입니다
            .successHandler((req, res, auth) -> {
                // 로그인 성공 처리
                String memId = auth.getName();
                MemberModel member = memberService.findByMemId(memId);
                
                // 디버깅: 로그인 성공 후 memType 확인
                System.out.println("로그인 성공 - memId: " + memId + ", memType: " + member.getMemType());
                
                req.getSession().setAttribute("loginMember", member);
                req.getSession().setAttribute("memberNo", member.getMemNo());
                res.sendRedirect("/home");
            })
            .failureUrl("/login?error=true")
        );

        // 3) OAuth2 로그인
        http.oauth2Login(oauth2 -> oauth2
            .loginPage("/login")
            .userInfoEndpoint(u -> u.userService(oauth2UserService))
            .defaultSuccessUrl("/home", true)
            .failureUrl("/login?error=true")
        );

        // 4) 로그아웃
        http.logout(logout -> logout
            .logoutUrl("/logout")
            .logoutSuccessUrl("/login?logout")
            .permitAll()
        );

        // 5) 평문 비밀번호 비교용 Provider
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(new PasswordEncoder() {
            @Override
            public String encode(CharSequence rawPassword) {
                return passwordEncoder().encode(rawPassword);
            }

            @Override
            public boolean matches(CharSequence rawPassword, String encodedPassword) {
                System.out.println("=== PasswordEncoder.matches ===");
                System.out.println("입력된 비밀번호: " + rawPassword);
                System.out.println("저장된 비밀번호 길이: " + encodedPassword.length());
                
                // 평문 비밀번호인지 확인 (길이가 60자 미만이면 평문으로 간주)
                if (encodedPassword.length() < 60) {
                    System.out.println("평문 비밀번호 비교");
                    boolean result = rawPassword.toString().equals(encodedPassword);
                    System.out.println("평문 비교 결과: " + result);
                    return result;
                } else {
                    System.out.println("암호화된 비밀번호 BCrypt 비교");
                    boolean result = passwordEncoder().matches(rawPassword, encodedPassword);
                    System.out.println("BCrypt 비교 결과: " + result);
                    return result;
                }
            }
        });
        http.authenticationProvider(authProvider);

        // CSRF는 필요시 켜 주세요
        http.csrf(csrf -> csrf.disable());

        return http.build();
    }
}