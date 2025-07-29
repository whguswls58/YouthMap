# VIVAMAP

**2030 서울 청년들을 위한 통합 정보 플랫폼**


**VIVAMAP**은 서울 청년들을 위한 정책, 문화, 맛집 정보를 통합 제공하는 플랫폼입니다. 다양한 정보를 흩어진 곳이 아닌 한눈에 확인하고, 리뷰 및 게시판 기능을 통해 청년 간 소통을 지원하는 **참여형 웹 서비스**입니다.

> “정보 탐색에 드는 시간과 피로도를 줄이고, 실질적인 활용도를 높이자!”


##  주요 기능

###  정책 정보 제공
- 온통청년 API 연동
- 주거, 일자리, 교육, 복지문화, 참여권리 분류
- 인기순/최신순 정렬, 상세 페이지 스크롤 이동, 정부기관 외부 링크 제공

###  문화 콘텐츠
- 서울열린데이터광장 API 연동
- 전시/공연/축제 리스트 및 상세 정보
- 카카오 지도 연동, 리뷰 및 별점 작성 가능

###  맛집 정보
- Google Places + Geolocation API 연동
- 지역구·현재 위치 기반 맛집 탐색
- 별점순/가나다순 정렬, 썸네일 슬라이드, 리뷰 작성 기능

###  유저 커뮤니티
- 게시판 CRUD + 카테고리 필터링
- 댓글 기능 및 이미지 첨부
- 로그인한 사용자만 글/댓글 작성 가능

###  관리자 기능
- 회원 관리 (정지, 검색, 정지 사유 확인)
- 게시글·댓글 통합 관리
- 공지사항 등록/수정/삭제
- API 데이터 수동 갱신


##  기술 스택

| 영역 | 사용 기술 |
|------|-----------|
| Frontend | HTML5, CSS3, JavaScript, JSP, AJAX, Fetch, JQuery |
| Backend | Java 17, Spring Boot 3, MyBatis |
| DBMS | Oracle DB |
| API | 온통청년 API, 서울열린데이터광장 API, Google Places, Kakao Map API |
| 인증/보안 | Spring Security, OAuth2 (Google, Naver), 세션 타이머 30분 |
| 배포 | AWS EC2 (Ubuntu), RDS, Route53 |
| 협업 도구 | Git, GitHub, GitHub Flow 브랜치 전략 |


## 브랜치 전략

```
main      ← 운영(배포) 브랜치  
develop   ← 통합 개발 브랜치  
feature/* ← 기능 단위 개발 브랜치
```

- `feature/*`에서 개발 → `develop` 병합 (PR 리뷰 필수)
- `develop` 안정화 후 → `main` 배포
- `.gitignore`로 IDE, 빌드 파일 제외


##  팀 구성 및 역할

| 이름 | 역할 |
|------|------|
| **조현진** | 팀장 / 환경 세팅, 정책 API 연동, 배포, Git 전략 수립 |
| **김예원** | 문화 기능 구현, 리뷰 작성, Kakao 지도 API |
| **김진영** | 메인 페이지 UI/게시판 CRUD 및 공지 관리 |
| **이슬** | 맛집 기능 전체 구현, Google Places 연동 및 지도 UX |
| **표정현** | 전체 기획, 회원/관리자 기능, 소셜 로그인, UI 오류 수정 |


## 개발 일정

| 단계 | 기간 | 주요 작업 |
|------|------|-----------|
| 기획 및 역할 분담 | 06.02 ~ 06.05 | 주제 선정, 사이트 조사 |
| 요구분석 & UI설계 | 06.05 ~ 06.13 | 기능 정의, UI 흐름도 작성 |
| DB설계/환경설정 | 06.09 ~ 06.13 | EXERD, EC2 세팅, Oracle 연동 |
| 구현 및 통합 | 06.13 ~ 06.30 | 프론트/백엔드 기능 구현, 오류 수정 |
| 테스트 및 배포 | 06.23 ~ 06.30 | 통합 테스트, 배포, 발표자료 준비 |


## 실행 방법

### 환경
- JDK 17
- Oracle DB
- STS4 or IntelliJ
- Gradle
- AWS EC2, RDS

### 실행
```bash
# 1. 프로젝트 클론
git clone https://github.com/whguswls58/YouthMap.git

# 2. 환경 설정
- application-secret.properties 생성 후 DB 연결 및 API Key 설정

# 3. 실행
./gradlew bootRun
```


## 기대 효과

- 청년 대상 정책 접근성 및 활용성 개선
- 문화 및 맛집 통합 플랫폼으로 서비스 확장
- 리뷰 및 커뮤니티 기능 통한 자발적 정보 공유
- 반응형 UI/UX를 통한 사용자 편의성 제고


## 문의

본 프로젝트는 **클라우드 데브옵스 자바 풀스택 개발자 캠프 (2025.02.05)** 과정의 산출물로 제작되었습니다.

> 문의: [조현진 (팀장) - whguswls5846@gmail.com]  
> GitHub: https://github.com/whguswls58/YouthMap


© 2025 VIVAMAP. All rights reserved.
