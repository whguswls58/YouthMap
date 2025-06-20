package com.example.demo.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.example.demo.model.Board;

@Mapper
public interface BoardDao {
    int insert(Board board);
    int count(Map<String, Object> map);
    List<Board> list(Map<String, Object> map);
    void updatecount(int no);
    Board content(int no);
    int update(Board board);
    int delete(int no);
    List<Board> getTopNotices();

    // 🔹 시퀀스에서 다음 번호 가져오기
    @Select("SELECT board_seq.NEXTVAL FROM dual")
    int getNextBoardNo();
}




