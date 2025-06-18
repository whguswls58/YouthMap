package com.example.demo.model;
import lombok.Data;
import java.util.Date;

import org.apache.ibatis.type.Alias;

@Data
@Alias("review1")
public class Review1 {
    private int review_id1;
    private int review_score1;
    private String review_content1;
    private String review_file1;
    private Date review_register1;
    private int mem_no;
    private String res_id;  //(식당PK 맞추기)
    
    //임시
    private String review_writer; 
}