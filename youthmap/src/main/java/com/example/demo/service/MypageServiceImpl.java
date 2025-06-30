	package com.example.demo.service;
	
	import java.util.List;
	import java.util.Map;
	import java.util.HashMap;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;

import com.example.demo.dao.MemberDao;
import com.example.demo.dao.BoardDao;
import com.example.demo.dao.CommentDao;
import com.example.demo.model.MemberModel;
import com.example.demo.model.Board;
import com.example.demo.model.Comment;
	
	@Service
	public class MypageServiceImpl implements MypageService {
		
		@Autowired
		private MemberDao memberMapper;
		
		@Autowired
		private BoardDao boardDao;
		
		@Autowired
		private CommentDao commentDao;
		
		
		// 회원의 이름, 메일, 주소,가입일등 조
		@Override
		public MemberModel getMemberInfo(Long memNo) {
			return memberMapper.selectMemberInfo(memNo);
		}
		
		// 회원이 작성한 게시글 수 조회
		@Override
		public int getPostCount(Long memNo) {
			return memberMapper.countPostsByMember(memNo);
			
		}
		
		// 회원이 작성 댓굴 수 조회
		@Override
		public int getCommentCount(Long memNo) {
			return memberMapper.countCommentsByMember(memNo);
		}
		
		// 내 게시물 조회 (페이징)
		@Override
		public List<Board> getMyPosts(Long memNo, int page, int limit) {
			int startRow = (page - 1) * limit + 1;
			int endRow = page * limit;
			
			Map<String, Object> params = new HashMap<>();
			params.put("memNo", memNo);
			params.put("startRow", startRow);
			params.put("endRow", endRow);
			
			return boardDao.getMyPosts(params);
		}
		
		// 내 댓글 조회 (페이징)
		@Override
		public List<Comment> getMyComments(Long memNo, int page, int limit) {
			int startRow = (page - 1) * limit + 1;
			int endRow = page * limit;
			
			Map<String, Object> params = new HashMap<>();
			params.put("memNo", memNo);
			params.put("startRow", startRow);
			params.put("endRow", endRow);
			
			return commentDao.getMyComments(params);
		}
	
	}
