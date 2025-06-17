package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import java.io.File;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.model.Board;
import com.example.demo.service.BoardService;
import com.example.demo.model.UserFile;
import com.example.demo.dao.UserFileDao;

import jakarta.servlet.http.HttpSession;

@Controller
public class BoardController {
	
	@Autowired
    private BoardService boardService;
	
	@Autowired
	private UserFileDao userFileDao;
	
	@Value("${file.upload.directory}")
	private String uploadDir; // 파일이 저장된 실제 폴더 경로

	// 📄 게시글 목록 + 페이징 + 카테고리 필터
	@GetMapping("/boardlist")
	public String boardlist(@RequestParam(value = "page", defaultValue = "1") int page,
	                        @RequestParam(value = "category", required = false) String category,
	                        @RequestParam(value = "searchType", required = false) String searchType,
	                        @RequestParam(value = "keyword", required = false) String keyword,
	                        Model model) {

	    int limit = 7;  // 공지사항 3개 + 일반글 7개 = 10개
	    int start = (page - 1) * limit;
	    int end = page * limit;

	    // 📌 공지사항은 항상 상단 고정
	    List<Board> noticeList = boardService.getTopNotices();
	    model.addAttribute("topNotices", noticeList);

	    // 📌 일반 게시글 조건 설정 (공지사항 제외)
	    Map<String, Object> map = new HashMap<>();
	    map.put("start", start + 1);
	    map.put("end", end);
	    if (category != null && !category.isEmpty()) {
	        map.put("category", category);
	    }
	    map.put("searchType", searchType);
	    map.put("keyword", keyword);
	    map.put("excludeCategory", "공지");  // 🔥 공지사항 제외 조건 추가

	    List<Board> boardlist = boardService.list(map);
	    int listcount = boardService.count(map);

	    int pagecount = listcount / limit + (listcount % limit == 0 ? 0 : 1);
	    int startpage = ((page - 1) / 10) * 10 + 1;
	    int endpage = startpage + 9;
	    if (endpage > pagecount) endpage = pagecount;

	    model.addAttribute("boardlist", boardlist);
	    model.addAttribute("listcount", listcount);
	    model.addAttribute("page", page);
	    model.addAttribute("pagecount", pagecount);
	    model.addAttribute("startpage", startpage);
	    model.addAttribute("endpage", endpage);
	    model.addAttribute("category", category);
	    model.addAttribute("searchType", searchType);
	    model.addAttribute("keyword", keyword);

	    return "userBoardPage/boardlist";
	}

