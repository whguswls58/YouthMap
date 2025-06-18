package com.example.demo.service;

import java.io.BufferedReader;

import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.example.demo.dao.CultureDao;
import com.example.demo.model.CultureModel;


@Service
public class CultureService {
	@Value("${culture.api.key}")
	private String apiKey;								// 인증키
	
	@Autowired
	private CultureDao dao;
	
	
	public String getYouthCulture() {
        
		System.out.println("apiKey:"+ apiKey);
		
		String apiKey = "786549546a616e6d3838774f786443";								// 인증키
		String apiUrl = "http://openapi.seoul.go.kr:8088/" + apiKey + "/json/culturalEventInfo/1/1000";	//여기까지함				// api url
	//	String apiUrl = "http://openapi.seoul.go.kr:8088/" + apiKey + "/json/culturalEventInfo/1001/2000";					// api url
//여기까지만	String apiUrl = "http://openapi.seoul.go.kr:8088/" + apiKey + "/json/culturalEventInfo/2001/3000";					// api url
	
// 아래부턴 db에 저장 x		
		//	String apiUrl = "http://openapi.seoul.go.kr:8088/" + apiKey + "/json/culturalEventInfo/3001/4000";					// api url
//		String apiUrl = "http://openapi.seoul.go.kr:8088/" + apiKey + "/json/culturalEventInfo/4001/5000";					// api url
		//String apiUrl = "http://openapi.seoul.go.kr:8088/" + apiKey + "/json/culturalEventInfo/5001/6000";					// api url
     //   String params = "?apiKeyNm=" + apiKey + "&pageNum=1&pageSize=10&rtnType=json";		// api 요청값
        // 요청 pageNum, pageSize 어떻게 처리해서 모든 데이터를 받아올 것인지?
        try {
            URL url = new URL(apiUrl);
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


	public int culinsert(CultureModel culMd) {
		return dao.culinsert(culMd);
	}
	public List<CultureModel> getperformance() {
		return dao.getperformance();
	}
	public List<CultureModel> getevent() {
		return dao.getevent();
	}
	public List<CultureModel> getexhibition(CultureModel culture) {
		return dao.getexhibhition(culture);
	}

	// 전시/미술 전체 리스트
	public List<CultureModel> getexhibitionlist(CultureModel culMd) {
		return dao.getexhibitionlist(culMd);
	}

	// 
	public int count(CultureModel culMd) {
		return dao.count(culMd);
	}

	// 전시미술 컨텐트 상세 페이지
	public CultureModel getexhibitioncont(CultureModel culMd) {
		return dao.getexhibhitioncont(culMd);
	}

	// 공연 리스트
	public List<CultureModel> getperformancelist(CultureModel culMd) {
		return dao.getperformancelist(culMd);
	}

	// 공연 전체 갯수
	public int count2(CultureModel culMd) {
		return dao.count2(culMd);
	}


	public CultureModel getperformancecont(CultureModel culMd) {
		return dao.getperformancecont(culMd);
	}

	// 축제행사 리스트
	public List<CultureModel> geteventlist(CultureModel culMd) {
		return dao.geteventlist(culMd);
	}


	public int count3(CultureModel culMd) {
		return dao.count3(culMd);
	}


	public CultureModel geteventcont(CultureModel culMd) {
		return dao.geteventcont(culMd);
	}


	public List<CultureModel> searchList(CultureModel culMd) {
		return dao.searchList(culMd);
	}


//	public int countList(CultureModel culMd) {
//		return dao.countList(culMd);	
//	}


	public int countall(CultureModel culMd) {
		return dao.countall(culMd);
	}


	public List<CultureModel> getallList(CultureModel culMd) {
		return dao.getallList(culMd);
	}


	
	
}
