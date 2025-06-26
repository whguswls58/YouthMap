package com.example.demo.controller;

import java.io.File;


import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.dao.CultureDao;
import com.example.demo.model.CultureModel;
import com.example.demo.model.Review2Model;
import com.example.demo.service.CultureService;
import com.example.demo.service.Review2Service;

import jakarta.servlet.http.HttpSession;

//@RequiredArgsConstructor			// Constructor DI :생성자의 매개변수로 의존성 주입
@Controller
public class CultureController {

	@Autowired // setter DI
	private CultureService service;

//	private final CultureService service;
	// review2 서비스 주입
//	private final review2Serive reservice;
	@Autowired
	private Review2Service reservice;

	// 1) 업데이트 결과 페이지
    @GetMapping("/datainput")
    public String datainput(Model model) {
        try {
            service.insertNewCultures();
            model.addAttribute("message", "업데이트가 완료되었습니다.");
        } catch (Exception e) {
            model.addAttribute("message", "업데이트 중 오류: " + e.getMessage());
        }
        // /WEB-INF/views/updateResult.jsp
        return "culture/updateResult";   
    }
				
	// 메인 페이지
	@GetMapping("/culturemain")
	public String mainPage(CultureModel culture, Model model) {

		
		
		List<CultureModel> exhibition = service.getexhibition(culture);
//		System.out.println("exhibition :" + exhibition);

		List<CultureModel> performance = service.getperformance();

		List<CultureModel> event = service.getevent();

		model.addAttribute("exhibition", exhibition);
		model.addAttribute("performance", performance);
		model.addAttribute("event", event);
//		model.addAttribute("con_start_date", con_start_date);
//		model.addAttribute("con_end_date", con_end_date);

		return "culture/culturemain";
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	// 전시/미술 리스트 페이지
	@RequestMapping("/exhibitionlist")
	public String exhibitionlist(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value="sort", required=false)  String sort,
			CultureModel culMd, Model model) {

		int limit = 12; // 한 페이지 출력할 데이터 갯수 12개. 두번째 기본변수.
		int listcount = service.count(culMd); // 세번째 기본변수. 총 데이터 갯수 구함. db에서 구해옴

		System.out.println("listcount" + listcount);

		service.addReadCount(culMd);

		// 한 페이지 범위 계산 파생변수 만들기(startRow, endRow)
		int startRow = (page - 1) * limit + 1;
		int endRow = page * limit;

		// 검색 안하면 startR-,endR-만 저장되는데. 검색하면 키워드 서치 까지 board에 담아서 다 가져감(총 4)
		culMd.setStartRow(startRow);
		culMd.setEndRow(endRow);
//		culMd.setCon_age("누구나");

		// 해당 페이지 데이터 조회
		List<CultureModel> exhibitionlist = service.getexhibitionlist(culMd);
//		  System.out.println(">>> exhibition.size() = " + exhibition.size());

		// 3) 새로 추가한 필드 세팅   >>  팝업창 정렬조건
        culMd.setSort     (sort);      // mostViewed / newest / endingSoon

		// 총 페이지 수 (10개씩 묶는 건 페이지 번호 블록 크기이지, 한 페이지 아이템 수가 아님)
		int pagecount = listcount / limit + (listcount % 10 == 0 ? 0 : 1);

		// 페이지 번호 블록 계산 (한 블록에 10페이지)
		int startpage = ((page - 1) / 10) * 10 + 1;
		int endpage = startpage + 10 - 1;

		if (endpage > pagecount)
			endpage = pagecount;

		model.addAttribute("exhibitionlist", exhibitionlist);
		model.addAttribute("page", page);
		model.addAttribute("listcount", listcount);
		model.addAttribute("pagecount", pagecount);
		model.addAttribute("startpage", startpage);
		model.addAttribute("endpage", endpage);
		model.addAttribute("mainCategory", "전시/미술");
		// 검색
		model.addAttribute("search", culMd.getSearch());
		model.addAttribute("keyword", culMd.getKeyword());
		model.addAttribute("sort",         sort);

		return "culture/exhibitionlist";
	}

