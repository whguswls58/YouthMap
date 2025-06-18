package com.example.demo.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.model.Restaurant;

@Mapper
public interface RestaurantDao {
	void saveRestaurant(Restaurant restaurant);
	
    Restaurant selectById(String res_id);
    
    int count(Restaurant restaurant);
    List<Restaurant> list(Restaurant restaurant);

	Restaurant findById(String resId);

	List<Restaurant> best();

	List<Restaurant> findNearby(Map<String, Object> param);

	List<Restaurant> maplist();

	void updatephotourls(@Param("res_id") String res_id, @Param("res_photo_urls")String res_photo_urls);

    

}
