package com.example.demo.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.dao.UserFileDao;
import com.example.demo.model.Board;
import com.example.demo.model.MemberModel;
import com.example.demo.model.UserFile;
import com.example.demo.service.BoardService;

@Controller
public class BoardController {

    @Autowired
    private BoardService boardService;

    @Autowired
    private UserFileDao userFileDao;

    @Value("${file.upload.directory}")
    private String uploadDir;

    /** 1) `/board` 요청이 들어오면 `boardlist` 로 리다이렉트 */
    @GetMapping("/board")
    public String redirectToList() {
        return "redirect:/boardlist";
    }

    /** 2) 게시글 목록 */
    @GetMapping("/boardlist")
    public String boardlist(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "searchType", required = false) String searchType,
            @RequestParam(value = "keyword", required = false) String keyword,
            Model model) {

        // 공지사항
        List<Board> notices = boardService.getTopNotices();
        model.addAttribute("topNotices", notices);

        // 페이징 설정
        int pageSize = 10; // 페이지당 게시글 수
        int startRow = (page - 1) * pageSize + 1;
        int endRow = page * pageSize;

        // 일반 글
        Map<String,Object> map = new HashMap<>();
        if (category != null && !category.isEmpty()) map.put("category", category);
        map.put("searchType", searchType);
        map.put("keyword", keyword);
        map.put("excludeCategory", "공지사항");
        map.put("startRow", startRow);
        map.put("endRow", endRow);

        List<Board> boardlist = boardService.list(map);
        
        // 일반 게시글만 카운트 (공지사항 제외)
        Map<String,Object> countMap = new HashMap<>();
        if (category != null && !category.isEmpty()) countMap.put("category", category);
        countMap.put("searchType", searchType);
        countMap.put("keyword", keyword);
        countMap.put("excludeCategory", "공지사항");
        int count = boardService.count(countMap);

        // 페이징 정보 계산
        int totalPages = (int) Math.ceil((double) count / pageSize);
        int startPage = ((page - 1) / 5) * 5 + 1; // 5개씩 페이지 번호 표시
        int endPage = Math.min(startPage + 4, totalPages);

        model.addAttribute("boardlist", boardlist);
        model.addAttribute("listcount", count);
        model.addAttribute("page", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("category", category);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);

        // JSP: /WEB-INF/views/board/boardlist.jsp
        return "board/boardlist";
    }

    /** 3) 글쓰기 폼 */
    @GetMapping("/boardwrite")
    public String writeForm(HttpSession session) {
        if (session.getAttribute("loginMember") == null) {
            return "redirect:/login";
        }
        return "board/writeform";
    }

    /** 4) 글쓰기 처리 */
    @PostMapping("/boardwrite")
    public String write(
            @ModelAttribute Board board,
            @RequestParam("uploadFile") MultipartFile uploadFile,
            HttpSession session) throws Exception {

        MemberModel m = (MemberModel)session.getAttribute("loginMember");
        if (m == null) return "redirect:/login";

        board.setMemId(m.getMemId());
        board.setMemNo(m.getMemNo().intValue());

        int newNo = boardService.getNextBoardNo();
        board.setBoardNo(newNo);
        boardService.insert(board);

        if (!uploadFile.isEmpty()) {
            String orig = uploadFile.getOriginalFilename();
            String saved = UUID.randomUUID() + "_" + orig;
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();
            File f = new File(dir, saved);
            uploadFile.transferTo(f);

            UserFile uf = new UserFile();
            uf.setBoardNo(newNo);
            uf.setUserFileName(orig);
            uf.setUserFilPath(saved);
            boardService.saveFile(uf);
        }

        return "redirect:/boardlist";
    }

    /** 5) 상세보기 */
    @GetMapping("/boardview")
    public String view(@RequestParam("no") int no, Model model) {
        boardService.updatecount(no);
        Board b = boardService.content(no);
        b.setBoardContent(b.getBoardContent().replace("\n","<br>"));
        List<UserFile> files = boardService.getFilesByBoardNo(no);

        model.addAttribute("board", b);
        model.addAttribute("fileList", files);
        // JSP: /WEB-INF/views/board/boardview.jsp
        return "board/boardview";
    }

    /** 6) 수정폼 */
    @GetMapping("/boardupdateform")
    public String updateForm(@RequestParam("no") int no,
                             Model model,
                             HttpSession session) {
        if (session.getAttribute("loginMember")==null) {
            return "redirect:/login";
        }
        Board b = boardService.content(no);
        List<UserFile> files = boardService.getFilesByBoardNo(no);
        model.addAttribute("board", b);
        model.addAttribute("fileList", files);
        return "board/updateform";
    }

    /** 7) 수정 처리 */
    @PostMapping("/boardupdate")
    public String update(Board board,
                         @RequestParam(value="deleteFile", required=false) List<String> deleteFiles,
                         @RequestParam(value="uploadFile", required=false) MultipartFile uploadFile) throws Exception {

        boardService.update(board);

        if (deleteFiles != null) {
            for (String path : deleteFiles) {
                new File(uploadDir, path).delete();
                userFileDao.deleteByPath(path);
            }
        }
        if (uploadFile != null && !uploadFile.isEmpty()) {
            String orig = uploadFile.getOriginalFilename();
            String saved = UUID.randomUUID()+"_"+orig;
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();
            uploadFile.transferTo(new File(dir, saved));

            UserFile uf = new UserFile();
            uf.setBoardNo(board.getBoardNo());
            uf.setUserFileName(orig);
            uf.setUserFilPath(saved);
            boardService.saveFile(uf);
        }

        return "redirect:/boardlist";
    }

    /** 8) 삭제 */
    @GetMapping("/boarddelete")
    public String delete(@RequestParam("boardNo") int boardNo,
                         HttpSession session) {

        MemberModel m = (MemberModel)session.getAttribute("loginMember");
        if (m==null) return "redirect:/login";

        Board b = boardService.content(boardNo);
        if (!m.getMemId().equals(b.getMemId()) && !"ADMIN".equals(m.getMemType())) {
            return "redirect:/boardlist";
        }

        for (UserFile uf : userFileDao.listByBoardNo(boardNo)) {
            new File(uploadDir, uf.getUserFilPath()).delete();
        }
        boardService.delete(boardNo);
        return "redirect:/boardlist";
    }

    /** 9) 삭제 확인폼 */
    @GetMapping("/boarddeleteform")
    public String deleteForm(@RequestParam("no") int no, Model model) {
        model.addAttribute("board", boardService.content(no));
        return "board/deleteconfirm";
    }
}



