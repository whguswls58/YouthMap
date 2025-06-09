package com.example.demo.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.springframework.stereotype.Service;

import com.example.demo.dao.PolicyDao;


@Service
public class PolicyService {
	
	private PolicyDao dao;
	
	
	public String getYouthPolicies() {
        
		String apiKey = "ec807d36-bd03-4e9d-92bd-20eec0f42d73";								// 인증키
		String apiUrl = "https://www.youthcenter.go.kr/go/ythip/getPlcy";					// api url
        String params = "?apiKeyNm=" + apiKey + "&pageNum=1&pageSize=10&rtnType=json";		// api 요청값
        // 요청 pageNum, pageSize 어떻게 처리해서 모든 데이터를 받아올 것인지?
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
