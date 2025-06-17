	package com.example.demo.service;
	
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	
	import com.example.demo.mapper.MemberMapper;
	import com.example.demo.model.MemberModel;
	
	@Service
	public class MypageServiceImpl implements MypageService {
		
		@Autowired
		private MemberMapper memberMapper;
		
		
		// 회원의 이름, 메일, 주소,가입일등 조
		@Override
		public MemberModel getMemberInfo(Long memNo) {
			return memberMapper.selectMemberInfo(memNo);
		}
		
		// 회원이 작성한 게시글 수 조
		@Override
		public int getPostCount(Long memNo) {
			return memberMapper.countPostsByMember(memNo);
			
		}
		
		// 회원이 작성 댓굴 수 조
		@Override
		public int getCommentCount(Long memNo) {
			return memberMapper.countCommentsByMember(memNo);
		}
	
	}
