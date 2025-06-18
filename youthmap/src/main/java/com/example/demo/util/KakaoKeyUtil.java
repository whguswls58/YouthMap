package com.example.demo.util;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;


@Component
public class KakaoKeyUtil {

    private static String kakaoKey;

    /** application-secret.properties 의 kakao.map.key 값을 받아 세팅 */
    @Value("${kakao.map.key}")
    public void setKakaoKey(String key) {
        KakaoKeyUtil.kakaoKey = key;
    }

    /** JSP 등에서 호출할 때 사용할 메서드 */
    public static String getApiKey() {
        return kakaoKey;
    }
}