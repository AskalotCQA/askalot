--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

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
-- Name: activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activities (
    id integer NOT NULL,
    initiator_id integer NOT NULL,
    resource_id integer NOT NULL,
    resource_type character varying(255) NOT NULL,
    action character varying(255) NOT NULL,
    created_on date NOT NULL,
    updated_on date NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    anonymous boolean DEFAULT false NOT NULL
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
-- Name: answer_revisions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE answer_revisions (
    id integer NOT NULL,
    answer_id integer NOT NULL,
    editor_id integer NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    deletor_id integer
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
-- Name: answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE answers (
    id integer NOT NULL,
    author_id integer NOT NULL,
    question_id integer NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    votes_difference integer DEFAULT 0 NOT NULL,
    comments_count integer DEFAULT 0 NOT NULL,
    votes_count integer DEFAULT 0 NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    votes_lb_wsci_bp numeric(13,12) DEFAULT 0 NOT NULL,
    edited_at timestamp without time zone,
    editor_id integer,
    deleted_at timestamp without time zone,
    deletor_id integer,
    edited boolean DEFAULT false NOT NULL,
    evaluations_count integer DEFAULT 0 NOT NULL
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
-- Name: assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    category_id integer NOT NULL,
    role_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
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
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tags character varying(255)[] DEFAULT '{}'::character varying[],
    questions_count integer DEFAULT 0 NOT NULL,
    slido_username character varying(255),
    slido_event_prefix character varying(255)
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
-- Name: changelogs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: comment_revisions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comment_revisions (
    id integer NOT NULL,
    comment_id integer NOT NULL,
    editor_id integer NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    deletor_id integer
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
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    author_id integer NOT NULL,
    commentable_id integer NOT NULL,
    commentable_type character varying(255) NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    edited_at timestamp without time zone,
    editor_id integer,
    deleted_at timestamp without time zone,
    deletor_id integer,
    edited boolean DEFAULT false NOT NULL
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
-- Name: evaluations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
    deleted_at timestamp without time zone,
    deletor_id integer
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
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: favorites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE favorites (
    id integer NOT NULL,
    favorer_id integer NOT NULL,
    question_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    deletor_id integer
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
-- Name: followings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: labelings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE labelings (
    id integer NOT NULL,
    author_id integer NOT NULL,
    answer_id integer NOT NULL,
    label_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    deletor_id integer
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
-- Name: labels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
    anonymous boolean DEFAULT false NOT NULL
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
-- Name: question_revisions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE question_revisions (
    id integer NOT NULL,
    question_id integer NOT NULL,
    editor_id integer NOT NULL,
    category character varying(255) NOT NULL,
    tags character varying(255)[] NOT NULL,
    title character varying(255) NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    deletor_id integer
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
-- Name: questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questions (
    id integer NOT NULL,
    author_id integer NOT NULL,
    category_id integer NOT NULL,
    title character varying(255) NOT NULL,
    text text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    votes_difference integer DEFAULT 0 NOT NULL,
    anonymous boolean DEFAULT false NOT NULL,
    answers_count integer DEFAULT 0 NOT NULL,
    comments_count integer DEFAULT 0 NOT NULL,
    favorites_count integer DEFAULT 0 NOT NULL,
    views_count integer DEFAULT 0 NOT NULL,
    votes_count integer DEFAULT 0 NOT NULL,
    slido_question_uuid integer,
    slido_event_uuid integer,
    deleted boolean DEFAULT false NOT NULL,
    votes_lb_wsci_bp numeric(13,12) DEFAULT 0 NOT NULL,
    touched_at timestamp without time zone NOT NULL,
    edited_at timestamp without time zone,
    editor_id integer,
    deleted_at timestamp without time zone,
    deletor_id integer,
    edited boolean DEFAULT false NOT NULL,
    evaluations_count integer DEFAULT 0 NOT NULL
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
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: slido_events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer NOT NULL,
    question_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    deletor_id integer,
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
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    login character varying(255) NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
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
    role character varying
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
-- Name: views; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE views (
    id integer NOT NULL,
    question_id integer NOT NULL,
    viewer_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    deletor_id integer
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
-- Name: votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE votes (
    id integer NOT NULL,
    voter_id integer NOT NULL,
    votable_id integer NOT NULL,
    votable_type character varying(255) NOT NULL,
    positive boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    deletor_id integer
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
-- Name: watchings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
    deleted_at timestamp without time zone
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

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


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

ALTER TABLE ONLY labelings ALTER COLUMN id SET DEFAULT nextval('labelings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY labels ALTER COLUMN id SET DEFAULT nextval('labels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY question_revisions ALTER COLUMN id SET DEFAULT nextval('question_revisions_id_seq'::regclass);


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
-- Name: activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: answer_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY answer_revisions
    ADD CONSTRAINT answer_revisions_pkey PRIMARY KEY (id);


--
-- Name: answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: changelogs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY changelogs
    ADD CONSTRAINT changelogs_pkey PRIMARY KEY (id);


--
-- Name: comment_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comment_revisions
    ADD CONSTRAINT comment_revisions_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY evaluations
    ADD CONSTRAINT evaluations_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: favourites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY favorites
    ADD CONSTRAINT favourites_pkey PRIMARY KEY (id);


--
-- Name: followings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY followings
    ADD CONSTRAINT followings_pkey PRIMARY KEY (id);


--
-- Name: labelings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY labelings
    ADD CONSTRAINT labelings_pkey PRIMARY KEY (id);


--
-- Name: labels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY labels
    ADD CONSTRAINT labels_pkey PRIMARY KEY (id);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: question_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY question_revisions
    ADD CONSTRAINT question_revisions_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: slido_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY slido_events
    ADD CONSTRAINT slido_events_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: views_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY views
    ADD CONSTRAINT views_pkey PRIMARY KEY (id);


--
-- Name: votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: watchings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY watchings
    ADD CONSTRAINT watchings_pkey PRIMARY KEY (id);


--
-- Name: index_activities_on_action; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_action ON activities USING btree (action);


--
-- Name: index_activities_on_anonymous; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_anonymous ON activities USING btree (anonymous);


--
-- Name: index_activities_on_created_on; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_created_on ON activities USING btree (created_on);


--
-- Name: index_activities_on_initiator_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_initiator_id ON activities USING btree (initiator_id);


--
-- Name: index_activities_on_resource_id_and_resource_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_resource_id_and_resource_type ON activities USING btree (resource_id, resource_type);


--
-- Name: index_activities_on_resource_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_resource_type ON activities USING btree (resource_type);


--
-- Name: index_answer_revisions_on_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answer_revisions_on_answer_id ON answer_revisions USING btree (answer_id);


--
-- Name: index_answer_revisions_on_deleted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answer_revisions_on_deleted ON answer_revisions USING btree (deleted);


--
-- Name: index_answer_revisions_on_deletor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answer_revisions_on_deletor_id ON answer_revisions USING btree (deletor_id);


--
-- Name: index_answer_revisions_on_editor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answer_revisions_on_editor_id ON answer_revisions USING btree (editor_id);


--
-- Name: index_answers_on_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_author_id ON answers USING btree (author_id);


--
-- Name: index_answers_on_deleted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_deleted ON answers USING btree (deleted);


--
-- Name: index_answers_on_deletor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_deletor_id ON answers USING btree (deletor_id);


--
-- Name: index_answers_on_edited; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_edited ON answers USING btree (edited);


--
-- Name: index_answers_on_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_question_id ON answers USING btree (question_id);


--
-- Name: index_answers_on_votes_difference; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_votes_difference ON answers USING btree (votes_difference);


--
-- Name: index_answers_on_votes_lb_wsci_bp; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_votes_lb_wsci_bp ON answers USING btree (votes_lb_wsci_bp);


--
-- Name: index_assignments_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_assignments_on_category_id ON assignments USING btree (category_id);


--
-- Name: index_assignments_on_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_assignments_on_role_id ON assignments USING btree (role_id);


--
-- Name: index_assignments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_assignments_on_user_id ON assignments USING btree (user_id);


--
-- Name: index_categories_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_categories_on_name ON categories USING btree (name);


--
-- Name: index_categories_on_slido_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_on_slido_username ON categories USING btree (slido_username);


--
-- Name: index_changelogs_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_changelogs_on_created_at ON changelogs USING btree (created_at);


--
-- Name: index_changelogs_on_version; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_changelogs_on_version ON changelogs USING btree (version);


--
-- Name: index_comment_revisions_on_comment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comment_revisions_on_comment_id ON comment_revisions USING btree (comment_id);


--
-- Name: index_comment_revisions_on_deleted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comment_revisions_on_deleted ON comment_revisions USING btree (deleted);


--
-- Name: index_comment_revisions_on_deletor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comment_revisions_on_deletor_id ON comment_revisions USING btree (deletor_id);


--
-- Name: index_comment_revisions_on_editor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comment_revisions_on_editor_id ON comment_revisions USING btree (editor_id);


--
-- Name: index_comments_on_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_author_id ON comments USING btree (author_id);


--
-- Name: index_comments_on_commentable_id_and_commentable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_commentable_id_and_commentable_type ON comments USING btree (commentable_id, commentable_type);


--
-- Name: index_comments_on_deleted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_deleted ON comments USING btree (deleted);


--
-- Name: index_comments_on_deletor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_deletor_id ON comments USING btree (deletor_id);


--
-- Name: index_comments_on_edited; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_edited ON comments USING btree (edited);


--
-- Name: index_evaluations_on_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_evaluations_on_author_id ON evaluations USING btree (author_id);


--
-- Name: index_evaluations_on_deleted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_evaluations_on_deleted ON evaluations USING btree (deleted);


--
-- Name: index_evaluations_on_deletor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_evaluations_on_deletor_id ON evaluations USING btree (deletor_id);


--
-- Name: index_evaluations_on_evaluable_id_and_evaluable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_evaluations_on_evaluable_id_and_evaluable_type ON evaluations USING btree (evaluable_id, evaluable_type);


--
-- Name: index_events_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_created_at ON events USING btree (created_at);


--
-- Name: index_favorites_on_deleted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_favorites_on_deleted ON favorites USING btree (deleted);


--
-- Name: index_favorites_on_deletor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_favorites_on_deletor_id ON favorites USING btree (deletor_id);


--
-- Name: index_favorites_on_favorer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_favorites_on_favorer_id ON favorites USING btree (favorer_id);


--
-- Name: index_favorites_on_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_favorites_on_question_id ON favorites USING btree (question_id);


--
-- Name: index_favorites_on_unique_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_favorites_on_unique_key ON favorites USING btree (favorer_id, question_id);


--
-- Name: index_followings_on_deleted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_followings_on_deleted ON followings USING btree (deleted);


--
-- Name: index_followings_on_deletor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_followings_on_deletor_id ON followings USING btree (deletor_id);


--
-- Name: index_followings_on_followee_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_followings_on_followee_id ON followings USING btree (followee_id);


--
-- Name: index_followings_on_follower_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_followings_on_follower_id ON followings USING btree (follower_id);


--
-- Name: index_followings_on_unique_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_followings_on_unique_key ON followings USING btree (follower_id, followee_id);


--
-- Name: index_labelings_on_answer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_labelings_on_answer_id ON labelings USING btree (answer_id);


--
-- Name: index_labelings_on_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_labelings_on_author_id ON labelings USING btree (author_id);


--
-- Name: index_labelings_on_deleted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_labelings_on_deleted ON labelings USING btree (deleted);


--
-- Name: index_labelings_on_deletor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_labelings_on_deletor_id ON labelings USING btree (deletor_id);


--
-- Name: index_labelings_on_label_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_labelings_on_label_id ON labelings USING btree (label_id);


--
-- Name: index_labelings_on_unique_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_labelings_on_unique_key ON labelings USING btree (answer_id, label_id, author_id);


--
-- Name: index_labels_on_value; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_labels_on_value ON labels USING btree (value);


--
-- Name: index_notifications_on_action; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_action ON notifications USING btree (action);


--
-- Name: index_notifications_on_anonymous; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_anonymous ON notifications USING btree (anonymous);


--
-- Name: index_notifications_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_created_at ON notifications USING btree (created_at);


--
-- Name: index_notifications_on_initiator_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_initiator_id ON notifications USING btree (initiator_id);


--
-- Name: index_notifications_on_recipient_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_recipient_id ON notifications USING btree (recipient_id);


--
-- Name: index_notifications_on_resource_id_and_resource_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_resource_id_and_resource_type ON notifications USING btree (resource_id, resource_type);


--
-- Name: index_notifications_on_resource_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_resource_type ON notifications USING btree (resource_type);


--
-- Name: index_notifications_on_unread; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_unread ON notifications USING btree (unread);


--
-- Name: index_question_revisions_on_deleted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_question_revisions_on_deleted ON question_revisions USING btree (deleted);


--
-- Name: index_question_revisions_on_deletor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_question_revisions_on_deletor_id ON question_revisions USING btree (deletor_id);


--
-- Name: index_question_revisions_on_editor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_question_revisions_on_editor_id ON question_revisions USING btree (editor_id);


--
-- Name: index_question_revisions_on_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_question_revisions_on_question_id ON question_revisions USING btree (question_id);


--
-- Name: index_questions_on_anonymous; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_anonymous ON questions USING btree (anonymous);


--
-- Name: index_questions_on_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_author_id ON questions USING btree (author_id);


--
-- Name: index_questions_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_category_id ON questions USING btree (category_id);


--
-- Name: index_questions_on_deleted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_deleted ON questions USING btree (deleted);


--
-- Name: index_questions_on_deletor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_deletor_id ON questions USING btree (deletor_id);


--
-- Name: index_questions_on_edited; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_edited ON questions USING btree (edited);


--
-- Name: index_questions_on_slido_question_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_questions_on_slido_question_uuid ON questions USING btree (slido_question_uuid);


--
-- Name: index_questions_on_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_title ON questions USING btree (title);


--
-- Name: index_questions_on_touched_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_touched_at ON questions USING btree (touched_at);


--
-- Name: index_questions_on_votes_difference; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_votes_difference ON questions USING btree (votes_difference);


--
-- Name: index_questions_on_votes_lb_wsci_bp; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_votes_lb_wsci_bp ON questions USING btree (votes_lb_wsci_bp);


--
-- Name: index_roles_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_roles_on_name ON roles USING btree (name);


--
-- Name: index_slido_events_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_slido_events_on_category_id ON slido_events USING btree (category_id);


--
-- Name: index_slido_events_on_ended_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_slido_events_on_ended_at ON slido_events USING btree (ended_at);


--
-- Name: index_slido_events_on_started_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_slido_events_on_started_at ON slido_events USING btree (started_at);


--
-- Name: index_slido_events_on_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_slido_events_on_uuid ON slido_events USING btree (uuid);


--
-- Name: index_taggings_on_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_author_id ON taggings USING btree (author_id);


--
-- Name: index_taggings_on_deleted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_deleted ON taggings USING btree (deleted);


--
-- Name: index_taggings_on_deletor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_deletor_id ON taggings USING btree (deletor_id);


--
-- Name: index_taggings_on_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_question_id ON taggings USING btree (question_id);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_tag_id ON taggings USING btree (tag_id);


--
-- Name: index_taggings_on_unique_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_taggings_on_unique_key ON taggings USING btree (question_id, tag_id, author_id);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);


--
-- Name: index_users_on_ais_login; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_ais_login ON users USING btree (ais_login);


--
-- Name: index_users_on_ais_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_ais_uid ON users USING btree (ais_uid);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_first; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_first ON users USING btree (first);


--
-- Name: index_users_on_last; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_last ON users USING btree (last);


--
-- Name: index_users_on_login; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_login ON users USING btree (login);


--
-- Name: index_users_on_middle; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_middle ON users USING btree (middle);


--
-- Name: index_users_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_name ON users USING btree (name);


--
-- Name: index_users_on_nick; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_nick ON users USING btree (nick);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON users USING btree (unlock_token);


--
-- Name: index_views_on_deleted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_views_on_deleted ON views USING btree (deleted);


--
-- Name: index_views_on_deletor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_views_on_deletor_id ON views USING btree (deletor_id);


--
-- Name: index_views_on_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_views_on_question_id ON views USING btree (question_id);


--
-- Name: index_views_on_viewer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_views_on_viewer_id ON views USING btree (viewer_id);


--
-- Name: index_votes_on_deleted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_deleted ON votes USING btree (deleted);


--
-- Name: index_votes_on_deletor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_deletor_id ON votes USING btree (deletor_id);


--
-- Name: index_votes_on_positive; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_positive ON votes USING btree (positive);


--
-- Name: index_votes_on_unique_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_votes_on_unique_key ON votes USING btree (voter_id, votable_id, votable_type);


--
-- Name: index_votes_on_votable_id_and_votable_type_and_positive; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_votable_id_and_votable_type_and_positive ON votes USING btree (votable_id, votable_type, positive);


--
-- Name: index_votes_on_voter_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_voter_id ON votes USING btree (voter_id);


--
-- Name: index_watchings_on_deleted; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_watchings_on_deleted ON watchings USING btree (deleted);


--
-- Name: index_watchings_on_deletor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_watchings_on_deletor_id ON watchings USING btree (deletor_id);


--
-- Name: index_watchings_on_unique_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_watchings_on_unique_key ON watchings USING btree (watcher_id, watchable_id, watchable_type);


--
-- Name: index_watchings_on_watchable_id_and_watchable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_watchings_on_watchable_id_and_watchable_type ON watchings USING btree (watchable_id, watchable_type);


--
-- Name: index_watchings_on_watcher_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_watchings_on_watcher_id ON watchings USING btree (watcher_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

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

INSERT INTO schema_migrations (version) VALUES ('20140422093803');

INSERT INTO schema_migrations (version) VALUES ('20140423082147');

INSERT INTO schema_migrations (version) VALUES ('20140423123809');

INSERT INTO schema_migrations (version) VALUES ('20140424163620');

INSERT INTO schema_migrations (version) VALUES ('20140429003614');

INSERT INTO schema_migrations (version) VALUES ('20140513162801');

