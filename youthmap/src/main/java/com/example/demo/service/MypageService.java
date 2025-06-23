package com.example.demo.service;

import java.util.List;
import com.example.demo.model.MemberModel;
import com.example.demo.model.Board;
import com.example.demo.model.Comment;

public interface MypageService {
	MemberModel getMemberInfo(Long memNo);
	int getPostCount(Long memNo);
	int getCommentCount(Long memNo);
	
	// 내 게시물 조회
	List<Board> getMyPosts(Long memNo, int page, int limit);
	
	// 내 댓글 조회
	List<Comment> getMyComments(Long memNo, int page, int limit);
}