    // ✅ 글쓰기 처리
    @PostMapping("/boardwrite")
    public String write(@ModelAttribute Board board,
                        @RequestParam("uploadFile") MultipartFile uploadFile,
                        HttpSession session) throws Exception {

        System.out.println("✅ 글쓰기 컨트롤러 도착");

        String memId = (String) session.getAttribute("loginId");
        Integer memNo = (Integer) session.getAttribute("loginNo");
        String loginRole = (String) session.getAttribute("loginRole");

        if (memId == null || memNo == null) {
            return "redirect:/temp-login";
        }
        
     // ✅ 공지사항 작성 권한 검사
        if ("공지사항".equals(board.getBoardCategory()) && !"ADMIN".equals(loginRole)) {
            System.out.println("⛔ 일반 사용자가 공지사항 작성 시도");
            return "redirect:/boardlist"; // or 경고 페이지
        }

        board.setMemId(memId);
        board.setMemNo(memNo);

        try {
            // 🔹 1. 시퀀스로 boardNo 미리 확보
            int boardNo = boardService.getNextBoardNo();
            board.setBoardNo(boardNo); // board 객체에 설정

            // 🔹 2. 게시글 저장
            boardService.insert(board);

            // 🔹 3. 파일 저장 (있다면)
            if (!uploadFile.isEmpty()) {
                String originalName = uploadFile.getOriginalFilename();

                // 🔁 중복 방지 파일명 처리
                String uuid = UUID.randomUUID().toString();
                String savedName = uuid + "_" + originalName;

                // 🗂 저장 경로
                String uploadPath = "C:/upload/";
                File uploadFolder = new File(uploadPath);
                if (!uploadFolder.exists()) {
                    uploadFolder.mkdirs();
                }

                // 💾 파일 저장
                File saveFile = new File(uploadPath + savedName);
                uploadFile.transferTo(saveFile);

                // 🗃 DB 저장
                UserFile file = new UserFile();
                file.setBoardNo(boardNo); // 반드시 시퀀스에서 확보한 boardNo 사용
                file.setUserFileName(originalName);   // 사용자가 업로드한 이름
                file.setUserFilPath(savedName);       // 실제 서버에 저장된 이름

                boardService.saveFile(file);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }

        return "redirect:/boardlist";
    }
    
 // ✅ 이 메서드가 있어야 글쓰기 페이지 열기 가능
    @GetMapping("/boardwrite")
    public String boardWriteForm(Model model) {
        return "userBoardPage/writeform"; // 너의 JSP 경로에 맞춰서
    }

    // 👁 게시글 상세보기 + 조회수 증가
    @GetMapping("/boardview")
    public String view(@RequestParam("no") int no, Model model) {
        boardService.updatecount(no); // 조회수 증가
        Board board = boardService.content(no);

        // 줄바꿈 처리 (boardContent 기준)
        String formattedContent = board.getBoardContent().replace("\n", "<br>");
        board.setBoardContent(formattedContent);
        
     // 첨부파일 목록 가져오기
        List<UserFile> fileList = boardService.getFilesByBoardNo(no);
        model.addAttribute("fileList", fileList);


        model.addAttribute("board", board);
        return "userBoardPage/boardview";
    }

    // ✏ 글수정 폼
    @GetMapping("/boardupdateform")
    public String updateForm(@RequestParam("no") int no, Model model) {
        Board board = boardService.content(no);
        model.addAttribute("board", board);

        // 🔽 이거 꼭 필요함!
        List<UserFile> fileList = boardService.getFilesByBoardNo(no);
        model.addAttribute("fileList", fileList);

        return "userBoardPage/updateform";
    }

    // ✅ 글수정 처리
    @PostMapping("/boardupdate")
    public String update(Board board,
                         @RequestParam(value = "deleteFile", required = false) List<String> deleteFiles,
                         @RequestParam(value = "uploadFile", required = false) MultipartFile uploadFile) {
        try {
            // 1. 게시글 내용 수정
            boardService.update(board);

            // 2. 체크된 기존 첨부파일 삭제
            if (deleteFiles != null) {
                for (String filename : deleteFiles) {
                    // 실제 파일 삭제
                    File file = new File("C:/upload/" + filename);
                    if (file.exists()) file.delete();

                    // DB에서 삭제
                    userFileDao.deleteByPath(filename);
                }
            }

            // 3. 새 파일 업로드 (있는 경우에만)
            if (uploadFile != null && !uploadFile.isEmpty()) {
                String originalName = uploadFile.getOriginalFilename();
                String uuid = UUID.randomUUID().toString();
                String savedName = uuid + "_" + originalName;

                File uploadFolder = new File("C:/upload/");
                if (!uploadFolder.exists()) uploadFolder.mkdirs();

                File saveFile = new File(uploadFolder, savedName);
                uploadFile.transferTo(saveFile);

                UserFile newFile = new UserFile();
                newFile.setBoardNo(board.getBoardNo());
                newFile.setUserFileName(originalName);
                newFile.setUserFilPath(savedName);

                boardService.saveFile(newFile);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }

        return "redirect:/boardlist";
    }

    // ❌ 글삭제
    @GetMapping("/boarddelete")
    public String delete(@RequestParam("no") int no, HttpSession session) {
        // 세션 정보 확인
        String loginId = (String) session.getAttribute("loginId");
        String loginRole = (String) session.getAttribute("loginRole");

        // 로그인 여부 확인
        if (loginId == null) {
            return "redirect:/login";
        }

        // 삭제 대상 게시글 정보 조회
        Board board = boardService.detail(no);
        if (board == null) {
            return "error"; // 또는 적절한 에러 페이지
        }

        // 권한 체크: 작성자 본인 또는 관리자
        if (!loginId.equals(board.getMemId()) && !"ADMIN".equals(loginRole)) {
            return "redirect:/boardlist"; // 권한 없음
        }

        // 1. 첨부파일 삭제
        List<UserFile> fileList = userFileDao.listByBoardNo(no);
        for (UserFile file : fileList) {
            File target = new File(uploadDir, file.getUserFilPath());
            if (target.exists()) {
                target.delete();
            }
        }

        // 2. 게시글 삭제 (첨부파일은 ON DELETE CASCADE)
        boardService.delete(no);

        return "redirect:/boardlist";
    }
    
    @GetMapping("/boarddeleteform")
    public String deleteForm(@RequestParam("no") int no, Model model) {
        Board board = boardService.content(no);
        model.addAttribute("board", board);
        return "userBoardPage/deleteconfirm";
    }

}
