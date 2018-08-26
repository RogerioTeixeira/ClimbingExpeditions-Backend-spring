--
-- PostgreSQL database cluster dump
--

-- Started on 2018-08-26 21:46:40 UTC

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
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md5a3556571e93b0d20722ba62be61e8c2d';






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

-- Started on 2018-08-26 21:46:40 UTC

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
-- TOC entry 8 (class 2615 OID 24726)
-- Name: audit; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA audit;


ALTER SCHEMA audit OWNER TO postgres;

--
-- TOC entry 3001 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA audit; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA audit IS 'Out-of-table audit/history logging tables and trigger functions';


--
-- TOC entry 9 (class 2615 OID 16385)
-- Name: climb; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA climb;


ALTER SCHEMA climb OWNER TO postgres;

--
-- TOC entry 1 (class 3079 OID 12980)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3003 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 2 (class 3079 OID 24603)
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- TOC entry 3004 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- TOC entry 577 (class 1247 OID 24576)
-- Name: id; Type: DOMAIN; Schema: climb; Owner: postgres
--

CREATE DOMAIN climb.id AS integer NOT NULL;


ALTER DOMAIN climb.id OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 24745)
-- Name: audit_table(regclass); Type: FUNCTION; Schema: audit; Owner: postgres
--

CREATE FUNCTION audit.audit_table(target_table regclass) RETURNS void
    LANGUAGE sql
    AS $_$
SELECT audit.audit_table($1, BOOLEAN 't', BOOLEAN 't');
$_$;


ALTER FUNCTION audit.audit_table(target_table regclass) OWNER TO postgres;

--
-- TOC entry 3005 (class 0 OID 0)
-- Dependencies: 279
-- Name: FUNCTION audit_table(target_table regclass); Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON FUNCTION audit.audit_table(target_table regclass) IS '
Add auditing support to the given table. Row-level changes will be logged with full client query text. No cols are ignored.
';


--
-- TOC entry 278 (class 1255 OID 24744)
-- Name: audit_table(regclass, boolean, boolean); Type: FUNCTION; Schema: audit; Owner: postgres
--

CREATE FUNCTION audit.audit_table(target_table regclass, audit_rows boolean, audit_query_text boolean) RETURNS void
    LANGUAGE sql
    AS $_$
SELECT audit.audit_table($1, $2, $3, ARRAY[]::text[]);
$_$;


ALTER FUNCTION audit.audit_table(target_table regclass, audit_rows boolean, audit_query_text boolean) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 24743)
-- Name: audit_table(regclass, boolean, boolean, text[]); Type: FUNCTION; Schema: audit; Owner: postgres
--

