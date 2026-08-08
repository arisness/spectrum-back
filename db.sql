--
-- PostgreSQL database dump
--

\restrict tD7h7AsgOG8KZ8BtPBagu5fnMtl2HPWkHpUwJ0CtbMfl4PYiNl6zysdYSyTLpZy

-- Dumped from database version 18.4 (Ubuntu 18.4-0ubuntu0.26.04.1)
-- Dumped by pg_dump version 18.4 (Ubuntu 18.4-0ubuntu0.26.04.1)

-- Started on 2026-08-07 17:40:33 -04

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 17786)
-- Name: chat; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA chat;


ALTER SCHEMA chat OWNER TO postgres;

--
-- TOC entry 6 (class 2615 OID 17626)
-- Name: security; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA security;


ALTER SCHEMA security OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 237 (class 1259 OID 17809)
-- Name: chat; Type: TABLE; Schema: chat; Owner: postgres
--

CREATE TABLE chat.chat (
    chat_timestamp timestamp(6) without time zone NOT NULL,
    chat_message text NOT NULL,
    chat_is_image boolean NOT NULL,
    fk_users_sender character varying NOT NULL,
    fk_users_receiver character varying NOT NULL
);


ALTER TABLE chat.chat OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 17788)
-- Name: interaction; Type: TABLE; Schema: chat; Owner: postgres
--

CREATE TABLE chat.interaction (
    fk_users_one character varying CONSTRAINT friend_fk_users_one_not_null NOT NULL,
    fk_users_two character varying CONSTRAINT friend_fk_users_two_not_null NOT NULL,
    interaction_id bigint CONSTRAINT friend_friend_id_not_null NOT NULL,
    interaction_type integer CONSTRAINT friend_interaction_type_not_null NOT NULL
);


ALTER TABLE chat.interaction OWNER TO postgres;

--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN interaction.interaction_type; Type: COMMENT; Schema: chat; Owner: postgres
--

COMMENT ON COLUMN chat.interaction.interaction_type IS 'integer
0 disliked
1 liked
more options can be acepted';


--
-- TOC entry 235 (class 1259 OID 17787)
-- Name: friend_friend_id_seq; Type: SEQUENCE; Schema: chat; Owner: postgres
--

CREATE SEQUENCE chat.friend_friend_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE chat.friend_friend_id_seq OWNER TO postgres;

--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 235
-- Name: friend_friend_id_seq; Type: SEQUENCE OWNED BY; Schema: chat; Owner: postgres
--

ALTER SEQUENCE chat.friend_friend_id_seq OWNED BY chat.interaction.interaction_id;


--
-- TOC entry 238 (class 1259 OID 17827)
-- Name: friend_interaction_type_seq; Type: SEQUENCE; Schema: chat; Owner: postgres
--

CREATE SEQUENCE chat.friend_interaction_type_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE chat.friend_interaction_type_seq OWNER TO postgres;

--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 238
-- Name: friend_interaction_type_seq; Type: SEQUENCE OWNED BY; Schema: chat; Owner: postgres
--

ALTER SEQUENCE chat.friend_interaction_type_seq OWNED BY chat.interaction.interaction_type;


--
-- TOC entry 221 (class 1259 OID 17627)
-- Name: component; Type: TABLE; Schema: security; Owner: postgres
--

CREATE TABLE security.component (
    component_id integer NOT NULL,
    component_name character varying NOT NULL
);


ALTER TABLE security.component OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17634)
-- Name: component_component_id_seq; Type: SEQUENCE; Schema: security; Owner: postgres
--

CREATE SEQUENCE security.component_component_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE security.component_component_id_seq OWNER TO postgres;

--
-- TOC entry 3627 (class 0 OID 0)
-- Dependencies: 222
-- Name: component_component_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: postgres
--

ALTER SEQUENCE security.component_component_id_seq OWNED BY security.component.component_id;


--
-- TOC entry 223 (class 1259 OID 17635)
-- Name: method; Type: TABLE; Schema: security; Owner: postgres
--

CREATE TABLE security.method (
    method_id integer NOT NULL,
    method_name character varying NOT NULL,
    fk_object_id integer NOT NULL
);


ALTER TABLE security.method OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17643)
-- Name: method_method_id_seq; Type: SEQUENCE; Schema: security; Owner: postgres
--

CREATE SEQUENCE security.method_method_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE security.method_method_id_seq OWNER TO postgres;

