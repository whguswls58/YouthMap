package com.example.demo.model;

import java.util.List;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("restaurant")
public class Restaurant {

	private String res_id;           // Google place_id
	private String res_subject;      // 식당 이름
	private String res_tel;          // 전화번호
	private double res_score;           // 평균 평점

	private String res_address;      // 주소
	private Double res_latitude;         // 위도
	private Double res_longitude;        // 경도

	private int res_user_ratings_total;    // 총 리뷰 수
	private int res_price_level;      // 가격대

	private String res_open;         // 현재 영업 여부 ("true" / "false")
	private String res_open_hours;    // 요일별 영업시간 텍스트

	private String res_file;         // 대표 photo_reference
	private String res_photo_url;     // 대표 사진 URL
	private String res_photo_urls;        // DB 매핑용 (콤마로 저장)
	private List<String> res_photoUrls; // 추가 사진 리스트

	private String res_mapUrl;       // Google 지도 URL
	private String res_content;      // 설명 or 메뉴 정보 (수동 입력)

	// ✅ 추가 추천
	private String res_status;       // 영업 상태 (business_status)
	private String res_website;      // 공식 웹사이트
	private String res_gu;        	 // 지역구
	
	// 검색
	private String keyword;
	 private Double distance;

	private int startRow;
	private int endRow;
}