	// ─── 전시/미술 컨텐츠 상세페이지 (GET) ───
	@GetMapping("/exhibitioncont")
	public String exhibitioncont(@RequestParam("con_id") int con_id,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "editReviewId", required = false) Integer editReviewId, CultureModel culMd,
			Model model) throws Exception {

		// 1) 콘텐츠 조회
		culMd.setCon_id(con_id);
		CultureModel exhibitioncont = service.getexhibitioncont(culMd);
		model.addAttribute("exhibitioncont", exhibitioncont);
		
		service.addReadCount(culMd);
		
		// 2) 리뷰 페이징 처리
		int pageSize = 10;
		int totalCount = reservice.countReview2(con_id);
		int totalPage = (int) Math.ceil((double) totalCount / pageSize);
		int startRow = (page - 1) * pageSize + 1;
		int endRow = page * pageSize;
		List<Review2Model> reviewlist = reservice.review2List(con_id, startRow, endRow);

		model.addAttribute("reviewlist", reviewlist);
		model.addAttribute("page", page);
		model.addAttribute("totalpage", totalPage);
//        model.addAttribute("", reviewlist)

		// 3) 수정 폼용 리뷰
		if (editReviewId != null) {
			Review2Model editReview = reservice.selectReview2(editReviewId);
			model.addAttribute("editReview", editReview);
		}

		return "culture/exhibitioncont";
	}

	// ─── 전시/미술 리뷰 작성 (POST) ───
	// ─── 전시/미술 리뷰 작성 (POST) ───
	@PostMapping("/exhibitioncont/reviewwrite")
	public String exhbtWriteReview2(@RequestParam("review_file22") MultipartFile file2,
			@RequestParam(value = "page", defaultValue = "1") int page, @ModelAttribute Review2Model review2,
			Model model, HttpSession session) throws Exception {
		// 1) DTO에 직접 세팅
//    	Review2Model review2 = new Review2Model();
//        review2.setCon_id(con_id);
//        review2.setReview_score2(review_score2);
//        review2.setReview_content2(review_content2);

		System.out.println("▶▶ review_writer2 = " + review2.getReview_writer2());

		// ★ 실제 경로 찾기 (static/images)
		String uploadPath = session.getServletContext().getRealPath("images");
		String filename = file2.getOriginalFilename();
		int size = (int) file2.getSize();
		String newfilename = "";

		System.out.println("file2: " + file2);
		System.out.println("filename: " + filename);
		System.out.println("size: " + size);
		System.out.println("uploadPath: " + uploadPath);

		if (size > 0) {
			String extension = filename.substring(filename.lastIndexOf(".")).toLowerCase();
			// 확장자 체크
			if (!extension.equals(".jpg") && !extension.equals(".jpeg") && !extension.equals(".png")
					&& !extension.equals(".gif")) {
				model.addAttribute("result2", 2); // 잘못된 확장자

			}
			// 1MB 제한 (필요시 조정)
			if (size > 10240 * 1000) {
				model.addAttribute("result1", 1); // 용량 초과
			}
			// 실제 저장 파일명
			newfilename = UUID.randomUUID().toString() + extension;
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists())
				uploadDir.mkdirs();

			file2.transferTo(new File(uploadPath, newfilename));
			review2.setReview_file2(newfilename);

		}

		// 리뷰 등록
		reservice.insertReview2(review2);
		// 상세페이지로 리다이렉트
		return "redirect:/exhibitioncont?con_id=" + review2.getCon_id() + "&page=" + page;
	}

	// ─── 전시/미술 리뷰 수정 (POST) ───
	@PostMapping("/exhibitioncont/reviewedit")
	public String exhbtEditReview2(@RequestParam("review_file22") MultipartFile file2,
			@RequestParam("old_file2") String old_file2, @RequestParam(value = "page", defaultValue = "1") int page,
//    		@RequestParam("review_id2") int review_id2,
//    		@RequestParam("con_id") int con_id,
//    		@RequestParam("review_score2") int review_score2,
//    		@RequestParam("review_content2") String review_content2,
			@ModelAttribute Review2Model review2, Model model, HttpSession session) throws Exception {
		// DTO 직접생성
//    	Review2Model review2 = new Review2Model();
//    	review2.setReview_id2(review_id2);
//    	review2.setCon_id(con_id);
//        review2.setReview_score2(review_score2);
//        review2.setReview_content2(review_content2);

		// 파일 교체 또는 유지
		if (!file2.isEmpty()) {
			String filename = file2.getOriginalFilename();
			String path = session.getServletContext().getRealPath("images");
			file2.transferTo(new File(path, filename));
			review2.setReview_file2(filename);
		} else {
			review2.setReview_file2(old_file2);
		}
		// 리뷰 수정
		reservice.updateReview2(review2);
		// 상세페이지로 리다이렉트
		return "redirect:/exhibitioncont?con_id=" + review2.getCon_id() + "&page=" + page;
	}

	// ─── 전시/미술 리뷰 삭제 (GET) ───
	@GetMapping("/exhibitioncont/reviewdelete")
	public String exhbtDeleteReview2(@RequestParam("review_id2") int review_id2, @RequestParam("con_id") int con_id,
			@RequestParam(value = "page", defaultValue = "1") int page, HttpSession session) {
		// 첨부파일 삭제
		String fileName = reservice.selectFile2(review_id2);
		if (fileName != null && !fileName.isBlank()) {
			String path = session.getServletContext().getRealPath("images");
			File f = new File(path, fileName);
			if (f.exists())
				f.delete();
		}
		// 리뷰 삭제
		reservice.deleteReview2(review_id2);
		// 상세페이지로 리다이렉트
		return "redirect:/exhibitioncont?con_id=" + con_id + "&page=" + page;
	}

	// ------------------ 공연 리스트------------------
	@GetMapping("/performancelist")
	public String performancelist(@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value="sort", required=false)  String sort,
			CultureModel culMd,
			Model model) {

		int limit = 12;
		int startRow = (page - 1) * limit + 1;
		int endRow = page * limit;
		
		culMd.setStartRow(startRow);
		culMd.setEndRow(endRow);

		service.addReadCount(culMd);
		
		// 3) 새로 추가한 필드 세팅
        culMd.setSort     (sort);      // mostViewed / newest / endingSoon
		
		// 서비스에서 공연만 조회해 주는 메서드
		List<CultureModel> performancelist = service.getperformancelist(culMd);

		int listcount = service.count2(culMd);
		int pagecount = listcount / limit + (listcount % 10 == 0 ? 0 : 1);
		int startpage = ((page - 1) / 10) * 10 + 1;
		int endpage = Math.min(startpage + 9, pagecount);

		model.addAttribute("performancelist", performancelist);
		model.addAttribute("page", page);
		model.addAttribute("listcount", listcount);
		model.addAttribute("pagecount", pagecount);
		model.addAttribute("startpage", startpage);
		model.addAttribute("endpage", endpage);
		model.addAttribute("search", culMd.getSearch());
		model.addAttribute("keyword", culMd.getKeyword());
		model.addAttribute("mainCategory", "공연");

		return "culture/performancelist";
	}

	// ---------여기서 컨텐츠 상세 페이지 + 댓글 기능 ------------
	// 공연 컨텐츠 상세페이지
	@GetMapping("/performancecont")
	public String performancecont(@RequestParam("con_id") int con_id,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "editReviewId", required = false) Integer editReviewId, CultureModel culMd,
			Model model) throws Exception {

		// 1) 콘텐츠 조회
		culMd.setCon_id(con_id);
		CultureModel performancecont = service.getperformancecont(culMd);
		model.addAttribute("performancecont", performancecont);
		
		service.addReadCount(culMd);


		// 2) 리뷰 페이징 처리
		int pageSize = 10;
		int totalCount = reservice.countReview2(con_id);
		int totalPage = (int) Math.ceil((double) totalCount / pageSize);
		int startRow = (page - 1) * pageSize + 1;
		int endRow = page * pageSize;
		List<Review2Model> reviewlist = reservice.review2List(con_id, startRow, endRow);

		model.addAttribute("reviewlist", reviewlist);
		model.addAttribute("page", page);
		model.addAttribute("totalpage", totalPage);
//        model.addAttribute("", reviewlist)

		// 3) 수정 폼용 리뷰
		if (editReviewId != null) {
			Review2Model editReview = reservice.selectReview2(editReviewId);
			model.addAttribute("editReview", editReview);
		}

		System.out.println("performancecont :" + performancecont);
		return "culture/performancecont";
	}

	// ─── 공연 리뷰 작성 (POST) ───
	// ─── 공연 리뷰 작성 (POST) ───
	@PostMapping("/performancecont/reviewwrite")
	public String performwriteReview2(@RequestParam("review_file22") MultipartFile file2,
			@RequestParam(value = "page", defaultValue = "1") int page, @ModelAttribute Review2Model review2,
			Model model, HttpSession session) throws Exception {
		// 1) DTO에 직접 세팅
//    	Review2Model review2 = new Review2Model();
//        review2.setCon_id(con_id);
//        review2.setReview_score2(review_score2);
//        review2.setReview_content2(review_content2);

		System.out.println("▶▶ review_writer2 = " + review2.getReview_writer2());

		// ★ 실제 경로 찾기 (static/images)
		String uploadPath = session.getServletContext().getRealPath("images");
		String filename = file2.getOriginalFilename();
		int size = (int) file2.getSize();
		String newfilename = "";

		System.out.println("file2: " + file2);
		System.out.println("filename: " + filename);
		System.out.println("size: " + size);
		System.out.println("uploadPath: " + uploadPath);

		if (size > 0) {
			String extension = filename.substring(filename.lastIndexOf(".")).toLowerCase();
			// 확장자 체크
			if (!extension.equals(".jpg") && !extension.equals(".jpeg") && !extension.equals(".png")
					&& !extension.equals(".gif")) {
				model.addAttribute("result2", 2); // 잘못된 확장자

			}
			// 1MB 제한 (필요시 조정)
			if (size > 10240 * 1000) {
				model.addAttribute("result1", 1); // 용량 초과
			}
			// 실제 저장 파일명
			newfilename = UUID.randomUUID().toString() + extension;
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists())
				uploadDir.mkdirs();

			file2.transferTo(new File(uploadPath, newfilename));
			review2.setReview_file2(newfilename);

		}

		// 리뷰 등록
		reservice.insertReview2(review2);
		// 상세페이지로 리다이렉트
		return "redirect:/performancecont?con_id=" + review2.getCon_id() + "&page=" + page;
	}

	// ─── 공연 리뷰 수정 (POST) ───
	@PostMapping("/performancecont/reviewedit")
	public String perfomEditReview2(@RequestParam("review_file22") MultipartFile file2,
			@RequestParam("old_file2") String old_file2, @RequestParam(value = "page", defaultValue = "1") int page,
//    		@RequestParam("review_id2") int review_id2,
//    		@RequestParam("con_id") int con_id,
//    		@RequestParam("review_score2") int review_score2,
//    		@RequestParam("review_content2") String review_content2,
			@ModelAttribute Review2Model review2, Model model, HttpSession session) throws Exception {
		// DTO 직접생성
//    	Review2Model review2 = new Review2Model();
//    	review2.setReview_id2(review_id2);
//    	review2.setCon_id(con_id);
//        review2.setReview_score2(review_score2);
//        review2.setReview_content2(review_content2);

		// 파일 교체 또는 유지
		if (!file2.isEmpty()) {
			String filename = file2.getOriginalFilename();
			String path = session.getServletContext().getRealPath("images");
			file2.transferTo(new File(path, filename));
			review2.setReview_file2(filename);
		} else {
			review2.setReview_file2(old_file2);
		}
		// 리뷰 수정
		reservice.updateReview2(review2);
		// 상세페이지로 리다이렉트
		return "redirect:/performancecont?con_id=" + review2.getCon_id() + "&page=" + page;
	}

	// ─── 공연 리뷰 삭제 (GET) ───
	@GetMapping("/performancecont/reviewdelete")
	public String performDeleteReview2(@RequestParam("review_id2") int review_id2, @RequestParam("con_id") int con_id,
			@RequestParam(value = "page", defaultValue = "1") int page, HttpSession session) {
		// 첨부파일 삭제
		String fileName = reservice.selectFile2(review_id2);
		if (fileName != null && !fileName.isBlank()) {
			String path = session.getServletContext().getRealPath("images");
			File f = new File(path, fileName);
			if (f.exists())
				f.delete();
		}
		// 리뷰 삭제
		reservice.deleteReview2(review_id2);
		// 상세페이지로 리다이렉트
		return "redirect:/performancecont?con_id=" + con_id + "&page=" + page;
	}