--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 224
-- Name: method_method_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: postgres
--

ALTER SEQUENCE security.method_method_id_seq OWNED BY security.method.method_id;


--
-- TOC entry 225 (class 1259 OID 17644)
-- Name: method_permission; Type: TABLE; Schema: security; Owner: postgres
--

CREATE TABLE security.method_permission (
    fk_profile_id integer NOT NULL,
    fk_transaction_id integer NOT NULL
);


ALTER TABLE security.method_permission OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17649)
-- Name: object; Type: TABLE; Schema: security; Owner: postgres
--

CREATE TABLE security.object (
    object_id integer NOT NULL,
    object_name character varying NOT NULL
);


ALTER TABLE security.object OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17656)
-- Name: object_object_id_seq; Type: SEQUENCE; Schema: security; Owner: postgres
--

CREATE SEQUENCE security.object_object_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE security.object_object_id_seq OWNER TO postgres;

--
-- TOC entry 3629 (class 0 OID 0)
-- Dependencies: 227
-- Name: object_object_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: postgres
--

ALTER SEQUENCE security.object_object_id_seq OWNED BY security.object.object_id;


--
-- TOC entry 228 (class 1259 OID 17657)
-- Name: option; Type: TABLE; Schema: security; Owner: postgres
--

CREATE TABLE security.option (
    option_id integer NOT NULL,
    option_name character varying NOT NULL,
    fk_component_id integer NOT NULL,
    option_function character varying NOT NULL,
    option_params character varying[] NOT NULL,
    option_async boolean NOT NULL,
    option_generic boolean NOT NULL
);


ALTER TABLE security.option OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17669)
-- Name: option_option_id_seq; Type: SEQUENCE; Schema: security; Owner: postgres
--

CREATE SEQUENCE security.option_option_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE security.option_option_id_seq OWNER TO postgres;

--
-- TOC entry 3630 (class 0 OID 0)
-- Dependencies: 229
-- Name: option_option_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: postgres
--

ALTER SEQUENCE security.option_option_id_seq OWNED BY security.option.option_id;


--
-- TOC entry 230 (class 1259 OID 17670)
-- Name: option_permission; Type: TABLE; Schema: security; Owner: postgres
--

CREATE TABLE security.option_permission (
    fk_profile_id integer NOT NULL,
    fk_option_id integer NOT NULL
);


ALTER TABLE security.option_permission OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17675)
-- Name: profile; Type: TABLE; Schema: security; Owner: postgres
--

CREATE TABLE security.profile (
    profile_name character varying(40) NOT NULL,
    profile_id integer NOT NULL
);


ALTER TABLE security.profile OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17680)
-- Name: profiles_0_profile_id_seq; Type: SEQUENCE; Schema: security; Owner: postgres
--

CREATE SEQUENCE security.profiles_0_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE security.profiles_0_profile_id_seq OWNER TO postgres;

--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 232
-- Name: profiles_0_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: postgres
--

ALTER SEQUENCE security.profiles_0_profile_id_seq OWNED BY security.profile.profile_id;


--
-- TOC entry 233 (class 1259 OID 17681)
-- Name: transaction; Type: TABLE; Schema: security; Owner: postgres
--

CREATE TABLE security.transaction (
    fk_method_id integer NOT NULL,
    transaction_id integer NOT NULL
);


ALTER TABLE security.transaction OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 17686)
-- Name: users; Type: TABLE; Schema: security; Owner: postgres
--

CREATE TABLE security.users (
    users_name character varying(50) NOT NULL,
    users_password character varying(30) NOT NULL,
    fk_profile_id integer DEFAULT 0 NOT NULL,
    users_email character varying NOT NULL,
    users_first_name text NOT NULL,
    users_last_name text NOT NULL,
    users_image text,
    users_description text,
    users_birthday date NOT NULL
);


ALTER TABLE security.users OWNER TO postgres;

--
-- TOC entry 3416 (class 2604 OID 17791)
-- Name: interaction interaction_id; Type: DEFAULT; Schema: chat; Owner: postgres
--

ALTER TABLE ONLY chat.interaction ALTER COLUMN interaction_id SET DEFAULT nextval('chat.friend_friend_id_seq'::regclass);


--
-- TOC entry 3417 (class 2604 OID 17837)
-- Name: interaction interaction_type; Type: DEFAULT; Schema: chat; Owner: postgres
--