CREATE FUNCTION audit.audit_table(target_table regclass, audit_rows boolean, audit_query_text boolean, ignored_cols text[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  stm_targets text = 'INSERT OR UPDATE OR DELETE OR TRUNCATE';
  _q_txt text;
  _ignored_cols_snip text = '';
BEGIN
    EXECUTE 'DROP TRIGGER IF EXISTS audit_trigger_row ON ' || quote_ident(target_table::TEXT);
    EXECUTE 'DROP TRIGGER IF EXISTS audit_trigger_stm ON ' || quote_ident(target_table::TEXT);

    IF audit_rows THEN
        IF array_length(ignored_cols,1) > 0 THEN
            _ignored_cols_snip = ', ' || quote_literal(ignored_cols);
        END IF;
        _q_txt = 'CREATE TRIGGER audit_trigger_row AFTER INSERT OR UPDATE OR DELETE ON ' || 
                 quote_ident(target_table::TEXT) || 
                 ' FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func(' ||
                 quote_literal(audit_query_text) || _ignored_cols_snip || ');';
        RAISE NOTICE '%',_q_txt;
        EXECUTE _q_txt;
        stm_targets = 'TRUNCATE';
    ELSE
    END IF;

    _q_txt = 'CREATE TRIGGER audit_trigger_stm AFTER ' || stm_targets || ' ON ' ||
             target_table ||
             ' FOR EACH STATEMENT EXECUTE PROCEDURE audit.if_modified_func('||
             quote_literal(audit_query_text) || ');';
    RAISE NOTICE '%',_q_txt;
    EXECUTE _q_txt;

END;
$$;


ALTER FUNCTION audit.audit_table(target_table regclass, audit_rows boolean, audit_query_text boolean, ignored_cols text[]) OWNER TO postgres;

--
-- TOC entry 3006 (class 0 OID 0)
-- Dependencies: 277
-- Name: FUNCTION audit_table(target_table regclass, audit_rows boolean, audit_query_text boolean, ignored_cols text[]); Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON FUNCTION audit.audit_table(target_table regclass, audit_rows boolean, audit_query_text boolean, ignored_cols text[]) IS '
Add auditing support to a table.

Arguments:
   target_table:     Table name, schema qualified if not on search_path
   audit_rows:       Record each row change, or only audit at a statement level
   audit_query_text: Record the text of the client query that triggered the audit event?
   ignored_cols:     Columns to exclude from update diffs, ignore updates that change only ignored cols.
';


--
-- TOC entry 276 (class 1255 OID 24742)
-- Name: if_modified_func(); Type: FUNCTION; Schema: audit; Owner: postgres
--

CREATE FUNCTION audit.if_modified_func() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog', 'public'
    AS $$
DECLARE
    audit_row audit.logged_actions;
    include_values boolean;
    log_diffs boolean;
    h_old hstore;
    h_new hstore;
    excluded_cols text[] = ARRAY[]::text[];
BEGIN
    IF TG_WHEN <> 'AFTER' THEN
        RAISE EXCEPTION 'audit.if_modified_func() may only run as an AFTER trigger';
    END IF;

    audit_row = ROW(
        nextval('audit.logged_actions_event_id_seq'), -- event_id
        TG_TABLE_SCHEMA::text,                        -- schema_name
        TG_TABLE_NAME::text,                          -- table_name
        TG_RELID,                                     -- relation OID for much quicker searches
        session_user::text,                           -- session_user_name
        current_timestamp,                            -- action_tstamp_tx
        statement_timestamp(),                        -- action_tstamp_stm
        clock_timestamp(),                            -- action_tstamp_clk
        txid_current(),                               -- transaction ID
        current_setting('application_name'),          -- client application
        inet_client_addr(),                           -- client_addr
        inet_client_port(),                           -- client_port
        current_query(),                              -- top-level query or queries (if multistatement) from client
        substring(TG_OP,1,1),                         -- action
        NULL, NULL,                                   -- row_data, changed_fields
        'f'                                           -- statement_only
        );

    IF NOT TG_ARGV[0]::boolean IS DISTINCT FROM 'f'::boolean THEN
        audit_row.client_query = NULL;
    END IF;

    IF TG_ARGV[1] IS NOT NULL THEN
        excluded_cols = TG_ARGV[1]::text[];
    END IF;
    
    IF (TG_OP = 'UPDATE' AND TG_LEVEL = 'ROW') THEN
        audit_row.row_data = hstore(OLD.*) - excluded_cols;
        audit_row.changed_fields =  (hstore(NEW.*) - audit_row.row_data) - excluded_cols;
        IF audit_row.changed_fields = hstore('') THEN
            -- All changed fields are ignored. Skip this update.
            RETURN NULL;
        END IF;
    ELSIF (TG_OP = 'DELETE' AND TG_LEVEL = 'ROW') THEN
        audit_row.row_data = hstore(OLD.*) - excluded_cols;
    ELSIF (TG_OP = 'INSERT' AND TG_LEVEL = 'ROW') THEN
        audit_row.row_data = hstore(NEW.*) - excluded_cols;
    ELSIF (TG_LEVEL = 'STATEMENT' AND TG_OP IN ('INSERT','UPDATE','DELETE','TRUNCATE')) THEN
        audit_row.statement_only = 't';
    ELSE
        RAISE EXCEPTION '[audit.if_modified_func] - Trigger func added as trigger for unhandled case: %, %',TG_OP, TG_LEVEL;
        RETURN NULL;
    END IF;
    INSERT INTO audit.logged_actions VALUES (audit_row.*);
    RETURN NULL;
END;
$$;


ALTER FUNCTION audit.if_modified_func() OWNER TO postgres;

--
-- TOC entry 3007 (class 0 OID 0)
-- Dependencies: 276
-- Name: FUNCTION if_modified_func(); Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON FUNCTION audit.if_modified_func() IS '
Track changes to a table at the statement and/or row level.

Optional parameters to trigger in CREATE TRIGGER call:

param 0: boolean, whether to log the query text. Default ''t''.

param 1: text[], columns to ignore in updates. Default [].

         Updates to ignored cols are omitted from changed_fields.

         Updates with only ignored cols changed are not inserted
         into the audit log.

         Almost all the processing work is still done for updates
         that ignored. If you need to save the load, you need to use
         WHEN clause on the trigger instead.

         No warning or error is issued if ignored_cols contains columns
         that do not exist in the target table. This lets you specify
         a standard set of ignored columns.

There is no parameter to disable logging of values. Add this trigger as
a ''FOR EACH STATEMENT'' rather than ''FOR EACH ROW'' trigger if you do not
want to log row values.

Note that the user name logged is the login role for the session. The audit trigger
cannot obtain the active role because it is reset by the SECURITY DEFINER invocation
of the audit trigger its self.
';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 201 (class 1259 OID 24729)
-- Name: logged_actions; Type: TABLE; Schema: audit; Owner: postgres
--

CREATE TABLE audit.logged_actions (
    event_id bigint NOT NULL,
    schema_name text NOT NULL,
    table_name text NOT NULL,
    relid oid NOT NULL,
    session_user_name text,
    action_tstamp_tx timestamp with time zone NOT NULL,
    action_tstamp_stm timestamp with time zone NOT NULL,
    action_tstamp_clk timestamp with time zone NOT NULL,
    transaction_id bigint,
    application_name text,
    client_addr inet,
    client_port integer,
    client_query text,
    action text NOT NULL,
    row_data public.hstore,
    changed_fields public.hstore,
    statement_only boolean NOT NULL,
    CONSTRAINT logged_actions_action_check CHECK ((action = ANY (ARRAY['I'::text, 'D'::text, 'U'::text, 'T'::text])))
);


ALTER TABLE audit.logged_actions OWNER TO postgres;

--
-- TOC entry 3008 (class 0 OID 0)
-- Dependencies: 201
-- Name: TABLE logged_actions; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON TABLE audit.logged_actions IS 'History of auditable actions on audited tables, from audit.if_modified_func()';


--
-- TOC entry 3009 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.event_id; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.event_id IS 'Unique identifier for each auditable event';


--
-- TOC entry 3010 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.schema_name; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.schema_name IS 'Database schema audited table for this event is in';


--
-- TOC entry 3011 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.table_name; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.table_name IS 'Non-schema-qualified table name of table event occured in';


--
-- TOC entry 3012 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.relid; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.relid IS 'Table OID. Changes with drop/create. Get with ''tablename''::regclass';


--
-- TOC entry 3013 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.session_user_name; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.session_user_name IS 'Login / session user whose statement caused the audited event';


--
-- TOC entry 3014 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.action_tstamp_tx; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.action_tstamp_tx IS 'Transaction start timestamp for tx in which audited event occurred';


--
-- TOC entry 3015 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.action_tstamp_stm; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.action_tstamp_stm IS 'Statement start timestamp for tx in which audited event occurred';


--
-- TOC entry 3016 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.action_tstamp_clk; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.action_tstamp_clk IS 'Wall clock time at which audited event''s trigger call occurred';


--
-- TOC entry 3017 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.transaction_id; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.transaction_id IS 'Identifier of transaction that made the change. May wrap, but unique paired with action_tstamp_tx.';


--
-- TOC entry 3018 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.application_name; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.application_name IS 'Application name set when this audit event occurred. Can be changed in-session by client.';


--
-- TOC entry 3019 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.client_addr; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.client_addr IS 'IP address of client that issued query. Null for unix domain socket.';


--
-- TOC entry 3020 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.client_port; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.client_port IS 'Remote peer IP port address of client that issued query. Undefined for unix socket.';


--
-- TOC entry 3021 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.client_query; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.client_query IS 'Top-level query that caused this auditable event. May be more than one statement.';


--
-- TOC entry 3022 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.action; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.action IS 'Action type; I = insert, D = delete, U = update, T = truncate';


--
-- TOC entry 3023 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.row_data; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.row_data IS 'Record value. Null for statement-level trigger. For INSERT this is the new tuple. For DELETE and UPDATE it is the old tuple.';


--
-- TOC entry 3024 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.changed_fields; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.changed_fields IS 'New values of fields changed by UPDATE. Null except for row-level UPDATE events.';


--
-- TOC entry 3025 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN logged_actions.statement_only; Type: COMMENT; Schema: audit; Owner: postgres
--

COMMENT ON COLUMN audit.logged_actions.statement_only IS '''t'' if audit event is from an FOR EACH STATEMENT trigger, ''f'' for FOR EACH ROW';


--
-- TOC entry 200 (class 1259 OID 24727)
-- Name: logged_actions_event_id_seq; Type: SEQUENCE; Schema: audit; Owner: postgres
--

CREATE SEQUENCE audit.logged_actions_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE audit.logged_actions_event_id_seq OWNER TO postgres;

--
-- TOC entry 3026 (class 0 OID 0)
-- Dependencies: 200
-- Name: logged_actions_event_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: postgres
--

ALTER SEQUENCE audit.logged_actions_event_id_seq OWNED BY audit.logged_actions.event_id;


--
-- TOC entry 203 (class 1259 OID 24829)
-- Name: role; Type: TABLE; Schema: climb; Owner: postgres
--

CREATE TABLE climb.role (
    id integer NOT NULL,
    role character varying(10) NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE climb.role OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 16386)
-- Name: seq_users; Type: SEQUENCE; Schema: climb; Owner: postgres
--

CREATE SEQUENCE climb.seq_users
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE climb.seq_users OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 24834)
-- Name: user; Type: TABLE; Schema: climb; Owner: postgres
--

CREATE TABLE climb."user" (
    id integer NOT NULL,
    uid character(28) NOT NULL,
    email character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE climb."user" OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 24840)
-- Name: user_logging; Type: TABLE; Schema: climb; Owner: postgres
--

CREATE TABLE climb.user_logging (
    id bigint NOT NULL,
    type character(2) NOT NULL,
    date timestamp without time zone NOT NULL,
    payload character varying(1000),
    id_user integer NOT NULL,
    users_id integer NOT NULL
);


ALTER TABLE climb.user_logging OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 24848)
-- Name: user_role; Type: TABLE; Schema: climb; Owner: postgres
--

CREATE TABLE climb.user_role (
    id_user integer NOT NULL,
    id_role integer NOT NULL
);


ALTER TABLE climb.user_role OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 24824)
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
-- TOC entry 2853 (class 2604 OID 24732)
-- Name: logged_actions event_id; Type: DEFAULT; Schema: audit; Owner: postgres
--

ALTER TABLE ONLY audit.logged_actions ALTER COLUMN event_id SET DEFAULT nextval('audit.logged_actions_event_id_seq'::regclass);


--
-- TOC entry 2858 (class 2606 OID 24738)
-- Name: logged_actions logged_actions_pkey; Type: CONSTRAINT; Schema: audit; Owner: postgres
--

ALTER TABLE ONLY audit.logged_actions
    ADD CONSTRAINT logged_actions_pkey PRIMARY KEY (event_id);


--
-- TOC entry 2863 (class 2606 OID 24833)
-- Name: role role_pk; Type: CONSTRAINT; Schema: climb; Owner: postgres
--

ALTER TABLE ONLY climb.role
    ADD CONSTRAINT role_pk PRIMARY KEY (id);


--
-- TOC entry 2868 (class 2606 OID 24847)
-- Name: user_logging user_logging_pk; Type: CONSTRAINT; Schema: climb; Owner: postgres
--

ALTER TABLE ONLY climb.user_logging
    ADD CONSTRAINT user_logging_pk PRIMARY KEY (id);


--
-- TOC entry 2866 (class 2606 OID 24838)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: climb; Owner: postgres
--

ALTER TABLE ONLY climb."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2870 (class 2606 OID 24852)
-- Name: user_role user_role_pk; Type: CONSTRAINT; Schema: climb; Owner: postgres
--

ALTER TABLE ONLY climb.user_role
    ADD CONSTRAINT user_role_pk PRIMARY KEY (id_user, id_role);


--
-- TOC entry 2861 (class 2606 OID 24828)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: climb; Owner: postgres
--

ALTER TABLE ONLY climb.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 2855 (class 1259 OID 24741)
-- Name: logged_actions_action_idx; Type: INDEX; Schema: audit; Owner: postgres
--

CREATE INDEX logged_actions_action_idx ON audit.logged_actions USING btree (action);


--
-- TOC entry 2856 (class 1259 OID 24740)
-- Name: logged_actions_action_tstamp_tx_stm_idx; Type: INDEX; Schema: audit; Owner: postgres
--

CREATE INDEX logged_actions_action_tstamp_tx_stm_idx ON audit.logged_actions USING btree (action_tstamp_stm);


--
-- TOC entry 2859 (class 1259 OID 24739)
-- Name: logged_actions_relid_idx; Type: INDEX; Schema: audit; Owner: postgres
--

CREATE INDEX logged_actions_relid_idx ON audit.logged_actions USING btree (relid);


--
-- TOC entry 2864 (class 1259 OID 24839)
-- Name: ix_uid; Type: INDEX; Schema: climb; Owner: postgres
--

CREATE UNIQUE INDEX ix_uid ON climb."user" USING btree (uid);


--
-- TOC entry 2872 (class 2606 OID 24853)
-- Name: user_role role_user_role_fk; Type: FK CONSTRAINT; Schema: climb; Owner: postgres
--

ALTER TABLE ONLY climb.user_role
    ADD CONSTRAINT role_user_role_fk FOREIGN KEY (id_role) REFERENCES climb.role(id);


--
-- TOC entry 2871 (class 2606 OID 24863)
-- Name: user_logging users_user_logging_fk; Type: FK CONSTRAINT; Schema: climb; Owner: postgres
--

ALTER TABLE ONLY climb.user_logging
    ADD CONSTRAINT users_user_logging_fk FOREIGN KEY (users_id) REFERENCES climb."user"(id);


--
-- TOC entry 2873 (class 2606 OID 24858)
-- Name: user_role users_user_role_fk; Type: FK CONSTRAINT; Schema: climb; Owner: postgres
--

ALTER TABLE ONLY climb.user_role
    ADD CONSTRAINT users_user_role_fk FOREIGN KEY (id_user) REFERENCES climb."user"(id);


-- Completed on 2018-08-26 21:46:40 UTC

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

-- Started on 2018-08-26 21:46:40 UTC

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


-- Completed on 2018-08-26 21:46:40 UTC

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

-- Started on 2018-08-26 21:46:40 UTC

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


-- Completed on 2018-08-26 21:46:40 UTC

--
-- PostgreSQL database dump complete
--

-- Completed on 2018-08-26 21:46:40 UTC

--
-- PostgreSQL database cluster dump complete
--

