package com.example.demo.model;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("userFile")
public class UserFile {
    private int userFileNo;       // 첨부파일 번호 (PK)
    private int boardNo;          // 게시글 번호 (FK)
    private String userFileName;  // 실제 파일 이름
    private String userFilPath;   // 저장된 파일 경로 (또는 저장된 이름)
}