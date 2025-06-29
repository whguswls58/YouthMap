package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.dao.BoardDao;
import com.example.demo.dao.UserFileDao;
import com.example.demo.model.Board;
import com.example.demo.model.UserFile;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dao.BoardDao;
import com.example.demo.dao.UserFileDao;
import com.example.demo.model.Board;
import com.example.demo.model.UserFile;

@Service
public class BoardService {

    @Autowired
    private BoardDao boardDao;

    @Autowired
    private UserFileDao userFileDao;

    public int getNextBoardNo() {
        return boardDao.getNextBoardNo(); // 시퀀스 미리 조회
    }

    public int insert(Board board) {
        return boardDao.insert(board);
    }

    public int count(Map<String, Object> map) {
        return boardDao.count(map);
    }

    public List<Board> list(Map<String, Object> map) {
        return boardDao.list(map);
    }

    public void updatecount(int no) {
        boardDao.updatecount(no);
    }

    public Board content(int no) {
        return boardDao.content(no);
    }

    public int update(Board board) {
        return boardDao.update(board);
    }

    public int delete(int no) {
        return boardDao.delete(no);
    }

    public void saveFile(UserFile file) {
        userFileDao.insertFile(file);
    }

    public List<UserFile> getFilesByBoardNo(int boardNo) {
        return userFileDao.listByBoardNo(boardNo);
    }
    
    @Transactional
    public void writeBoardWithFile(Board board, UserFile file) {
    	boardDao.insert(board);
    	System.out.println("현재 작성된 글 번호 : " + board.getBoardNo());
        if (file != null) {
            file.setBoardNo(board.getBoardNo());
            userFileDao.insertFile(file);
        }
    }
    
    
    public int deleteFileByPath(String filePath) {
        return userFileDao.deleteByPath(filePath);
    }
    
    public Board detail(int no) {
        return boardDao.content(no); // content 메서드를 내부적으로 호출
    }
    
 // 📌 공지사항 3개 가져오기
    public List<Board> getTopNotices() {
        return boardDao.getTopNotices();
    }
    
}