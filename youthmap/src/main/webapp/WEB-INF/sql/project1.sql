--회원관리--
CREATE TABLE Member (
    mem_no          NUMBER                      PRIMARY KEY,
    mem_id          VARCHAR2(50)                NOT NULL UNIQUE,
    mem_pass        VARCHAR2(255)               NOT NULL,
    mem_name        VARCHAR2(100)               NOT NULL,
    birth_date      DATE,
    mem_gen         CHAR(1),
    mem_mail        VARCHAR2(255),
    mem_address     VARCHAR2(255),
    mem_add_detail  VARCHAR2(255),
    mem_date        DATE         DEFAULT SYSDATE NOT NULL,  -- 가입일자
    mem_status      VARCHAR2(20) DEFAULT 'ACTIVE',
    mem_type        VARCHAR2(20) DEFAULT 'LOCAL',
    oauth_id        VARCHAR2(100),
    mem_num         VARCHAR2(50)
);

CREATE SEQUENCE member_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

--정책 테이블 --
CREATE TABLE Plcy (
    plcy_no               VARCHAR2(100)     PRIMARY KEY,
    plcy_nm               VARCHAR2(200),
    plcy_expln_cn         VARCHAR2(3000),
    plcy_kywd_nm          VARCHAR2(100),
    lclsf_nm              VARCHAR2(100),
    mclsf_nm              VARCHAR2(100),
    plcy_sprt_cn          VARCHAR2(3000),
    biz_prd_bgng_ymd      VARCHAR2(100),
    biz_prd_end_ymd       VARCHAR2(100),
    plcy_aply_mthd_cn     VARCHAR2(3000),
    srng_mthd_cn          VARCHAR2(3000),
    aply_url_addr         VARCHAR2(500),
    sbmsn_dcmnt_cn        VARCHAR2(4000),
    etc_mttr_cn           VARCHAR2(3000),
    ref_url_addr1         VARCHAR2(500),
    ref_url_addr2         VARCHAR2(500),
    sprt_scl_lmt_yn       VARCHAR2(100),
    sprt_scl_cnt          VARCHAR2(100),
    sprt_trgt_age_lmt_yn  VARCHAR2(100),
    sprt_trgt_min_age     VARCHAR2(100),
    sprt_trgt_max_age     VARCHAR2(100),
    rgtr_hghrk_inst_cd_nm VARCHAR2(100),
    rgtr_up_inst_cd_nm    VARCHAR2(100),
    rgtr_inst_cd_nm      VARCHAR2(100),
    mrg_stts_cd           VARCHAR2(100),
    earn_cnd_se_cd        VARCHAR2(100),
    earn_min_amt          VARCHAR2(100),
    earn_max_amt          VARCHAR2(100),
    earn_etc_cn           VARCHAR2(500),
    add_aply_qlfc_cnd_cn  CLOB,
    inq_cnt               NUMBER,
    aply_ymd_strt         VARCHAR2(100),
    aply_ymd_end          VARCHAR2(100),
    frst_reg_dt           VARCHAR2(100),
    last_mdfcn_dt        VARCHAR2(100),
    s_biz_cd              VARCHAR2(300),      -- 특화분야코드
    ptcp_prp_trgt_cn      CLOB,               -- 참여제한대상내용
    school_cd             VARCHAR2(300),       -- 학력코드
    plcy_major_cd         VARCHAR2(300),       -- 전공코드
    job_cd                VARCHAR2(300),       -- 취업상태코드
    reg_date              DATE
);


--게시판--
CREATE TABLE board (
    board_no NUMBER PRIMARY KEY,
    board_category VARCHAR2(20),
    board_subject VARCHAR2(200) NOT NULL,
    board_content VARCHAR2(2000) NOT NULL,
    board_readcount NUMBER DEFAULT 0 NOT NULL,
    board_date DATE DEFAULT SYSDATE NOT NULL,
    mem_no NUMBER,  -- 외래키 컬럼

    CONSTRAINT fk_board_member
        FOREIGN KEY (mem_no)
        REFERENCES member(mem_no)
);
CREATE SEQUENCE board_seq START WITH 1 INCREMENT BY 1;

--댓글--
CREATE TABLE comments (
    comm_no NUMBER PRIMARY KEY,           
    comm_content VARCHAR2(1000),          
    comm_date DATE DEFAULT SYSDATE NOT NULL,  
    comm_update DATE,                         
    board_no NUMBER NOT NULL,               
    mem_no NUMBER,
    mem_id VARCHAR2(50),                           

    CONSTRAINT fk_comments_board
        FOREIGN KEY (board_no)
        REFERENCES board(board_no),

    CONSTRAINT fk_comments_member
        FOREIGN KEY (mem_no)
        REFERENCES member(mem_no)
);
CREATE SEQUENCE comments_seq START WITH 1 INCREMENT BY 1;

-- 첨부파일
CREATE TABLE user_file (
    user_file_no NUMBER PRIMARY KEY,
    board_no NUMBER REFERENCES board(board_no) ON DELETE CASCADE,
    user_file_name VARCHAR2(255),
    user_file_path VARCHAR2(500)
);

CREATE SEQUENCE user_file_seq START WITH 1 INCREMENT BY 1;


CREATE TABLE culture (
    con_id         NUMBER                          primary key,
     category_name   VARCHAR2(50)  ,
     con_title      VARCHAR2(200)  ,
    con_img        VARCHAR2(500),
    con_location   VARCHAR2(200),
     con_lat         varchar2(50),
   con_lot         varchar2(50),
    con_start_date VARCHAR2(50),
    con_end_date   VARCHAR2(50),
    con_time       VARCHAR2(50),
    con_age        VARCHAR2(50),
    con_cost       VARCHAR2(50),
    con_link       VARCHAR2(500),
    con_regdate    DATE  );

CREATE SEQUENCE culture_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 리뷰 테이블 생성
CREATE TABLE review2 (
  review_id2        NUMBER     PRIMARY KEY  ,
  review_score2     NUMBER  ,
  review_content2   VARCHAR2(100),
  review_file2      VARCHAR2(300),
  review_register2  DATE,
  mem_no            NUMBER,
  con_id            NUMBER  

   CONSTRAINT fk_review2_member
      FOREIGN KEY (mem_no)
      REFERENCES member(mem_no),

  CONSTRAINT fk_review2_contents
      FOREIGN KEY (con_id)
      REFERENCES contents(con_id)
);

CREATE SEQUENCE review2_seq
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;
  
  
  -- comments 테이블에 mem_id 컬럼 추가
ALTER TABLE comments ADD mem_id VARCHAR2(50);

-- 기존 데이터가 있다면 mem_no를 통해 member 테이블에서 mem_id를 가져와서 업데이트
UPDATE comments c 
SET c.mem_id = (SELECT m.mem_id FROM member m WHERE m.mem_no = c.mem_no)
WHERE c.mem_id IS NULL;

-- mem_id 컬럼을 NOT NULL로 변경 (데이터 업데이트 후)
ALTER TABLE comments MODIFY mem_id VARCHAR2(50) NOT NULL; 
