package com.example.demo;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
@MapperScan("com.example.demo.dao")
@EnableScheduling
public class YouthmapApplication {

	public static void main(String[] args) {
		SpringApplication.run(YouthmapApplication.class, args);
	}

}
