package com.example.demo.dao;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.PolicyModel;

@Mapper
public interface PolicyDao {

	int cntData();

	Date lastUpdate();

	List<String> plcyNoList();

	int insertPolicy(PolicyModel policy);

	List<PolicyModel> plcyList();

	int updatePolicy(PolicyModel pm);

}
