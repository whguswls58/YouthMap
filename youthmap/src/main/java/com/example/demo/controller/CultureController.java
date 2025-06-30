package com.example.demo.controller;

import java.io.File;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.model.CultureModel;
import com.example.demo.model.MemberModel;
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
        return "redirect:/admin/dashboard";   
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
		int pagecount = listcount / limit + (listcount % 12 == 0 ? 0 : 1);

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
	@PostMapping("/exhibitioncont/reviewwrite")
	public String exhbtWriteReview2(@RequestParam("review_file22") MultipartFile file2,
			@RequestParam(value = "page", defaultValue = "1") int page, @ModelAttribute Review2Model review2,
			Model model, HttpSession session) throws Exception {
		
		System.out.println("현재 상세글 ID : " + review2.getCon_id());
		
		// 로그인 체크
		MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/login";
		}

		// 작성자 정보 설정
		review2.setMem_no(loginMember.getMemNo().intValue());

		// ★ 실제 경로 찾기 (static/images)
		String uploadPath = session.getServletContext().getRealPath("images");
		// 경로가 null이면 기본 경로 사용
		if (uploadPath == null) {
			uploadPath = System.getProperty("user.home") + "/images";
		}
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
			if (!extension.matches("\\.(jpg|jpeg|png|gif)")) {
				return "redirect:/exhibitioncont?con_id=" + review2.getCon_id();
			}
			// 1MB 제한 (필요시 조정)
			if (size > 1024 * 1024) {
				return "redirect:/exhibitioncont?con_id=" + review2.getCon_id();
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
			@ModelAttribute Review2Model review2, Model model, HttpSession session) throws Exception {
		
		// 로그인 체크
		MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/login";
		}

		// 작성자 정보 설정
		review2.setMem_no(loginMember.getMemNo().intValue());

		// 작성자 확인
		if (reservice.checkReview2Author(review2) == 0) {
			return "redirect:/exhibitioncont?con_id=" + review2.getCon_id();
		}

		// 파일 교체 또는 유지
		if (!file2.isEmpty()) {
			String filename = file2.getOriginalFilename();
			String extension = filename.substring(filename.lastIndexOf(".")).toLowerCase();
			if (!extension.matches("\\.(jpg|jpeg|png|gif)")) {
				return "redirect:/exhibitioncont?con_id=" + review2.getCon_id();
			}
			String newfilename = UUID.randomUUID().toString() + extension;
			String path = session.getServletContext().getRealPath("images");
			// 경로가 null이면 기본 경로 사용
			if (path == null) {
				path = System.getProperty("user.home") + "/images";
			}
			File uploadDir = new File(path);
			if (!uploadDir.exists()) {
				uploadDir.mkdirs();
			}
			file2.transferTo(new File(path, newfilename));
			review2.setReview_file2(newfilename);
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
		
		// 로그인 체크
		MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/login";
		}

		// Review2Model 객체 생성하여 작성자 정보 설정
		Review2Model review2 = new Review2Model();
		review2.setReview_id2(review_id2);
		review2.setMem_no(loginMember.getMemNo().intValue());

		// 작성자 확인
		if (reservice.checkReview2Author(review2) == 0) {
			return "redirect:/exhibitioncont?con_id=" + con_id;
		}

		// 첨부파일 삭제
		String fileName = reservice.selectFile2(review_id2);
		if (fileName != null && !fileName.trim().isEmpty()) {
			String path = session.getServletContext().getRealPath("images");
			// 경로가 null이면 기본 경로 사용
			if (path == null) {
				path = System.getProperty("user.home") + "/images";
			}
			File file = new File(path, fileName);
			if (file.exists()) file.delete();
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
		
		for (CultureModel c : performancelist) {
		    System.out.println("공연 con_id: " + c.getCon_id());
		}

		int listcount = service.count2(culMd);		// 총 데이터 갯수
		int pagecount = listcount / limit + (listcount % 12 == 0 ? 0 : 1);		// 총 페이지 수
		int startpage = ((page - 1) / 10) * 10 + 1;
		int endpage = startpage + 10 - 1;
		
		if (endpage > pagecount)
			endpage = pagecount;

		System.out.println("listcount : " + listcount);
		System.out.println("pagecount : " + pagecount);
		System.out.println("startRow: " + startRow);
		System.out.println("endRow: " + endRow);
		System.out.println("startpage : " + startpage);
		System.out.println("endpage : " + endpage);
		
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
	@PostMapping("/performancecont/reviewwrite")
	public String performwriteReview2(@RequestParam("review_file22") MultipartFile file2,
			@RequestParam(value = "page", defaultValue = "1") int page, @ModelAttribute Review2Model review2,
			Model model, HttpSession session) throws Exception {
		
		// 로그인 체크
		MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/login";
		}

		// 작성자 정보 설정
		review2.setMem_no(loginMember.getMemNo().intValue());

		// ★ 실제 경로 찾기 (static/images)
		String uploadPath = session.getServletContext().getRealPath("images");
		// 경로가 null이면 기본 경로 사용
		if (uploadPath == null) {
			uploadPath = System.getProperty("user.home") + "/images";
		}
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
			if (!extension.matches("\\.(jpg|jpeg|png|gif)")) {
				return "redirect:/performancecont?con_id=" + review2.getCon_id();
			}
			// 1MB 제한 (필요시 조정)
			if (size > 1024 * 1024) {
				return "redirect:/performancecont?con_id=" + review2.getCon_id();
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
			@ModelAttribute Review2Model review2, Model model, HttpSession session) throws Exception {
		
		// 로그인 체크
		MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/login";
		}

		// 작성자 정보 설정
		review2.setMem_no(loginMember.getMemNo().intValue());

		// 작성자 확인
		if (reservice.checkReview2Author(review2) == 0) {
			return "redirect:/performancecont?con_id=" + review2.getCon_id();
		}

		// 파일 교체 또는 유지
		if (!file2.isEmpty()) {
			String filename = file2.getOriginalFilename();
			String extension = filename.substring(filename.lastIndexOf(".")).toLowerCase();
			if (!extension.matches("\\.(jpg|jpeg|png|gif)")) {
				return "redirect:/performancecont?con_id=" + review2.getCon_id();
			}
			String newfilename = UUID.randomUUID().toString() + extension;
			String path = session.getServletContext().getRealPath("images");
			// 경로가 null이면 기본 경로 사용
			if (path == null) {
				path = System.getProperty("user.home") + "/images";
			}
			File uploadDir = new File(path);
			if (!uploadDir.exists()) {
				uploadDir.mkdirs();
			}
			file2.transferTo(new File(path, newfilename));
			review2.setReview_file2(newfilename);
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
		
		// 로그인 체크
		MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/login";
		}

		// Review2Model 객체 생성하여 작성자 정보 설정
		Review2Model review2 = new Review2Model();
		review2.setReview_id2(review_id2);
		review2.setMem_no(loginMember.getMemNo().intValue());

		// 작성자 확인
		if (reservice.checkReview2Author(review2) == 0) {
			return "redirect:/performancecont?con_id=" + con_id;
		}

		// 첨부파일 삭제
		String fileName = reservice.selectFile2(review_id2);
		if (fileName != null && !fileName.trim().isEmpty()) {
			String path = session.getServletContext().getRealPath("images");
			// 경로가 null이면 기본 경로 사용
			if (path == null) {
				path = System.getProperty("user.home") + "/images";
			}
			File file = new File(path, fileName);
			if (file.exists()) file.delete();
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
		int pagecount = listcount / limit + (listcount % 12 == 0 ? 0 : 1);
		int startpage = ((page - 1) / 10) * 10 + 1;
		int endpage = startpage + 10 - 1;
		
		if (endpage > pagecount)
			endpage = pagecount;

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
	@PostMapping("/eventcont/reviewwrite")
	public String eventcontWriteReview2(@RequestParam("review_file22") MultipartFile file2,
			@RequestParam(value = "page", defaultValue = "1") int page, @ModelAttribute Review2Model review2,
			Model model, HttpSession session) throws Exception {
		
		// 로그인 체크
		MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/login";
		}

		// 작성자 정보 설정
		review2.setMem_no(loginMember.getMemNo().intValue());

		// ★ 실제 경로 찾기 (static/images)
		String uploadPath = session.getServletContext().getRealPath("images");
		// 경로가 null이면 기본 경로 사용
		if (uploadPath == null) {
			uploadPath = System.getProperty("user.home") + "/images";
		}
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
			if (!extension.matches("\\.(jpg|jpeg|png|gif)")) {
				return "redirect:/eventcont?con_id=" + review2.getCon_id();
			}
			// 1MB 제한 (필요시 조정)
			if (size > 1024 * 1024) {
				return "redirect:/eventcont?con_id=" + review2.getCon_id();
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
		int endpage = startpage + 10 - 1;

		if (endpage > pagecount)
			endpage = pagecount;
		
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

	    int limit = 12;
	    int startRow = (page - 1) * limit + 1;
	    int endRow   = page * limit;

	    // 정렬, 페이징 세팅
	    culMd.setSort(sort);
	    culMd.setStartRow(startRow);
	    culMd.setEndRow(endRow);

	    // 검색/키워드 기본값 세팅
	    if (culMd.getSearch() == null)   culMd.setSearch("all");
	    if (culMd.getKeyword() == null)  culMd.setKeyword("");

	    // 💡 쿼리 분기 (mainCategory에 따라)
	    int listcount = 0;
	    List<CultureModel> list = null;

	    if ("all".equals(mainCategory)) {
	        listcount = service.countall(culMd);
	        list = service.getallList(culMd);
	    } else if ("전시/미술".equals(mainCategory)) {
	        culMd.setCategory_name("전시/미술");
	        listcount = service.count(culMd);
	        list = service.getexhibitionlist(culMd);
	    } else if ("공연".equals(mainCategory)) {
	        // 공연: 여러 카테고리를 IN 조건으로
	        culMd.setCategory_names(Arrays.asList("콘서트","연극","뮤지컬/오페라","국악", "독주회", "클래식","무용"));
	        listcount = service.count2(culMd);
	        list = service.getperformancelist(culMd);
	    } else if ("축제/행사".equals(mainCategory)) {
	        culMd.setCategory_names(Arrays.asList("축제-기타","축제-시민화합","축제-자연/경관","축제-문화/예술"));
	        listcount = service.count3(culMd);
	        list = service.geteventlist(culMd);
	    } else {
	    	// 혹시 모를 기타 분기
	        listcount = service.countall(culMd);
	        list = service.getallList(culMd);
	    }

	    int pagecount = (listcount + limit - 1) / limit;
	    int startpage = ((page - 1) / 10) * 10 + 1;
	    int endpage = startpage + 10 - 1;

	    if (endpage > pagecount)
			endpage = pagecount;
	    
	    model.addAttribute("allList", list);
	    model.addAttribute("page", page);
	    model.addAttribute("listcount", listcount);
	    model.addAttribute("pagecount", pagecount);
	    model.addAttribute("startpage", startpage);
	    model.addAttribute("endpage", endpage);
	    model.addAttribute("mainCategory", mainCategory);
	    model.addAttribute("sort", sort);

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
