--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5 (Debian 10.5-1.pgdg90+1)
-- Dumped by pg_dump version 10.5 (Debian 10.5-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP INDEX climb.ix_uid;
ALTER TABLE ONLY climb.users DROP CONSTRAINT users_pkey;
DROP TABLE climb.users;
DROP SEQUENCE climb.seq_users;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
DROP SCHEMA climb;
--
-- Name: climb; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA climb;


ALTER SCHEMA climb OWNER TO postgres;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
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
-- Name: users users_pkey; Type: CONSTRAINT; Schema: climb; Owner: postgres
--

ALTER TABLE ONLY climb.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: ix_uid; Type: INDEX; Schema: climb; Owner: postgres
--

CREATE UNIQUE INDEX ix_uid ON climb.users USING btree (uid);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