//	@GetMapping("/performancecont")
//	public String performancecont(@RequestParam(value = "page", defaultValue = "1") int page, CultureModel culMd,
//			Model model) {
//		CultureModel performancecont = service.getperformancecont(culMd);
//
//		model.addAttribute("page", page);
//		model.addAttribute("performancecont", performancecont);
//
//		return "culture/performancecont"; // 뷰 파일명
//	}

	// ------------------ 축제/행사 리스트------------------
	@GetMapping("/eventlist")
	public String eventlist(@RequestParam(value = "page", defaultValue = "1") int page, 
			@RequestParam(value="sort", required=false)  String sort,
			CultureModel culMd,
			Model model) {

		int limit = 12;
		int startRow = (page - 1) * limit + 1;
		int endRow = page * limit;
		culMd.setStartRow(startRow);
		culMd.setEndRow(endRow);
//		culMd.setCon_age("누구나");

		// 3) 새로 추가한 필드 세팅
        culMd.setSort     (sort);      // mostViewed / newest / endingSoon
        culMd.setStartRow (startRow);
        culMd.setEndRow   (endRow);

		// 서비스에서 공연만 조회해 주는 메서드
		List<CultureModel> eventlist = service.geteventlist(culMd);

		int listcount = service.count3(culMd);
		int pagecount = listcount / limit + (listcount % 10 == 0 ? 0 : 1);
		int startpage = ((page - 1) / 10) * 10 + 1;
		int endpage = Math.min(startpage + 9, pagecount);

		model.addAttribute("eventlist", eventlist);
		model.addAttribute("page", page);
		model.addAttribute("listcount", listcount);
		model.addAttribute("pagecount", pagecount);
		model.addAttribute("startpage", startpage);
		model.addAttribute("endpage", endpage);
		model.addAttribute("search", culMd.getSearch());
		model.addAttribute("keyword", culMd.getKeyword());
		model.addAttribute("mainCategory", "축제/행사");
		model.addAttribute("sort",         sort);

		return "culture/eventlist";
	}

	// ---------여기서 컨텐츠 상세 페이지 + 댓글 기능 ------------
	// 축제/행사 컨텐츠 상세페이지
	@GetMapping("/eventcont")
	public String eventcont(@RequestParam("con_id") int con_id,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "editReviewId", required = false) Integer editReviewId, CultureModel culMd,
			Model model) throws Exception {

//		    CultureModel culMd = new CultureModel();
//	    	System.out.println("culMd : " + culMd);

		// 1) 콘텐츠 조회
		culMd.setCon_id(con_id);
		CultureModel eventcont = service.geteventcont(culMd);
		model.addAttribute("eventcont", eventcont);
		
		service.addReadCount(culMd);


		// 2) 리뷰 페이징 처리
		int pageSize = 10;
		int totalCount = reservice.countReview2(con_id);
		int totalPage = (int) Math.ceil((double) totalCount / pageSize);
		int startRow = (page - 1) * pageSize + 1;
		int endRow = page * pageSize;
		List<Review2Model> reviewlist = reservice.review2List(con_id, startRow, endRow);

		model.addAttribute("reviewlist", reviewlist);
		model.addAttribute("page", page);
		model.addAttribute("totalpage", totalPage);
//	        model.addAttribute("", reviewlist)

		// 3) 수정 폼용 리뷰
		if (editReviewId != null) {
			Review2Model editReview = reservice.selectReview2(editReviewId);
			model.addAttribute("editReview", editReview);
		}

//		System.out.println("eventcont 넘어가는 model : " + model);
//		System.out.println("eventcont 넘어가는 eventcont값 : " + eventcont);
		return "culture/eventcont";
	}

	// ─── 축제/행사 리뷰 작성 (POST) ───
	// ─── 축제/행사 리뷰 작성 (POST) ───
	@PostMapping("/eventcont/reviewwrite")
	public String eventcontWriteReview2(@RequestParam("review_file22") MultipartFile file2,
			@RequestParam(value = "page", defaultValue = "1") int page, @ModelAttribute Review2Model review2,
			Model model, HttpSession session) throws Exception {
		// 1) DTO에 직접 세팅
//	    	Review2Model review2 = new Review2Model();
//	        review2.setCon_id(con_id);
//	        review2.setReview_score2(review_score2);
//	        review2.setReview_content2(review_content2);

		System.out.println("▶▶ review_writer2 = " + review2.getReview_writer2());

		// ★ 실제 경로 찾기 (static/images)
		String uploadPath = session.getServletContext().getRealPath("images");
		String filename = file2.getOriginalFilename();
		int size = (int) file2.getSize();
		String newfilename = "";

		System.out.println("file2: " + file2);
		System.out.println("filename: " + filename);
		System.out.println("size: " + size);
		System.out.println("uploadPath: " + uploadPath);

		if (size > 0) {
			String extension = filename.substring(filename.lastIndexOf(".")).toLowerCase();
			// 확장자 체크
			if (!extension.equals(".jpg") && !extension.equals(".jpeg") && !extension.equals(".png")
					&& !extension.equals(".gif")) {
				model.addAttribute("result2", 2); // 잘못된 확장자

			}
			// 1MB 제한 (필요시 조정)
			if (size > 10240 * 1000) {
				model.addAttribute("result1", 1); // 용량 초과
			}
			// 실제 저장 파일명
			newfilename = UUID.randomUUID().toString() + extension;
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists())
				uploadDir.mkdirs();

			file2.transferTo(new File(uploadPath, newfilename));
			review2.setReview_file2(newfilename);

		}

		// 리뷰 등록
		reservice.insertReview2(review2);
		// 상세페이지로 리다이렉트
		return "redirect:/eventcont?con_id=" + review2.getCon_id() + "&page=" + page;
	}

	// ─── 축제/행사 리뷰 수정 (POST) ───
	@PostMapping("/eventcont/reviewedit")
	public String eventcontEditReview2(@RequestParam("review_file22") MultipartFile file2,
			@RequestParam("old_file2") String old_file2, @RequestParam(value = "page", defaultValue = "1") int page,
//	    		@RequestParam("review_id2") int review_id2,
//	    		@RequestParam("con_id") int con_id,
//	    		@RequestParam("review_score2") int review_score2,
//	    		@RequestParam("review_content2") String review_content2,
			@ModelAttribute Review2Model review2, Model model, HttpSession session) throws Exception {
		// DTO 직접생성
//	    	Review2Model review2 = new Review2Model();
//	    	review2.setReview_id2(review_id2);
//	    	review2.setCon_id(con_id);
//	        review2.setReview_score2(review_score2);
//	        review2.setReview_content2(review_content2);

		// 파일 교체 또는 유지
		if (!file2.isEmpty()) {
			String filename = file2.getOriginalFilename();
			String path = session.getServletContext().getRealPath("images");
			file2.transferTo(new File(path, filename));
			review2.setReview_file2(filename);
		} else {
			review2.setReview_file2(old_file2);
		}
		// 리뷰 수정
		reservice.updateReview2(review2);
		// 상세페이지로 리다이렉트
		return "redirect:/eventcont?con_id=" + review2.getCon_id() + "&page=" + page;
	}

	// ─── 축제/행사 리뷰 삭제 (GET) ───
	@GetMapping("/eventcont/reviewdelete")
	public String eventDeleteReview2(@RequestParam("review_id2") int review_id2, @RequestParam("con_id") int con_id,
			@RequestParam(value = "page", defaultValue = "1") int page, HttpSession session) {
		// 첨부파일 삭제
		String fileName = reservice.selectFile2(review_id2);
		if (fileName != null && !fileName.isBlank()) {
			String path = session.getServletContext().getRealPath("images");
			File f = new File(path, fileName);
			if (f.exists())
				f.delete();
		}
		// 리뷰 삭제
		reservice.deleteReview2(review_id2);
		// 상세페이지로 리다이렉트
		return "redirect:/eventcont?con_id=" + con_id + "&page=" + page;
	}

