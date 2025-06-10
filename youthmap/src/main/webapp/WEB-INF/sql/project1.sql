--댓글 
CREATE TABLE "Comments" (
    "comm_no"        NUMBER            NOT NULL,
    "comm_content"   VARCHAR2(1000)    NULL,
    "comm_date"      DATE              DEFAULT SYSDATE NOT NULL,
    "comm_update"    DATE              NULL,
    "board_no"       NUMBER            NOT NULL,
    "mem_no"         NUMBER            NOT NULL,
    CONSTRAINT "PK_COMMENTS" PRIMARY KEY ("comm_no")
);
--첨부 파일 
CREATE TABLE "user_file" (
    "user_file_no"     NUMBER           NOT NULL,
    "user_file_name"   VARCHAR2(255)    NULL,
    "user_file_path"   VARCHAR2(200)    NULL,
    "board_no"         NUMBER           NOT NULL,
    CONSTRAINT "PK_USER_FILE" PRIMARY KEY ("user_file_no")
);
--문화 후기 
CREATE TABLE "review2" (
    "review_id2"        NUMBER           NOT NULL,
    "review_score2"     NUMBER           NULL,
    "review_content2"   VARCHAR2(100)    NULL,
    "review_file2"      VARCHAR2(100)    NULL,
    "review_register2"  DATE             NULL,
    "con_id"            NUMBER           NOT NULL,
    "mem_no"            NUMBER           NOT NULL,
    CONSTRAINT "PK_REVIEW2" PRIMARY KEY ("review_id2")
);
--정책
CREATE TABLE "Plcy" (
    "plcy_no"               VARCHAR2(20)     NOT NULL,
    "plcy_nm"               VARCHAR2(200)    NULL,
    "plcy_expln_cn"         VARCHAR2(3000)   NULL,
    "plcy_kywd_nm"          VARCHAR2(100)    NULL,
    "lclsf_nm"              VARCHAR2(50)     NULL,
    "mclsf_nm"              VARCHAR2(50)     NULL,
    "plcy_sprt_cn"          VARCHAR2(3000)   NULL,
    "biz_prd_bgng_ymd"      DATE             NULL,
    "biz_prd_end_ymd"       DATE             NULL,
    "plcy_aply_mthd_cn"     VARCHAR2(3000)   NULL,
    "srng_mthd_cn"          VARCHAR2(3000)   NULL,
    "aply_url_addr"         VARCHAR2(500)    NULL,
    "sbmsn_dcmnt_cn"        VARCHAR2(300)    NULL,
    "etc_mttr_cn"           VARCHAR2(3000)   NULL,
    "ref_url_addr1"         VARCHAR2(500)    NULL,
    "ref_url_addr2"         VARCHAR2(500)    NULL,
    "sprt_scl_lmt_yn"       CHAR(1)          NULL,
    "sprt_scl_cnt"          NUMBER           NULL,
    "sprt_trgt_age_lmt_yn"  CHAR(1)          NULL,
    "sprt_trgt_min_age"     NUMBER           NULL,
    "sprt_trgt_max_age"     NUMBER           NULL,
    "rgtr_hghrk_inst_cd_nm" VARCHAR2(100)    NULL,
    "rgtr_up_inst_cd_nm"    VARCHAR2(100)    NULL,
    "rgtr_iimst_cd_nm"      VARCHAR2(100)    NULL,
    "mrg_stts_cd"           VARCHAR2(10)     NULL,
    "earn_cnd_se_cd"        VARCHAR2(10)     NULL,
    "earn_min_amt"          NUMBER           NULL,
    "earn_max_amt"          NUMBER           NULL,
    "earn_etc_cn"           VARCHAR2(500)    NULL,
    "add_aply_qlfc_cmd_cn"  VARCHAR2(3000)   NULL,
    "inq_cnt"               NUMBER           NULL,
    "aply_ymd_strt"         DATE             NULL,
    "aply_ymd_end"          DATE             NULL,
    CONSTRAINT "PK_PLCY" PRIMARY KEY ("plcy_no")
);
--식당
CREATE TABLE "res" (
    "res_id"        NUMBER           NOT NULL,
    "res_subject"   VARCHAR2(100)    NULL,
    "res_menu"      NUMBER           NULL,
    "res_tel"       VARCHAR2(20)     NULL,
    "res_score"     NUMBER           NULL,
    "res_address"   VARCHAR2(255)    NULL,
    "res_map_url"   VARCHAR2(1000)   NULL,  -- TEXT → VARCHAR2로 변경
    "menu_content"  VARCHAR2(100)    NULL,
    "res_lat"       NUMBER(10,6)     NULL,
    "res_lon"       NUMBER(10,6)     NULL,
    CONSTRAINT "PK_RES" PRIMARY KEY ("res_id")
);
--회원
CREATE TABLE "Member" (
    "mem_no"        NUMBER           NOT NULL,
    "mem_id"        VARCHAR2(20)     NOT NULL,
    "mem_pass"      VARCHAR2(100)     NOT NULL,
    "mem_name"      VARCHAR2(50)     NOT NULL,
    "birth_date"    DATE             NULL,
    "mem_gen"       CHAR(1)          NULL,
    "mem_mail"      VARCHAR2(100)    NULL,
    "mem_address"   VARCHAR2(200)    NULL,
    "mem_addDetail" VARCHAR2(200)    NULL,
    "mem_date"      DATE             DEFAULT SYSDATE NOT NULL,
    CONSTRAINT "PK_MEMBER" PRIMARY KEY ("mem_no"),
    CONSTRAINT "UK_MEMBER_ID" UNIQUE ("mem_id")
);

