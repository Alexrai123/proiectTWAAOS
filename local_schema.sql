--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-06-09 01:02:57

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
-- SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 24577)
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24583)
-- Name: disciplines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disciplines (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    program character varying(50),
    year integer,
    group_name character varying(20)
);


ALTER TABLE public.disciplines OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24582)
-- Name: disciplines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.disciplines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.disciplines_id_seq OWNER TO postgres;

--
-- TOC entry 4842 (class 0 OID 0)
-- Dependencies: 218
-- Name: disciplines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.disciplines_id_seq OWNED BY public.disciplines.id;


--
-- TOC entry 225 (class 1259 OID 24610)
-- Name: exams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exams (
    id integer NOT NULL,
    discipline_id integer,
    proposed_by integer,
    proposed_date timestamp without time zone,
    confirmed_date timestamp without time zone,
    room_id integer,
    teacher_id integer,
    assistant_ids integer[],
    status character varying(20),
    group_name character varying(20) NOT NULL
);


ALTER TABLE public.exams OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24609)
-- Name: exams_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exams_id_seq OWNER TO postgres;

--
-- TOC entry 4843 (class 0 OID 0)
-- Dependencies: 224
-- Name: exams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exams_id_seq OWNED BY public.exams.id;


--
-- TOC entry 221 (class 1259 OID 24591)
-- Name: rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rooms (
    id integer NOT NULL,
    name character varying(50),
    building character varying(50),
    capacity integer
);


ALTER TABLE public.rooms OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24590)
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rooms_id_seq OWNER TO postgres;

--
-- TOC entry 4844 (class 0 OID 0)
-- Dependencies: 220
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- TOC entry 223 (class 1259 OID 24599)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    role character varying(10) NOT NULL,
    password_hash text,
    is_active boolean,
    group_name character varying(20)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24598)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 4845 (class 0 OID 0)
-- Dependencies: 222
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4660 (class 2604 OID 24586)
-- Name: disciplines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disciplines ALTER COLUMN id SET DEFAULT nextval('public.disciplines_id_seq'::regclass);


--
-- TOC entry 4663 (class 2604 OID 24613)
-- Name: exams id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams ALTER COLUMN id SET DEFAULT nextval('public.exams_id_seq'::regclass);


--
-- TOC entry 4661 (class 2604 OID 24594)
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- TOC entry 4662 (class 2604 OID 24602)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4828 (class 0 OID 24577)
-- Dependencies: 217
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
20250608_0241
\.


