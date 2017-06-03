--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.6
-- Dumped by pg_dump version 9.5.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: array_idx(anyarray, anyelement); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION array_idx(anyarray, anyelement) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$
        SELECT i FROM (
          SELECT generate_series(array_lower($1,1),array_upper($1,1))
        ) g(i)
        WHERE $1[i] = $2
        LIMIT 1;
      $_$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ab_groupings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE activities (
    id integer NOT NULL,
    initiator_id integer NOT NULL,
    resource_id integer NOT NULL,
    resource_type character varying(255) NOT NULL,
    action character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_on date NOT NULL,
    updated_on date NOT NULL,
    anonymous boolean DEFAULT false NOT NULL,
    context integer
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activities_id_seq OWNED BY activities.id;


--
-- Name: answer_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE answer_profiles (
    id integer NOT NULL,
    answer_id integer NOT NULL,
    property character varying(255),
    value double precision,
    probability double precision,
    source character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    text_value text
);


--
-- Name: answer_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE answer_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answer_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE answer_profiles_id_seq OWNED BY answer_profiles.id;


--
-- Name: answer_revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE answer_revisions (
    id integer NOT NULL,
    answer_id integer NOT NULL,
    editor_id integer NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone
);


--
-- Name: answer_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE answer_revisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answer_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE answer_revisions_id_seq OWNED BY answer_revisions.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE answers (
    id integer NOT NULL,
    author_id integer NOT NULL,
    question_id integer NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    votes_difference integer DEFAULT 0 NOT NULL,
    stack_exchange_uuid integer,
    comments_count integer DEFAULT 0 NOT NULL,
    votes_count integer DEFAULT 0 NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    votes_lb_wsci_bp numeric(13,12) DEFAULT 0 NOT NULL,
    edited_at timestamp without time zone,
    editor_id integer,
    deletor_id integer,
    deleted_at timestamp without time zone,
    edited boolean DEFAULT false NOT NULL,
    evaluations_count integer DEFAULT 0 NOT NULL,
    anonymous boolean DEFAULT false
);


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE answers_id_seq OWNED BY answers.id;


--
-- Name: assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE assignments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    category_id integer NOT NULL,
    role_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    admin_visible boolean DEFAULT true,
    parent integer
);