//	// 축제/행사 컨텐츠 상세페이지
//	@GetMapping("/eventcont")
//	public String eventcont(@RequestParam(value = "page", defaultValue = "1") int page, 
//								CultureModel culMd,
//								Model model) {
//		CultureModel eventcont = service.geteventcont(culMd);
//
//		model.addAttribute("page", page);
//		model.addAttribute("eventcont", eventcont);
//
//		return "culture/eventcont"; // 뷰 파일명
//	}

	/**
	 * 메인페이지에서 들어오는 검색 처리 - mainCategory : all, exhibition, performance, event -
	 * search : con_title, con_location, both - keyword : 검색어
	 */
	@GetMapping("/culturesearch")
	public String search(@RequestParam(value = "mainCategory", defaultValue = "all") String mainCategory,
			@RequestParam(value = "search", defaultValue = "all") String search,
			@RequestParam(value = "keyword", required = false) String keyword,
			@RequestParam(value = "page", defaultValue = "1") int page, CultureModel culMd, Model model) {

		System.out.println("search called : mainCategory=" + mainCategory + ", search=" + search + ",keyword=" + keyword
				+ ", page=" + page);

		// --- DTO 세팅 ---
		// all 이면 category_name=null 처리
		culMd.setCategory_name("all".equals(mainCategory) ? null : mainCategory);
		culMd.setSearch(search);
		culMd.setKeyword(keyword);
//		culMd.setCon_age("누구나");

		// 페이징
		int limit = 12;
		int startRow = (page - 1) * limit + 1;
		int endRow = page * limit;
		culMd.setStartRow(startRow);
		culMd.setEndRow(endRow);

		// --- 2) 서비스 호출 ---
		List<CultureModel> list;
		int totalCount;
		switch (mainCategory) {
		case "all":
			list = service.getallList(culMd);
			totalCount = service.countall(culMd);

//			System.out.println(">>> allList.size() = " + list.size());
			for (CultureModel c : list) {
				System.out.println("  id=" + c.getCon_id() + ", category=" + c.getCategory_name());
			}

			model.addAttribute("allList", list);
			break;
		case "performance":
			list = service.getperformancelist(culMd);
			totalCount = service.count2(culMd);
			model.addAttribute("performancelist", list);
			break;
		case "event":
			list = service.geteventlist(culMd);
			totalCount = service.count3(culMd);
			model.addAttribute("eventlist", list);
			break;
		case "exhibition":
		default:
			list = service.getexhibitionlist(culMd);
			totalCount = service.count(culMd);
			model.addAttribute("exhibitionlist", list);
			break;
		}

		// --- 3) 페이징 계산 & 공통 모델에 담기 ---
		int pagecount = totalCount / limit + (totalCount % limit == 0 ? 0 : 1);
		int startpage = ((page - 1) / 10) * 10 + 1;
		int endpage = Math.min(startpage + 9, pagecount);

		model.addAttribute("page", page);
		model.addAttribute("listcount", totalCount);
		model.addAttribute("pagecount", pagecount);
		model.addAttribute("startpage", startpage);
		model.addAttribute("endpage", endpage);
		model.addAttribute("search", search);
		model.addAttribute("keyword", keyword);
		model.addAttribute("mainCategory", mainCategory);

		// --- 4) 해당 뷰로 포워드 ---
		switch (mainCategory) {
		case "all":
			return "culture/allList";
		case "exhibition":
			return "culture/exhibitionlist";
		case "performance":
			return "culture/performancelist";
		case "event":
			return "culture/eventlist";
		default:
			return "culture/allList";
		}
	}

	// 전체 리스트 페이지
	@RequestMapping("/allList")
	public String allList(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "mainCategory", defaultValue = "all") String mainCategory, 
			@RequestParam(value="sort", required=false)  String sort,
			CultureModel culMd,
			Model model) {

		int limit = 12; // 한 페이지 출력할 데이터 갯수 12개. 두번째 기본변수.
		int listcount = service.count(culMd); // 세번째 기본변수. 총 데이터 갯수 구함. db에서 구해옴

		System.out.println("전체 listcount" + listcount);
		
		service.addReadCount(culMd);

		// 1) 페이징용 startRow/endRow 계산
		// 한 페이지 범위 계산 파생변수 만들기(startRow, endRow)
		int startRow = (page - 1) * limit + 1;
		int endRow = page * limit;

		// 2) 검색·카테고리 세팅
		// culMd.getSearch(), getKeyword(), getMainCategory() 에 요청값 또는 null
		// "all" 이면 전체, 아니면 해당 카테고리
		culMd.setCategory_name("all".equals(mainCategory) ? null : mainCategory);
		// search/keyword 기본값
		if (culMd.getSearch() == null)
			culMd.setSearch("all");
		if (culMd.getKeyword() == null)
			culMd.setKeyword("");

		// --- 1) DTO 세팅 ---
		// 전체 모드: category_name = null
//		culMd.setCon_age("누구나");
		
		// 3) 새로 추가한 필드 세팅
        culMd.setSort     (sort);      // mostViewed / newest / endingSoon
        culMd.setStartRow (startRow);
        culMd.setEndRow   (endRow);
		// 해당 페이지 데이터 조회
		List<CultureModel> allList = service.getallList(culMd);
//				  System.out.println(">>> exhibition.size() = " + exhibition.size());

		System.out.println("=== 페이지네이션 체크 ===");
		System.out.println("현재 page: " + page);
		System.out.println("startRow: " + startRow);
		System.out.println("endRow: " + endRow);
		System.out.println("sort: " + sort);
		System.out.println("allList.size(): " + allList.size());

		for (CultureModel c : allList) {
		    System.out.print(c.getCon_id() + ", ");
		}
		System.out.println("\n=====================");
		
		
		// 총 페이지 수 (10개씩 묶는 건 페이지 번호 블록 크기이지, 한 페이지 아이템 수가 아님)
		int pagecount = listcount / limit + (listcount % limit == 0 ? 0 : 1);
//		int pagecount = (listcount + limit - 1) / limit;
		// 페이지 번호 블록 계산 (한 블록에 10페이지)
		int startpage = ((page - 1) / 10) * 10 + 1;
		int endpage = startpage + 10 - 1;

		if (endpage > pagecount)
			endpage = pagecount;

		List<CultureModel> list;
		list = service.getallList(culMd);

		// --- 4) 모델 바인딩 ---
		model.addAttribute("allList", list);
		model.addAttribute("page", page);
		model.addAttribute("listcount", listcount);
		model.addAttribute("pagecount", pagecount);
		model.addAttribute("startpage", startpage);
		model.addAttribute("endpage", endpage);
		model.addAttribute("mainCategory", "all");
		model.addAttribute("sort",         sort);

//				// 검색
//				model.addAttribute("search", culMd.getSearch());
//				model.addAttribute("keyword", culMd.getKeyword());
		
		System.out.println("pagecount = " + pagecount);
		System.out.println("startpage = " + startpage);
		System.out.println("endpage = " + endpage);

		return "culture/allList";
	}

	@RequestMapping("/allList-mini")
	public String allListMini(
	    @RequestParam("sort") String sort,
	    Model model
	) {
	    List<CultureModel> miniList = service.getallListMini(sort); // 7개 제한 쿼리
	    model.addAttribute("miniList", miniList);
	    return "culture/miniList"; // 미니 카드 JSP
	}
	
	
}
