package com.example.demo.controller;

import com.example.demo.model.Restaurant;
import com.example.demo.model.Review1;
import com.example.demo.service.RestaurantService;
import com.example.demo.service.Review1Service;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.util.*;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Controller
public class RestaurantController {

    private final RestaurantService service;
    private final Review1Service reviewservice;

    // --------------------- [구글 API 동기화용] ----------------------

    // 1. 폼(GET) - 버튼만 있는 페이지
    @GetMapping("/updateapi")
    public String updateapiForm() {
        return "restaurant/updateapi"; // 버튼만 있는 페이지(JSP)
    }

    // 2. 실제 동기화(POST) - 버튼 눌렀을 때만 DB 동기화 진행
    @PostMapping("/updateapi")
    public String updateapi(Model model) throws Exception {
        int[] result = service.syncFromGoogleApi();
        model.addAttribute("insertCnt", result[0]);
        model.addAttribute("updateCnt", result[1]);
        return "restaurant/updateapi";
    }

    // --------------------- [메인/리스트/상세 등 기존 코드] ----------------------

    // 메인 페이지
    @GetMapping("/res_main")
    public String mainPage(
            @RequestParam(value="res_gu", required=false) String resGu,
            @RequestParam(value="page", defaultValue="1") int page,
            @RequestParam(value = "searchType", required = false, defaultValue = "res_subject") String searchType,
            @RequestParam(value = "keyword", required = false) String keyword,
            Model model) {
    	String apiKey = service.getGOOGLE_API_KEY();
        String[] seoulGu = {
                "강남구", "강동구", "강북구", "강서구", "관악구", "광진구",
                "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구",
                "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구",
                "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"
        };

        // 기본 4개(BEST)
        List<Restaurant> restaurants = service.best();

        // 지도용 전체
        List<Restaurant> mapRestaurants = service.maplist();
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
        
        model.addAttribute("apiKey", apiKey);
        model.addAttribute("seoulGuList", Arrays.asList(seoulGu));
        model.addAttribute("res_gu", resGu);
        model.addAttribute("keyword", keyword);
        model.addAttribute("restaurants", restaurants);
        model.addAttribute("mapRestaurants", mapRestaurants);
        model.addAttribute("searchType", searchType);

        return "restaurant/res_main";
    }