ALTER TABLE ONLY chat.interaction ALTER COLUMN interaction_type SET DEFAULT nextval('chat.friend_interaction_type_seq'::regclass);


--
-- TOC entry 3410 (class 2604 OID 17695)
-- Name: component component_id; Type: DEFAULT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.component ALTER COLUMN component_id SET DEFAULT nextval('security.component_component_id_seq'::regclass);


--
-- TOC entry 3411 (class 2604 OID 17696)
-- Name: method method_id; Type: DEFAULT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.method ALTER COLUMN method_id SET DEFAULT nextval('security.method_method_id_seq'::regclass);


--
-- TOC entry 3412 (class 2604 OID 17697)
-- Name: object object_id; Type: DEFAULT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.object ALTER COLUMN object_id SET DEFAULT nextval('security.object_object_id_seq'::regclass);


--
-- TOC entry 3413 (class 2604 OID 17698)
-- Name: option option_id; Type: DEFAULT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.option ALTER COLUMN option_id SET DEFAULT nextval('security.option_option_id_seq'::regclass);


--
-- TOC entry 3414 (class 2604 OID 17699)
-- Name: profile profile_id; Type: DEFAULT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.profile ALTER COLUMN profile_id SET DEFAULT nextval('security.profiles_0_profile_id_seq'::regclass);


--
-- TOC entry 3617 (class 0 OID 17809)
-- Dependencies: 237
-- Data for Name: chat; Type: TABLE DATA; Schema: chat; Owner: postgres
--

COPY chat.chat (chat_timestamp, chat_message, chat_is_image, fk_users_sender, fk_users_receiver) FROM stdin;
\.


--
-- TOC entry 3616 (class 0 OID 17788)
-- Dependencies: 236
-- Data for Name: interaction; Type: TABLE DATA; Schema: chat; Owner: postgres
--

COPY chat.interaction (fk_users_one, fk_users_two, interaction_id, interaction_type) FROM stdin;
\.


--
-- TOC entry 3601 (class 0 OID 17627)
-- Dependencies: 221
-- Data for Name: component; Type: TABLE DATA; Schema: security; Owner: postgres
--

COPY security.component (component_id, component_name) FROM stdin;
\.


--
-- TOC entry 3603 (class 0 OID 17635)
-- Dependencies: 223
-- Data for Name: method; Type: TABLE DATA; Schema: security; Owner: postgres
--

COPY security.method (method_id, method_name, fk_object_id) FROM stdin;
1	getLiked	1
2	getDisliked	1
3	addInteraction	1
4	updateInteraction	1
5	getMessages	2
\.


--
-- TOC entry 3605 (class 0 OID 17644)
-- Dependencies: 225
-- Data for Name: method_permission; Type: TABLE DATA; Schema: security; Owner: postgres
--

COPY security.method_permission (fk_profile_id, fk_transaction_id) FROM stdin;
0	11
0	12
0	13
0	14
0	21
\.


--
-- TOC entry 3606 (class 0 OID 17649)
-- Dependencies: 226
-- Data for Name: object; Type: TABLE DATA; Schema: security; Owner: postgres
--

COPY security.object (object_id, object_name) FROM stdin;
1	InteractionHandler
2	ChatHandler
\.


--
-- TOC entry 3608 (class 0 OID 17657)
-- Dependencies: 228
-- Data for Name: option; Type: TABLE DATA; Schema: security; Owner: postgres
--

COPY security.option (option_id, option_name, fk_component_id, option_function, option_params, option_async, option_generic) FROM stdin;
\.


--
-- TOC entry 3610 (class 0 OID 17670)
-- Dependencies: 230
-- Data for Name: option_permission; Type: TABLE DATA; Schema: security; Owner: postgres
--

COPY security.option_permission (fk_profile_id, fk_option_id) FROM stdin;
\.


--
-- TOC entry 3611 (class 0 OID 17675)
-- Dependencies: 231
-- Data for Name: profile; Type: TABLE DATA; Schema: security; Owner: postgres
--

COPY security.profile (profile_name, profile_id) FROM stdin;
Slave	0
\.


--
-- TOC entry 3613 (class 0 OID 17681)
-- Dependencies: 233
-- Data for Name: transaction; Type: TABLE DATA; Schema: security; Owner: postgres
--

COPY security.transaction (fk_method_id, transaction_id) FROM stdin;
1	11
2	12
3	13
4	14
5	21
\.


