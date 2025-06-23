package com.example.demo.model;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("comment")
public class Comment {
    private int commNo;          // 댓글 번호 (PK)
    private int boardNo;         // 게시글 번호 (FK)
    private String memId;        // 작성자 ID
    private String memName;      // 작성자 이름
    private String commContent;  // 댓글 내용
    private Date commDate;       // 작성 날짜
    private Date commUpdate;     // 수정 날짜 (수정 시 사용)
    private Long memNo;          // 회원 번호 (MemberModel과 일관성)

    private String boardSubject; // 게시글 제목 (마이페이지 내 댓글용)
}