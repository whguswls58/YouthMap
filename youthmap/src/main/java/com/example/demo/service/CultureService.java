package com.example.demo.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Date;
import java.util.List;
import java.util.Set;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.dao.CultureDao;
import com.example.demo.model.CultureModel;


@Service
public class CultureService {
    @Value("${culture.api.key}")
    private String apiKey;

    @Autowired
    private CultureDao dao;

    private static final Set<String> ALLOWED_TARGETS = Set.of(
        "성인", "누구나", "전체관람가", "미취학아동 입장불가"
    );
    private static final Set<String> ALLOWED_CODES = Set.of(
        "전시/미술", "축제-문화/예술", "축제-기타", "축제-자연/경관",
        "콘서트", "연극", "뮤지컬/오페라", "국악", "독주회", "클래식", "무용"
    );

    /**
     * API에서 지정 페이지의 JSON 문자열을 받아 반환
     */
    public String getYouthCulture(int i) {
        try {
            String apiUrl = String.format(
                "http://openapi.seoul.go.kr:8088/%s/json/culturalEventInfo/%d/%d",
                apiKey, (i * 1000) + 1, (i + 1) * 1000
            );
            HttpURLConnection conn = (HttpURLConnection)
                new URL(apiUrl).openConnection();
            conn.setRequestMethod("GET");

            BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "UTF-8")
            );
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            reader.close();
            return sb.toString();
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * DB에 저장된 최신 데이터 이후의 신규 페이지만 API에서 가져와
     * 필터링 후 저장 처리
     */
    @Transactional
    public void insertNewCultures() throws Exception {
    	
    	// 수동 업데이트 시작 로그
        System.out.println("===== 수동 문화 업데이트 시작 =====");

    	
        CultureModel latest = dao.getLatestData();
        String lastTitle     = latest.getCon_title();
        String lastStartDate = latest.getCon_start_date();

        JSONParser parser = new JSONParser();
        for (int i = 0; i < 5; i++) {
            String jsonData = getYouthCulture(i);
            if (jsonData == null || jsonData.isBlank()) {
                // API 호출 실패 또는 빈 응답 시 다음 페이지로
                continue;
            }
            JSONObject root;
            try {
                root = (JSONObject) parser.parse(jsonData);
            } catch (Exception e) {
                e.printStackTrace();
                continue;
            }
            JSONObject info = (JSONObject) root.get("culturalEventInfo");
            if (info == null) {
                continue;
            }
            JSONArray rows = (JSONArray) info.get("row");
            if (rows == null) {
                continue;
            }

            for (Object o : rows) {
                JSONObject c = (JSONObject) o;
                String title = (String) c.get("TITLE");
                String dr    = (String) c.get("DATE");
                String startDate = (dr != null && dr.contains("~"))
                    ? dr.split("~")[0].trim()
                    : null;

                if (lastTitle.equals(title) && lastStartDate.equals(startDate)) {
                    return;
                }

                String codeName = (String) c.get("CODENAME");
                String useTrgt  = (String) c.get("USE_TRGT");
                if (codeName == null
                 || !ALLOWED_TARGETS.contains(useTrgt)
                 || !ALLOWED_CODES.contains(codeName)) {
                    continue;
                }

                CultureModel m = toModel(c);
                dao.culinsert(m);
            }
        }
    }

    /**
     * 매일 오후 4시 30분에 자동으로 문화 업데이트 실행
     */
    @Scheduled(cron = "0 30 9 * * *", zone = "Asia/Seoul")
    public void scheduledCultureUpdate() {
        try {
            System.out.println("===== 문화 자동 업데이트 시작 =====");
            System.out.println("실행 시각: " + new Date());
            insertNewCultures();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /** JSON 객체를 CultureModel로 매핑하는 헬퍼 */
    private CultureModel toModel(JSONObject c) {
        CultureModel m = new CultureModel();
        m.setCategory_name((String) c.get("CODENAME"));
        m.setCon_title((String) c.get("TITLE"));
        m.setCon_location((String) c.get("PLACE"));
        m.setCon_lot((String) c.get("LOT"));
        m.setCon_lat((String) c.get("LAT"));
        m.setCon_age((String) c.get("USE_TRGT"));
        m.setCon_link((String) c.get("ORG_LINK"));
        m.setCon_img((String) c.get("MAIN_IMG"));

        String fee = (String) c.get("USE_FEE");
        m.setCon_cost((fee == null || fee.isEmpty()) ? "무료" : fee);
        m.setCon_time("상세 시간은 해당 홈페이지에서 확인하세요.");

        String dateRange = (String) c.get("DATE");
        if (dateRange != null && dateRange.contains("~")) {
            String[] parts = dateRange.split("~");
            m.setCon_start_date(parts[0].trim());
            m.setCon_end_date(parts[1].trim());
        }
        return m;
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


	public CultureModel getLatestData() {
		return dao.getLatestData();
	}


	
	
}
