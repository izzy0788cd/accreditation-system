--
-- PostgreSQL database dump
--


-- Dumped from database version 18.4 (Debian 18.4-1.pgdg13+1)
-- Dumped by pg_dump version 18.4 (Debian 18.4-1.pgdg13+1)

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
-- Data for Name: __EFMigrationsHistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."__EFMigrationsHistory" ("MigrationId", "ProductVersion") FROM stdin;
20260806002155_Initial	10.0.10
20260806025748_functionComponentModelsEdits	10.0.10
20260806035456_standardSummary	10.0.10
20260806110318_AddDefaultValueToCriterionIsApplicable	10.0.10
20260806110458_updateDbContext	10.0.10
20260806235232_AddDefaultValueForIsApplicableComplianceEvidence	10.0.10
20260807035739_AddComponentNumberToModel	10.0.10
20260807042713_AddFunctionNumberToModel	10.0.10
20260807044909_AddStandardNumberToModel	10.0.10
20260807051411_ChangedComponentNumberIntToString	10.0.10
20260807051833_EnforceUniqueStringOnComponentFunctionStandardModels	10.0.10
20260807053830_AddCriterionNumberToModelAndEnforceUnique	10.0.10
20260807054923_AddComplianceNumbertoModelAndEnforeUnique	10.0.10
20260807055623_AddEvidenceNumberToModel	10.0.10
20260809225330_RemovedMaxLengthOnComponentModelSummary	10.0.10
20260810052956_UpdateMaxLengthofSummaryForModels	10.0.10
20260811010155_CorrectSpellingMistakeWithFunctionModel	10.0.10
20260811060909_MakeComplianceCriterionNumberUnique	10.0.10
20260812231446_EvidenceSumaaryChangeToSummary	10.0.10
20260820053902_UpdateDeleteBehaviours	10.0.10
20260827023357_AddAllRemainingDataModels	10.0.10
20260827113712_ChangeLevelNumberStringToInteger	10.0.10
20260828040144_FixedSpellingMistakeOnCreditationStat	10.0.10
20260901003135_ChangeDbContextFacilityLevelsNaming+UserSurveyorsFK	10.0.10
20260904112609_ChangedScoreValueFromStringToInt	10.0.10
20260907234914_MakeScoreAndRiskRatingNullableOnComplianceAssessment	10.0.10
20260908105831_AddRefreshTokens	10.0.10
20260909044156_AddSurveyStandardAssignments	10.0.10
20260909055727_NormalizeNotApplicableScores	10.0.10
20260910042445_AddSurveyCancellation	10.0.10
20260910120146_SeedSurveyAccessRoles	10.0.10
20260911033702_AddSurveyReportVersions	10.0.10
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories ("categoryId", "categoryName", description) FROM stdin;
1	Public	government run
2	Private	private hospitals, clinics, medical facilities, etc.
\.


--
-- Data for Name: components; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.components ("componentId", "componentName", "componentSummary", "componentNumber") FROM stdin;
1	Leadership & Governance	The Health Service Organization is effectively and efficiently lead, governed and managed, in accordance with with goals and values to ensure quality of care.	1
2	Human Resource	Ensures the Health Service Organization has the right workforce capabilities and supports continuous staff development through effective HR management, education, training, professional development, career planning, and performance improvement.	2
3	Information Technology (ICT)	The Health Service Organization continuously improves patient safety and quality of care through the effective delivery of Information and Communication Technology (ICT).	3
4	Environment	The Health Service Organization ensure that their physical environment, facilities, and operations are safe, well-maintained, and sustainable GÇö through sound infrastructure planning and fire safety, effective management of plant, equipment, and utilities, robust infection prevention and control practices, and safe, compliant handling and disposal of healthcare waste GÇö so as to protect the health, safety, and wellbeing of patients, staff, and the surrounding community.	4
5	Public Health	The Health Service Organization ensures that public health interventions are evidence-based, effectively delivered, and integrated with clinical and primary health care GÇö through assessing, investigating, and communicating population health status and risks, promoting community health via education and disease prevention programs, and maintaining safe environmental health conditions in the community and healthcare facility GÇö to protect the health and wellbeing of all people across the province.	5
6	Essential Clinical Care	The Health Service Organization ensure consumers/patients receive appropriate, effective, evidence-based clinical care GÇö through prioritized access, assessment, care planning, and informed consent; continuity of care from admission to discharge, including safe management of emergencies; effective medication management; rigorous surgical safety practices; and safe blood product administration GÇö protecting patient health, safety, and wellbeing.	6
\.


--
-- Data for Name: functions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.functions ("functionId", "functionTitle", "functionSummary", "functionNumber") FROM stdin;
2	Quality and Safety in Integrated Health Service Delivery	The Health Service Organization have planning systems which specifically aim to improve the health status of their given population while safeguarding equity and fairness of access as well as responsiveness of the health system to the perceived needs of their community and focuses on what should be done to achieve the direction specified by the National Health Plan (NHP) and National Health Service Standards (NHSS) 2021 - 2030.	2
3	Essential Public Health Services	The Health Service Organization promotes the adoption and integration of evidence-based practices, interventions and policies into routine health care and public health settings. Public Health Managers assess evidence for population- and community-based public health interventions and monitor the effectiveness. Public health interventions are intended to promote or protect health or prevent ill health in communities or\npopulations. They are distinguished from clinical interventions, which are intended to prevent or treat illness in individuals. \nEvidence-based practice involves making decisions on the basis of the best available scientific evidence, using data and information systems systematically, applying program-planning frameworks, engaging the community in decision making, conducting sound evaluation, and disseminating what is learned. This definition can also be applied to evidence-based public health.	3
4	Essential Clinical Care	The Health Service Organization shall ensure consumers/patients receive appropriate, necessary and effective care, interventions and services in the most suitable setting. Appropriateness means providing the right treatment, intervention or service in the right way while avoiding unnecessary care. Effectiveness is the extent to which care achieves intended outcomes and meets consumer/patient needs. Care and interventions shall be based on current best available evidence and evaluated for appropriateness, effectiveness and outcomes at both individual and organizational levels. The Organization shall use findings to support continuous improvement.	4
1	Organizational Governance & Health Systems Strengthening.	The Health Service Organization have formal governance structures, leadership and delegation practices implemented, together with organizational strategic and operational plans, necessary for healthcare, to support and drive organizational commitment to improving health services delivery performance and the management of corporate and clinical public health risk and to successfully manage and support a skilled and competent health workforce.	1
\.


--
-- Data for Name: standards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.standards ("standardId", "standardTitle", "functionId", "componentId", "standardSummary", "standardNumber") FROM stdin;
2	Clinical & Public Health Governance Systems & Safety **MANDATORY STANDARD**	1	1	All Healthcare Organisations and their Management are committed to the delivery of safe quality health services and do this through strong governance, committed partnerships and effective oversight supported by Public Health & Clinical Governance Framework and implementation of Clinical Governances systems and processes.	3
6	Physical infrastructure, environment management and safety protocols	1	4	The infrastructure for a Healthcare Organisation is developed based on population, disease burden and geography.  Environmental Management Standards are implemented to support the safety and maintenance of buildings and the surrounding areas; including walkways, plant and other equipment, medical devices, the management of its supplies and consumables, utilities including electricity and water, and workplace design, signage and fire safety\nThe organisationGÇÖs management of its assets, goods and general services is an aspect of its responsibility to ensure the safety of consumers / patients and guardians, staff, contractors and other visitors and to manage risk.	7
1	Governance, Leadership & Management including Systems & Safety	1	1	The Health Service Organization has formal governance structures; strategic and operational plans, is committed to improving health services delivery performance, the management of corporate and clinical public health risk and managing a skilled and competent workforce.	1
3	Health workforce capacity and performance	1	2	All the Healthcare Organisation has aligned staff capability to the strategic business needs of the organization and helps all health staff to build their individual capacity and overall performance, through a range of human resource (HR) functions including job design, recruitment and selection, performance management and development, ongoing career and succession planning.	4
4	Health workforce training, upskilling and ongoing professional development	1	2	All Healthcare Organisations provide a wide range of practical, innovative, and evidence-informed education, training, upskilling and continuous professional development for all health staff (clinical and non-clinical), through activities and resources designed to support ongoing individual and organisational capacity and capability enhancements.	5
5	Medical supplies procurement and supply chain management	1	4	The Healthcare Organisation ensures drugs and medical supplies are available in the GÇÿright quantity, quality and right priceGÇÖ in all health facilities consistent with the level of care and services provided by that facility. All health facilities are to ensure that drugs and medical supplies in general, are adequately stored in conditions that maintain the quality (efficacy) of the products as recommended by the manufacturers of the products, and that any out-of-date stock are dealt with appropriately.	6
7	Financial management	1	1	The Health Service Organisation at all levels of the Papua New Guinea health system strengthen their financial mechanisms and processes by which they access and utilise public resources from pools at national, provincial and district levels. There will need to improve accountability for the delivery of health services across all levels of health services.	8
8	Health information and information communication technology (ICT)	1	3	All Healthcare Organisations continuously improve patient safety and quality of care through the effective delivery of Information and Communications Technology.	9
9	Population health, health services planning and project management	2	1	The Healthcare Organisation have planning systems which specifically aim to improve the health status of their given population while safeguarding equity, fairness of access and responsiveness of the health system to the perceived needs of their community aligning to the NHP and NHSS 2021-2030.	10
10	Partnerships and collaboration	2	1	The Health Service Organisation deliver health services through effective collaboration with partners.	11
11	Universal health care	2	1	All Health Service Organisations (HSOs) develops services that are responsive to need and available to all based on the principles of universal health coverage (UHC); that all people can use the promotive, preventive, curative, rehabilitative and palliative health services they need and of sufficient quality to be effective.	12
13	Formalised patient referral pathways	2	1	All Healthcare Organisations should comply with the patient referral discipline, refer appropriately and safely, and follow the agreed Patient Referral Guideline. The Patient Referral Guideline is about making timely referrals based on clinical assessment, communication between different levels of care, prior approval to transfer, and supporting a patientGÇÖs acute and ongoing care management, discharge and follow-up care.	14
14	Supportive supervision	2	1	All Healthcare Organisations advocate for Provincial and District Hospital Department Heads and District Health Managers-Coordinators, as well as working with the Public Health team, to manage, implement, monitor & report results of an integrated supervision approach that reflects continuous quality improvement.\nThe Provincial and District Department Heads as well as District Health Managers, monitor the performance report of each urban and/or rural health facility, district and hospital division/department at Quarterly Review Meetings;\nA Hospital and Urban-Rural Health Service Supervision Checklist and Performance Framework is utilised.	15
12	Improving preparedness for disease outbreaks including pandemics and other population threats (**MANDATORY STANDARD**)	2	1	The Health Facility should have the capacity to conduct disease outbreak surveillance of any emerging population health threats, including pandemics, and to share information quickly to stop the spread of the disease. A disaster preparedness plan is also essential to manage external and internal disasters.	13
16	Waste Management (**MANDATORY STANDARD**)	2	4	The Health Facility has a hospital/healthcare facility waste management plan that complies to national and local policies	17
17	Essentials Public Health Services	3	5	The Healthcare Organisation promotes the integration of evidence-based practices, interventions and policies into routine health care and public health settings. Public health interventions are intended to promote or protect health or prevent ill health in communities or populations. They are distinguished from clinical interventions, which are intended to prevent or treat illness in individuals.\nDecisions are made using data and information systems systematically, applying program-planning frameworks, engaging the community in decision making, conducting sound evaluation, and disseminating what is learned.	18, 19, 20
15	Infection and prevention control (**MANDATORY STANDARD**)	2	4	The Healthcare Organisation should implement, monitor and report based on the National IPC guidelines and ensure strong, effective province-wide IPC programs with the ability to influence the quality of care, improve patient safety and protect all those providing care in the health system while keeping communities safe. Effective IPC practices are a key strategy for dealing with public health threats and a contributor to ensure safe, effective high-quality health service delivery, particularly those related to water, sanitation and hygiene (WASH) and quality and universal health coverage (UHC).	16
18	Environmental Health Standards	3	5	The Health Service Organization improves environmental health services delivered in catchment communities and implement environment health standards in health care.	21
19	Nursing Services Standards	4	6	The Nursing Services shall be delivered by capable, effective, competent, skillful, and highly knowledgeable nurses who will be able to provide Patient Centric Care which includes promotive, preventive, curative and rehabilitative services. Nurses care for the whole person; physically, mentally, emotionally, and spiritually. While caring for an individual, the nurse also cares for the family. Nurses provide care with respect and dignity for patients and their families. The Nursing Services shall be organized, directed and coordinated with the other services in the Facility to provide nursing care in a safe, efficient, effective and caring manner.\nEffective nursing governance structures, leadership frameworks, and delegation practices are implemented in accordance with organizational strategic and operational objectives. These mechanisms promote continuous improvement in health service delivery, enhance corporate, clinical, and public health risk management, and support the recruitment, development, and retention of a skilled, competent, and sustainable workforce.	22
20	Internal Medicine	4	6	**STANDARD 23: PROVISION OF AND CONTINUITY OF CARE (MANDATORY STANDARD)**\nThe Healthcare Organisation ensures patients are provided with safe, high- quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.\nThe Healthcare Organization should implement evidence-based practice and a have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.	23a
\.


--
-- Data for Name: criteria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.criteria ("criterionId", "criterionTitle", "standardId", "isApplicable", "criterionNumber") FROM stdin;
35	Storage conditions and practices do not adversely impact the quality and efficacy of drugs & stored medical supplies	5	t	6.3
36	Methodical stock management to ensure a stock balance where there is no under- stocking or over- stocking	5	t	6.4
37	Product expiry management	5	t	6.5
38	Medical supply chain management	5	t	6.6
39	Annual procurement planning	5	t	6.7
40	Distribution planning	5	t	6.8
41	Purchase order management	5	t	6.9
42	Timely payments to suppliers	5	t	6.10
43	Warehousing	5	t	6.11
44	Efficient receiving of goods	5	t	6.12
45	Effective and efficient picking and packing operation	5	t	6.13
46	Planning, design and safety	6	t	7.1
47	Fire safety (mandatory standard)	6	t	7.2
48	Plant, equipment, medical devices, supplies and consumables	6	t	7.3
49	Medical devices, supplies and consumables	6	t	7.4
50	Preventive maintenance and cleaning	6	t	7.5
51	Safety management	6	t	7.6
52	Asset management	6	t	7.7
53	Security	6	t	7.8
54	Use of utilities	6	t	7.9
4	Management	1	t	1.4
5	Development Plans	1	t	1.5
7	Organizational Structure	1	t	1.6
8	By-laws, Policies, Guidelines & Procedures	1	t	1.7
9	Rights & Responsibilities of Patients	1	t	1.8
10	Ethics	1	t	1.9
11	Research	1	t	1.10
55	Policies and guidelines	7	t	8.1
56	The chief executive officer (CEO) and the governing board ensure compliance with the enforcement of national public financial management (PFM) legislation and guidelines	7	t	8.2
57	PHA board, chief executive officer and senior executive managers accountability mechanisms	7	t	8.3
58	Health financing management plan (supported by legislation, policies and internal control measures)	7	t	8.4
59	Budget & financial management (day to day procedures)	7	t	8.5
60	Budget & financial management audit reporting	7	t	8.6
61	Education GÇô continuous professional development	7	t	8.7
62	ICT and information management	8	t	9.1
63	Records and knowledge management	8	t	9.2
64	Governance and leadership	8	t	9.3
65	Hospital patient electronic health record system	8	t	9.4
66	E-health and telehealth	8	t	9.5
67	Stabilising infrastructure and systems	8	t	9.6
68	Information sharing and management	8	t	9.7
12	Clinical & Public Health Governance Framework, Systems & Processes	2	t	3.1
13	Code of Conduct	2	t	3.2
14	Quality Management	2	t	3.3
3	Leadership by the Chief Executive Officer & Senior Executive Management Team	1	t	1.3
69	Capacity and capability	8	t	9.8
70	Health service planning	9	t	10.1
71	Population health GÇô public health planning	9	t	10.2
72	Clinical services planning	9	t	10.3
73	Project management in healthcare	9	t	10.4
74	There is a functioning partnership committee	10	t	11.1
75	There are agreements in place with selected partners to ensure quality health service delivery in the province	10	t	11.2
2	Chief Executive Officer (CEO) & Senior Managers	1	t	1.2
76	Development of responsive health services	11	t	12.1
77	Strengthened primary health care	11	t	12.2
78	Improved quality and access to health services	11	t	12.3
79	Responsive planning to outbreaks	12	t	13.1
80	Emergency and disaster management for environmental management	12	t	13.2
81	Health worker education	12	t	13.3
82	Strengthen the patient referral system at all levels of care	13	t	14.1
1	Board of Governance	1	t	1.1
15	System Competence	2	t	3.4
16	Critical Risk Management	2	t	3.6
17	Clinical Audits and Mortality Review	2	t	3.7
18	Clinical Practice Guidelines and Clinical Supervision	2	t	3.8
19	Patient Complaint Management System	2	t	3.9
20	Clinical Public Health Governance Performance	2	t	3.10
21	Licensing and Credentialing	2	t	3.5
22	Health workforce governance	3	t	4.1
23	Health workforce planning and development	3	t	4.2
24	Health workforce skills mix	3	t	4.3
25	Health workforce risks management	3	t	4.4
26	Health workforce occupational health, safety and security	3	t	4.5
27	Health workforce performance management	3	t	4.6
28	Health workforce career and succession plans	3	t	4.7
29	Training and development analysis and planning	4	t	5.1
30	Health workforce training, upskilling and continuos professional development	4	t	5.2
31	Training and curriculums and regular reviews	4	t	5.3
32	Training and development stakeholders	4	t	5.4
33	Requisitions for stock replenishment are based on accurate demand quantification	5	t	6.1
34	Supply planning is undertaken to facilitate quantified demand	5	t	6.2
83	Effective coordination and communication mechanisms	13	t	14.2
84	Initiating health facility	13	t	14.3
85	Appropriateness of referral	13	t	14.4
86	Patient referral documentation and records	13	t	14.5
87	Receiving health facility	13	t	14.6
88	Discharge planning	13	t	14.7
89	Patient education and community awareness	13	t	14.8
90	Patient transport services	13	t	14.9
91	Continuous quality improvement	13	t	14.10
92	Provincial and district hospital dept managers and district health managers for urban and rural health services in partnership with public health program managers and officers undertake supervision visits and report results	14	t	15.1
93	Use of hospital integrated supervision checklist and urban-rural health services supervision checklist	14	t	15.2
94	PHA manager accountabilities	14	t	15.3
95	Supervision performance and reporting	14	t	15.4
96	IPC policy and guidelines are available and implemented at all levels of the healthcare system including the community.	15	t	16.1
97	Infection Prevention and Control (IPC) Program	15	t	16.2
98	Environmental Cleaning	15	t	16.3
99	Healthcare Waste Management Plan	16	t	17.1
100	Waste and Environmental Management	16	t	17.2
101	Education on waste management	16	t	17.3
102	Organization and management	17	t	18.1
103	Human resources and development	17	t	18.2
104	Policies and Procedures	17	t	18.3
105	Integrated public health services	17	t	18.4
106	Comprehensive information, health promotion and disease prevention	17	t	18.5
107	Investigate, diagnose, and address health problems and hazards affecting the population	17	t	18.6
108	Environment Health Workforce	18	t	21.1
109	Environmental Health Laws and Regulations	18	t	21.2
110	Environmental Health Programmes	18	t	21.3
111	Technology for Data Collection, Storage and Analysis	18	t	21.4
112	Community Education on Environmental Health Issues	18	t	21.5
113	Community Partnerships	18	t	21.6
114	Safe Drinking Water	18	t	21.7
115	Excreta Disposal	18	t	21.8
116	Wastewater Disposal	18	t	21.9
117	Laundry Management	18	t	21.10
118	Food Safety	18	t	21.11
119	Controls of Vector-borne Disease	18	t	21.12
120	Nursing Services Organization and Management	19	t	22.1
121	Nursing services human resource development and management	19	t	22.2
122	Nursing services policies and procredures	19	t	22.3
123	Facilities and medical equipment	19	t	22.4
124	Risk management	19	t	22.5
125	Safety and performance improvement activities	19	t	22.6
126	Organization and Management	20	t	23a.1
127	Human Resources and Development	20	t	23a.2
128	Policies and Procedures	20	t	23a.3
129	Facilities and Equipment	20	t	23a.4
130	Safety and Performance Improvement Activities	20	t	23a.5
\.


--
-- Data for Name: compliances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compliances ("complianceId", "complianceSummary", "criterionId", "isApplicable", "complianceNumber") FROM stdin;
20	The CEO reviews the performance of other Directors (non-Corporate) and other senior managers at least annually.	3	t	1.3.6
19	The CEO and the Director Corporate Services, ensures there is the highest level of Corporate Services available. There are Board approved policies and procedures for the following;\na.)\tAssets recording, management and reporting\nb.)\tComplaints handling\nc.)\tCorporate risks management and reporting\nd.)\tDelegations of Authority\ne.)\tDiscipline and Disciplinary Process\nf.)\tDiversity, Gender and Social Obligations\ng.)\tEthical Behaviour of all staff\nh.)\tFraud and Fraud Control\ni.)\tFinancial internal controls & segregation of duties\nj.)\tFinancial management, including transactions and reporting\nk.)\tGovernance arrangements (organisational structures, delegations and reporting lines)\nl.)\tHuman resources management & development\nm.)\tInformation technology management\nn.)\tMedia and public relations management\no.)\tOccupational health, safety and security\np.)\tPerformance appraisals and performance management\nq.)\tStakeholder relations and management\nr.)\tTendering, contracts and procurements\n	3	t	1.3.5
21	The CEO ensures proper Health Planning and Quality Systems are developed for the province and updated periodically. This includes the following:\na.)\t5- year Strategic Health Services Development Plan, \nb.)\t5-year Corporate Plan:\nc.)\t5-year Health Infrastructure Plan\nd.)\t5-year Health Procurements & Medical Supply Chain Plan\ne.)\t5-year Health Workforce Plan\nf.)\t5-year Staff Training & Development \ng.)\tPlan\nh.)\t5-year Information & ICT Networks Plan\ni.)\t5-year Assets & Equipment Plan that includes: Maintenance Plan and Transport and Logistics Plan\nj.)\t5-year Emergencies & Disaster Recovery Plan\nk.)\t5-year District Health Plans (for each individual District) \n	3	t	1.3.7
22	The CEO requires that all health facilities have developed an Annual Implementation Plan (AIP) which is aligned with both the organisationGÇÖs 5-year Strategic Plan and Corporate Plan.	3	t	1.3.8
23	The CEO establishes high-level collaboration relationships to represent Health in the Province. This would include working relationships with;\na.)\tProvincial Governor and GovernorGÇÖs staff\nb.)\tProvincial Administrator and AdministratorGÇÖs staff\nc.)\tMinister for Health and Ministerial staff\nd.)\tSecretary of Health and staff of NDoH\ne.)\tDistrict Administrators, DDAs, and District Health staff.\n	3	t	1.3.9
24	The CEO maintains effective partnership coordination for health services with signing of Memorandum of Agreement (MoA) or Service Level Agreement (SLA) with Christian Health Services and Catholic Health Services, other corporates, NGOs and international Health Partners.	3	t	1.3.10
12	The Board of Governance delegates necessary authority to the Organizations' CEO, Executive Directors, Senior and Middle Managers and other relevant staff, to act in accordance with all legislation, corporate policies, health priorities and delegated authority.	2	t	1.2.1
13	The Board of Governance shall recommend an acting appointment for the Organizations' CEO when required.	2	t	1.2.2
14	The governing body reviews the CEOGÇÖs performance at least annually.	2	t	1.2.3
25	The CEO maintains participation of all communities around health facilities within the province.	3	t	1.3.11
26	The CEO ensures that health infrastructure and capital projects are effectively coordinated through a GÇ£Projects UnitGÇ¥ to oversee the development, funding and implementation of all Health Infrastructure and Capital Projects.	3	t	1.3.12
15	The CEO ensures a Senior Executive Management Team (SEMT) is appointed to manage the delivery of high-quality health services within the province in accordance with corporate policies relevant to applicable legislation, health policies and health Priorities.	3	t	1.3.1
16	The CEO and SEMT undertake annual review of own performance through 360-degree feedback via a management and staff survey.	3	t	1.3.2
17	The Organisation establishes a Clinical and Public Health Governance Framework to support effective implementation of the National Health Service Standards (NHSS).	3	t	1.3.3
18	The CEO, Director Curative Health Services and the Director Public Health are collectively responsible to ensure all health services and public health programmes are planned, monitored and reported on effectively.	3	t	1.3.4
27	The CEO has an approved GÇ£Corporate Risks Management PlanGÇ¥ linked to the 5yr strategic health services development plan, to ensure a framework for the management of risks at all levels of the organisation (i.e.: strategic, programme /projects, and single issues).	3	t	1.3.13
28	There are weekly meetings between Management and staff to discuss work activities planning, AIP implementation, service issues / challenges, safety and quality, etc.	4	t	1.4.1
29	An organisational Health Human Resources (HHR) Unit and Health Workforce Plan is established and functioning effectively every year.	4	t	1.4.2
30	A Health Training Resources Unit (HTRU) and Health Workforce Training Plan is established and functioning effectively within the organisation, every year.	4	t	1.4.3
31	An organisational Assets and Equipment Policy and 5-year Plan is developed, budgeted for, implemented and effectively managed every year.	4	t	1.4.4
32	An organisational Fleet Management Policy, and 5-year Plan is developed, budgeted for, implemented and the transport fleet effectively managed every year.	4	t	1.4.5
33	An organisational Facility Management Program and 5-year Plan is developed, budgeted for, implemented and all maintenance of every health facility effectively managed, each year.	4	t	1.4.6
34	An organisational ICT Services & Network Policy and 5-year Plan is developed, budgeted for, and effectively managed to ensure reliable and consistent support services to all health facilities within the province, each year.	4	t	1.4.7
35	Power, clean water supply and sanitation are made available to all PHA facilities every year.	4	t	1.4.8
36	The organisationGÇÖs mission statement and goals are used to direct activities of the health service.	5	t	1.5.1
37	The organisationGÇÖs Corporate Plan is produced in consultation with and made known to staff, the community, other relevant health service providers and other stakeholders.	5	t	1.5.2
38	The organisationGÇÖs individual health services or hospital departments show evidence of planning and implementation of activities consistent with the Corporate Plan.	5	t	1.5.3
39	The organisationGÇÖs Corporate Plan is implemented and revised as necessary. The achievement of the plan is monitored and action taken to address improvements required.	5	t	1.5.4
40	Established lines of responsibility, authority and communication support leadership, teamwork and the organisation through an integration of services.	7	t	1.6.1
41	The organisation structure is reviewed at least every three years or when there is a significant change, such as alteration of the role of the health service or its services.	7	t	1.6.2
42	The organisationGÇÖs by-laws and the policies and procedures are consistent with the organisationGÇÖs goals, accepted standards, statutory requirements and responsibilities.	8	t	1.7.1
43	Compliance with the organisation policies and procedures occurs throughout the organisational health service.	8	t	1.7.2
44	All organisational policies and procedures are reviewed and revised as necessary.	8	t	1.7.3
45	The Organisation has an approved framework for the development, implementation and ongoing monitoring and evaluation (M&E) of all its health program and projects.	8	t	1.7.4
46	Rights and responsibilities of patients are clearly addressed through policies set by the Board of Governance and there are protocols to deal with matters of complaint.	9	t	1.8.1
47	Respect for patients/clients is evident throughout the healthcare organisation.	9	t	1.8.2
48	The Board of Governance ensures that there is a mechanism for considering ethical issues by an appropriate ethics committee.	10	t	1.9.1
49	Research projects are reviewed, approved and conducted within approved research guidelines by the appropriate ethics committee.	11	t	1.10.1
55	There is compliance with the NHSS at all organisational levels. These include privacy, confidentiality, health records and information management, standards for delivery of health services and compliance with quality standards.	15	t	3.4.1
56	All hospital staff are fully aware and comply to: The Papua New Guinea Medical Board for the registration and discipline of medical practitioners, dental practitioners and allied health workers; and The Papua New Guinea Nursing Council for the registration and discipline of nurses and nurse aides, and for related purposes; when required the PHA Board/CEO reports to the relevant Board to take disciplinary action of a healthcare professional. All Health Workers have approved clinical practice (job scope) based on their competences, performance and professional suitability. There are formal credentialing processes in place that delineates the clinical privileges of medical professionals at the time of appointment/re-appointment and privileges are regularly reviewed with the aid of their peers through the Credentials Committee structure.	21	t	3.5.1
108	Department/Unit Managers/OICs and team ensure all rubbish, flammable materials are safely stored, safely handled and safely practiced.	47	t	7.2.7
2	Newly appointed members of the Board of Governance for the Organization are given a formal orientation. It will include the provision of acts, bylaws and at least a tour of selected health services and introduction to key staff.	1	t	1.1.2
3	Members of the Board of Governance participate in ongoing education to assist them fulfil their role.	1	t	1.1.3
4	The Board of Governance has established their organization's Vision, Mission, Goals, & Objectives to specify and guide the delivery of health services.	1	t	1.1.4
5	The Board of Governance has overall responsibility for the organization's achievements, the quality of healthcare and the organization's resources.	1	t	1.1.5
6	The Board of Governance ensures that there are effective working relations;\nGÇó\twithin all the organisationGÇÖs health services\nGÇó\twith surrounding communities\nGÇó\twith relevant health care providers\nGÇó\twith health partners\nGÇó\tand with other stakeholders	1	t	1.1.6
7	The Board of Governance meets regularly, at least 4 times per year, & makes decisions to ensure arrangements for continuity of governance between meetings.	1	t	1.1.7
8	The Board of Governance has established Committees & Sub-Committees as per their relevance, functions and responsibility in accordance with by-laws, with evidence that such Committees and sub-committees are active.	1	t	1.1.8
1	The members of the Board of Governance and its officers have been duly appointed according to current legislative requirements.	1	t	1.1.1
50	The Board of Governance is held accountable to patients and the community for assuring the delivery of health services that are safe, effective, integrated, high quality and continuously improving through Public Health & Clinical Governance (CG) systems.	12	t	3.1.1
51	CEO & Senior Executive Management team demonstrate leadership to improve clinical care, patient safety and quality of the PHA health systems of care reflected in established Clinical Governance Committees both in clinical and public health settings.	12	t	3.1.2
9	All decisions of the Board of Governance are formally communicated in writing and circulated to staff or individuals of the organization as appropriate.	1	t	1.1.9
10	The Board of Governance periodically reviews its own performance to actively enhance its achievements and to ensure continuous improvement in the quality of care, effective and efficient management of the health services.	1	t	1.1.10
11	The Governing body establishes a policy outlining attendance, functions and roles of executive staff, senior and middle managers, and nominated staff, at the Board of Governance, Committee and Sub-Committee meetings.	1	t	1.1.11
52	There is a flow of information between the Board of Governance, Clinical Governance Committees, Clinical Department Heads, Coordinators of Public Health Programmes, OICs of Wards and District Health Managers, regarding patient safety and quality.	12	t	3.1.3
53	The organisation has an approved 'Code of Conduct' for all healthcare workers which promotes day-day professional conduct and all staff understand its meaning.	13	t	3.2.1
54	There are continuous quality improvement measures demonstrated by management and staff as they continually strive to improve the quality of care.	14	t	3.3.1
57	There is evidence of a 'Critical Incident Monitoring Management' system. This system provides adequate surveillance to recognise major clinical risks and urgent public health events, at the same time, support open disclosure among clinical and public health teams. The serious critical incidents that should be reported are: All deaths in hospital and rural health facilities in PNG especially	16	t	3.6.1
59	Clinical team should conduct Morbidity & Mortality meetings (M&Ms) to review unexpected deaths, particularly those mentioned in Section 3.6.	17	t	3.7.2
61	There is evidence that the SMOs and specialist nursing officers provide adequate clinical supervision within each clinical unit.	18	t	3.8.2
58	Clinicians from multidisciplinary teams should undertake clinical audits through systematic review of patient care against explicit criteria/standards, to identify ways to improve clinical and primary healthcare practice to improve patient outcomes.	17	t	3.7.1
60	There is evidence of national or locally developed 'Clinical Care Guidelines or Standard Treatment Guidelines' that describe the evidence-based care patients should receive for specific clinical conditions and that the patients are aware of the treatment they will receive.	18	t	3.8.1
62	A 'Patient Complaints' mechanism exists as they are a unique source of information for health services on how and why adverse events occur and how to prevent them. Better management of complaints will restore trust and reduce the risk of litigation, through open communication and a commitment to learn from the problem and prevent its recurrence.	19	t	3.9.1
63	The performance of the 'Clinical Public Health Governance Framework' including the CG Advisory Committee and subcommittees are monitored through annual reviews against specified indicators.	20	t	3.10.1
64	The Organisation has initiated leadership and management, at all levels, who are responsible to ensure that all health staff have the required educational qualifications, experience, skills, knowledge and capacities to deliver high-quality and sustainable health care services and support.	22	t	4.1.1
65	The Organisation appoints staff through recruitment, selection and appointment procedures that are consistent with Human Resource policies.	22	t	4.1.2
66	The Organisation has an established health services development plan which outlines clearly the health staffing supply and demand requirements for both clinical and non-clinical health workers, and which is monitored and reported on to the governing Board on a quarterly basis.	23	t	4.2.1
67	There is a 5-year Health Workforce Training Plan to support the 5-year strategic health services development plan, that identifies the required training, upskilling and professional development requirements for both clinical and non-clinical health workers which is monitored and reported to the governing Board on a quarterly basis.	23	t	4.2.2
68	The Organisation has the appropriate GÇ£Staffing Skills MixGÇ¥ needs for both clinical and non-clinical health workers, as determined by application of the Workforce Indicator Staffing Needs (WISN) methodology within the National Health Service Standards (NHSS).	24	t	4.3.1
69	The Organisation ensures that the minimum GÇ£Hospital Health SpecialistGÇ¥ as determined by the NHSS for Levels of Care and Essential health services.	24	t	4.3.2
70	The Organisation has established a GÇÿHealth Workforce Risk Management PlanGÇÖ and process, which identifies, assesses and addresses any risks to health workforce.	25	t	4.4.1
71	The Organisation has a Board of Governance approved policy and procedures covering GÇÿOccupational Health, Safety and Security (OHS&S) of all health workers within the province, including with health partner organisations/agencies.	26	t	4.5.1
72	The Organisation has established systems to set, monitor and continually improve the performance of the health workforce (clinical and non-clinical) at all levels of the organisation in compliance to General Order.	27	t	4.6.1
73	The Organisation sets policies and systems to strengthen the capacity and productivity of all health workers to improve health care and deliver positive health outcome results.	27	t	4.6.2
74	The Organisation has an established career progression and succession planning system with clear procedures that ensure staff with the requisite skills and capabilities are available in the organisation.	28	t	4.7.1
75	Organisations have a 5-year GÇ£Training & Development PlanGÇ¥ approved by the Board covering the whole health workforce (clinical and non-clinical) within the province, including those health workers within health partner organisations.	29	t	5.1.1
76	The Organisation has determined mandatory training accredited by regulatory boards for all health workers as described in the Training Policy for both clinical and non-clinical staff. These include: fire safety, Occupational Health and Safety, hand hygiene, use of protective personal equipment (PPE), environmental cleaning, medication safety for HEOs, Nos and CHWs, cardiopulmonary resuscitation for all health clinicians.	30	t	5.2.1
77	The Organisation has an established and fully equipped GÇ£Training and Resource CentreGÇ¥ to support the implementation of the 5- year health workforce training plan, which provides regular training and upskilling courses, and has resources available to assist with ongoing professional development for both clinical and non-clinical health workers.	30	t	5.2.2
78	The Organisation has established a regular process of evaluating the training programmes conducted for all the health workers and reporting to the Board of Governance with recommendations on an annual basis.	30	t	5.2.3
79	The organisation has an established a process for the regular annual review of all clinical and non-clinical training curricula delivered by internal and external providers with a view to ensuring curricula are current and meet existing work environment conditions at all levels.	31	t	5.3.1
80	The organisation maintains effective stakeholder relationships with training and development service providers (e.g., Schools of Nursing & CHWs, Universities, Private Training Providers, NGO Training Providers, etc.) as a means of engaging with collaboration on training programs.	32	t	5.4.1
81	The demand for every item that is stored in a health facility is based on documented past usage data sourced from stock records, and matched where possible with actual and forecast morbidity data for each item.	33	t	6.1.1
82	The supply requisitioning process is done methodically and ensuring that supply meets accurately estimated demand for each item. Supply planning should have;\nStock currently in hand minus any expired stock- in- hand\nDuration of stock based on average monthly usage data \nDuration of stock- in- hand and stock- on -order but not received yet.	34	t	6.2.1
83	Storage practices should be consistent with national criteria for storage and store keeping practices.\nStorage conditions should meet manufacturersGÇÖ requirements to maintain drugs and medical supplies quality. This includes the following aspects of storage management;\nQuality of products is affected by high temperature, high humidity, lack of ventilation and exposure to pests and vermin (e.g. rats)\nIncorrect labelling \nExpiry dates and products past expiry \nMethodical storage of products in boxes and shelves\nAccountability for stock: all receipts and issues are recorded in a stock register and periodic stock- takes carried out to check whether physically available quantities match quantities in stock register. \nThere is a designated officer managing the store	35	t	6.3.1
109	Department/Unit Managers/OICs and team comply with the organisationGÇÖs GÇÿNo smoking / No Betel-nut policyGÇÖ and which is enforced.	47	t	7.2.8
84	Quantities requisitioned periodically should be to meet accurately estimated demand and not to create excess stock of some and under- stocking of others.\nThe Store should be making sure the stock level does not exceed the Maximum Stock Level and does not fall below the Minimum Stock Level. The following are considered:\nAverage Monthly Usage\nLead Time \nMinimum Stock Level \nMaximum Stock Level	36	t	6.4.1
85	Avoid the amount of stock that expires in the store prior to being used. Ensure that;\nExpired stock is not issued to any patient.\nProducts that expire first issued first GÇô First to Expire, First Out (FEFO)\nStock that has already expired should not be counted as stock in hand\nAll expired stock is removed from shelves and disposed in accordance with NDOHGÇÖs expired stock disposal procedures.	37	t	6.5.1
86	The Organisation undertakes periodic supply planning in line with the strategic direction identified in the 10-year Master Plan for Medical Supply Chain Management. This would include;\nThe stock of drugs & medical supplies in its health facilities is provincial stock with stock transferability between health facilities. \nGeographic, seasonal, logistics (road conditions included) and other situations that make stock transfers difficult or impractical noted.\nProcuring/requisitioning frequency reduced and,  order quantities increased where logistics difficulties impact on delivery lead times.\nA provincial buffer stock of essential items introduced and buffer stock holdings in individual health facilities reduced.	38	t	6.6.1
87	Evidence that the Organisation carries out an Annual Procurement Planning identifying:\nThe estimated quantity of drugs and medical supply items required for the upcoming year.\nThe budget required to meet the cost of this estimated need \nRequired delivery time frames.\nThe exercise is carried out by the 31st of October every year and sent to the NDOH Medical Supply Procurement & Distribution Branch (MSPD) during the first week of November every year.	39	t	6.7.1
88	The Organisation undertakes distribution planning, \nmanagement of drugs, medical supplies, vaccines, medical gases and programme stock in accordance with the 10- Year Master Plan for Medical Supply Chain Management. This includes;\nThe method, time, frequency and cost for transportation to health facilities.\nPartnerships for distribution\nTransit Stores may be carried out by distribution contractors chosen through a competitive tender process contract.	40	t	6.8.1
89	Ensure that purchase order management is carried out efficiently and that shortcomings in management does not contribute to supply shortages, payment delays to suppliers, and ad hoc emergency procurement.	41	t	6.9.1
90	Ensure there is adherence to agreed terms and conditions with suppliers and there are no negative procurement outcomes due to payment delays to suppliers.	42	t	6.10.1
91	Ensure that the warehouse layout facilitates the efficient and effective movement, with accountable storage of goods that are stored in a warehouse. There should be adequate space for;\nincoming goods\na holding area to keep goods until they are stored\nan area to store medical gases and cylinders\na cold room for vaccines\nrefrigerators for items requiring storage in such conditions\na safe and secure area for dangerous and controlled drugs\nan area to keep goods that are picked and ready for dispatch\na separate area to keep damaged/expired items until they are disposed according to policy requirements	43	t	6.11.1
92	There should be efficient receiving of goods consistent with terms and conditions in the relevant purchase orders in the warehouse. The goods should be moved to a holding area as soon as possible and to minimise any inconvenience and/or delays to shippers who deliver goods.	44	t	6.12.1
93	Ensure that the picking and packing operation in the warehouse is: \nplanned, methodical and efficient\ncarried out by maximising the labour input\ndone accurately under supervision \nstock picked and packed are in accordance with the relevant picking slips generated by m-Supply \nall pickings are confirmed in the m-Supply with the least possible delay\nThe picking schedule should account for at least 80% of items to be picked and packed that week, leaving a maximum of 20% for unscheduled, urgent picking and packing of items that may be required.	45	t	6.13.1
94	The planning and design of health facilities and its refurbishment must be compliant with relevant legislations with safety features ensured.	46	t	7.1.1
95	There is planning and management of internal roads with respect to: \ndrop-off and collection of patients/clients\npedestrian safety\nambulance movement\nclient/consumer/patient transport,\nmovement of vehicles through the grounds,\nspeed of vehicles moving through the facility\nappropriate parking areas which are safe	46	t	7.1.2
96	The planning and management of walkways within the facility is adequate with respect to;\nwidth\ntrip hazards\ndisabled access\nmovement of clients/consumers \nmovement of patient\nsafety of staff and visitors	46	t	7.1.3
97	All plants and other permanent fixtures are chosen for safety and efficiency and installed and maintained by qualified individuals and as per the manufacturersGÇÖ instructions.	46	t	7.1.4
98	The Health Facility has completed the L3-5 Rapid Health Facility Assessment Tool.	46	t	7.1.5
99	There should be clear, well-located internal and external signages to meet the needs of consumers / patients, visitors and staff.	46	t	7.1.6
100	Disability access and facilities meet legislative requirements, which are based on recognised guidelines and is appropriate to the needs of the community and the organisation.	46	t	7.1.7
101	There is a critical incident monitoring system for risks associated with the health facility environment, these risks are investigated, reported and remedial actions taken.\nThere should be a Standard Operating Procedure (SOP) for staff, patients, guardians and other visitors to report incidents relating to buildings, roads, walkways, plant, medical devices, equipment, consumables and supplies.	46	t	7.1.8
102	The health facility infrastructure complies with building codes for fire safety.	47	t	7.2.1
103	The local fire brigade performs annual inspections to identify risks.	47	t	7.2.2
104	The fire extinguishers within the facility should fulfil the following criteria:\nare in appropriate locations\nhave a current service tag\nhave fire hoses\nis recorded on the asset registry\nis frequently checked	47	t	7.2.3
105	Department/Unit Managers/OICs and staff ensure all fire exits are always kept free of obstruction and fire exit doors open from inside and are not locked from inside.	47	t	7.2.4
106	Department/Unit Managers/OICs and team are trained in the use of fire extinguishing equipment at least annually, in emergency fire response, and understand fire alarm systems / panels around the hospital.	47	t	7.2.5
107	Department/Unit Managers/OICs and team participate annually in mock fire drills. This is reflected in the organisationGÇÖs emergency fire plan which details what to do in case of a fire and all staff members have adequate knowledge of the plan.	47	t	7.2.6
110	There should be correct and effective use of equipment via specialty training for staff where required.	48	t	7.3.1
111	There are efficient inventory practices, to ensure the ready availability of supplies and consumables.	48	t	7.3.2
112	The plant and equipment are chosen according to an assessment process that considers:    \ncompliance with relevant legislation, standards, guidelines and or codes of practice \nintended use and consumer needs\ncost benefit\nsafety \ninfection control\nenergy efficiency and environmental sustainability \ntraining needs, storage and distribution.	48	t	7.3.3
113	The plant and equipment are being installed, tested and commissioned in accordance with the manufacturerGÇÖs instructions and by appropriately qualified individuals.	48	t	7.3.4
114	The plant and equipment should receive regular maintenance and cleaning according to a documented schedule with the following requirements:\nrecording of a log where required\nmonitored with respect to electrical, thermal radiant and mechanical hazards \nsubject to documented processes for procurement, upgrading and replacement	48	t	7.3.5
115	Vehicles are subject to processes for procurement, operation, maintenance and safety that consider: \ngovernment contracts, where relevant\nvehicle operators\nposition descriptions that specify appropriate training and licences \nsafe transport of patients\nsecure transport of health records, medications, equipment or supplies\nworkplace health and safety issues associated with vehicles, including appropriate seating, access and storage \nreporting of any vehicular accident as an incident.	48	t	7.3.6
116	Medical devices should be used safely with staff involved in the operation of medical devices undergoing necessary training and where necessary, correct licenses have been obtained.	49	t	7.4.1
117	Medical devices are cleaned, sterilised and recommissioned separately from general cleaning processes.	49	t	7.4.2
118	GÇ£Supplies and consumablesGÇ¥ are generally commodities with a shorter life such as dressings, syringes, disposable gloves, catheters, etc.	49	t	7.4.3
119	The Health Service Organisation can demonstrate preventive maintenance for its equipment so that the plant and the equipment within its Facilities operate safely and efficiently.	50	t	7.5.1
120	Cleaning of equipment should be done according to a documented schedule which describe the frequency of cleaning and the areas / items to be cleaned. It should also describe those areas / items not to be subject to general cleaning (e.g. medical devices).	50	t	7.5.2
121	Plant logs and maintenance processes should ensure that all buildings, including storage areas, plant, equipment, waste management areas and grounds are cleaned, maintained and serviced by qualified persons in accordance with infection control requirements, manufacturer specifications and relevant standards, including maintenance on high-risk plants such as cooling towers and pressure vessels.	50	t	7.5.3
122	The clinical and non-clinical staff can demonstrate handling and management of hazardous material (biological, chemical, radiological, and/or physical), which has the potential to cause harm to humans, animals, or the environment.	51	t	7.6.1
123	There is a radiation safety plan which has a register of all radioactive substances, procedures for the disposal of radioactive waste and radiation equipment.	51	t	7.6.2
124	There is a current asset register maintained by a designated officer.	52	t	7.7.1
125	Security measures are taken to ensure the protection of patients and staff from assault and loss of property; and the Facility from damage and loss.	53	t	7.8.1
126	There is monitoring of water and electricity use, including:\nHow often is usage monitored? \nHow has the organisation improved the efficiency of its energy and water usage?	54	t	7.9.1
127	The Senior Executive Management Team (SEM) of the Health Service Organisation and PHA Finance and Budget Committee members, all Section 32 officers, requisitioning officers and financial delegates, have read and understood the relevant sections of various Acts that are referred to in the Public Finance Manual. These include;\nA copy of the PFM Act 1995, PFM (Amendment) Act 2016, PFM (Amendment) Act 2018\nFinancial Management Manual (2012 and new copy when it is released by Department of Finance)\nAll Financial Regulations, Instructions and Circulars issued by Central Agencies (but also any that are issued by Provincial Administrations as well),\nThe Section 32 Officer LearnerGÇÖs Manual (2014)\nThe National Procurement Act\nThe Audit Act 1989\nThe National Audit Manual\nThe Public Service Management Act 2014\nThe General Orders	55	t	8.1.1
128	The CEO and Board of Governance ensure compliance with Central Ministry instructions to implement effective PFM and its accountability requirements to national and provincial governments.	56	t	8.2.1
129	There is a credible budget planning process where budget and revenue estimates align to organisational resource needs and strategic service plans.	56	t	8.2.2
130	There is a credible budget implementation process across the organisation.	56	t	8.2.3
131	The Health Care Organisation has internal budget controls in place to ensure the accountable usage of public funds to the organisation.	56	t	8.2.4
132	The Health Care Organisation have strong working relationships with Central Ministries to improve alignment of approved budget estimates with service delivery plans and disbursement of cash with implementation requirements.	56	t	8.2.5
133	The Health Care Organisation has strong working relationships with Provincial and District Administrations to improve provincial resourcing of primary and rural health care.	56	t	8.2.6
134	The Health Service Organisation has established a fully functional Finance and Budget Committee to ensure that the formulation, oversight and reporting on the organisationGÇÖs budget is conducted in a proactive way and is compliant with national requirements.	56	t	8.2.7
135	The Health Service Organisation has established a fully functional Project Steering Committee (PSC), established to direct and oversee both planning and the development of health infrastructure across the organisation.	56	t	8.2.8
136	The Health Service Organisation has established a fully functional Audit & Risk Management Committee established to make effective use of the internal audit function.	56	t	8.2.9
137	Public Finance Management accountability requirements of the CEO and Board of Governance are fully understood and followed, to ensure the efficient and transparent usage of public and other resources to improve health outcomes in the province.\nThe CEOs must know their mandated role as the Chief Accountable Officer and the PFM powers that they command, who they are responsible to report to on overall PFM and performance reporting, in what format, how often to report and what to do with the reports in terms of strategic decision making before the Board.\nThe CEOs must also know their role in enforcing accountability requirements across all other officers working in the PHA in meeting mandatory performance objectives of the PHA and ensuring the effective management of its day-to-day operations.	57	t	8.3.1
138	The Health Service Organisation reviews quarterly financial performance and financial statements for the Board of Governance.	57	t	8.3.2
139	The Board of Governance approves budget estimates and annual financial statements.	57	t	8.3.3
140	The Health Service Organisation has an annual budget timeline developed, an internal budget process and annual budget cycle requirements.	58	t	8.4.1
141	The Health Service Organisation Fee structure has been established and gazetted to keep track of the revenues that it generates, such as hospital user fees and other medical charges.	58	t	8.4.2
142	Provincial and district consultations are conducted after the budget is passed by Parliament and approved by Provincial Assemblies	58	t	8.4.3
143	The Health Service Organisation maintains an operating account. There should be effective usage and maintenance of this account.\nThere is an internal operating account manual with the following criteria;\nNo one individual \noversees identifying a spending need\nis ensuring it is in line with the organisationGÇÖs plan for the year and delivers value for money (i.e. proper procurement guidelines have been followed).\ndoes verification of both budget appropriation and funds which are available through warrant authority and CFCs.\nmaking a commitment.\nreviewing the commitment to ensure it is in line with financial procedural requirements\nadministering the transaction\ncarrying out a review of the transaction	59	t	8.5.1
144	The Health Service Organisation maintains a Health Services Improvement Project (HSIP) trust account. The HSIP staff must effectively manage the trust account by adhering to;\nThe HSIP Trust Instrument\nThe Trust Account Manual of procedures\nThe Public Finances Management Act (PFMA)\nThe DPM General Orders, and\nAny memorandum of understanding between the Development Partners and the Government of PNG.	59	t	8.5.2
145	Bank reconciliations are conducted weekly to ensure that the Health Service OrganisationsGÇÖ underlying financial records are accurate and reliable.	59	t	8.5.3
146	Budget adjustment requests are tracked and reported.\nThere should be summaries of requisition requests and Section 32 approvals that require the redistribution of cash funds or actual budget adjustments in IFMS/ the accounting system used by the organisation.\nThere should be Board approved guidelines that specify the conditions under which budget adjustments within and across expenditure votes can take place and these guidelines are circulated to;\nSection 32 officers\nFinancial Delegates\nCommitment Clerks\nAuthorizing Officers and Certifying Officers, Directors of Public and Curative Health\nthe heads of the Church and Catholic Health Services District health managers and other budget holders	59	t	8.5.4
147	Annual reports should be prepared for publication to meet PFM Act, PHA Act and Audit Act requirements	60	t	8.6.1
148	Basic accounting qualifications are required for accounts and audit officers.	61	t	8.7.1
149	The Public Financial Management Manual for the Health Service Organisation is read and used as a guideline and tool for best practice.\nRelevant sections of the PFM Manual should be read, utilised and referred to in the daily operations of the organisation by the following officers;\nThe CEO\nThe Director of the Corporate and Support Services (CSS)\nThe Finance Manager\nAll Financial Delegates\nAccountants and clerks\nAll planning officers\nBudget officers\nMembers of various finance and budget committees.\nDistrict Health Managers	61	t	8.7.2
150	Training and support are provided by Central Agencies and NDoH throughout the year.	61	t	8.7.3
151	Training and capacity building work delivered through donor partner programmes.	61	t	8.7.4
152	The Organisation has developed and implemented a GÇ£5-year Information and Communications Technology (ICT) PlanGÇ¥ which is aligned with the OrganisationGÇÖs Strategic Development  Plan, to ensure relevant infrastructure (hardware, software, networks, systems, etc) are enabled in all health facilities, to fully support health services delivery operations and delivery of key health program & project outcomes.	62	t	9.1.1
153	The Organisation has implemented appropriate policies and procedures for the keeping, accessing, storage, archiving and disposal of records and their security, in line with all relevant legislations, regulations and by-laws.	63	t	9.2.1
154	Every patient has a medical record which is sufficiently detailed to enable continuity of care, education and research and to facilitate clinical coding.	63	t	9.2.2
155	Information is made available to staff in a user-friendly format to assist with patient care and management of services.	63	t	9.2.3
156	The Organisation has embedded effective and transparent governance, which prioritises ICT investment, ensures decisions consider outcomes across health, manages risk, enables clinical leadership and provides accountability. Medico-legal requirements for information are met.	64	t	9.3.1
157	The Organisation has adopted a policy to fund the implementation of a common hospital patient electronic health record system across all provincial hospitals linked to a National Master Index (ICD 10) or the e-National Health Information System (e-NHIS).	65	t	9.4.1
158	Develop strategy to encourage and support the implementing of non-urgent telehealth outpatient care service to achieve both expenditure savings and service efficiencies because of reduced travel and associated costs for patients.	66	t	9.5.1
159	There is a need to stabilise existing ICT infrastructure, implement ICT systems at new L5 health facilities, consolidate duplicate systems and build the foundations for the future.	67	t	9.6.1
160	Improve information management, including secure sharing of patient information to improve patient safety, quality of care and care coordination.	68	t	9.7.1
161	Build organisational capacity, capability and credibility to deliver and use ICT systems.	69	t	9.8.1
162	The Health Care Organisation, their partners and the communities engage in planning to meet the health needs of a geographic catchment for a defined population.\nThis planning should be integrated through vertical alignment (through levels of care) and horizontal alignment (through the integration of public health and clinical services) and is consistent with NHSS levels of care and delineated roles. \nThe following are taken into consideration:\nChanging population characteristics and population needs.\nEmerging clinical evidence and technologies \nProjection of future needs influenced by changes in populations, disease patterns and treatment technologies.	70	t	10.1.1
163	Public health planning relating to planning for a public health issue (or issues) for a specific population cohort and targeting a particular geographical catchment. This should consider:\nCommunities are involved in planning for desired services closer to where people live\nA focus on health promotion, health protection and prevention\nIncrease focus on planning for emerging priorities and pandemics, and immunisation\nRoutine integrated outreach services to GÇ£hard to reachGÇ¥ areas\nIntegrated school health programs\nAll health facilities have access to clean water and improved sanitation\n Programmes to reduce stunting in communities.	71	t	10.2.1
164	There is ongoing planning for a specific service -streams (e.g. medicine, surgical, O&G, paediatrics cardiac, renal) to provide evidence based, safe, high quality and appropriate clinical services. This type of planning targets a population or geographical catchment as part of planning for the clinical service. The planning should consider;\nKey service areas which include prevention, promotion and protection, primary health care, ambulatory care, clinical - acute care, specialised care and mental health.\nA standard set of capability requirements for most acute, specialised and sub specialised services in line with NHSS.\nEncourages clinical risk management. \nArticulates credentialing, privileging, qualification and training requirements for staff.\nIdentifies the relationships and interdependencies between health services across the Organisation and other facilities.	72	t	10.3.1
165	The health needs in the Clinical Services Plan are reflected through the life course (birth to death) with continuity of care between public, private and other healthcare providers for the following:\nWell population who live independent lives\nAt risk population with a probability of developing a health condition or an adverse health outcome\nEasy identification and intervention of ill health and who, without intervention, may progress to acute or chronic consequences\nAcute consequences and conditions who require treatment.\nChronic conditions that are long-lasting and/or leave a residual disability\nEnd of life care with fatal conditions and those who are dying.	72	t	10.3.2
166	The Health Service Organisation has adequate Healthcare Project Management services that impacts any projects that work to improve a healthcare-related function.	73	t	10.4.1
167	The Board of Governance ensures there is a functioning Partnership Committee.	74	t	11.1.1
168	The Partnerships Committee is chaired by an appointed member of the Board of Governance.	74	t	11.1.2
169	The Partnerships Committee is meeting regularly.	74	t	11.1.3
170	Reports from the Partnerships Committee are submitted to the Board of Governance with recommendations.	74	t	11.1.4
171	The Partnership Committee has equal representation of women.	74	t	11.1.5
172	Provincial Administration and the District Development Authorities (DDAs) have representation on the Partnerships Committee.	74	t	11.1.6
173	Partnerships Committee provides all stakeholders with an opportunity to contribute to the planning and delivery of health services in the province.	74	t	11.1.7
174	There are agreements which the Health Service Organisations have with Partners, include specifications of the services to be provided and the Government funding that is to be allocated.	75	t	11.2.1
175	The agreements with partners include a requirement for the partners to demonstrate their capacity to deliver the agreed health services.	75	t	11.2.2
176	The agreements include a requirement that partners shall comply with the GÇ£Free Primary HealthcareGÇ¥ and GÇ£Subsidised Specialist Healthcare PolicyGÇ¥.	75	t	11.2.3
177	Partners delivering health services in the province must ensure that their activities are reported to the National Health Information System (e-NHIS).	75	t	11.2.4
178	Partners in receipt of funding from the PHA are required to provide reports to the PHA to enable compliance with Public Finance Management Act (PFMA) and any Financial Instructions issued by Department of Finance.	75	t	11.2.5
179	Partners are required to ensure that all health staff are properly registered and licensed to practice.	75	t	11.2.6
180	The Health Service Organisation is responsible for ensuring that all health services delivered, including services delivered by non-government providers are delivered in accordance with these National Health Service Standards (2021-2030).	75	t	11.2.7
181	The health sector of PNG fully commits to the agenda of Universal Health Coverage. When illness or disability besets an individual, it is a right of that individual to access affordable and quality health care.\nThis would include:\nVillage Health Assistants (VHAs) with clearly defined roles that are responsive to a specific community setting\nCommunity and home-based care are planned and delivered, supported by user friendly guidelines and tools\nMulti-skilled health workers in rural (including urban settlements) and hard to reach areas ensure integrated outreach services are provided to designated communities\nIntegrated health promotion and prevention programs in ALL levels of healthcare facilities including provincial and district hospitals	76	t	12.1.1
182	The Health Service Organisation (HSO) has introduced Universal Health Coverage (UHC) comprising components of health service coverage on one hand and financial protection coverage on the other.\nThis would include:\nHSOs are providing care aligned to the NHSS Levels of Care and delivering Essential Health Services based on community needs and priorities\nGÇ£Free Primary Health Care (PHC) and Subsidised Specialised Health Services PolicyGÇ¥ are implemented\nDistrict Health Services have developed supervised delivery hubs in each district as GÇÿCentres of ExcellenceGÇÖ\nThere is evidence within community settings of Maternal Newborn Health (RMNH) services through community and facility-based incentives\nAcross districts, there are planned and outreach services being conducted to GÇ£hard to reachGÇ¥ areas, which are monitored in each level of care meetings and reviewed through eNHIS information\nUser-friendly incentive schemes for women and communities within PHAs are implemented to increase numbers of women accessing antenatal care, supervised delivery and postnatal care and family planning	76	t	12.1.2
183	The Health Service Organisation (HSO) have strengthened PHC services within and across districts in partnership with churches, DDAs, LLG and communities.	77	t	12.2.1
184	The Health Service Organisation and Private health organisations have built capacity of workforce at the primary health care level.\nThis includes that following:\nVillage Health Assistants (VHAs) have completed the 6-week VHA curriculum program facilitated by a relevant Health Training and Resource Centre\nAcross Districts, OICs of health facilities and Public Health Officers actively support and supervise VHAs\nHealth Facility services at L1-L4 and across Districts, have a competent skilled workforce and GÇÿrightGÇÖ skill mixGÇÖ to provide integrated health services	77	t	12.2.2
185	The Health Service Organisation (HSO) have increased capacity of collecting and use of Health information by 2030.	77	t	12.2.3
186	The Health Service Organisation (HSO) ensure that vital, essential and necessary medical supplies and point of care packages are available at all levels.	77	t	12.2.4
187	The Health Service Organisation (HSO) have planned, piloted and progressed health incentive schemes to attract service utilization. \nThey demonstrate innovation in community settings and across L1-L4 health services to attract human resource. This included incentive schemes for Village Health Assistants for ANC & supervised deliveries; delivery bundles, TB DOTs program; etc.	78	t	12.3.1
211	Results of supervision visits are monitored against eNHIS data and other health date collection systems.	95	t	15.4.2
188	The facility has an approved 5-year GÇ£Disease Outbreaks Surveillance PlanGÇ¥ in place to ensure any diseases or population health threats (including pandemics) are continually being observed and dealt with.	79	t	13.1.1
189	The Facility preparedness plan to manage a disease outbreak includes emergency response, business continuity, crisis management, and crisis communications.	79	t	13.1.2
190	The importance of strengthening public health surveillance is to provide early warning: early detection, surveillance and reporting.	79	t	13.1.3
191	Emergency and disaster planning involve a coordinated, cooperative process of preparing to match urgent needs with available resources. \nThis would include internal disasters such as bomb threats, building collapse, fire, failure of vital services such as electricity medical gases and communication networks, AND External disasters or multiple casualty events such as landslides, earthquakes and major crash.	79	t	13.1.4
192	The health facility undertakes emergency planning with other sectors including provincial government, education and private industry as part of the larger Provincial Disaster and Emergency Preparedness Response  Plan.	79	t	13.1.5
193	There are flowcharts for Emergencies and Response evacuation plans and instructions are prominently displayed.	80	t	13.2.1
194	There is evidence that the Hospital Departments/Unit Managers /OICs and teams are aware of, trained and practiced in the procedures, at least annually, in the event of internal and external disasters	81	t	13.3.1
195	The Organisation has a formalised patient referral guidelines adapted from the National Patient Referral Guidelines to best fit its geographical and population health needs. This guideline addresses:\nRelationship between all levels of care\nPeople receive the best possible care close to home\nPatients receive optimal care at the appropriate levels\nPatients who most need specialist services can access them in a timely way\nPrimary health services are well utilised\nCost effective use of hospital and primary health care services - All healthcare providers adhere to the Patient Referral Guideline \nHealth workers at each level of care are fully aware of their roles and responsibilities for patient referral and as an escort or a guardian as an escort.	82	t	14.1.1
196	A reliable communication method is fully utilised to facilitate communication and coordination between health workers involved in the management of patient referrals.	83	t	14.2.1
197	Patients who require referral, receive timely and appropriate patient assessment, care, treatment and referral.	84	t	14.3.1
198	Evidence that emergency or urgent condition and non-urgent or elective criteria, is based on the patientGÇÖs medical condition and triage categories. Referrals are done to the appropriate level.	85	t	14.4.1
199	Standardised Patient Referral Forms are utilised and health information on this form is audited for completeness and accuracy.	86	t	14.5.1
200	The receiving health facility can handle the immediate care of the referred patient. Patient referrals are usually from a lower level of health facility to a higher or specialist health facility and vice versa.	87	t	14.6.1
201	A patient who is discharged from a facility to his home or transferred to another facility requires a discharge plan for continuity of care.	88	t	14.7.1
202	District Health Managers and Public health teams work with communities to develop and have in place a working community transport plan.	89	t	14.8.1
203	It is the responsibility of the facility initiating the referral to organise transport for their patient to arrive safely at their referral destination (health facility). This is particularly for urgent referrals.	90	t	14.9.1
204	District Health Managers with the OICs of health facilities inform their District and Provincial Clinical Governance Committee about the safety and risks involved with patient care, patient referrals, public health programs, health workforce and the community.	91	t	14.10.1
205	Multi-Disciplinary approach from all Clinicians Managers and Supervisors of the health organization towards daily operations, supervision and productivity of health sector employees.	92	t	15.1.1
206	Supportive supervision promotes efficient, effective and equitable health care and fosters improvements in the procedures, personal interactions, and management of all hospitals and primary health care services.	92	t	15.1.2
207	Good supervision results in good leadership, empowerment, guidance, coaching, motivation, self-discipline and direction with a view to developing the productivity, performance, satisfaction, fulfilment and the knowledge and skills of the health worker and the workerGÇÖs commitments to the goals of the organisation.	93	t	15.2.1
208	During supervisory visit, Supervisors follow nine (9)    Supervisory Steps, i.e.;\nObservations of Department / Clinical Unit (physical environment)\nFull Staff (Team) Meeting\nReview all the evidence / data: i.e.: Registers, NHIS tablet, ANC cards, medical records, critical incident reports.\nDiscuss within the team, relevant Elements and Components, fill out an initial score.\nConduct GÇ£BrainstormingGÇ¥ with the full team to summarise agreed actions and recommendations to be taken for each component within each relevant element.\nComplete each Element Summary, scores, and calculate percentages; Each element summary provides a total score /% as well the summary of agreed actions & recommendations.\nComplete onsite in-service training: based on identified topics or priority topics from the staff (team) meeting.\nComplete the 'Supervision Performance Scorecard & Summary Report' (front sheet summary) and distribute copies to Hospital Dept/Division/Unit Heads/Clinical Directors/Public Health Unit/OICs and other relevant officers.\nProvide Feedback and plan for the next supervisory visit.	93	t	15.2.2
209	The health organisation holds individual Department Heads, DHMs and OICs of heath programs/facilities accountable for these Key DeliverableGÇÖs;\nDeliverable 1: Hospital Dept Heads /Public Health Program Managers / DHMs carry out;\nSupportive supervision visits at least 4 times a year\nFull multidisciplinary team meeting\nDeliverable 2: Hospital Dept Heads /Public Health Program Managers /DHMs presents at Quarterly review meetings;\nSupervision results\nIdentified agenda item /activity for further action. \nDeliverable 3: Quality Coordinator (QC) & Internal Auditor (IA) compile all results & key issues & recommendations for Corporate & Clinical Governance (incl. Public Health) Committee meetings.\nDeliverable 4: Corporate & Clinical Governance Committee meetings prioritise key recommendations to go to SEMT, supported by QC & IA; CG & CG meeting have standard agenda item for results from supervision. SEM confirm for CEO to Board.\nDeliverable 5: CEO Provides  Overall Report  to Board of Governance on;\nSupervision Performance Scorecard .\nSummary of Significant Issues/Recommendations.	94	t	15.3.1
210	The CEO of Health Organization ensures that;\nQuarterly SEMT meeting to present and discuss, cross check written quarterly Supervision Framework report against Key Health Deliverables and Targets. \nFinalise Supervision report and submit to Board of Governance.	95	t	15.4.1
274	There are sufficient toilets available in the Facility.	115	t	21.8.1
212	Preventing harm to patients, health workers and visitors due to infection in health care facilities is fundamental to achieving quality care, patient safety, health security and the reduction of healthcare associated infections (HAIs) and antimicrobial resistance (AMR).	96	t	16.1.1
213	The IPC programme implementation is monitored, supported and properly resourced by the Organization.	96	t	16.1.2
214	Key IPC strategies are being monitored by the health care organisation. This includes;\ni.\tHand hygiene and aseptic technique\nii.\tAntimicrobial stewardship\niii.\tNotifiable disease\niv.\tOutbreak management\nTransmission precautions\nv.\tOccupational exposure\nvi.\tPrevention and management\nvii.\tSterilisation and reprocessing of instruments and devices.	96	t	16.1.3
215	The IPC programme addresses environmental factors such as;\ni.\tCleaning services\nii.\tFood safety and kitchen cleaning\niii.\tLinen handling and laundry services\niv.\tRelevant equipment.	96	t	16.1.4
216	IPC education is part of health worker education and uses team and task-based strategies that are participatory, including bedside and simulation-based training to reduce the risk of hospital acquired infection and anti-microbial resistance.	96	t	16.1.5
217	Hospital Acquired Infection (HAI) surveillance is performed to guide IPC interventions and detect outbreaks, including Antimicrobial Resistance (AMR) surveillance with timely feedback of results to health workers and stakeholders (including integrated public health surveillance systems) and through national networks.	96	t	16.1.6
218	Measures are taken to reduce the risk of HAI and the spread of AMR;\n1.)  Bed occupancy doesnGÇÖt exceed the standard capacity of the facility \n2.) Health worker staffing levels are adequately assigned according to patient workload.	96	t	16.1.7
219	There is evidence that health acquired infections are prevented and dealt with by measures such as:\ni.\tReadily available hand-washing facilities\nii.\tNon re-use of single use items\niii.\tCompliant equipment sterilising practices	97	t	16.2.1
220	All staff, patients and guardians within the organisation understand their role in the prevention of infection.	97	t	16.2.2
221	All health service operations minimise any infection risk in accordance with the infection control program	97	t	16.2.3
222	Cleaning, disinfecting, drying, packaging and sterilising of equipment and maintenance of associated equipment conforms to the National IPC policy and Guidelines.	97	t	16.2.4
223	The Organisation has an approved policy or educational program to promote effective antimicrobial stewardship.	97	t	16.2.5
224	The Facility ensures that all areas of the physical environment are monitored and maintained to ensure that it meets current standards, codes and regulations, there is regular cleaning to remove visible dirt and dust; cleaning agents and disinfectants should be selected according to the task and functional risk factors. These include areas such as operating theatres, invasive procedure areas (catheter labs and endoscopy), ICU, special care nurseries, CSSD.	98	t	16.3.1
225	The facility ensures that there are adequate cleaning staff and resources to maintain the cleanliness of the environment.	98	t	16.3.2
226	The Facility implements the National IPC Guidelines on food safety, linen and laundry handling.	98	t	16.3.3
227	The Facility has a waste management plan which is known by clinical and non-clinical staff..	99	t	17.1.1
228	The Health Facility has approved Guidelines that direct the efficient and sustainable use of energy, water and other utilities.	100	t	17.2.1
229	Clinical and other waste are being disposed of in accordance with legislation.	100	t	17.2.2
230	Health Facility OICs promote, educate and regularly assess all relevant health workers competencies and compliance in management of healthcare waste and waste management is mandatory in training programs.	101	t	17.3.1
231	The Vision, Mission of the Services are accessible. The Goals of the Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.	102	t	18.1.1
232	There is a mechanism to ensure effective interaction between the Director of Public Health (Head of Service) and the Organization's Governing Body and Senior Management.	102	t	18.1.2
233	Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the Public Health Services. These meetings are minuted and communicated to all staff.	102	t	18.1.3
234	Appropriate statistics and records are maintained in the department in and used for managing services and patient care. The following (among others) are available;\na.)\tworkload/census for inpatients and outpatients\nb.)\tquarterly and annual report\nc.)\tincident reports and register\nd.)\tstaffing number and staff profile\ne.)\tstaff training records\nf.)\tdata on performance improvement\ng.)\treferral cases	102	t	18.1.4
235	The Health Service Organization uses legal and regulatory frameworks to improve and protect communities within the province.	102	t	18.1.5
236	The are written and dated job descriptions for each category of staff that include;\na.)\tQualification, training and experience for the position\nb.)\tLines of authority\nc.)\tAccountability, functions and responsibilities\nd.)\tReviewed when required if there is major change in job scope \ne.)\tStatutory regulations\nf.)\tAdministrative and clinical job scope\n	103	t	18.2.1
237	The staff holds current registration with the relevant professional body.	103	t	18.2.2
238	The staff works within their job description and job scope.	103	t	18.2.3
239	There are continuing education activities (in-service training) for the public health team facilitated by the Organization's Training Resource Centre to strengthen public health competencies including strategic, technical and leadership skills.	103	t	18.2.4
240	The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.	103	t	18.2.5
241	In a service where there are health training programmes conducted, there should be sufficient skilled trained staff to provide supervision of students.	103	t	18.2.6
242	Staff receive evaluation of their performance at the completion of the probationary period and six monthly thereafter, or as defined by the Organization.	103	t	18.2.7
243	Where appropriate, the Public Health Division shall endeavor to undertake research using available resources.	103	t	18.2.8
244	The Organisation ensures that the Public Health workforce levels meet the projected targets for rural health service based on public health programmes and needs.	103	t	18.2.9
275	Wastewater within the Facility is handled appropriately.	116	t	21.9.1
276	The laundry system aims to provide a well- designed laundering programme in a safe and sanitary environment and to ensure the supply of clean and hygienic laundry.	117	t	21.10.1
245	There is a structured orientation programme for all newly appointed staff to the Public Health Division including medical practitioners and for those new to specific areas that include the following;\na.)\tExplanation of the goals, objectives, policies and procedures of the Organisation and the Public Health Division.\nb.)\tLines of authority and areas of responsibility \nc.)\tExplanation of duties and functions\nd.)\tExplanation of the methods of assigning clinical care and the standards of clinical practice (if applicable)\ne.)\tHandover communication\nf.)\tProcesses for resolving practice/ethical dilemmas in a timely manner\ng.)\tInformation about safety procedures\nh.)\tTraining in basic/advanced life support techniques\ni.)\tMethods of obtaining appropriate resource materials\nj.)\tStaff performance appraisal procedures.	103	t	18.2.10
246	The Public Health Division staff wear uniforms and have identification tags or cards.	103	t	18.2.11
247	There are written policies and procedures for the Public Health Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.	104	t	18.3.1
248	Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.	104	t	18.3.2
249	The policies and procedures documentation shall address at least the following topics;\na.)\tDescription of the organisational structure of the Public Health Division\nb.)\tThe use of Standard Treatment Guidelines\nc.)\tHandover communication\nd.)\tDrug prescription, dispensing and administration\ne.)\tBlood transfusion \nf.)\tContinuing of care including regular review of patient, review of investigation results, discharge (planned or GÇ£At Own RiskGÇ¥)\ng.)\tReferrals and escort as necessary \nh.)\tManagement of patients under police custody/prisoner\ni.)\tManagement of cases with an infectious disease including notification of notifiable diseases\nj.)\tThe responsibilities of the staff including clinical staff in relation to internal and external disasters (contingency plan)\nk.)\tIncident reports shall be compiled, investigated, discussed and recorded and action plans implemented\nl.)\tEnd of life care or palliative care\nm.)\tManagement of a death.	104	t	18.3.3
250	There are scheduled supportive supervisory activities from the Provincial Health Authority or higher-level facilities.	105	t	18.4.1
251	There are scheduled outreach activities which are integrated between public and curative health services. Outreach activities should involve local health committees and communities.	105	t	18.4.2
252	The Maternal and Reproductive Health Services is established and well-supported. There are adequate family planning services, antenatal, intrapartum and postnatal care, Prevention of Parent to Child (PTCT) services, birth registrations, immunizations, maternal death audits and referral pathways.	105	t	18.4.3
253	The Expanded Programme on Childhood Immunisation (EPI) is established and well supported.	105	t	18.4.4
254	STD, HIV, AIDS Programmes: These programmes are established and supported	105	t	18.4.5
255	Malaria Prevention and Control: The malaria prevention and control is established and supported	105	t	18.4.6
256	Tuberculosis (TB) Prevention and Control: The TB programme is established and supported	105	t	18.4.7
257	The Public Health Division uses evidence from research, practice-based insights and other forms of information to inform decision making and contribute to effective public health practice.\nThere is a process to assess and monitor population health status and risk factors within the province.\n	105	t	18.4.8
258	The Health Service Organisation has a health promotion and disease prevention programme that aligns with the Healthy Island concept and enables individuals and communities to increase the control over their health.\nIt covers social determinants of health such as poverty, education, literacy, gender and literacy and addresses adequate community infrastructure, public safety, environmental health (access to quality water, air quality and sanitation), safe homes and access to affordable food and healthcare services.	106	t	18.5.1
259	The Health Service Organisation has appropriate health communication strategies (verbal and written) to empower individuals, populations and communities to make healthier choices within the province.\nThese communication strategies demonstrate the use of research-based strategies to shape materials and products. It addresses local concepts, languages and different priorities for different cultures. It also addresses health literacy, internet access and media exposure of the target population.	106	t	18.5.2
260	The Health Service Organization has a strategy for health education. Health Education provides information to target populations on health benefits and risks. It provides tools to build capacity and to support behaviour change in an appropriate setting.	106	t	18.5.3
261	The Heath Service Organization ensures that the Public Health Division investigate, diagnose, and address hazards affecting the catchment population.	107	t	18.6.1
262	The Organization has a designated environmental health officer(s) overseeing the programme at provincial and district levels.	108	t	21.1.1
263	Public health teams including the environmental health programme regularly review and assess the impact of existing laws, and regulations on their programme.	109	t	21.2.1
264	The Environmental Health (EH) programme summarizes data collected in community assessments and describes the status of environmental health factors in a community.	110	t	21.3.1
265	The EH programme undertakes investigation of patterns and outbreaks of environmentally- related illness, hazards, risk factors and other environmental health threats.	110	t	21.3.2
266	The public health, infection prevention and control, biomedical and EH programme evaluates the effectiveness of EH services.	110	t	21.3.3
267	The Environmental Health programme has access to data and information systems to prioritize their activities.	111	t	21.4.1
268	The EH program informs, educates and empowers the community about environmental health issues.	112	t	21.5.1
269	Crisis communications are provided by public environmental health officers (EHO) to allow individuals, stakeholders and communities to make the best possible decisions about their safety and well-being during a crisis or emergency.	112	t	21.5.2
270	The Organization has established a process to identify key stakeholders and partners for community environmental health in general (e.g., improved environmental health conditions at the community level) or for specific environmental health concerns (e.g., drinking water, vector-borne disease, food safety).	113	t	21.6.1
271	Community partnerships foster the sharing of information, resources, and/or accountability in undertaking community environmental health improvement.	113	t	21.6.2
272	There are systematic community-level for environmental health improvements and emergency response and preparedness.	113	t	21.6.3
273	The environmental health programme oversees the quality of drinking water in the Facility.	114	t	21.7.1
277	Laundry staff receive training on infection prevention and control measures particularly on standard precautions.	117	t	21.10.2
278	Food handling and preparation is done with utmost cleanliness, and that contact between raw food and cooked food is avoided.	118	t	21.11.1
279	Food storage practices are optimized to prevent contamination and to protect against insects and rodents.	118	t	21.11.2
280	Thawing and chilling hot food has to adhere to specific guidelines.	118	t	21.11.3
281	Food handling and kitchen staff receive training on good IPC and food handling practices.	118	t	21.11.4
282	The number of vectors in the health-care setting is minimized so that patients, staff and guardians are protected from potential disease-transmitting vectors.	119	t	21.12.1
283	Vision, Mission and Value statements of the Facility are accessible. Philosophies, goals and objectives of the Nursing Services are clearly documented and measurable that indicates safety, quality and patient centered care. These reflect the roles and aspirations of the service and the needs of the community. These statements are monitored, reviewed and revised as required accordingly and communicated to all staff.	120	t	22.1.1
284	The organizational structure of the Nursing Services is clearly represented in one or more organization charts which;\na.)\tProvides a clear representation of the structure, functions and reporting relationships between the Person in Charge (PIC), Head of Nursing Services (HoNS), consultants, medical practitioners and staff of the Nursing Services\nb.)\tIs accessible to all staff and clients\nc.)\tIs revised when there is a major change in any of the following;\ni.\tOrganization\nii.\tFunctions\niii.\tReporting relationship\niv.\tStaffing patterns	120	t	22.1.2
285	Nursing Services Five (5) year activity plan shall be developed and maintained to support the continued delivery of nursing services in accordance with NHSS 2nd edition NATIONAL Clinical Public Health Framework and Manual for PHA and National Health Plan 2021-2030 Vol 1 A, Policies and Strategies.\nHoNS shall take lead coordination role for development, implementation, monitoring and evaluation of Nursing Services Five (5) year activity plan.	120	t	22.1.3
286	Regular staff meetings are held between the HoNS, Nurse leaders and staff regularly to discuss issues and matters pertaining to the operations of the Nursing Services. Minutes are kept; decisions and resolutions made during meetings shall be accessible and communicated to nurses.	120	t	22.1.4
287	Nursing Services Budget Planning & Management: The Head of Nursing Services (HoNS) is involved in the planning, justification and management of the budget and resource utilization of the services.	120	t	22.1.5
288	Nursing recruitment and appointments: The HoNS is involved and engaged with PHA or Health Service Organization HR in the recruitment and appointment process of nursing staff.	120	t	22.1.6
289	Appropriate statistics and records shall be maintained in relation to the provision of Nursing Services and used for managing the services and patient care.	120	t	22.1.7
290	The Head of Nursing Services (HoNS) is responsible in planning, the development and evaluation of nursing facilities and services.	120	t	22.1.8
291	There is evidence that the Nursing Services are involved in the development and implementation of new technologies.	120	t	22.1.9
292	HoNS shall ensure a Nursing Service Continuity Plan (NSCP) is in place to maintain critical emergency functions during service disruptions.\nThe plan shall be based on service priorities and potential risks, and include key actions, responsible staff, and alternative arrangements to continue care. For example, in Emergency Situation.	120	t	22.1.10
293	Health facility that provides clinical experience for student nurses, and MUST have a Memorandum of Understanding (MoU) documented between the health facility and the educational institution, detailing the responsibilities of all parties (stakeholders) involved, and shall include;\na.)\tTime period\nb.)\tLiability \nc.)\tReview of terms of contract\nd.)\tAccountability for clinical nursing practices	120	t	22.1.11
294	The Head (HoNS) and staff of the Nursing Services shall be individuals qualified by education, training, experience, certification and registration under the PNG Nursing Council Registration (Medical Act 1980, Chapter 398).	121	t	22.2.1
295	The Head of Nursing Services (HoNS) is a member of the Senior Executive Management Team (SEMT) and sits on relevant committees of the Governing Body	121	t	22.2.2
296	Nurse leaders delegated responsibilities:\nThe HoNS shall designate a qualified registered nurse with delegated responsibility for the management of the Nursing Services of each unit, at all times.	121	t	22.2.3
297	The assessment, planning, implementation and evaluation of nursing care is the responsibility and accountability of each and every registered nurse	121	t	22.2.4
298	Nursing staff roster should reflect professional competency standards. HoNS and nurse leaders shall consider professional competency of each nurse when developing nursing services duty roster to provide safe and effective practice.\nPatient needs and patient acuity level of care\nStaffing profile to comply with relevant guidelines and regulatory requirements;\nNumbers\nCredentials and privileges\nExperience of the various categories of nursing staff\nContingency staffing plans (absenteeism, turnover, etc.)	121	t	22.2.5
299	There are written and dated specific job descriptions for all nursing staff that includes;\nQualification, training, experience and certifications required for the job\nLines of authority\nAccountability, functions and responsibilities\nReview when required, and when there is a major change in any of the following;\nNature and scope of work\nDuties and responsibilities\nGeneral and specific accountabilities\nQualifications required and privileges granted\nStatutory Regulations\nAdministrative, teaching and clinical functions	121	t	22.2.6
300	Nursing Services Orientation Programme (MANDATORY)\nThere is a structured orientation programme for all newly appointed, contracted, and outsourced staff to the nursing services that covers the GÇÿGeneralGÇÖ, GÇÿServicesGÇÖ and GÇÿJob-SpecificsGÇÖ aspects of nursing services.\nGeneral\nVision and Mission of the facility\nOrganisation chart and reporting structure of the facility\nEnvironment and facility safety policies, procedures including sustainability practices\nInfection control policies and procedures\nPolicies for performance management, patient safety and risk management\nEthical practices and code of conduct including medicolegal awareness\nManagement of aggression, violence and harassment\nPatient and family rights\nServices\nGaols, objectives and organisational structure of Nursing Services\nPolicies and procedures relevant to Nursing Services\nworking instructions for patient care\nservice continuity plan for Nursing Services in response to internal and external disasters\nJob-Specific\nExplanation of particular duties and functions\nExplanation of the methods of assigning clinical care and the standards of clinical practice\nHandover communication\nTraining in basic, advanced life support techniques\nTechnology and equipment use including artificial intelligence (AI), as well as digital care if introduced.	121	t	22.2.7
301	Established formal nursing staff performance structure consistent that links with individual nurse job description (issued signed) and health facility or organization mission and objectives. \n\nPerformance appraisal conducted at the completion of the probationary period and annually. \n\nRecorded formal discussion on appraisal outcome held in confidential manner.	121	t	22.2.8
302	Nursing staff training needs and development plan. There is evidence of training needs assessment informed by the performance appraisal process and other needs. Training development plan is established to address knowledge and skills required for staff to maintain competency in their current positions and future advancement.	121	t	22.2.9
303	Continuing nursing education. There are continuing nursing education activities for the staff, to pursue professional interests and to prepare for current and future changes in nursing practice(s). \n A Nursing Services Study leave agreement policy address short term and long-term training away from duty.	121	t	22.2.10
304	Nursing Staff Personnel records on training, staff development, leave and others are maintained for every staff at;\nHead of Nursing Services Office\nHuman Resource Department as per Facility policy\nStaff personnel file is kept at the Head of Nursing Services offices and HRM with records on the items below.	121	t	22.2.11
305	In a Facility where nursing education programmes are conducted, the Nursing Services shall ensure that there are sufficient skilled clinical nursing staff with right credentials, experience, certification and privileged to provide clinical guidance and supervision of students	121	t	22.2.12
306	The nursing services shall ensure the establishment of a mechanism which includes requirements, methodology, and certification for credentialing and delineation of privileges for nurses in specialized areas for specific procedures. The mechanism taken by the nursing services adheres to the following;\nThe written policies and procedures document the criteria for privileging\nThe decisions made are objective, fair, and impartial and consistent with written policies, procedures and criteria\nThe granting of privileges for a specified period of time\nThe allocation of privileges in such a way that each staff functions within a specified area of competence\nThe granting of privileges is approved by the Credentialing and Privileging Committee and certified by the person in charge (PIC/Governing Body)	121	t	22.2.13
307	The Nursing services shall be responsible for promoting and supporting Health -Promoting Environment Policy that address the Physical, Mental and Spiritual wellbeing of the nursing staff, ensuring a safe and healthy work environment.\nThe nursing services shall also have policies and procedures for the promotion of staff physical, mental and spiritual well-being;\nA health-promoting environment, e.g., stress management, burn out, staff engagement opportunities, workload monitoring, management of work life balance, healthy lifestyle programmes e.g. Workplace Wellness Programs, Community-Based Health Initiatives\nStaff shall be provided with appropriate nursing practice supervision, support, and advice e.g., mentor mentee program\nThere shall be clear procedures for the effective management of underperformance e.g., feedback on performance review or performance appraisal report	121	t	22.2.14
308	The nursing services shall establish a safe mechanism for management of patient and nursing staff to grievances reporting risk concerns or safety threats anonymously, with assurance of non-retaliation in accordance with the principles of psychological safety.\nNursing grievance means feeling of resentment, bitterness and hurt over a nursing care process, work relationships or personal matter which affects nurse mind sat and performance at work.\nIn PNG;\nPatient and professional conducts complaints received are investigated and managed internally.\nSerious misconduct cases are investigated, documents and reported to the PNG Nursing Council \nMisconduct of criminal nature are referred to Police.\nEmployment and payroll matters are referred HR & CEO	121	t	22.2.15
309	Nursing Staff Feedback Management Policy prescribe a mechanism to gather and manage nursing staff feedback about their workplace experience such as burnout, roster, and work environment. Feedback shall be analysed and used to make improvements that enhance the work environment, nursing staff satisfaction and organisation culture.	121	t	22.2.16
310	There are written policies and procedures for the Nursing Services which are consistent with the overall policies of the Facility, regulatory requirements, current standard practices and Patients and Family Rights which include;\nPolicies and procedures, applicable laws and regulations that guide uniform nursing care of all patients\nEmergency patients\nUse of resuscitation services\nAdministration of blood and blood products\nPatients on life support/comatose\nPatients with communicable disease\nImmuno-compromised patients\nPatients on dialysis\nCare of patients on restraints\nCare of elderly patients\nDisabled individuals and children\nPatients receiving chemotherapy and other high-risk medications\nPolicies and procedures that guide the care of high-risk patients and high-risk services\nPolicies and procedures on recognition of early deterioration of patientGÇÖs condition (i.e., Early Warning Score, or EWS)\nPolicies and procedures on patient nutrition and hygiene. These policies and procedures are signed, authorized and dated. There is a mechanism for and evidence of a periodic review at least once in every 3-year\nDocumented Policies and Procedures, Protocols, Manuals and Guidelines are available dated and signed to guide nursing care for these patient conditions.	122	t	22.3.1
311	Policies and Procedures Development Committee (PPCD) develop policies in collaboration with staff, medical practitioners, management and where required, with other external service providers and with reference to relevant sources involved.	122	t	22.3.2
312	Communicating current policies and procedures to all staff in nursing services.	122	t	22.3.3
313	Copies of the policies and procedures, guidelines, relevant acts, regulations, by-laws, and statutory requirements are accessible to staff.	122	t	22.3.5
314	The Head of Nursing Services (HoNS) is responsible for the nursing services documentation and implementation of all nursing policies and procedures.	122	t	22.3.6
315	The Nursing Services participate in planning, decision making and formulation of Policies of the Facility.	122	t	22.3.7
316	Patient Care Assessment Plan (MANDATORY)\nThe Nursing Services have an established initial assessment process for patients where their needs nursing needs are identified and followed by regular assessment as deemed necessary.	122	t	22.3.8
317	Nursing Care Plan for Individual Patients (MANDATORY)\nNursing Practice is in accordance with current accepted standards based on evidences shall include in the nursing care plan;\nDocumented individualized patient -focused nursing care plan for each patient achieves appropriate outcomes of care.\nMonitoring of patients to assess the outcomes of the care of patient. \nReviewing of modifying of the care plan.\nCompleting the care plan and follow up to include discharge planning that that reflects continuity of care which is documented.	122	t	22.3.9
318	Nursing services adequate facilities spacing, appropriate medical equipment with proper utilisation of space at each unit to allow staff to carry out nursing services safely and efficiently.	123	t	22.4.1
319	Nursing services are provided with sufficient PPE (Personal Protective Equipment), hygiene sinks strictly for handwashing, are installed and easily accessible by nurses and medical staff.\nFunctional Basic & Critical medical equipment available, Oxygen Cylinder, Suction units, multiparameter patient monitor, Defibrillators & ECG machine where required.\nEmergency Trolley and Drawers are appropriately stock.\nDrawer 1. Airways & breathing items\nDrawer 2. Circulation & IV \nDrawer 3. Emergency Medications\nDrawer 4. Diagnostics and Sundries items.	123	t	22.4.2
320	Where specialized medical equipment is used, there evidence that only staff who are trained and authorized by the facility operate such equipment.	123	t	22.4.3
321	There are sufficient change rooms, toilets for staff use and storage including safe keeping of staff personal items.	123	t	22.4.4
322	Facilities which provide nursing training shall have specific areas for training and rooms for tutorial.	123	t	22.4.5
323	The services shall practice responsible stewardship of the facilities and equipment and promote environmentally sustainable care.	123	t	22.4.6
324	A comprehensive nursing risk management programme integrates clinical governance to safe guard patient safety and elevates care standards, prevents adverse events, minimized medical errors, and other incidents identified in PHA Health Facility Clinical Risk Management Plan to protect   both patients and Organization.	124	t	22.5.1
325	Nursing Services Standard Risk Management Training Programme is conducted. Evidence of Application of Risk management procedures are implemented within nursing services division. Programme reviewed is conducted to reflect innovation initiative for improvement.	124	t	22.5.2
326	Therea are periodical planned and systematic safety and performance improvement activities to monitor nursing and evaluate the performance of the nursing services. The process includes;\nPlanned activities \nData collection \nMonitoring and evaluation of the performance \nAction plan for improvement\nImplementation of Action Plan \nRe-evaluation for improvement \nInnovation	125	t	22.6.1
327	The Head of Services has assigned the responsibilities for planning, monitoring and managing safety and performance improvement activities to appropriate individuals/personnel within the respective services.	125	t	22.6.2
328	The Head of Services shall ensure a basic Business Continuity Plan (BCP) is in place to maintain critical emergency functions during service disruptions. The plan shall be based on service priorities and potential risks, and include key actions, responsible staff, and alternative arrangements to continue care.	125	t	22.6.3
329	There are periodical planned and systematic safety and performance improvement activities to monitor and evaluate the performance of the Nursing Services. The process includes;\nPlanned Activities\nData collection\nMonitoring and evaluation of the performance\nAction plan for improvement\nImplementation of action plan\nRe-evaluation for improvement\nInnovation	125	t	22.6.4
330	There is tracking and trending of specific performance indicators for improvement of the services/patient care such as percentage of Intravenous (IV) line complications (needles out, redness skin, infection of sites, extravasation). Target: Gëñ 0.5%.	125	t	22.6.5
331	The Services participates in the FacilityGÇÖs safety culture assessment. The results are utilized by Service leadership to inform and guide efforts to improve the culture of safety within the Service.	125	t	22.6.6
332	Feedback on the results of safety and performance improvement activities is regularly communicated to the staff to promote transparency, shared learning, and active engagement in improvement initiatives.	125	t	22.6.7
333	Appropriate documentation of safety and performance improvement activities is kept and confidentiality of medical practitioners, staff and patients is preserved.	125	t	22.6.8
334	The Vision, Mission of the Facility are accessible. The Goals of the Medical Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.	126	t	23a.1.1
335	There is a mechanism to ensure effective interaction between the Head of the Services and the Organization's Governing Body and Senior Management.	126	t	23a.1.2
336	Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the Medical Services. These meetings are minuted and communicated to all staff.	126	t	23a.1.3
337	Appropriate statistics and records are maintained in the department in and used for managing services and patient care.\nThe following, among others, are available;\na.)\tworkload/census for inpatients and outpatients\nb.)\tquarterly and annual report\nc.)\tincident reports and register\nd.)\tstaffing number and staff profile\ne.)\tstaff training records\nf.)\tdata on performance improvement	126	t	23a.1.4
338	The are written and dated job descriptions for each category of staff that include:\na.)\tQualification, training and experience for the position\nb.)\tLines of authority\nc.)\tAccountability, functions and responsibilities\nd.)\tReviewed when required if there is major change in job scope \ne.)\tStatutory regulations\nf.)\tAdministrative and clinical job scope	127	t	23a.2.1
339	The staff holds current registration with the relevant professional body.	127	t	23a.2.2
340	The staff works within their job description and job scope.	127	t	23a.2.3
341	There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice.	127	t	23a.2.4
342	The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.	127	t	23a.2.5
343	In a Facility where undergraduate medical, nursing and allied health training programmes are conducted, the Facility shall ensure there are sufficient skilled trained staff to provide clinical supervision of students.	127	t	23a.2.6
344	Staff including medical practitioners receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organization.	127	t	23a.2.7
345	Where appropriate the Facility shall endeavour to undertake clinical research using available resources.	127	t	23a.2.8
346	Staffing levels are based on the following;\na.)\tThe number of persons deployed is proportional to the number of patients being cared for as per regulatory requirements and for the intensity of care provided\nb.)\tThe categories of service providers reflect the complexity of clinical problems being managed\nc.)\tStaffing needs shall take into consideration absences due to leave or illness; double shift duties by clinical staff shall be documented and monitored\nd.)\tAdequate staffing levels of appropriate competency shall be maintained throughout the hours the services are in operation. \ne.)\tWhere it is not possible to have service providers on duty on site, e.g. after working hours, provision is made for relevant medical practitioner to be available on call.	127	t	23a.2.9
347	There is a structured orientation programme for all newly appointed staff to the Medical Services including medical practitioners and for those new to specific areas that include the following:\na.)\tExplanation of the goals, objectives, policies and procedures of the Facility and those of the Medical Services\nb.)\tLines of authority and areas of responsibility \nc.)\tExplanation of duties and functions\nd.)\tExplanation of the methods of assigning clinical care and the standards of clinical practice \ne.)\tHandover communication\nf.)\tProcesses for resolving practice/ethical dilemmas in a timely manner\ng.)\tInformation about safety procedures \nh.)\tTraining in basic/advanced life support techniques\ni.)\tMethods of obtaining appropriate resource materials\nj.)\tStaff appraisal procedures for the Medical Services\nk.)\tEducation on Patient and Family Rights	127	t	23a.2.10
348	There are written policies and procedures for the Medical Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.	128	t	23a.3.1
349	Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.	128	t	23a.3.2
350	The policies and procedures documentation shall address at least the following topics;\na.)\tDescription of the organisational structure of the Medical Services\nb.)\tThe use of updated Standard Treatment Guidelines.\nc.)\tHandover communication\nd.)\tDrug prescription, dispensing and administration\ne.)\tBlood transfusion \nf.)\tContinuing of care including regular review of patient and review of investigation results\ng.)\tAdmission and Discharge (planned or GÇ£At Own RiskGÇ¥)\nh.)\tReferrals and Repatriations\ni.)\tGuardians for patients\nj.)\tManagement of cases with an infectious disease including notification of notifiable diseases\nk.)\tInternal and External Disaster\nl.)\tIncident reports \nm.)\tManagement of deaths. \nn.)\tHealth information system and Medical Records.\no.)\tOutreach and supervisory visits\np.)\tInfection Prevention and Control\nq.)\tManagement of acutely deteriorating patients.\nr.)\tPatient feedback and complaint mechanism.\ns.)\tInformed consent	128	t	23a.3.3
351	The service shall operate on a 24- hour basis providing level of care appropriate the facility.	128	t	23a.3.4
352	The service shall ensure that provision of patient care and services achieve effective outcomes and is safe.	128	t	23a.3.5
353	There is a standardised patient medical record. This record should have the following;\na.)\tAn identification page\nb.)\tVital sign monitoring sheet (BP, HR, SpO2, Conscious level)\nc.)\tPatient history\nd.)\tClinical notes\ne.)\tConsent form\nf.)\tDiagnostic reports\ng.)\tFinal diagnosis and code at time of discharge\nh.)\tDrug order/medication sheet\ni.)\tOperating theatre sheet (if appropriate)\nj.)\tAllergy and adverse reaction documentation\nk.)\tBehavior issues that may pose a risk.\nl.)\tDischarge summary\nm.)\tReferral form (if applicable)	128	t	23a.3.6
354	There are adequate and appropriate facilities and equipment with proper utilization of space to enable staff to carry out their professional, teaching and administrative functions.	129	t	23a.4.1
355	Existing facilities shall consider the safety and comfort of staff and patients.	129	t	23a.4.2
356	Suitable forms of communication systems and equipment are provided to enable clinical staff to communicate among themselves and with the other members of the healthcare team.	129	t	23a.4.3
357	There is optimal management of beds at the Department with documentation of total number of beds and monitoring of bed occupancy rates.	129	t	23a.4.4
358	Facilities are suitably located to facilitate easy access and to provide an atmosphere of user, environmental and GÇÿdisabledGÇÖ friendly.	129	t	23a.4.5
359	Equipment, both for emergency and non-emergency usage, shall be appropriate to the level of care.	129	t	23a.4.6
360	There is evidence that the facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order.	129	t	23a.4.7
361	Where specialized equipment is used, there is evidence that only staff who are trained and authorized by the Facility operate such equipment.	129	t	23a.4.8
362	The Specialist Outpatient Services shall have the following features;\na.)\tThe organisation and management of the clinics are planned to ensure minimal waiting time, and avoidance of unnecessary visits by the patients.\nb.)\tRecord keeping shall be efficient.\nc.)\tAn appointment or queuing system is used to manage patient consultations.\nd.)\tThe clinic is easily accessible including for non-ambulant patients and is easily identified through adequate signage. \ne.)\tThe clinic is located close to other facilities, e.g. radiology, laboratories and pharmacy.\nf.)\tAdequate provision is made for patient comfort. \ng.)\tCall back system (especially for high-risk cases)\nh.)\tAvenue for patients to access service between appointments.	129	t	23a.4.9
363	At the Outpatient Clinic, adequate numbers of rooms are provided to ensure patient privacy and confidentiality for various patient care activities including:\na.)\tConsultation (not more than one patient in a room at any time). \nb.)\tMinor procedures and nursing procedures. \nc.)\tPerformance of various tests.	129	t	23a.4.10
364	There are planned activities for performance and quality improvement.	130	t	23a.5.1
365	The Head of Medical Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.	130	t	23a.5.2
366	Specific performance indicators are tracked for e.g. number of mortality audits being done, number of deaths within 24 hours of admission.	130	t	23a.5.3
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations ("organizationId", "organizationName", "categoryId", description) FROM stdin;
1	PHA	1	Provincial Health Authority.
2	Paradise Hospital	2	Paradise private hospital...
3	NDoH	1	The National Department of Health
4	NCDPHA	1	National Capital District Provincial Health Authority
\.


--
-- Data for Name: riskRatings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."riskRatings" ("riskId", "riskValue", "riskLabel", description, "severityOrder") FROM stdin;
2	M	Moderate	Moderate Risk Rating	2
3	H	High	High Risk Rating	3
4	E	Extreme	Extreme Risk Rating	4
1	L	Low	Low Risk Rating	1
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles ("roleId", "roleName", description) FROM stdin;
1	Admin	Administrator role
2	User	test user account
3	Surveyor	This role is for the surveyors doing the checks.
4	Team Lead	Leads assigned survey teams and can view the complete assigned survey.
5	Viewer	Read-only access to reference information and dashboard summaries.
\.


--
-- Data for Name: scores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scores ("scoreId", "scoreValue", "scoreLabel", description) FROM stdin;
1	0	0	Non-Compliant
2	1	1	Partially Compliant
3	2	2	Compliant
7	\N	NA	NA = Not Applicable
\.


--
-- Data for Name: specializations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.specializations ("specializationId", "specializationName", description) FROM stdin;
1	Finance & Corporate Services	\N
2	Public Health	\N
3	Medical Services	\N
4	Information Technology	Information and Communications Technology specialist, assigned to survey the ICT aspect of the health facility.
\.


--
-- Data for Name: surveyorCertStatuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."surveyorCertStatuses" ("surveyorCertStatusId", "surveyorCertStatusName", description) FROM stdin;
1	Certified Surveyor	Qualified to participate in accreditation survey teams.
2	Surveyor Trainee	Completed initial training; requires supervision by a certified lead.
3	Inactive / Not Practicing	Certified previously but not currently available for assignments.
4	Certification Suspended	Temporarily not eligible to undertake surveys.
5	Certification Expired	Previously certified, but renewal is overdue.
\.


--
-- Data for Name: userAccounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."userAccounts" ("userAccountId", "roleId", username, "passwordHash", "isActive", "dateCreated") FROM stdin;
4	3	jRogers	AQAAAAIAAYagAAAAEMw9NL08YZhUPFkKCykJWwTn/O98em4UelGKMeUP3WIs9ict3Swc95Tc8BH+ZeRvvA==	t	2026-09-09
1	1	isiddy	AQAAAAIAAYagAAAAEDhXhWIBrAJHRez8vsROulIQrnVfZeHV7D0HaxSLPIfdO03Lr8WuxX7R/mVefRIFOw==	t	2026-09-02
2	4	jsmith	AQAAAAIAAYagAAAAEPuhr0VhLS2mrckbZHibcxdZ5Gwd7ZU3G3jOGE2K26WQv7dfx5t0trPtKC32Z9nY5g==	t	2026-09-04
3	3	jjackson	AQAAAAIAAYagAAAAEGoy0/G4Nx7QsBDYiFnOBnBapQgERBEfpmYmoBjPR8R4CFBQKuhd44OFrurYn0g22w==	t	2026-09-04
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users ("userId", "userAccountId", "firstName", "lastName", "organizationId", "position", email, phone, mobile, comments) FROM stdin;
3	2	John	Smith	1	Surveyor	jsmith@pha.gov	321-1237	string	dummy user account for a user, who's assigned to "Surveyor" role
4	3	Johnson	Jackson	2	Head of Public Health & Health Promotions	jjackson@paradisehospital.com	321-6578	7546-9896	This is just a test profile for a user, under the "user" role!
2	1	Ishmael	Siddy	3	IT Network Engineer	isiddy@pnghssdp.org	325-1206	8380 4721	This is just a dummy profile for an admin user
5	4	Jonathan	Rogers	3	Surveyor	jrogers@ndoh.gov.pg	325-6887	7835-6698	
\.


--
-- Data for Name: surveyors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.surveyors ("surveyorId", "userId", "surveyorCertStatusId", "specializationId") FROM stdin;
5	3	1	1
6	5	2	1
8	4	2	3
7	2	1	4
\.


--
-- Data for Name: complianceAssessments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."complianceAssessments" ("complianceAssessmentId", "surveyorId", "surveyId", "complianceId", "scoreId", "riskRatingId", "complianceComments") FROM stdin;
667	5	1	334	\N	\N	\N
668	5	1	335	\N	\N	\N
669	5	1	336	\N	\N	\N
670	5	1	337	\N	\N	\N
671	5	1	338	\N	\N	\N
672	5	1	339	\N	\N	\N
673	5	1	340	\N	\N	\N
674	5	1	341	\N	\N	\N
675	5	1	342	\N	\N	\N
676	5	1	343	\N	\N	\N
677	5	1	344	\N	\N	\N
678	5	1	345	\N	\N	\N
679	5	1	346	\N	\N	\N
680	5	1	347	\N	\N	\N
681	5	1	348	\N	\N	\N
682	5	1	349	\N	\N	\N
398	6	2	65	\N	\N	\N
402	6	2	69	\N	\N	\N
406	6	2	73	\N	\N	\N
410	6	2	77	\N	\N	\N
414	6	2	81	\N	\N	\N
418	6	2	85	\N	\N	\N
422	6	2	89	\N	\N	\N
426	6	2	93	\N	\N	\N
428	6	2	95	\N	\N	\N
430	6	2	97	\N	\N	\N
432	6	2	99	\N	\N	\N
434	6	2	101	\N	\N	\N
436	6	2	103	\N	\N	\N
438	6	2	105	\N	\N	\N
440	6	2	107	\N	\N	\N
442	6	2	109	\N	\N	\N
444	6	2	111	\N	\N	\N
446	6	2	113	\N	\N	\N
448	6	2	115	\N	\N	\N
450	6	2	117	\N	\N	\N
452	6	2	119	\N	\N	\N
454	6	2	121	\N	\N	\N
456	6	2	123	\N	\N	\N
458	6	2	125	\N	\N	\N
460	6	2	127	\N	\N	\N
462	6	2	129	\N	\N	\N
464	6	2	131	\N	\N	\N
466	6	2	133	\N	\N	\N
468	6	2	135	\N	\N	\N
470	6	2	137	\N	\N	\N
472	6	2	139	\N	\N	\N
474	6	2	141	\N	\N	\N
476	6	2	143	\N	\N	\N
478	6	2	145	\N	\N	\N
480	6	2	147	\N	\N	\N
482	6	2	149	\N	\N	\N
484	6	2	151	\N	\N	\N
486	6	2	153	\N	\N	\N
488	6	2	155	\N	\N	\N
490	6	2	157	\N	\N	\N
492	6	2	159	\N	\N	\N
494	6	2	161	\N	\N	\N
496	6	2	163	\N	\N	\N
498	6	2	165	\N	\N	\N
500	6	2	167	\N	\N	\N
502	6	2	169	\N	\N	\N
504	6	2	171	\N	\N	\N
506	6	2	173	\N	\N	\N
508	6	2	175	\N	\N	\N
510	6	2	177	\N	\N	\N
512	6	2	179	\N	\N	\N
514	6	2	181	\N	\N	\N
516	6	2	183	\N	\N	\N
518	6	2	185	\N	\N	\N
520	6	2	187	\N	\N	\N
522	6	2	189	\N	\N	\N
524	6	2	191	\N	\N	\N
526	6	2	193	\N	\N	\N
528	6	2	195	\N	\N	\N
530	6	2	197	\N	\N	\N
532	6	2	199	\N	\N	\N
534	6	2	201	\N	\N	\N
536	6	2	203	\N	\N	\N
538	6	2	205	\N	\N	\N
540	6	2	207	\N	\N	\N
542	6	2	209	\N	\N	\N
544	6	2	211	\N	\N	\N
546	6	2	213	\N	\N	\N
548	6	2	215	\N	\N	\N
550	6	2	217	\N	\N	\N
552	6	2	219	\N	\N	\N
554	6	2	221	\N	\N	\N
556	6	2	223	\N	\N	\N
558	6	2	225	\N	\N	\N
560	6	2	227	\N	\N	\N
562	6	2	229	\N	\N	\N
564	6	2	231	\N	\N	\N
566	6	2	233	\N	\N	\N
568	6	2	235	\N	\N	\N
570	6	2	237	\N	\N	\N
572	6	2	239	\N	\N	\N
574	6	2	241	\N	\N	\N
576	6	2	243	\N	\N	\N
578	6	2	245	\N	\N	\N
580	6	2	247	\N	\N	\N
582	6	2	249	\N	\N	\N
584	6	2	251	\N	\N	\N
586	6	2	253	\N	\N	\N
588	6	2	255	\N	\N	\N
590	6	2	257	\N	\N	\N
592	6	2	259	\N	\N	\N
594	6	2	261	\N	\N	\N
596	6	2	263	\N	\N	\N
598	6	2	265	\N	\N	\N
600	6	2	267	\N	\N	\N
602	6	2	269	\N	\N	\N
604	6	2	271	\N	\N	\N
606	6	2	273	\N	\N	\N
608	6	2	275	\N	\N	\N
610	6	2	277	\N	\N	\N
612	6	2	279	\N	\N	\N
614	6	2	281	\N	\N	\N
616	6	2	283	\N	\N	\N
618	6	2	285	\N	\N	\N
620	6	2	287	\N	\N	\N
622	6	2	289	\N	\N	\N
624	6	2	291	\N	\N	\N
626	6	2	293	\N	\N	\N
628	6	2	295	\N	\N	\N
630	6	2	297	\N	\N	\N
632	6	2	299	\N	\N	\N
634	6	2	301	\N	\N	\N
636	6	2	303	\N	\N	\N
638	6	2	305	\N	\N	\N
640	6	2	307	\N	\N	\N
642	6	2	309	\N	\N	\N
644	6	2	311	\N	\N	\N
646	6	2	313	\N	\N	\N
648	6	2	315	\N	\N	\N
650	6	2	317	\N	\N	\N
652	6	2	319	\N	\N	\N
654	6	2	321	\N	\N	\N
656	6	2	323	\N	\N	\N
658	6	2	325	\N	\N	\N
50	6	1	50	\N	\N	\N
51	6	1	51	\N	\N	\N
52	6	1	52	\N	\N	\N
53	6	1	53	\N	\N	\N
54	6	1	54	\N	\N	\N
55	6	1	55	\N	\N	\N
56	6	1	56	\N	\N	\N
683	5	1	350	\N	\N	\N
684	5	1	351	\N	\N	\N
685	5	1	352	\N	\N	\N
686	5	1	353	\N	\N	\N
687	5	1	354	\N	\N	\N
688	5	1	355	\N	\N	\N
689	5	1	356	\N	\N	\N
690	5	1	357	\N	\N	\N
691	5	1	358	\N	\N	\N
692	5	1	359	\N	\N	\N
693	5	1	360	\N	\N	\N
694	5	1	361	\N	\N	\N
695	5	1	362	\N	\N	\N
696	5	1	363	\N	\N	\N
697	5	1	364	\N	\N	\N
698	5	1	365	\N	\N	\N
699	5	1	366	\N	\N	\N
127	6	1	127	\N	\N	\N
128	6	1	128	\N	\N	\N
129	6	1	129	\N	\N	\N
130	6	1	130	\N	\N	\N
147	6	1	147	\N	\N	\N
148	6	1	148	\N	\N	\N
149	6	1	149	\N	\N	\N
150	6	1	150	\N	\N	\N
167	6	1	167	\N	\N	\N
168	6	1	168	\N	\N	\N
169	6	1	169	\N	\N	\N
92	8	1	92	\N	\N	\N
154	7	1	154	2	1	\N
157	7	1	157	1	3	\N
158	7	1	158	3	1	\N
161	7	1	161	2	2	\N
131	6	1	131	\N	\N	\N
132	6	1	132	\N	\N	\N
133	6	1	133	\N	\N	\N
134	6	1	134	\N	\N	\N
135	6	1	135	\N	\N	\N
136	6	1	136	\N	\N	\N
137	6	1	137	\N	\N	\N
138	6	1	138	\N	\N	\N
139	6	1	139	\N	\N	\N
140	6	1	140	\N	\N	\N
141	6	1	141	\N	\N	\N
142	6	1	142	\N	\N	\N
143	6	1	143	\N	\N	\N
144	6	1	144	\N	\N	\N
145	6	1	145	\N	\N	\N
146	6	1	146	\N	\N	\N
399	6	2	66	\N	\N	\N
403	6	2	70	\N	\N	\N
407	6	2	74	\N	\N	\N
411	6	2	78	\N	\N	\N
415	6	2	82	\N	\N	\N
419	6	2	86	\N	\N	\N
423	6	2	90	\N	\N	\N
427	6	2	94	\N	\N	\N
431	6	2	98	\N	\N	\N
435	6	2	102	\N	\N	\N
439	6	2	106	\N	\N	\N
443	6	2	110	\N	\N	\N
447	6	2	114	\N	\N	\N
451	6	2	118	\N	\N	\N
455	6	2	122	\N	\N	\N
459	6	2	126	\N	\N	\N
463	6	2	130	\N	\N	\N
467	6	2	134	\N	\N	\N
471	6	2	138	\N	\N	\N
475	6	2	142	\N	\N	\N
479	6	2	146	\N	\N	\N
483	6	2	150	\N	\N	\N
487	6	2	154	\N	\N	\N
491	6	2	158	\N	\N	\N
495	6	2	162	\N	\N	\N
499	6	2	166	\N	\N	\N
503	6	2	170	\N	\N	\N
507	6	2	174	\N	\N	\N
511	6	2	178	\N	\N	\N
515	6	2	182	\N	\N	\N
519	6	2	186	\N	\N	\N
523	6	2	190	\N	\N	\N
527	6	2	194	\N	\N	\N
531	6	2	198	\N	\N	\N
535	6	2	202	\N	\N	\N
539	6	2	206	\N	\N	\N
543	6	2	210	\N	\N	\N
547	6	2	214	\N	\N	\N
551	6	2	218	\N	\N	\N
555	6	2	222	\N	\N	\N
559	6	2	226	\N	\N	\N
563	6	2	230	\N	\N	\N
567	6	2	234	\N	\N	\N
571	6	2	238	\N	\N	\N
575	6	2	242	\N	\N	\N
579	6	2	246	\N	\N	\N
583	6	2	250	\N	\N	\N
587	6	2	254	\N	\N	\N
591	6	2	258	\N	\N	\N
595	6	2	262	\N	\N	\N
599	6	2	266	\N	\N	\N
603	6	2	270	\N	\N	\N
607	6	2	274	\N	\N	\N
611	6	2	278	\N	\N	\N
615	6	2	282	\N	\N	\N
619	6	2	286	\N	\N	\N
623	6	2	290	\N	\N	\N
627	6	2	294	\N	\N	\N
631	6	2	298	\N	\N	\N
635	6	2	302	\N	\N	\N
639	6	2	306	\N	\N	\N
643	6	2	310	\N	\N	\N
647	6	2	314	\N	\N	\N
651	6	2	318	\N	\N	\N
655	6	2	322	\N	\N	\N
659	6	2	326	\N	\N	\N
660	6	2	327	\N	\N	\N
663	6	2	330	\N	\N	\N
664	6	2	331	\N	\N	\N
334	5	2	1	\N	\N	\N
335	5	2	2	\N	\N	\N
336	5	2	3	\N	\N	\N
337	5	2	4	\N	\N	\N
338	5	2	5	\N	\N	\N
339	5	2	6	\N	\N	\N
340	5	2	7	\N	\N	\N
341	5	2	8	\N	\N	\N
342	5	2	9	\N	\N	\N
343	5	2	10	\N	\N	\N
344	5	2	11	\N	\N	\N
345	5	2	12	\N	\N	\N
346	5	2	13	\N	\N	\N
347	5	2	14	\N	\N	\N
348	5	2	15	\N	\N	\N
349	5	2	16	\N	\N	\N
350	5	2	17	\N	\N	\N
351	5	2	18	\N	\N	\N
352	5	2	19	\N	\N	\N
353	5	2	20	\N	\N	\N
354	5	2	21	\N	\N	\N
355	5	2	22	\N	\N	\N
356	5	2	23	\N	\N	\N
357	5	2	24	\N	\N	\N
358	5	2	25	\N	\N	\N
359	5	2	26	\N	\N	\N
360	5	2	27	\N	\N	\N
361	5	2	28	\N	\N	\N
362	5	2	29	\N	\N	\N
363	5	2	30	\N	\N	\N
364	5	2	31	\N	\N	\N
365	5	2	32	\N	\N	\N
366	5	2	33	\N	\N	\N
367	5	2	34	\N	\N	\N
368	5	2	35	\N	\N	\N
369	5	2	36	\N	\N	\N
370	5	2	37	\N	\N	\N
371	5	2	38	\N	\N	\N
372	5	2	39	\N	\N	\N
373	5	2	40	\N	\N	\N
374	5	2	41	\N	\N	\N
375	5	2	42	\N	\N	\N
376	5	2	43	\N	\N	\N
377	5	2	44	\N	\N	\N
378	5	2	45	\N	\N	\N
379	5	2	46	\N	\N	\N
380	5	2	47	\N	\N	\N
381	5	2	48	\N	\N	\N
382	5	2	49	\N	\N	\N
383	5	2	50	\N	\N	\N
384	5	2	51	\N	\N	\N
385	5	2	52	\N	\N	\N
386	5	2	53	\N	\N	\N
387	5	2	54	\N	\N	\N
388	5	2	55	\N	\N	\N
389	5	2	56	\N	\N	\N
390	5	2	57	\N	\N	\N
391	5	2	58	\N	\N	\N
392	5	2	59	\N	\N	\N
393	5	2	60	\N	\N	\N
394	5	2	61	\N	\N	\N
395	5	2	62	\N	\N	\N
396	5	2	63	\N	\N	\N
700	6	2	334	\N	\N	\N
701	6	2	335	\N	\N	\N
702	6	2	336	\N	\N	\N
703	6	2	337	\N	\N	\N
704	6	2	338	\N	\N	\N
705	6	2	339	\N	\N	\N
706	6	2	340	\N	\N	\N
707	6	2	341	\N	\N	\N
708	6	2	342	\N	\N	\N
709	6	2	343	\N	\N	\N
710	6	2	344	\N	\N	\N
711	6	2	345	\N	\N	\N
712	6	2	346	\N	\N	\N
713	6	2	347	\N	\N	\N
714	6	2	348	\N	\N	\N
715	6	2	349	\N	\N	\N
716	6	2	350	\N	\N	\N
717	6	2	351	\N	\N	\N
718	6	2	352	\N	\N	\N
719	6	2	353	\N	\N	\N
720	6	2	354	\N	\N	\N
721	6	2	355	\N	\N	\N
722	6	2	356	\N	\N	\N
723	6	2	357	\N	\N	\N
724	6	2	358	\N	\N	\N
725	6	2	359	\N	\N	\N
726	6	2	360	\N	\N	\N
727	6	2	361	\N	\N	\N
162	5	1	162	\N	\N	\N
163	5	1	163	\N	\N	\N
164	5	1	164	\N	\N	\N
165	5	1	165	\N	\N	\N
166	5	1	166	\N	\N	\N
728	6	2	362	\N	\N	\N
729	6	2	363	\N	\N	\N
730	6	2	364	\N	\N	\N
731	6	2	365	\N	\N	\N
170	6	1	170	\N	\N	\N
732	6	2	366	\N	\N	\N
400	6	2	67	\N	\N	\N
404	6	2	71	\N	\N	\N
408	6	2	75	\N	\N	\N
241	8	1	241	\N	\N	\N
242	8	1	242	\N	\N	\N
243	8	1	243	\N	\N	\N
244	8	1	244	\N	\N	\N
245	8	1	245	\N	\N	\N
246	8	1	246	\N	\N	\N
247	8	1	247	\N	\N	\N
248	8	1	248	\N	\N	\N
249	8	1	249	\N	\N	\N
250	8	1	250	\N	\N	\N
251	8	1	251	\N	\N	\N
252	8	1	252	\N	\N	\N
253	8	1	253	\N	\N	\N
254	8	1	254	\N	\N	\N
255	8	1	255	\N	\N	\N
256	8	1	256	\N	\N	\N
259	8	1	259	\N	\N	\N
260	8	1	260	\N	\N	\N
261	8	1	261	\N	\N	\N
412	6	2	79	\N	\N	\N
416	6	2	83	\N	\N	\N
420	6	2	87	\N	\N	\N
424	6	2	91	\N	\N	\N
12	6	1	12	\N	\N	\N
13	6	1	13	\N	\N	\N
14	6	1	14	\N	\N	\N
15	6	1	15	\N	\N	\N
16	6	1	16	\N	\N	\N
17	6	1	17	\N	\N	\N
18	6	1	18	\N	\N	\N
19	6	1	19	\N	\N	\N
20	6	1	20	\N	\N	\N
21	6	1	21	\N	\N	\N
22	6	1	22	\N	\N	\N
23	6	1	23	\N	\N	\N
24	6	1	24	\N	\N	\N
25	6	1	25	\N	\N	\N
26	6	1	26	\N	\N	\N
93	8	1	93	\N	\N	\N
94	8	1	94	\N	\N	\N
95	8	1	95	\N	\N	\N
96	8	1	96	\N	\N	\N
97	8	1	97	\N	\N	\N
98	8	1	98	\N	\N	\N
99	8	1	99	\N	\N	\N
100	8	1	100	\N	\N	\N
101	8	1	101	\N	\N	\N
102	8	1	102	\N	\N	\N
103	8	1	103	\N	\N	\N
104	8	1	104	\N	\N	\N
105	8	1	105	\N	\N	\N
106	8	1	106	\N	\N	\N
107	8	1	107	\N	\N	\N
108	8	1	108	\N	\N	\N
109	8	1	109	\N	\N	\N
110	8	1	110	\N	\N	\N
111	8	1	111	\N	\N	\N
112	8	1	112	\N	\N	\N
113	8	1	113	\N	\N	\N
115	8	1	115	\N	\N	\N
116	8	1	116	\N	\N	\N
117	8	1	117	\N	\N	\N
118	8	1	118	\N	\N	\N
119	8	1	119	\N	\N	\N
120	8	1	120	\N	\N	\N
121	8	1	121	\N	\N	\N
122	8	1	122	\N	\N	\N
123	8	1	123	\N	\N	\N
124	8	1	124	\N	\N	\N
125	8	1	125	\N	\N	\N
126	8	1	126	\N	\N	\N
155	7	1	155	3	1	\N
156	7	1	156	2	2	There is no information system that stored patients information, that is available for staff to use, to provide care.
159	7	1	159	2	2	most of the computers are personal computers of stuff, that they use for work, as the number of computers provided by the health facility is limited...
77	5	1	77	\N	\N	\N
78	5	1	78	\N	\N	\N
160	7	1	160	2	2	In terms of dashboards, the only one that they can see is the published eNHIS data made available to the facility, from NDoH.
114	8	1	114	\N	\N	\N
151	6	1	151	\N	\N	\N
152	7	1	152	2	3	Though there is a 5-year plan for ICT, there's significant evidence to indicated that no implementation of said plan has been carried out, or planned to be implemented in the near future,.\nThis is a high risk that needs to be addressed as soon as possible.
153	7	1	153	1	4	Medical records are stored in an orderly manner, and the facility has already lost a decent amount of medical records to rain, as they weren't stored properly.\nExtreme risk that needs immediate attention!!
187	5	1	187	\N	\N	\N
188	5	1	188	\N	\N	\N
189	5	1	189	\N	\N	\N
257	8	1	257	\N	\N	\N
258	8	1	258	\N	\N	\N
296	5	1	296	\N	\N	\N
297	5	1	297	\N	\N	\N
298	5	1	298	\N	\N	\N
397	6	2	64	\N	\N	\N
401	6	2	68	\N	\N	\N
405	6	2	72	\N	\N	\N
409	6	2	76	\N	\N	\N
413	6	2	80	\N	\N	\N
417	6	2	84	\N	\N	\N
421	6	2	88	\N	\N	\N
425	6	2	92	\N	\N	\N
429	6	2	96	\N	\N	\N
433	6	2	100	\N	\N	\N
437	6	2	104	\N	\N	\N
441	6	2	108	\N	\N	\N
445	6	2	112	\N	\N	\N
449	6	2	116	\N	\N	\N
453	6	2	120	\N	\N	\N
457	6	2	124	\N	\N	\N
461	6	2	128	\N	\N	\N
465	6	2	132	\N	\N	\N
469	6	2	136	\N	\N	\N
473	6	2	140	\N	\N	\N
477	6	2	144	\N	\N	\N
481	6	2	148	\N	\N	\N
485	6	2	152	\N	\N	\N
489	6	2	156	\N	\N	\N
493	6	2	160	\N	\N	\N
497	6	2	164	\N	\N	\N
501	6	2	168	\N	\N	\N
505	6	2	172	\N	\N	\N
509	6	2	176	\N	\N	\N
513	6	2	180	\N	\N	\N
517	6	2	184	\N	\N	\N
521	6	2	188	\N	\N	\N
525	6	2	192	\N	\N	\N
529	6	2	196	\N	\N	\N
533	6	2	200	\N	\N	\N
537	6	2	204	\N	\N	\N
541	6	2	208	\N	\N	\N
545	6	2	212	\N	\N	\N
549	6	2	216	\N	\N	\N
553	6	2	220	\N	\N	\N
557	6	2	224	\N	\N	\N
561	6	2	228	\N	\N	\N
565	6	2	232	\N	\N	\N
569	6	2	236	\N	\N	\N
573	6	2	240	\N	\N	\N
577	6	2	244	\N	\N	\N
581	6	2	248	\N	\N	\N
585	6	2	252	\N	\N	\N
589	6	2	256	\N	\N	\N
593	6	2	260	\N	\N	\N
597	6	2	264	\N	\N	\N
601	6	2	268	\N	\N	\N
605	6	2	272	\N	\N	\N
609	6	2	276	\N	\N	\N
613	6	2	280	\N	\N	\N
617	6	2	284	\N	\N	\N
621	6	2	288	\N	\N	\N
625	6	2	292	\N	\N	\N
629	6	2	296	\N	\N	\N
633	6	2	300	\N	\N	\N
637	6	2	304	\N	\N	\N
641	6	2	308	\N	\N	\N
645	6	2	312	\N	\N	\N
649	6	2	316	\N	\N	\N
653	6	2	320	\N	\N	\N
657	6	2	324	\N	\N	\N
661	6	2	328	\N	\N	\N
662	6	2	329	\N	\N	\N
665	6	2	332	\N	\N	\N
666	6	2	333	\N	\N	\N
1	6	1	1	\N	\N	\N
2	6	1	2	\N	\N	\N
3	6	1	3	\N	\N	\N
4	6	1	4	\N	\N	\N
5	6	1	5	\N	\N	\N
6	6	1	6	\N	\N	\N
7	6	1	7	\N	\N	\N
8	6	1	8	\N	\N	\N
9	6	1	9	\N	\N	\N
10	6	1	10	\N	\N	\N
11	6	1	11	\N	\N	\N
27	6	1	27	\N	\N	\N
28	6	1	28	\N	\N	\N
29	6	1	29	\N	\N	\N
30	6	1	30	\N	\N	\N
31	6	1	31	\N	\N	\N
32	6	1	32	\N	\N	\N
33	6	1	33	\N	\N	\N
34	6	1	34	\N	\N	\N
35	6	1	35	\N	\N	\N
36	6	1	36	\N	\N	\N
37	6	1	37	\N	\N	\N
38	6	1	38	\N	\N	\N
39	6	1	39	\N	\N	\N
40	6	1	40	\N	\N	\N
41	6	1	41	\N	\N	\N
42	6	1	42	\N	\N	\N
43	6	1	43	\N	\N	\N
44	6	1	44	\N	\N	\N
45	6	1	45	\N	\N	\N
46	6	1	46	\N	\N	\N
47	6	1	47	\N	\N	\N
48	6	1	48	\N	\N	\N
49	6	1	49	\N	\N	\N
57	6	1	57	\N	\N	\N
58	6	1	58	\N	\N	\N
59	6	1	59	\N	\N	\N
60	6	1	60	\N	\N	\N
61	6	1	61	\N	\N	\N
62	6	1	62	\N	\N	\N
63	6	1	63	\N	\N	\N
64	5	1	64	\N	\N	\N
65	5	1	65	\N	\N	\N
66	5	1	66	\N	\N	\N
67	5	1	67	\N	\N	\N
68	5	1	68	\N	\N	\N
69	5	1	69	\N	\N	\N
70	5	1	70	\N	\N	\N
71	5	1	71	\N	\N	\N
72	5	1	72	\N	\N	\N
73	5	1	73	\N	\N	\N
74	5	1	74	\N	\N	\N
75	5	1	75	\N	\N	\N
76	5	1	76	\N	\N	\N
79	5	1	79	\N	\N	\N
80	5	1	80	\N	\N	\N
81	8	1	81	\N	\N	\N
82	8	1	82	\N	\N	\N
83	8	1	83	\N	\N	\N
84	8	1	84	\N	\N	\N
85	8	1	85	\N	\N	\N
86	8	1	86	\N	\N	\N
87	8	1	87	\N	\N	\N
88	8	1	88	\N	\N	\N
89	8	1	89	\N	\N	\N
90	8	1	90	\N	\N	\N
91	8	1	91	\N	\N	\N
181	5	1	181	\N	\N	\N
182	5	1	182	\N	\N	\N
183	5	1	183	\N	\N	\N
184	5	1	184	\N	\N	\N
185	5	1	185	\N	\N	\N
186	5	1	186	\N	\N	\N
190	5	1	190	\N	\N	\N
191	5	1	191	\N	\N	\N
192	5	1	192	\N	\N	\N
193	5	1	193	\N	\N	\N
194	5	1	194	\N	\N	\N
205	5	1	205	\N	\N	\N
206	5	1	206	\N	\N	\N
207	5	1	207	\N	\N	\N
208	5	1	208	\N	\N	\N
209	5	1	209	\N	\N	\N
210	5	1	210	\N	\N	\N
211	5	1	211	\N	\N	\N
212	5	1	212	\N	\N	\N
213	5	1	213	\N	\N	\N
214	5	1	214	\N	\N	\N
215	5	1	215	\N	\N	\N
216	5	1	216	\N	\N	\N
217	5	1	217	\N	\N	\N
218	5	1	218	\N	\N	\N
219	5	1	219	\N	\N	\N
220	5	1	220	\N	\N	\N
221	5	1	221	\N	\N	\N
222	5	1	222	\N	\N	\N
223	5	1	223	\N	\N	\N
224	5	1	224	\N	\N	\N
225	5	1	225	\N	\N	\N
226	5	1	226	\N	\N	\N
227	5	1	227	\N	\N	\N
228	5	1	228	\N	\N	\N
229	5	1	229	\N	\N	\N
230	5	1	230	\N	\N	\N
262	5	1	262	\N	\N	\N
263	5	1	263	\N	\N	\N
264	5	1	264	\N	\N	\N
265	5	1	265	\N	\N	\N
266	5	1	266	\N	\N	\N
267	5	1	267	\N	\N	\N
268	5	1	268	\N	\N	\N
269	5	1	269	\N	\N	\N
270	5	1	270	\N	\N	\N
271	5	1	271	\N	\N	\N
272	5	1	272	\N	\N	\N
273	5	1	273	\N	\N	\N
274	5	1	274	\N	\N	\N
275	5	1	275	\N	\N	\N
276	5	1	276	\N	\N	\N
277	5	1	277	\N	\N	\N
278	5	1	278	\N	\N	\N
279	5	1	279	\N	\N	\N
280	5	1	280	\N	\N	\N
281	5	1	281	\N	\N	\N
282	5	1	282	\N	\N	\N
283	5	1	283	\N	\N	\N
284	5	1	284	\N	\N	\N
285	5	1	285	\N	\N	\N
286	5	1	286	\N	\N	\N
287	5	1	287	\N	\N	\N
288	5	1	288	\N	\N	\N
289	5	1	289	\N	\N	\N
290	5	1	290	\N	\N	\N
291	5	1	291	\N	\N	\N
292	5	1	292	\N	\N	\N
293	5	1	293	\N	\N	\N
294	5	1	294	\N	\N	\N
295	5	1	295	\N	\N	\N
299	5	1	299	\N	\N	\N
300	5	1	300	\N	\N	\N
301	5	1	301	\N	\N	\N
302	5	1	302	\N	\N	\N
303	5	1	303	\N	\N	\N
304	5	1	304	\N	\N	\N
305	5	1	305	\N	\N	\N
306	5	1	306	\N	\N	\N
307	5	1	307	\N	\N	\N
308	5	1	308	\N	\N	\N
309	5	1	309	\N	\N	\N
310	5	1	310	\N	\N	\N
311	5	1	311	\N	\N	\N
312	5	1	312	\N	\N	\N
313	5	1	313	\N	\N	\N
314	5	1	314	\N	\N	\N
315	5	1	315	\N	\N	\N
316	5	1	316	\N	\N	\N
317	5	1	317	\N	\N	\N
318	5	1	318	\N	\N	\N
319	5	1	319	\N	\N	\N
320	5	1	320	\N	\N	\N
321	5	1	321	\N	\N	\N
322	5	1	322	\N	\N	\N
323	5	1	323	\N	\N	\N
324	5	1	324	\N	\N	\N
325	5	1	325	\N	\N	\N
326	5	1	326	\N	\N	\N
327	5	1	327	\N	\N	\N
328	5	1	328	\N	\N	\N
329	5	1	329	\N	\N	\N
330	5	1	330	\N	\N	\N
331	5	1	331	\N	\N	\N
332	5	1	332	\N	\N	\N
333	5	1	333	\N	\N	\N
171	6	1	171	\N	\N	\N
172	6	1	172	\N	\N	\N
173	6	1	173	\N	\N	\N
174	6	1	174	\N	\N	\N
175	6	1	175	\N	\N	\N
176	6	1	176	\N	\N	\N
177	6	1	177	\N	\N	\N
178	6	1	178	\N	\N	\N
179	6	1	179	\N	\N	\N
180	6	1	180	\N	\N	\N
195	8	1	195	\N	\N	\N
196	8	1	196	\N	\N	\N
197	8	1	197	\N	\N	\N
198	8	1	198	\N	\N	\N
199	8	1	199	\N	\N	\N
200	8	1	200	\N	\N	\N
201	8	1	201	\N	\N	\N
202	8	1	202	\N	\N	\N
203	8	1	203	\N	\N	\N
204	8	1	204	\N	\N	\N
231	8	1	231	\N	\N	\N
232	8	1	232	\N	\N	\N
233	8	1	233	\N	\N	\N
234	8	1	234	\N	\N	\N
235	8	1	235	\N	\N	\N
236	8	1	236	\N	\N	\N
237	8	1	237	\N	\N	\N
238	8	1	238	\N	\N	\N
239	8	1	239	\N	\N	\N
240	8	1	240	\N	\N	\N
\.


--
-- Data for Name: evidence; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evidence ("evidenceId", "evidenceSummary", "complianceId", "isApplicable", "evidenceNumber") FROM stdin;
142	Evidence of department M and M reviews particularly those that require mandatory reporting (meeting minutes, M and M register).	59	t	1
143	Evidence that the Clinical Audits and Mortality and Morbidity Reviews are presented at the CG Advisory Committee meetings and to the Board (meeting agenda, minutes).	59	t	2
145	Evidence that patients are given adequate information about their condition or the treatment that they will receive (e.g. documentation in notes, informed consent).	60	t	2
2	Documented, and signed GÇ£Roles & ResponsibilitiesGÇ¥ of the Chairperson and Deputy Chairperson.	1	t	1
113	Evidence of Board of Governance members leading/being a part of the CGAC (appointment letter/meeting minutes).	50	t	1
114	Evidence of Board of Governance meeting agendas with issues around patient safety and quality (meeting minutes).	50	t	2
116	Evidence of Director of Curative Services and Director of Public Health heading or as team members of the CGAC and subcommittees (appointment letters).	51	t	2
118	Evidence of CG action plans for the CG committees and Subcommittees.	51	t	4
120	Evidence of the flow of information and action taken on matters pertaining to patient safety and quality from the clinical wards to the CG committees (correspondence, registers, minutes).	52	t	1
122	Evidence of matters pertaining to patient safety and quality actioned at Board meetings (meeting agenda, minutes).	52	t	3
123	Evidence of an endorsed 'Code of Conduct' document.	53	t	1
125	Evidence that the 'Code of Conduct' is understood by the organisation's staff who know where to seek clarification if needed.	53	t	3
126	Evidence of monitoring of patient outcomes (e.g. mortality rates, readmission rates, surgical site infection rates).	54	t	1
131	There is a facility-wide peer-reviewed baseline accreditation survey conducted with >80% compliance in all domains.	55	t	3
132	There is a policy on patient confidentiality and privacy.	55	t	4
133	Evidence of current license to practice for all healthcare staff (records of doctors, nurses and other staff current annual licensing certificates).	56	t	1
136	Evidence of disciplinary action for a health worker-based issue.	56	t	4
137	There is evidence of a Critical Incident Monitoring System or committee (appointment letters, SOP, meeting agenda or minutes that discuss critical incidents).	57	t	1
138	There is evidence that the Quality Coordinator maintains a record of critical incidents and the pathway of reporting of critical incidences exists in the hospital and within the public health system (e.g. critical incident register, SOP of critical incident reporting pathway).	57	t	2
139	There is evidence that the reported critical incidents have been discussed or Root Cause Analysis done and the findings have been actioned.	57	t	3
140	There is evidence that the Board and the CG advisory committee are aware of the critical incidents report summary and actions taken (e.g. meeting agenda).	57	t	4
27	There is evidence of documented delegations for the CEO and other Executive Directors, Senior and Middle Managers, and other relevant staff which defines the extent of their delegated authority (see policy).	12	t	1
141	The Quality Coordinator maintains a register of clinical audits within the health facility addressing the standard of practice, identification of gaps, measurement of practice and improvement of practice.	58	t	1
149	Evidence that the Board of Governance and CEO's office via the CG Advisory Committee is informed about the numbers and subjects of patient complaints and litigation.	62	t	3
28	There is evidence that the Board of Governance has formal written job descriptions and key performance indicators (KPIs) for the CEO, Executive Directors, Senior and Middle ManagersGÇÖ and other relevant staff, to guide them in their respective positions.	12	t	2
29	There is evidence that the Board of Governance has protocols outlining \nthe appointment of acting CEO on each occasion of the CEOGÇÖs absence (see policy).	13	t	1
30	There is evidence of a formal appraisal of the CEOGÇÖs performance, which is linked to the positionGÇÖs job description and achievement of key performance indicators (KPIs).	14	t	1
154	The Organisation has a list of facilities with continuous power and water supply, and effective sanitation.	35	t	1
156	Evidence of a Board approved 5- year Health Workforce Plan aligned with the Corporate Plan and relevant to the health service and needs.	64	t	1
157	Evidence of an Integrated Organisational Structure with clear reporting lines (both clinical and non-clinical).	64	t	2
38	There is evidence of SEMTGÇÖs own performance reviews being undertaken regularly, with changes recorded within approved SEMT Minutes for the last meeting of each year (see meeting minutes).	16	t	1
26	There is evidence of recorded attendance for meetings (attendance sheet).	11	t	3
31	There is evidence of written guidelines outlining roles, functions and responsibilities of the Organizations' Senior Executive Management Team (SEMT).	15	t	1
32	The is evidence that Board of Governance has formally approved and established the Terms of Reference, and scheduled meetings for the Senior Executive Management Team (SEMT).	15	t	2
33	There is evidence of documented delegations which defines the extent of the SEMT authority.	15	t	3
34	There is evidence that a formal SEMT is meeting monthly, and holding extra-ordinary meetings, when needed.	15	t	4
35	SEMT meeting minutes are available and communicated in writing to all managers and staff, as well as all other relevant persons/stakeholders (e.g.: Health Partners).	15	t	5
36	All SEMT meeting minutes and documentations is reviewed by the CEO and reported to the Board of Governance (CEO initials on documentation, meeting minutes).	15	t	6
37	Implementation of SEMT decisions are monitored at subsequent meetings.	15	t	7
39	There is a Clinical and Public Health Governance Framework in the Organization (see document).	17	t	1
40	The Clinical and Public Health Governance Framework is available and communicated in writing to all managers, staff and other stakeholders (see evidence of communication).	17	t	2
41	There are joint meetings between the CEO, Directors of Curative and Public Health Services (see meeting minutes or schedules).	18	t	1
42	There is evidence of joint monitoring and reporting exercises coordinated by the office of the CEO, Directors of Curative and Public Health Services.	18	t	2
43	There are endorsed agreements (MOAs/MOUs) with relevant bodies, including relevant health care providers that provide support for Health Services and Public Health programs.	18	t	3
44	There is evidence of a mechanisms for regular review of professional licensing and professional competencies in service delivery.	18	t	4
45	Evidence that the CEO and Director of Corporate Services maintain and close working relationship. (see work correspondences on issues).	19	t	1
46	Policies (a) to (r) are available and approved by the Board.	19	t	2
47	Evidence that Corporate Services information is communicated in writing to all Organization managers and staff, and other relevant persons/stakeholders (e.g.: Health Partners).	19	t	3
48	There is evidence of regular performance assessments, of the Director Corporate Services recorded and approved by the Board of Governance.	19	t	4
49	There are endorsed agreements (MOAs/MOUs) with corporate support services in terms of finance, budgeting, HR management, training, procurement and medical supply chain, asset management, facilities maintenance, transport and fleet management, distribution and logistics, housekeeping and IT etc.	19	t	5
50	There are performance appraisals for the Directors of Public Health and Curative Services.	20	t	1
51	There are performance appraisals for other senior positions: Director of Medical Services (DMS), Director of Nursing Services (DNS), DFA and relevant others (e.g.: Internal Auditor, QA Coordinator, Legal Officer, etc).	20	t	2
52	There is evidence of (a) to (k).	21	t	1
53	There is Board approval for (a) to (k).	21	t	2
54	Evidence that the plans undergo a periodic review.	21	t	3
55	Evidence of CEOGÇÖs endorsement of individual AIPs within all the OrganisationGÇÖs health facilities and functional areas.	22	t	1
56	Formal implementation progress reviews of the AIPs are held on a quarterly basis (see reports).	22	t	2
57	Outcomes of the AIPs are reported quarterly to the SEMT and the Board of Governance (see reports or meeting minutes).	22	t	3
58	Evidence of CEO, SEMT and Board of Governance working closely with (a) to (e) (see correspondences, meeting minutes or reports).	23	t	1
59	Evidence of MoAs, MOUs or SLAs signed between the Board of Governance and;\nnâ¦\tCatholic Health Services\nnâ¦\tChristian Health Services\nnâ¦\tPrivately-run Health Services\nnâ¦\tNGO-run Health Services\nnâ¦\tCivil Societies\nnâ¦\tCorporate Partners\n	24	t	1
60	Number of regular quarterly Health Partnership Committee meeting conducted each year.	24	t	2
61	Number of submissions to Board from Health Partnership Committee meetings.	24	t	3
62	Evidence of meetings with community groups surrounding the health facility (meeting minutes).	25	t	1
63	Health facilities have fully functioning Health Facility Committees (meeting minutes).	25	t	2
64	Evidence of Terms of Reference (ToR) for the Health Infrastructure and Capital Projects Steering Committee.	26	t	1
65	Evidence of meetings conducted by the Steering Committee (meeting minutes).	26	t	2
66	Evidence of a 5-year Health Infrastructure & Capital Works Project Plan approved by the Board of Governance.	26	t	3
67	Evidence of Projects approved for funding by DNPM & Treasury.	26	t	4
68	Evidence that there is	26	t	5
69	Evidenced by establishment of a fully functioning Audit and Risks Committee.	27	t	1
70	Evidence of a risk matrix with regular input to the Board of Governance.	27	t	2
71	Evidence of unit Managers/OICs holding regular weekly staff meetings, that minutes of meetings recorded and decisions are being implemented.	28	t	1
73	Evidence of a 5-year Health Workforce Plan approved by the Board of Governance.	29	t	2
74	An integrated Payroll System is used.	29	t	3
72	HHR Unit is established and staffed appropriately with qualified HR personnel and functioning effectively.\n>\tFully functioning Counselling & Disciplinary System.\n> Recruitment, deployment, redundancy and retirement programs functioning effectively.\n	29	t	1
75	Evidence of a Health Training Resource Unit (HTRU) having been established, staffed appropriately with qualified training personnel and functioning effectively.	30	t	1
76	There is a 5-year Training Plan, which includes post- graduate and in-house training plans for all organisation employees, is approved by the Board of Governance.	30	t	2
77	There is a list of staff (clinical & non-clinical) successfully trained each year.	30	t	3
78	There are partnerships with Universities, Higher Schools of Education, Nursing & CHW Schools (see Memorandum of Understanding).	30	t	4
79	Evidence of regular 6-monthly assetGÇÖs inventory undertaken by physical check of assets against Asset Registers.	31	t	1
80	Evidence of a 5-year Fleet Management Plan that has been approved by the Board of Governance.	32	t	1
81	Evidence of fully functioning ambulance & other vehicles fleet management, with quarterly Fleet inspection, maintenance and operational reports.	32	t	2
82	Evidence of an approved 5-year Facility Maintenance Plan and Program approved by the Board of Governance.	33	t	1
83	Evidence of reports and evidence of Preventative Maintenance on all organisational facility buildings, staff houses/accommodation, medical equipment, static plants, etc.	33	t	2
84	Evidence of a 5-year ICT Services & Network Policy and Plan approved by the Board.	34	t	1
85	Documentation of organizational facilities with, and without, ICT coverage and provision of ICT services.	34	t	2
86	Evidence that plans reflect the Mission Statement, Goals and Objectives of the organisation.	36	t	1
87	There is evidence of staff consultation in producing the Corporate Plan. and formally distributed to other stakeholders.	37	t	1
88	Evidence that the organisations Corporate Plan are known to members of staff (presentation at annual meeting).	37	t	2
89	The Corporate Plan is circulated to other stakeholders (see circulation list).	37	t	3
90	Evidence that steps are being taken to implement the organisationGÇÖs 5- year strategic health services development plan and corporate plan.	38	t	1
91	Evidence that the organisationGÇÖs Corporate Plan is reviewed by the Board of Governance and, if appropriate, revised at least every five years.	39	t	1
92	Evidence that there is a documented and dated organisation structure showing all levels from the Board of Governance down.	40	t	1
93	Evidence that the organisational structure supports effective leadership, teamwork and integration of services.	40	t	2
94	Evidence that there are organisational policies for communication, i.e. all correspondence addressed to the CEO, handling of complaints.	40	t	3
95	Evidence that there is timely review of the Organisation structure every 3 years, or whenever it is required.	41	t	1
96	There is evidence of approved organisational by-laws and policies and procedures being consistent with the organisationGÇÖs mission statement, goals, statutory requirements and responsibilities.	42	t	1
97	Evidence that policies and procedures are being implemented throughout the health service, and compliance with them is being monitored on a regular quarterly basis. Evidence that copies of all policies and procedures are available work area and members of staff understand and use the policies	43	t	1
98	Evidence that copies of all policies and procedures are available work area and members of staff understand and use the policies	43	t	2
99	Evidence that all organisational policies and procedures are being reviewed, at least every three years and dated.	44	t	1
100	Evidence that the Board of Governance has approved a health program and projects monitoring and evaluation (M&E) framework.	45	t	1
101	Evidence that managers at all levels, are clearly monitoring and reporting program and project processes and relevant targets are being met.	45	t	2
102	Evidence that copies of relevant M&E reports are made available to the organisationGÇÖs CEO and Board of Governance on a regular quarterly basis.	45	t	3
103	Evidence that there is a Board approved patient rights and responsibilities policy.	46	t	1
104	Evidence that there is a policy regarding the handling of complaints from patient and staff, suppliers and other clients.	46	t	2
105	Evidence that the client complaint mechanism is publicly displayed the facility and through information pamphlets/sheets noting general information, contact numbers and language.	46	t	3
106	Evidence that the Board is informed on a quarterly basis, about the numbers and subjects of patient complaints and litigation (meeting agenda, minutes or reports).	46	t	4
107	It is evident that staff members treat patients/clients with respect, are polite and helpful (observe, interview patients).	47	t	1
108	Patient privacy and confidentiality are maintained through the Organisation (observe).	47	t	2
109	Evidence that the Board of Governance has approved a policy for dealing with ethical issues.	48	t	1
110	Evidence of all research being approved by the Board of Governance.\nNB: Ask if there are any research projects?\nNB: The NDOH Medical Research Advisory Committee serves as the National Ethical Advisory Clearing Committee to support organisations.  \n	49	t	1
111	Sight approvals by NDOHGÇÖs Medical Research Advisory Committee for research projects.	49	t	2
112	Evidence of collaboration with Professional and Regulatory Bodies on various research activities.	49	t	3
121	Evidence of the flow of information and action taken on matters pertaining to patient safety and quality from rural facilities and public health programmes to CG committees (correspondence, registers, minutes).	52	t	2
124	Evidence that the 'Code of Conduct' document can be accessed by all staff.	53	t	2
127	There is evidence of usage of data to measure service effectiveness, e.g. waiting times, operating theatre utilization rates, service utilization rates.	54	t	2
128	Evidence of engagement with NGOs, private and business sectors to develop and implement health service delivery solutions (MOUs, service-level agreements).	54	t	3
129	There is evidence of completing the level-appropriate Integrated Supervisory Checklist.	55	t	1
130	There is evidence of having completed the Health Facility Rapid Assessment Tool.	55	t	2
134	Job descriptions exist for different cadres.	56	t	2
135	Evidence of Credentialing and Privileging for Medical Professionals (minutes of C and P meeting).	56	t	3
144	Evidence of a current and approved Standard Treatment Guidelines in different clinical areas and the staff are aware of these guidelines.	60	t	1
146	Evidence that there is a supervisor or mentor for new or junior staff.	61	t	1
147	Evidence of a policy that outlines the rights and responsibilities of patients.	62	t	1
148	Evidence of a SOP/protocol to deal with patient complaints.	62	t	2
150	Evidence that clients/consumers and their families/carers are aware of the complaints procedure and feel comfortable using it.	62	t	4
151	Evidence of annual internal audit report that tracks Clinical Public Health Governance Framework performance indicators.	63	t	1
152	Evidence of quarterly report from all CG subcommittees and CG Advisory Committee.	63	t	2
153	Evidence that the CG reports are sent to the Medical Standards and Compliance Branch annually.	63	t	3
1	Evidence of letters and copies of the relevant gazette, and/or new article(s) to confirm the appointments of the Governing body.	1	t	2
3	Governing Body meeting minutes verify appointment of Chairperson and Deputy Chairperson which are published or gazetted.	1	t	3
155	The Organisation has a list of facilities with proper sanitation.	35	t	2
158	Evidence of coordination with other partners that support and compliment health resource needs in the Organisation.	64	t	3
159	Evidence that staff recruitment is based on merit and in accordance with policy.	65	t	1
160	Evidence that all managers have qualifications and experience appropriate to their area of work.	65	t	2
115	Evidence of establishment of provincial CG advisory committee (CGAC) and subcommittees (appointment letters).	51	t	1
117	Evidence of an endorsed provincial CG manual.	51	t	3
119	Evidence of district-level CG committees and action plans.	51	t	5
161	Evidence of gender equality in the appointment of staff positions.	65	t	3
162	Staff have dated job descriptions which are available at the workplace.	65	t	4
163	Staff have acknowledged receipt of their job descriptions.	65	t	5
164	There is a probationary period usually three months with documented appraisals.	65	t	6
165	There are personal files for each employee which are up to date and confidentially stored.	65	t	7
166	Evidence of an annually reviewed Health Workforce Plan with recommendations for the Governing Board.	66	t	1
167	Evidence of an annually reviewed Health Workforce Training Plan being implemented within the PHA.	67	t	1
168	Evidence that there are guidelines for staff who have undergone training to Implement their knowledge and skills.	67	t	2
169	Evidence of the use of the WISN tool to determine the correct numbers and skill mix for health workers.	68	t	1
182	Evidence of a Training Policy approved by the Board of Governance.	75	t	1
183	Evidence of the approved Policy stating that the Organisation accords each health worker a minimum of 3 working days of training per year.	75	t	2
184	Evidence of a 5 year GÇ£Training and Development PlanGÇ¥ approved by the Board.	75	t	3
185	Evidence of a standard GÇ£inductionGÇ¥ or orientation programme for all new employees about the organisationGÇÖs mission, vision and general expectations.	76	t	1
186	Evidence of mandatory training programmes with registers of staff who have attended the training.	76	t	2
187	Evidence of a functioning training and resource centre offering upskilling and continuous professional development activities.	77	t	1
188	Evidence of staff training reports being circulated to the CEO and Board.	77	t	2
4	Governing Body have established these Committees, each with clearly defined GÇ£Roles & ResponsibilitiesGÇ¥;\nnâÿ\tInternal Audit Committee\nnâÿ\tPartnership Committee\nnâÿ\tCorporate Services Committee\nnâÿ\tCurative Health Services Committee\nnâÿ\tPublic Health Services Committee\nnâÿ\tCapital Works Committee\nnâÿ\tFinance and Budget Committee	1	t	4
5	Documented statement showing Members & Officers appointed to Governing Body Committee understand, accept and signed their roles and responsibilities.	1	t	5
170	Evidence that the Organisation has collaborated with the NDOH in the orientation and implementation of the WISN methodology for their officers.	68	t	2
189	Evidence of an agreed and funded training calender for clinical and non-clinical in- service training on an annual basis.	77	t	3
171	Evidence of Organisation having minimum GÇ£Hospital Health SpecialistsGÇ¥ which is reflected in the Integrated Organisation structure.	69	t	1
172	Evidence of copies of Board of Governance approvals for GÇ£Hospital Health SpecialistGÇ¥ positions.	69	t	2
7	There is evidence of an orientation program for new members of the Board of Governance (see attendance list and orientation programme agenda).	2	t	1
173	Evidence of a functioning GÇÿHealth Workforce Risk Management planGÇÖ and guidelines for tracking the process, being monitored on a quarterly basis by CEO and Board of Governance.	70	t	1
174	Evidence of an industrial relation policy with mechanisms of addressing staff concerns.	70	t	2
175	Evidence of a Board approved OHS&S Policy and procedure.	71	t	1
176	Evidence of performance appraisals being conducted on an annual basis for all individual health staff (clinical and non-clinical) against their job descriptions.	72	t	1
177	Evidence that there are relevant training and upskilling courses and that there is a system of continuous professional development in place which is monitored by the Training Unit and reported to the Board of Governance	72	t	2
178	Evidence of Health Workforce Productivity and Performance policies and systems with reporting mechanisms to the Board.	73	t	1
190	Evidence of GÇ£Training Needs Analysis conducted on an annual basis on an annual basis, in conjunction with individual health workersGÇÖ performance appraisals.	78	t	1
191	Evidence of the annual review of all clinical and non-clinical training curricula to ensure currency with work requirements at all health staff levels of the organisation.	79	t	1
192	Evidence that copies of the training curriculum review reports are sighted by the CEO and Board.	79	t	2
8	There is evidence that members of the Board of Governance have attended relevant seminars, conferences, lectures.	3	t	1
9	There is evidence that the members of the Board of Governance have adopted a Vision, Mission and Goals consistent with relevant health priorities, polices and legislation.	4	t	1
10	The OrganisationGÇÖs Vision, Mission and Goals are clearly visible and have been put up in the organization's premises, and displayed in letterheads and internal newsletters.	4	t	2
11	There is evidence that the Board of Governance has discussed the organization's achievements, quality of care and the use of resources for the organisation. (e.g. meeting minutes).	5	t	1
12	There is evidence of scheduled meetings of the Board of Governance, at least 4 times a year.	7	t	1
13	There is evidence of Board of Governance meeting minutes having been kept in accordance with relevant By-laws and Policies.	7	t	2
14	There is evidence of documented delegations from the Board of Governance to the Chairman or Deputy Chairman, or to the CEO to make decisions between meetings and confirmed in writing.	7	t	3
15	There is evidence of written signed agreements (MOAs/MOUs/SLAs) with relevant health care providers, health partners and other stakeholders in the province.	6	t	1
16	There is evidence of communication with surrounding communities sighted by the Board.	6	t	2
18	There is evidence that the Board of Governance has established committees and subcommittees.	8	t	1
19	There is evidence that the Board of Governance has approved established terms of reference, membership, and defined meeting procedures for all its committees and sub-committees.	8	t	2
20	There is evidence that all committee and sub-committee meeting minutes, are referred to and dealt with by the Board of Governance (see meeting minutes).	8	t	3
21	There is evidence that all decisions of the Board of Governance are being communicated to the relevant persons in writing (see examples)	9	t	1
22	There is evidence that implementation of decisions is monitored at subsequent meetings of the Board of Governance.	9	t	2
23	There is evidence of the Board of Governance undertaking regular own-performance reviews and acting on the findings.	10	t	1
24	There is evidence of existing policy for senior and middle management or nominated officers for their attendance, roles and functions during scheduled meetings.	11	t	1
25	There is evidence of the Board of Governance requiring its principal advisors (the CEO, Executive Directors, Senior and Middle Managers  other staff) to attend Board of Governance meetings or Sub-Committees (see policy/circular).	11	t	2
193	Evidence of stakeholder engagement with training and development partners within and external to the province.	80	t	1
194	Evidence that the CEO and Board have sighted the stakeholder engagement reports.	80	t	2
231	The design of the building conforms to relevant building codes and regulations.	94	t	1
232	Visual inspection of (a) to (g) shows evidence of appropriate internal roads for the facility.	95	t	1
233	Visual inspection of (a) to (g) shows evidence of appropriate walkways for the facility.	96	t	1
179	There is evidence of productivity management of all health staff by managers, reviewed on a regular quarterly basis with proposed recommendations to the Board of Governance.	73	t	2
180	Evidence of approved GÇ£career paths and succession planningGÇ¥ processes implemented within the Organisation.	74	t	1
181	Evidence of regular collaborative monitoring and reporting to the Board of all potential health staff available for undertaking the most critical roles within the organisation (eg: CEO position, Executive Director positions, CFO, HRM, HRD and DHM positions, etc).	74	t	2
195	There is evidence of accurate usage data from stock records against actual and forecast morbidity data. (see records and data).	81	t	1
196	Evidence of supply planning criteria prior to requisition of supplies. (interview)	82	t	1
197	Evidence of the use of M- supply system to monitor stock status. (interview and observation)	82	t	2
198	Evidence of consultations with programme managers on annual programme stock (HIV, Malaria, TB, Vaccines) (see emails or meeting minutes).	82	t	3
199	There is a designated officer in charge of the store.	83	t	1
200	Evidence of stock accountability: see stock register for receipt and issue records.	83	t	2
201	Evidence of periodic stock- takes to match physical stocks and stocks on register (see reports).	83	t	3
202	The floor layout, shelving and space for pallets are adequate for the optimal storage of medical supplies.	83	t	4
203	Evidence that items that need refrigerated/cold room conditions have adequate, well managed space and there is a constant supply of electricity (AC and DC current via a standby generator).	83	t	5
204	Evidence that there is a demarcated area to store empty and filled medical gas cylinders.	83	t	6
205	Evidence of FEFO (First to Expire First to be issued) practice for all products with a manufacturer specified shelf life.	83	t	7
206	Evidence of documentation of average monthly use, lead time, minimum and maximum stock levels.	84	t	1
207	Evidence of maintenance of stock levels between Minimum Stock Level and Maximum Stock Levels for each item.	84	t	2
208	Evidence that product expiry management procedures are being utilised.	85	t	1
209	Evidence of appropriate expired stock disposal.	85	t	2
210	Evidence of an Organisational drugs and medical supplies chain master plan.	86	t	1
211	Evidence of an annual procurement planning exercise (meeting minutes or reports) within the set annual time frames.	87	t	1
212	Evidence of budgetary planning for the estimated needs (reports)	87	t	2
213	Evidence that procurement of drugs and medical supplies is consistent with the latest available NDOH Medical Supply Catalogue.	87	t	3
214	Evidence of policy or guidelines for medical supplies distribution.	88	t	1
215	Evidence of a tender process that awards distribution contracts to qualified tenderers.	88	t	2
216	Evidence of safety measures that are included in the tender and the contract to ensure the quality of goods is safeguarded by the contractor/s during transportation.	88	t	3
217	Evidence of a comprehensive data base for purchase order management (including expected delivery dates, actual delivery dates, alerts that signal receipt delays, reconciling with delivery invoices and supplier performance assessments).	89	t	1
218	Evidence of supplier performance assessments being carried out and becoming a criterion for procurement evaluations. (see reports)	89	t	2
219	Evidence that there is a clear indication of payment terms in invitations to bid for anticipated procurement of drugs and medical supplies (see the invitation to bid).	90	t	1
220	Evidence of a clear indication of supplierGÇÖs terms and conditions in their bids (see example of payment bids).	90	t	2
221	Evidence of appropriate layout, shelves, pallets and handling equipment (observation).	91	t	1
222	Evidence of appropriate space with all the necessary storage areas (observation).	91	t	2
223	Evidence of the smooth movements through the warehouse, including incoming goods, customer orders (requisitions), inter-facility transfers, dispatches, and returns (observation, interviews).	91	t	3
224	Evidence of a procedure to check whether goods received conform to the terms and conditions specified in the purchase (see SOP, observe, interview)	92	t	1
225	Evidence that the receiving area is cleared of goods received as soon as possible and goods are moved to a holding area (see SOP, observe, interview).	92	t	2
226	Evidence that there is a supervised procedure in place to check quantities received as per delivery notes and against quantities (see SOP, observe, interview)	92	t	3
227	Evidence information in the Logistics Management Information System (LMIS)/ m-Supply is entered promptly and to convey information and documentation to the procuring entity. (check the LMIS)	92	t	4
228	Evidence of preparation of a weekly picking schedule for the warehouse by the Warehouse Manager (see schedule).	93	t	1
229	Evidence of all items picked are moved to the packing area as soon as possible and packed ready for dispatch in clearly labelled boxes/containers (observation).	93	t	2
230	Evidence of accurate entries made in m-Supply or equivalent, and entries confirmed by a supervisor (see m-Supply entry).	93	t	3
234	The plant and permanent fixtures are maintained by a qualified individual (see credentials and job description).	97	t	1
235	The plant and permanent fixtures are safe for use (visual inspection).	97	t	2
236	Permanent fixtures are installed according to manufacturersGÇÖ instructions (review example of instructions and fixture).	97	t	3
237	Evidence of Completion of the Rapid Assessment Tool.	98	t	1
238	Evidence that signages and directions are visible and clear to access services.	99	t	1
239	Evidence of disability appropriate signage which includes the use of multilingual / international symbols (should be height appropriate, have tactile features, pictograms).	100	t	1
240	Presence of accessible toilets with signage.	100	t	2
241	Presence of ramps and adequate space in areas catering to disability services	100	t	3
242	Evidence of a SOP to report incidents relating to buildings, roads, walkways, plant, medical devices, equipment, consumables and supplies.	101	t	1
243	Evidence that staff (clinical and non-clinical) know where to access this SOP (interview).	101	t	2
244	Evidence of compliance to building codes for fire safety.	102	t	1
245	Annual fire safety inspection report from the local fire brigade.	103	t	1
246	Evidence that the organisation takes action to implement the recommendations from the local fire brigade.	103	t	2
247	Evidence that the fire hoses / extinguishers are in the appropriate locations in the areas of work (observe).	104	t	1
248	Evidence that extinguishers have current service tags.	104	t	2
249	Evidence that the fire extinguisher is listed on the asset register.	104	t	3
250	Evidence that fire hoses are checked at least quarterly (documented record).	104	t	4
251	Fire exits are free from obstruction.	105	t	1
252	Fire exit doors open from the inside and is not locked.	105	t	2
253	Register of annual fire safety training.	106	t	1
254	Staff know how to use a fire extinguisher (interview)	106	t	2
255	There is a facility emergency fire plan (review plan).	107	t	1
256	Staff are aware of what to so in the case of the fire (interview).	107	t	2
257	There are mock fire drills (see records).	107	t	3
258	There is safe storage of flammable material (observe, interview).	108	t	1
259	There are no smoking signs around the facility premises.	109	t	1
260	There are no people smoking/chewing betelnut within the facility premises.	109	t	2
261	Register of staff trained for specialised equipment (review training register).	110	t	1
262	A current inventory is maintained for medical supplies and consumables (review inventory).	111	t	1
263	Evidence of an assessment process to procure equipment (review report).	112	t	1
264	Evidence that the manufacturerGÇÖs instructions were followed in the installation, testing and commissioning of equipment.	113	t	1
265	Evidence that installation, testing and commissioning of equipment were done by a qualified individual.	113	t	2
266	There is a record of maintenance for equipment.	114	t	1
267	There is a record of equipment that requires upgrading, replacement and procurement.	114	t	2
268	Evidence of vehicle procurement records.	115	t	1
269	Evidence of requirements for vehicle operators.	115	t	2
270	Evidence of documentation of required training and licenses to operate the vehicle.	115	t	3
271	Records of patient transfer.	115	t	4
272	Records of transfer of health records, medications, equipment or supplies.	115	t	5
273	Inspection of vehicles for safety features (seating, seat belts etc.).	115	t	6
274	Incident reports for incidents involving vehicles.	115	t	7
275	Evidence that medical devices are installed, calibrated, maintained, repaired and decommissioned and disposed of by qualified individuals.	116	t	1
276	Medical devices are operated by staff who have received necessary training and/or licensing (see training records for equipment).	116	t	2
277	Evidence that clinical teams demonstrate safe use and maintenance of medical devices for patent monitoring including bedside monitors, telemetry monitors, etc. (observation)	116	t	3
278	Evidence that clinical teams demonstrate safe use and maintenance of devices for treatment: lasers, electrosurgery, diathermy, etc.	116	t	4
279	Evidence that pathology teams demonstrate safe use and maintenance of diagnostics devices for pathology, laboratory analysers, radiology equipment, endoscopes, etc.	116	t	5
280	Evidence that medical devices undergo calibration when necessary (review log).	116	t	6
281	Evidence that the medical devices are cleaned and sterilised separately from general cleaning (observe).	117	t	1
282	Evidence of policies for the procurement of medical supplies.	118	t	1
283	Evidence of policies for ordering, delivery and distribution of medical supplies.	118	t	2
284	Evidence of policies for the storage and inventory control of medical supplies.	118	t	3
285	Evidence of policies for the reuse of items.	118	t	4
286	Evidence of policies for the recall of items.	118	t	5
287	There is a schedule for preventive maintenance for equipment within the Facility.	119	t	1
288	If maintenance and cleaning cannot be carried out according to schedule, there is documentation of the reason (see maintenance log).	119	t	2
289	There is a schedule for cleaning of items.	120	t	1
290	Barriers are in place when maintenance or cleaning is carried out.	120	t	2
291	Evidence that cleaning, maintenance of equipment, waste management areas and grounds are done by qualified personnel (interview, maintenance records).	121	t	1
292	There is proper signage or labels for hazardous materials.	122	t	1
293	Staff (clinical and non-clinical) know how to handle hazardous materials (observe and interview)	122	t	2
294	There is provision of necessary personal protective equipment, and other relevant equipment to handle hazardous material (observe).	122	t	3
295	Evidence that staff have access to Safety Data Sheets and other relevant resources include processes for managing a related emergency, such as a spill or an accidental exposure.	122	t	4
344	There are Terms of Reference for the Project Steering Committee.	135	t	1
296	There is monitoring of compliance with safe practice requirements and remedial action taken where required (review of incident reports, complaints)	122	t	5
297	There is a designated radiation safety officer.	122	t	6
298	The radiation safety plan is coordinated with external authorities (see meeting minutes or MoU)	123	t	1
299	There is a personal radiation monitoring system and monitoring of relevant rooms.	123	t	2
300	There are measures to keep patient radiation exposure to a minimum.	123	t	3
301	There are measures to keep staff radiation exposure to a minimum.	123	t	4
302	Evidence of a current assets register (the condition, availability and performance).	124	t	1
303	Evidence of a designated officer to manage the assets register.	124	t	2
304	Evidence that new items are recorded in asset registration.	124	t	3
305	The asset register contains information on plants, equipment and biomedical devices.	124	t	4
306	There is an asset disposal strategy.	124	t	5
307	Evidence of an organisation-wide system to identify major security and implement controls (meeting minutes or reports addressing security).	125	t	1
308	Evidence of Memorandum of Agreement for provision of security services if external services are used.	125	t	2
309	Evidence that potential high-risk areas emergency department, treatment GÇô procedure rooms; plant rooms; pharmacies and drug storage areas, ATMs) have been considered in the planning of security measures (meeting minutes).	125	t	3
310	There is lighting in potential risk areas, such as car parks, access paths and storage facilities	125	t	4
311	There is installation and monitoring of security cameras	125	t	5
312	Evidence of installation of personal / duress alarms, with connection to the police or other appropriate response teams	125	t	6
313	Evidence of installation of physical barriers, such as security glass in specific areas	125	t	7
314	Evidence of escape routes.	125	t	8
315	Evidence of access restriction to certain areas using swipe cards or code pads.	125	t	9
316	Evidence that external service providers understand and comply with the organisationGÇÖs security controls and procedure (observe and interview)	125	t	10
317	There is evidence of steps taken to address GÇ£zero aggressionGÇ¥ to all levels of staff (signages, training sessions)	125	t	11
318	Evidence of monitoring water and energy use (reports).	126	t	1
319	Evidence that there are efforts to improve efficiency (e.g. purchasing electrical equipment with a high energy rating, programmes to conserve energy and water -switching off equipment, good plumbing maintenance, etc.) (reports, interviews).	126	t	2
320	Evidence of documented contingency plans to address utility failures (see SOP or policy).	126	t	3
321	Documents (a) to (i) have been circulated and read, understood, by the relevant officers as evidenced by the initialling of the relevant officer after reading.	127	t	1
322	Circulars issued by Department of Treasury (DoT), Department of Finance (DoF), Department of National Planning and Monitoring (DNPM), Department of Personal Management (DPM), key PHA Corporate officers and divisional managers are read and implemented (see initialling after reading).	128	t	1
323	There is evidence of compliance with the national budget timetable, reporting timelines and quarterly reviews (review reports).	128	t	2
324	Evidence that budget estimates are prepared with input from district health managers, directors, hospital CEOs, hospital management and corporate staff (see meeting minutes, emails).	129	t	1
325	Evidence that budget estimates are relevant and against a checklist.	129	t	2
326	Evidence that final annual budget and forward year expenditure and revenue estimates align to provincial service delivery plans (see costed annual implementation plans), approved by the PHA board.	129	t	3
327	Evidence of annual implementation plans and procurement plans prepared in detail by major cost centres (provincial and district hospitals, CSS, public health and curative health divisions and by district health managers).	129	t	4
328	Evidence of monthly cash flow forecasts for all cost centres are reviewed and submitted through the Board of Governance and CEO to Central Ministries (see meeting minutes/ reports).	130	t	1
329	Evidence of dedicated Finance team follow up on weekly and monthly warrant authorities and cash disbursements anticipated from Central Ministries (see reports).	130	t	2
330	The Finance and Budget Committee ensure that cash disbursements and reprioritisations of cash/payments are conducted to fulfil the requirement to keep health facilities open and operational (see meeting minutes and reports).	130	t	3
331	Quarterly financial performance reviews are sent to the Board of Governance (see reports).	130	t	4
332	Evidence of CEOGÇÖs delegation of authority to Account Officers to authorise payments and collect revenues on behalf of the organisation. (see letter of authorisation).	131	t	1
333	Evidence of delegated authority to financial delegates to provide advice and implement spending decisions of requisition officers. (see letter of authorisation).	131	t	2
334	Evidence of delegation of authority to Section 32 officers to approve requisitions in line with the specified financial limits across operational budgets, maintenance, capital purchases and capital works. (see letter of authorisation).	131	t	3
335	The CEO and Corporate Director have the contact details of senior officers in DNPM, DoT and DoF (evidence of work email addresses and numbers).	132	t	1
336	Evidence of regular meetings or correspondence with these agencies and DPM key officers. (see email correspondences or meeting minutes)	132	t	2
337	Evidence of follow-up on budget submissions, warrant authorities, cash disbursements, procurement processes and HR processes. (see email correspondences).	132	t	3
338	Evidence of communication with Provincial and District Administration (see email or meeting minutes).	133	t	1
339	Evidence of a Terms of Reference for the Finance and Budget Committee approved by SEM and Board of Governance.	134	t	1
340	There is a scheduled timetable for Finance and Budget Committee meetings (see timetable).	134	t	2
341	Minutes of Committee meetings are escalated to the Board of Governance and CEO for review.	134	t	3
342	Committee meet on budget formulation and budget implementation (see meeting agenda)	134	t	4
343	Circulars, instructions and internal memos issued through the Committee are sent to the rest of the organisation (see email or circulars).	134	t	5
345	Meeting minutes of the PSC demonstrate discussion on the development health infrastructure.	135	t	2
346	Reports from the PSC meetings are reported to the Board of Governance.	135	t	3
347	There are Terms of Reference developed for the Committee and approved by SEM and Board of Governance.	136	t	1
348	Evidence of meeting schedule set up for the Committee annually.	136	t	2
349	Meeting minutes indicate discussions on risk management, governance and internal control systems for the organisation.	136	t	3
350	Evidence that the CEO is aware of his role in PFM, reporting structures, format of reporting and the use of financial reports (interview).	137	t	1
351	Evidence of quarterly reviews of financial performance (see reports)	138	t	1
352	Internal quarterly Integrated Financial Management Systems (IFMS) reports are prepared by the Corporate Director and the Finance Committee, for presentation to Finance Committee and PHA board	138	t	2
353	Evidence of Board approval for budget estimates.	139	t	1
354	Evidence of Board approval for annual financial statements.	139	t	2
355	There is an annual internal timetable by the Finance Committee for responsible officers to submit to plan for mandatory quarterly internal reporting.	140	t	1
356	There is a gazetted fee structure with;\nspecific charges to designated services across different facility levels.\n(b)any services to be provided free of charge.	141	t	1
357	User Fees and No Fees Structures are displayed on Signboards within Health Facility outpatient and patient services waiting area.	141	t	2
358	User Fees and No Fees Structures are announce publicly and regularly, daily.	141	t	3
359	There are consultations between the financial team and Provincial and District administrations to ensure that income receipts are provided by Provincial and District Administrations, in line with forecasted requirements (evidence of meeting minutes/reports).	142	t	1
360	Evidence of discussion for potential delays in receipts of income for internal reprioritisation of available funds for specific pre-approved purposes and commitments (evidence of communication/ emails/reports)	142	t	2
361	There is an internal operating accounts manual/guideline.	143	t	1
362	The manual highlights (a) to (g).	143	t	2
363	Evidence of documents (a) to (e).	144	t	1
364	There is a designated staff managing the HSIP account.	144	t	2
365	Evidence of weekly and regular bank reconciliations.	145	t	1
366	Evidence that the bank reconciliation report is updated in IFMS.	145	t	2
367	Reconciliation of cash book entries and bank statement entries conducted.	145	t	3
368	Evidence that bank reconciliations are prepared regularly by Public Bodies and submitted to DoF 14 days after the end of each month.	145	t	4
369	End of year financial accounts and statements are prepared.	145	t	5
370	Evidence that accounts officers maintain summaries of requests for budget adjustments (see summaries).	146	t	1
371	There is evidence of Board approved guidelines for budget adjustments.	146	t	2
372	The guidelines should be circulated to (a) to (e). (see circulation list)	146	t	3
373	Performance and management plans are prepared annually for submission to DoF (see plans).	147	t	1
374	Financial statements are prepared before the end of each financial year, in a format specified by Finance and in line with the Audit Act 1989 (inspect financial statements)	147	t	2
375	An annual report is sent to the Minister for Health and the Governor of the Province on the performance of its functions and duties under the PHA Act (see report).	147	t	3
376	The annual report is expected to be submitted by the 31st of May against the previous yearGÇÖs calendar year performance (see date of submission).	147	t	4
377	Evidence of accounting qualification for account and audit staff (see qualification).	148	t	1
378	Copy of the PFM Manual is available.	149	t	1
379	Relevant officers are aware where to access the PFM Manual	149	t	2
380	Evidence of attendance to financial training run by Central agencies.	150	t	1
381	Evidence of attendance to financial training run by donor partner programmes.	151	t	1
382	Evidence of a Board approved 5-year Information and Communications Technology (ICT) Plan aligning to the Strategic Development Plan.	152	t	1
383	Evidence of copies of relevant ICT plans and processes in all health facilities within the Organisation which are regularly reviewed (1-2 years).	152	t	2
384	Evidence of copies of relevant ICT reports are made available to the CEO and the Board on a regular basis.	152	t	3
385	Evidence of audits to confirm the integrity of data systems through data security measures and reliability of computer hardware.	152	t	4
386	Data stored in computers are backed up regularly and stored in a secure location.	152	t	5
387	Evidence of Board approved GÇ£Record Management GÇ£policies related to the keeping, accessing, storage, archiving, security and disposalGÇ¥ of all records within the Organisation.	153	t	1
388	Copies of relevant policies, processes and procedures are available within all health facilities within the Organisation.	153	t	2
389	Evidence of regular data audits to confirm the accuracy of data entry.	153	t	3
390	Medical records are filed appropriately and easy to retrieve.	153	t	4
391	Medical Records Department area is secure and access is limited.	153	t	5
392	Evidence of inpatient record with an identification page, diagnostic reports, drug prescription sheet, nursing sheet, medical notes, consent forms, etc. with a final diagnosis and code.	154	t	1
393	If a GÇÿHelt BukGÇ¥ is used as the primary record, evidence of supplementary records which identifies minimally the date of presentation, patientGÇÖs name, treating clinician and the presenting condition must be maintained by the facility.	154	t	2
394	Every patient has a GÇ£unique patient identifierGÇ¥ to identify their records.	154	t	3
395	Medical staff record details of orders and treatment in the notes with sign and date. Writing must be legible.	154	t	4
396	Original of letters to the health service, X-ray and pathology reports etc. are filed in the records as soon as they are available.	154	t	5
397	Procedure for obtaining patientGÇÖs records during readmission is available in the medical record department during and after office hours.	154	t	6
398	The final diagnosis is completed in 7 days.	154	t	7
399	Collected information (statistics on type and number of patients) is available to staff to assist with patient care.	155	t	1
400	Wards and departments collect information about their patients (e.g. numbers admitted, number of deaths, number of positive STDs in Pathology dept).	155	t	2
401	There are Board-approved policies on patient confidentiality and staff are aware where they are.	156	t	1
402	Access to patient information is limited to the GÇ£people who need to knowGÇ¥ e.g. doctors, nurses, allied staff.	156	t	2
403	Evidence of policies on the production and reproduction of medical records (no copies of records are provided to legal/insurance/other medical practitioners without patient/guardian consent).	156	t	3
404	In computerised health services, patientGÇÖs records systems have restricted access (e.g. password protected).	156	t	4
405	Statutory notifications (e.g. infectious diseases) are reported to the Department of Health within required times.	156	t	5
406	Evidence that a common hospital patient information management system is being considered by the Organisation or has been implemented.	157	t	1
407	Evidence of technology supporting secure transmission of voice and data between two or more health care locations using digital telecommunications.	158	t	1
408	Evidence of review of existing computer operating systems and applications, including those that are nearing the end of their license periods or which are no longer supported. (both clinical and corporate systems).	159	t	1
409	The OrganisationGÇÖs Health Information Officer plays a role in compiling and disseminating essential data to the Management and relevant units.	160	t	1
410	Evidence of sharing of information via technology between departments and clinicians (e.g. between ward clinicians and radiology or pathology, between rural and provincial health facility).	160	t	2
411	Easily accessible clinical information is available to identify trends, including studying the impact of interventions and informing research (e.g. dashboards).	160	t	3
412	There is ongoing education and training of staff to use electronic systems (including e-NHIS and other applications).	161	t	1
413	Evidence of staff training in ICD coding.	161	t	2
414	Evidence of stakeholder engagement in the development of the OrganisationGÇÖs Health Services Plan (meeting minutes).	162	t	1
415	Evidence of a current 5- year Health Services Plan.	162	t	2
416	Evidence of a prioritisation of resource allocation identified through the health service planning process.	162	t	3
417	Evidence of an approved public health services plan that addresses points a.) to g.).	163	t	1
418	Evidence of a discipline- specific approved clinical services plan that address point a) to b).	164	t	1
419	Evidence that the Clinical Services plan encompasses the point a) to b).	165	t	1
420	Evidence that the health care Organisation has officers with project management skills to help control costs, manage risk, and improve project outcomes.	166	t	1
421	Evidence that the Project Management Officer provide practical and pragmatic approaches for implementing project management within the Organisation.	166	t	2
422	Evidence that the Health Service Organisation demonstrates sound project management practices (includes conception and initiation, planning, execution, performance/monitoring, and project closure. Key deliverables are achieved.	166	t	3
423	The Board has approved the Terms of Reference for a GÇ£Partnerships CommitteeGÇ¥.	167	t	1
424	Evidence of the appointment of the Board of Governance representative has been minuted.	168	t	1
425	Evidence that the Partnerships Committee meets on a quarterly basis, or more if required (meeting schedule or minutes).	169	t	1
426	Evidence that the Board of Governance reviews papers and recommendations from the Partnerships Committee (meeting minutes).	170	t	1
427	Evidence that the PHA has women representation on the partnership committee.	171	t	1
428	Evidence that Provincial Administration and DDA CEOs attend meetings of the Partnerships Committee (reports, meeting minutes).	172	t	1
429	Evidence that all partners, including Church Health Services, NGOs and Private Sector Partners participant in Annual Planning and budgeting meetings, and Provincial Reviews (meeting minutes or reports).	173	t	1
430	Evidence of details of planned activity with partners and funding source have been specified in the Service Agreement.	174	t	1
431	Evidence that partners have the required qualifications and experience needed to deliver the specified services.	175	t	1
432	Evidence that the agreement includes a clause on these policies.	176	t	1
433	Evidence that partner activities are captured in the e-NHIS.	177	t	1
434	The Health Service Organisation must ensure that all partners are providing necessary reports to support compliance with PFMA requirements.	178	t	1
435	Evidence that partners are submitting their updated annual registration information of their health practitioners to the Medical Board and Nursing Council of PNG.	179	t	1
436	Evidence that the Health Service Organisation monitor quality of service delivery for all health services, across the province.	180	t	1
437	Evidence that the Health Organisation has developed responsive health services based on the points above.	181	t	1
438	Evidence that health service is being provided complying with 12.1.2.	182	t	1
439	Evidence that PHC is addressed in health partnership committees.	183	t	1
440	Evidence that District Health Managers, with their public health teams and OICs of health facility services support Village Health Committees to ensure community and women have a voice in developing policies, planning and implementation of health services at the local level.	183	t	2
441	VHAs have completed training and are supervised.	184	t	1
442	There is a Health Training and Resource Centre in-service training capability for L1-L4 health services.	184	t	2
443	The Health Service Organisation is using the eNHIS to plan, and monitor PHC performance and provide feedback to their communities.	185	t	1
444	Evidence that the HSO have access to essential medicines and manage their supply chain across districts; there are no out of stock nor expired drugs within PHC facilities.	186	t	1
445	Evidence that the HSO is innovative in incentivising VHAs.	187	t	1
446	Evidence of an approved Disease Outbreak Surveillance Plan which is regularly reviewed and updated.	188	t	1
500	Evidence of discussions with communities on community transport arrangements.	202	t	1
447	Public Health unit managers/health facility OICs are aware of the Disease Outbreak Surveillance Plan Plan and the Outbreak Manual for Papua New Guinea 2012.	188	t	2
448	Evidence that the CEO and SEM evaluate responses to emerging health threats (meeting minutes).	188	t	3
449	Evidence of active reporting on notifiable diseases.	189	t	1
450	Public health officers are aware of syndromic surveillance processes.	189	t	2
451	Evidence of processes in place with critical suppliers/vendors for support during disease outbreak.	189	t	3
452	Evidence of an effective communication strategy during outbreaks with communities and NGOs.	189	t	4
453	Evidence that public health officers are aware of the steps in urgent public health events (verify-assess-respond).	190	t	1
454	Evidence that public health officers are able to control a public health event (field team,plan,mobilise, treat patients,look for cases, prevent infection, monitor).	190	t	2
455	There is a Emergency and Disaster Preparedness Plan addressing external and internal disasters.	191	t	1
456	The Emergency and Disaster Preparedness Plan addresses increased human resource needs for service continuity and  availability of medical supplies.	191	t	2
457	Evidence that the Disaster Plan addresses resources to: \nReceive and triage\nAssess, resuscitate and stabilize \nProvide definitive care for and facilitate transfer of patients to the most appropriate level of health facility	191	t	3
458	Evidence that the health facility has a Disaster or Emergency sub-committee responsible for preparedness planning and management of disasters.	192	t	1
459	Evidence that the facilityGÇÖs plans are part of the Provincial and District Government Disaster and Emergency Plan.	192	t	2
460	Emergency response flowcharts are prominently displayed within the facility.	193	t	1
461	Health care workers are aware of the location of the Emergency Response flowcharts and Standard Operating Procedures (SOP)s for emergency responses.	193	t	2
462	Key health care workers are aware of their roles in the Emergency Response flowchart.	193	t	3
463	Evidence that health workers are trained in emergency and disaster preparedness with mock exercises and simulations.	194	t	1
464	Evidence that staff are aware of procedures for safe evacuation in a disaster of vulnerable patients  including the disabled, patients from critical care areas and other immobile patients.	194	t	2
465	Staff are aware of trained procedures in the event of personal threat at the workplace including armed hold-ups.	194	t	3
466	Evidence of an endorsed Patient Referral Guideline.	195	t	1
467	Copies of the OrganisationGÇÖs Patient Referral Guidelines are available at all health facilities.	195	t	2
468	Evidence of a toll-free number/ CUG radio/Whatsapp/ messaging service   between referring and receiving facilities including private and public.	196	t	1
469	All health facilities must have a communication directory with details of health facilities, services and contact numbers of relevant persons.	196	t	2
470	Evidence that Emergency cases are resuscitated and stabilised in preparation for referral/evacuation.	197	t	1
471	Evidence of triaging to Category 1, 2 and 3 based on severity of the patientGÇÖs condition.	197	t	2
472	Evidence of documented approval between referring and receiving facility prior to transfer.	197	t	3
473	Evidence of written patient/guardian consent for referral.	197	t	4
474	Evidence that the patient referral form travels with the patient.	197	t	5
475	Evidence that patient with poor prognosis are not transferred.	197	t	6
476	Evidence that urgent referals by air or sea are appoved by the CEO/delegate.	197	t	7
477	Evidence of a referral registry at the initiating health facility.	197	t	8
478	Evidence that the referral is appropriate to the level of triage and medical condition.	198	t	1
479	Evidence of referrals to a Rural Hospital for screening, and communication with the Provincial Senior Medical Officer for non-urgent cases.	198	t	2
480	Evidence of communication with the Provincial Senior Medical Officer for an urgent or unstable case (e.g.requiring resuscitation).	198	t	3
481	Evidence that self- referred patients are not offered repatriation.	198	t	4
482	Evidence of referral and management for cases referred from Village Health Assistants and Community-based treatment partners.	198	t	5
483	Evidence of village deaths recorded as verbal autopsy.	198	t	6
484	Evidence that public health programme officers are aware of referral pathways for TB patients, gender-based violence survivors, mental health patients and patients with disabilities.	198	t	7
485	Evidence that a standardised patient referral form is used for referrals which is signed off by a senior officer prior to referral.	199	t	1
486	Evidence that the patient referral form has relevant information including presenting complaint, history, co-morbidities and regular medications.	199	t	2
487	The patient referral form has  documentation of vital signs and treatment given.	199	t	3
488	The patient referral form has documented time of patient arrival and time of departure.	199	t	4
489	There is a GÇ£checklistGÇÖ to support health workers at the initiating health facility to prepare patients for transfer.	199	t	5
490	Evidence of documentation of patientGÇÖs condition during transport.	199	t	6
491	Evidence that the health facility receiving the patient has the available skilled workforce / right skill mix, medicines and equipment to manage the referred condition of the patient.	200	t	1
492	Evidence  that there is documentation of a handover by accompanying staff to the receiving facility.	200	t	2
493	Evidence of a referral registry at the receiving health facility.	200	t	3
494	Hospital Emergency Department, Birth Suite or Specialist Medical Consultation Clinics is the point of call for urgent and non-urgent referrals.	200	t	4
495	Patient is discharged with medical and patient care instructions, supply of medications and consumables that the patient requires at the time of discharge.	201	t	1
496	Documentation of discharge plan is on Discharge Summary, Admission form and patient inpatient records.	201	t	2
497	Evidence of communication between facilities for patient discharge date, transport needs and follow up treatment.	201	t	3
498	A copy of the Discharge Summary is given to the patient.	201	t	4
499	Evidence of instructions on repatraition cost.	201	t	5
501	Urgent referals are transferred by the referring health facilityGÇÖs road transport (ambulance).	203	t	1
502	Non-urgent referrals are through PMVs, dinghys or private tranport.	203	t	2
503	The health facilityGÇÖs transport vehicle is equipped to manage a critically ill patient (emergency resuscitation kits).	203	t	3
504	Accompanying health staff are trained in Basic Life Support (BLS) and/or Advanced Cardiac Life Support (ACLS) with a current Authorisation to practice.	203	t	4
505	Patient referral data is compiled and reviewed and submitted to the Provincial Clinical Governance Committees.	204	t	1
506	There is evidence of audits of the patient referral forms for compliance with the referral guideline.	204	t	2
507	Multi-disciplinary approach to planning, leading, and organising, supervising staff, to make informed decisions and accept responsibility for improving the quality of health services provided.\nThis includes using jusdgement over effective use of resources, information technology, performance and productivity of the health facility workforce	205	t	1
508	Improved supervisory competencies of supervisors at both the provincial and district levels to ensure that regular supervisory visits are conducted in the districts.	206	t	1
509	There is a minimum of four (4) supervisory visits to each health facility each year.	206	t	2
510	Utilising the relevant checklist for the provincial and district hospitals and Levels 1 GÇô 4 facilities, i.e., rural to urban health services.	206	t	3
511	Evidence of an established and approved annual Hospital and Public Health Integrated Supervision Plan   for urban-rural health services prepared by Department Heads, DHMs and OICs.	207	t	1
512	Senior managers and health staff of hospital and public health Programs attendance at education or awareness sessions on;\napproved Hospital and Public Health program Integrated Supervision Annual plan, its purpose and benefits to staff and team.  \nHow to use both the hospital and urban-rural health services supervision checklist.	207	t	2
513	Evidence availablle at hospital and public health programs health facilities   confirms  Supervisors complaince with the nine (9) Supervisory Steps during the Supervisory Integrated Visit.	208	t	1
514	Evidence of supportive visits, with reports, at least 4 times per year, as well as meeting minutes of the full multi-disciplinary team held quarterly.	209	t	1
515	Hospital Dept Heads /Public Health Program Managers / DHMs carry out;\nSupportive supervision visits at least 4 times a year\nFull multidisciplinary team meeting	209	t	2
516	Evidence of Integrated  Supervisory Visits Statement  Document  on   Key Issues & recommendations   prepared by  Quality Coordinator (QC) & Internal Auditor (IA)  presentation to  Corporate & Clinical Governance (incl. Public Health) Committee meetings.	209	t	3
517	Evidence that SEMT received  Integrated Supervisory Visits Statement  Document  on Priorities Key Issues & recommendations from Corporate & Clinical Governance Committee	209	t	4
518	Evidence that All health facilities at that PHA are delivering services in accordance with designated level of care, NHS standards, and have access to drugs and equipment required.	210	t	1
519	Evidence of a functioning network of health facilities are open and providing services in accordance with designated levels (NHSS).	210	t	2
520	Evidence of signed Service Level Agreements (SLAs) with churches and targets for all health facilities Level 2 to Level 4 are being implemented.	210	t	3
521	The organisation has implemented SLA and is managing with all health facilities receive a minimum of four supportive supervisory visit annually using relevant supervisory tools for hospitals, rural health services and public health.	210	t	4
522	The L5 Provincial Hospital undergoes self-appraisal using relevant supervisory tools at a minimum of 2 assessment annually.	210	t	5
523	Evidence that agreed targets for all NHIS health indicators for each health facilities are being achieved.	210	t	6
524	Evidence that supervisory tools are being used.	211	t	1
525	Evidence that supervisory visits are completed and analysed at each review period of, at minimum, 6 months	211	t	2
526	Evidence that reporting is through the monthly hospital divisional units, allied health and rural health services on agreed indicators.	211	t	3
528	There is a multidisciplinary IPC subcommittee as part of the Clinical Governance Committees.	212	t	2
529	An annual implementation plan is available for the IPC programme in the health facility.	212	t	3
527	Copies of the National IPC Policy and National IPC Guidelines are available within the health facility.	212	t	1
530	Reports on IPC activities is managed and monitored by the IPC subcommittee of the Clinical Governance Committee	213	t	1
531	There is budget allocated for the IPC Programme.	213	t	2
532	There is a designated IPC officer, with a ratio of one full-time officer for every 250 beds or an IPC link nurse at every primary health care facility.	213	t	3
533	Evidence that key IPC Strategies are included in the IPC programme and are being monitored.	214	t	1
534	Evidence that environmental factors are included in the IPC programme and are monitored.	215	t	1
535	IPC education is part of new employee orientation.	216	t	1
536	There are separate IPC education sessions conducted for IPC specialists, health workers involved in health service delivery and support staff (administrative workers, cleaners) 	216	t	2
537	There is periodic evaluation of staff knowledge on IPC.	216	t	3
538	Evidence of adoption of standardised definitions for HAI and AMR surveillance	217	t	1
539	Evidence of tracking of HAI and AMR patterns.	217	t	2
540	There is access to microbiology or laboratory support to guide HAI and AMR surveillance	217	t	3
541	Evidence that AMR and HAI reports are sent quarterly to the IPC subcommittee and the OrganisationGÇÖs Clinical Governance committee.	217	t	4
542	AMR and HAI surveillance reports are disseminated to all unit managers on a regular basis.	217	t	5
543	Standards for bed occupancy is one patient per bed with adequate spacing between patient beds.	218	t	1
544	Evidence that the WISN method was used to estimate workload capacity.	218	t	2
545	Evidence that if bed capacity exceeds staffing capacity, steps are taken to address additional workload.	218	t	3
546	Evidence that these items and practices are available.	219	t	1
547	Evidence that IPC workflow standards has considered in each work area and developed in conjunction with the IPC team.	220	t	1
548	PatientGÇÖs guardians only care for their own patient	220	t	2
549	There are clear instructions for ablutions (cleaning) and waste disposal for the patient and guardian	220	t	3
550	There is evidence of adequate supply of clean water.	221	t	1
551	The physical layout of CSSD and laundry facilities comply with IPC guidelines.	221	t	2
552	There are isolation and containment facilities within the facility.	221	t	3
553	Guidelines for cleaning equipment are available within the wards.	222	t	1
554	Sterilising is carried out in accordance with the National IPC guidelines.	222	t	2
555	Evidence of an Organisational policy on who can prescribe antibiotics.	223	t	1
556	Evidence of tracking of Anti-microbial resistance trends.	223	t	2
557	The staff in specific high-risk areas can demonstrate how to clean and monitor relevant areas.	224	t	1
558	Standard operating procedures (SOPs) on cleaning are available in these areas.	224	t	2
559	There are sufficient cleaning staff who have the right supplies for cleaning.	225	t	1
560	Cleaning products are stored and used as per manufacturerGÇÖs instructions and relevant work safety policies. 	225	t	2
561	Frequency of cleaning of specific areas is related to its risk assessment.	225	t	3
562	Cleaning staff know how to manage spills of blood and body fluid.	225	t	4
563	Evidence that the Facility complies with the food safety guidelines during preparation, serving and storage.	226	t	1
564	Evidence of the facility waste management plan.	227	t	1
565	Evidence of waste management issues discussed through clinical governance committees.	227	t	2
566	If waste management is outsourced, there is a current memorandum of understanding or contract with the external contractor.	227	t	3
567	Evidence of recycling, reducing waste and resource conservation.	228	t	1
568	Evidence that there are adequate range and supply of bags and waste bins including sharp containers, biohazard bins, general waste bins, and cytotoxic bins.	229	t	1
569	Evidence that waste is being segregated at the source of production.	229	t	2
570	Waste containers are colour- coded and labelled.	229	t	3
571	There are appropriate PPE and equipment for waste management (heavy duty gloves, broom, shovels) in relevant areas.	229	t	4
572	Expired drugs are disposed according to guidelines.	229	t	5
573	Waste disposal area within the facility is fenced and clean.	229	t	6
574	There is a functioning and fenced incinerator in bigger hospitals and other waste management methods in smaller health facilities.	229	t	7
575	Facility clinical and non-clinical staff are aware of protecting against blood and body substances during handling of waste.	229	t	8
576	Evidence of waste management training for clinical and non-clinical staff.	230	t	1
577	The Mission, Vision and Goals of the Organization are visible, endorsed and dated.	231	t	1
578	There is an endorsed and dated department Organizational chart with lines of functions and reporting relationships.	231	t	2
579	Relevant service operational policies are available in the respective department. (National Health Plan, National Health Service Standards, relevant Public Health Policies, etc.)	231	t	3
580	Evidence of an Annual Implementation Plan and budget.	231	t	4
581	Evidence of an Annual District Health Plan and Budget.	231	t	5
582	Evidence of a fee structure (if fees are collected).	231	t	6
583	Evidence of scheduling (roster) to do the Integrated Supervisory Checklist for Level 1 to Level 4 facilities twice a year.	231	t	7
584	Letter of appointment and terms of reference as the Head of Service.	232	t	1
585	Letter of appointment and terms of reference as a member of the Clinical Governance Advisory Committee. 	232	t	2
586	Letter of appointment and terms of reference in other Organizational committees.	232	t	3
587	Meeting minutes are available, disseminated and acknowledged by staff.	233	t	1
588	There is sufficient attendance for the meetings with adequate representatives of the service.	233	t	2
589	Frequency of meetings are as scheduled.	233	t	3
590	Discussions and resolutions are implemented. (problems not solved are brought forward to the next meeting till resolved).	233	t	4
591	Staff were involved in the development of the Annual Implementation Plan (see meeting minutes).	233	t	5
592	Evidence of quarterly performance reviews (meeting minutes or reports).	233	t	6
593	The statistics and records from (a) to (g) are available.	234	t	1
594	There are applicable copies of public health acts and laws in the Public Health Division.	235	t	1
595	There is evidence of use of the laws to conduct enforcement activity (e.g. sanitary codes for the food industry; Public Health Act for urgent reporting of infectious diseases, Medicine and Cosmetics Act 1999 for the sale of medication etc.)	235	t	2
596	There are dated and specific job descriptions for each staff that include (a) to (f).	236	t	1
597	The job description is acknowledged by the staff and signed by the Head of Service and dated.	236	t	2
598	The scope of work in the job description aligns with the training, skill and experience of the staff. (credentialling) 	236	t	3
599	Evidence of current registration for all cadres of staff (annual practicing certificate).	237	t	1
600	Observation that cadres of staff are working according to their job description and job scope.	238	t	1
601	Training calendar includes in-house/ external courses/ workshops/ conferences 	239	t	1
602	Training register for each staff including training in life support is kept in the Division.	239	t	2
603	There are ongoing Continuous Professional Activities in the Division.	239	t	3
604	Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.	240	t	1
605	Evidence of sufficiently skilled trained staff to provide supervision as per terms of Memorandum of Understanding.	241	t	1
606	The training programme includes community- based experiences for the healthcare undergraduate.	241	t	2
607	Performance appraisal for staff is completed upon probationary period and as an annual exercise.	242	t	1
608	Documented evidence of research activities within the Public Health Division.	243	t	1
609	There is a projected number of Public Health staff according to needs.	244	t	1
610	The number of Public Health staff meet the projected needs.	244	t	2
611	Evidence of policy stating that all staff have to attend a structured orientation programme.	245	t	1
612	Attendance list of those having attended the orientation programme.	245	t	2
613	Public Health Division staff wear uniforms or organization approved attire.	246	t	1
614	Public Health Division staff have identification tags or cards.	246	t	2
615	Evidence of documented policies and procedures for the service.	247	t	1
616	The policies and procedures are endorsed and dated.	247	t	2
617	There is a periodic review at least once in three years.	247	t	3
618	Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference.	247	t	4
619	Minutes of committee meetings on development and revision on policies and procedures.	248	t	1
620	Documented policies and procedures that address (a) to (m).	249	t	1
621	Staff are briefed on the policies and procedures (meeting minutes or circulation acknowledgement).	249	t	2
622	There is evidence of compliance to the policies and procedures (staff interview, observation, review of patient complaints, results of audits)	249	t	3
623	A roster of scheduled supervisory visits to different health facilities is sighted.	250	t	1
624	There are dated and signed reports following/from the supervisory visits.	250	t	2
625	There is follow-up action taken on items agreed upon during the supervisory visits.	250	t	3
626	There is a roster for outreach activities.	251	t	1
627	Outreach activities are combined between curative and public health teams.	251	t	2
628	There are dated and signed reports of the outreach activities.	251	t	3
629	There is a roster for school health outreach programmes.	251	t	4
630	Village Health Assistances are part of the outreach programmes.	251	t	5
631	There are district Maternal and Perinatal Clinical Governance committees. (see meeting minutes, appointment letters)	252	t	1
632	The Public Health Division has a list of facilities offering Maternal and Child Health services.	252	t	2
633	Maternal mortality reviews are conducted. (see meeting minutes).	252	t	3
634	There are established documented referral pathways for maternal cases.	252	t	4
635	The Public Health Division has a list of facilities offering family planning services.	252	t	5
636	The current Obstetrics and Gynaecology Standard Treatment Guideline is available.	252	t	6
637	There are records for essential Maternal Child Health drugs.	252	t	7
638	There is a designated Officer in Charge for the EPI programme.	253	t	1
639	There has been staff training on EPI in the past two years (training records)	253	t	2
640	Data on EPI programmes are complete and maintained.	253	t	3
641	Vaccine stock data is complete and maintained	253	t	4
642	There is a designated officer for the STD, HIV and AIDS programme (see appointment letter).	254	t	1
643	There have been staff training programmes for STD, HIV and AIDS in the past two years (training records).	254	t	2
644	The current standard treatment guidelines for HIV/AIDs management are available.	254	t	3
645	Data on STD, HIV and AIDS programmes are complete and maintained (review tally sheets, records, e-NHIS).	254	t	4
646	Anti- retroviral (ART) stock data is complete and maintained (see stock card).	254	t	5
647	The list of health care staff trained in HIV counselling and testing is current and maintained (see training register).	254	t	6
648	There is an established referral pathway for HIV/STD or AIDS cases to curative services if needed (see SOP on referral pathway)	254	t	7
649	There is a designated officer for the STD, HIV and AIDS programme (see appointment letter).	254	t	8
650	There is a designated officer for the Malaria programme (see appointment letter).	255	t	1
651	The current Standard Treatment Guidelines for Malaria management is available.	255	t	2
652	There are updated Malaria epidemic monitoring/surveillance charts.	255	t	3
653	There have been staff training programmes for Malaria in the past two years (training records on the use of rapid diagnostic tests and latest treatment regimens).	255	t	4
654	Data on the Malaria programme is complete and maintained (review tally sheets, records, e-NHIS)	255	t	5
655	Rapid diagnostic kits stock data for Malaria is complete (see stock cards).	255	t	6
656	Anti- malarial therapy stock data is complete and maintained (see stock card).	255	t	7
657	There is an established referral pathway for Malaria cases to curative services if needed (see SOP on referral pathway).	255	t	8
658	There is a designated officer for the TB programme (appointment letter)	256	t	1
659	The current Standard Treatment Guidelines for Tuberculosis management is available	256	t	2
660	There have been staff training programmes for TB in the past two years (see training register).	256	t	3
661	Data on the TB programme is complete and maintained (review tally sheets, records, e-NHIS)	256	t	4
662	Buffer stock for anti-TB drugs is available (see stock card).	256	t	5
663	The TB coordinator provides the Basic Management Unit TB report to health facilities managing TB cases (see copy of report)	256	t	6
664	There is an established referral pathway for TB cases to curative services if needed (see SOP on referral pathway).	256	t	7
665	There is displayed information on catchment areas at the Public Health Division.	257	t	1
666	Catchment areas updated in the past 2 years are organised by number of households and population segregated by sex and age	257	t	2
667	There is a displayed list of villages/wards with key health information.	257	t	3
668	There is a current annual estimate of children under 1 year old, 5 years and women of childbearing age.	257	t	4
669	There is a chart to monitor immunisations of children under 1 years old.	257	t	5
670	There are reports on drug and medical equipment stock-outs.	257	t	6
671	There are meetings held to discuss findings reported in the national Health Information System (e-NHIS).	257	t	7
672	Evidence of a health promotion and disease prevention plan.	258	t	1
673	The programme demonstrates locally appropriate programmes that meet community needs.	258	t	2
674	The programme has targeted disease prevention strategies for chronic diseases (e.g. diabetes and hypertension)	258	t	3
675	There is evidence of communication with NDOHGÇÖs Health Promotion team in obtaining material or advice.	258	t	4
676	There is use of appropriate communication channels (e.g. social media, peer to peer networks, mass media) to reach target groups.	259	t	1
677	There is evidence of engagement with community stakeholders or influencers as part of the communication strategy.	259	t	2
678	There is evidence of health communication addressing immunisation, newborn care, WASH and HIV prevention.	259	t	3
679	There is engagement with partners to communicate health strategies. (see correspondence emails, meeting reports).	259	t	4
680	There are evidence of health education activities e.g. oral health outreach programmes, school health interventions and women and menGÇÖs health awareness sessions.	260	t	1
681	There are staff training programmes to deliver the health education activities appropriately.	260	t	2
682	There is evidence that the information is presented with audio-visual and computer-based support (slides, posters, pictures, websites etc.)	260	t	3
683	There is evidence that surveillance officers use data to identify and respond to outbreaks (reports of outbreak identification and response).	261	t	1
684	There is a standard operating procedure for the assembly and deployment of Rapid Response Teams (RRT) during an acute outbreak or crisis.	261	t	2
685	There is evidence of engagement with communities and other stakeholders in responding to an outbreak or event (communication, reports)	261	t	3
686	There is a copy of the Outbreak Manual for Papua New Guinea 2012.	261	t	4
687	A list of officers who have undergone the Field Epidemiology Training Programme is maintained.	261	t	5
688	There are designated environmental health officers.	262	t	1
689	The environmental health officer has a specific job description.	262	t	2
690	The environmental health officer has appropriate professional qualifications to fulfil the role.	262	t	3
691	The reporting roles of the position are clearly defined in the organogram of the Organization.	262	t	4
692	Evidence that the environmental health officer/s attend appropriate training to maintain their competence.	262	t	5
693	Copies of relevant environmental health laws and regulations are available in the division.	263	t	1
694	The environmental health team are aware and have read these regulations (interview, see initialing after reading).	263	t	2
695	Individuals and organizations have been informed and educated on relevant public health and environmental quality laws and regulations (see meetings, training records).	263	t	3
696	Evidence that enforcement activities in accordance with regulations have been carried out (see reports, interview).	263	t	4
697	There is an environmental health profile for communities using community environmental health assessment data (see profiles).	264	t	1
698	The community health profiles are reviewed and updated.	264	t	2
699	The EH focal point is included in the emergency response plan of natural disasters or public health emergencies.	265	t	1
700	There are written roles and responsibilities for the EH focal point in the emergency response plan.	265	t	2
701	There is an SOP on the testing, handling and reporting of laboratory samples for environmental testing.	265	t	3
702	There is evidence of laboratory accessibility that can test environmental samples (see flow chart and SOP).	265	t	4
703	The EH focal point is part of the surveillance team that investigates environmentally related threats and hazards.	265	t	5
704	The EH focal point works with the Department of Agriculture and Livestock (DAL) and PNG Biosecurity Authority on issues around animal health-human health connection (see correspondence or meeting minutes).	265	t	6
705	There are joint meetings between public health infection prevention and control, biomedical and EH focal points.	266	t	1
706	Evidence of multiple sources of data to plan EH activities (surveillance and epidemiological data, registries etc.).	267	t	1
707	The EH programme uses geographic information systems (GIS).	267	t	2
708	There is evidence of suitable (language and culturally appropriate) environmental health information for the community.	268	t	1
709	There is appropriate use of communication channels and tools to reach and address the needs of various target audiences e.g. radio, social media, etc.).	268	t	2
710	Environmental health education activities are targeted to specific groups (e.g. children, septic tank installers and owners, community water systems operators, etc. see evidence).	268	t	3
711	There are procedures for alerting all subpopulations in the community when an environmental health emergency happens (see SOP or reports about previous events).	269	t	1
712	There is an SOP for interagency coordination during an environmental health emergency.	269	t	2
713	There is a directory of community organizations and agencies with an interest in environmental health issues and services.	270	t	1
714	Evidence of joint meetings with other partners: government agencies (e.g., health, environment, agriculture), the private sector, advocacy groups and universities on environmental health issues)\n(see meeting reports or minutes).	271	t	1
715	There is evidence of community involvement in the preparation of local environmental health programmes (see meeting minutes or reports).	272	t	1
716	There is a water safety plan to prevent microbial contamination.	273	t	1
717	Drinking water meets WHO and national standards concerning chemical and radiological parameters.	273	t	2
718	All drinking-water is treated with a residual disinfectant to ensure microbial safety up to the point of consumption or use.	273	t	3
719	There are no tastes, odors or colors that would discourage consumption or use of the drinking-water.	273	t	4
720	Water that is below drinking-water quality is used only for cleaning, laundry and sanitation and is labelled as such at every outlet.	273	t	5
721	Water of appropriate quality is supplied for medical activities as well as for vulnerable patients, and standards and indicators have been established.	273	t	6
722	There is one toilet per 20 users for inpatient settings and at least four toilets per outpatient setting (one for staff, and for patients: one for females, one for males).	274	t	1
723	Toilets have convenient handwashing facilities.	274	t	2
724	Toilets are easily accessible (that is, no more than 30 meters from all users).	274	t	3
725	There is a cleaning and maintenance routine in operation that ensures that toilets are clean and functioning.	274	t	4
726	Evidence that wastewater is removed rapidly from the point where it is produced.	275	t	1
727	Rainwater and surface run-off is safely disposed of and does not carry contamination from the health care setting to the outside surrounding environment.	275	t	2
728	Soiled linen is placed in a leak proof bag or a linen trolley with a cover and labelled.	276	t	1
729	Linen is not sorted in the patient care area (observe, interview).	276	t	2
730	When handling or washing soiled linen, laundry staff wear appropriate Personal Protective Equipment (Household utility gloves, closed shoes, a plastic or rubber apron) (observe).	276	t	3
731	Clean and soiled linen are transported and stored separately in different marked bags.	276	t	4
732	Beds, mattresses and pillows are cleaned between patients and whenever soiled with body fluids.	276	t	5
733	Laundry area is cleaned using the two-step cleaning method i.e. detergent followed by a chemical disinfectant (interview, observe)	276	t	6
734	Staff have received IPC training. (see training records, interview staff).	277	t	1
735	Food handlers wear appropriate protective clothing (waterproof or fabric aprons, hair net).	278	t	1
736	There are separate areas and utensils for raw and cooked food, items can be colour coded (observe).	278	t	2
737	Food and meat are prepared in different areas.	278	t	3
738	There is minimization of hand contact evidenced by the use of suitable utensils while handling food.	278	t	4
739	Handwashing is observed before and after handling food and gloves used when available.	278	t	5
740	Cooking is done on a smokeless stove or in well- ventilated areas.	278	t	6
741	Food preparation premises is thoroughly cleaned minimally once daily.	278	t	7
742	Food is stored in enclosed rooms or cabinets with adequate shelf space.	279	t	1
743	The bottom shelf must be 10-12cm above the floor.	279	t	2
744	All frozen food must be stored at a temperature of -18né¦C (check freezer temperature).	279	t	3
745	All perishable food not being processed must be stored in the refrigerator at a temperature below 5né¦C.	279	t	4
746	Dry foods are kept in plastic buckets/tins with a tight-fitting lid.	279	t	5
747	Evidence that food is not being thawed at room temperature (observe, interview)	280	t	1
748	Frozen poultry, red meat and seafood are thawed either by slow thaw (removed from freezer and kept in refrigerator for 24 hours) or rapid thaw (kept under cold water for two hours) processes (interview).	280	t	2
749	Food that is pre-prepared for later consumption is rapidly chilled from cooked to 21né¦C within 2 hours and 21né¦C to 5né¦C within four hours. (interview)	280	t	3
750	Food handling staff have received IPC training (see training register).	281	t	1
751	Food handling staff have received appropriate food safety training.	281	t	2
752	There is evidence of vector control measures within the Facility such as the use of wire mesh on the windows, the use of bed nets, indoor repellent sprays etc. (observe)	282	t	1
753	There is evidence of vector source reduction (this includes clearing brush, managing irrigation, and removing standing water to eliminate breeding grounds) (observe, interview)	282	t	2
754	Vision, Mission and values statements of the Facility are available, endorsed and dated by the Governing Body.	283	t	1
755	Philosophies, goals and objectives of the Nursing Services are measurable in line with the Facility statements are available, endorsed and dated.	283	t	2
756	Philosophies, goals and objectives of the Nursing Services communicated to staff at Nursing Orientation, Training and Meetings.	283	t	3
757	Achievement of goals and objectives are monitored, reviewed and revised accordingly.	283	t	4
758	Current Health Facility organization chart shows formal communication reporting relationships between Nursing Services and other divisions/ departments.	284	t	1
759	Nursing Services Divisions Organization Chart reflects line of authority and working relationships between HoNS, nursing unit leaders and staff. Nursing Services Organization chart dated and co- signed by HoNS & PHA CEO.	284	t	2
760	Nursing Services Divisions Organization Chart is one of the agenda for orientation programs and other relevant forums.	284	t	3
761	5-year Activity Plan: Nursing Services Five (5) year activity plan dated and signed available, displayed at Offices of HoNS and Nursing Stations.	285	t	1
762	Awareness of Activity Plan: Nursing Services Five (5) year activity plan awareness programme attendance record.	285	t	2
763	Minutes are accessible, disseminated and acknowledged by the relevant body and nursing staff.	286	t	1
764	Attendance list of members with adequate representation of the service.	286	t	2
765	Frequency of meetings with agenda as scheduled.	286	t	3
766	HoNS have annual budget plan reflecting nursing activities incorporated in the overall health facility budget.	287	t	1
767	Meeting Minutes of Facility-wide Budget Plan Management reflects Nursing Services budget.	287	t	2
768	Request for allocation of budget and resources (staffing, equipment, etc.) for the service is Supported and Approved in Health Organization Facility budget.	287	t	3
769	HoNS identified vacant nursing role /position. Formal request to PHA / Health Service Organization SEMT and HR submission for Advertisement, Recruitments and Appointment to the vacant role /position.	288	t	1
770	HoNS conduct Transparent appraisal of all applications received. Prepares summary of Short-listed applicant that meets selection criteria.	288	t	2
771	Selection committee interview Short listed applicant; Decision made on a suitable applicant.	288	t	3
772	HR office issue Job offer with terms of employment to successful applicant for consideration and acceptance.	288	t	4
773	Successful applicant accepted and signed job offer, paving way for formal employment process.	288	t	5
774	Completion of required employment data information.	288	t	6
775	Nurse is place on duty roster only after issued signed JD and formal orientation program attendance.	288	t	7
776	Outpatients and inpatients statistics record.	289	t	1
777	Midnight Census stats to determine bed occupancy and lengths of stay.	289	t	2
778	MCH statistics on;\na.)\tWell baby visits\nb.)\tSick baby visits\nc.)\tFamily planning attendance\nd.)\tAntenatal visit attendance\ne.)\tVillage outreach clinics\nf.)\tTypes of immunizations	289	t	3
779	Public health programmes such as;\na.)\tMedical outreach visits to level 3 or 4	289	t	4
780	Data on performance improvement activities including performances indicators and not limited to incident and near missesGÇÖ report	289	t	5
781	Staff training records	289	t	6
782	Annual report to Board of Governance	289	t	7
783	Involvement of Nursing Ward Managers and HoNS (where applicable) in the planning, development and implementation of new policies, facilities, and services	290	t	1
784	Minutes of meeting(s)	290	t	2
785	Involvement of the nursing staff on development and implementation of new technologies.	291	t	1
786	Minutes of department, and/or management meetings	291	t	2
787	Documented and approved NSCP for unanticipated situation.	292	t	1
788	Department-level Risk Register. This Risk Register includes;\na.)\tLikelihood\nb.)\tImpact\nc.)\tAssigned ownership\nd.)\tRisk Treatment	292	t	2
789	Clear actions and staff responsibilities during disruption /emergencies.	292	t	3
790	Record of drills or tests, with follow-up actions, if conducted.	292	t	4
791	Review of Risk Register	292	t	5
792	Valid Memorandum of Understanding (MoU) or Agreement	293	t	1
793	Ratio of Clinical Instructor (CI) and students commensurate with the number of students, i.e., 1:15	293	t	2
794	Student ward allocation roster	293	t	3
795	Records on credentials of Head of Service and staff required to fill up the posts within the service (to match the complexity of the Facility and services) and certification/registration (Annual Practicing Certificate.	294	t	1
796	Overall statistics of staff, qualification and experience (updated nursing staff establishment).	294	t	2
797	List of nurses with post basic certification in various disciplines	294	t	3
798	Training and competency records.	294	t	4
799	Deployment/assignment according to staff experience and specialty training.	294	t	5
800	HoNS has Valid appointment letters and Terms of Reference as member of committees stipulated by the Governing Body.	295	t	1
801	Minutes of relevant committee meetings	295	t	2
802	Designated registered nurses are assigned to each unit with delegated responsibility for management of Nursing Services.	296	t	1
803	Dated and signed letters of appointments.	296	t	2
804	Dated and signed job descriptions specific to the units or clinics.	296	t	3
805	Name of the assigned nurse leader is shown in the duty roster.	296	t	4
806	A structured approach should be adopted to ensure nursing care with comprehensive personalized focus on each patientGÇÖs needs as stipulated in Standard 2.3	297	t	1
807	Full time staff (Infection Control Nurse) in accordance with national norm commensurate with bed occupancy rate.	298	t	1
808	Current assigned duty roster.	298	t	2
809	Nursing staff roster covers Patient acuity level of care.	298	t	3
810	Nursing staff duty roster shows balance in allocation of nurses according to qualification and experience.	298	t	4
811	In experience nurse must not be rostered to work alone without supervision.	298	t	5
812	Written contingency plan for turnover and absenteeism.	298	t	6
813	Written and signed instruction is issued by HoNS or Nurse Leader if a nurse is assigned to work in another area outside rostered Schedule.	298	t	7
814	Updated specific job descriptions for different categories of nursing roles but not limited to those as listed from (a) to (e).	299	t	1
815	General Nurse update Job descriptions	299	t	2
816	Midwife Nurse updated Job description	299	t	3
817	Paediatric Nurse updated Job description	299	t	4
818	Intensive care Nurse updated Job descriptions	299	t	5
819	Peri Operative Nurse updated Job description	299	t	6
820	Mental Health Nurse updated Job description	299	t	7
821	Emergency Nurse updated Job descriptions	299	t	8
822	Nurse job description issued to each nurse is dated and signed by the HoNS.	299	t	8a
823	Each nurse signed the job description to confirm that they understand the details of the job, accept their responsibility in their practice of caring for patients.	299	t	9
824	Orientation Policy document requiring all new staff attendance at orientation programme.	300	t	1
825	Orientation program, and document, covers the GÇÿGeneralGÇÖ, GÇÿServicesGÇÖ and GÇÿJob-SpecificGÇÖ aspects.	300	t	2
826	Attendance record signed by the facilitator of orientation programme.	300	t	3
827	Approved Formal Nursing Staff Performance Appraisal Structure/ framework.	301	t	1
828	Performance appraisal conducted in confidential manner at end of Probation and Annually.	301	t	2
829	Formal discussion with nurse on appraisal outcome, weakness, strength, future development plan.	301	t	3
830	Overall Nursing staff Performance Appraisal Summary report including commendation and recommendation for further action;\nProbation nurse\nAnnual nursing services staff (all nursing)	301	t	4
831	Nursing Management action plan Information Performance Appraisal Summary report capturing required action.	301	t	5
832	Training needs assessment is carried out and gaps identified. Staff development plan is done, supported and signed by CEO.	302	t	1
833	Training schedule/calendar is in place.	302	t	2
834	Required training is provided through any of these short-term activities, clinical supervision, in-house training and mentoring.	302	t	3
835	Required Performance & competency improvement is being monitored after training or capacity building activities in Point 3	302	t	4
836	Nursing staff performance report on skills and competency improvement achieved in their performance after the training.	302	t	5
837	Long term Nursing staff Training plan includes external courses/ workshop/ conferences.	303	t	1
838	Clear information on nature, objectives and learning outcome from required Training directly gives added value to Individual nurse and patient care.	303	t	2
963	Frequency of meetings are as scheduled.	336	t	3
839	Study Agreement signed between HoNS, CEO and Nurse identified for long term Training are kept and maintained for each staff.	303	t	3
840	Certificate of attendance/degree/post basic training.	303	t	4
841	Records of nursing staff biodata.	304	t	1
842	Qualification and experience with primary source verification where applicable.	304	t	2
843	Evidence of current registration.	304	t	3
844	Training record(s).	304	t	4
845	Competency record and privileging.	304	t	5
846	Leave records relates to any of these;\nRecreation\nSick\nCompassionate\nMaternity\nStudy and secondment	304	t	6
847	Confidentiality agreement	304	t	7
848	Skilled Clinical Nursing Staff with Students ration are appropriately met (1:15).	305	t	1
849	Written evidence to prove that continuous efforts has been taken to ensure that sufficient skilled clinical nursing supervisors are available at all times	305	t	2
850	The Clinical nursing Supervisor have right credentials and privileged to supervised student nurses at that facility	305	t	3
851	Signed Code of Conduct by Clinical Supervisor.	305	t	4
852	Minutes of Joint Meeting between Nursing Services and Nursing College.	305	t	5
853	Documented policies and procedures are established to govern the Credentialing and privileging process for Nursing services which Includes but not to item (a) to (e).	306	t	1
854	There is a systematic validation process for each individual staff member of their credentials.	306	t	2
855	Skills competency is assessed regularly.	306	t	3
856	Formal Letters of assignment are or certificate of Privileging with time duration are issued and reviewed accordingly.	306	t	4
857	Nursing Service health promoting environment policy relates workplace wellness programme.	307	t	1
858	Nursing services Christian Spiritual program.	307	t	2
859	Adequately Resource Nursing & general Staff Health Clinic.	307	t	3
860	Nursing Services physical and social health programmes.	307	t	4
861	Evidence of effective and functioning Nursing care practice supervision programme.	307	t	5
862	Evidence of staff appraisal programme with feedback on underperformance.	307	t	6
863	Functioning, and effective, counselling service for nursing staff, such as;\nSocial and spiritual counselling.	307	t	7
864	Approved Patient and Professional Conducts Grievances reporting policy Document. Policy prescribes management process on patient and professional conduct complaints, violence, bullying, and harassment.	308	t	1
865	Nursing staff Grievances Policy awareness campaigns sessions including anonymous reporting channel.	308	t	2
866	Patient or Nurse professional conducts complaints received are investigated and managed internally.	308	t	3
867	Serious Patient Nursing professional conducts complaints reported to the PNG Nursing Council.	308	t	4
868	Misconduct of criminal nature are referred to Police.	308	t	5
869	Employment and payroll matters are referred to HR & CEO.	308	t	6
870	Outcome of investigation on grievances or complaints received, managed and recorded are reported to CEO in Nursing performance report.	308	t	7
871	Approved Nursing Staff Feedback Management Policy.	309	t	1
872	Nursing Staff Feedback Policy awareness campaigns sessions conducted.	309	t	2
873	Nursing Staff implement Feedback Policy freely to give their feelings   about their workplace experience through emails, mobile SMS text or letter.	309	t	3
874	Nursing Staff work environment satisfaction survey is being conducted twice in a year. Survey outcome and gaps identified for improvement communicated to nursing staff and SEMT.	309	t	4
875	General care of all patients.	310	t	1
876	Care of emergency patients.	310	t	2
877	Use of resuscitation procedures.	310	t	3
878	Administration of blood and blood products.	310	t	4
879	Patients on life support/comatose.	310	t	5
880	Care of elderly patients.	310	t	6
881	Care of disable individuals, both adults and children.	310	t	7
882	Patient receiving chemotherapy and other high-risk medications.	310	t	8
883	Policies and procedures on patient nutrition, hygiene are consistent with regulatory requirement.	310	t	9
884	Minutes of Committee Meetings on developments and revision on Policies and procedures.	311	t	1
885	Minutes of meeting with evidence   of Cross reference with other departments.	311	t	2
886	Records of training and briefing on current policies and procedures to all staff. to all staff. to all staff.	312	t	1
887	The policies and procedures are communicated to all nursing staff and others through formal internal circular dated and co-signed by the medical officer and head of nursing.	312	t	2
888	Nursing services staff have access to copies of Policies and procedures, guidelines, relevant Acts, Regulations, By Laws and Statutory requirements.	313	t	1
889	The policies and procedures for nursing services are endorsed by the HoNS.	314	t	1
890	List of Committees where the Head of the nursing servicers is involved and Minutes of Management Meetings.	315	t	1
891	Initial assessment for all inpatient to be completed within 8 hours.	316	t	1
892	Nursing assessment should be done every shift and as when required.	316	t	2
893	Nursing plan documented after each patientGÇÖs assessment.	316	t	3
894	Implementation of Structured Nursing care Plan based on patientsGÇÖ need as state (a) to (d).	317	t	1
895	Documented Nursing Care Plan signed and dated.	317	t	2
896	Continuity of patient care is mention at shift hand over report.	317	t	3
897	Patient discharge plan includes patient education.	317	t	4
898	Adequate and proper utilization of Space with good ventilation.	318	t	1
899	Appropriated type of medical equipment to match the complexity or healthy facility level of services.	318	t	2
900	Easily Access and clear exit routes.	318	t	3
901	Adequate supply of hygiene disinfectant soaps, protective items disposal gloves, hand wash basins, Alcohol-Based Hand Rub, paper hand towels.	319	t	1
902	Visible Functioning Hygiene Sinks with running water easily accessible for hand washing by nurses and medical staff and other carer.	319	t	2
903	Availability and easily accessible of functional basic and critical medical equipment are e.g., oxygen cylinder, suction unit and defibrillators and ECG unit where applicable.	319	t	3
904	Evidence of functioning Emergency Trolley and Drawers are appropriately stock.\nDrawer 1. Airways & breathing items\nDrawer 2. Circulation & IV \nDrawer 3. Emergency Medications\nDrawer 4. Diagnostics and Sundries items	319	t	4
905	Medical EquipmentGÇÖs has valid planned Preventable Maintenance Plan (PMP).	319	t	5
906	User Training Records.	320	t	1
907	Competency assessment records.	320	t	2
908	List of trained staff and privileged to operate specialized equipment.	320	t	3
909	Provision of adequate staff toilets with personal lockers or equivalent to keep staff personal belongings with adequate security.	321	t	1
910	Change rooms with shower facilities at Operating theatre, maternity ward and isolation unit.	321	t	2
911	Dedicated room for tea and lunch breaks.	321	t	3
912	Nursing Conference room for handover report and mini clinical session at Nurse Station.	321	t	4
913	Availability of Training facility with lecture and tutorial rooms.	322	t	1
914	Evidence of any initiative or change of Practice or policy that promote environmentally.	323	t	1
915	The comprehensive Nursing Services Risk Management programme integrates clinical and public health governance structures is documented, dated and signed.	324	t	1
916	Letter of assignment for a designated Nurse   for coordination of Nursing Services RISK management Programme is dated and signed.	324	t	2
917	Letter of assignment has clear responsibilities and reporting requirement, understood, accepted and signed by designated nurse.	324	t	3
918	A Risk Management Programme (RMP) \n Training Document is available, signed and document.	325	t	1
919	The RMP training plan covers periodical, planned and systematic safety and performance improvement activities to monitor and evaluate the performance of the Nursing Services. The process includes;\nPlanned activities\nData collection\nMonitoring and evaluation of the performance\nAction plan for improvement\nImplementation of action plan\nRe-evaluation for improvement \nInnovation	325	t	2
920	Nursing staff adhere to point (a) to (g) implementing process complying with approved Nursing RMP.	325	t	3
921	Nursing Staff RMP Training attendance\nRecord.	325	t	4
922	Records, trending and analysis on performance improvement studies \nand activities.	325	t	5
923	Minutes of performance improvement    meetings.	325	t	6
924	Records of performance improvement and remedial actions adoption into training needs, policy, guidelines and standard operating procedures.	325	t	7
925	Records on Innovation, if available.	325	t	8
926	Planned performance improvement activities include (b) to (f).	326	t	1
927	Records, trending and analysis on performance improvement studies and activities.	326	t	2
928	Minutes of performance improvement meetings.	326	t	3
929	Records of performance improvement and remedial actions adoption into training needs, policy, guidelines and standard operating procedures.	326	t	4
930	Records on innovation, if available.	326	t	5
931	Minutes of meetings discussing progress on improvement activities.	327	t	1
932	Letter of assignment of responsibilities to appropriate individuals within respective services.	327	t	2
933	Job description prescribes required task for planning, monitoring and managing safety and performance improvement activities	327	t	3
934	Documented and approved PCP for emergency services.	328	t	1
935	List of key emergency functions and identified risks, documented in a department-level Risk Register. This Risk Register includes;\nLikelihood\nImpact\nAssigned ownership	328	t	2
936	A system for incident reporting is in place and includes the following;\nTraining of staff\nPolicy on incident reporting\nRegister, records of incidents	329	t	1
937	Completed incident reports;\nRoot cause analysis\nCorrective and preventive action plan\nRemedial measure(s)	329	t	2
938	Clinical Audits including patient safety reviews (e.g. mortality and morbidity review etc.	329	t	3
939	Sentential event Investigation with appropriate corrective and preventive action and oversight by governing body.	329	t	4
940	Grievance Mechanism, both staff and public, including grievances reporting and processing mechanisms available.	329	t	5
941	Minutes of meeting.	329	t	6
942	Acknowledgement by HoNS.	329	t	7
943	Feedback and learning from incident reporting are shared with staff.	329	t	8
944	Specific performance indicators monitored, verified and validated.	330	t	1
945	Records of tracking and trending analysis.	330	t	2
946	Remedial measures taken where appropriate	330	t	3
947	Review any performance indicator over a one-year period.\nHave consistently met or exceeded target \nContinue to show persistency Performance	330	t	4
948	Where applicable, review the target or identify new indicators.	330	t	5
949	Safety culture survey for the nursing staff	331	t	1
950	Results of safety and performance improvement activities are accessible to staff through education sessions, meetings and digital communications.	332	t	1
951	Documentation on performance improvement activities and performance indicators.	333	t	1
952	Policy statement on anonymity on patients and providers involved in performance improvement activities.	333	t	2
953	The Mission, Vision and Goals of the Organization are visible, endorsed and dated.	334	t	1
954	There is an endorsed and dated department Organizational chart with lines of functions and reporting relationships.	334	t	2
955	Relevant policies are available in the department. (National Health Plan, National Health Service Standards, Service Improvement Plan etc.).	334	t	3
956	Evidence of submission of an Annual Implementation Plan and budget.	334	t	4
957	Evidence of fee structure (if fees are collected).	334	t	5
958	Letter of appointment and terms of reference as the Head of Service.	335	t	1
959	Letter of appointment and terms of reference as a member of the Clinical Governance Advisory Committee.	335	t	2
960	Letter of appointment and terms of reference in other hospital committees.	335	t	3
961	Meeting minutes are available, disseminated and acknowledged by staff.	336	t	1
962	There is sufficient attendance for the meetings with adequate representatives of the service.	336	t	2
964	Discussions and resolutions are implemented. (problems not solved are brought forward to the next meeting till resolved).	336	t	4
965	The statistics and records from (a) to (f) are available.	337	t	1
966	There are dated and specific job descriptions for each staff that include (a) to (f).	338	t	1
967	The job description is acknowledged by the staff and signed by the Head of Service and dated.	338	t	2
968	The scope of work in the job description aligns with the training, skill and experience of the staff (credentialling)	338	t	3
969	Evidence of current registration for all cadres of staff (annual practicing certificate).	339	t	1
970	Observation that cadres of staff are working according to their job description and job scope.	340	t	1
971	Training calendar includes in-house/ external courses/ workshops/ conferences.	341	t	1
972	Training for each staff including training in life support is kept in the Department.	341	t	2
973	There are ongoing Continuous Professional Activities in the Department.	341	t	3
974	Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.	342	t	1
975	Evidence of sufficient skilled trained staff to provide clinical supervision as per terms of Memorandum of Understanding.	343	t	1
976	Performance appraisal for staff including medical practitioners is completed upon probationary period and as an annual exercise.	344	t	1
977	Documented evidence of research activities in the Department.	345	t	1
978	Planning of staff allocation and movement within the Department includes the following;\na.)\tDeployment based on staff to patient ratio, bed occupancy rate and complexity of cases.\nb.)\tSpecial skills/training of staff.\nc.)\tContingency plan for acute shortage.\nd.)\tDuty roster.\ne.)\tEvidence that all clinicians re not made to work more than the stipulated hours.	346	t	1
979	Evidence of policy stating that all staff have to attend a structured orientation programme.	347	t	1
980	Attendance list of those having attended the orientation programme.	347	t	2
981	Evidence of documented policies and procedures for the service.	348	t	1
982	The policies and procedures are endorsed and dated.	348	t	2
983	There is a periodic review at least once in three years.	348	t	3
984	Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference	348	t	4
985	Minutes of committee meetings on development and revision on policies and procedures.	349	t	1
986	Documented policies and procedures that address (a) to (s).	350	t	1
987	Staff are briefed on the policies and procedures (meeting minutes or circulation acknowledgement).	350	t	2
988	Operational policy on 24-hour service.	351	t	1
989	Staffing level reflects a good mix of senior and junior staff.	351	t	2
990	On call roster is dated and authorized.	351	t	3
991	Relevant Standard Treatment Guidelines are available in the division (Adult STG, TB treatment Protocol, Leprosy Manual, Diabetes Therapeutic Guidelines, Malaria Treatment Guidelines, HIV Treatment Guidelines, STI Treatment Guidelines, Medical and Dental Catalogue).	352	t	1
992	Patient register is updated daily.	352	t	2
993	Evidence of appropriate admission process.	352	t	3
994	Evidence of in-patient and guardian orientation process during admission.	352	t	4
995	Evidence of initial assessment and provisional diagnosis.	352	t	5
996	Evidence and documentation of morning and evening rounds.	352	t	6
997	Evidence of regular vital sign documentation	352	t	7
998	Documentation of discussions with patient/family/guardian about the patientGÇÖs condition.	352	t	8
999	Evidence of discussions with other disciplines and referrals if necessary.	352	t	9
1000	Evidence of patient handover during shift change (documentation and observed).	352	t	10
1001	Evidence of documented informed consent for procedures.	352	t	11
1002	Evidence of flowchart on patient deterioration or GÇ£Code BlueGÇ¥ procedures.	352	t	12
1003	Discharge summaries are issued to patients on discharge with a care plan.	352	t	13
1004	PatientGÇÖs medical record has elements (a) to (k).	353	t	1
1005	The PatientGÇÖs medical record has a unique identifier (MRN).	353	t	2
1006	Evidence of clinical documentation which is signed, dated and with legible writing.	353	t	3
1007	Evidence of use of appropriate abbreviations.	353	t	4
1008	The building is sound and there is adequate space to match the services.	354	t	1
1009	Appropriate type of equipment to match the complexity of services.	354	t	2
1010	Adequate facilities and equipment at each patient care area for safe care. (e.g. defibrillators, emergency trolley, hand washing facilities etc.).	354	t	3
1011	Easy access and clear (unblocked) exit routes.	354	t	4
1012	Absence of overcrowding.	354	t	5
1013	Availability of an isolation area.	354	t	6
1014	There are lights/lamps/solar for blackouts.	354	t	7
1015	There is good ventilation within the ward/s.	354	t	8
1016	There is running water in the facility.	354	t	9
1017	Waste is segregated at the facility at the point of generation.	354	t	10
1018	Design and layout of the unit, e.g. wards, treatment rooms, dirty and clean utility rooms, access, lighting, signage, etc. address the safety aspects of patients and staff.	355	t	1
1019	Equipment should have scheduled planned preventive maintenance (PPM).	355	t	2
1020	There is access to hand washing facilities.	355	t	3
1021	Mattresses are covered with waterproof coverings and there is clean linen on every bed.	355	t	4
1022	Sharps are disposed properly.	355	t	5
1023	Appropriate telecommunication modalities available for daily operation and during emergencies.	356	t	1
1024	There is up-to-date documentation of the total number of beds (overnight and day-only beds)	357	t	1
1025	Evidence that any patient who occupies a bed for more than 4 hours and receives significant clinical care is classified as an GÇ£in-patientGÇ¥.	357	t	2
1026	Factors such as GÇ£bed occupancy ratesGÇ¥ and GÇ£average length of stayGÇ¥ are monitored and analyzed.	357	t	3
1027	Floor plan indicates facility accessibility and is patient and user friendly.	358	t	1
1028	Feedback from patient satisfaction surveys on the facilities.	358	t	2
1029	Incident reporting relating to facilities if any.	358	t	3
1030	Toilets have wheelchair access.	358	t	4
1031	Availability of emergency and non-emergency equipment appropriate to level of care, such as defibrillator, emergency trolley, suction machine, electrocardiogram (ECG) machine, infusion or syringe pump, vital sign monitor, pulse oximeter, oxygen concentrator etc.	359	t	1
1032	Scheduled checking of items in emergency trolley.	359	t	2
1033	There are adequate patient transfer trolleys, wheelchairs, mobility aids and a dedicated drug fridge.	359	t	3
1034	There is a dedicated cabinet for dangerous drugs which can be locked.	359	t	4
1035	Planned Preventive Maintenance records such as schedule, stickers, etc.	360	t	1
1036	Planned Replacement Programme where applicable.	360	t	2
1037	Complaint records.	360	t	3
1038	Asset inventory	360	t	4
1039	User training records.	361	t	1
1040	List of staff trained and authorized to operate specialized equipment.	361	t	2
1041	Evidence of list of services available and offered to patients.	362	t	1
1042	Flow chart on work process.	362	t	2
1043	Safe keeping of medical records.	362	t	3
1044	Clinic appointment system.	362	t	4
1045	Security of data in Health Information System.	362	t	5
1046	Monitoring of waiting time.	362	t	6
1047	Adequate and appropriate signage.	362	t	7
1048	Floor plan indicates accessibility to supporting services and optimization of space.	362	t	8
1049	Adequate patient personal use items, e.g. wheelchair, mobility aids etc.	362	t	9
1050	Adequate waiting area, toilets, reading material and parking space.	362	t	10
1051	Evidence of facilities with patient privacy ensured.	363	t	1
1052	Procedure room appropriately equipped.	363	t	2
1053	Patient monitoring device is available where required (vital signs).	363	t	3
1054	List of procedures performed.	363	t	4
1055	There is a designated person who monitors safety and performance improvement activities within the Medical Services.	364	t	1
1056	There are records/registers on performance improvement activities.	364	t	2
1057	There are meeting minutes for performance improvement meetings.	364	t	3
1058	There are records on innovation (if any)	364	t	4
1059	System for incident reporting is in place with the following;\na.)\tTraining of staff in incident reporting\nb.)\tPolicy on incident reporting\nc.)\tMethod/SOP on Incident reporting\nd.)\tRegister of incidents	365	t	1
1060	Completed incident reports.	365	t	2
1061	Corrective and preventive action plans.	365	t	3
1062	Minutes of meeting.	365	t	4
1063	Involved staff given feedback about the incident report	365	t	5
1064	Acknowledgment by Head of Medical Service and Director of Curative Services.	365	t	6
1065	Specific performance indicators are monitored.	366	t	1
1066	Remedial action is taken when appropriate.	366	t	2
\.


--
-- Data for Name: complianceEvidenceChecks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."complianceEvidenceChecks" ("complianceEvidenceCheckId", "complianceAssessmentId", "evidenceId", "isChecked") FROM stdin;
951	334	2	f
952	334	1	f
953	334	3	f
954	334	4	f
955	334	5	f
960	338	11	f
969	342	21	f
1901	667	957	f
1902	667	953	f
1903	667	954	f
970	342	22	f
1904	667	955	f
977	346	29	f
987	350	39	f
988	350	40	f
1000	354	52	f
1001	354	53	f
1002	354	54	f
1010	358	62	f
1011	358	63	f
1020	362	72	f
1021	362	73	f
1022	362	74	f
1030	366	82	f
1031	366	83	f
1037	370	87	f
1038	370	88	f
1039	370	89	f
1045	374	95	f
1050	378	100	f
1051	378	101	f
1052	378	102	f
1060	382	110	f
1061	382	111	f
1062	382	112	f
1073	386	123	f
1074	386	125	f
1075	386	124	f
1087	390	137	f
1088	390	138	f
1089	390	139	f
1090	390	140	f
1096	394	146	f
1107	398	159	f
1108	398	160	f
1109	398	161	f
1110	398	162	f
1111	398	163	f
1112	398	164	f
1113	398	165	f
1119	402	171	f
1120	402	172	f
1126	406	178	f
1127	406	179	f
1135	410	187	f
1136	410	188	f
1137	410	189	f
1143	414	195	f
1156	418	208	f
1157	418	209	f
1165	422	217	f
1166	422	218	f
1176	426	228	f
1177	426	229	f
1178	426	230	f
1182	430	234	f
1183	430	235	f
1184	430	236	f
1190	434	242	f
1191	434	243	f
1199	438	251	f
1200	438	252	f
1207	442	259	f
1208	442	260	f
1212	446	264	f
1213	446	265	f
1229	450	281	f
1239	454	291	f
1255	458	307	f
1256	458	308	f
1257	458	309	f
1258	458	310	f
1259	458	311	f
1260	458	312	f
1261	458	313	f
1262	458	314	f
1263	458	315	f
1264	458	316	f
1265	458	317	f
1272	462	324	f
1273	462	325	f
1274	462	326	f
1275	462	327	f
1286	466	338	f
1298	470	350	f
1304	474	356	f
1305	474	357	f
1306	474	358	f
1313	478	365	f
1314	478	366	f
1315	478	367	f
1316	478	368	f
1317	478	369	f
1326	482	378	f
1327	482	379	f
1335	486	387	f
1336	486	388	f
1337	486	389	f
1338	486	390	f
1339	486	391	f
1354	490	406	f
1360	494	412	f
1361	494	413	f
1367	498	419	f
1373	502	425	f
1377	506	429	f
1381	510	433	f
1385	514	437	f
1391	518	443	f
1397	522	449	f
1398	522	450	f
1399	522	451	f
1400	522	452	f
1408	526	460	f
1409	526	461	f
1410	526	462	f
1418	530	470	f
1419	530	471	f
1420	530	472	f
1421	530	473	f
1422	530	474	f
1423	530	475	f
1424	530	476	f
1425	530	477	f
1443	534	495	f
1444	534	496	f
1445	534	497	f
1446	534	498	f
1447	534	499	f
1455	538	507	f
1462	542	514	f
1463	542	515	f
1464	542	516	f
1465	542	517	f
1478	546	530	f
1479	546	531	f
1480	546	532	f
1486	550	538	f
1487	550	539	f
1488	550	540	f
1489	550	541	f
1490	550	542	f
1498	554	550	f
1499	554	551	f
1500	554	552	f
1507	558	559	f
1508	558	560	f
1509	558	561	f
1510	558	562	f
1516	562	568	f
1517	562	569	f
1518	562	570	f
1519	562	571	f
1520	562	572	f
1521	562	573	f
1522	562	574	f
1523	562	575	f
1535	566	587	f
1536	566	588	f
1537	566	589	f
1538	566	590	f
1539	566	591	f
1540	566	592	f
1547	570	599	f
1553	574	605	f
1554	574	606	f
1	1	3	f
5	1	5	f
1559	578	611	f
1560	578	612	f
1568	582	620	f
1569	582	621	f
1570	582	622	f
1586	586	638	f
956	335	7	f
961	339	15	f
962	339	16	f
971	343	23	f
978	347	30	f
989	351	41	f
990	351	42	f
991	351	43	f
992	351	44	f
1003	355	55	f
1004	355	56	f
1005	355	57	f
1012	359	64	f
1013	359	65	f
1014	359	66	f
1015	359	67	f
1016	359	68	f
1023	363	75	f
1024	363	76	f
1025	363	77	f
1026	363	78	f
1032	367	84	f
1033	367	85	f
1040	371	90	f
1046	375	96	f
1053	379	103	f
1054	379	104	f
1055	379	105	f
1056	379	106	f
1063	383	113	f
1064	383	114	f
1076	387	126	f
1077	387	127	f
1078	387	128	f
1091	391	141	f
1097	395	149	f
1098	395	147	f
1099	395	148	f
1100	395	150	f
1114	399	166	f
1121	403	173	f
1122	403	174	f
1128	407	180	f
1129	407	181	f
1138	411	190	f
1144	415	196	f
1145	415	197	f
1146	415	198	f
1158	419	210	f
1167	423	219	f
1168	423	220	f
1179	427	231	f
1185	431	237	f
1192	435	244	f
1201	439	253	f
1202	439	254	f
1209	443	261	f
1214	447	266	f
1215	447	267	f
1230	451	282	f
1231	451	283	f
1232	451	284	f
1233	451	285	f
1234	451	286	f
1240	455	292	f
1241	455	293	f
1242	455	294	f
1243	455	295	f
1244	455	296	f
1245	455	297	f
1266	459	318	f
1267	459	319	f
1268	459	320	f
1276	463	328	f
1277	463	329	f
1278	463	330	f
1279	463	331	f
1287	467	339	f
1288	467	340	f
1289	467	341	f
1290	467	342	f
1291	467	343	f
1299	471	351	f
1300	471	352	f
1307	475	359	f
1308	475	360	f
1318	479	370	f
1319	479	371	f
1320	479	372	f
1328	483	380	f
1340	487	392	f
1341	487	393	f
1342	487	394	f
1343	487	395	f
1344	487	396	f
1345	487	397	f
1346	487	398	f
1355	491	407	f
1362	495	414	f
1363	495	415	f
1364	495	416	f
1368	499	420	f
1369	499	421	f
1370	499	422	f
1374	503	426	f
1378	507	430	f
1382	511	434	f
1386	515	438	f
1392	519	444	f
1401	523	453	f
1402	523	454	f
1411	527	463	f
1412	527	464	f
1413	527	465	f
1426	531	478	f
1427	531	479	f
1428	531	480	f
1429	531	481	f
1430	531	482	f
1431	531	483	f
1432	531	484	f
1448	535	500	f
1456	539	508	f
1457	539	509	f
1458	539	510	f
1466	543	518	f
1467	543	519	f
1468	543	520	f
1469	543	521	f
1470	543	522	f
1471	543	523	f
1481	547	533	f
1491	551	543	f
1492	551	544	f
1493	551	545	f
1501	555	553	f
1502	555	554	f
1511	559	563	f
1524	563	576	f
1541	567	593	f
1548	571	600	f
1555	575	607	f
1561	579	613	f
1562	579	614	f
1571	583	623	f
1572	583	624	f
1573	583	625	f
1590	587	642	f
1591	587	643	f
1592	587	644	f
1593	587	645	f
1594	587	646	f
1595	587	647	f
1596	587	648	f
1597	587	649	f
1620	591	672	f
1621	591	673	f
1622	591	674	f
1623	591	675	f
1636	595	688	f
1637	595	689	f
1638	595	690	f
1639	595	691	f
1640	595	692	f
1653	599	705	f
1661	603	713	f
1670	607	722	f
1671	607	723	f
1672	607	724	f
1673	607	725	f
1683	611	735	f
1684	611	736	f
1685	611	737	f
1686	611	738	f
1687	611	739	f
1688	611	740	f
1689	611	741	f
1700	615	752	f
1701	615	753	f
1711	619	763	f
1712	619	764	f
1713	619	765	f
1731	623	783	f
1732	623	784	f
1743	627	795	f
957	336	8	f
963	340	12	f
964	340	13	f
965	340	14	f
972	344	26	f
973	344	24	f
974	344	25	f
979	348	31	f
980	348	32	f
981	348	33	f
982	348	34	f
983	348	35	f
984	348	36	f
985	348	37	f
993	352	45	f
994	352	46	f
995	352	47	f
996	352	48	f
997	352	49	f
1006	356	58	f
1017	360	69	f
1018	360	70	f
1027	364	79	f
1034	368	154	f
1035	368	155	f
1041	372	91	f
1047	376	97	f
1048	376	98	f
1057	380	107	f
1058	380	108	f
1065	384	116	f
1066	384	118	f
1067	384	115	f
1068	384	117	f
1069	384	119	f
1079	388	131	f
1080	388	132	f
1081	388	129	f
1082	388	130	f
1092	392	142	f
1093	392	143	f
1101	396	151	f
1102	396	152	f
1103	396	153	f
1115	400	167	f
1116	400	168	f
1123	404	175	f
1130	408	182	f
1131	408	183	f
1132	408	184	f
1139	412	191	f
1140	412	192	f
1147	416	199	f
1148	416	200	f
1149	416	201	f
1150	416	202	f
1151	416	203	f
1152	416	204	f
1153	416	205	f
1159	420	211	f
1160	420	212	f
1161	420	213	f
1169	424	221	f
1170	424	222	f
1171	424	223	f
1180	428	232	f
1186	432	238	f
1193	436	245	f
1194	436	246	f
1203	440	255	f
1204	440	256	f
1205	440	257	f
1210	444	262	f
1216	448	268	f
1217	448	269	f
1218	448	270	f
1219	448	271	f
1220	448	272	f
1221	448	273	f
1222	448	274	f
1235	452	287	f
1236	452	288	f
1246	456	298	f
1247	456	299	f
1248	456	300	f
1249	456	301	f
1269	460	321	f
1280	464	332	f
1281	464	333	f
1282	464	334	f
1292	468	344	f
1293	468	345	f
1294	468	346	f
1301	472	353	f
1302	472	354	f
1309	476	361	f
1310	476	362	f
1321	480	373	f
1322	480	374	f
1323	480	375	f
1324	480	376	f
1329	484	381	f
1347	488	399	f
1348	488	400	f
1356	492	408	f
1365	496	417	f
1371	500	423	f
1375	504	427	f
1379	508	431	f
1383	512	435	f
1387	516	439	f
1388	516	440	f
1393	520	445	f
1403	524	455	f
1404	524	456	f
1405	524	457	f
1414	528	466	f
1415	528	467	f
1433	532	485	f
1434	532	486	f
1435	532	487	f
1436	532	488	f
1437	532	489	f
1438	532	490	f
1449	536	501	f
1450	536	502	f
1451	536	503	f
1452	536	504	f
1459	540	511	f
1460	540	512	f
1472	544	524	f
1473	544	525	f
1474	544	526	f
1482	548	534	f
1494	552	546	f
1503	556	555	f
1504	556	556	f
1512	560	564	f
1513	560	565	f
1514	560	566	f
1525	564	577	f
1526	564	578	f
1527	564	579	f
1528	564	580	f
1529	564	581	f
1530	564	582	f
1531	564	583	f
1542	568	594	f
1543	568	595	f
1549	572	601	f
1550	572	602	f
1551	572	603	f
1556	576	608	f
1563	580	615	f
1564	580	616	f
1565	580	617	f
1566	580	618	f
1574	584	626	f
1575	584	627	f
1576	584	628	f
1577	584	629	f
1578	584	630	f
1598	588	650	f
1599	588	651	f
1600	588	652	f
1601	588	653	f
1602	588	654	f
1603	588	655	f
1604	588	656	f
1605	588	657	f
1624	592	676	f
1625	592	677	f
1626	592	678	f
1627	592	679	f
1641	596	693	f
1642	596	694	f
1643	596	695	f
1644	596	696	f
1654	600	706	f
1655	600	707	f
1662	604	714	f
1674	608	726	f
1675	608	727	f
1690	612	742	f
1691	612	743	f
958	337	9	f
959	337	10	f
966	341	18	f
967	341	19	f
968	341	20	f
975	345	27	f
976	345	28	f
986	349	38	f
998	353	50	f
999	353	51	f
1007	357	59	f
1008	357	60	f
1009	357	61	f
1019	361	71	f
1028	365	80	f
1029	365	81	f
1036	369	86	f
1042	373	92	f
1043	373	93	f
1044	373	94	f
1049	377	99	f
1059	381	109	f
1070	385	120	f
1071	385	122	f
1072	385	121	f
1083	389	133	f
1084	389	136	f
1085	389	134	f
1086	389	135	f
1094	393	145	f
1095	393	144	f
1104	397	156	f
1105	397	157	f
1106	397	158	f
1117	401	169	f
1118	401	170	f
1124	405	176	f
1125	405	177	f
1133	409	185	f
1134	409	186	f
1141	413	193	f
1142	413	194	f
1154	417	206	f
1155	417	207	f
1162	421	214	f
1163	421	215	f
1164	421	216	f
1172	425	224	f
1173	425	225	f
1174	425	226	f
1175	425	227	f
1181	429	233	f
1187	433	239	f
1188	433	240	f
1189	433	241	f
1195	437	247	f
1196	437	248	f
1197	437	249	f
1198	437	250	f
1206	441	258	f
1211	445	263	f
1223	449	275	f
1224	449	276	f
1225	449	277	f
1226	449	278	f
1227	449	279	f
1228	449	280	f
1237	453	289	f
1238	453	290	f
1250	457	302	f
1251	457	303	f
1252	457	304	f
1253	457	305	f
1254	457	306	f
1270	461	322	f
1271	461	323	f
1283	465	335	f
1284	465	336	f
1285	465	337	f
1295	469	347	f
1296	469	348	f
1297	469	349	f
1303	473	355	f
1311	477	363	f
1312	477	364	f
1325	481	377	f
1330	485	382	f
1331	485	383	f
1332	485	384	f
1333	485	385	f
1334	485	386	f
1349	489	401	f
1350	489	402	f
1351	489	403	f
1352	489	404	f
1353	489	405	f
1357	493	409	f
1358	493	410	f
1359	493	411	f
1366	497	418	f
1372	501	424	f
1376	505	428	f
1380	509	432	f
1384	513	436	f
1389	517	441	f
1390	517	442	f
1394	521	446	f
1395	521	447	f
1396	521	448	f
1406	525	458	f
1407	525	459	f
1416	529	468	f
1417	529	469	f
1439	533	491	f
1440	533	492	f
1441	533	493	f
1442	533	494	f
1453	537	505	f
1454	537	506	f
1461	541	513	f
1475	545	527	f
1476	545	528	f
1477	545	529	f
1483	549	535	f
1484	549	536	f
1485	549	537	f
1495	553	547	f
1496	553	548	f
1497	553	549	f
1505	557	557	f
1506	557	558	f
1515	561	567	f
1532	565	584	f
1533	565	585	f
1534	565	586	f
1544	569	596	f
1545	569	597	f
1546	569	598	f
1552	573	604	f
1557	577	609	f
1905	667	956	f
1558	577	610	f
1567	581	619	f
1579	585	631	f
1580	585	632	f
1581	585	633	f
1582	585	634	f
1583	585	635	f
1584	585	636	f
1585	585	637	f
1606	589	658	f
1607	589	659	f
1608	589	660	f
1609	589	661	f
1610	589	662	f
1611	589	663	f
1612	589	664	f
1628	593	680	f
1629	593	681	f
1630	593	682	f
1645	597	697	f
1646	597	698	f
1656	601	708	f
1657	601	709	f
1658	601	710	f
1663	605	715	f
1676	609	728	f
1677	609	729	f
1678	609	730	f
1679	609	731	f
1680	609	732	f
1681	609	733	f
1695	613	747	f
1696	613	748	f
1697	613	749	f
1706	617	758	f
1707	617	759	f
1708	617	760	f
1717	621	769	f
1718	621	770	f
1719	621	771	f
1720	621	772	f
1721	621	773	f
1722	621	774	f
1723	621	775	f
1587	586	639	f
1588	586	640	f
1589	586	641	f
1613	590	665	f
1614	590	666	f
1615	590	667	f
1616	590	668	f
1617	590	669	f
1618	590	670	f
1619	590	671	f
1631	594	683	f
1632	594	684	f
1633	594	685	f
1634	594	686	f
1635	594	687	f
1647	598	699	f
1648	598	700	f
1649	598	701	f
1650	598	702	f
1651	598	703	f
1652	598	704	f
1659	602	711	f
1660	602	712	f
1664	606	716	f
1665	606	717	f
1666	606	718	f
1667	606	719	f
1668	606	720	f
1669	606	721	f
1682	610	734	f
1698	614	750	f
1699	614	751	f
1709	618	761	f
1710	618	762	f
1724	622	776	f
1725	622	777	f
1726	622	778	f
1727	622	779	f
1728	622	780	f
1729	622	781	f
1730	622	782	f
1740	626	792	f
1741	626	793	f
1742	626	794	f
1744	627	796	f
1745	627	797	f
1746	627	798	f
1747	627	799	f
1754	630	806	f
1755	631	807	f
1756	631	808	f
1757	631	809	f
1758	631	810	f
1759	631	811	f
1760	631	812	f
1761	631	813	f
1775	634	827	f
1776	634	828	f
1777	634	829	f
1778	634	830	f
1779	634	831	f
1780	635	832	f
1781	635	833	f
1782	635	834	f
1783	635	835	f
1784	635	836	f
1796	638	848	f
1797	638	849	f
1798	638	850	f
1799	638	851	f
1800	638	852	f
1801	639	853	f
1802	639	854	f
1803	639	855	f
1804	639	856	f
1819	642	871	f
1820	642	872	f
1821	642	873	f
1822	642	874	f
1823	643	875	f
1824	643	876	f
1825	643	877	f
1826	643	878	f
1827	643	879	f
1828	643	880	f
1829	643	881	f
1830	643	882	f
1831	643	883	f
1836	646	888	f
1837	647	889	f
1842	650	894	f
1843	650	895	f
1844	650	896	f
1845	650	897	f
1846	651	898	f
1847	651	899	f
1848	651	900	f
1857	654	909	f
1858	654	910	f
1859	654	911	f
1860	654	912	f
1861	655	913	f
1866	658	918	f
1867	658	919	f
1868	658	920	f
1869	658	921	f
1870	658	922	f
1871	658	923	f
1872	658	924	f
1873	658	925	f
1874	659	926	f
1875	659	927	f
1876	659	928	f
1877	659	929	f
1878	659	930	f
1884	662	936	f
1885	662	937	f
1886	662	938	f
1887	662	939	f
1888	662	940	f
1889	662	941	f
1890	662	942	f
1891	662	943	f
1892	663	944	f
1893	663	945	f
1894	663	946	f
1895	663	947	f
1896	663	948	f
1899	666	951	f
1900	666	952	f
2	1	4	f
3	1	2	f
7	3	8	f
8	4	9	f
9	4	10	f
10	5	11	f
11	6	16	f
12	6	15	f
13	7	14	f
14	7	13	f
15	7	12	f
16	8	19	f
17	8	20	f
18	8	18	f
19	9	22	f
20	9	21	f
22	11	25	f
25	12	28	f
27	13	29	f
28	14	30	f
29	15	37	f
30	15	31	f
31	15	32	f
32	15	33	f
33	15	34	f
34	15	35	f
35	15	36	f
36	16	38	f
37	17	39	f
38	17	40	f
39	18	44	f
40	18	41	f
41	18	42	f
42	18	43	f
43	19	45	f
44	19	46	f
45	19	47	f
46	19	48	f
47	19	49	f
51	21	53	f
54	22	56	f
56	23	58	f
57	24	59	f
58	24	60	f
59	24	61	f
60	25	62	f
61	25	63	f
62	26	64	f
63	26	65	f
64	26	66	f
65	26	67	f
66	26	68	f
67	27	69	f
68	27	70	f
69	28	71	f
1692	612	744	f
1693	612	745	f
1694	612	746	f
1702	616	754	f
1703	616	755	f
1704	616	756	f
1705	616	757	f
1714	620	766	f
1715	620	767	f
1716	620	768	f
1733	624	785	f
1734	624	786	f
1748	628	800	f
1749	628	801	f
1762	632	814	f
1763	632	815	f
1764	632	816	f
1765	632	817	f
1766	632	818	f
1767	632	819	f
1768	632	820	f
1769	632	821	f
1770	632	822	f
1771	632	823	f
1785	636	837	f
1786	636	838	f
1787	636	839	f
1788	636	840	f
1805	640	857	f
1806	640	858	f
1807	640	859	f
1808	640	860	f
1809	640	861	f
1810	640	862	f
1811	640	863	f
1832	644	884	f
1833	644	885	f
1906	668	958	f
1907	668	959	f
1908	668	960	f
1909	669	961	f
4	1	1	f
1910	669	962	f
6	2	7	f
1911	669	963	f
1912	669	964	f
1913	670	965	f
1914	671	966	f
1915	671	967	f
1916	671	968	f
1917	672	969	f
1918	673	970	f
1919	674	971	f
21	10	23	f
23	11	24	f
1920	674	972	f
24	11	26	f
26	12	27	f
1921	674	973	f
1922	675	974	f
1923	676	975	f
1924	677	976	f
1925	678	977	f
1926	679	978	f
1927	680	980	f
1928	680	979	f
1929	681	981	f
1930	681	982	f
1931	681	983	f
1932	681	984	f
1933	682	985	f
1934	683	986	f
1935	683	987	f
1936	684	988	f
1937	684	989	f
1938	684	990	f
1939	685	991	f
1940	685	992	f
1941	685	993	f
1942	685	994	f
48	20	50	f
49	20	51	f
50	21	52	f
1943	685	995	f
52	21	54	f
53	22	55	f
1944	685	996	f
55	22	57	f
1945	685	997	f
1946	685	998	f
1947	685	999	f
1948	685	1000	f
1949	685	1001	f
1950	685	1002	f
1951	685	1003	f
1952	686	1004	f
1953	686	1005	f
1954	686	1006	f
1955	686	1007	f
1956	687	1010	f
1957	687	1008	f
1958	687	1009	f
1959	687	1011	f
1960	687	1012	f
1961	687	1013	f
73	30	75	f
74	30	76	f
75	30	77	f
76	30	78	f
77	31	79	f
78	32	80	f
1962	687	1014	f
1963	687	1015	f
1964	687	1016	f
1965	687	1017	f
1966	688	1018	f
1967	688	1019	f
1968	688	1020	f
1969	688	1021	f
1970	688	1022	f
1971	689	1023	f
1972	690	1024	f
1973	690	1025	f
1974	690	1026	f
92	40	92	f
90	40	93	f
91	40	94	f
93	41	95	f
94	42	96	f
1975	691	1027	f
1976	691	1028	f
1977	691	1029	f
1978	691	1030	f
1979	692	1031	f
1980	692	1032	f
1981	692	1033	f
1982	692	1034	f
1983	693	1035	f
1984	693	1036	f
1985	693	1037	f
1986	693	1038	f
1987	694	1039	f
1988	694	1040	f
1989	695	1041	f
1990	695	1042	f
111	50	113	f
112	50	114	f
117	51	115	f
1991	695	1043	f
116	51	117	f
1992	695	1044	f
115	51	119	f
120	52	120	f
1993	695	1045	f
119	52	122	f
1994	695	1046	f
1995	695	1047	f
1996	695	1048	f
1997	695	1049	f
1998	695	1050	f
1999	696	1051	f
2000	696	1052	f
2001	696	1053	f
2002	696	1054	f
2003	697	1055	f
2004	697	1056	f
2005	697	1057	f
2006	697	1058	f
2007	698	1059	f
2008	698	1060	f
2009	698	1061	f
2010	698	1062	f
2011	698	1063	f
2012	698	1064	f
142	60	144	f
143	60	145	f
144	61	146	f
145	62	147	f
147	62	149	f
1838	648	890	f
1849	652	901	f
1850	652	902	f
1851	652	903	f
1852	652	904	f
1853	652	905	f
2013	699	1065	f
2014	699	1066	f
172	70	173	f
171	70	174	f
173	71	175	f
175	72	176	f
192	80	193	f
191	80	194	f
193	81	195	f
195	82	196	f
196	82	198	f
218	90	219	f
217	90	220	f
220	91	221	f
221	91	223	f
222	92	224	f
224	92	226	f
237	100	239	f
238	100	240	f
239	100	241	f
240	101	242	f
242	102	244	f
259	110	261	f
260	111	262	f
261	112	263	f
287	120	289	f
288	120	290	f
289	121	291	f
291	122	292	f
293	122	294	f
290	122	296	f
327	130	328	f
328	130	329	f
326	130	330	f
329	130	331	f
331	131	332	f
332	131	334	f
334	132	335	f
333	132	337	f
2015	700	957	f
2016	700	953	f
2017	700	954	f
2018	700	955	f
2019	700	956	f
2020	701	958	f
2021	701	959	f
2022	701	960	f
2023	702	961	f
2024	702	962	f
2025	702	963	f
2026	702	964	f
2027	703	965	f
2028	704	966	f
2029	704	967	f
2030	704	968	f
2031	705	969	f
353	140	355	f
354	141	356	f
2032	706	970	f
356	141	358	f
357	142	359	f
2033	707	971	f
2034	707	972	f
2035	707	973	f
2036	708	974	f
2037	709	975	f
2038	710	976	f
2039	711	977	f
2040	712	978	f
2041	713	980	f
2042	713	979	f
2043	714	981	f
2044	714	982	f
2045	714	983	f
2046	714	984	f
2047	715	985	f
2048	716	986	f
2049	716	987	f
2050	717	988	f
2051	717	989	f
2052	717	990	f
378	150	380	f
379	151	381	f
2053	718	991	f
382	152	384	f
2054	718	992	f
384	152	386	f
2055	718	993	f
2056	718	994	f
2057	718	995	f
2058	718	996	f
2059	718	997	f
2060	718	998	f
2061	718	999	f
2062	718	1000	f
2063	718	1001	f
2064	718	1002	f
2065	718	1003	f
2066	719	1004	f
2067	719	1005	f
2068	719	1006	f
2069	719	1007	f
2070	720	1010	f
2071	720	1008	f
2072	720	1009	f
2073	720	1011	f
2074	720	1012	f
2075	720	1013	f
2076	720	1014	f
407	160	409	f
408	160	410	f
2077	720	1015	f
412	162	414	f
2078	720	1016	f
414	162	416	f
2079	720	1017	f
2080	721	1018	f
2081	721	1019	f
2082	721	1020	f
2083	721	1021	f
2084	721	1022	f
2085	722	1023	f
2086	723	1024	f
2087	723	1025	f
424	170	426	f
425	171	427	f
426	172	428	f
2088	723	1026	f
2089	724	1027	f
2090	724	1028	f
2091	724	1029	f
2092	724	1030	f
2093	725	1031	f
2094	725	1032	f
434	180	436	f
435	181	437	f
436	182	438	f
2095	725	1033	f
2096	725	1034	f
2097	726	1035	f
2098	726	1036	f
2099	726	1037	f
2100	726	1038	f
2101	727	1039	f
2102	727	1040	f
2103	728	1041	f
2104	728	1042	f
2105	728	1043	f
2106	728	1044	f
2107	728	1045	f
2108	728	1046	f
452	190	453	f
451	190	454	f
454	191	455	f
2109	728	1047	f
455	191	457	f
456	192	458	f
2110	728	1048	f
2111	728	1049	f
2112	728	1050	f
2113	729	1051	f
2114	729	1052	f
2115	729	1053	f
2116	729	1054	f
2117	730	1055	f
2118	730	1056	f
2119	730	1057	f
2120	730	1058	f
2121	731	1059	f
2122	731	1060	f
2123	731	1061	f
2124	731	1062	f
2125	731	1063	f
2126	731	1064	f
2127	732	1065	f
2128	732	1066	f
380	152	382	t
409	160	411	t
410	161	412	t
490	200	491	f
491	200	492	f
492	200	493	f
489	200	494	f
494	201	495	f
496	201	497	f
497	201	499	f
498	202	500	f
516	210	518	f
517	210	519	f
518	210	520	f
519	210	521	f
520	210	522	f
521	210	523	f
522	211	524	f
390	154	392	t
524	211	526	f
527	212	527	f
526	212	529	f
545	220	547	f
546	220	548	f
547	220	549	f
548	221	550	f
550	221	552	f
551	222	553	f
574	230	576	f
575	231	577	f
577	231	579	f
579	231	581	f
581	231	583	f
582	232	584	f
584	232	586	f
602	240	604	f
603	241	605	f
605	242	607	f
621	250	623	f
622	250	624	f
623	250	625	f
624	251	626	f
626	251	628	f
628	251	630	f
629	252	631	f
631	252	633	f
633	252	635	f
635	252	637	f
678	260	680	f
679	260	681	f
680	260	682	f
681	261	683	f
683	261	685	f
685	261	687	f
686	262	688	f
688	262	690	f
690	262	692	f
400	156	402	t
711	270	713	f
712	271	714	f
713	272	715	f
745	280	747	f
746	280	748	f
747	280	749	f
748	281	750	f
750	282	752	f
781	290	783	f
782	290	784	f
783	291	785	f
785	292	787	f
787	292	789	f
789	292	791	f
822	300	824	f
823	300	825	f
824	300	826	f
825	301	827	f
827	301	829	f
829	301	831	f
830	302	832	f
832	302	834	f
834	302	836	f
873	310	875	f
874	310	876	f
875	310	877	f
876	310	878	f
877	310	879	f
878	310	880	f
879	310	881	f
880	310	882	f
881	310	883	f
882	311	884	f
884	312	886	f
405	158	407	t
904	320	906	f
905	320	907	f
906	320	908	f
907	321	909	f
909	321	911	f
911	322	913	f
942	330	944	f
943	330	945	f
944	330	946	f
945	330	947	f
946	330	948	f
947	331	949	f
948	332	950	f
1735	625	787	f
1736	625	788	f
1737	625	789	f
1738	625	790	f
1739	625	791	f
1750	629	802	f
1751	629	803	f
1752	629	804	f
1753	629	805	f
1772	633	824	f
1773	633	825	f
1774	633	826	f
1789	637	841	f
1790	637	842	f
1791	637	843	f
1792	637	844	f
1793	637	845	f
1794	637	846	f
1795	637	847	f
1812	641	864	f
1813	641	865	f
1814	641	866	f
1815	641	867	f
1816	641	868	f
1817	641	869	f
1818	641	870	f
1834	645	886	f
1835	645	887	f
1839	649	891	f
1840	649	892	f
1841	649	893	f
1854	653	906	f
1855	653	907	f
1856	653	908	f
1862	656	914	f
1863	657	915	f
1864	657	916	f
1865	657	917	f
1879	660	931	f
1880	660	932	f
1881	660	933	f
1882	661	934	f
1883	661	935	f
1897	664	949	f
1898	665	950	f
70	29	73	f
71	29	74	f
72	29	72	f
79	32	81	f
80	33	82	f
81	33	83	f
82	34	84	f
83	34	85	f
84	36	86	f
85	37	89	f
86	37	87	f
87	37	88	f
88	38	90	f
89	39	91	f
95	43	98	f
96	43	97	f
97	44	99	f
98	45	100	f
99	45	101	f
100	45	102	f
101	46	104	f
102	46	103	f
103	46	105	f
104	46	106	f
105	47	108	f
106	47	107	f
107	48	109	f
108	49	110	f
109	49	111	f
110	49	112	f
113	51	116	f
114	51	118	f
118	52	121	f
121	53	124	f
122	53	123	f
123	53	125	f
124	54	127	f
125	54	126	f
126	54	128	f
127	55	129	f
128	55	130	f
129	55	131	f
130	55	132	f
131	56	133	f
132	56	135	f
133	56	134	f
134	56	136	f
135	57	139	f
136	57	140	f
137	57	138	f
138	57	137	f
139	58	141	f
140	59	143	f
141	59	142	f
146	62	150	f
148	62	148	f
149	63	152	f
150	63	151	f
151	63	153	f
152	35	154	f
153	35	155	f
154	64	157	f
155	64	156	f
156	64	158	f
157	65	159	f
158	65	160	f
159	65	161	f
160	65	162	f
161	65	163	f
162	65	164	f
163	65	165	f
164	66	166	f
165	67	167	f
166	67	168	f
167	68	170	f
168	68	169	f
169	69	172	f
170	69	171	f
174	72	177	f
176	73	179	f
177	73	178	f
178	74	180	f
179	74	181	f
180	75	182	f
181	75	183	f
182	75	184	f
183	76	185	f
184	76	186	f
185	77	187	f
186	77	188	f
187	77	189	f
188	78	190	f
189	79	191	f
190	79	192	f
194	82	197	f
197	83	204	f
198	83	199	f
199	83	200	f
200	83	201	f
201	83	202	f
202	83	203	f
203	83	205	f
204	84	207	f
205	84	206	f
206	85	209	f
207	85	208	f
208	86	210	f
209	87	212	f
210	87	213	f
211	87	211	f
212	88	215	f
213	88	214	f
214	88	216	f
215	89	217	f
216	89	218	f
219	91	222	f
223	92	227	f
225	92	225	f
226	93	229	f
227	93	228	f
228	93	230	f
229	94	231	f
230	95	232	f
231	96	233	f
232	97	234	f
233	97	235	f
234	97	236	f
235	98	237	f
236	99	238	f
241	101	243	f
243	103	245	f
244	103	246	f
245	104	248	f
246	104	249	f
247	104	247	f
248	104	250	f
249	105	251	f
250	105	252	f
251	106	253	f
252	106	254	f
253	107	257	f
254	107	255	f
255	107	256	f
256	108	258	f
257	109	260	f
258	109	259	f
262	113	264	f
263	113	265	f
264	114	266	f
265	114	267	f
266	115	271	f
267	115	268	f
268	115	269	f
269	115	270	f
270	115	272	f
271	115	273	f
272	115	274	f
273	116	275	f
274	116	276	f
275	116	277	f
276	116	278	f
277	116	279	f
278	116	280	f
279	117	281	f
280	118	284	f
281	118	282	f
282	118	283	f
283	118	285	f
284	118	286	f
285	119	288	f
286	119	287	f
292	122	293	f
294	122	295	f
295	122	297	f
296	123	298	f
297	123	299	f
298	123	300	f
299	123	301	f
300	124	305	f
301	124	306	f
302	124	302	f
303	124	303	f
304	124	304	f
305	125	312	f
306	125	307	f
307	125	308	f
308	125	309	f
309	125	310	f
310	125	311	f
311	125	313	f
312	125	314	f
313	125	315	f
314	125	316	f
315	125	317	f
316	126	318	f
317	126	319	f
318	126	320	f
319	127	321	f
320	128	323	f
321	128	322	f
322	129	326	f
323	129	324	f
324	129	325	f
325	129	327	f
330	131	333	f
335	132	336	f
336	133	338	f
337	134	340	f
338	134	339	f
339	134	341	f
340	134	342	f
341	134	343	f
342	135	345	f
343	135	344	f
344	135	346	f
345	136	347	f
346	136	348	f
347	136	349	f
348	137	350	f
349	138	352	f
350	138	351	f
351	139	353	f
352	139	354	f
355	141	357	f
358	142	360	f
359	143	362	f
360	143	361	f
361	144	363	f
362	144	364	f
363	145	366	f
364	145	365	f
365	145	367	f
366	145	368	f
367	145	369	f
368	146	370	f
369	146	371	f
370	146	372	f
371	147	373	f
372	147	374	f
373	147	375	f
374	147	376	f
375	148	377	f
376	149	378	f
377	149	379	f
381	152	383	f
383	152	385	f
385	153	387	f
386	153	388	f
387	153	389	f
388	153	390	f
389	153	391	f
392	154	394	f
402	156	404	f
391	154	393	t
393	154	395	t
394	154	396	t
395	154	397	t
396	154	398	t
397	155	399	t
398	155	400	t
399	156	401	t
401	156	403	t
403	156	405	t
404	157	406	f
411	161	413	f
413	162	415	f
415	163	417	f
416	164	418	f
417	165	419	f
418	166	420	f
419	166	421	f
420	166	422	f
421	167	423	f
422	168	424	f
423	169	425	f
427	173	429	f
428	174	430	f
429	175	431	f
430	176	432	f
431	177	433	f
432	178	434	f
433	179	435	f
437	183	439	f
438	183	440	f
439	184	441	f
440	184	442	f
441	185	443	f
442	186	444	f
443	187	445	f
444	188	446	f
445	188	447	f
446	188	448	f
447	189	449	f
448	189	450	f
449	189	451	f
450	189	452	f
453	191	456	f
457	192	459	f
458	193	461	f
459	193	460	f
460	193	462	f
461	194	464	f
462	194	463	f
463	194	465	f
464	195	467	f
465	195	466	f
466	196	469	f
467	196	468	f
468	197	472	f
469	197	470	f
470	197	471	f
471	197	473	f
472	197	474	f
473	197	475	f
474	197	476	f
475	197	477	f
476	198	484	f
477	198	478	f
478	198	479	f
479	198	480	f
480	198	481	f
481	198	482	f
482	198	483	f
483	199	488	f
484	199	485	f
485	199	486	f
486	199	487	f
487	199	489	f
488	199	490	f
493	201	498	f
495	201	496	f
499	203	502	f
500	203	501	f
501	203	503	f
502	203	504	f
503	204	505	f
504	204	506	f
505	205	507	f
506	206	508	f
507	206	509	f
508	206	510	f
509	207	511	f
510	207	512	f
511	208	513	f
512	209	514	f
513	209	515	f
514	209	516	f
515	209	517	f
523	211	525	f
525	212	528	f
528	213	530	f
529	213	531	f
530	213	532	f
531	214	533	f
532	215	534	f
533	216	535	f
534	216	536	f
535	216	537	f
536	217	538	f
537	217	539	f
538	217	540	f
539	217	541	f
540	217	542	f
541	218	543	f
542	218	544	f
543	218	545	f
544	219	546	f
549	221	551	f
552	222	554	f
553	223	556	f
554	223	555	f
555	224	557	f
556	224	558	f
557	225	559	f
558	225	560	f
559	225	561	f
560	225	562	f
561	226	563	f
562	227	566	f
563	227	564	f
564	227	565	f
565	228	567	f
566	229	568	f
567	229	569	f
568	229	570	f
569	229	571	f
570	229	572	f
571	229	573	f
572	229	574	f
573	229	575	f
576	231	578	f
578	231	580	f
580	231	582	f
583	232	585	f
585	233	587	f
586	233	588	f
587	233	589	f
588	233	590	f
589	233	591	f
590	233	592	f
591	234	593	f
592	235	594	f
593	235	595	f
594	236	596	f
595	236	597	f
596	236	598	f
597	237	599	f
598	238	600	f
599	239	601	f
600	239	602	f
601	239	603	f
604	241	606	f
606	243	608	f
607	244	609	f
608	244	610	f
609	245	611	f
610	245	612	f
611	246	613	f
612	246	614	f
613	247	615	f
614	247	616	f
615	247	617	f
616	247	618	f
617	248	619	f
618	249	620	f
619	249	621	f
620	249	622	f
625	251	627	f
627	251	629	f
630	252	632	f
632	252	634	f
634	252	636	f
636	253	638	f
637	253	639	f
638	253	640	f
639	253	641	f
640	254	642	f
641	254	643	f
642	254	644	f
643	254	645	f
644	254	646	f
645	254	647	f
646	254	648	f
647	254	649	f
648	255	650	f
649	255	651	f
406	159	408	f
650	255	652	f
651	255	653	f
652	255	654	f
653	255	655	f
654	255	656	f
655	255	657	f
656	256	658	f
657	256	659	f
658	256	660	f
659	256	661	f
660	256	662	f
661	256	663	f
662	256	664	f
663	257	665	f
664	257	666	f
665	257	667	f
666	257	668	f
667	257	669	f
668	257	670	f
669	257	671	f
670	258	672	f
671	258	673	f
672	258	674	f
673	258	675	f
674	259	676	f
675	259	677	f
676	259	678	f
677	259	679	f
682	261	684	f
684	261	686	f
687	262	689	f
689	262	691	f
691	263	693	f
692	263	694	f
693	263	695	f
694	263	696	f
695	264	697	f
696	264	698	f
697	265	699	f
698	265	700	f
699	265	701	f
700	265	702	f
701	265	703	f
702	265	704	f
703	266	705	f
704	267	706	f
705	267	707	f
706	268	708	f
707	268	709	f
708	268	710	f
709	269	711	f
710	269	712	f
714	273	716	f
715	273	717	f
716	273	718	f
717	273	719	f
718	273	720	f
719	273	721	f
720	274	722	f
721	274	723	f
722	274	724	f
723	274	725	f
724	275	726	f
725	275	727	f
726	276	728	f
727	276	729	f
728	276	730	f
729	276	731	f
730	276	732	f
731	276	733	f
732	277	734	f
733	278	735	f
734	278	736	f
735	278	737	f
736	278	738	f
737	278	739	f
738	278	740	f
739	278	741	f
740	279	742	f
741	279	743	f
742	279	744	f
743	279	745	f
744	279	746	f
749	281	751	f
751	282	753	f
752	283	754	f
753	283	755	f
754	283	756	f
755	283	757	f
756	284	758	f
757	284	759	f
758	284	760	f
759	285	761	f
760	285	762	f
761	286	763	f
762	286	764	f
763	286	765	f
764	287	766	f
765	287	767	f
766	287	768	f
767	288	769	f
768	288	770	f
769	288	771	f
770	288	772	f
771	288	773	f
772	288	774	f
773	288	775	f
774	289	776	f
775	289	777	f
776	289	778	f
777	289	779	f
778	289	780	f
779	289	781	f
780	289	782	f
784	291	786	f
786	292	788	f
788	292	790	f
790	293	792	f
791	293	793	f
792	293	794	f
793	294	795	f
794	294	796	f
795	294	797	f
796	294	798	f
797	294	799	f
798	295	800	f
799	295	801	f
800	296	802	f
801	296	803	f
802	296	804	f
803	296	805	f
804	297	806	f
805	298	807	f
806	298	808	f
807	298	809	f
808	298	810	f
809	298	811	f
810	298	812	f
811	298	813	f
812	299	814	f
813	299	815	f
814	299	816	f
815	299	817	f
816	299	818	f
817	299	819	f
818	299	820	f
819	299	821	f
820	299	822	f
821	299	823	f
826	301	828	f
828	301	830	f
831	302	833	f
833	302	835	f
835	303	837	f
836	303	838	f
837	303	839	f
838	303	840	f
839	304	841	f
840	304	842	f
841	304	843	f
842	304	844	f
843	304	845	f
844	304	846	f
845	304	847	f
846	305	848	f
847	305	849	f
848	305	850	f
849	305	851	f
850	305	852	f
851	306	853	f
852	306	854	f
853	306	855	f
854	306	856	f
855	307	857	f
856	307	858	f
857	307	859	f
858	307	860	f
859	307	861	f
860	307	862	f
861	307	863	f
862	308	864	f
863	308	865	f
864	308	866	f
865	308	867	f
866	308	868	f
867	308	869	f
868	308	870	f
869	309	871	f
870	309	872	f
871	309	873	f
872	309	874	f
883	311	885	f
885	312	887	f
886	313	888	f
887	314	889	f
888	315	890	f
889	316	891	f
890	316	892	f
891	316	893	f
892	317	894	f
893	317	895	f
894	317	896	f
895	317	897	f
896	318	898	f
897	318	899	f
898	318	900	f
899	319	901	f
900	319	902	f
901	319	903	f
902	319	904	f
903	319	905	f
908	321	910	f
910	321	912	f
912	323	914	f
913	324	915	f
914	324	916	f
915	324	917	f
916	325	918	f
917	325	919	f
918	325	920	f
919	325	921	f
920	325	922	f
921	325	923	f
922	325	924	f
923	325	925	f
924	326	926	f
925	326	927	f
926	326	928	f
927	326	929	f
928	326	930	f
929	327	931	f
930	327	932	f
931	327	933	f
932	328	934	f
933	328	935	f
934	329	936	f
935	329	937	f
936	329	938	f
937	329	939	f
938	329	940	f
939	329	941	f
940	329	942	f
941	329	943	f
949	333	951	f
950	333	952	f
\.


--
-- Data for Name: creditationStatuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."creditationStatuses" ("creditationStatusId", "creditationStatus", description, comments) FROM stdin;
1	Not Yet Assessed	The facility has not started an accreditation survey.	Ready to be assigned to an assessment team.
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.regions ("regionId", "regionName") FROM stdin;
2	Momase Region
1	Southern Region
3	Highlands Region
4	New Guinea Islands
\.


--
-- Data for Name: provinces; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provinces ("provinceId", "provinceName", "regionId") FROM stdin;
1	National Capital District (NCD)	1
2	Madang	2
3	Morobe	2
4	Gulf	1
5	Chimbu	3
6	Eastern Highlands	3
7	Enga	3
8	Southern Highlands	3
9	Western Highlands	3
10	Hela	3
11	Jiwaka	3
12	East New Britain	4
13	Manus	4
14	New Ireland	4
15	West New Britain	4
16	Autonomous Region of Bougainville	4
17	East Sepik	2
18	Sandaun	2
19	Central	1
20	Milne Bay	1
21	Oro	1
22	Western	1
\.


--
-- Data for Name: districts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.districts ("districtId", "districtName", "provinceId") FROM stdin;
1	Moresby South	1
2	Moresby North-East	1
3	Moresby North-West	1
4	Bogia District	2
5	Huon Gulf District	3
6	Chuave	5
7	Gumine	5
8	Karimui-Nomane	5
9	Kerowagi	5
10	Kundiawa-Gembogl	5
11	Sinasina-Yonggomugl	5
12	Daulo	6
13	Goroka	6
14	Henganofi	6
15	Kainantu	6
16	Lufa	6
17	Obura-Wonenara	6
18	Okapa	6
19	Unggai-Bena	6
20	Kandep	7
21	Kompiam-Ambum	7
22	Lagaip	7
23	Wapenamanda	7
24	Wabag	7
25	Porgera-Paiela	7
26	Ialibu-Pangia	8
27	Imbonggu	8
28	Kagua-Erave	8
29	Mendi-Munihu	8
30	Nipa-Kutubu	8
31	Dei	9
32	Mount Hagen	9
33	Mul-Baiyer	9
34	Tambul-Nebilyer	9
35	Magarima	10
36	Koroba-Kopiago	10
37	Tari-Pori	10
38	Komo-Hulia	10
39	Anglimp-South Waghi	11
40	Jimi	11
41	North Waghi	11
42	Gazelle	12
43	Kokopo	12
44	Pomio	12
45	Rabaul	12
46	Manus	13
47	Kavieng	14
48	Namatanai	14
49	Kandrian-Gloucester	15
50	Talasea	15
51	Nakanai	15
52	Central Bougainville	16
53	North Bougainville	16
54	South Bougainville	16
55	Ambunti-Dreikikier	17
56	Angoram	17
57	Maprik	17
58	Wewak	17
59	Wosera-Gawi	17
60	Yangoru-Saussia	17
61	Madang	2
62	Middle Ramu	2
63	Rai Coast	2
64	Sumkar	2
65	Usino-Bundi	2
66	Bulolo	3
67	Finschhafen	3
68	Kabwum	3
69	Lae	3
70	Markham	3
71	Menyamya	3
72	Nawae	3
73	Tewae-Siassi	3
74	Wau-Waria	3
75	Aitape-Lumi	18
76	Nuku	18
77	Telefomin	18
78	Vanimo-Green River	18
79	Abau	19
80	Goilala	19
81	Kairuku	19
82	Hiri-Koiari	19
83	Rigo	19
84	Kerema	4
85	Kikori	4
86	Alotau	20
87	EsaGÇÖala	20
88	Kiriwina-Goodenough	20
89	Samarai-Murua	20
90	Ijivitari	21
91	Sohe	21
92	Popondetta	21
93	North Fly	22
94	Middle Fly	22
95	South Fly	22
96	Delta Fly	22
\.


--
-- Data for Name: levels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.levels ("levelId", "levelName", description, "levelOrder") FROM stdin;
1	Level 1	Level 1 health facilities such as aid posts out in rural areas of Papua New Guinea, as per the NHSS Vol. 2	1
2	Level 2	Community Health Post (CHP): Offers foundational primary care, maternal and child health, and basic family planning services	2
3	Level 3	Health Center(s): A larger community-based facility delivering expanded outpatient care, child immunizations, and basic birthing services	3
4	Level 4	District Hospitals: Provides rural or urban district-level secondary care, including basic emergency obstetric and neonatal care (BEmONC or CEmONC).	4
\.


--
-- Data for Name: facilities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.facilities ("facilityId", "levelId", "facilityName", "districtId", "organizationId", "creditationStatusId", "headOfService", comments) FROM stdin;
1	4	Gerehu Hospital	3	4	1		\N
2	3	Morata Clinic	3	4	1	Helen Kaii Siddy	>> dummy data
\.


--
-- Data for Name: refreshTokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."refreshTokens" ("refreshTokenId", "userAccountId", "tokenHash", "expiresAt", "revokedAt") FROM stdin;
212	1	C24164DCA20B24370B6453553190CFEA4C00E91C6EB66A1FEC2851C61C1E253B	2026-09-23 04:59:38.940229+00	\N
367	4	0F81FE96EFFB76E77FE345ACAA2B14ED7F8343F999ABFCD481923AAB64295B55	2026-09-24 12:18:56.051935+00	2026-09-10 12:19:09.958568+00
216	1	78D407704C0A99ECE2C025BCF8C9196C179C92C7F0E3F0E8743719641AF07ADD	2026-09-23 05:13:20.930373+00	2026-09-09 05:13:25.527597+00
368	2	6C69D9CFD3CAF6BDA362976FF7177C30B51613B3C59DB7C8558BD840B9E36A3E	2026-09-24 12:19:21.076793+00	2026-09-10 12:19:40.662294+00
397	1	6626AE07A44ED2A17E1454739D20ABCA856CAF5625C4274947658DB21E1C49FE	2026-09-25 00:39:30.103331+00	2026-09-11 00:39:54.337385+00
372	1	1D3C20496FB0051CAE44DF54EFDFB9FC7F59B8F0AE388D9F325C3FC0D586B113	2026-09-24 21:21:45.146803+00	2026-09-10 21:42:59.444652+00
219	4	8EEA15C5ECDB6ED6781505C314E2D1992BF048C30923F56A25D31A1129F626F8	2026-09-23 05:14:18.187818+00	2026-09-09 05:14:19.519364+00
224	4	EC9F746DB079B0F6029327C413E168C44DBF9818BC2288E4BF7AC4466E740A3C	2026-09-23 05:18:47.361792+00	\N
376	1	69451C3477A94D16C300476B195C88CB5E09B2129E4D2CA157410519C8E035DD	2026-09-24 22:08:07.783628+00	2026-09-10 22:39:52.377931+00
226	4	030D8460424A3871F4905DDFA9CC6DACC0957F30BFABD1E39DB1927CA4A7F520	2026-09-23 05:19:03.658136+00	\N
259	1	E630160E007A8155162B883ED930E3253F55337BA2B19B73DCEA46878527C4A9	2026-09-23 10:40:32.566601+00	2026-09-09 10:40:51.185459+00
230	4	151B90BAFC1B47DD5DBE8974A2F0F8727C9CD4001EE3F58779E2184FE4400EC8	2026-09-23 05:19:13.182081+00	2026-09-09 05:19:13.713633+00
232	4	41A741499B176A20724C2873613679CDD185416EBB361184C2AF4E1D1E93FC02	2026-09-23 05:19:13.713713+00	\N
234	4	E23A0F1D728C545016FAA7E8402B64D9A3943D0B2F48EAACCB2EE0D421484BFB	2026-09-23 05:31:44.902939+00	2026-09-09 05:32:30.341768+00
236	1	8F60D5F6B551CDE642C3AB163825B85015C3A0932D93508A2F0036C42EAF854B	2026-09-23 05:34:58.908935+00	2026-09-09 05:37:01.342438+00
240	1	5352C6DC8CD9734DE88F6D5BF4DE9673C803B7599B2F73FF2CC37320D072C8A3	2026-09-23 05:40:43.746067+00	2026-09-09 05:41:03.843737+00
244	1	0BF5756F1C2AAA6CD2FCBE49823ADE3587586B75028147AEFC95D060FEC62B97	2026-09-23 05:50:50.654629+00	2026-09-09 05:51:04.987065+00
249	1	54C4490B3B62871137CD0A6765B0BCB18740D54BDDCF98DE9C0EFE030A026E3A	2026-09-23 06:04:22.378233+00	2026-09-09 06:04:30.638547+00
253	2	22318D0DD23BF3F03FB5C826F74DE7272C5CF2837CBA6BE1D19266C6B28F8479	2026-09-23 10:02:46.593855+00	\N
258	1	6450AD427F7D547799A47EF20E833C2D7D328D7E27A2EDFDD10441E28318BFDC	2026-09-23 10:06:35.589067+00	\N
263	2	256F6B1A1801E0C7699EBA487D18D9716452DD780C1A14EBC802EDDF2E7A1ADC	2026-09-23 10:54:53.504165+00	2026-09-09 11:04:16.305266+00
268	2	CD72102379A88BC0598A98F38AFDB96EEB27D1FD11E097AA46D5DEC3DCCBEF39	2026-09-23 11:16:49.256274+00	\N
273	2	7A7645AF0D5D46BF029B94D6A39718268B8DC2DFC3C9DCADBA737218A015696B	2026-09-23 11:56:40.839939+00	\N
279	1	9E57F2B30EEB4D97980D72BF2CDCDD1F0A006D1110B5BB339B835623515DB59D	2026-09-23 12:24:21.507346+00	2026-09-09 12:25:04.870177+00
280	2	FDFEC569C089F4F9CE2C46FDB903DA420EA9B52839AAFE5EB66B6876E245D02B	2026-09-23 22:13:11.398949+00	2026-09-09 22:15:14.632334+00
284	4	1C187B4D15FAA3EFD55EC7C2D8E84E0B58BCECACF91E0DD01ED313AD999D22F2	2026-09-23 22:24:11.207275+00	2026-09-09 22:25:03.312149+00
286	1	00C1E7276D26209EB7FAFD7AC7293A9E402D6941BA429156F0215CBD685057E6	2026-09-23 22:28:48.93907+00	2026-09-09 22:40:13.475426+00
308	1	4E597E2BF448B0C0FB0A10E7238F6D4A556FFCEAF7BCEAF01B32CBD52091A994	2026-09-24 00:20:55.024736+00	2026-09-10 00:37:26.280947+00
289	1	EBBE437F8D451E9EB3755C373EE5E4BB5FDFB5AF21286BFD8CB0F425F0AC8593	2026-09-23 23:34:00.807049+00	2026-09-09 23:51:38.780409+00
294	1	CCF415E5565763E6A8E1FC3C3EFE57BEF3110392FB1AD13A928AA6082796DB2F	2026-09-23 23:51:38.780528+00	2026-09-09 23:59:39.259548+00
298	1	1B414F6CF75FF2BE811F75C25721051230732E8E03CBAD9DAA65EEEE7D3F7176	2026-09-24 00:07:05.637889+00	\N
307	1	A4C1E5F9B25C4FAD2EEE99800C62BF418C58C6892ABDE217B3CC9C5302F9965F	2026-09-24 00:20:55.011707+00	\N
309	1	F42C2C48ED6E1AD1EB813B7F6F3987EEA9588B02BA0306F3F5151D1C86BE4FFA	2026-09-24 00:23:36.413078+00	\N
306	1	F1F29F95BD61C5201A1369BDD0D2CBDC810B7A8A67E5EE12A085F16DDEE0F740	2026-09-24 00:20:47.642347+00	2026-09-10 00:23:36.413024+00
313	1	211266BAFE09BC17FBF7BA13C53702B894B4DE2EC56D6E8C93C5D33064A0CCE5	2026-09-24 00:37:26.28099+00	2026-09-10 00:57:59.081949+00
319	1	1C9113C431A7CCACB161DA52B1A0A75ED57B61F6EC959F059D19AC2BECAD8761	2026-09-24 01:44:21.266091+00	2026-09-10 01:44:27.810887+00
321	1	E4952E8E263E953DFE2EC7A317F034B6F608A0A97420A14DFA5AF2837EA5904B	2026-09-24 01:44:34.382314+00	\N
320	1	C43389E954B4303219F13F52978668806FC00FC2E7D2A9D00E7DED6A105C39B4	2026-09-24 01:44:27.810955+00	2026-09-10 01:44:34.384334+00
325	1	A004E935C55379E7811A1F3E5EC3DC9ED52C7666CB352FDB5EB89E057BC61F03	2026-09-24 02:13:12.909255+00	\N
329	1	593D8F52E018C6EDCD142CE996BA3555FD0EABF1CE4F238F8FBB4765BEC89318	2026-09-24 04:12:33.982104+00	2026-09-10 04:21:16.065808+00
333	1	6F3631CC25A5128A15527BB1A20B1A0A0C793A0D4783C08585EC22F914220AF6	2026-09-24 04:34:31.903071+00	\N
341	1	A27FB239291C730E779E97E40EB44D81994F4AC300BEA09B60FCFC32F2D6F872	2026-09-24 04:57:21.736057+00	\N
346	1	57CD78759FBEC995A8B16BFC5D9F75BAE19F58F3F9CB22F4947065ACFCCD597E	2026-09-24 11:15:28.953363+00	2026-09-10 11:20:38.729881+00
350	2	DF818E450090C42D739B1804BE29ED6966B5B7A89600F57E1DE1D43CB773F2B2	2026-09-24 11:23:11.044438+00	2026-09-10 11:27:32.311735+00
356	2	C133D132DF02FCA04731F7C2CAB8F0BD044ABA1CFA6251D447D3DD04C64DE8D7	2026-09-24 11:40:32.393906+00	\N
360	1	A602DA21B0F752E4CF1D0BC4C6023819FA7EA93A3A786A78B79C9A2CBB697B01	2026-09-24 12:08:32.485477+00	2026-09-10 12:09:03.979726+00
380	1	59D979CE8881337E019594B37E01C7B3E0FCFDB2A387DECA9D962E1DE49C52F4	2026-09-24 23:13:27.931129+00	2026-09-10 23:23:00.413226+00
385	2	3EB6A99B4830F37A84D5C35041B34B0F581873BBC1437CF8AF8989411DB04CC1	2026-09-24 23:31:46.093554+00	2026-09-10 23:37:43.637304+00
389	1	F83FE2959CDBCD87DF4E58C6EC501B0FF272E776CF2B260857DFE38DA572FFC3	2026-09-25 00:19:30.1863+00	2026-09-11 00:31:17.73547+00
431	1	A9B96B022BD67B675F4FDA65095861D46DF32654303D5166A9D74846BA996E23	2026-09-25 05:15:26.292574+00	2026-09-11 05:15:39.733597+00
395	1	BD3A43BBA36E4ADCB8CB9D371B782CAF11779B058654024C8133C8CA4535060D	2026-09-25 00:39:16.963233+00	2026-09-11 00:39:30.103269+00
398	1	7BE70890BF638ED75EC91AF5492DB939E9CFD2BA8F323BE0142BA833F0F90050	2026-09-25 00:40:00.332352+00	2026-09-11 00:40:48.73078+00
406	1	0B2FF80A9CCB93CFBE1AF1D524B7575F75E78191E193F895A7C7A1545680C928	2026-09-25 00:53:57.002325+00	\N
414	1	332C2608E2A16C8AED1F8FDDCC8BAF401F0EA4F84B0BBAE76C0B45368E6D0EDA	2026-09-25 03:00:59.563071+00	2026-09-11 03:30:03.576054+00
410	1	790ECD6F6996A7E547E78F2989F7CA759C20EDB536CC0815453F5798E5BF3DBD	2026-09-25 01:32:38.92119+00	2026-09-11 02:17:25.886046+00
418	1	EAFEEF94720710FA02DE676EBE1F754C21B8ACA5499CE43D9E5BC48648EE7F98	2026-09-25 03:52:39.572026+00	2026-09-11 04:01:39.745696+00
422	1	A74A1E4EBBA53ECDC0F386D15D87C50C8D3017B1FC7B62649DCD91CBBD5C47B3	2026-09-25 04:43:03.399152+00	2026-09-11 04:48:41.848673+00
427	1	E05A4AFD2D6817C255FF1FD817B1C390A72B628A6E83A690FF46EF09A1A9A4FF	2026-09-25 05:15:24.408016+00	2026-09-11 05:15:25.565843+00
429	1	373027EB2B3745A92AD5AC8EBF0EDB72EC56636A3B93ADBAC1E6B40A9771DA31	2026-09-25 05:15:25.565911+00	2026-09-11 05:15:26.292501+00
437	1	73E0CAB5880CF75C6A446CD0BE086122CA653A6BF2201CFA754305BCBEEC09B6	2026-09-25 05:32:43.235163+00	\N
439	1	C71C869A5AEF739029282BDBC4EAD94ECF0E84E20FB90E4DE83C2996EEE61B2C	2026-09-25 05:32:43.999135+00	\N
445	1	A5B2B94B480A71057A2EB62F126989D6DC8339884A989B9D61C38DF23AB6F4A3	2026-09-26 00:02:53.180819+00	2026-09-12 00:23:07.162996+00
449	1	B7C1E0F578DEF82BE2680A318CF09162A4551D0CE663034F3A3A44F1A12E8118	2026-09-26 00:26:34.687689+00	2026-09-12 00:33:01.169733+00
453	1	CEEC6424CD9288EC4CB907C0D43C73F90DFA208123546EB03A4FFCBEBE8D21E9	2026-09-26 00:56:39.466413+00	2026-09-12 00:57:19.330285+00
213	1	99AFB297F68532E9CFC833F33E6D1C823B523790CA64A6019B0B1956E080923F	2026-09-23 04:59:38.943282+00	2026-09-09 05:01:43.204099+00
217	1	98D1635FED336F6CC0BBC4A8F0DD5578CBE1FA7125D8E3E4838DFB25FCCA00C1	2026-09-23 05:13:20.930368+00	\N
220	4	86435E5031C2489ADC184B72E61CD9621BBAF10BE668830AF99E840E701A9E78	2026-09-23 05:14:18.189268+00	\N
221	4	2600AEE890B304BAD170F9A09CE272F6CB67CE9D1893B7BB7B72C0BA20071520	2026-09-23 05:14:19.517727+00	2026-09-09 05:18:41.572447+00
339	1	9074C27D1AE1B67EC7C74DCFEA5753DB7EC5E46841B1C922CC42B95B9712C4BE	2026-09-24 04:38:47.895496+00	\N
260	4	756F17ACF995DBC985072CABDF7B43C2C941D4728CCFE4011DCF6E50FB6AE4BD	2026-09-23 10:41:02.829999+00	2026-09-09 10:53:26.013946+00
225	4	86138A85E20AA4BEBDE682F4505AEF148C9B36AB8E669B826D37CC778F61E950	2026-09-23 05:18:47.361803+00	2026-09-09 05:19:03.661381+00
264	1	4D77CFEFBA77D9EBADA28AB2251C76EAAE3E1C9B5C296C404CE8A40BA0C8B4DA	2026-09-23 11:04:25.094523+00	2026-09-09 11:05:31.495306+00
241	4	BEEEF94CA35E96FF407C055D226EF7A63559BDFCF7041EAECB6FD48D3036726B	2026-09-23 05:44:51.945647+00	2026-09-09 05:46:05.440656+00
266	2	D03FD69A45992E8ADC5C7C9B2CC3C12B271CF30F4D9346C907E8EBAB0632C116	2026-09-23 11:06:13.711177+00	2026-09-09 11:06:31.419962+00
246	1	442BEF1BCF8FF2F6D1162CE291575675E7AECC99F7FACDE23720686F93FFF5E5	2026-09-23 05:51:54.142917+00	\N
245	1	D0FA761BD57D4733CA99505644884C84DB19C55BBD6A4F662AC72C28EED2F491	2026-09-23 05:51:16.648372+00	2026-09-09 05:51:54.147839+00
251	1	31759978D6521AC78939F3E91241957B1B2C5EB7278CAB59F74A88406C4B326A	2026-09-23 06:05:21.840107+00	2026-09-09 06:06:33.935087+00
269	2	FF59FD92FD31BFD726FF1A88BE000ABEFB16D6CD921AA3E8230CC92A06A171E9	2026-09-23 11:16:49.256263+00	2026-09-09 11:27:11.070999+00
254	2	183460E2BF0C8D8A36DABEDA78DFBE0EC44CA794201C2E3287D7A12E4C70C715	2026-09-23 10:02:46.593864+00	2026-09-09 10:04:05.558061+00
274	2	6CABF56640337F9E67D5491345FB8B5D1B0699C4F5D813B5F7AE9C106B497AC1	2026-09-23 11:56:40.842162+00	2026-09-09 11:56:46.045808+00
275	2	E14F5B5772553A0BC7287A5A3C7475DF51C1A7126B3F6561C2074729E90C6A80	2026-09-23 11:57:03.535907+00	2026-09-09 12:08:47.992219+00
281	4	68BCC4DF867CB5759FC3AD4F9AA0D84CFCCFACE42FA7916714285820F3ABF4E1	2026-09-23 22:15:20.326805+00	2026-09-09 22:17:26.256203+00
285	2	6DD5770BB5F3658A5EC6E33EFFCABF3744B9343F3267846CE4D95AC0B9BF12C8	2026-09-23 22:25:10.602612+00	2026-09-09 22:28:42.451215+00
342	1	CEC8A0DB809109B8DBCA5F7BC2AF40A6C446E5AC90C26787A037CFAC37879B1F	2026-09-24 04:57:21.737489+00	2026-09-10 05:49:01.695191+00
291	1	DD5C3C2A37B34CE837268364EFF1C32495841DF70766D731A688259F61876608	2026-09-23 23:42:12.400468+00	\N
290	1	70AD033EAA0EA6C2D606B273D7BBD19FFAA0D3AF6991DD92456FD1D01CFF350B	2026-09-23 23:42:11.65143+00	2026-09-09 23:42:12.400385+00
295	1	AFD61BDF2A14E236B2A0956E022E0504534565C7F382E05CED79BA0BFEBD2B66	2026-09-23 23:59:39.259594+00	2026-09-10 00:03:11.288961+00
347	1	C858C833DA3A4B6ECBB276D4DA47BC5744B2FD123478E564C30613C1159D420D	2026-09-24 11:20:38.730008+00	2026-09-10 11:21:38.602756+00
299	1	9C691D8FFDF3DDBF5380F510CBE3C281BEEE2EB3760787DB2AA012209B143A72	2026-09-24 00:07:05.637889+00	2026-09-10 00:13:39.831264+00
310	1	B44747668CD1ED904F446F12FD911C7C59C705921B566B6D0C76E8C33513ED63	2026-09-24 00:23:36.413078+00	2026-09-10 00:34:02.674347+00
381	4	B9CC08B8614364A558F9680F973B61E9EAD45649D52CE15398A7ABD657EA235D	2026-09-24 23:23:08.127268+00	2026-09-10 23:24:40.43906+00
314	1	B28967EC4DC2F844F9CD2E258666337995C28444C719F3D2528424AA0C1780A2	2026-09-24 00:57:59.08203+00	2026-09-10 01:17:20.743078+00
351	2	F00E962045AF155A2A82B961B14B2E1A584EFACD490F07B3A3F554137E23836E	2026-09-24 11:27:32.311846+00	2026-09-10 11:36:26.170092+00
322	1	8BA31AD8A5360663FE4A9DB5AB45809FA3351158F82003CD5508E018227481D0	2026-09-24 01:44:34.384482+00	2026-09-10 01:48:49.098063+00
326	1	E9F6B7D8708BF1602A7B1EC2C44C527C314399ABF5A394183D12CB6DB991D632	2026-09-24 02:13:12.91571+00	2026-09-10 02:33:56.059176+00
330	1	9D555171728533B67D8A5CB6E0752BA55C4F32DC60D0671C35D38B45D93EF14F	2026-09-24 04:21:16.065833+00	\N
334	1	681DA28D8C4ABBC4215386DEEC3194E6964557CFC1DA9DECF25762DD1FFB796A	2026-09-24 04:36:59.23888+00	\N
337	1	B5A9B940BBCA53AB4219E8B0B9E36699BFD4AB41B35848B6C0A56B4B55F1F4C2	2026-09-24 04:38:14.850403+00	\N
336	1	E3AAA39A5A9C9124897C7B96AC057C9B89581DF3A4873BA342175C4600D2B102	2026-09-24 04:37:56.731497+00	2026-09-10 04:38:14.850259+00
357	2	10F7621176A8D6CA9735278E9FBCBB587652426B1DA5DD5DF4B83E1D1AD8DE01	2026-09-24 11:40:32.398729+00	2026-09-10 11:42:34.32398+00
382	2	10645D0B2124B68D544A5749401E3BC4713F6C436C93EB7A7D897F107E8ADCD5	2026-09-24 23:24:47.040337+00	2026-09-10 23:24:51.659303+00
386	1	86B4A51919F143C700CD8CBCA1E5D504B727FC4475DBEF3FFE3CF58E4A638628	2026-09-24 23:37:50.58258+00	2026-09-11 00:02:36.566106+00
363	3	2D122864BE83AA68156EB542F8EA23CA7B7D48F626C793B96262B66E2BE2F541	2026-09-24 12:10:46.483111+00	2026-09-10 12:11:11.740485+00
364	3	A902127AC073F4B5863F51E864F709FD612D1FEEA42E1B6597B2D0C299792407	2026-09-24 12:11:37.843848+00	2026-09-10 12:13:39.899842+00
370	4	5FF0217C37FAF1ECC74FA3E285446846415BD79E14441904FCC6FD7997950FBA	2026-09-24 12:20:18.137387+00	2026-09-10 12:21:16.527035+00
371	2	57A7A254FC9C8261BC199BE85B5362D315420B9FEA0D70011B49BD43192EE1A4	2026-09-24 12:21:23.665606+00	2026-09-10 12:22:10.636354+00
373	1	9B33E6F241CFFA392B541DDA1C1BDC5B5D46616188D25E4DC5AFF84368395B08	2026-09-24 21:42:59.450528+00	2026-09-10 22:08:07.783554+00
377	1	5C872F336761BF95908B4D8646C2BBCE1CCEDD6F42F927E8136A189504C4FFEE	2026-09-24 22:39:52.378023+00	\N
450	2	D0A9D72EC21863E0B4FE06AE695F9D82ACDD90CA7758B29603EB819F43086B9E	2026-09-26 00:33:19.344532+00	2026-09-12 00:34:51.126318+00
390	1	0BBEE1BBF56A972C448C647E05D3F042C6471A208FF8B7059F8B9885B0016BC6	2026-09-25 00:31:17.735562+00	2026-09-11 00:34:04.439473+00
396	1	53AC892CFA56CC70BC13EB1DFC0E322640D5E527E90FD11E5026187820BB7ABE	2026-09-25 00:39:30.103926+00	\N
433	1	4828566AB98767459B594944D239EB094DFB34530C7FDD315432FA99852DA1E0	2026-09-25 05:16:56.930502+00	\N
407	1	6229248151085796AF2A410CC50167E8E59D7B3F92F2600BEFD5AD93F0A4D4CE	2026-09-25 00:53:57.007101+00	2026-09-11 01:22:28.069746+00
411	1	1D4133C988C1A6E11A038B095FF190D6CD2EA718FA9DDEDC4F75E0F1E129E0A6	2026-09-25 02:17:25.886138+00	\N
415	1	7BCC9E6C2BCBD63B995CAC97BD18499A83DC8550180235C5B15DB45026EB1E1C	2026-09-25 03:30:03.575027+00	\N
419	1	1565FAEFE1B112AFC6184BA0D45E02F7E59D8E236D132A240EF655F3AD0699B5	2026-09-25 04:01:45.226086+00	2026-09-11 04:03:31.270156+00
423	1	042D287F77DEBC7B924E1D0DCFA04578AAFE88840F95B13EC81021ED529D7547	2026-09-25 04:48:41.841812+00	\N
432	1	0D8B6B6DEC7CE3232884BEDBF20A0D9A8E2862C65FF8C5C02845748876E3761B	2026-09-25 05:16:41.153743+00	2026-09-11 05:16:56.930219+00
440	1	45D476909CD19C3FC509F444BF6AAFA609C1D370E15DD1EA1F6D82430E74BA6B	2026-09-25 05:32:43.999135+00	2026-09-11 05:55:19.058279+00
438	1	9D2CE918B66966275B39A0D16743C0AB385A50A47ABDA849CFECFA31E08AFCCF	2026-09-25 05:32:43.235165+00	2026-09-11 05:32:43.999008+00
446	1	1C333D16624EC49F2CEA17234053A0F963ADDD57EDFDF3BBC45E16C56E743A34	2026-09-26 00:23:07.163318+00	\N
454	2	CFFCB05B03C10194CD5AD8E4628DC2DD92AB1A9E0032D028D046D0D389C33922	2026-09-26 00:57:26.618864+00	2026-09-12 00:59:25.929289+00
457	1	4D7E2DAE682676E257BC2AC83CCC19A6B16CC54664230A589E7C3E0718C5C383	2026-09-26 01:14:42.186883+00	\N
214	1	AC6D3C6BDD5852181100EACC937A59B23A16DB70AAD76A7CCED55AB0E8CF3779	2026-09-23 05:01:43.204233+00	\N
261	4	F1F8B079E856A354423B3C9455CDC6975378E78135A12F4DB8F4090A7AA2FD96	2026-09-23 10:53:26.013996+00	\N
218	4	E673CD9F1318D535B5CFD3525E6BD4143FC271599ADC762F86682AF8AC18EBB0	2026-09-23 05:13:37.418556+00	2026-09-09 05:14:18.189203+00
222	4	D0BCD0603A40B74F1A8680D2579F60878B31E5C3A4AC62AAF07778D1A57B37BE	2026-09-23 05:14:19.519454+00	\N
229	4	EEDB8BCA7ACEEE9538DF60D36BFA2E210AADE7C59DAFFEB1EF03176AED124E15	2026-09-23 05:19:13.182081+00	\N
228	4	1B5FB2E2F7559682780E41540755A1EA0118B2E5E2C98B8E03F1B7941F3B97CB	2026-09-23 05:19:11.821228+00	2026-09-09 05:19:13.182042+00
237	1	FF7483885B3DFD4A54763EEDDFA56DD4A3C7ED545FA42FFB3EAFE2DE032FEF99	2026-09-23 05:37:01.342553+00	\N
265	2	97231907DF3BE6FF4243F2D2056D792812F0FF95FD0E9E8122FCB0955B17664B	2026-09-23 11:05:40.616474+00	2026-09-09 11:06:13.711115+00
242	1	02A5FFECC03870ADD61E7BA79405F35F048B156770FCD8E7A82F88D9ED1095E3	2026-09-23 05:46:17.149772+00	2026-09-09 05:50:50.654435+00
247	1	CC74DFCC9BEAFEE664EB95A6F6563A6E808319771BD92D207FC43FECC92996D0	2026-09-23 05:51:54.14793+00	2026-09-09 06:04:22.37806+00
270	1	199AA2D81F02365F2BAAFFEF08FEC6FB005F87AF965AA5E4B6409247EA11BDF0	2026-09-23 11:28:53.493576+00	2026-09-09 11:30:13.953937+00
255	1	E505CF058A50F15E2285DCA583019529B3B2E58218966575BE8662199BD7729E	2026-09-23 10:06:12.185024+00	2026-09-09 10:06:22.449074+00
256	1	A7BF582997A7F8599B1A8AE2F5EB70D1209651261C5CD173F896765F2CA0F1A0	2026-09-23 10:06:29.801714+00	2026-09-09 10:06:35.588882+00
277	2	16C2CEE56B662CC729D082F9E3B13F484B782EAC3DDB98181C145D936EC63450	2026-09-23 12:09:04.30627+00	\N
276	2	99B4D313CF85A7235E7C9724C99C6F9DC27ADB306886AD696F645A9D28632FEF	2026-09-23 12:08:47.992277+00	2026-09-09 12:09:04.308083+00
282	2	6DC223100AC8EC49777F1D9E868DECFB8F1DFA6FE4E1E095AF8042350A790175	2026-09-23 22:17:33.722455+00	2026-09-09 22:22:44.262829+00
287	2	BA3F2BE802827ABC60C262EA9A4D7F7FE114D9651C7DFA7A75F350075C7AAC95	2026-09-23 22:40:20.605698+00	2026-09-09 23:08:00.630661+00
296	1	6473BE3D8B82F73464323140FF3733F76AFD129B7F7A2FE17DAE580D04AB07C7	2026-09-24 00:03:11.28455+00	\N
300	1	25ACB4FFDCC05226AFCFAB79499CDB93A7E75299219EF64B1C17027016948A4F	2026-09-24 00:13:39.823003+00	\N
302	1	0179BD1593F3F301DEE61A6029051B4F8C85D7F94970EB5CDAB8070ED0088F3B	2026-09-24 00:15:57.946686+00	\N
304	1	1386107FAD1657B39D01EF4618340678F03C2B07D4088E339D53AC40E7A2D45D	2026-09-24 00:18:05.108123+00	\N
383	4	A354E4410350D9CBA1A83BC55C825D7BF4E696E9B211253D5F99930B9A6BDF6B	2026-09-24 23:24:58.725212+00	2026-09-10 23:26:10.499712+00
292	1	18EB80E1DC9786FB008F75D79472A86E6DC9838FE857208FFF14C54B245241A6	2026-09-23 23:42:12.400463+00	2026-09-10 00:20:55.024704+00
311	1	BCEF96C3AFF4DC64F2F5D54B284D0D41611F9D0D6A8B5DA741D1786B249F5E30	2026-09-24 00:34:02.671821+00	\N
315	1	7C3D06598FA7CE4927E6C33724093C344C8A39241C2BC75E989F0ADFFAF25B21	2026-09-24 01:17:20.743114+00	\N
318	1	1743C115FA9B8D46374E6D59E0D30DFCBF79E377AA11569FBD3A227B451DE3A8	2026-09-24 01:17:22.386988+00	2026-09-10 01:44:21.26601+00
323	1	3C474AD296AA7AD9B3DD4344A6F720AE8372F8D32D95407F46DBA385E1B4747E	2026-09-24 01:48:49.092041+00	\N
327	1	0F4E15F00F2E9603143E8E34B713404FCC5DC85CBFFE1CA2F3606A4EB72CE4EE	2026-09-24 03:47:18.391468+00	2026-09-10 04:12:33.982058+00
387	1	10BF88B7DB40B4FED00AB4A806E7C976FB1AC00E4E9351BE167ECC11FBA4FDEE	2026-09-25 00:02:36.566164+00	2026-09-11 00:03:48.85345+00
331	1	C16ED8D75FE7B7DB0741B7C10C0913A6D38B1D7608104CBBDD8EA0F1D1D36F69	2026-09-24 04:21:16.065833+00	2026-09-10 04:34:31.902902+00
391	1	F988823E6FF7ECC1853AACC9F97A16D58DD12FF6FCE1C894094B15E42A185CE5	2026-09-25 00:34:04.434564+00	\N
338	1	4B1F3BEB7781F24520747E429754A3DC5D5C3191B07AEAE47E3F91CE10EAAF14	2026-09-24 04:38:14.850323+00	2026-09-10 04:38:47.904658+00
393	1	70BFFCB583886E43EC994FACB307F3BA5A988A975E91825F790D5203754E66AE	2026-09-25 00:34:14.475875+00	\N
335	1	66B720775D4BB8DF997565C8386C754C3071A581AE5D0991A46F7226EBDFBF08	2026-09-24 04:36:59.238897+00	2026-09-10 04:57:21.737461+00
399	1	1EDD624FBA445EE155BB7802F497364E920525A1FA9D7C41D9A61375A03CFA68	2026-09-25 00:40:48.73094+00	\N
344	1	C0670D60EA0D07CF700DF06EA96256E55466BA08638871EF6676B7C587ADAAA0	2026-09-24 05:49:04.076432+00	\N
343	1	51BDD23E0C0BD8BF9F1DBFD8608BDA1DF27E9422F8975C880328CF5747BB6807	2026-09-24 05:49:01.695256+00	2026-09-10 05:49:04.076077+00
348	1	F99FC0F4DF0A60C9F5EAB4BA39AB0F089D23CB5EC37C6401F42E3763C4A485F0	2026-09-24 11:20:38.730008+00	\N
352	2	39D51BF05E66D6CA31B05AC21342EF2C09F40342F20606A279908A2BC310A2B6	2026-09-24 11:36:26.168942+00	\N
354	2	59398827BF8F562A4AA4C250FDB24D7A3EF3B632E5524FA215ED80A7081F7065	2026-09-24 11:36:58.688848+00	\N
358	1	DEECB2D5D7A5ED666D7EF9FA01D2D7937D1CAF5396B17551EBD6CD96C64ECB13	2026-09-24 11:42:42.013835+00	2026-09-10 11:52:05.425464+00
362	1	5FD9BEF0A31E5F0504E396F09AC7109C1E008F88099BAAD2546D6FB4847CFC96	2026-09-24 12:09:54.97388+00	2026-09-10 12:10:39.596826+00
374	1	2255413186D753C27A55A2C99C00C9620D64957D254D5521E877E0BFCBE1A290	2026-09-24 21:42:59.444888+00	\N
378	1	75E6EB49C11375208013BAC7974D6D10FFB1630A0CD38B1B431396EE88CC083D	2026-09-24 22:39:52.378024+00	2026-09-10 23:13:27.931068+00
424	1	F81CE459608B43A9ED04CD75AEF08EBAA6DA341CD5AABBA5CC228E06D059D318	2026-09-25 04:48:41.848754+00	2026-09-11 05:15:23.692511+00
403	1	59C31DCDE7130DD20EC85B61A9F3D3A9E525F6087E02D6739CEFF647C611F93F	2026-09-25 00:47:56.481793+00	2026-09-11 00:47:57.412664+00
405	1	34275D5315F3C470CF6A58C3FC40D7DE6B114B0EB6BB2B65C6D43B074240CBC7	2026-09-25 00:47:57.412753+00	2026-09-11 00:53:57.007046+00
408	1	8088550A7113D8BE6D3623FC5B8A0C780BB57A2D3E2D43DC8AC15B0C10302C82	2026-09-25 01:22:28.069916+00	\N
412	1	854E9B62B5608180A33DFF7AB867374380CC241925C356E1611D8DCA8A86F689	2026-09-25 02:17:25.886138+00	2026-09-11 03:00:59.56303+00
416	1	54046B8AFFB60B2C6EA1A73F27ECE35D055B0F26B71E70EA78EA517E615F8476	2026-09-25 03:30:03.576074+00	2026-09-11 03:43:01.263963+00
420	3	4F2E16766D0E657FB31E2BFAA7D552FDE8196F8C0AAF0A1AF2392C2DF64830E1	2026-09-25 04:03:51.32327+00	2026-09-11 04:04:15.834998+00
435	1	DB1D6F62E2BCA9CA7BFB7E6E20DF7DB3A829E68EA97F1BE6FA58119CBEB16DDF	2026-09-25 05:16:58.096087+00	\N
434	1	1C9F58D3D0B20E3DD01ADF829184E9B89960EBFA3D573F00EB66595E22C06F63	2026-09-25 05:16:56.930502+00	2026-09-11 05:16:58.094584+00
441	1	7775CD2DA544A0293FA421C472D615646D6EE68401484347BE01082B553EFB52	2026-09-25 05:55:19.058333+00	\N
444	1	4C395B41BBB85292F6EDF673EC3530E90392E361745A317003CF432150D964EB	2026-09-25 05:55:19.962783+00	\N
451	1	C87B986F28ED7E17512BCA898826A36BAFB78E282A8908B54A8F0581AD08BA9E	2026-09-26 00:34:57.896648+00	2026-09-12 00:55:04.272621+00
447	1	3145DACCE9C5884F29415A189E659E93F102339042B38E3F109F587790FB1430	2026-09-26 00:23:07.163322+00	2026-09-12 00:26:34.687596+00
455	1	EA9ED706C858A0CC5AD27C635A403DCEDA01ABF058A76C57E80A7F3B120AC848	2026-09-26 00:59:32.680031+00	2026-09-12 01:13:46.578001+00
458	1	6C45056AFD25396BCA06A70E52B649C51CE8E7D1715D06F8050978B3405501F0	2026-09-26 09:11:12.680058+00	2026-09-12 09:17:08.239638+00
211	1	9303E3A62B3098DC830120413CA7106C132DEF44EF2FD0E1EF9B482F4DA1CA58	2026-09-23 04:54:13.774061+00	2026-09-09 04:59:38.943203+00
262	4	C8E741287DFBBF9FE40F14621CC4146CC9703C73F079BAECED861D27D4047686	2026-09-23 10:53:26.013995+00	2026-09-09 10:54:40.604625+00
215	1	4A214F4E6B0AFC7C34C5345156BBDC65F28FADFA4DA53B160E11E93AFF9B69BA	2026-09-23 05:01:43.204251+00	2026-09-09 05:13:20.930181+00
223	4	3CBEB9B3851C098BAA0CE1ACA98220A38371F2AD720AAFFFBC1972621BC966B2	2026-09-23 05:18:41.572495+00	2026-09-09 05:18:47.361671+00
227	4	0017C7CCE85009CA4A707E2AA0052061A58C81A9125D0F2E5BC3BA29CE87E325	2026-09-23 05:19:03.661489+00	2026-09-09 05:19:11.821158+00
231	4	CE28FD16475FB192275B8C123BF66EAB87CC3CCF22ADA4AA1E6785CFF1EEE199	2026-09-23 05:19:13.709182+00	\N
233	4	D8898C9A5B1FC97670FF60A0E1D17309B2F2D65E00F8A7C99808ECA6C7F8EECA	2026-09-23 05:19:22.223787+00	2026-09-09 05:20:04.292462+00
238	1	9586A8F173389E6A046AD5824804E4E873202227B7A1E05891A0E2B8DA384CBB	2026-09-23 05:37:01.342552+00	2026-09-09 05:39:41.959539+00
239	4	228499BBE65A27542412D5284E5E3DAB7A8EA9AB2B72672E4E4D366C71E2CC93	2026-09-23 05:39:51.018821+00	2026-09-09 05:40:37.441522+00
243	1	68B2398856F19C08D9D6B0DDC2629133DE4F1A09FAE12AD276A9F8A3080E4BF6	2026-09-23 05:50:50.65462+00	\N
248	1	AF767D590C6E690932F86478AEAA8D8CE6F2BA21FB5AF568C98A2B3EF795A416	2026-09-23 06:04:22.378233+00	\N
267	2	80AD9431423C58B794C220E980DE0334976481F3C07B5B5CBFC75BF324F29EDE	2026-09-23 11:07:08.638148+00	2026-09-09 11:16:49.25588+00
252	2	FDDBD6144611DCA75160589C34D5ACDF08009828BE259F28964279AB65B11B44	2026-09-23 06:06:40.87441+00	2026-09-09 10:02:46.59368+00
257	1	5E4DDB004B11A4A826C925F1A998FE281FC7A0A49F9BF3B8E7E3005431A4171F	2026-09-23 10:06:35.589067+00	2026-09-09 10:32:42.840984+00
271	4	EB80295E8D2F32110D64F555A3DCE47C5A32C718299D477735C0EBB691EEDF6C	2026-09-23 11:55:24.224076+00	2026-09-09 11:55:49.038789+00
355	2	618680CF5A69A9978989A1F56F61E924A36142CF86A384EF9AD5B3D1722B6A15	2026-09-24 11:36:58.69679+00	2026-09-10 11:40:32.398629+00
272	2	D0B257711DC19A03E5F93B3E5E66F46E7A9C5C922E26A9D055127DB889864DDA	2026-09-23 11:55:59.684951+00	2026-09-09 11:56:40.842098+00
278	2	2294CC231A3EC00B8BFB3F63D7B807B30BC0A79A4F536D9C158703D4D65C7725	2026-09-23 12:09:04.308215+00	2026-09-09 12:11:16.326012+00
283	1	170C5CFCD99DC7B9A830B4929B0CBB5AB3CB03C56EB6C6B57EDF5ADC1CF99704	2026-09-23 22:22:50.799469+00	2026-09-09 22:24:04.101514+00
288	1	93F443FF17F578B8A40CF015F7C8B07AF58F4C5ADCCDEDCFF4F6754B0D33EB11	2026-09-23 23:20:03.738798+00	2026-09-09 23:42:11.651229+00
293	1	F845C31213C1FC7F79FF9134B69D5174B17CDAC345F62E6A7D53939E474FFCB9	2026-09-23 23:51:38.775764+00	\N
297	1	DEB30584F65DFEF43110DD56E1C2C46D09F972B27A5958DC8839EA663C3B36C9	2026-09-24 00:03:11.289009+00	2026-09-10 00:07:05.63786+00
359	1	FC1356497AA2991B981F3CB005AA6F5699F3019419C6A7922ED6FB231AB8AB93	2026-09-24 11:53:19.500756+00	2026-09-10 11:54:03.752002+00
301	1	ED3B2E5F1DB6E7C2CE051722B97C580263207946C7DC89500815662251E18D1B	2026-09-24 00:13:39.831346+00	2026-09-10 00:15:57.946638+00
303	1	8E52E4779B7E4E3CED789E57AFCB9AEACBA75257D34FB81F62235BAB10D4D2B0	2026-09-24 00:15:57.946687+00	2026-09-10 00:18:05.108054+00
305	1	585E5235483239557A1CD9B23D56EF555D0AE1F1A828189EDA1C37469A3621C3	2026-09-24 00:18:05.108123+00	2026-09-10 00:20:47.642283+00
312	1	3141F4F5CED56D0AE4A1314A60C48507CDA148C155A31E4F429016F651DD6A06	2026-09-24 00:34:02.674385+00	\N
365	1	EF027F3A1407B4CAC11FA3F14B9B944DADC7A07AD30DFB7A272A47D0DD0D01D6	2026-09-24 12:17:46.487189+00	2026-09-10 12:17:53.208204+00
317	1	AD4E4FC0DEFA43D37F4949C5C7D57EFB6381869A9A18EBF6D71CF6A5876A9B18	2026-09-24 01:17:22.386988+00	\N
316	1	C2CC8967E1ECEA7B0239953BB1B62B6A3AD5E72E351DBADE3AADFE52BDC6BF04	2026-09-24 01:17:20.743114+00	2026-09-10 01:17:22.386938+00
324	1	F19CE3E818650E5BD9ECDCB72FD393B6D967F922C7E5AB00796059A5E54BFE05	2026-09-24 01:48:49.098124+00	2026-09-10 02:13:12.915669+00
328	1	87F968AF08168D9ED08011FAFFCCFFAB840C2792F55C1FED6642C09624C76D74	2026-09-24 04:12:33.982105+00	\N
366	3	87F0335474C2A4BCBC16F373CC82DC7A4CDB6B6079F3DC69073BFED862054DE4	2026-09-24 12:18:12.121986+00	2026-09-10 12:18:43.799538+00
332	1	33B6A3A0A00168DE7835908FC8791A2AEB3341D8C4D243226093F411AA671EF0	2026-09-24 04:34:31.903074+00	2026-09-10 04:36:59.23881+00
340	1	73846334BABA7CD36CFDB2555EE9009791009F95B2559CDC511975ABC114B2B8	2026-09-24 04:38:47.905097+00	\N
345	1	B16AEFB98E9AAD63A1AF02347CB3475C757BEFB40B4E7439991B933B3689BFAC	2026-09-24 05:49:04.07616+00	2026-09-10 06:05:59.852614+00
349	4	45223E634FFB10F516D3B0588AD43B756AD3169A6FB063EC4D4F5E45C3BA2654	2026-09-24 11:21:52.599012+00	2026-09-10 11:23:04.226942+00
353	2	6F52146B3CD259E2611F0A1F002CC17E895AD60A67413764D9FB12DCFAD10624	2026-09-24 11:36:26.170204+00	2026-09-10 11:36:58.69673+00
369	1	CE052CF040892A69EB8C974104261E24499FA00AD24CA0E2242854BCE586C222	2026-09-24 12:19:49.526302+00	2026-09-10 12:20:08.860622+00
375	1	76D065A8AD40CE1CE6F9ED56F65AC9FCEB98DC1123087C91E5926526D49261E2	2026-09-24 22:08:07.783628+00	\N
379	1	5303569D9630FD1FD0E3BCEFAF4552D9C10E491ED6F308BA777CB4F29767EA33	2026-09-24 23:13:27.927353+00	\N
384	1	55576AA4E88CBD3BE4AFE702163F0305C789865E59D5021682944CCE21AC96E5	2026-09-24 23:26:21.745352+00	2026-09-10 23:31:40.236574+00
388	4	92ABD0132F0356AED26F5FA281EBEEB32CD5219F9E9CB441C389C708EE7950FD	2026-09-25 00:03:56.76184+00	2026-09-11 00:19:20.137816+00
409	1	5B52C00826E9ACEDA80DB835B3C40438C62B7397146E1433D95E211E2E7B2FE8	2026-09-25 01:22:28.069916+00	2026-09-11 01:32:38.921148+00
392	1	6DE136CF4E0367A1D35EBEBC27230D08AB4AA6D7C704641B38F8C18400544BED	2026-09-25 00:34:04.439541+00	2026-09-11 00:34:14.476663+00
394	1	C06A3753B278170D8196DCC9A52B6682CE44C86480EFF0AB5F690CFDADEE6261	2026-09-25 00:34:14.476704+00	2026-09-11 00:39:16.963148+00
400	1	B39E73F0FAE51277004795C6B33E75F533EF4645DD6DAC7E708495D3D937E26C	2026-09-25 00:40:48.730936+00	\N
413	1	4D558C748C0BB30B670CBD8F395B3734657B8AE6591FE3FA2882838BE21EE952	2026-09-25 03:00:59.556525+00	\N
402	1	22A780994BAE81D62E0A6B12FCCCE9050C3FB0397CA82E82B7DA53E6F5042B96	2026-09-25 00:47:56.481711+00	\N
401	1	5FBC412FBB5704158F347E16C363E5745519E55AF74FC62F7A9BDEEBBBC90396	2026-09-25 00:40:51.850058+00	2026-09-11 00:47:56.481669+00
404	1	1660177A90FA925E532A609F20975D2526775CF1EC553214271959B57984B709	2026-09-25 00:47:57.412754+00	\N
417	1	7947DDE97041883E8310481AA31CB4B3750C235736A3A1774A802E7C9736512D	2026-09-25 03:43:01.264082+00	\N
421	1	E5F933C16406F86E2CAA3027A3921B9A50E4AF52AAE55447FD951A10913E697B	2026-09-25 04:04:22.379455+00	2026-09-11 04:43:03.399035+00
430	1	6156A68764322ADDCEF0FDF1D3938847570147AEC07E64273AC93950EF2DD99A	2026-09-25 05:15:26.289638+00	\N
426	1	D64A9F66BF81C7B37D10C68C40FDE03F7B9DAABC962D8EA5AA0A120FC5B39D18	2026-09-25 05:15:24.408016+00	\N
425	1	FE3E5C2CC26C575A18A9AE39B4DA571B1ABE1168ECE736FE11C7FA05D69D07C3	2026-09-25 05:15:23.692567+00	2026-09-11 05:15:24.407952+00
428	1	5CC0E57024061CC5CE4F66828C05D7A7229977B9EB4F52D9867EDDEBED215FF3	2026-09-25 05:15:25.561694+00	\N
436	1	FECA04516C6D61F5A32281D0DEDD14BAC91F51F3351BF32E3C2C5AF809E94770	2026-09-25 05:16:58.096117+00	2026-09-11 05:32:43.235039+00
448	1	32082D52792EACAA8B8FB8323904B39DC7A67EDB145EEEBD25DD0F4B767FB59A	2026-09-26 00:26:34.687689+00	\N
443	1	7701DF9F35A8711CFABEF106240B610BD88181F88CCAB59E360E7CB90EEAA78E	2026-09-25 05:55:19.962783+00	\N
442	1	1A03113317FBEF77CCDB29D1EE6817E636EF850D2EBF5A8EE8E4C41BEC477694	2026-09-25 05:55:19.058333+00	2026-09-11 05:55:19.962744+00
452	4	3CF166BB0CE19FB938540EB2F5C8320E24CD32EA92825742BF45B17ACC5349CF	2026-09-26 00:56:08.923468+00	2026-09-12 00:56:27.572792+00
456	4	0DA5F945BFF3B219DB547348F2672D12E2279DF68717EC63C3A6C497E560BC3D	2026-09-26 01:13:59.411633+00	2026-09-12 01:14:34.789937+00
\.


--
-- Data for Name: surveyReportVersions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."surveyReportVersions" ("reportVersionId", "surveyId", "versionNumber", "createdAt", "createdBy", "reportJson") FROM stdin;
\.


--
-- Data for Name: surveyStandardAssignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."surveyStandardAssignments" ("surveyStandardAssignmentId", "surveyId", "standardId", "surveyorId") FROM stdin;
4	2	1	5
5	2	2	5
24	1	1	6
25	1	2	6
26	1	5	8
27	1	6	8
28	1	7	6
29	1	8	7
30	1	10	6
31	1	13	8
32	1	17	8
\.


--
-- Data for Name: surveyTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."surveyTypes" ("surveyTypeId", "surveyTypeName", description) FROM stdin;
1	Internal	These are the internal, self-rating survey(s) conducted in-house by the health facility.
2	External	The National Health Facility Accreditation Survey conducted by the recognized national body, and its surveyors.
\.


--
-- Name: categories_categoryId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."categories_categoryId_seq"', 2, true);


--
-- Name: complianceAssessments_complianceAssessmentId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."complianceAssessments_complianceAssessmentId_seq"', 732, true);


--
-- Name: complianceEvidenceChecks_complianceEvidenceCheckId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."complianceEvidenceChecks_complianceEvidenceCheckId_seq"', 2128, true);


--
-- Name: compliances_complianceId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."compliances_complianceId_seq"', 366, true);


--
-- Name: components_componentId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."components_componentId_seq"', 10, true);


--
-- Name: creditationStatuses_creditaitonStatusId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."creditationStatuses_creditaitonStatusId_seq"', 1, true);


--
-- Name: criteria_criterionId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."criteria_criterionId_seq"', 130, true);


--
-- Name: districts_districtId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."districts_districtId_seq"', 96, true);


--
-- Name: evidence_evidenceId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."evidence_evidenceId_seq"', 1066, true);


--
-- Name: facilities_facilityId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."facilities_facilityId_seq"', 2, true);


--
-- Name: functions_functionId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."functions_functionId_seq"', 6, true);


--
-- Name: levels_levelId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."levels_levelId_seq"', 4, true);


--
-- Name: organizations_organizationId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."organizations_organizationId_seq"', 4, true);


--
-- Name: provinces_provinceId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."provinces_provinceId_seq"', 22, true);


--
-- Name: refreshTokens_refreshTokenId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."refreshTokens_refreshTokenId_seq"', 458, true);


--
-- Name: regions_regionId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."regions_regionId_seq"', 4, true);


--
-- Name: riskRatings_riskId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."riskRatings_riskId_seq"', 4, true);


--
-- Name: roles_roleId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."roles_roleId_seq"', 5, true);


--
-- Name: scores_scoreId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."scores_scoreId_seq"', 7, true);


--
-- Name: specializations_specializationId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."specializations_specializationId_seq"', 4, true);


--
-- Name: standards_standardId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."standards_standardId_seq"', 20, true);


--
-- Name: surveyReportVersions_reportVersionId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."surveyReportVersions_reportVersionId_seq"', 2, true);


--
-- Name: surveyStandardAssignments_surveyStandardAssignmentId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."surveyStandardAssignments_surveyStandardAssignmentId_seq"', 32, true);


--
-- Name: surveyTypes_surveyTypeId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."surveyTypes_surveyTypeId_seq"', 2, true);


--
-- Name: surveyorCertStatuses_surveyorCertStatusId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."surveyorCertStatuses_surveyorCertStatusId_seq"', 5, true);


--
-- Name: surveyors_surveyorId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."surveyors_surveyorId_seq"', 8, true);


--
-- Name: userAccounts_userAccountId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."userAccounts_userAccountId_seq"', 4, true);


--
-- Name: users_userId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."users_userId_seq"', 5, true);


--
-- PostgreSQL database dump complete
--


