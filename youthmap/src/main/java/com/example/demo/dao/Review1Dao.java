package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.model.Review1;

@Mapper
public interface Review1Dao {

	void insertreview(Review1 review);

	List<Review1> reviewlist(@Param("res_id") String resId, @Param("startRow") int startRow, @Param("endRow") int endRow);
	

    int updatereview(Review1 review);
    int deletereview(int review_id1);

	Review1 selectreview(int review_id1);

	int countreview(String resId);

	String reviewfile(int review_id1);

}