--맛집 후기 
CREATE TABLE "review1" ( 
    "review_id1"       NUMBER           NOT NULL,
    "review_score1"    NUMBER           NULL,
    "review_content1"  VARCHAR2(100)    NULL,
    "review_file1"     VARCHAR2(100)    NULL,
    "review_register1" DATE             NULL,
    "mem_no"           NUMBER           NOT NULL,
    "res_id"           NUMBER           NOT NULL,
    CONSTRAINT "PK_REVIEW_1" PRIMARY KEY ("review_id1")
);
--문
CREATE TABLE "content" (
    "con_id"          NUMBER           NOT NULL,
    "con_title"       VARCHAR2(200)    NULL,
    "con_img"         VARCHAR2(500)    NULL,
    "con_age"		  VARCHAR2(100)    NULL,
    "con_location"    VARCHAR2(200)    NULL,
    "con_map"         VARCHAR2(500)    NULL,
    "con_start_date"  DATE             NULL,
    "con_end_date"    DATE             NULL,
    "con_time"        VARCHAR2(50)     NULL,   뺴기.
    "con_cost"        VARCHAR2(50)     NULL,
    "con_regdate"     DATE             NULL,
    "category_id"     NUMBER           NOT NULL,
    CONSTRAINT "PK_CONTENT" PRIMARY KEY ("con_id")
);
-- 게시물
CREATE TABLE "Board" (
    "board_no"         NUMBER            NOT NULL,
    "board_category"   VARCHAR2(20)      NULL,
    "board_subject"    VARCHAR2(200)     NOT NULL,
    "board_content"    VARCHAR2(2000)    NOT NULL,
    "board_readcount"  NUMBER            DEFAULT 0 NOT NULL,
    "board_date"       DATE              DEFAULT SYSDATE NOT NULL,
    "mem_no"           NUMBER            NOT NULL,
    CONSTRAINT "PK_BOARD" PRIMARY KEY ("board_no")
);
--카테고리 
CREATE TABLE "category" (
    "category_id"     NUMBER           NOT NULL,
    "category_name"   VARCHAR2(50)     NOT NULL,
    CONSTRAINT "PK_카테고리" PRIMARY KEY ("category_id")
);


CREATE SEQUENCE seq_mem_no
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_board_no
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_res_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_con_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_comm_no
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_category_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_file_no
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

