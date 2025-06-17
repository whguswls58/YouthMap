package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.UserFile;

@Mapper
public interface UserFileDao {
    int insertFile(UserFile file);
    List<UserFile> listByBoardNo(int boardNo); // (상세 보기용)
    int deleteByPath(String userFilePath);
}