--
-- TOC entry 3614 (class 0 OID 17686)
-- Dependencies: 234
-- Data for Name: users; Type: TABLE DATA; Schema: security; Owner: postgres
--

COPY security.users (users_name, users_password, fk_profile_id, users_email, users_first_name, users_last_name, users_image, users_description, users_birthday) FROM stdin;
\.


--
-- TOC entry 3632 (class 0 OID 0)
-- Dependencies: 235
-- Name: friend_friend_id_seq; Type: SEQUENCE SET; Schema: chat; Owner: postgres
--

SELECT pg_catalog.setval('chat.friend_friend_id_seq', 1, false);


--
-- TOC entry 3633 (class 0 OID 0)
-- Dependencies: 238
-- Name: friend_interaction_type_seq; Type: SEQUENCE SET; Schema: chat; Owner: postgres
--

SELECT pg_catalog.setval('chat.friend_interaction_type_seq', 1, false);


--
-- TOC entry 3634 (class 0 OID 0)
-- Dependencies: 222
-- Name: component_component_id_seq; Type: SEQUENCE SET; Schema: security; Owner: postgres
--

SELECT pg_catalog.setval('security.component_component_id_seq', 1, false);


--
-- TOC entry 3635 (class 0 OID 0)
-- Dependencies: 224
-- Name: method_method_id_seq; Type: SEQUENCE SET; Schema: security; Owner: postgres
--

SELECT pg_catalog.setval('security.method_method_id_seq', 5, true);


--
-- TOC entry 3636 (class 0 OID 0)
-- Dependencies: 227
-- Name: object_object_id_seq; Type: SEQUENCE SET; Schema: security; Owner: postgres
--

SELECT pg_catalog.setval('security.object_object_id_seq', 2, true);


--
-- TOC entry 3637 (class 0 OID 0)
-- Dependencies: 229
-- Name: option_option_id_seq; Type: SEQUENCE SET; Schema: security; Owner: postgres
--

SELECT pg_catalog.setval('security.option_option_id_seq', 1, false);


--
-- TOC entry 3638 (class 0 OID 0)
-- Dependencies: 232
-- Name: profiles_0_profile_id_seq; Type: SEQUENCE SET; Schema: security; Owner: postgres
--

SELECT pg_catalog.setval('security.profiles_0_profile_id_seq', 1, false);


--
-- TOC entry 3441 (class 2606 OID 17888)
-- Name: chat pk_chat; Type: CONSTRAINT; Schema: chat; Owner: postgres
--

ALTER TABLE ONLY chat.chat
    ADD CONSTRAINT pk_chat PRIMARY KEY (chat_timestamp, fk_users_sender, fk_users_receiver);


--
-- TOC entry 3437 (class 2606 OID 17798)
-- Name: interaction pk_friend; Type: CONSTRAINT; Schema: chat; Owner: postgres
--

ALTER TABLE ONLY chat.interaction
    ADD CONSTRAINT pk_friend PRIMARY KEY (interaction_id);


--
-- TOC entry 3439 (class 2606 OID 17826)
-- Name: interaction unq_friend; Type: CONSTRAINT; Schema: chat; Owner: postgres
--

ALTER TABLE ONLY chat.interaction
    ADD CONSTRAINT unq_friend UNIQUE (fk_users_one, fk_users_two);


--
-- TOC entry 3419 (class 2606 OID 17701)
-- Name: component component_pkey; Type: CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.component
    ADD CONSTRAINT component_pkey PRIMARY KEY (component_id);


--
-- TOC entry 3423 (class 2606 OID 17703)
-- Name: method_permission method_permission_pkey; Type: CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.method_permission
    ADD CONSTRAINT method_permission_pkey PRIMARY KEY (fk_profile_id, fk_transaction_id);


--
-- TOC entry 3421 (class 2606 OID 17705)
-- Name: method method_pkey; Type: CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.method
    ADD CONSTRAINT method_pkey PRIMARY KEY (method_id);


--
-- TOC entry 3425 (class 2606 OID 17707)
-- Name: object object_pkey; Type: CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.object
    ADD CONSTRAINT object_pkey PRIMARY KEY (object_id);


--
-- TOC entry 3429 (class 2606 OID 17709)
-- Name: option_permission option_permission_pkey; Type: CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.option_permission
    ADD CONSTRAINT option_permission_pkey PRIMARY KEY (fk_profile_id, fk_option_id);