--
-- Name: assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignments_id_seq OWNED BY assignments.id;


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE attachments (
    id integer NOT NULL,
    file_file_name character varying(255),
    file_content_type character varying(255),
    file_file_size integer,
    file_updated_at timestamp without time zone,
    attachmentable_id integer NOT NULL,
    attachmentable_type character varying(255) NOT NULL,
    author_id integer NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE attachments_id_seq OWNED BY attachments.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tags character varying(255)[] DEFAULT '{}'::character varying[],
    questions_count integer DEFAULT 0 NOT NULL,
    slido_username character varying(255),
    slido_event_prefix character varying(255),
    parent_id integer,
    lft integer,
    rgt integer,
    uuid character varying(255),
    depth integer,
    full_tree_name text,
    full_public_name text,
    public_tags character varying(255)[] DEFAULT '{}'::character varying[],
    shared boolean DEFAULT true,
    askable boolean DEFAULT true,
    lti_id character varying(255),
    description text,
    third_party_hash character varying(255),
    askalot_page_url character varying(255),
    lists_count integer DEFAULT 0 NOT NULL,
    visible boolean DEFAULT true NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: categories_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories_questions (
    id integer NOT NULL,
    question_id integer NOT NULL,
    category_id integer NOT NULL,
    shared boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone,
    shared_through_category_id integer
);


--
-- Name: categories_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_questions_id_seq OWNED BY categories_questions.id;


--
-- Name: changelogs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE changelogs (
    id integer NOT NULL,
    text text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    title character varying(255),
    version character varying(255) NOT NULL
);


--
-- Name: changelogs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE changelogs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: changelogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE changelogs_id_seq OWNED BY changelogs.id;


--
-- Name: comment_revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE comment_revisions (
    id integer NOT NULL,
    comment_id integer NOT NULL,
    editor_id integer NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone
);


--
-- Name: comment_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comment_revisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comment_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comment_revisions_id_seq OWNED BY comment_revisions.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE comments (
    id integer NOT NULL,
    author_id integer NOT NULL,
    commentable_id integer NOT NULL,
    commentable_type character varying(255) NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    stack_exchange_uuid integer,
    deleted boolean DEFAULT false NOT NULL,
    edited_at timestamp without time zone,
    editor_id integer,
    deletor_id integer,
    deleted_at timestamp without time zone,
    edited boolean DEFAULT false NOT NULL,
    anonymous boolean DEFAULT false
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: context_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE context_users (
    id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    context_id integer
);


--
-- Name: context_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE context_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: context_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE context_users_id_seq OWNED BY context_users.id;


--
-- Name: document_revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE document_revisions (
    id integer NOT NULL,
    document_id integer NOT NULL,
    editor_id integer NOT NULL,
    title character varying(255) NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer
);


--
-- Name: document_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE document_revisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: document_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE document_revisions_id_seq OWNED BY document_revisions.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE documents (
    id integer NOT NULL,
    author_id integer NOT NULL,
    group_id integer NOT NULL,
    title character varying(255) NOT NULL,
    text text NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone,
    questions_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    edited boolean DEFAULT false NOT NULL,
    edited_at timestamp without time zone,
    editor_id integer,
    anonymous boolean DEFAULT false NOT NULL
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE documents_id_seq OWNED BY documents.id;


--
-- Name: emails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE emails (
    id integer NOT NULL,
    user_id integer,
    subject text,
    body text,
    status boolean,
    send_html_email boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE emails_id_seq OWNED BY emails.id;


--
-- Name: evaluation_revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE evaluation_revisions (
    id integer NOT NULL,
    evaluation_id integer NOT NULL,
    editor_id integer NOT NULL,
    text text,
    value integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone
);


--
-- Name: evaluation_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE evaluation_revisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: evaluation_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE evaluation_revisions_id_seq OWNED BY evaluation_revisions.id;


--
-- Name: evaluations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE evaluations (
    id integer NOT NULL,
    author_id integer NOT NULL,
    evaluable_id integer NOT NULL,
    evaluable_type character varying(255) NOT NULL,
    text text,
    value integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone,
    edited boolean DEFAULT false NOT NULL,
    edited_at timestamp without time zone,
    editor_id integer
);


--
-- Name: evaluations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE evaluations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: evaluations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE evaluations_id_seq OWNED BY evaluations.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE events (
    id integer NOT NULL,
    data json NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE favorites (
    id integer NOT NULL,
    favorer_id integer NOT NULL,
    question_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone,
    stack_exchange_uuid integer
);


--
-- Name: favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE favorites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE favorites_id_seq OWNED BY favorites.id;


--
-- Name: followings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE followings (
    id integer NOT NULL,
    follower_id integer NOT NULL,
    followee_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone
);


--
-- Name: followings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE followings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: followings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE followings_id_seq OWNED BY followings.id;


--
-- Name: group_revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE group_revisions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    editor_id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    visibility character varying(255) DEFAULT 'public'::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer
);


--
-- Name: group_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_revisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_revisions_id_seq OWNED BY group_revisions.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE groups (
    id integer NOT NULL,
    creator_id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    visibility character varying(255) DEFAULT 'public'::character varying NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone,
    documents_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    edited boolean DEFAULT false NOT NULL,
    edited_at timestamp without time zone,
    editor_id integer
);


--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE groups_id_seq OWNED BY groups.id;


--
-- Name: labelings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE labelings (
    id integer NOT NULL,
    author_id integer NOT NULL,
    answer_id integer NOT NULL,
    label_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone,
    stack_exchange_uuid integer
);


--
-- Name: labelings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE labelings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: labelings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE labelings_id_seq OWNED BY labelings.id;


--
-- Name: labels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE labels (
    id integer NOT NULL,
    value character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: labels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE labels_id_seq OWNED BY labels.id;


--
-- Name: lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE lists (
    id integer NOT NULL,
    category_id integer NOT NULL,
    lister_id integer NOT NULL,
    unit_view boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    deleted_at timestamp without time zone
);


--
-- Name: lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lists_id_seq OWNED BY lists.id;


--
-- Name: mooc_category_contents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mooc_category_contents (
    id integer NOT NULL,
    category_id integer,
    content text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: mooc_category_contents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mooc_category_contents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mooc_category_contents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mooc_category_contents_id_seq OWNED BY mooc_category_contents.id;


--
-- Name: mooclet_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE news (
    id integer NOT NULL,
    title character varying(255),
    description text,
    show boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: news_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE news_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: news_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE news_id_seq OWNED BY news.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications (
    id integer NOT NULL,
    recipient_id integer NOT NULL,
    initiator_id integer NOT NULL,
    resource_id integer NOT NULL,
    resource_type character varying(255) NOT NULL,
    action character varying(255) NOT NULL,
    unread boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    read_at timestamp without time zone,
    anonymous boolean DEFAULT false NOT NULL,
    context integer,
    from_dashboard boolean DEFAULT false,
    feedback_expertise integer,
    feedback_willigness integer
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: question_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE question_profiles (
    id integer NOT NULL,
    question_id integer NOT NULL,
    property character varying(255),
    value double precision,
    probability double precision,
    source character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    text_value text
);


--
-- Name: question_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE question_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: question_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE question_profiles_id_seq OWNED BY question_profiles.id;


--
-- Name: question_revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE question_revisions (
    id integer NOT NULL,
    question_id integer NOT NULL,
    editor_id integer NOT NULL,
    category character varying(255),
    tags character varying(255)[] NOT NULL,
    title character varying(255) NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone,
    document_id integer,
    question_type character varying(255)
);


--
-- Name: question_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE question_revisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: question_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE question_revisions_id_seq OWNED BY question_revisions.id;


--
-- Name: question_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE question_types (
    id integer NOT NULL,
    mode character varying(255),
    icon character varying(255),
    name character varying(255),
    description character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    color character varying(255) DEFAULT '#000000'::character varying
);


--
-- Name: question_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE question_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: question_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE question_types_id_seq OWNED BY question_types.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE questions (
    id integer NOT NULL,
    author_id integer NOT NULL,
    category_id integer,
    title character varying(255) NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    votes_difference integer DEFAULT 0 NOT NULL,
    anonymous boolean DEFAULT false NOT NULL,
    stack_exchange_uuid integer,
    answers_count integer DEFAULT 0 NOT NULL,
    comments_count integer DEFAULT 0 NOT NULL,
    favorites_count integer DEFAULT 0 NOT NULL,
    views_count integer DEFAULT 0 NOT NULL,
    votes_count integer DEFAULT 0 NOT NULL,
    slido_question_uuid integer,
    slido_event_uuid integer,
    deleted boolean DEFAULT false NOT NULL,
    touched_at timestamp without time zone NOT NULL,
    votes_lb_wsci_bp numeric(13,12) DEFAULT 0 NOT NULL,
    edited_at timestamp without time zone,
    editor_id integer,
    deletor_id integer,
    deleted_at timestamp without time zone,
    edited boolean DEFAULT false NOT NULL,
    stack_exchange_duplicate boolean,
    stack_exchange_questions_uuids integer[],
    evaluations_count integer DEFAULT 0 NOT NULL,
    document_id integer,
    closed boolean DEFAULT false NOT NULL,
    closer_id integer,
    closed_at timestamp without time zone,
    with_best_answer boolean DEFAULT false,
    question_type_id integer
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


--
-- Name: recommendations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: slido_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE slido_events (
    id integer NOT NULL,
    category_id integer NOT NULL,
    uuid integer NOT NULL,
    identifier character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    started_at timestamp without time zone NOT NULL,
    ended_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: slido_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE slido_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: slido_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE slido_events_id_seq OWNED BY slido_events.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer NOT NULL,
    question_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone,
    author_id integer NOT NULL
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    stack_exchange_uuid integer,
    max_time numeric(20,6),
    min_votes_difference integer,
    max_votes_difference integer
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_profiles (
    id integer NOT NULL,
    user_id integer NOT NULL,
    targetable_id integer NOT NULL,
    targetable_type character varying(255) NOT NULL,
    property character varying(255),
    value double precision,
    probability double precision,
    source character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    text_value text
);


--
-- Name: user_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_profiles_id_seq OWNED BY user_profiles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    login character varying(255) NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT NULL::character varying,
    ais_uid character varying(255),
    ais_login character varying(255),
    nick character varying(255) NOT NULL,
    name character varying(255),
    first character varying(255),
    middle character varying(255),
    last character varying(255),
    about text,
    facebook character varying(255),
    twitter character varying(255),
    linkedin character varying(255),
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying(255),
    locked_at timestamp without time zone,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_at timestamp without time zone,
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    gravatar_email character varying(255),
    show_name boolean DEFAULT true NOT NULL,
    show_email boolean DEFAULT true NOT NULL,
    bitbucket character varying(255),
    flickr character varying(255),
    foursquare character varying(255),
    github character varying(255),
    google_plus character varying(255),
    instagram character varying(255),
    pinterest character varying(255),
    stack_overflow character varying(255),
    tumblr character varying(255),
    youtube character varying(255),
    role character varying(255) DEFAULT 'student'::character varying NOT NULL,
    stack_exchange_uuid integer,
    answers_count integer DEFAULT 0 NOT NULL,
    comments_count integer DEFAULT 0 NOT NULL,
    favorites_count integer DEFAULT 0 NOT NULL,
    questions_count integer DEFAULT 0 NOT NULL,
    views_count integer DEFAULT 0 NOT NULL,
    votes_count integer DEFAULT 0 NOT NULL,
    remember_token character varying(255),
    followers_count integer DEFAULT 0 NOT NULL,
    followees_count integer DEFAULT 0 NOT NULL,
    evaluations_count integer DEFAULT 0 NOT NULL,
    omniauth_provider character varying(255),
    omniauth_token text,
    omniauth_token_expires_at timestamp without time zone,
    facebook_uid bigint,
    facebook_friends text,
    facebook_likes text,
    documents_count integer DEFAULT 0 NOT NULL,
    send_email_notifications boolean DEFAULT true NOT NULL,
    alumni boolean DEFAULT false NOT NULL,
    dashboard_last_sign_in_at timestamp without time zone DEFAULT now(),
    attachments_count integer,
    lists_count integer DEFAULT 0 NOT NULL,
    send_mail_notifications_frequency character varying DEFAULT 'daily'::character varying,
    last_mail_notification_sent_at timestamp without time zone,
    mail_notification_delay integer DEFAULT 0,
    prefered_activity_tab character varying DEFAULT 'all'::character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: views; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE views (
    id integer NOT NULL,
    question_id integer NOT NULL,
    viewer_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone
);


--
-- Name: views_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE views_id_seq OWNED BY views.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE votes (
    id integer NOT NULL,
    voter_id integer,
    votable_id integer NOT NULL,
    votable_type character varying(255) NOT NULL,
    positive boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone,
    stack_exchange_uuid integer
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE votes_id_seq OWNED BY votes.id;


--
-- Name: watchings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE watchings (
    id integer NOT NULL,
    watcher_id integer NOT NULL,
    watchable_id integer NOT NULL,
    watchable_type character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deletor_id integer,
    deleted_at timestamp without time zone,
    context integer
);


--
-- Name: watchings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE watchings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: watchings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE watchings_id_seq OWNED BY watchings.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities ALTER COLUMN id SET DEFAULT nextval('activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY answer_profiles ALTER COLUMN id SET DEFAULT nextval('answer_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY answer_revisions ALTER COLUMN id SET DEFAULT nextval('answer_revisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY answers ALTER COLUMN id SET DEFAULT nextval('answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments ALTER COLUMN id SET DEFAULT nextval('assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments ALTER COLUMN id SET DEFAULT nextval('attachments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories_questions ALTER COLUMN id SET DEFAULT nextval('categories_questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY changelogs ALTER COLUMN id SET DEFAULT nextval('changelogs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comment_revisions ALTER COLUMN id SET DEFAULT nextval('comment_revisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY context_users ALTER COLUMN id SET DEFAULT nextval('context_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY document_revisions ALTER COLUMN id SET DEFAULT nextval('document_revisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents ALTER COLUMN id SET DEFAULT nextval('documents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY emails ALTER COLUMN id SET DEFAULT nextval('emails_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY evaluation_revisions ALTER COLUMN id SET DEFAULT nextval('evaluation_revisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY evaluations ALTER COLUMN id SET DEFAULT nextval('evaluations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY favorites ALTER COLUMN id SET DEFAULT nextval('favorites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY followings ALTER COLUMN id SET DEFAULT nextval('followings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_revisions ALTER COLUMN id SET DEFAULT nextval('group_revisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY groups ALTER COLUMN id SET DEFAULT nextval('groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY labelings ALTER COLUMN id SET DEFAULT nextval('labelings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY labels ALTER COLUMN id SET DEFAULT nextval('labels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lists ALTER COLUMN id SET DEFAULT nextval('lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mooc_category_contents ALTER COLUMN id SET DEFAULT nextval('mooc_category_contents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY news ALTER COLUMN id SET DEFAULT nextval('news_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY question_profiles ALTER COLUMN id SET DEFAULT nextval('question_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY question_revisions ALTER COLUMN id SET DEFAULT nextval('question_revisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY question_types ALTER COLUMN id SET DEFAULT nextval('question_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY slido_events ALTER COLUMN id SET DEFAULT nextval('slido_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_profiles ALTER COLUMN id SET DEFAULT nextval('user_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY views ALTER COLUMN id SET DEFAULT nextval('views_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY votes ALTER COLUMN id SET DEFAULT nextval('votes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY watchings ALTER COLUMN id SET DEFAULT nextval('watchings_id_seq'::regclass);


--
-- Name: ab_groupings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: answer_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY answer_profiles
    ADD CONSTRAINT answer_profiles_pkey PRIMARY KEY (id);


--
-- Name: answer_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY answer_revisions
    ADD CONSTRAINT answer_revisions_pkey PRIMARY KEY (id);


--
-- Name: answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories_questions
    ADD CONSTRAINT categories_questions_pkey PRIMARY KEY (id);


--
-- Name: changelogs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY changelogs
    ADD CONSTRAINT changelogs_pkey PRIMARY KEY (id);


--
-- Name: comment_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comment_revisions
    ADD CONSTRAINT comment_revisions_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: context_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY context_users
    ADD CONSTRAINT context_users_pkey PRIMARY KEY (id);


--
-- Name: document_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY document_revisions
    ADD CONSTRAINT document_revisions_pkey PRIMARY KEY (id);


--
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY emails
    ADD CONSTRAINT emails_pkey PRIMARY KEY (id);


--
-- Name: evaluation_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY evaluation_revisions
    ADD CONSTRAINT evaluation_revisions_pkey PRIMARY KEY (id);


--
-- Name: evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY evaluations
    ADD CONSTRAINT evaluations_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: favourites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY favorites
    ADD CONSTRAINT favourites_pkey PRIMARY KEY (id);


--
-- Name: followings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY followings
    ADD CONSTRAINT followings_pkey PRIMARY KEY (id);


--
-- Name: group_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_revisions
    ADD CONSTRAINT group_revisions_pkey PRIMARY KEY (id);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: labelings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY labelings
    ADD CONSTRAINT labelings_pkey PRIMARY KEY (id);


--
-- Name: labels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY labels
    ADD CONSTRAINT labels_pkey PRIMARY KEY (id);


--
-- Name: lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);


--
-- Name: mooc_category_contents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mooc_category_contents
    ADD CONSTRAINT mooc_category_contents_pkey PRIMARY KEY (id);


--
-- Name: mooclet_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY news
    ADD CONSTRAINT news_pkey PRIMARY KEY (id);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: question_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY question_profiles
    ADD CONSTRAINT question_profiles_pkey PRIMARY KEY (id);


--
-- Name: question_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY question_revisions
    ADD CONSTRAINT question_revisions_pkey PRIMARY KEY (id);


--
-- Name: question_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY question_types
    ADD CONSTRAINT question_types_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: slido_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY slido_events
    ADD CONSTRAINT slido_events_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: views_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY views
    ADD CONSTRAINT views_pkey PRIMARY KEY (id);


--
-- Name: votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: watchings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY watchings
    ADD CONSTRAINT watchings_pkey PRIMARY KEY (id);


--
-- Name: index_ab_groupings_on_ab_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_action ON activities USING btree (action);


--
-- Name: index_activities_on_anonymous; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_anonymous ON activities USING btree (anonymous);


--
-- Name: index_activities_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_created_at ON activities USING btree (created_at);


--
-- Name: index_activities_on_created_on; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_created_on ON activities USING btree (created_on);


--
-- Name: index_activities_on_initiator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_initiator_id ON activities USING btree (initiator_id);


--
-- Name: index_activities_on_resource_id_and_resource_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_resource_id_and_resource_type ON activities USING btree (resource_id, resource_type);


--
-- Name: index_activities_on_resource_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_resource_type ON activities USING btree (resource_type);


--
-- Name: index_answer_profiles_on_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answer_profiles_on_answer_id ON answer_profiles USING btree (answer_id);


--
-- Name: index_answer_revisions_on_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answer_revisions_on_answer_id ON answer_revisions USING btree (answer_id);


--
-- Name: index_answer_revisions_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answer_revisions_on_deleted ON answer_revisions USING btree (deleted);


--
-- Name: index_answer_revisions_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answer_revisions_on_deletor_id ON answer_revisions USING btree (deletor_id);


--
-- Name: index_answer_revisions_on_editor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answer_revisions_on_editor_id ON answer_revisions USING btree (editor_id);


--
-- Name: index_answers_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answers_on_author_id ON answers USING btree (author_id);


--
-- Name: index_answers_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answers_on_deleted ON answers USING btree (deleted);


--
-- Name: index_answers_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answers_on_deletor_id ON answers USING btree (deletor_id);


--
-- Name: index_answers_on_edited; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answers_on_edited ON answers USING btree (edited);


--
-- Name: index_answers_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answers_on_question_id ON answers USING btree (question_id);


--
-- Name: index_answers_on_stack_exchange_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_answers_on_stack_exchange_uuid ON answers USING btree (stack_exchange_uuid);


--
-- Name: index_answers_on_votes_difference; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answers_on_votes_difference ON answers USING btree (votes_difference);


--
-- Name: index_answers_on_votes_lb_wsci_bp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answers_on_votes_lb_wsci_bp ON answers USING btree (votes_lb_wsci_bp);


--
-- Name: index_assignments_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assignments_on_category_id ON assignments USING btree (category_id);


--
-- Name: index_assignments_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assignments_on_role_id ON assignments USING btree (role_id);


--
-- Name: index_assignments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assignments_on_user_id ON assignments USING btree (user_id);


--
-- Name: index_assignments_on_user_id_and_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_assignments_on_user_id_and_category_id ON assignments USING btree (user_id, category_id);


--
-- Name: index_attachments_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_author_id ON attachments USING btree (author_id);


--
-- Name: index_attachments_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_deletor_id ON attachments USING btree (deletor_id);


--
-- Name: index_categories_on_lft; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_lft ON categories USING btree (lft);


--
-- Name: index_categories_on_lti_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_lti_id ON categories USING btree (lti_id);


--
-- Name: index_categories_on_parent_id_and_uuid_and_lti_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categories_on_parent_id_and_uuid_and_lti_id ON categories USING btree (parent_id, uuid, lti_id);


--
-- Name: index_categories_on_rgt; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_rgt ON categories USING btree (rgt);


--
-- Name: index_categories_on_slido_username; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_slido_username ON categories USING btree (slido_username);


--
-- Name: index_categories_questions_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_questions_on_deletor_id ON categories_questions USING btree (deletor_id);


--
-- Name: index_changelogs_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_changelogs_on_created_at ON changelogs USING btree (created_at);


--
-- Name: index_changelogs_on_version; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_changelogs_on_version ON changelogs USING btree (version);


--
-- Name: index_comment_revisions_on_comment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comment_revisions_on_comment_id ON comment_revisions USING btree (comment_id);


--
-- Name: index_comment_revisions_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comment_revisions_on_deleted ON comment_revisions USING btree (deleted);


--
-- Name: index_comment_revisions_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comment_revisions_on_deletor_id ON comment_revisions USING btree (deletor_id);


--
-- Name: index_comment_revisions_on_editor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comment_revisions_on_editor_id ON comment_revisions USING btree (editor_id);


--
-- Name: index_comments_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_author_id ON comments USING btree (author_id);


--
-- Name: index_comments_on_commentable_id_and_commentable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_commentable_id_and_commentable_type ON comments USING btree (commentable_id, commentable_type);


--
-- Name: index_comments_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_deleted ON comments USING btree (deleted);


--
-- Name: index_comments_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_deletor_id ON comments USING btree (deletor_id);


--
-- Name: index_comments_on_edited; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_edited ON comments USING btree (edited);


--
-- Name: index_comments_on_stack_exchange_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_comments_on_stack_exchange_uuid ON comments USING btree (stack_exchange_uuid);


--
-- Name: index_context_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_context_users_on_user_id ON context_users USING btree (user_id);


--
-- Name: index_document_revisions_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_document_revisions_on_deleted ON document_revisions USING btree (deleted);


--
-- Name: index_document_revisions_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_document_revisions_on_deletor_id ON document_revisions USING btree (deletor_id);


--
-- Name: index_document_revisions_on_document_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_document_revisions_on_document_id ON document_revisions USING btree (document_id);


--
-- Name: index_document_revisions_on_editor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_document_revisions_on_editor_id ON document_revisions USING btree (editor_id);


--
-- Name: index_documents_on_anonymous; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_anonymous ON documents USING btree (anonymous);


--
-- Name: index_documents_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_deletor_id ON documents USING btree (deletor_id);


--
-- Name: index_documents_on_edited; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_edited ON documents USING btree (edited);


--
-- Name: index_documents_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_group_id ON documents USING btree (group_id);


--
-- Name: index_documents_on_questions_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_questions_count ON documents USING btree (questions_count);


--
-- Name: index_documents_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_title ON documents USING btree (title);


--
-- Name: index_evaluation_revisions_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_evaluation_revisions_on_deleted ON evaluation_revisions USING btree (deleted);


--
-- Name: index_evaluation_revisions_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_evaluation_revisions_on_deletor_id ON evaluation_revisions USING btree (deletor_id);


--
-- Name: index_evaluation_revisions_on_editor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_evaluation_revisions_on_editor_id ON evaluation_revisions USING btree (editor_id);


--
-- Name: index_evaluation_revisions_on_evaluation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_evaluation_revisions_on_evaluation_id ON evaluation_revisions USING btree (evaluation_id);


--
-- Name: index_evaluations_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_evaluations_on_author_id ON evaluations USING btree (author_id);


--
-- Name: index_evaluations_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_evaluations_on_deleted ON evaluations USING btree (deleted);


--
-- Name: index_evaluations_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_evaluations_on_deletor_id ON evaluations USING btree (deletor_id);


--
-- Name: index_evaluations_on_edited; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_evaluations_on_edited ON evaluations USING btree (edited);


--
-- Name: index_evaluations_on_evaluable_id_and_evaluable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_evaluations_on_evaluable_id_and_evaluable_type ON evaluations USING btree (evaluable_id, evaluable_type);


--
-- Name: index_events_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_created_at ON events USING btree (created_at);


--
-- Name: index_favorites_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_favorites_on_deleted ON favorites USING btree (deleted);


--
-- Name: index_favorites_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_favorites_on_deletor_id ON favorites USING btree (deletor_id);


--
-- Name: index_favorites_on_favorer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_favorites_on_favorer_id ON favorites USING btree (favorer_id);


--
-- Name: index_favorites_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_favorites_on_question_id ON favorites USING btree (question_id);


--
-- Name: index_favorites_on_stack_exchange_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_favorites_on_stack_exchange_uuid ON favorites USING btree (stack_exchange_uuid);


--
-- Name: index_favorites_on_unique_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_favorites_on_unique_key ON favorites USING btree (favorer_id, question_id);


--
-- Name: index_followings_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_followings_on_deleted ON followings USING btree (deleted);


--
-- Name: index_followings_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_followings_on_deletor_id ON followings USING btree (deletor_id);


--
-- Name: index_followings_on_followee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_followings_on_followee_id ON followings USING btree (followee_id);


--
-- Name: index_followings_on_follower_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_followings_on_follower_id ON followings USING btree (follower_id);


--
-- Name: index_followings_on_unique_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_followings_on_unique_key ON followings USING btree (follower_id, followee_id);


--
-- Name: index_for_unique_category_questions; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_for_unique_category_questions ON categories_questions USING btree (question_id, category_id, shared_through_category_id);


--
-- Name: index_group_revisions_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_group_revisions_on_deleted ON group_revisions USING btree (deleted);


--
-- Name: index_group_revisions_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_group_revisions_on_deletor_id ON group_revisions USING btree (deletor_id);


--
-- Name: index_group_revisions_on_editor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_group_revisions_on_editor_id ON group_revisions USING btree (editor_id);


--
-- Name: index_group_revisions_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_group_revisions_on_group_id ON group_revisions USING btree (group_id);


--
-- Name: index_groups_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_groups_on_creator_id ON groups USING btree (creator_id);


--
-- Name: index_groups_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_groups_on_deletor_id ON groups USING btree (deletor_id);


--
-- Name: index_groups_on_edited; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_groups_on_edited ON groups USING btree (edited);


--
-- Name: index_groups_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_groups_on_title ON groups USING btree (title);


--
-- Name: index_labelings_on_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_labelings_on_answer_id ON labelings USING btree (answer_id);


--
-- Name: index_labelings_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_labelings_on_author_id ON labelings USING btree (author_id);


--
-- Name: index_labelings_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_labelings_on_deleted ON labelings USING btree (deleted);


--
-- Name: index_labelings_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_labelings_on_deletor_id ON labelings USING btree (deletor_id);


--
-- Name: index_labelings_on_label_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_labelings_on_label_id ON labelings USING btree (label_id);


--
-- Name: index_labelings_on_stack_exchange_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_labelings_on_stack_exchange_uuid ON labelings USING btree (stack_exchange_uuid);


--
-- Name: index_labelings_on_unique_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_labelings_on_unique_key ON labelings USING btree (answer_id, label_id, author_id);


--
-- Name: index_labels_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_labels_on_value ON labels USING btree (value);


--
-- Name: index_lists_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lists_on_category_id ON lists USING btree (category_id);


--
-- Name: index_lists_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lists_on_deleted ON lists USING btree (deleted);


--
-- Name: index_lists_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lists_on_deletor_id ON lists USING btree (deletor_id);


--
-- Name: index_lists_on_lister_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lists_on_lister_id ON lists USING btree (lister_id);


--
-- Name: index_mooc_category_contents_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mooc_category_contents_on_category_id ON mooc_category_contents USING btree (category_id);


--
-- Name: index_notifications_on_action; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_action ON notifications USING btree (action);


--
-- Name: index_notifications_on_anonymous; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_anonymous ON notifications USING btree (anonymous);


--
-- Name: index_notifications_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_created_at ON notifications USING btree (created_at);


--
-- Name: index_notifications_on_initiator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_initiator_id ON notifications USING btree (initiator_id);


--
-- Name: index_notifications_on_recipient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_recipient_id ON notifications USING btree (recipient_id);


--
-- Name: index_notifications_on_resource_id_and_resource_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_resource_id_and_resource_type ON notifications USING btree (resource_id, resource_type);


--
-- Name: index_notifications_on_resource_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_resource_type ON notifications USING btree (resource_type);


--
-- Name: index_notifications_on_unread; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_unread ON notifications USING btree (unread);


--
-- Name: index_question_profiles_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_question_profiles_on_question_id ON question_profiles USING btree (question_id);


--
-- Name: index_question_revisions_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_question_revisions_on_deleted ON question_revisions USING btree (deleted);


--
-- Name: index_question_revisions_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_question_revisions_on_deletor_id ON question_revisions USING btree (deletor_id);


--
-- Name: index_question_revisions_on_document_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_question_revisions_on_document_id ON question_revisions USING btree (document_id);


--
-- Name: index_question_revisions_on_editor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_question_revisions_on_editor_id ON question_revisions USING btree (editor_id);


--
-- Name: index_question_revisions_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_question_revisions_on_question_id ON question_revisions USING btree (question_id);


--
-- Name: index_questions_on_anonymous; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_anonymous ON questions USING btree (anonymous);


--
-- Name: index_questions_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_author_id ON questions USING btree (author_id);


--
-- Name: index_questions_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_category_id ON questions USING btree (category_id);


--
-- Name: index_questions_on_closer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_closer_id ON questions USING btree (closer_id);


--
-- Name: index_questions_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_deleted ON questions USING btree (deleted);


--
-- Name: index_questions_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_deletor_id ON questions USING btree (deletor_id);


--
-- Name: index_questions_on_document_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_document_id ON questions USING btree (document_id);


--
-- Name: index_questions_on_edited; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_edited ON questions USING btree (edited);


--
-- Name: index_questions_on_question_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_question_type_id ON questions USING btree (question_type_id);


--
-- Name: index_questions_on_slido_question_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_questions_on_slido_question_uuid ON questions USING btree (slido_question_uuid);


--
-- Name: index_questions_on_stack_exchange_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_questions_on_stack_exchange_uuid ON questions USING btree (stack_exchange_uuid);


--
-- Name: index_questions_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_title ON questions USING btree (title);


--
-- Name: index_questions_on_touched_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_touched_at ON questions USING btree (touched_at);


--
-- Name: index_questions_on_votes_difference; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_votes_difference ON questions USING btree (votes_difference);


--
-- Name: index_questions_on_votes_lb_wsci_bp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_votes_lb_wsci_bp ON questions USING btree (votes_lb_wsci_bp);


--
-- Name: index_recommendations_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_roles_on_name ON roles USING btree (name);


--
-- Name: index_slido_events_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_slido_events_on_category_id ON slido_events USING btree (category_id);


--
-- Name: index_slido_events_on_ended_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_slido_events_on_ended_at ON slido_events USING btree (ended_at);


--
-- Name: index_slido_events_on_started_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_slido_events_on_started_at ON slido_events USING btree (started_at);


--
-- Name: index_slido_events_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_slido_events_on_uuid ON slido_events USING btree (uuid);


--
-- Name: index_taggings_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_author_id ON taggings USING btree (author_id);


--
-- Name: index_taggings_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_deleted ON taggings USING btree (deleted);


--
-- Name: index_taggings_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_deletor_id ON taggings USING btree (deletor_id);


--
-- Name: index_taggings_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_question_id ON taggings USING btree (question_id);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tag_id ON taggings USING btree (tag_id);


--
-- Name: index_taggings_on_unique_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_taggings_on_unique_key ON taggings USING btree (question_id, tag_id, author_id);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);


--
-- Name: index_tags_on_stack_exchange_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_stack_exchange_uuid ON tags USING btree (stack_exchange_uuid);


--
-- Name: index_user_profiles_on_targetable_id_and_targetable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_profiles_on_targetable_id_and_targetable_type ON user_profiles USING btree (targetable_id, targetable_type);


--
-- Name: index_user_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_profiles_on_user_id ON user_profiles USING btree (user_id);


--
-- Name: index_users_on_ais_login; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_ais_login ON users USING btree (ais_login);


--
-- Name: index_users_on_ais_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_ais_uid ON users USING btree (ais_uid);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_facebook_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_facebook_uid ON users USING btree (facebook_uid);


--
-- Name: index_users_on_first; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_first ON users USING btree (first);


--
-- Name: index_users_on_last; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_last ON users USING btree (last);


--
-- Name: index_users_on_login; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_login ON users USING btree (login);


--
-- Name: index_users_on_middle; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_middle ON users USING btree (middle);


--
-- Name: index_users_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_name ON users USING btree (name);


--
-- Name: index_users_on_nick; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_nick ON users USING btree (nick);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_role ON users USING btree (role);


--
-- Name: index_users_on_stack_exchange_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_stack_exchange_uuid ON users USING btree (stack_exchange_uuid);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON users USING btree (unlock_token);


--
-- Name: index_views_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_views_on_deleted ON views USING btree (deleted);


--
-- Name: index_views_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_views_on_deletor_id ON views USING btree (deletor_id);


--
-- Name: index_views_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_views_on_question_id ON views USING btree (question_id);


--
-- Name: index_views_on_viewer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_views_on_viewer_id ON views USING btree (viewer_id);


--
-- Name: index_votes_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_deleted ON votes USING btree (deleted);


--
-- Name: index_votes_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_deletor_id ON votes USING btree (deletor_id);


--
-- Name: index_votes_on_positive; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_positive ON votes USING btree (positive);


--
-- Name: index_votes_on_stack_exchange_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_votes_on_stack_exchange_uuid ON votes USING btree (stack_exchange_uuid);


--
-- Name: index_votes_on_unique_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_votes_on_unique_key ON votes USING btree (voter_id, votable_id, votable_type, stack_exchange_uuid);


--
-- Name: index_votes_on_votable_id_and_votable_type_and_positive; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_votable_id_and_votable_type_and_positive ON votes USING btree (votable_id, votable_type, positive);


--
-- Name: index_votes_on_voter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_voter_id ON votes USING btree (voter_id);


--
-- Name: index_watchings_on_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_watchings_on_deleted ON watchings USING btree (deleted);


--
-- Name: index_watchings_on_deletor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_watchings_on_deletor_id ON watchings USING btree (deletor_id);


--
-- Name: index_watchings_on_unique_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_watchings_on_unique_key ON watchings USING btree (watcher_id, watchable_id, watchable_type, context);


--
-- Name: index_watchings_on_watchable_id_and_watchable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_watchings_on_watchable_id_and_watchable_type ON watchings USING btree (watchable_id, watchable_type);


--
-- Name: index_watchings_on_watcher_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_watchings_on_watcher_id ON watchings USING btree (watcher_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20131012150605');

INSERT INTO schema_migrations (version) VALUES ('20131012191904');

INSERT INTO schema_migrations (version) VALUES ('20131029183142');

INSERT INTO schema_migrations (version) VALUES ('20131029185422');

INSERT INTO schema_migrations (version) VALUES ('20131030000407');

INSERT INTO schema_migrations (version) VALUES ('20131030003524');

INSERT INTO schema_migrations (version) VALUES ('20131102201136');

INSERT INTO schema_migrations (version) VALUES ('20131105182120');

INSERT INTO schema_migrations (version) VALUES ('20131106113259');

INSERT INTO schema_migrations (version) VALUES ('20131106113301');

INSERT INTO schema_migrations (version) VALUES ('20131108234645');

INSERT INTO schema_migrations (version) VALUES ('20131108235150');

INSERT INTO schema_migrations (version) VALUES ('20131111001542');

INSERT INTO schema_migrations (version) VALUES ('20131114192420');

INSERT INTO schema_migrations (version) VALUES ('20131115002122');

INSERT INTO schema_migrations (version) VALUES ('20131119115825');

INSERT INTO schema_migrations (version) VALUES ('20131120181708');

INSERT INTO schema_migrations (version) VALUES ('20131120181752');

INSERT INTO schema_migrations (version) VALUES ('20131120181900');

INSERT INTO schema_migrations (version) VALUES ('20131120181906');

INSERT INTO schema_migrations (version) VALUES ('20131120181914');

INSERT INTO schema_migrations (version) VALUES ('20131120181929');

INSERT INTO schema_migrations (version) VALUES ('20131120182517');

INSERT INTO schema_migrations (version) VALUES ('20131120182818');

INSERT INTO schema_migrations (version) VALUES ('20131120182855');

INSERT INTO schema_migrations (version) VALUES ('20131120184915');

INSERT INTO schema_migrations (version) VALUES ('20131120190247');

INSERT INTO schema_migrations (version) VALUES ('20131123103705');

INSERT INTO schema_migrations (version) VALUES ('20131124171012');

INSERT INTO schema_migrations (version) VALUES ('20131127003041');

INSERT INTO schema_migrations (version) VALUES ('20131202201143');

INSERT INTO schema_migrations (version) VALUES ('20131205213336');

INSERT INTO schema_migrations (version) VALUES ('20131209222109');

INSERT INTO schema_migrations (version) VALUES ('20131210012349');

INSERT INTO schema_migrations (version) VALUES ('20140118124033');

INSERT INTO schema_migrations (version) VALUES ('20140121142825');

INSERT INTO schema_migrations (version) VALUES ('20140122212035');

INSERT INTO schema_migrations (version) VALUES ('20140130105541');

INSERT INTO schema_migrations (version) VALUES ('20140131102843');

INSERT INTO schema_migrations (version) VALUES ('20140206190919');

INSERT INTO schema_migrations (version) VALUES ('20140208172456');

INSERT INTO schema_migrations (version) VALUES ('20140209112906');

INSERT INTO schema_migrations (version) VALUES ('20140210084759');

INSERT INTO schema_migrations (version) VALUES ('20140210084942');

INSERT INTO schema_migrations (version) VALUES ('20140210085201');

INSERT INTO schema_migrations (version) VALUES ('20140210161235');

INSERT INTO schema_migrations (version) VALUES ('20140216125125');

INSERT INTO schema_migrations (version) VALUES ('20140216132318');

INSERT INTO schema_migrations (version) VALUES ('20140221155422');

INSERT INTO schema_migrations (version) VALUES ('20140221163623');

INSERT INTO schema_migrations (version) VALUES ('20140221164020');

INSERT INTO schema_migrations (version) VALUES ('20140224161859');

INSERT INTO schema_migrations (version) VALUES ('20140226035359');

INSERT INTO schema_migrations (version) VALUES ('20140226112332');

INSERT INTO schema_migrations (version) VALUES ('20140226121136');

INSERT INTO schema_migrations (version) VALUES ('20140227094329');

INSERT INTO schema_migrations (version) VALUES ('20140227095246');

INSERT INTO schema_migrations (version) VALUES ('20140227095502');

INSERT INTO schema_migrations (version) VALUES ('20140227151446');

INSERT INTO schema_migrations (version) VALUES ('20140305114254');

INSERT INTO schema_migrations (version) VALUES ('20140310195122');

INSERT INTO schema_migrations (version) VALUES ('20140310204944');

INSERT INTO schema_migrations (version) VALUES ('20140310223035');

INSERT INTO schema_migrations (version) VALUES ('20140311001031');

INSERT INTO schema_migrations (version) VALUES ('20140311223652');

INSERT INTO schema_migrations (version) VALUES ('20140311225104');

INSERT INTO schema_migrations (version) VALUES ('20140312105054');

INSERT INTO schema_migrations (version) VALUES ('20140314110311');

INSERT INTO schema_migrations (version) VALUES ('20140315163927');

INSERT INTO schema_migrations (version) VALUES ('20140317201604');

INSERT INTO schema_migrations (version) VALUES ('20140321084147');

INSERT INTO schema_migrations (version) VALUES ('20140322113048');

INSERT INTO schema_migrations (version) VALUES ('20140329011652');

INSERT INTO schema_migrations (version) VALUES ('20140329121310');

INSERT INTO schema_migrations (version) VALUES ('20140330175530');

INSERT INTO schema_migrations (version) VALUES ('20140330180048');

INSERT INTO schema_migrations (version) VALUES ('20140331225953');

INSERT INTO schema_migrations (version) VALUES ('20140403094835');

INSERT INTO schema_migrations (version) VALUES ('20140403095606');

INSERT INTO schema_migrations (version) VALUES ('20140403111720');

INSERT INTO schema_migrations (version) VALUES ('20140403181644');

INSERT INTO schema_migrations (version) VALUES ('20140403190759');

INSERT INTO schema_migrations (version) VALUES ('20140403192531');

INSERT INTO schema_migrations (version) VALUES ('20140403192541');

INSERT INTO schema_migrations (version) VALUES ('20140408184343');

INSERT INTO schema_migrations (version) VALUES ('20140408184444');

INSERT INTO schema_migrations (version) VALUES ('20140409143851');

INSERT INTO schema_migrations (version) VALUES ('20140409144529');

INSERT INTO schema_migrations (version) VALUES ('20140409144728');

INSERT INTO schema_migrations (version) VALUES ('20140414184427');

INSERT INTO schema_migrations (version) VALUES ('20140417162824');

INSERT INTO schema_migrations (version) VALUES ('20140417212431');

INSERT INTO schema_migrations (version) VALUES ('20140417213144');

INSERT INTO schema_migrations (version) VALUES ('20140417213702');

INSERT INTO schema_migrations (version) VALUES ('20140418210243');

INSERT INTO schema_migrations (version) VALUES ('20140419150139');

INSERT INTO schema_migrations (version) VALUES ('20140419205433');

INSERT INTO schema_migrations (version) VALUES ('20140420091223');

INSERT INTO schema_migrations (version) VALUES ('20140420093029');

INSERT INTO schema_migrations (version) VALUES ('20140421091947');

INSERT INTO schema_migrations (version) VALUES ('20140423082147');

INSERT INTO schema_migrations (version) VALUES ('20140423123809');

INSERT INTO schema_migrations (version) VALUES ('20140424163620');

INSERT INTO schema_migrations (version) VALUES ('20140429003614');

INSERT INTO schema_migrations (version) VALUES ('20140513162801');

INSERT INTO schema_migrations (version) VALUES ('20140523053735');

INSERT INTO schema_migrations (version) VALUES ('20140523053753');

INSERT INTO schema_migrations (version) VALUES ('20140523053816');

INSERT INTO schema_migrations (version) VALUES ('20140611004811');

INSERT INTO schema_migrations (version) VALUES ('20141004130146');

INSERT INTO schema_migrations (version) VALUES ('20141008092820');

INSERT INTO schema_migrations (version) VALUES ('20141008095014');

INSERT INTO schema_migrations (version) VALUES ('20141023161800');

INSERT INTO schema_migrations (version) VALUES ('20141025092934');

INSERT INTO schema_migrations (version) VALUES ('20141026134711');

INSERT INTO schema_migrations (version) VALUES ('20141026134908');

INSERT INTO schema_migrations (version) VALUES ('20141027134900');

INSERT INTO schema_migrations (version) VALUES ('20141101205230');

INSERT INTO schema_migrations (version) VALUES ('20141101205246');

INSERT INTO schema_migrations (version) VALUES ('20141101214034');

INSERT INTO schema_migrations (version) VALUES ('20141103003512');

INSERT INTO schema_migrations (version) VALUES ('20141103192331');

INSERT INTO schema_migrations (version) VALUES ('20141117173517');

INSERT INTO schema_migrations (version) VALUES ('20141201144422');

INSERT INTO schema_migrations (version) VALUES ('20141201163635');

INSERT INTO schema_migrations (version) VALUES ('20141201163936');

INSERT INTO schema_migrations (version) VALUES ('20141201232355');

INSERT INTO schema_migrations (version) VALUES ('20150323112635');

INSERT INTO schema_migrations (version) VALUES ('20150323125346');

INSERT INTO schema_migrations (version) VALUES ('20150411100033');

INSERT INTO schema_migrations (version) VALUES ('20151012143719');

INSERT INTO schema_migrations (version) VALUES ('20151014122011');

INSERT INTO schema_migrations (version) VALUES ('20151103135754');

INSERT INTO schema_migrations (version) VALUES ('20151106073333');

INSERT INTO schema_migrations (version) VALUES ('20151106073334');

INSERT INTO schema_migrations (version) VALUES ('20151106073335');

INSERT INTO schema_migrations (version) VALUES ('20151107171100');

INSERT INTO schema_migrations (version) VALUES ('20151107171101');

INSERT INTO schema_migrations (version) VALUES ('20151107171102');

INSERT INTO schema_migrations (version) VALUES ('20151107171103');

INSERT INTO schema_migrations (version) VALUES ('20151108154348');

INSERT INTO schema_migrations (version) VALUES ('20151108201548');

INSERT INTO schema_migrations (version) VALUES ('20151109234218');

INSERT INTO schema_migrations (version) VALUES ('20151110003132');

INSERT INTO schema_migrations (version) VALUES ('20151110003133');

INSERT INTO schema_migrations (version) VALUES ('20151119105858');

INSERT INTO schema_migrations (version) VALUES ('20151122110354');

INSERT INTO schema_migrations (version) VALUES ('20151122112444');

INSERT INTO schema_migrations (version) VALUES ('20151130051140');

INSERT INTO schema_migrations (version) VALUES ('20151207221041');

INSERT INTO schema_migrations (version) VALUES ('20151213225917');

INSERT INTO schema_migrations (version) VALUES ('20160220170558');

INSERT INTO schema_migrations (version) VALUES ('20160221111744');

INSERT INTO schema_migrations (version) VALUES ('20160224152624');

INSERT INTO schema_migrations (version) VALUES ('20160224210832');

INSERT INTO schema_migrations (version) VALUES ('20160224210833');

INSERT INTO schema_migrations (version) VALUES ('20160228103010');

INSERT INTO schema_migrations (version) VALUES ('20160229115039');

INSERT INTO schema_migrations (version) VALUES ('20160306150418');

INSERT INTO schema_migrations (version) VALUES ('20160306194117');

INSERT INTO schema_migrations (version) VALUES ('20160306211255');

INSERT INTO schema_migrations (version) VALUES ('20160307103948');

INSERT INTO schema_migrations (version) VALUES ('20160313091803');

INSERT INTO schema_migrations (version) VALUES ('20160330210355');

INSERT INTO schema_migrations (version) VALUES ('20160402191527');

INSERT INTO schema_migrations (version) VALUES ('20160402205422');

INSERT INTO schema_migrations (version) VALUES ('20160409094926');

INSERT INTO schema_migrations (version) VALUES ('20160417130646');

INSERT INTO schema_migrations (version) VALUES ('20160417135429');

INSERT INTO schema_migrations (version) VALUES ('20160503083015');

INSERT INTO schema_migrations (version) VALUES ('20160507084030');

INSERT INTO schema_migrations (version) VALUES ('20160509144416');

INSERT INTO schema_migrations (version) VALUES ('20160516203213');

INSERT INTO schema_migrations (version) VALUES ('20160611205335');

INSERT INTO schema_migrations (version) VALUES ('20160913174811');

INSERT INTO schema_migrations (version) VALUES ('20160930145553');

INSERT INTO schema_migrations (version) VALUES ('20161004171530');

INSERT INTO schema_migrations (version) VALUES ('20161006214540');

INSERT INTO schema_migrations (version) VALUES ('20161014154617');

INSERT INTO schema_migrations (version) VALUES ('20161014155314');

INSERT INTO schema_migrations (version) VALUES ('20161106125632');

INSERT INTO schema_migrations (version) VALUES ('20161106171609');

INSERT INTO schema_migrations (version) VALUES ('20161106171728');

INSERT INTO schema_migrations (version) VALUES ('20161110161857');

INSERT INTO schema_migrations (version) VALUES ('20161115200549');

INSERT INTO schema_migrations (version) VALUES ('20161119140437');

INSERT INTO schema_migrations (version) VALUES ('20161122154704');

INSERT INTO schema_migrations (version) VALUES ('20161202180133');

INSERT INTO schema_migrations (version) VALUES ('20170115175555');

INSERT INTO schema_migrations (version) VALUES ('20170203140643');

INSERT INTO schema_migrations (version) VALUES ('20170602193255');

INSERT INTO schema_migrations (version) VALUES ('20170603164809');

