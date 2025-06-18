package com.example.demo.controller;

import com.example.demo.model.Restaurant;
import com.example.demo.model.Review1;
import com.example.demo.service.RestaurantService;
import com.example.demo.service.Review1Service;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Controller
public class RestaurantController {
	
	@Autowired
    private final RestaurantService service;
    private final Review1Service reviewservice;
    
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

    // api로 검
    @GetMapping("/search")
    public String search(@RequestParam(value = "regions", required = false) List<String> regions,
                         Model model) throws Exception {
        model.addAttribute("districts", Arrays.asList(SEOUL_DISTRICTS));

        if (regions != null && !regions.isEmpty()) {
            List<String> allPlaceIds = new ArrayList<>();

            for (String region : regions) {
                String gu = region.split(" ")[1];
                List<String> placeIds = fetchPlaceIds(region);
                allPlaceIds.addAll(placeIds);
            }

            // 중복 제거
            List<String> uniquePlaceIds = allPlaceIds.stream()
                    .distinct()
                    .collect(Collectors.toList());

            
            List<Restaurant> restaurants = new ArrayList<>();
            for (String placeId : uniquePlaceIds) {
                Restaurant r = fetchDetail(placeId); // DB 저장 X, 정보만 받아오기!
                if (r != null) {
                    boolean saved = service.saveRestaurantIfNotExists(r);
                    if (saved) { // 새로 저장된 것만 목록에 추가
                        restaurants.add(r);
                    }
                }
            }
            
            model.addAttribute("regionMap", restaurants);
            model.addAttribute("selectedRegions", regions);
        }
        
        return "search";
    }
   //search 에서 상세정보api
    private List<String> fetchPlaceIds(String keyword) throws Exception {
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
    public static String extractGu(String address) {
        if (address == null) return "";
        for (String guFull : SEOUL_DISTRICTS) {
            String gu = guFull.replace("서울 ", ""); // "서울 종로구" → "종로구"
            if (address.contains(gu)) return gu;
        }
        // 혹시라도 못 찾으면 패턴으로 마지막 '구' 찾아서 반환
        Pattern p = Pattern.compile("([가-힣]{2,4}구)");
        Matcher m = p.matcher(address);
        if (m.find()) return m.group(1);
        return "";
    }

    private Restaurant fetchDetail(String placeId) throws Exception {
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
        // ★ 주소에서 구 추출해서 저장!
        System.out.println("저장 시작: " + r);
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

            // 여분 사진 리스트 (대표사진은 제외!)
            List<String> extraPhotoUrls = new ArrayList<>();
            for (int i = 1; i < photos.size(); i++) {
                JSONObject p = (JSONObject) photos.get(i);
                String extraRef = (String) p.get("photo_reference");
                String url = "https://maps.googleapis.com/maps/api/place/photo"
                        + "?maxwidth=400&photo_reference=" + extraRef + "&key=" + GOOGLE_API_KEY;
                extraPhotoUrls.add(url);
            }
            // 레스토랑 객체에는 안 넣고, Controller에서 별도로 Model에 addAttribute 하면 됨
            // (상세페이지 진입 시 한 번 더 API 호출해서 전달하는 방식 추천)
            r.setRes_photoUrls(extraPhotoUrls);
        }
        
        return r;
    }
    