--
-- TOC entry 3427 (class 2606 OID 17711)
-- Name: option option_pkey; Type: CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.option
    ADD CONSTRAINT option_pkey PRIMARY KEY (option_id);


--
-- TOC entry 3431 (class 2606 OID 17713)
-- Name: profile pk_profiles_0; Type: CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.profile
    ADD CONSTRAINT pk_profiles_0 PRIMARY KEY (profile_id);


--
-- TOC entry 3433 (class 2606 OID 17715)
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (transaction_id);


--
-- TOC entry 3435 (class 2606 OID 17717)
-- Name: users username_pkey; Type: CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT username_pkey PRIMARY KEY (users_name);


--
-- TOC entry 3450 (class 2606 OID 17799)
-- Name: interaction fk_users_one; Type: FK CONSTRAINT; Schema: chat; Owner: postgres
--

ALTER TABLE ONLY chat.interaction
    ADD CONSTRAINT fk_users_one FOREIGN KEY (fk_users_one) REFERENCES security.users(users_name);


--
-- TOC entry 3452 (class 2606 OID 17894)
-- Name: chat fk_users_receiver; Type: FK CONSTRAINT; Schema: chat; Owner: postgres
--

ALTER TABLE ONLY chat.chat
    ADD CONSTRAINT fk_users_receiver FOREIGN KEY (fk_users_receiver) REFERENCES security.users(users_name);


--
-- TOC entry 3453 (class 2606 OID 17889)
-- Name: chat fk_users_sender; Type: FK CONSTRAINT; Schema: chat; Owner: postgres
--

ALTER TABLE ONLY chat.chat
    ADD CONSTRAINT fk_users_sender FOREIGN KEY (fk_users_sender) REFERENCES security.users(users_name);


--
-- TOC entry 3451 (class 2606 OID 17804)
-- Name: interaction fk_users_two; Type: FK CONSTRAINT; Schema: chat; Owner: postgres
--

ALTER TABLE ONLY chat.interaction
    ADD CONSTRAINT fk_users_two FOREIGN KEY (fk_users_two) REFERENCES security.users(users_name);


--
-- TOC entry 3445 (class 2606 OID 17718)
-- Name: option fk_component; Type: FK CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.option
    ADD CONSTRAINT fk_component FOREIGN KEY (fk_component_id) REFERENCES security.component(component_id);


--
-- TOC entry 3442 (class 2606 OID 17723)
-- Name: method fk_method; Type: FK CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.method
    ADD CONSTRAINT fk_method FOREIGN KEY (fk_object_id) REFERENCES security.object(object_id);


--
-- TOC entry 3448 (class 2606 OID 17728)
-- Name: transaction fk_method; Type: FK CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.transaction
    ADD CONSTRAINT fk_method FOREIGN KEY (fk_method_id) REFERENCES security.method(method_id);


--
-- TOC entry 3446 (class 2606 OID 17733)
-- Name: option_permission fk_option; Type: FK CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.option_permission
    ADD CONSTRAINT fk_option FOREIGN KEY (fk_option_id) REFERENCES security.option(option_id);


--
-- TOC entry 3443 (class 2606 OID 17738)
-- Name: method_permission fk_profile; Type: FK CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.method_permission
    ADD CONSTRAINT fk_profile FOREIGN KEY (fk_profile_id) REFERENCES security.profile(profile_id);


--
-- TOC entry 3447 (class 2606 OID 17743)
-- Name: option_permission fk_profile; Type: FK CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.option_permission
    ADD CONSTRAINT fk_profile FOREIGN KEY (fk_profile_id) REFERENCES security.profile(profile_id);


--
-- TOC entry 3449 (class 2606 OID 17748)
-- Name: users fk_profile; Type: FK CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.users
    ADD CONSTRAINT fk_profile FOREIGN KEY (fk_profile_id) REFERENCES security.profile(profile_id);


--
-- TOC entry 3444 (class 2606 OID 17753)
-- Name: method_permission fk_transaction; Type: FK CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.method_permission
    ADD CONSTRAINT fk_transaction FOREIGN KEY (fk_transaction_id) REFERENCES security.transaction(transaction_id);


-- Completed on 2026-08-07 17:40:33 -04

--
-- PostgreSQL database dump complete
--

\unrestrict tD7h7AsgOG8KZ8BtPBagu5fnMtl2HPWkHpUwJ0CtbMfl4PYiNl6zysdYSyTLpZy