--
-- TOC entry 4830 (class 0 OID 24583)
-- Dependencies: 219
-- Data for Name: disciplines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.disciplines (id, name, program, year, group_name) FROM stdin;
0	Algebra liniara, geometrie analitica si diferentiala	Calculatoare	1	3111
1	Analiza matematica	Calculatoare	1	3111
2	Proiectare logica	Calculatoare	1	3111
3	Grafica asistata de calculator	Calculatoare	1	3111
4	Programarea calculatoarelor si limbaje de programare 1	Calculatoare	1	3111
5	Comunicare	Calculatoare	1	3111
6	Limba engleza 1	Calculatoare	1	3111
7	Educatie fizica si sport 1	Calculatoare	1	3111
8	Matematici speciale	Calculatoare	1	3111
9	Fizica 1	Calculatoare	1	3111
10	Programarea calculatoarelor si limbaje de programare 2	Calculatoare	1	3111
11	Arhitectura sistemelor de calcul	Calculatoare	1	3111
12	Electrotehnica	Calculatoare	1	3111
13	Limba engleza 2	Calculatoare	1	3111
14	Algebra liniara, geometrie analitica si diferentiala	Calculatoare	1	3112
15	Analiza matematica	Calculatoare	1	3112
16	Proiectare logica	Calculatoare	1	3112
17	Grafica asistata de calculator	Calculatoare	1	3112
18	Programarea calculatoarelor si limbaje de programare 1	Calculatoare	1	3112
19	Comunicare	Calculatoare	1	3112
20	Limba engleza 1	Calculatoare	1	3112
21	Educatie fizica si sport 1	Calculatoare	1	3112
22	Matematici speciale	Calculatoare	1	3112
23	Fizica 1	Calculatoare	1	3112
24	Programarea calculatoarelor si limbaje de programare 2	Calculatoare	1	3112
25	Arhitectura sistemelor de calcul	Calculatoare	1	3112
26	Electrotehnica	Calculatoare	1	3112
27	Limba engleza 2	Calculatoare	1	3112
28	Algebra liniara, geometrie analitica si diferentiala	Calculatoare	1	3113
29	Analiza matematica	Calculatoare	1	3113
30	Proiectare logica	Calculatoare	1	3113
31	Grafica asistata de calculator	Calculatoare	1	3113
32	Programarea calculatoarelor si limbaje de programare 1	Calculatoare	1	3113
33	Comunicare	Calculatoare	1	3113
34	Limba engleza 1	Calculatoare	1	3113
35	Educatie fizica si sport 1	Calculatoare	1	3113
36	Matematici speciale	Calculatoare	1	3113
37	Fizica 1	Calculatoare	1	3113
38	Programarea calculatoarelor si limbaje de programare 2	Calculatoare	1	3113
39	Arhitectura sistemelor de calcul	Calculatoare	1	3113
40	Electrotehnica	Calculatoare	1	3113
41	Limba engleza 2	Calculatoare	1	3113
42	Algebra liniara, geometrie analitica si diferentiala	Calculatoare	1	3114
43	Analiza matematica	Calculatoare	1	3114
44	Proiectare logica	Calculatoare	1	3114
45	Grafica asistata de calculator	Calculatoare	1	3114
46	Programarea calculatoarelor si limbaje de programare 1	Calculatoare	1	3114
47	Comunicare	Calculatoare	1	3114
48	Limba engleza 1	Calculatoare	1	3114
49	Educatie fizica si sport 1	Calculatoare	1	3114
50	Matematici speciale	Calculatoare	1	3114
51	Fizica 1	Calculatoare	1	3114
52	Programarea calculatoarelor si limbaje de programare 2	Calculatoare	1	3114
53	Arhitectura sistemelor de calcul	Calculatoare	1	3114
54	Electrotehnica	Calculatoare	1	3114
55	Limba engleza 2	Calculatoare	1	3114
56	Dispozitive electronice si electronica analogica 1	Calculatoare	2	3121
57	Programare orientata pe obiecte	Calculatoare	2	3121
58	Fizica 2	Calculatoare	2	3121
59	Teoria sistemelor	Calculatoare	2	3121
60	Retele de calculatoare	Calculatoare	2	3121
61	Structura si organizarea calculatoarelor	Calculatoare	2	3121
62	Educatie fizica si sport III	Calculatoare	2	3121
63	Programarea interfetelor utilizator	Calculatoare	2	3121
64	Metode numerice	Calculatoare	2	3121
65	Programarea calculatoarelor si limbaje de programare 3	Calculatoare	2	3121
66	Masurari electronice, senzori si traductoare	Calculatoare	2	3121
67	Dispozitive electronice si electronica analogica 2	Calculatoare	2	3121
68	Proiectarea aplicatiilor orientate pe obiecte (proiect)	Calculatoare	2	3121
69	Electronica digitala	Calculatoare	2	3121
70	Practica in domeniu (90 ore)	Calculatoare	2	3121
71	Dispozitive electronice si electronica analogica 1	Calculatoare	2	3122
72	Programare orientata pe obiecte	Calculatoare	2	3122
73	Fizica 2	Calculatoare	2	3122
74	Teoria sistemelor	Calculatoare	2	3122
75	Retele de calculatoare	Calculatoare	2	3122
76	Structura si organizarea calculatoarelor	Calculatoare	2	3122
77	Educatie fizica si sport III	Calculatoare	2	3122
78	Programarea interfetelor utilizator	Calculatoare	2	3122
79	Metode numerice	Calculatoare	2	3122
80	Programarea calculatoarelor si limbaje de programare 3	Calculatoare	2	3122
81	Masurari electronice, senzori si traductoare	Calculatoare	2	3122
82	Dispozitive electronice si electronica analogica 2	Calculatoare	2	3122
83	Proiectarea aplicatiilor orientate pe obiecte (proiect)	Calculatoare	2	3122
84	Electronica digitala	Calculatoare	2	3122
85	Practica in domeniu (90 ore)	Calculatoare	2	3122
86	Dispozitive electronice si electronica analogica 1	Calculatoare	2	3123
87	Programare orientata pe obiecte	Calculatoare	2	3123
88	Fizica 2	Calculatoare	2	3123
89	Teoria sistemelor	Calculatoare	2	3123
90	Retele de calculatoare	Calculatoare	2	3123
91	Structura si organizarea calculatoarelor	Calculatoare	2	3123
92	Educatie fizica si sport III	Calculatoare	2	3123
93	Programarea interfetelor utilizator	Calculatoare	2	3123
94	Metode numerice	Calculatoare	2	3123
95	Programarea calculatoarelor si limbaje de programare 3	Calculatoare	2	3123
96	Masurari electronice, senzori si traductoare	Calculatoare	2	3123
97	Dispozitive electronice si electronica analogica 2	Calculatoare	2	3123
98	Proiectarea aplicatiilor orientate pe obiecte (proiect)	Calculatoare	2	3123
99	Electronica digitala	Calculatoare	2	3123
100	Practica in domeniu (90 ore)	Calculatoare	2	3123
101	Dispozitive electronice si electronica analogica 1	Calculatoare	2	3124
102	Programare orientata pe obiecte	Calculatoare	2	3124
103	Fizica 2	Calculatoare	2	3124
104	Teoria sistemelor	Calculatoare	2	3124
105	Retele de calculatoare	Calculatoare	2	3124
106	Structura si organizarea calculatoarelor	Calculatoare	2	3124
107	Educatie fizica si sport III	Calculatoare	2	3124
108	Programarea interfetelor utilizator	Calculatoare	2	3124
109	Metode numerice	Calculatoare	2	3124
110	Programarea calculatoarelor si limbaje de programare 3	Calculatoare	2	3124
111	Masurari electronice, senzori si traductoare	Calculatoare	2	3124
112	Dispozitive electronice si electronica analogica 2	Calculatoare	2	3124
113	Proiectarea aplicatiilor orientate pe obiecte (proiect)	Calculatoare	2	3124
114	Electronica digitala	Calculatoare	2	3124
115	Practica in domeniu (90 ore)	Calculatoare	2	3124
116	Structuri de date si algoritmi	Calculatoare	3	3131
117	Elemente de grafica pe calculator	Calculatoare	3	3131
118	Microcontrolere	Calculatoare	3	3131
119	Protocoale de comunicatii	Calculatoare	3	3131
120	Sisteme de operare	Calculatoare	3	3131
121	Elemente de grafica pe calculator - proiect	Calculatoare	3	3131
122	Microcontrolere - proiect	Calculatoare	3	3131
123	Proiectarea aplicatiilor WEB	Calculatoare	3	3131
124	Proiectarea algoritmilor	Calculatoare	3	3131
125	Baze de date	Calculatoare	3	3131
126	Baze de date - proiect	Calculatoare	3	3131
127	Inteligenta artificiala	Calculatoare	3	3131
128	Limba engleza IV	Calculatoare	3	3131
129	Practica de specialitate - 90 ore	Calculatoare	3	3131
130	Prelucrarea numerica a imaginilor	Calculatoare	3	3131
131	Procesoare numerice de semnal	Calculatoare	3	3131
132	Structuri de date si algoritmi	Calculatoare	3	3132
133	Elemente de grafica pe calculator	Calculatoare	3	3132
134	Microcontrolere	Calculatoare	3	3132
135	Protocoale de comunicatii	Calculatoare	3	3132
136	Sisteme de operare	Calculatoare	3	3132
137	Elemente de grafica pe calculator - proiect	Calculatoare	3	3132
138	Microcontrolere - proiect	Calculatoare	3	3132
139	Proiectarea aplicatiilor WEB	Calculatoare	3	3132
140	Proiectarea algoritmilor	Calculatoare	3	3132
141	Baze de date	Calculatoare	3	3132
142	Baze de date - proiect	Calculatoare	3	3132
143	Inteligenta artificiala	Calculatoare	3	3132
144	Limba engleza IV	Calculatoare	3	3132
145	Practica de specialitate - 90 ore	Calculatoare	3	3132
146	Prelucrarea numerica a imaginilor	Calculatoare	3	3132
147	Procesoare numerice de semnal	Calculatoare	3	3132
148	Structuri de date si algoritmi	Calculatoare	3	3133
149	Elemente de grafica pe calculator	Calculatoare	3	3133
150	Microcontrolere	Calculatoare	3	3133
151	Protocoale de comunicatii	Calculatoare	3	3133
152	Sisteme de operare	Calculatoare	3	3133
153	Elemente de grafica pe calculator - proiect	Calculatoare	3	3133
154	Microcontrolere - proiect	Calculatoare	3	3133
155	Proiectarea aplicatiilor WEB	Calculatoare	3	3133
156	Proiectarea algoritmilor	Calculatoare	3	3133
157	Baze de date	Calculatoare	3	3133
158	Baze de date - proiect	Calculatoare	3	3133
159	Inteligenta artificiala	Calculatoare	3	3133
160	Limba engleza IV	Calculatoare	3	3133
161	Practica de specialitate - 90 ore	Calculatoare	3	3133
162	Prelucrarea numerica a imaginilor	Calculatoare	3	3133
163	Procesoare numerice de semnal	Calculatoare	3	3133
164	Structuri de date si algoritmi	Calculatoare	3	3134
165	Elemente de grafica pe calculator	Calculatoare	3	3134
166	Microcontrolere	Calculatoare	3	3134
167	Protocoale de comunicatii	Calculatoare	3	3134
168	Sisteme de operare	Calculatoare	3	3134
169	Elemente de grafica pe calculator - proiect	Calculatoare	3	3134
170	Microcontrolere - proiect	Calculatoare	3	3134
171	Proiectarea aplicatiilor WEB	Calculatoare	3	3134
172	Proiectarea algoritmilor	Calculatoare	3	3134
173	Baze de date	Calculatoare	3	3134
174	Baze de date - proiect	Calculatoare	3	3134
175	Inteligenta artificiala	Calculatoare	3	3134
176	Limba engleza IV	Calculatoare	3	3134
177	Practica de specialitate - 90 ore	Calculatoare	3	3134
178	Prelucrarea numerica a imaginilor	Calculatoare	3	3134
179	Procesoare numerice de semnal	Calculatoare	3	3134
180	Sisteme inteligente	Calculatoare	4	3141
181	Sisteme de intrare-iesire si echipamente periferice	Calculatoare	4	3141
182	Ingineria programelor	Calculatoare	4	3141
183	Recunoasterea formelor	Calculatoare	4	3141
184	Circuite VLSI	Calculatoare	4	3141
185	Arhitecturi si prelucrari paralele	Calculatoare	4	3141
186	Practica pentru proiectul de diploma	Calculatoare	4	3141
187	Elaborarea proiectului de diploma	Calculatoare	4	3141
188	Proiectarea bazelor de date	Calculatoare	4	3141
189	Proiectarea asistata de calculator a modulelor electronice	Calculatoare	4	3141
190	Proiectarea translatoarelor	Calculatoare	4	3141
191	Sisteme de calcul in timp real	Calculatoare	4	3141
192	Calcul mobil	Calculatoare	4	3141
193	Sisteme cu microprocesoare	Calculatoare	4	3141
194	Aplicatii integrate pentru intreprinderi	Calculatoare	4	3141
195	Internetul obiectelor	Calculatoare	4	3141
196	Criptografie si securitate informationala	Calculatoare	4	3141
197	Domotica si cladiri inteligente	Calculatoare	4	3141
198	Sisteme inteligente	Calculatoare	4	3142
199	Sisteme de intrare-iesire si echipamente periferice	Calculatoare	4	3142
200	Ingineria programelor	Calculatoare	4	3142
201	Recunoasterea formelor	Calculatoare	4	3142
202	Circuite VLSI	Calculatoare	4	3142
203	Arhitecturi si prelucrari paralele	Calculatoare	4	3142
204	Practica pentru proiectul de diploma	Calculatoare	4	3142
205	Elaborarea proiectului de diploma	Calculatoare	4	3142
206	Proiectarea bazelor de date	Calculatoare	4	3142
207	Proiectarea asistata de calculator a modulelor electronice	Calculatoare	4	3142
208	Proiectarea translatoarelor	Calculatoare	4	3142
209	Sisteme de calcul in timp real	Calculatoare	4	3142
210	Calcul mobil	Calculatoare	4	3142
211	Sisteme cu microprocesoare	Calculatoare	4	3142
212	Aplicatii integrate pentru intreprinderi	Calculatoare	4	3142
213	Internetul obiectelor	Calculatoare	4	3142
214	Criptografie si securitate informationala	Calculatoare	4	3142
215	Domotica si cladiri inteligente	Calculatoare	4	3142
216	Sisteme inteligente	Calculatoare	4	3143
217	Sisteme de intrare-iesire si echipamente periferice	Calculatoare	4	3143
218	Ingineria programelor	Calculatoare	4	3143
219	Recunoasterea formelor	Calculatoare	4	3143
220	Circuite VLSI	Calculatoare	4	3143
221	Arhitecturi si prelucrari paralele	Calculatoare	4	3143
222	Practica pentru proiectul de diploma	Calculatoare	4	3143
223	Elaborarea proiectului de diploma	Calculatoare	4	3143
224	Proiectarea bazelor de date	Calculatoare	4	3143
225	Proiectarea asistata de calculator a modulelor electronice	Calculatoare	4	3143
226	Proiectarea translatoarelor	Calculatoare	4	3143
227	Sisteme de calcul in timp real	Calculatoare	4	3143
228	Calcul mobil	Calculatoare	4	3143
229	Sisteme cu microprocesoare	Calculatoare	4	3143
230	Aplicatii integrate pentru intreprinderi	Calculatoare	4	3143
231	Internetul obiectelor	Calculatoare	4	3143
232	Criptografie si securitate informationala	Calculatoare	4	3143
233	Domotica si cladiri inteligente	Calculatoare	4	3143
234	Analiza matematica	Automatica si informatica aplicata	1	3211
235	Algebra liniara, geometrie analitica si diferentiala	Automatica si informatica aplicata	1	3211
236	Analiza si sinteza dispozitivelor numerice	Automatica si informatica aplicata	1	3211
237	Programarea calculatoarelor si limbaje de programare I	Automatica si informatica aplicata	1	3211
238	Grafica asistata pe calculator	Automatica si informatica aplicata	1	3211
239	Tehnologie electronica	Automatica si informatica aplicata	1	3211
240	Educatie fizica si sport I	Automatica si informatica aplicata	1	3211
241	Matematici speciale	Automatica si informatica aplicata	1	3211
242	Fizica I	Automatica si informatica aplicata	1	3211
243	Programarea calculatoarelor si limbaje de programare II	Automatica si informatica aplicata	1	3211
244	Electrotehnica	Automatica si informatica aplicata	1	3211
245	Arhitectura calculatoarelor	Automatica si informatica aplicata	1	3211
246	Comunicare	Automatica si informatica aplicata	1	3211
247	Limba engleza I	Automatica si informatica aplicata	1	3211
248	Limba straina tehnica I - Engleza	Automatica si informatica aplicata	1	3211
249	Limba straina tehnica I - Franceza	Automatica si informatica aplicata	1	3211
250	Limba straina tehnica I - Germana	Automatica si informatica aplicata	1	3211
251	Complemente de matematica	Automatica si informatica aplicata	1	3211
252	Limba straina tehnica II - Engleza	Automatica si informatica aplicata	1	3211
253	Limba straina tehnica II - Franceza	Automatica si informatica aplicata	1	3211
254	Limba straina tehnica II - Germana	Automatica si informatica aplicata	1	3211
255	Teoria probabilitatilor si statistica matematica	Automatica si informatica aplicata	1	3211
256	Analiza matematica	Automatica si informatica aplicata	1	3212
257	Algebra liniara, geometrie analitica si diferentiala	Automatica si informatica aplicata	1	3212
258	Analiza si sinteza dispozitivelor numerice	Automatica si informatica aplicata	1	3212
259	Programarea calculatoarelor si limbaje de programare I	Automatica si informatica aplicata	1	3212
260	Grafica asistata pe calculator	Automatica si informatica aplicata	1	3212
261	Tehnologie electronica	Automatica si informatica aplicata	1	3212
262	Educatie fizica si sport I	Automatica si informatica aplicata	1	3212
263	Matematici speciale	Automatica si informatica aplicata	1	3212
264	Fizica I	Automatica si informatica aplicata	1	3212
265	Programarea calculatoarelor si limbaje de programare II	Automatica si informatica aplicata	1	3212
266	Electrotehnica	Automatica si informatica aplicata	1	3212
267	Arhitectura calculatoarelor	Automatica si informatica aplicata	1	3212
268	Comunicare	Automatica si informatica aplicata	1	3212
269	Limba engleza I	Automatica si informatica aplicata	1	3212
270	Limba straina tehnica I - Engleza	Automatica si informatica aplicata	1	3212
271	Limba straina tehnica I - Franceza	Automatica si informatica aplicata	1	3212
272	Limba straina tehnica I - Germana	Automatica si informatica aplicata	1	3212
273	Complemente de matematica	Automatica si informatica aplicata	1	3212
274	Limba straina tehnica II - Engleza	Automatica si informatica aplicata	1	3212
275	Limba straina tehnica II - Franceza	Automatica si informatica aplicata	1	3212
276	Limba straina tehnica II - Germana	Automatica si informatica aplicata	1	3212
277	Teoria probabilitatilor si statistica matematica	Automatica si informatica aplicata	1	3212
278	Analiza matematica	Automatica si informatica aplicata	1	3213
279	Algebra liniara, geometrie analitica si diferentiala	Automatica si informatica aplicata	1	3213
280	Analiza si sinteza dispozitivelor numerice	Automatica si informatica aplicata	1	3213
281	Programarea calculatoarelor si limbaje de programare I	Automatica si informatica aplicata	1	3213
282	Grafica asistata pe calculator	Automatica si informatica aplicata	1	3213
283	Tehnologie electronica	Automatica si informatica aplicata	1	3213
284	Educatie fizica si sport I	Automatica si informatica aplicata	1	3213
285	Matematici speciale	Automatica si informatica aplicata	1	3213
286	Fizica I	Automatica si informatica aplicata	1	3213
287	Programarea calculatoarelor si limbaje de programare II	Automatica si informatica aplicata	1	3213
288	Electrotehnica	Automatica si informatica aplicata	1	3213
289	Arhitectura calculatoarelor	Automatica si informatica aplicata	1	3213
290	Comunicare	Automatica si informatica aplicata	1	3213
291	Limba engleza I	Automatica si informatica aplicata	1	3213
292	Limba straina tehnica I - Engleza	Automatica si informatica aplicata	1	3213
293	Limba straina tehnica I - Franceza	Automatica si informatica aplicata	1	3213
294	Limba straina tehnica I - Germana	Automatica si informatica aplicata	1	3213
295	Complemente de matematica	Automatica si informatica aplicata	1	3213
296	Limba straina tehnica II - Engleza	Automatica si informatica aplicata	1	3213
297	Limba straina tehnica II - Franceza	Automatica si informatica aplicata	1	3213
298	Limba straina tehnica II - Germana	Automatica si informatica aplicata	1	3213
299	Teoria probabilitatilor si statistica matematica	Automatica si informatica aplicata	1	3213
300	Analiza matematica	Automatica si informatica aplicata	1	3214
301	Algebra liniara, geometrie analitica si diferentiala	Automatica si informatica aplicata	1	3214
302	Analiza si sinteza dispozitivelor numerice	Automatica si informatica aplicata	1	3214
303	Programarea calculatoarelor si limbaje de programare I	Automatica si informatica aplicata	1	3214
304	Grafica asistata pe calculator	Automatica si informatica aplicata	1	3214
305	Tehnologie electronica	Automatica si informatica aplicata	1	3214
306	Educatie fizica si sport I	Automatica si informatica aplicata	1	3214
307	Matematici speciale	Automatica si informatica aplicata	1	3214
308	Fizica I	Automatica si informatica aplicata	1	3214
309	Programarea calculatoarelor si limbaje de programare II	Automatica si informatica aplicata	1	3214
310	Electrotehnica	Automatica si informatica aplicata	1	3214
311	Arhitectura calculatoarelor	Automatica si informatica aplicata	1	3214
312	Comunicare	Automatica si informatica aplicata	1	3214
313	Limba engleza I	Automatica si informatica aplicata	1	3214
314	Limba straina tehnica I - Engleza	Automatica si informatica aplicata	1	3214
315	Limba straina tehnica I - Franceza	Automatica si informatica aplicata	1	3214
316	Limba straina tehnica I - Germana	Automatica si informatica aplicata	1	3214
317	Complemente de matematica	Automatica si informatica aplicata	1	3214
318	Limba straina tehnica II - Engleza	Automatica si informatica aplicata	1	3214
319	Limba straina tehnica II - Franceza	Automatica si informatica aplicata	1	3214
320	Limba straina tehnica II - Germana	Automatica si informatica aplicata	1	3214
321	Teoria probabilitatilor si statistica matematica	Automatica si informatica aplicata	1	3214
322	Circuite electronice liniare I	Automatica si informatica aplicata	2	3221
323	Programarea calculatoarelor si limbaje de programare III	Automatica si informatica aplicata	2	3221
324	Teoria sistemelor I	Automatica si informatica aplicata	2	3221
325	Fizica II	Automatica si informatica aplicata	2	3221
326	Sisteme dinamice cu evenimente discrete	Automatica si informatica aplicata	2	3221
327	Sisteme cu microprocesoare	Automatica si informatica aplicata	2	3221
328	Educatie fizica si sport II	Automatica si informatica aplicata	2	3221
329	Metode numerice	Automatica si informatica aplicata	2	3221
330	Electronica digitala	Automatica si informatica aplicata	2	3221
331	Masurari si traductoare	Automatica si informatica aplicata	2	3221
332	Circuite electronice liniare II	Automatica si informatica aplicata	2	3221
333	Teoria sistemelor II	Automatica si informatica aplicata	2	3221
334	Limbaje de asamblare	Automatica si informatica aplicata	2	3221
335	Practica de domeniu	Automatica si informatica aplicata	2	3221
336	Limba straina tehnica III - Engleza	Automatica si informatica aplicata	2	3221
337	Limba straina tehnica III - Franceza	Automatica si informatica aplicata	2	3221
338	Limba straina tehnica III - Germana	Automatica si informatica aplicata	2	3221
339	Statistica economica	Automatica si informatica aplicata	2	3221
340	Limba straina tehnica IV - Engleza	Automatica si informatica aplicata	2	3221
341	Limba straina tehnica IV - Franceza	Automatica si informatica aplicata	2	3221
342	Limba straina tehnica IV - Germana	Automatica si informatica aplicata	2	3221
343	Circuite electronice liniare I	Automatica si informatica aplicata	2	3222
344	Programarea calculatoarelor si limbaje de programare III	Automatica si informatica aplicata	2	3222
345	Teoria sistemelor I	Automatica si informatica aplicata	2	3222
346	Fizica II	Automatica si informatica aplicata	2	3222
347	Sisteme dinamice cu evenimente discrete	Automatica si informatica aplicata	2	3222
348	Sisteme cu microprocesoare	Automatica si informatica aplicata	2	3222
349	Educatie fizica si sport II	Automatica si informatica aplicata	2	3222
350	Metode numerice	Automatica si informatica aplicata	2	3222
351	Electronica digitala	Automatica si informatica aplicata	2	3222
352	Masurari si traductoare	Automatica si informatica aplicata	2	3222
353	Circuite electronice liniare II	Automatica si informatica aplicata	2	3222
354	Teoria sistemelor II	Automatica si informatica aplicata	2	3222
355	Limbaje de asamblare	Automatica si informatica aplicata	2	3222
356	Practica de domeniu	Automatica si informatica aplicata	2	3222
357	Limba straina tehnica III - Engleza	Automatica si informatica aplicata	2	3222
358	Limba straina tehnica III - Franceza	Automatica si informatica aplicata	2	3222
359	Limba straina tehnica III - Germana	Automatica si informatica aplicata	2	3222
360	Statistica economica	Automatica si informatica aplicata	2	3222
361	Limba straina tehnica IV - Engleza	Automatica si informatica aplicata	2	3222
362	Limba straina tehnica IV - Franceza	Automatica si informatica aplicata	2	3222
363	Limba straina tehnica IV - Germana	Automatica si informatica aplicata	2	3222
364	Circuite electronice liniare I	Automatica si informatica aplicata	2	3223
365	Programarea calculatoarelor si limbaje de programare III	Automatica si informatica aplicata	2	3223
366	Teoria sistemelor I	Automatica si informatica aplicata	2	3223
367	Fizica II	Automatica si informatica aplicata	2	3223
368	Sisteme dinamice cu evenimente discrete	Automatica si informatica aplicata	2	3223
369	Sisteme cu microprocesoare	Automatica si informatica aplicata	2	3223
370	Educatie fizica si sport II	Automatica si informatica aplicata	2	3223
371	Metode numerice	Automatica si informatica aplicata	2	3223
372	Electronica digitala	Automatica si informatica aplicata	2	3223
373	Masurari si traductoare	Automatica si informatica aplicata	2	3223
374	Circuite electronice liniare II	Automatica si informatica aplicata	2	3223
375	Teoria sistemelor II	Automatica si informatica aplicata	2	3223
376	Limbaje de asamblare	Automatica si informatica aplicata	2	3223
377	Practica de domeniu	Automatica si informatica aplicata	2	3223
378	Limba straina tehnica III - Engleza	Automatica si informatica aplicata	2	3223
379	Limba straina tehnica III - Franceza	Automatica si informatica aplicata	2	3223
380	Limba straina tehnica III - Germana	Automatica si informatica aplicata	2	3223
381	Statistica economica	Automatica si informatica aplicata	2	3223
382	Limba straina tehnica IV - Engleza	Automatica si informatica aplicata	2	3223
383	Limba straina tehnica IV - Franceza	Automatica si informatica aplicata	2	3223
384	Limba straina tehnica IV - Germana	Automatica si informatica aplicata	2	3223
385	Circuite electronice liniare I	Automatica si informatica aplicata	2	3224
386	Programarea calculatoarelor si limbaje de programare III	Automatica si informatica aplicata	2	3224
387	Teoria sistemelor I	Automatica si informatica aplicata	2	3224
388	Fizica II	Automatica si informatica aplicata	2	3224
389	Sisteme dinamice cu evenimente discrete	Automatica si informatica aplicata	2	3224
390	Sisteme cu microprocesoare	Automatica si informatica aplicata	2	3224
391	Educatie fizica si sport II	Automatica si informatica aplicata	2	3224
392	Metode numerice	Automatica si informatica aplicata	2	3224
393	Electronica digitala	Automatica si informatica aplicata	2	3224
394	Masurari si traductoare	Automatica si informatica aplicata	2	3224
395	Circuite electronice liniare II	Automatica si informatica aplicata	2	3224
396	Teoria sistemelor II	Automatica si informatica aplicata	2	3224
397	Limbaje de asamblare	Automatica si informatica aplicata	2	3224
398	Practica de domeniu	Automatica si informatica aplicata	2	3224
399	Limba straina tehnica III - Engleza	Automatica si informatica aplicata	2	3224
400	Limba straina tehnica III - Franceza	Automatica si informatica aplicata	2	3224
401	Limba straina tehnica III - Germana	Automatica si informatica aplicata	2	3224
402	Statistica economica	Automatica si informatica aplicata	2	3224
403	Limba straina tehnica IV - Engleza	Automatica si informatica aplicata	2	3224
404	Limba straina tehnica IV - Franceza	Automatica si informatica aplicata	2	3224
405	Limba straina tehnica IV - Germana	Automatica si informatica aplicata	2	3224
406	Microcontrolere - arhitecturi si programare	Automatica si informatica aplicata	3	3231
407	Retele de calculatoare	Automatica si informatica aplicata	3	3231
408	Electronica de putere	Automatica si informatica aplicata	3	3231
409	Ingineria sistemelor automate	Automatica si informatica aplicata	3	3231
410	Modelare, identificare si simulare	Automatica si informatica aplicata	3	3231
411	Modelare, identificare si simulare (proiect)	Automatica si informatica aplicata	3	3231
412	Masini electrice si actionari	Automatica si informatica aplicata	3	3231
413	Baze de date	Automatica si informatica aplicata	3	3231
414	Sisteme de conducere a proceselor tehnologice	Automatica si informatica aplicata	3	3231
415	Optimizari	Automatica si informatica aplicata	3	3231
416	Limba engleza II	Automatica si informatica aplicata	3	3231
417	Practica de specialitate	Automatica si informatica aplicata	3	3231
418	Proiectare asistata de calculator	Automatica si informatica aplicata	3	3231
419	Sisteme de operare	Automatica si informatica aplicata	3	3231
420	Tehnici de securizare a informatiei	Automatica si informatica aplicata	3	3231
421	Prelucrarea semnalelor	Automatica si informatica aplicata	3	3231
422	Instrumentatie virtuala	Automatica si informatica aplicata	3	3231
423	Echipamente de automatizare electrice si electronice	Automatica si informatica aplicata	3	3231
424	Programare JAVA	Automatica si informatica aplicata	3	3231
425	Surse regenerabile	Automatica si informatica aplicata	3	3231
426	Competente antreprenoriale	Automatica si informatica aplicata	3	3231
427	Complemente de ingineria sistemelor	Automatica si informatica aplicata	3	3231
428	Drept si legislatie economica	Automatica si informatica aplicata	3	3231
429	Proiectarea algoritmilor	Automatica si informatica aplicata	3	3231
430	Microcontrolere - arhitecturi si programare	Automatica si informatica aplicata	3	3232
431	Retele de calculatoare	Automatica si informatica aplicata	3	3232
432	Electronica de putere	Automatica si informatica aplicata	3	3232
433	Ingineria sistemelor automate	Automatica si informatica aplicata	3	3232
434	Modelare, identificare si simulare	Automatica si informatica aplicata	3	3232
435	Modelare, identificare si simulare (proiect)	Automatica si informatica aplicata	3	3232
436	Masini electrice si actionari	Automatica si informatica aplicata	3	3232
437	Baze de date	Automatica si informatica aplicata	3	3232
438	Sisteme de conducere a proceselor tehnologice	Automatica si informatica aplicata	3	3232
439	Optimizari	Automatica si informatica aplicata	3	3232
440	Limba engleza II	Automatica si informatica aplicata	3	3232
441	Practica de specialitate	Automatica si informatica aplicata	3	3232
442	Proiectare asistata de calculator	Automatica si informatica aplicata	3	3232
443	Sisteme de operare	Automatica si informatica aplicata	3	3232
444	Tehnici de securizare a informatiei	Automatica si informatica aplicata	3	3232
445	Prelucrarea semnalelor	Automatica si informatica aplicata	3	3232
446	Instrumentatie virtuala	Automatica si informatica aplicata	3	3232
447	Echipamente de automatizare electrice si electronice	Automatica si informatica aplicata	3	3232
448	Programare JAVA	Automatica si informatica aplicata	3	3232
449	Surse regenerabile	Automatica si informatica aplicata	3	3232
450	Competente antreprenoriale	Automatica si informatica aplicata	3	3232
451	Complemente de ingineria sistemelor	Automatica si informatica aplicata	3	3232
452	Drept si legislatie economica	Automatica si informatica aplicata	3	3232
453	Proiectarea algoritmilor	Automatica si informatica aplicata	3	3232
454	Microcontrolere - arhitecturi si programare	Automatica si informatica aplicata	3	3233
455	Retele de calculatoare	Automatica si informatica aplicata	3	3233
456	Electronica de putere	Automatica si informatica aplicata	3	3233
457	Ingineria sistemelor automate	Automatica si informatica aplicata	3	3233
458	Modelare, identificare si simulare	Automatica si informatica aplicata	3	3233
459	Modelare, identificare si simulare (proiect)	Automatica si informatica aplicata	3	3233
460	Masini electrice si actionari	Automatica si informatica aplicata	3	3233
461	Baze de date	Automatica si informatica aplicata	3	3233
462	Sisteme de conducere a proceselor tehnologice	Automatica si informatica aplicata	3	3233
463	Optimizari	Automatica si informatica aplicata	3	3233
464	Limba engleza II	Automatica si informatica aplicata	3	3233
465	Practica de specialitate	Automatica si informatica aplicata	3	3233
466	Proiectare asistata de calculator	Automatica si informatica aplicata	3	3233
467	Sisteme de operare	Automatica si informatica aplicata	3	3233
468	Tehnici de securizare a informatiei	Automatica si informatica aplicata	3	3233
469	Prelucrarea semnalelor	Automatica si informatica aplicata	3	3233
470	Instrumentatie virtuala	Automatica si informatica aplicata	3	3233
471	Echipamente de automatizare electrice si electronice	Automatica si informatica aplicata	3	3233
472	Programare JAVA	Automatica si informatica aplicata	3	3233
473	Surse regenerabile	Automatica si informatica aplicata	3	3233
474	Competente antreprenoriale	Automatica si informatica aplicata	3	3233
475	Complemente de ingineria sistemelor	Automatica si informatica aplicata	3	3233
476	Drept si legislatie economica	Automatica si informatica aplicata	3	3233
477	Proiectarea algoritmilor	Automatica si informatica aplicata	3	3233
478	Microcontrolere - arhitecturi si programare	Automatica si informatica aplicata	3	3234
479	Retele de calculatoare	Automatica si informatica aplicata	3	3234
480	Electronica de putere	Automatica si informatica aplicata	3	3234
481	Ingineria sistemelor automate	Automatica si informatica aplicata	3	3234
482	Modelare, identificare si simulare	Automatica si informatica aplicata	3	3234
483	Modelare, identificare si simulare (proiect)	Automatica si informatica aplicata	3	3234
484	Masini electrice si actionari	Automatica si informatica aplicata	3	3234
485	Baze de date	Automatica si informatica aplicata	3	3234
486	Sisteme de conducere a proceselor tehnologice	Automatica si informatica aplicata	3	3234
487	Optimizari	Automatica si informatica aplicata	3	3234
488	Limba engleza II	Automatica si informatica aplicata	3	3234
489	Practica de specialitate	Automatica si informatica aplicata	3	3234
490	Proiectare asistata de calculator	Automatica si informatica aplicata	3	3234
491	Sisteme de operare	Automatica si informatica aplicata	3	3234
492	Tehnici de securizare a informatiei	Automatica si informatica aplicata	3	3234
493	Prelucrarea semnalelor	Automatica si informatica aplicata	3	3234
494	Instrumentatie virtuala	Automatica si informatica aplicata	3	3234
495	Echipamente de automatizare electrice si electronice	Automatica si informatica aplicata	3	3234
496	Programare JAVA	Automatica si informatica aplicata	3	3234
497	Surse regenerabile	Automatica si informatica aplicata	3	3234
498	Competente antreprenoriale	Automatica si informatica aplicata	3	3234
499	Complemente de ingineria sistemelor	Automatica si informatica aplicata	3	3234
500	Drept si legislatie economica	Automatica si informatica aplicata	3	3234
501	Proiectarea algoritmilor	Automatica si informatica aplicata	3	3234
502	Programarea aplicatiilor internet	Automatica si informatica aplicata	4	3241
503	Retele industriale de calculatoare	Automatica si informatica aplicata	4	3241
504	Managementul proiectelor	Automatica si informatica aplicata	4	3241
505	Sisteme de inteligenta artificiala distribuite	Automatica si informatica aplicata	4	3241
506	Circuite periferice si interfete de proces	Automatica si informatica aplicata	4	3241
507	Limba engleza III	Automatica si informatica aplicata	4	3241
508	Automate si microprogramare	Automatica si informatica aplicata	4	3241
509	Fiabilitate si diagnoza	Automatica si informatica aplicata	4	3241
510	Fiabilitate si diagnoza (proiect)	Automatica si informatica aplicata	4	3241
511	Elaborarea proiectului de diploma	Automatica si informatica aplicata	4	3241
512	Practica pentru proiectul de diploma	Automatica si informatica aplicata	4	3241
513	Sisteme de timp real	Automatica si informatica aplicata	4	3241
514	Conducerea structurilor flexibile de fabricatie	Automatica si informatica aplicata	4	3241
515	Retele neuronale si logica fuzzy	Automatica si informatica aplicata	4	3241
516	Sisteme de comanda si reglare a actionarilor electrice	Automatica si informatica aplicata	4	3241
517	Automatizarea cladirilor	Automatica si informatica aplicata	4	3241
518	Internetul obiectelor	Automatica si informatica aplicata	4	3241
519	Tehnici de programare cu baze de date	Automatica si informatica aplicata	4	3241
520	Circuite logice programabile	Automatica si informatica aplicata	4	3241
521	Proiectarea bazelor de date	Automatica si informatica aplicata	4	3241
522	Ingineria sistemelor de programe	Automatica si informatica aplicata	4	3241
523	Sisteme mobile	Automatica si informatica aplicata	4	3241
524	Inventica	Automatica si informatica aplicata	4	3241
525	Programarea aplicatiilor internet	Automatica si informatica aplicata	4	3242
526	Retele industriale de calculatoare	Automatica si informatica aplicata	4	3242
527	Managementul proiectelor	Automatica si informatica aplicata	4	3242
528	Sisteme de inteligenta artificiala distribuite	Automatica si informatica aplicata	4	3242
529	Circuite periferice si interfete de proces	Automatica si informatica aplicata	4	3242
530	Limba engleza III	Automatica si informatica aplicata	4	3242
531	Automate si microprogramare	Automatica si informatica aplicata	4	3242
532	Fiabilitate si diagnoza	Automatica si informatica aplicata	4	3242
533	Fiabilitate si diagnoza (proiect)	Automatica si informatica aplicata	4	3242
534	Elaborarea proiectului de diploma	Automatica si informatica aplicata	4	3242
535	Practica pentru proiectul de diploma	Automatica si informatica aplicata	4	3242
536	Sisteme de timp real	Automatica si informatica aplicata	4	3242
537	Conducerea structurilor flexibile de fabricatie	Automatica si informatica aplicata	4	3242
538	Retele neuronale si logica fuzzy	Automatica si informatica aplicata	4	3242
539	Sisteme de comanda si reglare a actionarilor electrice	Automatica si informatica aplicata	4	3242
540	Automatizarea cladirilor	Automatica si informatica aplicata	4	3242
541	Internetul obiectelor	Automatica si informatica aplicata	4	3242
542	Tehnici de programare cu baze de date	Automatica si informatica aplicata	4	3242
543	Circuite logice programabile	Automatica si informatica aplicata	4	3242
544	Proiectarea bazelor de date	Automatica si informatica aplicata	4	3242
545	Ingineria sistemelor de programe	Automatica si informatica aplicata	4	3242
546	Sisteme mobile	Automatica si informatica aplicata	4	3242
547	Inventica	Automatica si informatica aplicata	4	3242
548	Programarea aplicatiilor internet	Automatica si informatica aplicata	4	3243
549	Retele industriale de calculatoare	Automatica si informatica aplicata	4	3243
550	Managementul proiectelor	Automatica si informatica aplicata	4	3243
551	Sisteme de inteligenta artificiala distribuite	Automatica si informatica aplicata	4	3243
552	Circuite periferice si interfete de proces	Automatica si informatica aplicata	4	3243
553	Limba engleza III	Automatica si informatica aplicata	4	3243
554	Automate si microprogramare	Automatica si informatica aplicata	4	3243
555	Fiabilitate si diagnoza	Automatica si informatica aplicata	4	3243
556	Fiabilitate si diagnoza (proiect)	Automatica si informatica aplicata	4	3243
557	Elaborarea proiectului de diploma	Automatica si informatica aplicata	4	3243
558	Practica pentru proiectul de diploma	Automatica si informatica aplicata	4	3243
559	Sisteme de timp real	Automatica si informatica aplicata	4	3243
560	Conducerea structurilor flexibile de fabricatie	Automatica si informatica aplicata	4	3243
561	Retele neuronale si logica fuzzy	Automatica si informatica aplicata	4	3243
562	Sisteme de comanda si reglare a actionarilor electrice	Automatica si informatica aplicata	4	3243
563	Automatizarea cladirilor	Automatica si informatica aplicata	4	3243
564	Internetul obiectelor	Automatica si informatica aplicata	4	3243
565	Tehnici de programare cu baze de date	Automatica si informatica aplicata	4	3243
566	Circuite logice programabile	Automatica si informatica aplicata	4	3243
567	Proiectarea bazelor de date	Automatica si informatica aplicata	4	3243
568	Ingineria sistemelor de programe	Automatica si informatica aplicata	4	3243
569	Sisteme mobile	Automatica si informatica aplicata	4	3243
570	Inventica	Automatica si informatica aplicata	4	3243
571	Programarea aplicatiilor internet	Automatica si informatica aplicata	4	3244
572	Retele industriale de calculatoare	Automatica si informatica aplicata	4	3244
573	Managementul proiectelor	Automatica si informatica aplicata	4	3244
574	Sisteme de inteligenta artificiala distribuite	Automatica si informatica aplicata	4	3244
575	Circuite periferice si interfete de proces	Automatica si informatica aplicata	4	3244
576	Limba engleza III	Automatica si informatica aplicata	4	3244
577	Automate si microprogramare	Automatica si informatica aplicata	4	3244
578	Fiabilitate si diagnoza	Automatica si informatica aplicata	4	3244
579	Fiabilitate si diagnoza (proiect)	Automatica si informatica aplicata	4	3244
580	Elaborarea proiectului de diploma	Automatica si informatica aplicata	4	3244
581	Practica pentru proiectul de diploma	Automatica si informatica aplicata	4	3244
582	Sisteme de timp real	Automatica si informatica aplicata	4	3244
583	Conducerea structurilor flexibile de fabricatie	Automatica si informatica aplicata	4	3244
584	Retele neuronale si logica fuzzy	Automatica si informatica aplicata	4	3244
585	Sisteme de comanda si reglare a actionarilor electrice	Automatica si informatica aplicata	4	3244
586	Automatizarea cladirilor	Automatica si informatica aplicata	4	3244
587	Internetul obiectelor	Automatica si informatica aplicata	4	3244
588	Tehnici de programare cu baze de date	Automatica si informatica aplicata	4	3244
589	Circuite logice programabile	Automatica si informatica aplicata	4	3244
590	Proiectarea bazelor de date	Automatica si informatica aplicata	4	3244
591	Ingineria sistemelor de programe	Automatica si informatica aplicata	4	3244
592	Sisteme mobile	Automatica si informatica aplicata	4	3244
593	Inventica	Automatica si informatica aplicata	4	3244
594	Analiza matematica	ETTI	1	3311
595	Algebra liniara, geometrie analitica si diferentiala	ETTI	1	3311
596	Circuite integrate digitale I	ETTI	1	3311
597	Grafica asistata de calculator	ETTI	1	3311
598	Programarea calculatoarelor si limbaje de programare I	ETTI	1	3311
599	Limba engleza I	ETTI	1	3311
600	Educatie fizica I	ETTI	1	3311
601	Matematici speciale	ETTI	1	3311
602	Fizica I	ETTI	1	3311
603	Informatica aplicata	ETTI	1	3311
604	Metode numerice	ETTI	1	3311
605	Dispozitive electronice	ETTI	1	3311
606	Bazele electrotehnicii I	ETTI	1	3311
607	Limba engleza II	ETTI	1	3311
608	Educatie fizica II	ETTI	1	3311
609	Componente si circuite pasive	ETTI	1	3311
610	Analiza matematica	ETTI	1	3312
611	Algebra liniara, geometrie analitica si diferentiala	ETTI	1	3312
612	Circuite integrate digitale I	ETTI	1	3312
613	Grafica asistata de calculator	ETTI	1	3312
614	Programarea calculatoarelor si limbaje de programare I	ETTI	1	3312
615	Limba engleza I	ETTI	1	3312
616	Educatie fizica I	ETTI	1	3312
617	Matematici speciale	ETTI	1	3312
618	Fizica I	ETTI	1	3312
619	Informatica aplicata	ETTI	1	3312
620	Metode numerice	ETTI	1	3312
621	Dispozitive electronice	ETTI	1	3312
622	Bazele electrotehnicii I	ETTI	1	3312
623	Limba engleza II	ETTI	1	3312
624	Educatie fizica II	ETTI	1	3312
625	Componente si circuite pasive	ETTI	1	3312
626	Analiza matematica	ETTI	1	3313
627	Algebra liniara, geometrie analitica si diferentiala	ETTI	1	3313
628	Circuite integrate digitale I	ETTI	1	3313
629	Grafica asistata de calculator	ETTI	1	3313
630	Programarea calculatoarelor si limbaje de programare I	ETTI	1	3313
631	Limba engleza I	ETTI	1	3313
632	Educatie fizica I	ETTI	1	3313
633	Matematici speciale	ETTI	1	3313
634	Fizica I	ETTI	1	3313
635	Informatica aplicata	ETTI	1	3313
636	Metode numerice	ETTI	1	3313
637	Dispozitive electronice	ETTI	1	3313
638	Bazele electrotehnicii I	ETTI	1	3313
639	Limba engleza II	ETTI	1	3313
640	Educatie fizica II	ETTI	1	3313
641	Componente si circuite pasive	ETTI	1	3313
642	Analiza matematica	ETTI	1	3314
643	Algebra liniara, geometrie analitica si diferentiala	ETTI	1	3314
644	Circuite integrate digitale I	ETTI	1	3314
645	Grafica asistata de calculator	ETTI	1	3314
646	Programarea calculatoarelor si limbaje de programare I	ETTI	1	3314
647	Limba engleza I	ETTI	1	3314
648	Educatie fizica I	ETTI	1	3314
649	Matematici speciale	ETTI	1	3314
650	Fizica I	ETTI	1	3314
651	Informatica aplicata	ETTI	1	3314
652	Metode numerice	ETTI	1	3314
653	Dispozitive electronice	ETTI	1	3314
654	Bazele electrotehnicii I	ETTI	1	3314
655	Limba engleza II	ETTI	1	3314
656	Educatie fizica II	ETTI	1	3314
657	Componente si circuite pasive	ETTI	1	3314
658	Circuite electronice fundamentale	ETTI	2	3321
659	Semnale si sisteme I	ETTI	2	3321
660	Fizica II	ETTI	2	3321
661	Teoria transmisiunii informatiei	ETTI	2	3321
662	Limba engleza III	ETTI	2	3321
663	Educatie fizica III	ETTI	2	3321
664	Circuite integrate analogice	ETTI	2	3321
665	Circuite integrate digitale II	ETTI	2	3321
666	Semnale si sisteme II	ETTI	2	3321
667	Masuratori in electronica si telecomunicatii	ETTI	2	3321
668	Programarea calculatoarelor si limbaje de programare II	ETTI	2	3321
669	Limba engleza IV	ETTI	2	3321
670	Educatie fizica IV	ETTI	2	3321
671	Practica de domeniu	ETTI	2	3321
672	Optoelectronica	ETTI	2	3321
673	Tehnici de comunicare	ETTI	2	3321
674	Circuite electronice fundamentale	ETTI	2	3322
675	Semnale si sisteme I	ETTI	2	3322
676	Fizica II	ETTI	2	3322
677	Teoria transmisiunii informatiei	ETTI	2	3322
678	Limba engleza III	ETTI	2	3322
679	Educatie fizica III	ETTI	2	3322
680	Circuite integrate analogice	ETTI	2	3322
681	Circuite integrate digitale II	ETTI	2	3322
682	Semnale si sisteme II	ETTI	2	3322
683	Masuratori in electronica si telecomunicatii	ETTI	2	3322
684	Programarea calculatoarelor si limbaje de programare II	ETTI	2	3322
685	Limba engleza IV	ETTI	2	3322
686	Educatie fizica IV	ETTI	2	3322
687	Practica de domeniu	ETTI	2	3322
688	Optoelectronica	ETTI	2	3322
689	Tehnici de comunicare	ETTI	2	3322
690	Circuite electronice fundamentale	ETTI	2	3323
691	Semnale si sisteme I	ETTI	2	3323
692	Fizica II	ETTI	2	3323
693	Teoria transmisiunii informatiei	ETTI	2	3323
694	Limba engleza III	ETTI	2	3323
695	Educatie fizica III	ETTI	2	3323
696	Circuite integrate analogice	ETTI	2	3323
697	Circuite integrate digitale II	ETTI	2	3323
698	Semnale si sisteme II	ETTI	2	3323
699	Masuratori in electronica si telecomunicatii	ETTI	2	3323
700	Programarea calculatoarelor si limbaje de programare II	ETTI	2	3323
701	Limba engleza IV	ETTI	2	3323
702	Educatie fizica IV	ETTI	2	3323
703	Practica de domeniu	ETTI	2	3323
704	Optoelectronica	ETTI	2	3323
705	Tehnici de comunicare	ETTI	2	3323
706	Circuite electronice fundamentale	ETTI	2	3324
707	Semnale si sisteme I	ETTI	2	3324
708	Fizica II	ETTI	2	3324
709	Teoria transmisiunii informatiei	ETTI	2	3324
710	Limba engleza III	ETTI	2	3324
711	Educatie fizica III	ETTI	2	3324
712	Circuite integrate analogice	ETTI	2	3324
713	Circuite integrate digitale II	ETTI	2	3324
714	Semnale si sisteme II	ETTI	2	3324
715	Masuratori in electronica si telecomunicatii	ETTI	2	3324
716	Programarea calculatoarelor si limbaje de programare II	ETTI	2	3324
717	Limba engleza IV	ETTI	2	3324
718	Educatie fizica IV	ETTI	2	3324
719	Practica de domeniu	ETTI	2	3324
720	Optoelectronica	ETTI	2	3324
721	Tehnici de comunicare	ETTI	2	3324
722	Bazele sistemelor de achizitii de date	ETTI	3	3331
723	Tehnici CAD in realizarea modulelor electronice	ETTI	3	3331
724	Radiocomunicatii	ETTI	3	3331
725	Microcontrolere	ETTI	3	3331
726	Microcontrolere (proiect)	ETTI	3	3331
727	Microunde	ETTI	3	3331
728	Comunicatii analogice si digitale	ETTI	3	3331
729	Arhitectura microprocesoarelor	ETTI	3	3331
730	Practica de specialitate	ETTI	3	3331
731	Televiziune	ETTI	3	3331
732	Circuite de RF si microunde (RFID)	ETTI	3	3331
733	Circuite de RF si microunde (RFID)(proiect)	ETTI	3	3331
734	Nano si microtehnologii pentru electronica	ETTI	3	3331
735	Managementul proiectelor	ETTI	3	3331
736	Bazele sistemelor de achizitii de date	ETTI	3	3332
737	Tehnici CAD in realizarea modulelor electronice	ETTI	3	3332
738	Radiocomunicatii	ETTI	3	3332
739	Microcontrolere	ETTI	3	3332
740	Microcontrolere (proiect)	ETTI	3	3332
741	Microunde	ETTI	3	3332
742	Comunicatii analogice si digitale	ETTI	3	3332
743	Arhitectura microprocesoarelor	ETTI	3	3332
744	Practica de specialitate	ETTI	3	3332
745	Televiziune	ETTI	3	3332
746	Circuite de RF si microunde (RFID)	ETTI	3	3332
747	Circuite de RF si microunde (RFID)(proiect)	ETTI	3	3332
748	Nano si microtehnologii pentru electronica	ETTI	3	3332
749	Managementul proiectelor	ETTI	3	3332
750	Bazele sistemelor de achizitii de date	ETTI	3	3333
751	Tehnici CAD in realizarea modulelor electronice	ETTI	3	3333
752	Radiocomunicatii	ETTI	3	3333
753	Microcontrolere	ETTI	3	3333
754	Microcontrolere (proiect)	ETTI	3	3333
755	Microunde	ETTI	3	3333
756	Comunicatii analogice si digitale	ETTI	3	3333
757	Arhitectura microprocesoarelor	ETTI	3	3333
758	Practica de specialitate	ETTI	3	3333
759	Televiziune	ETTI	3	3333
760	Circuite de RF si microunde (RFID)	ETTI	3	3333
761	Circuite de RF si microunde (RFID)(proiect)	ETTI	3	3333
762	Nano si microtehnologii pentru electronica	ETTI	3	3333
763	Managementul proiectelor	ETTI	3	3333
764	Bazele sistemelor de achizitii de date	ETTI	3	3334
765	Tehnici CAD in realizarea modulelor electronice	ETTI	3	3334
766	Radiocomunicatii	ETTI	3	3334
767	Microcontrolere	ETTI	3	3334
768	Microcontrolere (proiect)	ETTI	3	3334
769	Microunde	ETTI	3	3334
770	Comunicatii analogice si digitale	ETTI	3	3334
771	Arhitectura microprocesoarelor	ETTI	3	3334
772	Practica de specialitate	ETTI	3	3334
773	Televiziune	ETTI	3	3334
774	Circuite de RF si microunde (RFID)	ETTI	3	3334
775	Circuite de RF si microunde (RFID)(proiect)	ETTI	3	3334
776	Nano si microtehnologii pentru electronica	ETTI	3	3334
777	Managementul proiectelor	ETTI	3	3334
778	Retele de calculatoare	ETTI	4	3341
779	Retele de comunicatii mobile	ETTI	4	3341
780	Inginerie software pentru comunicatii	ETTI	4	3341
781	Prelucrarea digitala a semnalelor	ETTI	4	3341
782	Securitatea comunicatiilor de date	ETTI	4	3341
783	Compatibilitate electromagnetica	ETTI	4	3341
784	Comunicatii 4G si 5G	ETTI	4	3341
785	Practica pentru elaborarea proiectului de diploma	ETTI	4	3341
786	Elaborarea proiectului de diploma	ETTI	4	3341
787	Comunicatii optice	ETTI	4	3341
788	Protocoale de telecomunicatii	ETTI	4	3341
789	Procesoare de semnal in comunicatii	ETTI	4	3341
790	Calitate si fiabilitate	ETTI	4	3341
791	Retele de calculatoare	ETTI	4	3342
792	Retele de comunicatii mobile	ETTI	4	3342
793	Inginerie software pentru comunicatii	ETTI	4	3342
794	Prelucrarea digitala a semnalelor	ETTI	4	3342
795	Securitatea comunicatiilor de date	ETTI	4	3342
796	Compatibilitate electromagnetica	ETTI	4	3342
797	Comunicatii 4G si 5G	ETTI	4	3342
798	Practica pentru elaborarea proiectului de diploma	ETTI	4	3342
799	Elaborarea proiectului de diploma	ETTI	4	3342
800	Comunicatii optice	ETTI	4	3342
801	Protocoale de telecomunicatii	ETTI	4	3342
802	Procesoare de semnal in comunicatii	ETTI	4	3342
803	Calitate si fiabilitate	ETTI	4	3342
804	Retele de calculatoare	ETTI	4	3343
805	Retele de comunicatii mobile	ETTI	4	3343
806	Inginerie software pentru comunicatii	ETTI	4	3343
807	Prelucrarea digitala a semnalelor	ETTI	4	3343
808	Securitatea comunicatiilor de date	ETTI	4	3343
809	Compatibilitate electromagnetica	ETTI	4	3343
810	Comunicatii 4G si 5G	ETTI	4	3343
811	Practica pentru elaborarea proiectului de diploma	ETTI	4	3343
812	Elaborarea proiectului de diploma	ETTI	4	3343
813	Comunicatii optice	ETTI	4	3343
814	Protocoale de telecomunicatii	ETTI	4	3343
815	Procesoare de semnal in comunicatii	ETTI	4	3343
816	Calitate si fiabilitate	ETTI	4	3343
817	Retele de calculatoare	ETTI	4	3344
818	Retele de comunicatii mobile	ETTI	4	3344
819	Inginerie software pentru comunicatii	ETTI	4	3344
820	Prelucrarea digitala a semnalelor	ETTI	4	3344
821	Securitatea comunicatiilor de date	ETTI	4	3344
822	Compatibilitate electromagnetica	ETTI	4	3344
823	Comunicatii 4G si 5G	ETTI	4	3344
824	Practica pentru elaborarea proiectului de diploma	ETTI	4	3344
825	Elaborarea proiectului de diploma	ETTI	4	3344
826	Comunicatii optice	ETTI	4	3344
827	Protocoale de telecomunicatii	ETTI	4	3344
828	Procesoare de semnal in comunicatii	ETTI	4	3344
829	Calitate si fiabilitate	ETTI	4	3344
\.