    // api 정보db에 저장
    @GetMapping("/collectAll")
    public String collectAllData(Model model) throws Exception {
        int totalSaved = 0;
        Set<String> allSavedIds = new HashSet<>(); // 전체 중복방지

        String[] SEOUL_GUS = {
            "서울 종로구", "서울 중구", "서울 용산구", "서울 성동구", "서울 광진구",
            "서울 동대문구", "서울 중랑구", "서울 성북구", "서울 강북구", "서울 도봉구",
            "서울 노원구", "서울 은평구", "서울 서대문구", "서울 마포구", "서울 양천구",
            "서울 강서구", "서울 구로구", "서울 금천구", "서울 영등포구", "서울 동작구",
            "서울 관악구", "서울 서초구", "서울 강남구", "서울 송파구", "서울 강동구"
        };

        for (String gu : SEOUL_GUS) {
            // 각 구별 placeId 리스트
            List<String> placeIds = fetchPlaceIds(gu); // fetchPlaceIds는 페이징 60개까지 가져옴

            for (String placeId : placeIds) {
                if (allSavedIds.contains(placeId)) continue; // 완전 중복 방지

                Restaurant r = fetchDetail(placeId);
                if (r != null) {
                    boolean saved = service.saveRestaurantIfNotExists(r);
                    if (saved) {
                        allSavedIds.add(placeId);
                        totalSaved++;
                    }
                }
            }
        }
        model.addAttribute("totalSaved", totalSaved);
        return "restaurant/collectResult"; // 성공 결과 페이지(jsp)로 이동 (ex: "총 저장: ${totalSaved}")
    }

    // 메인 페이
    @GetMapping("/res_main")
    public String mainPage(@RequestParam(value="res_gu", required=false) String resGu,
    					   @RequestParam(value="page", defaultValue="1") int page,	
    					   @RequestParam(value = "searchType", required = false, defaultValue = "res_subject") String searchType,
    					   @RequestParam(value = "keyword", required = false) String keyword,
    					   Model model) {
    	
    	String[] seoulGu = { "강남구", "강동구", "강북구", "강서구", "관악구", "광진구",
    			"구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구",
    			"마포구", "서대문구", "서초구", "성동구", "성북구", "송파구",
    			"양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"
    	};

        // ⭐ 카드용 맛집: 기본 4개(BEST)
        List<Restaurant> restaurants = service.best();

        // ⭐ 지도용 전체(혹은 전체조회, 조건부 필터링 가능)
        List<Restaurant> mapRestaurants = service.maplist(); // 또는 service.listAll(), DB에 따라 메소드 이름 조정
        System.out.println("mapRestaurants: " + mapRestaurants); // 로그 찍기
        // 검색/구별 처리
        if ((keyword == null || keyword.trim().isEmpty()) && (resGu == null || resGu.trim().isEmpty())) {
            restaurants = service.best();
        } else {
            Restaurant cond = new Restaurant();
            cond.setRes_gu(resGu);
            cond.setKeyword(keyword);
            restaurants = service.list(cond);
        }
        if ("res_gu".equals(searchType) && (resGu != null && !resGu.isEmpty())) {
            keyword = "";
        }
        if ("res_gu".equals(searchType)) {
            keyword = "";
        }

        // model 추가
        model.addAttribute("GOOGLE_API_KEY", GOOGLE_API_KEY);
        model.addAttribute("seoulGuList", Arrays.asList(seoulGu));
        model.addAttribute("res_gu", resGu);
        model.addAttribute("keyword", keyword);
        model.addAttribute("restaurants", restaurants);           // 카드/리스트: 4개 or 검색결과
        model.addAttribute("mapRestaurants", mapRestaurants);     // 지도: 전체
        model.addAttribute("searchType", searchType);

        return "restaurant/res_main"; // /WEB-INF/views/main.jsp
    }
    
    
    // 목록 리스트 
    @RequestMapping("/restaurants")
    public String restaurantList(@RequestParam(value = "page", defaultValue = "1") int page,
            					 @RequestParam(value = "res_gu", required = false) String resGu, // 구 파라미터
            					 @RequestParam(value = "searchType", required = false, defaultValue = "res_subject") String searchType,
            					 @RequestParam(value = "keyword", required = false) String keyword, // 식당명 등 검색,
            					 @RequestParam(value="lat", required=false) Double lat,
            				     @RequestParam(value="lng", required=false) Double lng,
            					 Model model) {

        int limit = 9; // 한 페이지에 9개
        Restaurant cond = new Restaurant();

        // 조건 설정: 구 선택시 구별, 키워드 검색시 키워드로
        cond.setRes_gu(resGu);
        cond.setKeyword(keyword);

        int listcount = service.count(cond); // 전체 건수(조건별)
        int startRow = (page - 1) * limit + 1;
        int endRow = page * limit;
        cond.setStartRow(startRow);
        cond.setEndRow(endRow);

        List<Restaurant> restaurants = service.list(cond);

        String[] seoulGuList = {
                "강남구", "강동구", "강북구", "강서구", "관악구", "광진구",
                "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구",
                "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구",
                "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"
            };
            model.addAttribute("seoulGuList", Arrays.asList(seoulGuList));
        // 총 페이지 수, 페이징 계산
        int pagecount = listcount / limit + (listcount % limit == 0 ? 0 : 1);
        int startpage = ((page - 1) / 10) * 10 + 1;
        int endpage = startpage + 10 - 1;
        if (endpage > pagecount) endpage = pagecount;

        if ("nearby".equals(searchType) && lat != null && lng != null) {
            // 현재 위치 기준 가까운 맛집
            Map<String,Object> param = new HashMap<>();
            param.put("lat", lat);
            param.put("lng", lng);
            param.put("radius", 2); // km, 반경 (원하는 값)
            restaurants = service.findNearby(param);
        } else {
            // 기존 리스트
        	service.list(cond);
        }
        // 모델에 값 전달
        model.addAttribute("searchType", searchType);
        model.addAttribute("page", page);
        model.addAttribute("restaurants", restaurants);
        model.addAttribute("listcount", listcount);
        model.addAttribute("pagecount", pagecount);
        model.addAttribute("startpage", startpage);
        model.addAttribute("endpage", endpage);
        model.addAttribute("res_gu", resGu);
        model.addAttribute("keyword", keyword);

        return "restaurant/res_list"; // /WEB-INF/views/list.jsp
    }	
    
