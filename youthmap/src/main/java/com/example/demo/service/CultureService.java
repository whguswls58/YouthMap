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
        "성인", "누구나", "전체관람가", "미취학아동입장불가", "전체관람"
    );
    private static final Set<String> ALLOWED_CODES = Set.of(
        "전시/미술", "축제-문화/예술", "축제-기타", "축제-자연/경관",
        "콘서트", "연극", "뮤지컬/오페라", "국악", "독주회", "클래식", "무용"
    );

    /** 한 페이지(1000개)씩 API 호출 */
    public String getYouthCulture(int pageIndex) {
        try {
            String apiUrl = String.format(
                "http://openapi.seoul.go.kr:8088/%s/json/culturalEventInfo/%d/%d",
                apiKey,
                pageIndex * 1000 + 1,
                (pageIndex + 1) * 1000
            );
            HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
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
     * DB에 없는 데이터만 삽입하도록 수정:
     *  - 제목+시작일 기준으로 exists 체크
     *  - useTrgt 공백 제거 후 필터링
     *  - 중간에 끼어든 신규 행도 모두 삽입
     */
    @Transactional
    public void insertNewCultures() throws Exception {
        System.out.println("===== 수동 문화 업데이트 시작 =====");

        JSONParser parser = new JSONParser();
        int insertCount = 0;

        // 최대 5페이지(1~5000건) 조회
        for (int i = 0; i < 5; i++) {
            String jsonData = getYouthCulture(i);
            if (jsonData == null || jsonData.isBlank()) {
                continue;
            }

            JSONObject root = (JSONObject) parser.parse(jsonData);
            JSONObject info = (JSONObject) root.get("culturalEventInfo");
            if (info == null) {
                continue;
            }
            JSONArray rows = (JSONArray) info.get("row");
            if (rows == null) {
                continue;
            }

            System.out.println("▶ 페이지 " + i + " 항목 수: " + rows.size());

            for (Object o : rows) {
                JSONObject c = (JSONObject) o;

                // 1) TITLE + START_DATE 기준으로 존재 여부 확인
                String titleRaw  = (String) c.get("TITLE");
                String dateRaw   = (String) c.get("DATE");
                String startDate = dateRaw != null && dateRaw.contains("~")
                    ? dateRaw.split("~")[0].trim()
                    : dateRaw;

                if (dao.existsByTitleAndDate(titleRaw, startDate)) {
                    continue;  // 이미 DB에 있으면 스킵
                }

                // 2) USE_TRGT 정규화 + 필터링
                String useTrgtRaw = (String) c.get("USE_TRGT");
                String useTrgt    = useTrgtRaw == null
                                   ? ""
                                   : useTrgtRaw.replaceAll("\\s+", "");
                if (!ALLOWED_TARGETS.contains(useTrgt)) {
                    continue;
                }

                // 3) CODENAME 필터링
                String codeName = (String) c.get("CODENAME");
                if (codeName == null || !ALLOWED_CODES.contains(codeName)) {
                    continue;
                }

                // 4) 삽입
                CultureModel m = toModel(c);
                dao.culinsert(m);
                insertCount++;
            }
        }

        System.out.println("▶ 신규 삽입 건수: " + insertCount);
    }

    /** 매일 16:30 자동 업데이트 */
    @Scheduled(cron = "0 30 17 * * *", zone = "Asia/Seoul")
    public void scheduledCultureUpdate() {
        System.out.println("===== 문화 자동 업데이트 시작 ===== " + new Date());
        try {
            insertNewCultures();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /** JSON → Model 매핑 */
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
