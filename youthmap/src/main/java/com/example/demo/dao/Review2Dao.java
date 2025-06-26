// src/main/java/com/example/demo/dao/Review2Dao.java
package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.model.Review2Model;

@Mapper
public interface Review2Dao {

    /** 리뷰 등록 */
    void insertReview2(Review2Model review);

    /** 페이징된 리뷰 리스트 */
    List<Review2Model> review2List(
        @Param("con_id")    int conId,
        @Param("startRow") int startRow,
        @Param("endRow")   int endRow
    );

    /** 리뷰 수정 */
    int updateReview2(Review2Model review);

    /** 리뷰 삭제 */
    int deleteReview2(int review_id2);

    /** 단일 리뷰 조회 */
    Review2Model selectReview2(int review_id2);

    /** 총 리뷰 개수 */
    int countReview2(int conId);

    /** 첨부파일명 조회 */
    String selectFile2(int review_id2);

    /** 작성자 확인 */
    int checkReview2Author(Review2Model review);
}