    //상세페이지
    @GetMapping("/restaurantDetail")
    public String restaurantDetail(@RequestParam("res_id") String resId, Model model,
    							   @RequestParam(value = "page", defaultValue = "1") int page,
    							   @RequestParam(value = "editReviewId", required = false) Integer editReviewId
    							   ) throws Exception {
        // DB에서 해당 식당 정보
    	 Restaurant restaurant = service.selectById(resId);
    	 System.out.println("restaurant="+restaurant); // 로그 꼭!

    	    // 여분 사진: DB 컬럼(res_photo_urls 등)에 ,(쉼표)로 저장
    	    List<String> extraPhotoUrls = new ArrayList<>();
    	    if (restaurant != null && restaurant.getRes_photo_urls() != null) {
    	        String photoUrlsStr = restaurant.getRes_photo_urls();
    	        String[] urlArr = photoUrlsStr.split(",");
    	        for (String url : urlArr) {
    	            url = url.trim();
    	            if (!url.isEmpty()) extraPhotoUrls.add(url);
    	        }
    	    }

    	    // 리뷰 페이지
    	    int pageSize = 10; // 한 페이지에 몇 개씩
    	    int totalCount = reviewservice.countreview(resId);
    	    int totalpage = (int) Math.ceil((double) totalCount / pageSize);
    	    int startRow = (page - 1) * pageSize + 1;
    	    int endRow = page * pageSize;

    	    List<Review1> reviewlist = reviewservice.reviewlist(resId, startRow, endRow);
    	    
    	    // ★ 수정폼에 넣을 리뷰정보 추가
    	    if (editReviewId != null) {
    	        Review1 editReview = reviewservice.selectreview(editReviewId);
    	        model.addAttribute("editReview", editReview);
    	    }
    	    model.addAttribute("page", page);
    	    model.addAttribute("totalpage", totalpage);
    	    model.addAttribute("reviewlist", reviewlist); 
    	    model.addAttribute("restaurant", restaurant);
    	    model.addAttribute("extraPhotoUrls", extraPhotoUrls); // 여분사진
    	    return "restaurant/restaurantDetail";
    }
    
