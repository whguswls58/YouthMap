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
        MemberModel m = memberService.findByMemId(username);
        if (m == null || !"ACTIVE".equalsIgnoreCase(m.getMemStatus())) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);
        }
        return User.builder()
                   .username(m.getMemId())
                   .password(m.getMemPass())
                   .roles("USER")
                   .build();
    }
}
