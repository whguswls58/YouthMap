package com.example.demo.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import com.example.demo.model.CultureModel;

@Mapper
public interface CultureDao {

	int culinsert(CultureModel culMd);
	
	boolean existsByTitleAndDate(@Param("title") String title,
            @Param("startDate") String startDate);

	List<CultureModel> getexhibhition();

	List<CultureModel> getperformance();

	List<CultureModel> getevent();

	// 전시미술
	List<CultureModel> getexhibhition(CultureModel culture);

	// 전시/미술 전체 리스트
	List<CultureModel> getexhibitionlist(CultureModel culMd);

	int count(CultureModel culMd);

	CultureModel getexhibhitioncont(CultureModel culMd);

	// 공연
	int count2(CultureModel culMd);
	
	List<CultureModel> getperformancelist(CultureModel culMd);

	CultureModel getperformancecont(CultureModel culMd);
	
	// 축제행사
	List<CultureModel> geteventlist(CultureModel culMd);

	int count3(CultureModel culMd);
 
	CultureModel geteventcont(CultureModel culMd);

	List<CultureModel> searchList(CultureModel culMd);

	int countall(CultureModel culMd);

	List<CultureModel> getallList(CultureModel culMd);

	CultureModel getLatestData();

	int addReadCount(CultureModel culMd);

	List<CultureModel> getallListMini(String sort);

}