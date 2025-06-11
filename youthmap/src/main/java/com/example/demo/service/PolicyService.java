package com.example.demo.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dao.PolicyDao;
import com.example.demo.model.PolicyModel;

@Service
public class PolicyService {

	@Autowired
	private PolicyDao dao;

	@Autowired
	private SqlSessionFactory sqlSessionFactory;

	// api에 요청하여 json 데이터 받아옴
	public String getYouthPolicies(@RequestParam("pageNum") int pageNum, @RequestParam("size") int pageSize) {

		String apiKey = "ec807d36-bd03-4e9d-92bd-20eec0f42d73"; // 인증키
		String apiUrl = "https://www.youthcenter.go.kr/go/ythip/getPlcy"; // api url
		String params = "?apiKeyNm=" + apiKey + "&pageNum=" + pageNum + "&pageSize=" + pageSize + "&rtnType=json"; // api
																													// 요청값

		try {
			URL url = new URL(apiUrl + params);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");

			BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));

			StringBuilder response = new StringBuilder();
			String line;
			while ((line = reader.readLine()) != null) {
				response.append(line);
			}
			reader.close();

			return response.toString();

		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}

	// DB에 저장된 총 데이터 수
	public int cntData() {
		return dao.cntData();
	}

	// 마지막 업데이트 일
	public Date lastUpdate() {
		return dao.lastUpdate();
	}

	// DB에 저장되어 있는 모든 plcy_no 리스트
	public List<String> plcyNoList() {
		return dao.plcyNoList();
	}

	// 정책 정보 insert 수행
	public int insertPolicy(PolicyModel pm) {
		return dao.insertPolicy(pm);
	}

	// 정책 리스트 검색
	public List<PolicyModel> plcyList() {
		return dao.plcyList();
	}

}
