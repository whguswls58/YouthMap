package com.example.demo.model;

import java.sql.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("board")
public class Board {
    private int boardNo;
    private String memId;
    private String boardCategory;
    private String boardSubject;
    private String boardContent;
    private int boardReadcount;
    private Date boardDate;
    private int memNo;
    private int rnum;
}
