--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4
-- Dumped by pg_dump version 10.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_item_info; Type: TABLE; Schema: public; Owner: chenshulin
--

CREATE TABLE public.ar_item_info (
    id integer NOT NULL,
    "条形码" character varying(25) NOT NULL,
    "姓名" character varying(45),
    "性别" character varying(10),
    "年龄" character varying(25),
    "联系方式" character varying(25),
    "送检单位" character varying(120),
    "检测项目" character varying(10),
    "接样日期" date,
    "报告日期" date,
    "报告路径" character varying(1024)
);


ALTER TABLE public.ar_item_info OWNER TO chenshulin;

--
-- Name: ar_item_info_id_seq; Type: SEQUENCE; Schema: public; Owner: chenshulin
--

CREATE SEQUENCE public.ar_item_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ar_item_info_id_seq OWNER TO chenshulin;

--
-- Name: ar_item_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chenshulin
--

ALTER SEQUENCE public.ar_item_info_id_seq OWNED BY public.ar_item_info.id;


--
-- Name: ar_snp_result; Type: TABLE; Schema: public; Owner: chenshulin
--

CREATE TABLE public.ar_snp_result (
    id bigint NOT NULL,
    "样本" integer,
    "位点" character varying(25) NOT NULL,
    "碱基" character varying(10) NOT NULL
);


ALTER TABLE public.ar_snp_result OWNER TO chenshulin;

--
-- Name: ar_snp_result_id_seq; Type: SEQUENCE; Schema: public; Owner: chenshulin
--

CREATE SEQUENCE public.ar_snp_result_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ar_snp_result_id_seq OWNER TO chenshulin;

--
-- Name: ar_snp_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chenshulin
--

ALTER SEQUENCE public.ar_snp_result_id_seq OWNED BY public.ar_snp_result.id;


--
-- Name: huaren_items; Type: TABLE; Schema: public; Owner: chenshulin
--

CREATE TABLE public.huaren_items (
    "条码" character varying(25),
    "华仁样本的条码" character varying(25),
    "检测者姓名" character varying(25),
    "采集时间" character varying(25),
    "出生年月" character varying(25),
    "年龄" character varying(25),
    "性别" character varying(25),
    "检测套餐" character varying(80),
    "报告书" character varying(25),
    "受检者联系方式" character varying(15),
    "表格日期" character varying(25),
    "收样日期" character varying(25),
    "登记人" character varying(25),
    "地址" character varying(100),
    "特殊备注" character varying(100),
    "负责人" character varying(100),
    "报告发送日期" date
);


ALTER TABLE public.huaren_items OWNER TO chenshulin;

--
-- Name: ar_item_info id; Type: DEFAULT; Schema: public; Owner: chenshulin
--

ALTER TABLE ONLY public.ar_item_info ALTER COLUMN id SET DEFAULT nextval('public.ar_item_info_id_seq'::regclass);


--
-- Name: ar_snp_result id; Type: DEFAULT; Schema: public; Owner: chenshulin
--

ALTER TABLE ONLY public.ar_snp_result ALTER COLUMN id SET DEFAULT nextval('public.ar_snp_result_id_seq'::regclass);


--
-- Data for Name: ar_item_info; Type: TABLE DATA; Schema: public; Owner: chenshulin
--

COPY public.ar_item_info (id, "条形码", "姓名", "性别", "年龄", "联系方式", "送检单位", "检测项目", "接样日期", "报告日期", "报告路径") FROM stdin;
\.


--
-- Data for Name: ar_snp_result; Type: TABLE DATA; Schema: public; Owner: chenshulin
--

COPY public.ar_snp_result (id, "样本", "位点", "碱基") FROM stdin;
\.


--
-- Data for Name: huaren_items; Type: TABLE DATA; Schema: public; Owner: chenshulin
--

COPY public.huaren_items ("条码", "华仁样本的条码", "检测者姓名", "采集时间", "出生年月", "年龄", "性别", "检测套餐", "报告书", "受检者联系方式", "表格日期", "收样日期", "登记人", "地址", "特殊备注", "负责人", "报告发送日期") FROM stdin;
\.


--
-- Name: ar_item_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chenshulin
--

SELECT pg_catalog.setval('public.ar_item_info_id_seq', 1, false);


--
-- Name: ar_snp_result_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chenshulin
--

SELECT pg_catalog.setval('public.ar_snp_result_id_seq', 1, false);


--
-- Name: ar_item_info ar_item_info_pkey; Type: CONSTRAINT; Schema: public; Owner: chenshulin
--

ALTER TABLE ONLY public.ar_item_info
    ADD CONSTRAINT ar_item_info_pkey PRIMARY KEY (id);


--
-- Name: ar_snp_result ar_snp_result_pkey; Type: CONSTRAINT; Schema: public; Owner: chenshulin
--

ALTER TABLE ONLY public.ar_snp_result
    ADD CONSTRAINT ar_snp_result_pkey PRIMARY KEY (id);


--
-- Name: ar_snp_result ar_snp_result_样本_fkey; Type: FK CONSTRAINT; Schema: public; Owner: chenshulin
--

ALTER TABLE ONLY public.ar_snp_result
    ADD CONSTRAINT "ar_snp_result_样本_fkey" FOREIGN KEY ("样本") REFERENCES public.ar_item_info(id);


--
-- PostgreSQL database dump complete
--

