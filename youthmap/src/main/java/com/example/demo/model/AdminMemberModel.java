package com.example.demo.model;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AdminMemberModel {

    private Long memNo;         // 회원 고유번호
    private String memId;       // 회원 아이디
    private String memName;     // 회원 이름
    private String memStatus;   // 회원 상태 (정상, 정지, 탈퇴 등)
    private LocalDate memDate;     // 가입일

    private int postCount;      // 작성한 게시물 수
    private int commentCount;   // 작성한 댓글 수
    private String banReason;   // 정지 사유
}
