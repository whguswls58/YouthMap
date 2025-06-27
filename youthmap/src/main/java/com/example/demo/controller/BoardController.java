package com.example.demo.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletResponse;
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

    // 업로드 디렉토리 초기화
    @PostConstruct
    public void init() {
        File uploadDirectory = new File(uploadDir);
        if (!uploadDirectory.exists()) {
            uploadDirectory.mkdirs();
            System.out.println("업로드 디렉토리 생성: " + uploadDir);
        } else {
            System.out.println("업로드 디렉토리 확인: " + uploadDir);
        }
    }

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
        if (category != null && !category.isEmpty()) {
            map.put("category", category);
            // 공지카테고리가 아닌 경우에만 공지사항 제외
            if (!"공지".equals(category)) {
                map.put("excludeCategory", "공지");
            }
        } else {
            // 전체카테고리인 경우 공지사항 제외
            map.put("excludeCategory", "공지");
        }
        map.put("searchType", searchType);
        map.put("keyword", keyword);
        map.put("startRow", startRow);
        map.put("endRow", endRow);

        List<Board> boardlist = boardService.list(map);
        
        // 일반 게시글만 카운트 (공지사항 제외)
        Map<String,Object> countMap = new HashMap<>();
        if (category != null && !category.isEmpty()) {
            countMap.put("category", category);
            // 공지카테고리가 아닌 경우에만 공지사항 제외
            if (!"공지".equals(category)) {
                countMap.put("excludeCategory", "공지");
            }
        } else {
            // 전체카테고리인 경우 공지사항 제외
            countMap.put("excludeCategory", "공지");
        }
        countMap.put("searchType", searchType);
        countMap.put("keyword", keyword);
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
            @RequestParam(value = "uploadFile", required = false) MultipartFile uploadFile,
            HttpSession session) throws Exception {

        MemberModel m = (MemberModel)session.getAttribute("loginMember");
        if (m == null) return "redirect:/login";

        board.setMemId(m.getMemId());
        board.setMemNo(m.getMemNo().intValue());

        int newNo = boardService.getNextBoardNo();
        board.setBoardNo(newNo);
        boardService.insert(board);

        // 첨부파일이 있을 때만 처리
        if (uploadFile != null && !uploadFile.isEmpty()) {
            try {
                String orig = uploadFile.getOriginalFilename();
                String saved = UUID.randomUUID() + "_" + orig;
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();
                File f = new File(dir, saved);
                uploadFile.transferTo(f);

                System.out.println("파일 업로드 성공:");
                System.out.println("  원본 파일명: " + orig);
                System.out.println("  저장 파일명: " + saved);
                System.out.println("  저장 경로: " + f.getAbsolutePath());
                System.out.println("  파일 크기: " + f.length() + " bytes");

                UserFile uf = new UserFile();
                uf.setBoardNo(newNo);
                uf.setUserFileName(orig);
                uf.setUserFilPath(saved);
                boardService.saveFile(uf);
                
                System.out.println("DB에 파일 정보 저장 완료");
            } catch (Exception e) {
                // 파일 업로드 실패 시에도 게시글은 저장되도록 함
                System.err.println("파일 업로드 실패: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            System.out.println("첨부파일이 없습니다.");
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

        // 디버깅 로그
        System.out.println("게시글 번호: " + no);
        System.out.println("전체 파일 수: " + files.size());
        files.forEach(file -> System.out.println("파일: " + file.getUserFileName() + " (이미지: " + isImageFile(file.getUserFileName()) + ")"));

        // 이미지 파일과 일반 파일 분리
        List<UserFile> imageFiles = files.stream()
            .filter(file -> isImageFile(file.getUserFileName()))
            .collect(java.util.stream.Collectors.toList());
        
        List<UserFile> otherFiles = files.stream()
            .filter(file -> !isImageFile(file.getUserFileName()))
            .collect(java.util.stream.Collectors.toList());

        System.out.println("이미지 파일 수: " + imageFiles.size());
        System.out.println("일반 파일 수: " + otherFiles.size());

        model.addAttribute("board", b);
        model.addAttribute("fileList", files);
        model.addAttribute("imageFiles", imageFiles);
        model.addAttribute("otherFiles", otherFiles);
        // JSP: /WEB-INF/views/board/boardview.jsp
        return "board/boardview";
    }

    // 이미지 파일인지 확인하는 메서드
    private boolean isImageFile(String fileName) {
        if (fileName == null) return false;
        String lowerFileName = fileName.toLowerCase();
        return lowerFileName.endsWith(".jpg") || lowerFileName.endsWith(".jpeg") 
            || lowerFileName.endsWith(".png") || lowerFileName.endsWith(".gif") 
            || lowerFileName.endsWith(".bmp") || lowerFileName.endsWith(".webp");
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

        // 기존 파일 삭제 처리
        if (deleteFiles != null && !deleteFiles.isEmpty()) {
            for (String path : deleteFiles) {
                try {
                    new File(uploadDir, path).delete();
                    userFileDao.deleteByPath(path);
                } catch (Exception e) {
                    System.err.println("파일 삭제 실패: " + e.getMessage());
                }
            }
        }
        
        // 새 파일 업로드 처리
        if (uploadFile != null && !uploadFile.isEmpty()) {
            try {
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
            } catch (Exception e) {
                System.err.println("파일 업로드 실패: " + e.getMessage());
            }
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

    @GetMapping("/download")
    public void download(@RequestParam("file") String fileName, HttpServletResponse response) throws Exception {
        File file = new File(uploadDir, fileName);
        if (file.exists()) {
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(fileName, "UTF-8"));
            try (FileInputStream fis = new FileInputStream(file);
                 OutputStream os = response.getOutputStream()) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
            }
        }
    }

    @GetMapping("/filedownload")
    public void fileDownload(@RequestParam("filename") String filename,
                             @RequestParam("origin") String origin,
                             HttpServletResponse response) throws Exception {

        // 저장된 파일 경로
        String savePath = uploadDir + "/" + filename;
        File file = new File(savePath);

        if (file.exists()) {
            response.setContentType("application/octet-stream");
            String encoded = URLEncoder.encode(origin, "UTF-8").replaceAll("\\+", "%20");
            response.setHeader("Content-Disposition", "attachment;filename=" + encoded);
            response.setContentLength((int) file.length());

            FileInputStream in = new FileInputStream(file);
            OutputStream out = response.getOutputStream();

            byte[] buffer = new byte[1024];
            int len;
            while ((len = in.read(buffer)) > 0) {
                out.write(buffer, 0, len);
            }

            in.close();
            out.close();
        }
    }

    @GetMapping("/fileview")
    public void fileView(@RequestParam("filename") String filename,
                         @RequestParam("origin") String origin,
                         HttpServletResponse response) throws Exception {

        // 저장된 파일 경로
        String savePath = uploadDir + "/" + filename;
        File file = new File(savePath);

        System.out.println("파일 경로: " + savePath);
        System.out.println("파일 존재: " + file.exists());

        if (file.exists()) {
            // 파일 확장자에 따른 Content-Type 설정
            String contentType = getContentType(origin);
            response.setContentType(contentType);
            response.setContentLength((int) file.length());

            FileInputStream in = new FileInputStream(file);
            OutputStream out = response.getOutputStream();

            byte[] buffer = new byte[1024];
            int len;
            while ((len = in.read(buffer)) > 0) {
                out.write(buffer, 0, len);
            }

            in.close();
            out.close();
        } else {
            System.err.println("파일을 찾을 수 없습니다: " + savePath);
        }
    }

    private String getContentType(String fileName) {
        if (fileName == null) return "application/octet-stream";
        
        String lowerFileName = fileName.toLowerCase();
        if (lowerFileName.endsWith(".jpg") || lowerFileName.endsWith(".jpeg")) {
            return "image/jpeg";
        } else if (lowerFileName.endsWith(".png")) {
            return "image/png";
        } else if (lowerFileName.endsWith(".gif")) {
            return "image/gif";
        } else if (lowerFileName.endsWith(".bmp")) {
            return "image/bmp";
        } else if (lowerFileName.endsWith(".webp")) {
            return "image/webp";
        } else if (lowerFileName.endsWith(".pdf")) {
            return "application/pdf";
        } else if (lowerFileName.endsWith(".txt")) {
            return "text/plain";
        } else {
            return "application/octet-stream";
        }
    }
}



