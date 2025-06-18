package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;
import com.example.demo.dao.RestaurantDao;
import com.example.demo.model.Restaurant;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class RestaurantService {

    private final RestaurantDao dao;  // 생성자 주입

    public void saveRestaurant(Restaurant r) { // 그냥 저장
        dao.saveRestaurant(r);
    }
    
    // 중복 체크 후 저장
    public boolean saveRestaurantIfNotExists(Restaurant restaurant) {
        System.out.println("중복체크: " + restaurant.getRes_id());
        Restaurant existing = dao.selectById(restaurant.getRes_id());
        System.out.println("DB에 이미 있는지? " + (existing != null));
        if (existing == null) {
            dao.saveRestaurant(restaurant);
            System.out.println("저장됨!");
            return true;
        } else {
            System.out.println("이미 존재 - 저장 안함");   
            return false;
        }
    }
    
    public int count(Restaurant restaurant) {
        return dao.count(restaurant);
    }

    public List<Restaurant> list(Restaurant restaurant) {
        return dao.list(restaurant);
    }


	public Restaurant selectById(String resId) {
		return dao.selectById(resId);
	}

	public List<Restaurant> best() {
		return dao.best();
	}

	public List<Restaurant> findNearby(Map<String, Object> param) {
		return dao.findNearby(param);
	}

	public List<Restaurant> maplist() {
		return dao.maplist();
	}

	public void updatephotourls( String res_id, String res_photo_urls) {
		dao.updatephotourls(res_id, res_photo_urls);
	}
    

}
