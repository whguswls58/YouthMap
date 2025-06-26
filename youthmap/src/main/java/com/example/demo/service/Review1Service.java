package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dao.Review1Dao;
import com.example.demo.model.Review1;

@Service
public class Review1Service {
	
	@Autowired
	private Review1Dao dao;

	public void insertreview(Review1 review) {
		dao.insertreview(review);
	}


	public List<Review1> reviewlist(String res_id, int startRow, int endRow) {
	    return dao.reviewlist(res_id,startRow,endRow);

	}

	public int updatereview(Review1 review) {
		return dao.updatereview(review);
		
	}

	public int deletereview(Review1 review) {
		return dao.deletereview(review.getReview_id1());
	}

	// 작성자 확인
	public int checkReviewAuthor(Review1 review) {
		return dao.checkReviewAuthor(review);
	}

	public Review1 selectreview(int review_id1) {

	return dao.selectreview(review_id1);
			}


	public int countreview(String resId) {
		return dao.countreview(resId);
	}


	public String reviewfile(int review_id1) {
		return dao.reviewfile(review_id1);
	}
	
		
	
	

}

   

