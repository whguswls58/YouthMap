package com.example.demo.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.model.Restaurant;

@Mapper
public interface RestaurantDao {
	
	void saveRestaurant(Restaurant restaurant);
	

// CRUD
int saveres(Restaurant r);            // 저장 (INSERT)
int updateres(Restaurant r);          // 수정 (UPDATE)
Restaurant selectById(String res_id); // 단건 조회(중복 체크용)

/** 별점순 페이징+검색 */
List<Restaurant> listByScore(Restaurant restaurant);

/** 가나다순 페이징+검색 */
List<Restaurant> listByName(Restaurant restaurant);

// 검색/리스트/기타
int count(Restaurant restaurant);     // 전체/조건 건수
List<Restaurant> list(Restaurant restaurant); // 조건+페이징 리스트
List<Restaurant> best();              // BEST 4개
List<Restaurant> findNearby(Map<String, Object> param); // 반경 내 검색
List<Restaurant> maplist();           // 전체 리스트(지도용)
void updatephotourls(
    @Param("res_id") String res_id, 
    @Param("res_photo_urls") String res_photo_urls
);
}