    // 목록 리스트
    @RequestMapping("/restaurants")
    public String restaurantList(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "res_gu", required = false) String resGu,
            @RequestParam(value = "searchType", required = false, defaultValue = "res_subject") String searchType,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value="lat", required=false) Double lat,
            @RequestParam(value="lng", required=false) Double lng,
            Model model) {

        int limit = 9;
        Restaurant cond = new Restaurant();
        cond.setRes_gu(resGu);
        cond.setKeyword(keyword);

        int listcount = service.count(cond);
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

        int pagecount = listcount / limit + (listcount % limit == 0 ? 0 : 1);
        int startpage = ((page - 1) / 10) * 10 + 1;
        int endpage = startpage + 10 - 1;
        if (endpage > pagecount) endpage = pagecount;

        if ("nearby".equals(searchType) && lat != null && lng != null) {
            Map<String,Object> param = new HashMap<>();
            param.put("lat", lat);
            param.put("lng", lng);
            param.put("radius", 2); // km
            restaurants = service.findNearby(param);
        }

        model.addAttribute("searchType", searchType);
        model.addAttribute("page", page);
        model.addAttribute("restaurants", restaurants);
        model.addAttribute("listcount", listcount);
        model.addAttribute("pagecount", pagecount);
        model.addAttribute("startpage", startpage);
        model.addAttribute("endpage", endpage);
        model.addAttribute("res_gu", resGu);
        model.addAttribute("keyword", keyword);

        return "restaurant/res_list";
    }

    // 상세페이지
    @GetMapping("/restaurantDetail")
    public String restaurantDetail(@RequestParam("res_id") String resId, Model model,
                                   @RequestParam(value = "page", defaultValue = "1") int page,
                                   @RequestParam(value = "editReviewId", required = false) Integer editReviewId
    ) throws Exception {
        Restaurant restaurant = service.selectById(resId);

        // 여분 사진: 쉼표로 저장
        List<String> extraPhotoUrls = new ArrayList<>();
        if (restaurant != null && restaurant.getRes_photo_urls() != null) {
            String photoUrlsStr = restaurant.getRes_photo_urls();
            String[] urlArr = photoUrlsStr.split(",");
            for (String url : urlArr) {
                url = url.trim();
                if (!url.isEmpty()) extraPhotoUrls.add(url);
            }
        }

        // 리뷰 페이징
        int pageSize = 10;
        int totalCount = reviewservice.countreview(resId);
        int totalpage = (int) Math.ceil((double) totalCount / pageSize);
        int startRow = (page - 1) * pageSize + 1;
        int endRow = page * pageSize;

        List<Review1> reviewlist = reviewservice.reviewlist(resId, startRow, endRow);

        if (editReviewId != null) {
            Review1 editReview = reviewservice.selectreview(editReviewId);
            model.addAttribute("editReview", editReview);
        }
        model.addAttribute("page", page);
        model.addAttribute("totalpage", totalpage);
        model.addAttribute("reviewlist", reviewlist);
        model.addAttribute("restaurant", restaurant);
        model.addAttribute("extraPhotoUrls", extraPhotoUrls);
        return "restaurant/restaurantDetail";
    }

    // 리뷰 작성
    @PostMapping("/reviewwrite")
    public String writeReview(@ModelAttribute Review1 review,
                              @RequestParam("review_file11") MultipartFile file,
                              Model model,
                              HttpSession session) throws Exception {

        String uploadPath = session.getServletContext().getRealPath("images");
        String filename = file.getOriginalFilename();
        int size = (int) file.getSize();
        String newfilename = "";

        if (size > 0) {
            String extension = filename.substring(filename.lastIndexOf(".")).toLowerCase();
            if (!extension.equals(".jpg") && !extension.equals(".jpeg") &&
                !extension.equals(".png") && !extension.equals(".gif")) {
                model.addAttribute("result2", 2);
            }
            if (size > 1024 * 1000) {
                model.addAttribute("result1", 1);
            }
            newfilename = java.util.UUID.randomUUID().toString() + extension;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            file.transferTo(new File(uploadPath, newfilename));
            review.setReview_file1(newfilename);
        }

        reviewservice.insertreview(review);
        return "redirect:restaurant/restaurantDetail?res_id=" + review.getRes_id();
    }

    // 리뷰 수정
    @PostMapping("/reviewedit")
    public String reviewEdit(@ModelAttribute Review1 review,
                             @RequestParam("review_file11") MultipartFile file,
                             @RequestParam("old_file") String oldFile,
                             HttpSession session, @RequestParam("res_id") String resId
    ) throws Exception {
        if (!file.isEmpty()) {
            String filename = file.getOriginalFilename();
            String path = session.getServletContext().getRealPath("images");
            file.transferTo(new java.io.File(path + "/" + filename));
            review.setReview_file1(filename);
        } else {
            review.setReview_file1(oldFile);
        }

        reviewservice.updatereview(review);
        return "redirect:restaurant/restaurantDetail?res_id=" + review.getRes_id();
    }

    // 리뷰 삭제
    @GetMapping("/reviewdelete")
    public String reviewDelete(@RequestParam("review_id1") int review_id1,
                               @RequestParam("res_id") String resId,
                               HttpSession session) {
        String fileName = reviewservice.reviwfile(review_id1);
        if (fileName != null && !fileName.trim().isEmpty()) {
            String path = session.getServletContext().getRealPath("/upload/");
            java.io.File file = new java.io.File(path, fileName);
            if (file.exists()) file.delete();
        }
        reviewservice.deletereview(review_id1);
        return "redirect:restaurant/restaurantDetail?res_id=" + resId;
    }
}
