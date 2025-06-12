package com.example.demo.dao;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.PolicyModel;

@Mapper
public interface PolicyDao {

	int cntData();

	Date lastUpdate();

	List<String> plcyNoList();

	int plcyInsert(PolicyModel policy);

	List<PolicyModel> plcyList();

	int plcyUpdate(PolicyModel pm);

	PolicyModel plcyContent(String plcy_no);

	List<PolicyModel> plcyListByPage(Map<String, Integer> params);

}
