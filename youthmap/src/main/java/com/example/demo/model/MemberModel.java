package com.example.demo.model;

import lombok.Data;
import java.time.LocalDate;

@Data
public class MemberModel {
    private Long memNo;             
    private String memId;           
    private String memPass;         
    private String memName;         
    private LocalDate birthDate;   
    private String memGen;          
    private String memMail;          
    private String memAddress;       
    private String memAddDetail;   
    private LocalDate memDate;       
    private String memStatus;
    
    private String memType;
    private String oauthId;
    private String memNum;          // 핸드폰번호
}
