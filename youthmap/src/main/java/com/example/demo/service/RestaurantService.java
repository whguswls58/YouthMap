package com.example.demo.service;

import com.example.demo.dao.RestaurantDao;
import com.example.demo.model.Restaurant;
import lombok.RequiredArgsConstructor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class RestaurantService {

    private final RestaurantDao dao;

    // API 키와 HTTP 클라이언트, 파서 등은 서비스에만 둔다
    @Value("${google.api.key}")
    private String GOOGLE_API_KEY;
    private final OkHttpClient client = new OkHttpClient();
    private final JSONParser parser = new JSONParser();

    private static final String[] SEOUL_DISTRICTS = {
        "서울 종로구", "서울 중구", "서울 용산구", "서울 성동구", "서울 광진구",
        "서울 동대문구", "서울 중랑구", "서울 성북구", "서울 강북구", "서울 도봉구",
        "서울 노원구", "서울 은평구", "서울 서대문구", "서울 마포구", "서울 양천구",
        "서울 강서구", "서울 구로구", "서울 금천구", "서울 영등포구", "서울 동작구",
        "서울 관악구", "서울 서초구", "서울 강남구", "서울 송파구", "서울 강동구"
    };

    // [1] 구글 Places API로 키워드(지역) placeId 목록 얻기
    public List<String> fetchPlaceIds(String keyword) throws Exception {
        List<String> placeIds = new ArrayList<>();
        int page = 0;
        String nextPageToken = null;

        while (page < 2) {
            String currentUrl = (page == 0)
                    ? "https://maps.googleapis.com/maps/api/place/textsearch/json?query="
                    + URLEncoder.encode(keyword + " 맛집", StandardCharsets.UTF_8)
                    + "&language=ko&key=" + GOOGLE_API_KEY
                    : "https://maps.googleapis.com/maps/api/place/textsearch/json?pagetoken="
                    + nextPageToken + "&language=ko&key=" + GOOGLE_API_KEY;

            if (page > 0) Thread.sleep(2000);

            Request request = new Request.Builder().url(currentUrl).build();
            Response response = client.newCall(request).execute();
            JSONObject json = (JSONObject) parser.parse(response.body().string());
            JSONArray results = (JSONArray) json.get("results");

            for (Object obj : results) {
                JSONObject jo = (JSONObject) obj;
                String placeId = (String) jo.get("place_id");
                placeIds.add(placeId);
            }

            Object tokenObj = json.get("next_page_token");
            nextPageToken = tokenObj != null ? tokenObj.toString() : null;
            page++;
        }
        return placeIds;
    }

    // [2] PlaceId로 상세정보 받아와 Restaurant 객체로 변환
    public Restaurant fetchDetail(String placeId) throws Exception {
        String fields = String.join(",",
                "name", "formatted_address", "formatted_phone_number",
                "geometry", "opening_hours", "photos",
                "rating", "price_level", "url",
                "website", "business_status", "user_ratings_total");

        String detailUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=" + placeId
                + "&fields=" + fields + "&language=ko&key=" + GOOGLE_API_KEY;

        Response response = client.newCall(new Request.Builder().url(detailUrl).build()).execute();
        JSONObject result = (JSONObject) ((JSONObject) parser.parse(response.body().string())).get("result");
        if (result == null) return null;

        Restaurant r = new Restaurant();
        r.setRes_id(placeId);
        r.setRes_subject((String) result.get("name"));
        String address = (String) result.get("formatted_address");
        r.setRes_address(address);
        r.setRes_tel((String) result.get("formatted_phone_number"));
        r.setRes_mapUrl((String) result.get("url"));
        r.setRes_website((String) result.get("website"));
        r.setRes_status((String) result.get("business_status"));
        r.setRes_gu(extractGu(address));

        JSONObject loc = (JSONObject) ((JSONObject) result.get("geometry")).get("location");
        r.setRes_latitude(((Number) loc.get("lat")).doubleValue());
        r.setRes_longitude(((Number) loc.get("lng")).doubleValue());

        JSONObject oh = (JSONObject) result.get("opening_hours");
        if (oh != null) {
            r.setRes_open(String.valueOf(oh.get("open_now")));
            JSONArray weekdayText = (JSONArray) oh.get("weekday_text");
            if (weekdayText != null) {
                StringBuilder sb = new StringBuilder();
                for (Object o : weekdayText) sb.append(o).append("\n");
                r.setRes_open_hours(sb.toString());
            }
        } else {
            r.setRes_open("정보 없음");
            r.setRes_open_hours("영업시간 정보 없음");
        }

        Number rating = (Number) result.get("rating");
        r.setRes_score(rating != null ? rating.doubleValue() : 0.0);

        r.setRes_price_level(result.get("price_level") != null
                ? ((Number) result.get("price_level")).intValue() : -1);

        r.setRes_user_ratings_total(result.get("user_ratings_total") != null
                ? ((Number) result.get("user_ratings_total")).intValue() : 0);

        JSONArray photos = (JSONArray) result.get("photos");
        if (photos != null && !photos.isEmpty()) {
            // 대표 사진 세팅
            JSONObject p0 = (JSONObject) photos.get(0);
            String ref = (String) p0.get("photo_reference");
            r.setRes_file(ref);
            r.setRes_photo_url("https://maps.googleapis.com/maps/api/place/photo"
                    + "?maxwidth=400&photo_reference=" + ref + "&key=" + GOOGLE_API_KEY);

            // 여분 사진 리스트 (대표사진 제외)
            List<String> extraPhotoUrls = new ArrayList<>();
            for (int i = 1; i < photos.size(); i++) {
                JSONObject p = (JSONObject) photos.get(i);
                String extraRef = (String) p.get("photo_reference");
                String url = "https://maps.googleapis.com/maps/api/place/photo"
                        + "?maxwidth=400&photo_reference=" + extraRef + "&key=" + GOOGLE_API_KEY;
                extraPhotoUrls.add(url);
            }
            // 쉼표로 DB에 저장
            r.setRes_photo_urls(String.join(",", extraPhotoUrls));
        }

        return r;
    }

    // [3] 주소에서 "구" 추출
    public static String extractGu(String address) {
        if (address == null) return "";
        for (String guFull : SEOUL_DISTRICTS) {
            String gu = guFull.replace("서울 ", "");
            if (address.contains(gu)) return gu;
        }
        Pattern p = Pattern.compile("([가-힣]{2,4}구)");
        Matcher m = p.matcher(address);
        if (m.find()) return m.group(1);
        return "";
    }

    // [4] 신규/업데이트 분기해서 저장(중복 방지)
    public boolean saveOrUpdate(Restaurant r) {
        Restaurant exists = dao.selectById(r.getRes_id());
        if (exists == null) return dao.saveres(r) > 0; // INSERT
        else return dao.updateres(r) > 0;               // UPDATE
    }

    // [5] 단순 중복체크 insert (미사용 시 삭제)
    public boolean saveRestaurantIfNotExists(Restaurant restaurant) {
        Restaurant existing = dao.selectById(restaurant.getRes_id());
        if (existing == null) {
            dao.saveres(restaurant);
            return true;
        } else {
            return false;
        }
    }

    // ---------------- [동기화 핵심] ----------------

    /**
     * [컨트롤러에서 POST로 호출됨]
     * 구글 API로 placeId 목록 가져와서 DB에 동기화 (중복은 update, 신규만 insert)
     * @return int[] {신규insert수, update수}
     */
    public int[] syncFromGoogleApi() throws Exception {
        List<String> apiPlaceIds = fetchPlaceIds("서울 맛집");
        List<Restaurant> allRestaurants = dao.maplist();
        Set<String> dbPlaceIds = allRestaurants.stream()
            .map(Restaurant::getRes_id)
            .collect(Collectors.toSet());

        int insertCnt = 0, updateCnt = 0;
        for (String placeId : apiPlaceIds) {
            Restaurant apiResult = fetchDetail(placeId);
            if (apiResult == null) continue;
            boolean isInsert = saveOrUpdate(apiResult); // 반드시 이 메소드만 사용!
            if (isInsert) insertCnt++;
            else updateCnt++;
        }
        return new int[]{insertCnt, updateCnt};
    }

    // ------------------- [스케줄러: 매월 1일 자동 동기화] -------------------

    @Scheduled(cron = "0 0 3 1 * ?") // 매월 1일 03:00
    public void monthlySync() throws Exception {
        int[] result = syncFromGoogleApi();
        System.out.println("==== [자동] 구글 API 동기화 완료: 신규=" + result[0] + ", 업데이트=" + result[1]);
    }

    // -------------------- [기존 DB 조회/리스트 기능] --------------------

    public int saveres(Restaurant r)        { return dao.saveres(r); }
    public int updateres(Restaurant r)      { return dao.updateres(r); }
    public int count(Restaurant restaurant) { return dao.count(restaurant); }
    public List<Restaurant> list(Restaurant restaurant) { return dao.list(restaurant); }
    public Restaurant selectById(String resId) { return dao.selectById(resId); }
    public List<Restaurant> best() { return dao.best(); }
    public List<Restaurant> findNearby(Map<String, Object> param) { return dao.findNearby(param); }
    public List<Restaurant> maplist() { return dao.maplist(); }
    public void updatephotourls(String res_id, String res_photo_urls) { dao.updatephotourls(res_id, res_photo_urls); }

	public String getGOOGLE_API_KEY() {
		return GOOGLE_API_KEY;
	}

	public void setGOOGLE_API_KEY(String gOOGLE_API_KEY) {
		GOOGLE_API_KEY = gOOGLE_API_KEY;
	}
}
