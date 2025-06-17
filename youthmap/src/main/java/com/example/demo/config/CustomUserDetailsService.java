package com.example.demo.config;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.example.demo.model.MemberModel;
import com.example.demo.service.MemberService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {
    
    private final MemberService memberService;
    
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        System.out.println("=== CustomUserDetailsService.loadUserByUsername ===");
        System.out.println("요청된 username: " + username);
        
        MemberModel m = memberService.findByMemId(username);
        if (m == null || !"ACTIVE".equalsIgnoreCase(m.getMemStatus())) {
            System.out.println("사용자를 찾을 수 없거나 비활성 상태: " + username);
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);
        }
        
        System.out.println("찾은 회원: " + m.getMemId() + ", 상태: " + m.getMemStatus());
        System.out.println("비밀번호 길이: " + m.getMemPass().length());
        System.out.println("=== CustomUserDetailsService 완료 ===");
        
        return User.builder()
                   .username(m.getMemId())
                   .password(m.getMemPass())
                   .roles("USER")
                   .build();
    }
}
