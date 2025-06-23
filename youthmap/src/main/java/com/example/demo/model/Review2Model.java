package com.example.demo.model;

import java.sql.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("Review2")
public class Review2Model {

	private int review_id2;
    private int review_score2;
    private String review_content2;
    private String review_file2;
    private Date review_register2;
    private int mem_no;
    private int con_id;  //(컨텐츠 PK 맞추기)
    
    //임시
    private String review_writer2; 
}
