package com.example.demo.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dao.PolicyDao;


@Service
public class PolicyService {
	
	private PolicyDao dao;
	
	// api에 요청하여 json 데이터 받아옴
	public String getYouthPolicies(@RequestParam("pageNum") int pageNum, @RequestParam("size") int pageSize) {
        
		String apiKey = "ec807d36-bd03-4e9d-92bd-20eec0f42d73";								// 인증키
		String apiUrl = "https://www.youthcenter.go.kr/go/ythip/getPlcy";					// api url
        String params = "?apiKeyNm=" + apiKey + "&pageNum=" + pageNum + "&pageSize="+ pageSize +"&rtnType=json";		// api 요청값
        
        try {
            URL url = new URL(apiUrl + params);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "UTF-8"));

            StringBuilder response = new StringBuilder();
            String line;
            while((line = reader.readLine()) != null) {
                response.append(line);
            }
            reader.close();

            return response.toString();

        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
	
}