    // 리뷰 작성
    @PostMapping("/reviewwrite")
    public String writeReview(@ModelAttribute Review1 review,
    						  @RequestParam("review_file11") MultipartFile file,
    						  Model model,
    						  HttpSession session) throws Exception {
      
     // ★ 실제 경로 찾기 (static/images)
        String uploadPath = session.getServletContext().getRealPath("images");
        String filename = file.getOriginalFilename();
        int size = (int) file.getSize();
        String newfilename = "";

        System.out.println("file:" + file);
		System.out.println("filename:" + filename);
		System.out.println("size:" + size);
		System.out.println("uploadPath:" + uploadPath);
		
        if (size > 0) {
            String extension = filename.substring(filename.lastIndexOf(".")).toLowerCase();
            // 확장자 체크
            if (!extension.equals(".jpg") && !extension.equals(".jpeg") &&
                !extension.equals(".png") && !extension.equals(".gif")) {
                model.addAttribute("result2", 2);
            }
            if (size > 1024 * 1000) { // 1MB 제한(자유롭게 변경)
                model.addAttribute("result1", 1);
            }
            newfilename = java.util.UUID.randomUUID().toString() + extension;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            file.transferTo(new File(uploadPath, newfilename));
            review.setReview_file1(newfilename);
        }

        
        reviewservice.insertreview(review);
        // 작성 후 상세페이지로 리다이렉트
        return "redirect:restaurant/restaurantDetail?res_id=" + review.getRes_id();
    }
    
   
    
    // 리뷰 수정
    @PostMapping("/reviewedit")
    public String reviewEdit(@ModelAttribute Review1 review,
            				 @RequestParam("review_file11") MultipartFile file,
            				 @RequestParam("old_file") String oldFile,
            				 HttpSession session, @RequestParam("res_id") String resId
    ) throws Exception {
    	 System.out.println("==== 리뷰 수정 파라미터 확인 ====");
    	    System.out.println("review_id1 = " + review.getReview_id1());
    	    System.out.println("review_score1 = " + review.getReview_score1());
    	    System.out.println("review_content1 = " + review.getReview_content1());
    	    System.out.println("review_file1 = " + review.getReview_file1());
    	    System.out.println("res_id = " + review.getRes_id());
        // 파일 첨부 처리
        if (!file.isEmpty()) {
            String filename = file.getOriginalFilename();
            String path = session.getServletContext().getRealPath("images");
            file.transferTo(new java.io.File(path + "/" + filename));
            review.setReview_file1(filename);
        } else {
            review.setReview_file1(oldFile); // ★ 기존 파일 유지
        }
        
        int result = reviewservice.updatereview(review);
        System.out.println("MyBatis update result: " + result);

        // 식당 상세페이지로 리다이렉트
        return "redirect:restaurant/restaurantDetail?res_id=" + review.getRes_id();
    }
    // 리뷰 삭제
    @GetMapping("/reviewdelete")
    public String reviewDelete(@RequestParam("review_id1") int review_id1,
            				   @RequestParam("res_id") String resId,
            				   HttpSession session) {
    	 // 1. 파일명 조회
        String fileName = reviewservice.reviwfile(review_id1);
        if (fileName != null && !fileName.trim().isEmpty()) {
            // 2. 실제 경로로 파일 삭제
            String path = session.getServletContext().getRealPath("/upload/"); // 실제 경로 맞춰주세요
            java.io.File file = new java.io.File(path, fileName);
            if (file.exists()) file.delete();
        }
        int result=reviewservice.deletereview(review_id1);
        return "redirect:restaurant/restaurantDetail?res_id=" + resId;
    }
}