--
-- TOC entry 4836 (class 0 OID 24610)
-- Dependencies: 225
-- Data for Name: exams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exams (id, discipline_id, proposed_by, proposed_date, confirmed_date, room_id, teacher_id, assistant_ids, status, group_name) FROM stdin;
\.


--
-- TOC entry 4832 (class 0 OID 24591)
-- Dependencies: 221
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rooms (id, name, building, capacity) FROM stdin;
8	C001	C	42
9	C002	C	42
10	C004	C	21
11	C005	C	21
12	C007	C	0
13	C101	C	30
14	C102	C	29
15	C103	C	30
16	C104	C	21
17	C105	C	21
19	C107	C	21
20	C108	C	0
21	C109	C	19
22	C201	C	28
23	C202	C	28
24	C203	C	28
25	C204	C	21
26	C205	C	0
27	C206	C	0
28	C207	C	21
29	C208	C	0
30	C209	C	19
31	C301	C	28
32	C302	C	28
33	C303	C	28
34	C304	C	21
35	C305	C	21
37	C307	C	0
38	D001	D	0
39	D002	D	0
40	D003	D	0
41	D004	D	0
43	D005	D	0
44	D006	D	18
45	D007	D	14
46	D008	D	14
47	D009	D	14
48	D011	D	21
49	D101	D	36
51	D103	D	0
52	D104a	D	0
53	D105	D	0
54	D106	D	14
55	D107	D	14
56	D108	D	0
57	D109	D	0
58	D111	D	0
60	D205	D	14
61	D207	D	0
63	amf. Dragomir Hurmuzescu	D	36
65	amf. Nicolae Boţan	D	36
66	amf. Remus Radulet	D	36
70	A018 Laborator Gamificarea Ed	A	12
71	A022 Centru Resurse ET	A	20
72	C306	C	21
73	Amf. Emanuel Diaconescu	B	0
74	B302 Tehnica dentara-Protetica	B	0
81	ED004	E	0
82	E213	E	0
83	E210	E	0
84	E205	E	0
85	E223	E	0
90	B304	B	0
92	B305 Laborator Fizica	B	0
93	B307 Sala Curs	B	0
94	B310 Sala Curs	B	0
95	FIM B312	B	0
96	B006 Laborator Mec Fluide	B	0
97	B008 Laborator Termotehnica	B	0
102	B209 Laborator Mecanica	B	0
104	B213 Laborator Rezistenta	B	0
106	B202 Laborator Desen Tehnic	B	0
107	B301 Tehnica dentara-protetica	B	0
108	B303 Laborator microbiologie	B	0
110	B308 Laborator Sisteme Mecatr	B	0
111	B309 Laborator Proiectare Asis	B	0
112	Laborator TM	B	0
113	Laborator ROBOTI	B	0
115	ED001	E	0
116	E209	E	0
117	Obs2 Lab. Testare Psihologică	Obs.	0
118	G101	G	0
120	B101 Nutriție și Metabolism	B	0
122	B011 Laborator Dispozitive 	B	0
123	B012 Laborator Prelucr def	B	0
124	B013 Laborator Tehn de Fabr	B	0
125	B014 Laborator Concep Fabr	B	0
126	B005 Laborator TT	B	0
128	B203 Laborator Stiinta IngMat 	B	0
129	Sala sport	Sala	0
130	C003	C	21
132	Obs. 1 - Sală mare	Obs.	0
133	B007 Laborator Masini Unelte	B	0
135	Amf E129	E	0
136	E230	E	0
137	A114 (A53)	A	0
140	A121 - laborator	A	0
141	E206	E	0
144	Sala Club	Camin	0
147	Sala Stadion Areni	A	0
150	E216	E	0
151	Teren  sintetic	\N	0
153	E003	E	0
154	Lectoratul Francez	A	20
155	E219	E	0
156	E005	E	31
157	E006	E	0
158	B201 Laborator Infografica	B	0
159	A20	A	0
160	K102 Laborator fizioterapie	K	0
162	amf. Dimitrie Leonida	D	43
163	Laborator Limbi Moderne	A	20
164	Sala Eugeniu Coşeriu	A	60
165	A024	A	0
167	Amfiteatrul Eugen Lovinescu	A	110
168	Laborator Multimedia ProLang	A	20
169	Lectoratul Italian	A	20
170	Lectoratul Spaniol	A	0
172	Sala Studii Anglo-Americane	A	40
173	Centrul de Reusita Universitar	A	0
174	Laborator Media	\N	20
176	Sală An pregătitor	\N	20
178	Lectoratul German	A	0
182	E120	E	0
184	P.Bucovina 4	PB	0
185	P.Bucovina 11bis	PB	0
186	 E220	E	0
187	A038	A	0
192	E201	E	0
193	E123	E	10
194	ED024	E	0
195	ED016	E	0
196	FIM1	B	0
197	E101	E	31
200	ED011	E	0
201	E233	E	31
203	ED028-30	E	0
207	E 224	E	0
209	Casa alba DPPD	C.A.	0
213	E126	E	0
214	Sala Senat	H	0
215	Catedra de Franceza	A	0
216	A112 - sala DSPP	A	0
218	E119	E	0
222	ED015	E	0
224	Sala curs LB3	\N	0
225	A033	A	16
227	D110	D	0
230	E118	E	0
233	B004 Laborator Chimie	B	0
234	K210	K	0
235	A113(A52)	A	0
238	K 107 - Laborator BFKT	K	0
239	Bazin de înot	K	0
240	Stadion Areni	Stadion	0
242	Laborator de Etnografie	A	36
246	Lectoratul Ucrainean	A	10
249	Birou Comunicare	A	0
250	Catedra de Română	A	0
251	Catedra de Engleza	A	0
252	L201 - Sală Forță	A	0
303	E007	E	0
304	E010	E	0
305	E012	E	0
306	E013	E	0
307	E132	E	0
308	E113 Laborator	E	0
309	E110	E	0
310	E109 Laborator	E	0
311	E106 Sala calculatoare	E	0
312	E105	E	0
313	E227	E	0
314	E032	E	0
315	E034	E	0
316	E036	E	0
318	E026	E	0
319	A116	A	0
320	A117	A	0
321	A004	A	0
322	E218	E	0
323	J6	J	20
325	E217	E	0
326	C4-Microcantina	Camin	0
327	A 034	A	0
328	A109	A	13
330	A013	A	0
332	A110	A	16
333	S1	A	0
334	E039	E	0
341	Catedra de Română2	A	0
342	Birou Doctorat+CADISS	A	0
343	Epigon	A	0
344	Lab DSP	\N	0
345	Bazin (culuar 1)	K	0
346	Bazin (culuar 2)	K	0
347	Bazin (culuar 3)	K	0
348	Bazin (culuar 4)	K	0
349	Bazin (culuar 5)	K	0
350	Bazin (culuar 6)	K	0
363	A036a	A	16
366	H103	H	0
367	H102	H	0
368	H306	H	0
369	H301	H	6
370	E221	E	0
371	H304	H	0
373	H206	H	0
376	H205	H	0
377	H108	H	0
378	H105	H	6
379	A006	A	0
380	E124	E	0
381	H203	H	0
382	H303	H	0
383	H002	H	0
384	H109	H	0
386	ED003	E	0
387	Birou It.+Sp.+Ucr. 	A	0
388	E235	E	0
389	H207	H	0
390	H104	H	0
391	Consiliu Judetean	H	0
393	Birou Director CSUD	E	0
398	ED010	E	0
400	ED013	E	0
401	ED012	E	0
402	Laborator cercetare E.A.	E	0
403	A118	A	0
404	E 208 Catedra	E	0
406	E 228 Catedra	E	0
407	Birou E 203 Catedra	E	0
409	E 212 Catedra	E	0
411	E 229 Catedra	E	0
412	A 31 Catedra Centrul de Studii	A	0
413	E 0010 Prorectorat Relatii Int	E	0
414	E211 Filosofie	E	0
418	E232 Filosofie	E	0
427	B216 Birou CD	B	0
431	B207 Birou CD	B	0
442	H110	H	0
443	H204	H	0
446	E238	E	0
447	E204	E	0
448	E207	E	0
449	E231	E	0
450	E214	E	0
453	Catedra1 FSE	A	0
454	Catedra2 FSE	A	0
455	E234	E	0
460	H001	H	0
461	S62	A	0
462	B104 Laborator OM+Trib	B	0
472	E 015	E	0
476	Birou A 7 Doctorat Istorie	A	0
484	H202	H	0
485	E125	E	0
487	E222	E	0
488	H305	H	0
489	Birou Scoala doctorala	A	0
490	C408	C	0
491	Scoala Doctorala	C	0
492	C402	C	0
493	C404	C	15
495	C401b	C	15
497	Birou Doctorat RN	A	0
498	Birou Doctorat MAD	A	0
501	H107	H	0
502	L104 - Sala Fitness	A	0
503	B212 Laborator Tolerante	B	0
506	B108 Laborator Mecanisme	B	0
510	B112 Laborator Mectr auto	B	0
512	H101	H	0
516	H201	H	0
519	A026 - birou	A	0
520	Restaurant USV	Restaur	0
521	Aula E	E	38
522	C409	C	0
524	ED022	E	0
525	A. Aula	A	46
526	Decanat FLSC A002	A	0
529	E011A Secretariat FMSB	E	0
530	C5-108	Camin	0
536	108	Camin	0
537	Incubator de afaceri	Cămin	0
548	D102	D	0
549	E215	E	0
550	Sustinere teza doctorat	D	0
551	Lab Act	B	0
554	C405	C	0
555	Decanat	A	0
556	Birou	A	0
557	Corp K	K	0
558		E	0
559	A016 - birou	A	0
560	E237	E	0
561	A009 - birou	A	0
562	C401d	C	15
563	Birou A210	A	0
567	A027 - birou	A	0
570	J1	J	16
571	Laborator Scule Aschietoare	B	0
573	B206a Birou CD	B	0
575	Birou 110	B	0
577	E240	E	0
578	Auditorium	F	0
582	E236	E	0
584	D104b	D	0
587	Sala Consiliu	H	0
590	B206b	B	0
592	A032	A	0
593	E239	\N	0
594	P.Bucovina 3	PB	0
595	P.Bucovina 6	PB	0
596	P.Bucovina 7	PB	0
598	Foaier, Auditorium, corp F 	F	0
600	PB2	PB	0
604	C406	C	0
607	PB5	PB	0
608	P. Bucovina 201	PB	0
609	P.Bucovina 202	PB	0
611	Lab Dinamica/Vibratii	B	0
612	N108	N	0
613	A 012	A	0
618	PB002	PB	0
620	037a	A	0
622	Bicom 2	Bicom	0
624	_on-line	\N	999
628	C407	C	20
633	B110a Laborator Sist de act	B	0
634	P. Bucovina 301	PB	0
635	037b	A	0
641	ED005	E	0
645	ED007	\N	0
646	ED026	\N	0
655	P.Bucovina 302	PB	0
656	A035	A	0
657	Corp CH - CreativeHUB 3	\N	0
658	CreativeHUB 1	CH	0
659	CreativeHUB 2	CH	0
661	CreativeHUB 4	CH	0
662	Bazele Ing Autovehic	B	0
666	LB4	\N	0
667	corp F - Sala 110 Radio USV	F	18
672	BookCafe	\N	0
673	B103 Laborator Sist Rob AV	B	0
674	E116 Director Biblioteca	E	0
675	B206c Birou CD	B	0
676	A208 Birou	A	0
677	Centru de practică	\N	0
680	C401e	C	0
681	Centru Media	E	0
683	CNI Spiru Haret - Sala II.5	\N	30
685	CNI Spiru Haret - Sala II.4	\N	30
689	CNI Spiru Haret - Sala II.6	\N	30
690	Sala lectura	A	90
691	Sala periodice Biblioteca USV	A	30
692	B313	B	30
698	Metrologie Avansată 	B	0
699	C410	C	2
701	H302	H	0
706	PB401	\N	0
709	Sectii clinice SCJSV	\N	0
710	D101a	D	25
714	J7	J	30
717	Ambulator SCJU/Sectii clinice	\N	0
722	B102 Laborator Proiect Scule	B	0
723	B113 Laborator Transmisii auto	\N	0
724	Rectorat	E	0
726	Lab biologie moleculara SCJUSV	\N	0
727	Clinici	\N	0
728	Patinoar	\N	0
730	D011a	D	0
\.


