package com.example.demo.service;

import com.example.demo.model.MemberModel;

public interface MypageService {
	MemberModel getMemberInfo(Long memNo);
	int getPostCount(Long memNo);
	int getCommentCount(Long memNo);
	

}
