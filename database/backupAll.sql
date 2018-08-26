--
-- PostgreSQL database cluster dump
--

-- Started on 2018-08-20 14:37:59 UTC

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases
--

DROP DATABASE climb;




--
-- Drop roles
--

DROP ROLE postgres;


--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md5bba4a8bebdead2345a83f042532e61fe';





--
-- Database creation
--

CREATE DATABASE climb WITH TEMPLATE = template0 OWNER = postgres;
REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect climb

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5 (Debian 10.5-1.pgdg90+1)
-- Dumped by pg_dump version 10.5 (Debian 10.5-1.pgdg90+1)

-- Started on 2018-08-20 14:37:59 UTC

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
-- TOC entry 3 (class 2615 OID 16536)
-- Name: climb; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA climb;


ALTER SCHEMA climb OWNER TO postgres;

--
-- TOC entry 1 (class 3079 OID 16538)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2858 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 197 (class 1259 OID 16543)
-- Name: seq_users; Type: SEQUENCE; Schema: climb; Owner: postgres
--

CREATE SEQUENCE climb.seq_users
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE climb.seq_users OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 198 (class 1259 OID 16545)
-- Name: users; Type: TABLE; Schema: climb; Owner: postgres
--

CREATE TABLE climb.users (
    id integer NOT NULL,
    uid character(28) NOT NULL,
    email character varying(100) NOT NULL,
    created_at timestamp(4) with time zone NOT NULL,
    updated_at timestamp(4) with time zone NOT NULL,
    logged_at timestamp with time zone
);


ALTER TABLE climb.users OWNER TO postgres;

--
-- TOC entry 2728 (class 2606 OID 16549)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: climb; Owner: postgres
--

ALTER TABLE ONLY climb.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 2726 (class 1259 OID 16550)
-- Name: ix_uid; Type: INDEX; Schema: climb; Owner: postgres
--

CREATE UNIQUE INDEX ix_uid ON climb.users USING btree (uid);


--
-- TOC entry 2857 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2018-08-20 14:37:59 UTC

--
-- PostgreSQL database dump complete
--

\connect postgres

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5 (Debian 10.5-1.pgdg90+1)
-- Dumped by pg_dump version 10.5 (Debian 10.5-1.pgdg90+1)

-- Started on 2018-08-20 14:37:59 UTC

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
-- TOC entry 2846 (class 0 OID 0)
-- Dependencies: 2845
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 1 (class 3079 OID 16473)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2849 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 2848 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2018-08-20 14:37:59 UTC

--
-- PostgreSQL database dump complete
--

\connect template1

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5 (Debian 10.5-1.pgdg90+1)
-- Dumped by pg_dump version 10.5 (Debian 10.5-1.pgdg90+1)

-- Started on 2018-08-20 14:37:59 UTC

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
-- TOC entry 2846 (class 0 OID 0)
-- Dependencies: 2845
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- TOC entry 1 (class 3079 OID 12980)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2848 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


-- Completed on 2018-08-20 14:38:00 UTC

--
-- PostgreSQL database dump complete
--

-- Completed on 2018-08-20 14:38:00 UTC

--
-- PostgreSQL database cluster dump complete
--