--
-- TOC entry 4834 (class 0 OID 24599)
-- Dependencies: 223
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, role, password_hash, is_active, group_name) FROM stdin;
1	Admin	admin@usv.ro	ADM	$2b$12$n.QtPcwWidBnceUxF3v9weg6666bQARt8q39omTfhj0gHr2C3BrUq	t	\N
2	Secretary	sec@usv.ro	SEC	$2b$12$7uDL.oZrIT9mg0VF.qobzerP6qkfivyVPJu1JUceqcrpZm5MAcff2	t	\N
3	Coordinator	cd@usv.ro	CD	$2b$12$MOuHwA4EwkzcP2QGompt3.mI.51hAELdp8czR9adSs7gSpdGaoAFW	t	\N
4	StudentGroup	sg@usv.ro	SG	$2b$12$UObm0FeqpR.Xh/xQrpW/OOrIy62aWMyZTHPRwEBzJ3VsCKItwHdrS	t	\N
5	Alexandru Tudor Andrei	tudor.andrei@usm.ro	CD	\N	t	\N
6	Adina Luminita Barila	adina@eed.usv.ro	CD	\N	t	\N
7	Laura-Bianca Bilius	laura.bilius@usm.ro	CD	\N	t	\N
8	Adrian-Vasile Catana	adrian.catana@usm.ro	CD	\N	t	\N
9	Mihaela Chistol	mihaela.chistol@usm.ro	CD	\N	t	\N
10	Andrei Codrean	andrei.codrean@assist.ro	CD	\N	t	\N
11	Mirela Danubianu	mdanub@eed.usv.ro	CD	\N	t	\N
12	Eugen Dodiu	eugen.dodiu@usm.ro	CD	\N	t	\N
13	Cristina Nicoleta Gaitan	cristinag@usm.ro	CD	\N	t	\N
14	Vasile Gheorghita Gaitan	gaitan@eed.usv.ro	CD	\N	t	\N
15	Bogdan Gheran	bogdan.gheran@usm.ro	CD	\N	t	\N
16	Ovidiu Gherman	ovidiug@eed.usv.ro	CD	\N	t	\N
17	Felicia Giza-Belciug	felicia@eed.usv.ro	CD	\N	t	\N
18	Ionel Gordin	ionel@usv.ro	CD	\N	t	\N
19	Bogdanel Gradinaru	bogdan.gradinaru@usm.ro	CD	\N	t	\N
20	Nicolai Iuga	nicolaiiuga@gmail.com	CD	\N	t	\N
21	Alexandru Nistor	alexandru.nistor@assist.ro	CD	\N	t	\N
22	Cristian Pamparau	pamparaucristian0@gmail.com	CD	\N	t	\N
23	Ionut-Dorin Pavel	ipavel@usm.ro	CD	\N	t	\N
24	Stefan Gheorghe Pentiuc	pentiuc@eed.usv.ro	CD	\N	t	\N
25	Floarea Pitu	floarea.pitu@usm.ro	CD	\N	t	\N
26	Ionela Rusu	ionela.rusu@usm.ro	CD	\N	t	\N
27	Ovidiu-Andrei Schipor	oschipor@gmail.com	CD	\N	t	\N
28	Elisabeta Smolenic	elisabetat@eed.usv.ro	CD	\N	t	\N
29	Alexandru Siean	alexandru.siean@usm.ro	CD	\N	t	\N
30	Cristian Andy Tanase	andy.tanase@usm.ro	CD	\N	t	\N
31	Simona-Anda Tcaciuc	tcaciuc.anda@eed.usv.ro	CD	\N	t	\N
32	Mihail Terenti	mihail.terenti@usm.ro	CD	\N	t	\N
33	Cristina Elena Turcu	cristina@eed.usv.ro	CD	\N	t	\N
34	Ioan Ungurean	ioanu@eed.usv.ro	CD	\N	t	\N
35	Radu Vatavu	vatavu@eed.usv.ro	CD	\N	t	\N
36	Elisabeta Zagan	elisabeta.zagan@usm.ro	CD	\N	t	\N
37	Ionel Zagan	zagan@eed.usv.ro	CD	\N	t	\N
38	Sebastian Avatamanitei	sebastian.avatamanitei@usm.ro	CD	\N	t	\N
39	Alexandra Ligia Balan	alexandra@eed.usv.ro	CD	\N	t	\N
40	Doru Gabriel Balan	dorub@usv.ro	CD	\N	t	\N
41	Catalin Beguni	catalin.beguni@usm.ro	CD	\N	t	\N
42	Ciprian Bejenar	ciprian.bejenar@usm.ro	CD	\N	t	\N
43	Dana Betenchi	dana.betenchi@usm.ro	CD	\N	t	\N
44	Corneliu Buzduga	cbuzduga@usm.ro	CD	\N	t	\N
45	Alin-Mihai Cailean	alinc@eed.usv.ro	CD	\N	t	\N
46	Aurel Chirap	aurel@eed.usv.ro	CD	\N	t	\N
47	Iuliana Chiuchisan	iulia@eed.usv.ro	CD	\N	t	\N
48	Iulian Chiuchisan	iulian.chiuchisan@usm.ro	CD	\N	t	\N
49	Elena-Eugenia Ciobanu	neli.ciobanu@eed.usv.ro	CD	\N	t	\N
50	Viorela Gabriela Ciobanu	gabriela.ciobanu@usm.ro	CD	\N	t	\N
51	Calin Ciufudean	calin@eed.usv.ro	CD	\N	t	\N
52	Eugen Coca	ecoca@eed.usv.ro	CD	\N	t	\N
53	Lucian Cosovanu	lucian.cosovanu@usm.ro	CD	\N	t	\N
54	Ana Maria Cozgarea	amcozgarea@usm.ro	CD	\N	t	\N
55	Elena Curelaru	elena@eed.usv.ro	CD	\N	t	\N
56	Andrei Diaconu	andrei.diaconu@usm.ro	CD	\N	t	\N
57	Mihai Dimian	dimian@eed.usv.ro	CD	\N	t	\N
58	Radu Fechet	radu.fechet@usm.ro	CD	\N	t	\N
59	Constantin Filote	filote@eed.usv.ro	CD	\N	t	\N
60	Oana Geman	oana.geman@usm.ro	CD	\N	t	\N
61	Adrian Graur	adriang@eed.usv.ro	CD	\N	t	\N
62	Oana Vasilica Grosu	vasilica.grosu@usm.ro	CD	\N	t	\N
63	Simona-Raluca Iacoban	simona_colibaba@yahoo.com	CD	\N	t	\N
64	Alexandru Lavric	lavric@usm.ro	CD	\N	t	\N
65	Liliana Luca	liliana.luca@usm.ro	CD	\N	t	\N
66	Alexandru Maftei	alexandru.maftei@usm.ro	CD	\N	t	\N
67	George Mahalu	george.mahalu@usm.ro	CD	\N	t	\N
68	Doru Movileanu	doru.movileanu@usm.ro	CD	\N	t	\N
69	Partemie Marian Mutescu	marian.mutescu@usm.ro	CD	\N	t	\N
70	Vasyl Mykhailovych	vasyl.mykhailovych@usm.ro	CD	\N	t	\N
71	Aurelia Pascut	aurelia@usm.ro	CD	\N	t	\N
72	Adrian-Ioan Petrariu	apetrariu@eed.usv.ro	CD	\N	t	\N
73	Sorin Pohoata	sorinp@eed.usv.ro	CD	\N	t	\N
74	Valentin Popa	valentin@eed.usv.ro	CD	\N	t	\N
75	Alin Dan Potorac	alinp@eed.usv.ro	CD	\N	t	\N
76	Marius Prelipceanu	marius.prelipceanu@usm.ro	CD	\N	t	\N
77	Remus Prodan	remus.prodan@usm.ro	CD	\N	t	\N
78	Aurelian Rotaru	rotaru@eed.usv.ro	CD	\N	t	\N
79	Bianca Satco	bisatco@eed.usv.ro	CD	\N	t	\N
80	Floarea Nicoleta Sofian Boca	nicolesof@yahoo.com	CD	\N	t	\N
81	Ion Soroceanu	ion.soroceanu@usm.ro	CD	\N	t	\N
82	Iuliana Soldanescu	iuliana.soldanescu@student.usv.ro	CD	\N	t	\N
83	Ioana-Alexandra Somitca	ioana.somitca@gmail.com	CD	\N	t	\N
84	Claudia Tighiceanu	claudia.tighiceanu@usm.ro	CD	\N	t	\N
85	Roxana Toderean	roxana.toderean@usm.ro	CD	\N	t	\N
86	Corneliu Octavian Turcu	cturcu@eed.usv.ro	CD	\N	t	\N
87	Dragos Ionut Vicoveanu	dragos.vicoveanu@usm.ro	CD	\N	t	\N
88	Eduard Zadobrischi	eduard.zadobrischi@usm.ro	CD	\N	t	\N
89	Ciprian Afanasov	aciprian@eed.usv.ro	CD	\N	t	\N
90	Pavel Atanasoae	atanasoae@eed.usv.ro	CD	\N	t	\N
91	Neculai Barba	barba@eed.usv.ro	CD	\N	t	\N
92	Crenguta Elena Bobric	crengutab@eed.usv.ro	CD	\N	t	\N
93	Daniel Georgescu	daniel.georgescu@usm.ro	CD	\N	t	\N
94	Dorin Gradinaru	gradinaru@fim.usv.ro	CD	\N	t	\N
95	Eugen Hopulele	eugenh@eed.usv.ro	CD	\N	t	\N
96	Daniela Irimia	daniela@eed.usv.ro	CD	\N	t	\N
97	Elena-Daniela Lupu	elena.lupu@usm.ro	CD	\N	t	\N
98	Dan Laurentiu Milici	dam@eed.usv.ro	CD	\N	t	\N
99	Mariana Rodica Milici	mami@eed.usv.ro	CD	\N	t	\N
100	Ilie Nitan	ilie.nitan@usm.ro	CD	\N	t	\N
101	Mihaela Paval	mpoienar@usm.ro	CD	\N	t	\N
102	Radu Dumitru Pentiuc	radup@eed.usv.ro	CD	\N	t	\N
103	Cezar Dumitru Popa	cezardumitrup@gmail.com	CD	\N	t	\N
104	Cristina Prodan	cristinap@eed.usv.ro	CD	\N	t	\N
105	Gabriela Rata	gabrielar@eed.usv.ro	CD	\N	t	\N
106	Mihai Rata	mihair@eed.usv.ro	CD	\N	t	\N
107	Constantin Ungureanu	costel@eed.usv.ro	CD	\N	t	\N
108	Valentin Vlad	vladv@eed.usv.ro	CD	\N	t	\N
\.


