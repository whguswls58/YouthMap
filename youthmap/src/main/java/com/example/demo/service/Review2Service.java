package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dao.Review2Dao;
import com.example.demo.model.Review2Model;

@Service
public class Review2Service {

    @Autowired
    private Review2Dao dao;

    /** 리뷰 등록 */
    public void insertReview2(Review2Model review2) {
        dao.insertReview2(review2);
    }

    /** 페이징된 리뷰 리스트 조회 */
    public List<Review2Model> review2List(int con_id, int startRow, int endRow) {
        return dao.review2List(con_id, startRow, endRow);
    }

    /** 리뷰 수정 */
    public int updateReview2(Review2Model review2) {
        return dao.updateReview2(review2);
    }

    /** 리뷰 삭제 */
    public int deleteReview2(int review_id2) {
        return dao.deleteReview2(review_id2);
    }

    /** 단일 리뷰 조회 (수정 폼용) */
    public Review2Model selectReview2(int review_id2) {
        return dao.selectReview2(review_id2);
    }

    /** 총 리뷰 개수 (페이징 계산용) */
    public int countReview2(int con_id) {
        return dao.countReview2(con_id);
    }

    /** 첨부파일명 조회 (삭제 시 파일 지우기용) */
    public String selectFile2(int review_id2) {
        return dao.selectFile2(review_id2);
    }
}