--
-- TOC entry 4846 (class 0 OID 0)
-- Dependencies: 218
-- Name: disciplines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.disciplines_id_seq', 1, false);


--
-- TOC entry 4847 (class 0 OID 0)
-- Dependencies: 224
-- Name: exams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exams_id_seq', 1, false);


--
-- TOC entry 4848 (class 0 OID 0)
-- Dependencies: 220
-- Name: rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rooms_id_seq', 1, false);


--
-- TOC entry 4849 (class 0 OID 0)
-- Dependencies: 222
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- TOC entry 4665 (class 2606 OID 24581)
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- TOC entry 4667 (class 2606 OID 24588)
-- Name: disciplines disciplines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disciplines
    ADD CONSTRAINT disciplines_pkey PRIMARY KEY (id);


--
-- TOC entry 4677 (class 2606 OID 24617)
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (id);


--
-- TOC entry 4671 (class 2606 OID 24596)
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- TOC entry 4675 (class 2606 OID 24606)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4668 (class 1259 OID 24589)
-- Name: ix_disciplines_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_disciplines_id ON public.disciplines USING btree (id);


--
-- TOC entry 4678 (class 1259 OID 24638)
-- Name: ix_exams_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_exams_id ON public.exams USING btree (id);


--
-- TOC entry 4669 (class 1259 OID 24597)
-- Name: ix_rooms_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_rooms_id ON public.rooms USING btree (id);


--
-- TOC entry 4672 (class 1259 OID 24607)
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- TOC entry 4673 (class 1259 OID 24608)
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- TOC entry 4679 (class 2606 OID 24618)
-- Name: exams exams_discipline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_discipline_id_fkey FOREIGN KEY (discipline_id) REFERENCES public.disciplines(id) ON DELETE CASCADE;


--
-- TOC entry 4680 (class 2606 OID 24623)
-- Name: exams exams_proposed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_proposed_by_fkey FOREIGN KEY (proposed_by) REFERENCES public.users(id);


--
-- TOC entry 4681 (class 2606 OID 24628)
-- Name: exams exams_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- TOC entry 4682 (class 2606 OID 24633)
-- Name: exams exams_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.users(id);


-- Completed on 2025-06-09 01:02:57

--
-- PostgreSQL database dump complete
--

