BEGIN;
SET LOCAL lock_timeout = '5s';
DO $$ BEGIN IF NOT EXISTS(SELECT 1 FROM functions WHERE "functionId"=4 AND "functionNumber"='4') OR NOT EXISTS(SELECT 1 FROM components WHERE "componentId"=6 AND "componentNumber"='6') THEN RAISE EXCEPTION 'Parent mapping changed'; END IF; IF EXISTS(SELECT 1 FROM standards WHERE lower("standardNumber") IN ('23b','23c','23d','23e','23f')) THEN RAISE EXCEPTION 'Target standard already exists; review before importing'; END IF; END $$;
CREATE TEMP TABLE import_s (standard_number text NOT NULL, title text NOT NULL, summary text NOT NULL) ON COMMIT DROP;
INSERT INTO import_s VALUES
('23b','Paediatrics','Standard 23: provision of and continuity of care (mandatory standard)
The Healthcare Organisation ensures patients are provided with safe, high- quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.
The Healthcare Organisation should implement evidence-based practice and a have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.

Source references
Standard 17 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standard

Criterion guidance
23b.1 Organisation and management
The Medical Services shall be organised, directed and coordinated with other services in the facility to provide a standard of inpatient and outpatient care to the community in a safe, effective, efficient and caring manner. The medical services should be accessible, and continuity of care assured.

23b.2 Human resources and development
The Medical Services shall be organised, directed and coordinated with other services in the facility to provide a standard of inpatient and outpatient care to the community in a safe, effective, efficient and caring manner. The medical services should be accessible, and continuity of care assured.

23b.3 Policies and procedures
There are written and dated policies for all activities of the Medical Services. These policies reflect current standards of medical practice, relevant regulations and statutory requirements. These policies and procedures, terms of reference, by laws, rules and regulations state how the clinical staff regulate themselves and provide patient care.

23b.4 Facilities and equipment
The Head of Medical Services shall ensure adequate facilities and equipment that are safe and appropriate are available for the staff to function effectively and to meet the goals and objectives of the Medical Services.

23b.5 Safety and performance improvement activities
The Head of Medical Services shall ensure the provision of quality performance with staff involvement in the continuous safety and performance improvement activities of the Medical Services.'),
('23c','Obstetrics and gynaecology','Standard 23: provision of and continuity of care (mandatory standard)
The Healthcare Organisation ensures patients are provided with safe, high- quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.
The Healthcare Organisation should implement evidence-based practice and a have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.

Source references
Standard 17 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standard

Criterion guidance
23c.1 Organisation and management
The Obstetrics and Gynaecology (O&G) Services shall be organised, directed and coordinated with other services in the facility to provide a standard of inpatient and outpatient care to the community in a safe, effective, efficient and caring manner. The medical services should be accessible, and continuity of care assured.

23c.2 Human resources and development
The Obstetrics and Gynaecology Services shall be directed by a qualified and competent medical practitioner, and staffed by suitably qualified and competent clinical staff to achieve the goals and objectives of its Services. There are sufficient staffing levels, a staff supervision structure, performance appraisals and ongoing commitment to continuing medical education.

23c.3 Policies and procedures
There are written and dated policies for all activities of the Obstetrics and Gynaecology Services. These policies reflect current standards of medical practice, relevant regulations and statutory requirements. These policies and procedures, terms of reference, by laws, rules and regulations state how the clinical staff regulate themselves and provide patient care.

23c.4 Facilities and equipment
The Head of Obstetrics and Gynaecology Services shall ensure adequate facilities and equipment that are safe and appropriate are available for the staff to function effectively and to meet the goals and objectives of the Services.

23c.5 Safety and performance improvement activities
The Head of Obstetrics and Gynaecology Services shall ensure the provision of quality performance with staff involvement in the continuous safety and performance improvement activities of the Medical Services.'),
('23d','Emergency medicine','Standard 23: provision of and continuity of care (mandatory standard)
The Healthcare Organisation ensures patients are provided with safe, high- quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.
The Healthcare Organisation should implement evidence-based practice and a have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.

Source references
Standard 17 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standard

Criterion guidance
23d.1 Organisation and management
The Emergency Services shall provide quality care which shall be organised, directed and coordinated with other services in the Facility according to the goals and objectives of the Facility to meet the needs of the patient population being served.

23d.2 Human resources and development
The Emergency Services shall be directed by a qualified and competent medical practitioner, and staffed by suitably qualified and competent clinical staff to achieve the goals and objectives of the Emergency Services. There are sufficient staffing levels, a staff supervision structure, performance appraisals and ongoing commitment to continuing medical education.

23d.3 Policies and procedures
There are written and dated policies for all activities of the Emergency Services. These policies reflect current standards of medical practice, relevant regulations and statutory requirements. These policies and procedures, terms of reference, by laws, rules and regulations state how the clinical staff regulate themselves and provide patient care.

23d.4 Facilities and equipment
There are facilities and equipment that are safe and appropriate for the staff to function effectively and to meet the goals and objectives of the Emergency Services.

23d.5 Safety and performance improvement activities
The Head of Emergency Services shall ensure the provision of quality performance with staff involvement in the continuous safety and performance improvement activities of the Emergency Services.'),
('23e','Psychiatry and mental health','Standard 23: provision of and continuity of care (mandatory standard)
The Healthcare Organisation ensures patients are provided with safe, high- quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.
The Healthcare Organisation should implement evidence-based practice and a have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.

Source references
Standard 17 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standard

Criterion guidance
23e.1 Organisation and management
The Psychiatry Services shall be organised, directed and coordinated with other services in the Facility to provide a high standard of inpatient and outpatient care to the community in a safe, efficient, effective, evidence- based and caring manner and with due regard for the needs, dignity and privacy of patients and confidentiality of their personal information. The Psychiatry Services shall be easily accessible, and continuity of care assured.

23e.2 Human resources and development
The Psychiatry Services shall be directed by a qualified and competent medical practitioner, and staffed by suitably qualified and competent clinical staff to achieve the goals and objectives of the Psychiatry Services. There are sufficient staffing levels, a staff supervision structure, performance appraisals and ongoing commitment to continuing medical education.

23e.3 Policies and procedures
There are written and dated policies for all activities of the Psychiatry Services. These policies reflect current standards of medical practice, relevant regulations and statutory requirements. These policies and procedures, terms of reference, by laws, rules and regulations state how the clinical staff regulate themselves and provide patient care.

23e.4 Facilities and equipment
The Head of Psychiatry Services shall ensure adequate facilities and equipment that are safe and appropriate are available for the staff to function effectively and to meet the goals and objectives of the Psychiatry Services.

23e.5 Safety and performance improvement activities
The Head of Psychiatry Services shall ensure the provision of quality performance with staff involvement in the continuous safety and performance improvement activities of the Psychiatry Services.'),
('23f','Ophthalmology','Standard 23: provision of and continuity of care (mandatory standard)
The Healthcare Organisation ensures patients are provided with safe, high- quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.
The Healthcare Organisation should implement evidence-based practice and a have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.

Source references
Standard 17 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standard

Criterion guidance
23f.1 Organisation and management
The Ophthalmology Services shall be organised, directed and coordinated with other services in the facility to provide a standard of inpatient and outpatient care to the community in a safe, effective, efficient and caring manner. The Ophthalmology services should be accessible, and continuity of care assured.

23f.2 Human resource and development
The Ophthalmology Services shall be directed by a qualified and competent medical practitioner, and staffed by suitably qualified and competent clinical staff to achieve the goals and objectives of the Ophthalmology Services. There is sufficient staffing levels, a staff supervision structure, performance appraisals and ongoing commitment to continuing medical education.

23f.3 Policies and procedures
There are written and dated policies for all activities of the Ophthalmology Services. These policies reflect current standards of medical practice, relevant regulations and statutory requirements. These policies and procedures, terms of reference, by laws, rules and regulations state how the clinical staff regulate themselves and provide patient care.

23f.4 Facilities and equipment
The Head of Ophthalmology Services shall ensure adequate facilities and equipment that are safe and appropriate are available for the staff to function effectively and to meet the goals and objectives of the Ophthalmology Services.

23f.5 Safety and performance improvement activities
The Head of Ophthalmology Services shall ensure the provision of quality performance with staff involvement in the continuous safety and performance improvement activities of the Ophthalmology Services.');
CREATE TEMP TABLE import_c (standard_number text NOT NULL, number text NOT NULL, title text NOT NULL) ON COMMIT DROP;
INSERT INTO import_c VALUES
('23b','23b.1','Organisation and management'),
('23b','23b.2','Human resources and development'),
('23b','23b.3','Policies and procedures'),
('23b','23b.4','Facilities and equipment'),
('23b','23b.5','Safety and performance improvement activities'),
('23c','23c.1','Organisation and management'),
('23c','23c.2','Human resources and development'),
('23c','23c.3','Policies and procedures'),
('23c','23c.4','Facilities and equipment'),
('23c','23c.5','Safety and performance improvement activities'),
('23d','23d.1','Organisation and management'),
('23d','23d.2','Human resources and development'),
('23d','23d.3','Policies and procedures'),
('23d','23d.4','Facilities and equipment'),
('23d','23d.5','Safety and performance improvement activities'),
('23e','23e.1','Organisation and management'),
('23e','23e.2','Human resources and development'),
('23e','23e.3','Policies and procedures'),
('23e','23e.4','Facilities and equipment'),
('23e','23e.5','Safety and performance improvement activities'),
('23f','23f.1','Organisation and management'),
('23f','23f.2','Human resource and development'),
('23f','23f.3','Policies and procedures'),
('23f','23f.4','Facilities and equipment'),
('23f','23f.5','Safety and performance improvement activities');
CREATE TEMP TABLE import_co (standard_number text NOT NULL, criterion_number text NOT NULL, number text NOT NULL, summary text NOT NULL) ON COMMIT DROP;
INSERT INTO import_co VALUES
('23b','23b.1','23b.1.1','The Vision, Mission of the Facility are accessible. The Goals of the Medical Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.'),
('23b','23b.1','23b.1.2','There is a mechanism to ensure effective interaction between the Head of the Services and the Organisation’s Governing Body and Senior Management.'),
('23b','23b.1','23b.1.3','Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the Medical Services. These meetings are minuted and communicated to all staff.'),
('23b','23b.1','23b.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care.
The following, among others, are available;
a.) workload/census for inpatients and outpatients
b.) quarterly and annual report
c.) incident reports and register
d.) staffing number and staff profile
e.) staff training records
f.) data on performance improvement'),
('23b','23b.2','23b.2.1','The are written and dated job descriptions for each category of staff that include:
a.) Qualification, training and experience for the position
b.) Lines of authority
c.) Accountability, functions and responsibilities
d.) Reviewed when required if there is major change in job scope
e.) Statutory regulations
f.) Administrative and clinical job scope'),
('23b','23b.2','23b.2.2','The staff holds current registration with the relevant professional body.'),
('23b','23b.2','23b.2.3','The staff works within their job description and job scope.'),
('23b','23b.2','23b.2.4','There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice.'),
('23b','23b.2','23b.2.5','The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.'),
('23b','23b.2','23b.2.6','In a Facility where undergraduate medical, nursing and allied health training programmes are conducted, the Facility shall ensure there are sufficient skilled trained staff to provide clinical supervision of students.'),
('23b','23b.2','23b.2.7','Staff including medical practitioners receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('23b','23b.2','23b.2.8','Where appropriate the Facility shall endeavour to undertake clinical research using available resources.'),
('23b','23b.2','23b.2.9','Staffing levels are based on the following;
a.) The number of persons deployed is proportional to the number of patients being cared for as per regulatory requirements and for the intensity of care provided
b.) The categories of service providers reflect the complexity of clinical problems being managed
c.) Staffing needs shall take into consideration absences due to leave or illness; double shift duties by clinical staff shall be documented and monitored
d.) Adequate staffing levels of appropriate competency shall be maintained throughout the hours the services are in operation.
e.) Where it is not possible to have service providers on duty on site, e.g. after working hours, provision is made for relevant medical practitioner to be available on call.'),
('23b','23b.2','23b.2.10','There is a structured orientation programme for all newly appointed staff to the Medical Services including medical practitioners and for those new to specific areas that include the following;
a.) Explanation of the goals, objectives, policies and procedures of the Facility and those of the Medical Services
b.) Lines of authority and areas of responsibility
c.) Explanation of duties and functions
d.) Explanation of the methods of assigning clinical care and the standards of clinical practice
e.) Handover communication
f.) Processes for resolving practice/ethical dilemmas in a timely manner
g.) Information about safety procedures
h.) Training in basic/advanced life support techniques
i.) Methods of obtaining appropriate resource materials
j.) Staff appraisal procedures for the Medical Services
k.) Education on Patient and Family Rights'),
('23b','23b.3','23b.3.1','There are written policies and procedures for the Medical Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.'),
('23b','23b.3','23b.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('23b','23b.3','23b.3.3','The policies and procedures documentation shall address at least the following topics;
a.) Description of the organisational structure of the Psychiatry Services
b.) The use of updated Standard Treatment Guidelines.
c.) Handover communication
d.) Drug prescription, dispensing and administration
e.) Blood transfusion
f.) Continuing of care including regular review of patient and review of investigation results
g.) Admission and Discharge (planned or “At Own Risk”)
h.) Referrals and Repatriations
i.) Guardians for patients
j.) Management of cases with an infectious disease including notification of notifiable diseases
k.) Internal and External Disaster
l.) Incident reports
m.) Management of deaths.
n.) Health information system and Medical Records.
o.) Outreach and supervisory visits including school visits.
p.) Infection Prevention and Control
q.) Management of acutely deteriorating patients.
r.) Patient feedback and complaint mechanism.
s.) Informed consent'),
('23b','23b.3','23b.3.4','The service shall operate on a 24-hour basis providing level of care appropriate the facility.'),
('23b','23b.3','23b.3.5','The service shall ensure that provision of patient care and services achieve effective outcomes and is safe.'),
('23b','23b.3','23b.3.6','There is a standardised patient medical record.
This record should have the following;
a.) An identification page
b.) Vital sign monitoring sheet (BP, HR, SpO2, Conscious level)
c.) Patient history
d.) Clinical notes
e.) Consent form
f.) Diagnostic reports
g.) Final diagnosis and code at time of discharge
h.) Drug order/medication sheet
i.) Operating theatre sheet (if appropriate)
j.) Allergy and adverse reaction documentation
k.) Behaviour issues that may pose a risk.
l.) Discharge summary
m.) Referral form (if applicable)'),
('23b','23b.4','23b.4.1','There are adequate and appropriate facilities and equipment with proper utilisation of space to enable staff to carry out their professional, teaching and administrative functions.'),
('23b','23b.4','23b.4.2','Existing facilities shall consider the safety and comfort of staff and patients.'),
('23b','23b.4','23b.4.3','Suitable forms of communication systems and equipment are provided to enable clinical staff to communicate among themselves and with the other members of the healthcare team.'),
('23b','23b.4','23b.4.4','There is optimal management of beds at the Department with documentation of total number of beds and monitoring of bed occupancy rates.'),
('23b','23b.4','23b.4.5','Facilities are suitably located to facilitate easy access and to provide an atmosphere of user, environmental and ‘disabled’ friendly.'),
('23b','23b.4','23b.4.6','Equipment, both for emergency and non-emergency usage, shall be appropriate to the level of care.'),
('23b','23b.4','23b.4.7','There is evidence that the facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order.'),
('23b','23b.4','23b.4.8','Where specialised equipment is used, there is evidence that only staff who are trained and authorised by the Facility operate such equipment.'),
('23b','23b.4','23b.4.9','The Specialist Outpatient Services shall have the following features;
a.) The organisation and management of the clinics are planned to ensure minimal waiting time, and avoidance of unnecessary visits by the patients.
b.) Record keeping shall be efficient.
c.) An appointment or queuing system is used to manage patient consultations.
d.) The clinic is easily accessible including for non-ambulant patients and is easily identified through adequate signage.
e.) The clinic is located close to other facilities, e.g. radiology, laboratories and pharmacy.
f.) Adequate provision is made for patient comfort.
g.) Call back system (especially for high- risk cases)
h.) Avenue for patients to access service between appointments.
i.) Monitoring of data (number of Children Outpatient Department attendees annually- new and reattendance, number of family support centre attendances etc.)'),
('23b','23b.4','23b.4.10','At the Outpatient Clinic, adequate numbers of rooms are provided to ensure patient privacy and confidentiality for various patient care activities including:
a.) Consultation (not more than one patient in a room at any time).
b.) Minor procedures and nursing procedures.
c.) Performance of various tests.'),
('23b','23b.5','23b.5.1','There are planned activities for performance and quality improvement.'),
('23b','23b.5','23b.5.2','The Head of Medical Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.'),
('23b','23b.5','23b.5.3','Specific performance indicators are tracked for e.g.;
a.) Case fatality rates for pneumonia in children under 5 years.
b.) Percentage of children receiving their 3rd pentavalent at the hospital facility.
c.) Proportion of neonates born with birth weight less than 2500g annually
d.) Neonatal mortality rates annually
e.) Adverse drug reactions annually
f.) Deaths from adverse drug reactions annually'),
('23c','23c.1','23c.1.1','The Vision, Mission of the Facility are accessible. The Goals of the O &G Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.'),
('23c','23c.1','23c.1.2','There is a mechanism to ensure effective interaction between the Head of the Services and the Organisation’s Governing Body and Senior Management.'),
('23c','23c.1','23c.1.3','Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the Obstetrics and Gynaecology Services. These meetings are minuted and communicated to all staff.'),
('23c','23c.1','23c.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care.
The following (among others) are available:
a.) workload/census for inpatients and outpatients
b.) quarterly and annual report
c.) incident reports and register
d.) staffing number and staff profile
e.) staff training records
f.) data on performance improvement'),
('23c','23c.2','23c.2.1','The are written and dated job descriptions for each category of staff that include;
a.) Qualification, training and experience for the position
b.) Lines of authority
c.) Accountability, functions and responsibilities
d.) Reviewed when required if there is major change in job scope
e.) Statutory regulations
f.) Administrative and clinical job scope'),
('23c','23c.2','23c.2.2','The staff holds current registration with the relevant professional body.'),
('23c','23c.2','23c.2.3','The staff works within their job description and job scope.'),
('23c','23c.2','23c.2.4','There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice.'),
('23c','23c.2','23c.2.5','The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.'),
('23c','23c.2','23c.2.6','In a Facility where undergraduate medical, nursing and allied health training programmes are conducted, the Facility shall ensure there are sufficient skilled trained staff to provide clinical supervision of students.'),
('23c','23c.2','23c.2.7','Staff including medical practitioners receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('23c','23c.2','23c.2.8','Where appropriate the Facility shall endeavour to undertake clinical research using available resources.'),
('23c','23c.2','23c.2.9','Staffing levels are based on the following;
a.) The number of persons deployed is proportional to the number of patients being cared for as per regulatory requirements and for the intensity of care provided
b.) The categories of service providers reflect the complexity of clinical problems being managed
c.) Staffing needs shall take into consideration absences due to leave or illness; double shift duties by clinical staff shall be documented and monitored
d.) Adequate staffing levels of appropriate competency shall be maintained throughout the hours the services are in operation.
e.) Where it is not possible to have service providers on duty on site, e.g. after working hours, provision is made for relevant medical practitioner to be available on call.'),
('23c','23c.2','23c.2.10','There is a structured orientation programme for all newly appointed staff to the Obstetrics and Gynaecology Services including medical practitioners and for those new to specific areas that include the following;
a.) Explanation of the goals, objectives, policies and procedures of the Facility and those of the Medical Services
b.) Lines of authority and areas of responsibility
c.) Explanation of duties and functions
d.) Explanation of the methods of assigning clinical care and the standards of clinical practice
e.) Handover communication
f.) Processes for resolving practice/ethical dilemmas in a timely manner
g.) Information about safety procedures
h.) Training in basic/advanced life support techniques
i.) Methods of obtaining appropriate resource materials
j.) Staff appraisal procedures for the Medical Services
k.) Education on Patient and Family Rights'),
('23c','23c.3','23c.3.1','There are written policies and procedures for the Obstetrics and Gynaecology Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.'),
('23c','23c.3','23c.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('23c','23c.3','23c.3.3','The policies and procedures documentation shall address at least the following topics;
a.) Description of the organisational structure of the Obstetrics and Gynaecology Services
b.) The use of updated Standard Treatment Guidelines.
c.) Handover communication
d.) Drug prescription, dispensing and administration
e.) Blood transfusion
f.) Continuing of care including regular review of patient and review of investigation results
g.) Admission and Discharge (planned or “At Own Risk”)
h.) Referrals and Repatriations
i.) Guardians for patients
j.) Management of cases with an infectious disease including notification of notifiable diseases
k.) Internal and External Disaster
l.) Incident reports
m.) Management of deaths.
n.) Health information system and Medical Records.
o.) Outreach and supervisory visits
p.) Infection Prevention and Control
q.) Management of acutely deteriorating patients.
r.) Patient feedback and complaint mechanism.
s.) Informed consent'),
('23c','23c.3','23c.3.4','The service shall operate on a 24- hour basis providing level of care appropriate the facility.'),
('23c','23c.3','23c.3.5','The service shall ensure that provision of patient care and services achieve effective outcomes and is safe.'),
('23c','23c.3','23c.3.6','There is a standardised patient medical record.
This record should have the following:
a.) An identification page
b.) Vital sign monitoring sheet (BP, HR, SpO2, Conscious level)
c.) Partograph for antenatal patients
d.) Patient history
e.) Clinical notes
f.) Consent form
g.) Diagnostic reports
h.) Final diagnosis and code at time of discharge
i.) Drug order/medication sheet
j.) Operating theatre sheet (if appropriate)
k.) Allergy and adverse reaction documentation
l.) Behaviour issues that may pose a risk.
m.) Discharge summary
n.) Referral form (if applicable)'),
('23c','23c.3','23c.3.7','The Obstetrics and Gynaecology Services shall provide adequate level of monitoring appropriate to the obstetric patient’s risk level as follows:
a.) For non-high-risk patients:
i. Maternal and foetal monitoring, frequency as described.
ii. Monitoring in latent phase of labour shall be at an appropriate level
iii. Patients in established labour should be managed in a labour delivery suite
iv. Patients shall be reviewed by a Specialist Medical Officer (if available) at least once a day.
b.) For high-risk patients
i. The maternal and foetal monitoring shall be at an appropriate level as prescribed;
ii. the patient shall be reviewed by a specialist at least twice a day.
iii. Multidisciplinary care where indicated.
c.) For very high-risk patients, patient should be preferably managed in an HDU/ICU setting.'),
('23c','23c.3','23c.3.8','The Obstetrics and Gynaecology Services shall ensure that antenatal, intrapartum and postnatal mothers have documented records to facilitate continuity of care. A copy of the record/card is given to the patient.'),
('23c','23c.3','23c.3.9','The Obstetrics and Gynaecology Services shall ensure that postnatal mothers being discharged will continue to receive postnatal care.'),
('23c','23c.4','23c.4.1','There are adequate and appropriate facilities and equipment with proper utilisation of space to enable staff to carry out their professional, teaching and administrative functions.'),
('23c','23c.4','23c.4.2','Existing facilities shall consider the safety and comfort of staff and patients.'),
('23c','23c.4','23c.4.3','Suitable forms of communication systems and equipment are provided to enable clinical staff to communicate among themselves and with the other members of the healthcare team.'),
('23c','23c.4','23c.4.4','There is optimal management of beds at the Department with documentation of total number of beds and monitoring of bed occupancy rates.'),
('23c','23c.4','23c.4.5','Facilities are suitably located to facilitate easy access and to provide an atmosphere of user, environmental and ‘disabled’ friendly.'),
('23c','23c.4','23c.4.6','Equipment, both for emergency and non-emergency usage, shall be appropriate to the level of care.'),
('23c','23c.4','23c.4.7','There is evidence that the facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order.'),
('23c','23c.4','23c.4.8','Where specialised equipment is used, there is evidence that only staff who are trained and authorised by the Facility operate such equipment.'),
('23c','23c.4','23c.4.9','The Specialist Outpatient Services shall have the following features;
a.) The organisation and management of the clinics are planned to ensure minimal waiting time, and avoidance of unnecessary visits by the patients.
b.) Record keeping shall be efficient.
c.) An appointment or queuing system is used to manage patient consultations.
d.) The clinic is easily accessible including for non-ambulant patients and is easily identified through adequate signage.
e.) The clinic is located close to other facilities, e.g. radiology, laboratories and pharmacy.
f.) Adequate provision is made for patient comfort.
g.) Call back system (especially for high- risk cases)
h.) Avenue for patients to access service between appointments.
i.) Baby-friendly facilities'),
('23c','23c.4','23c.4.10','At the Outpatient Clinic, adequate numbers of rooms are provided to ensure patient privacy and confidentiality for various patient care activities including:
a.) Consultation (not more than one patient in a room at any time).
b.) Minor procedures and nursing procedures.
c.) Performance of various tests.'),
('23c','23c.5','23c.5.1','There are planned activities for performance and quality improvement.'),
('23c','23c.5','23c.5.2','The Head of Obstetrics and Gynaecology Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.'),
('23c','23c.5','23c.5.3','Specific performance indicators are tracked for e.g.;
a.) Maternal mortality ratio
b.) Antenatal attendance- 1st and 4th presentation
c.) Number of labour ward women tested for HIV
d.) Number of postnatal ward women tested for HIV
e.) Number of women tested positive who are started on Anti-retroviral Therapy (ART)
f.) Number of women accessing family planning methods (pills/injections/IUDs)
g.) Length of stay for common diagnosis.'),
('23d','23d.1','23d.1.1','The Vision, Mission of the Facility are accessible to all visitors. The Goals of the Emergency Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.'),
('23d','23d.1','23d.1.2','There is a mechanism to ensure effective interaction between the Head of the Services and the Organisation’s Governing Body and Senior Management.'),
('23d','23d.1','23d.1.3','Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the Emergency Services. These meetings are minuted and communicated to all staff.'),
('23d','23d.1','23d.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care.
The following (among others) are available:
a. workload/census for inpatients and outpatients
b. quarterly and annual report
c. incident reports and register
d. staffing number and staff profile
e. staff training records
f. data on performance improvement'),
('23d','23d.2','23d.2.1','The are written and dated job descriptions for each category of staff that include;
a.) Qualification, training and experience for the position
b.) Lines of authority
c.) Accountability, functions and responsibilities
d.) Reviewed when required if there is major change in job scope
e.) Statutory regulations
f.) Administrative and clinical job scope'),
('23d','23d.2','23d.2.2','The staff holds current registration with the relevant professional body.'),
('23d','23d.2','23d.2.3','The staff works within their job description and job scope.'),
('23d','23d.2','23d.2.4','There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice.'),
('23d','23d.2','23d.2.5','The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.'),
('23d','23d.2','23d.2.6','In a Facility where undergraduate medical, nursing and allied health training programmes are conducted, the Facility shall ensure there are sufficient skilled trained staff to provide clinical supervision of students.'),
('23d','23d.2','23d.2.7','Staff including medical practitioners receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('23d','23d.2','23d.2.8','Where appropriate the Facility shall endeavour to undertake clinical research using available resources.'),
('23d','23d.2','23d.2.9','Staffing levels are based on the following;
a.) The number of persons deployed is proportional to the number of patients being cared for as per regulatory requirements and for the intensity of care provided
b.) The categories of service providers reflect the complexity of clinical problems being managed
c.) Staffing needs shall take into consideration absences due to leave or illness; double shift duties by clinical staff shall be documented and monitored
d.) Adequate staffing levels of appropriate competency shall be maintained throughout the hours the services are in operation.
e.) Where it is not possible to have service providers on duty on site, e.g. after working hours, provision is made for relevant medical practitioner to be available on call.'),
('23d','23d.2','23d.2.10','There is a structured orientation programme for all newly appointed staff to the Medical Services including medical practitioners and for those new to specific areas that include the following;
a.) Explanation of the goals, objectives, policies and procedures of the Facility and those of the Medical Services
b.) Lines of authority and areas of responsibility
c.) Explanation of duties and functions
d.) Explanation of the methods of assigning clinical care and the standards of clinical practice
e.) Handover communication
f.) Processes for resolving practice/ethical dilemmas in a timely manner
g.) Information about safety procedures
h.) Training in basic/advanced life support techniques
i.) Methods of obtaining appropriate resource materials
j.) Staff appraisal procedures for the Medical Services
k.) Education on Patient and Family Rights'),
('23d','23d.3','23d.3.1','There are written policies and procedures for the Emergency Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.'),
('23d','23d.3','23d.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('23d','23d.3','23d.3.3','The policies and procedures documentation shall address at least the following topics;
a.) Description of the organisational structure of the Medical Services
b.) The use of updated Standard Treatment Guidelines.
c.) Handover communication
d.) Drug prescription, dispensing and administration
e.) Blood transfusion
f.) Continuing of care including regular review of patient and review of investigation results
g.) Admission and Discharge (planned or “At Own Risk”)
h.) Referrals and Repatriations
i.) Guardians for patients
j.) Management of cases with an infectious disease including notification of notifiable diseases
k.) Internal and External Disaster
l.) Incident reports
m.) Management of deaths'),
('23d','23d.3','23d.3.4','The service shall operate on a 24- hour basis providing level of care appropriate the facility.'),
('23d','23d.3','23d.3.5','Close working and formal arrangements shall exist between the Emergency Services and appropriate parties:
a.) Internally with:
• Other clinical services of the Facility
• Support services including cleaning and security
• Non-clinical functions of the Emergency Services, i.e. reception, registration/ payment/billing and clerical services.
b.) Externally with other local healthcare agencies operating within the Facility''s catchment area including feeder clinics or facilities.'),
('23d','23d.4','23d.4.1','The Emergency Services shall have dedicated treatment zones based on urgency of illness. The zone shall be clearly visible with directional signage which is well posted. Access to each area shall be determine its function and maybe restricted from public based on needs. There should be a;
a.) Patient drop zone and triage area
b.) Reception, registration and waiting area
c.) Resuscitation and critical care area
d.) Semi-critical area
e.) Non-critical area
f.) Procedural and specialty care area for example: plaster room, minor operation theatre etc.
g.) Patient isolation and decontamination area
h.) Others (when applicable)
• Ambulance Communication Centre
• Ambulance drop-off zone and access
i.) Storage (consumables, equipment)'),
('23d','23d.4','23d.4.2','There are adequate and appropriate facilities and equipment with proper utilisation of space to enable staff to carry out their professional, teaching and administrative functions.'),
('23d','23d.4','23d.4.3','The following medications are deemed necessary to optimally meet the goals and objectives of the Emergency Services. There should be floor stock of the following (among others);
a.) Antihypertensives
b.) Activated charcoal
c.) Antihistamines
d.) Antiplatelets
e.) Bronchodilators
f.) Corticosteroids
g.) Inotropic drugs
h.) Analgesics
i.) Anti-convulsant'),
('23d','23d.4','23d.4.4','A list of the minimum requirements for equipment and drugs, both for emergency and non-emergency usage, shall be available in the Emergency Department appropriate to the level of care.
The emergency trolley should include the following drugs;
• Antianginal (Sublingual Glyceral Trinitrate (GTN)
• Antiarrythmics (Adenosine, Amiodarone, Lignocaine, Digoxine)
• Antidotes (Flumazenil, Atopine, Glucose 50%, MgSO4, Calcium gluconate or Calcium chloride)
• Sodium bicarbonate
• Adrenaline
• Water for Injection'),
('23d','23d.4','23d.4.5','The Emergency Services are equipped with essential equipment depending on scope of service. The following equipment should be present;
a.) Airway Management devices such as:
i. Adjuncts- oropharyngeal airway, nasopharyngeal airway;
ii. Endotracheal Intubation Equipment:
iii. Rescue airway devices for Difficult and failed airway situation- supraglottic airway, Video Assisted Laryngoscope and devices.
b.) Oxygen Delivery Equipment such as:
i. various size oxygen mask, simple face mask, venturi mask, high flow rebreathing mask
c.) Respiratory and ventilation support such as:
i. Ventilator invasive and non-invasive
d.) Vascular Access Devices and Circulatory Support including:
i. Intravascular access devices including intraosseous set (manual/ mechanical)
ii. Intravenous fluid delivery devices inclusive volumetric pump and rapid infusions
iii. Various intravenous fluids solution for resuscitation and volume replacement.
e.) Defibrillator and Emergency Cardiac Care Equipment including:
i. 12 Lead ECG machine and Transcutaneous pacing depending on the level of care provided.
ii. Defibrillator with Automated External Defibrillator (AED) capabilities.
f.) Patient Body Thermal Control Equipment
g.) Fluid Warmers, Storage for Blood products (depending on level of care; within easy access)
h.) Limb, Neck and Spine Immobilization and Protection Equipment
i.) Patient Vital Parameters Monitor including Blood Pressure, Pulse Rate, Respiratory Rate, Pulse oximetry, Cardiac Monitoring and temperature.
j.) Wounds, Soft tissue and Burns Care Sets
k.) Point of Care or Bedside (Rapid) Diagnostic Tests or Support including:
i. Blood sugar analyser;
ii. Urine analyser.
iii. Full blood count
iv. Arterial blood gas
l.) Imaging Devices or Support
i. Access to X-ray;
ii.  Access to Ultrasound / portable ultrasound / point of care ultrasound
m.) Emergency Care Equipment for paediatric including length- based chart/tape for equipment sizing and emergency drug dosing (Broselow Tape)
n.) Obstetric Delivery Equipment
o.) Emergency Patient Care Beds'),
('23d','23d.4','23d.4.6','Existing facilities shall consider the safety and comfort of staff and patients.'),
('23d','23d.4','23d.4.7','Suitable forms of communication systems and equipment are provided to enable clinical staff to communicate among themselves and with the other members of the healthcare team.'),
('23d','23d.4','23d.4.8','Facilities are suitably located to facilitate easy access and to provide an atmosphere of user, environmental and ‘disabled'' friendly.'),
('23d','23d.4','23d.4.9','There is evidence that the facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order.'),
('23d','23d.4','23d.4.10','Where specialised equipment is used, there is evidence that only staff who are trained and authorised by the Facility operate such equipment.'),
('23d','23d.4','23d.4.11','Adequate numbers of rooms are provided to ensure patient privacy and confidentiality for various patient care activities including:
a.) Consultation (not more than one patient in a room at any time)
b.) Conduct of minor procedures and nursing procedures)
c.) Performance of various tests'),
('23d','23d.5','23d.5.1','There are planned activities for performance and quality improvement.'),
('23d','23d.5','23d.5.2','The Head of Emergency Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.'),
('23d','23d.5','23d.5.3','Specific performance indicators are tracked for e.g.;
a.) Average waiting time between presentation and treatment
b.) Average waiting time for different triage categories
c.) Average waiting time for inpatient beds (access block rate)'),
('23e','23e.1','23e.1.1','The Vision, Mission of the Facility are accessible. The Goals of the Psychiatry Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.'),
('23e','23e.1','23e.1.2','There is a mechanism to ensure effective interaction between the Head of the Services and the Organisation’s Governing Body and Senior Management.'),
('23e','23e.1','23e.1.3','Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the Psychiatry Services. These meetings are minuted and communicated to all staff.'),
('23e','23e.1','23e.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care.
The following, among others, are available;
a.) workload/census for inpatients and outpatients
b.) quarterly and annual report
c.) incident reports and register
d.) staffing number and staff profile
e.) staff training records
f.) data on performance improvement
g.) number of patients requiring seclusion
h.) number of patients requiring restraint'),
('23e','23e.2','23e.2.1','The are written and dated job descriptions for each category of staff that include:
a.) Qualification, training and experience for the position
b.) Lines of authority
c.) Accountability, functions and responsibilities
d.) Reviewed when required if there is major change in job scope
e.) Statutory regulations
f.) Administrative and clinical job scope'),
('23e','23e.2','23e.2.2','The staff holds current registration with the relevant professional body.'),
('23e','23e.2','23e.2.3','The staff works within their job description and job scope.'),
('23e','23e.2','23e.2.4','There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice.'),
('23e','23e.2','23e.2.5','The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.'),
('23e','23e.2','23e.2.6','In a Facility where undergraduate medical, nursing and allied health training programmes are conducted, the Facility shall ensure there are sufficient skilled trained staff to provide clinical supervision of students.'),
('23e','23e.2','23e.2.7','Staff, including medical practitioners, receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('23e','23e.2','23e.2.8','Where appropriate the Facility shall endeavour to undertake clinical research using available resources.'),
('23e','23e.2','23e.2.9','Staffing levels are based on the following;
a.) The number of persons deployed is proportional to the number of patients being cared for as per regulatory requirements and for the intensity of care provided
b.) The categories of service providers reflect the complexity of clinical problems being managed
c.) Staffing needs shall take into consideration absences due to leave or illness; double shift duties by clinical staff shall be documented and monitored
d.) Adequate staffing levels of appropriate competency shall be maintained throughout the hours the services are in operation.
e.) Where it is not possible to have service providers on duty on site, e.g. after working hours, provision is made for relevant medical practitioner to be available on call.'),
('23e','23e.2','23e.2.10','There is a structured orientation programme for all newly appointed staff to the Psychiatry Services including medical practitioners and for those new to specific areas that include the following;
a.) Explanation of the goals, objectives, policies and procedures of the Facility and those of the Psychiatry Services
b.) Lines of authority and areas of responsibility
c.) Explanation of duties and functions
d.) Explanation of the methods of assigning clinical care and the standards of clinical practice
e.) Handover communication
f.) Processes for resolving practice/ethical dilemmas in a timely manner
g.) Information about safety procedures
h.) Training in basic/advanced life support techniques
i.) Methods of obtaining appropriate resource materials
j.) Staff appraisal procedures for the Psychiatry Services
k.) Education on Patient and Family Rights'),
('23e','23e.3','23e.3.1','There are written policies and procedures for the Psychiatry Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.'),
('23e','23e.3','23e.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('23e','23e.3','23e.3.3','The policies and procedures documentation shall address at least the following topics;
a.) Description of the organisational structure of the Medical Services
b.) Clinical practice guidelines
c.) Handover communication
d.) Drug prescription, dispensing and administration
e.) Blood transfusion
f.) Continuing of care including regular review of patient and review of investigation results, discharge (planned or “At Own Risk”)
g.) Referrals and escort as necessary
h.) Management of patients under police custody/prisoner
i.) Management of cases with an infectious disease including notification of notifiable diseases
j.) The responsibilities of the staff including medical practitioners in relation to internal and external disasters are documented, and known to the staff (contingency plan)
k.) Incident reports shall be compiled, investigated, discussed and recorded and action plans implemented
l.) End of life care
m.) Management of death'),
('23e','23e.3','23e.3.4','The service shall operate on a 24-hour basis providing level of care appropriate the facility.'),
('23e','23e.4','23e.4.1','There are adequate and appropriate facilities and equipment with proper utilisation of space to enable staff to carry out their professional, teaching and administrative functions.'),
('23e','23e.4','23e.4.2','Existing facilities shall consider the safety and comfort of staff and patients.'),
('23e','23e.4','23e.4.3','Suitable forms of communication systems and equipment are provided to enable clinical staff to communicate among themselves and with the other members of the healthcare team.'),
('23e','23e.4','23e.4.4','Facilities are suitably located to facilitate easy access and to provide an atmosphere of user, environmental and ‘disabled'' friendly'),
('23e','23e.4','23e.4.5','Equipment, both for emergency and non-emergency usage, shall be appropriate to the level of care.'),
('23e','23e.4','23e.4.6','There is evidence that the facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order.'),
('23e','23e.4','23e.4.7','Where specialised equipment is used, there is evidence that only staff who are trained and authorised by the Facility operate such equipment.'),
('23e','23e.4','23e.4.8','The following medications are available within the Psychiatry Services.
a.) Chlorpromazine
b.) Haloperidol
c.) Olanzapine
d.) Stelazine
e.) Fluphenazine decanoate
f.) Fluoxetine
g.) Amitriptyline
h.) Diazepam
i.) Carbamazepine
j.) Sodium valproate'),
('23e','23e.4','23e.4.9','The Specialist Outpatient Services shall have the following features;
a.) The organisation and management of the clinics are planned to ensure minimal waiting time, and avoidance of unnecessary visits by the patients
b.) Record keeping shall be efficient
c.) An appointment or queuing system is used to manage patient consultations
d.) The clinic is easily accessible including for non-ambulant patients and is easily identified through adequate signage
e.) The clinic is located close to other facilities, e.g. radiology, laboratories and pharmacy
f.) Adequate provision is made for patient comfort
g.) Call back system (especially for high- risk cases)
h.) Avenue for patients to access service between appointments
i.) Adequate patient personal use items e.g. wheelchair etc.'),
('23e','23e.4','23e.4.10','At the Outpatient Clinic, adequate numbers of rooms are provided to ensure patient privacy and confidentiality for various patient care activities including:
a.) Consultation (not more than one patient in a room at any time).
b.) Minor procedures and nursing procedures.
c.) Performance of various tests.'),
('23e','23e.5','23e.5.1','There are planned activities for performance and quality improvement.'),
('23e','23e.5','23e.5.2','The Head of Psychiatry Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.'),
('23e','23e.5','23e.5.3','Specific performance indicators are tracked for e.g.;
a.) Number of readmissions services within 28 days of discharge
b.) Number of patients absconded in the last 12 months'),
('23f','23f.1','23f.1.1','The Vision, Mission of the Facility are accessible. The Goals of the Ophthalmology Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.'),
('23f','23f.1','23f.1.2','There is a mechanism to ensure effective interaction between the Head of the Services and the Organisation’s Governing Body and Senior Management. The Head of Ophthalmology Services shall also be involved for the following aspects of management of the services;
a.) Preparation of budget and ensuring that expenditure remains within the budget allocated
b.) Human resource
c.) Facility and equipment management
d.) Safety and performance improvement activities and risk management'),
('23f','23f.1','23f.1.3','Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the Medical Services. These meetings are minuted and communicated to all staff.'),
('23f','23f.1','23f.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care. The following (among others) are available;
a.) Workload/census for inpatients and outpatients
b.) Quarterly and annual report
c.) Incident reports and register
d.) Staffing number and staff profile
e.) Staff training records
f.) Data on performance improvement
g.) Number of referrals to the Ophthalmology Services'),
('23f','23f.2','23f.2.1','The are written and dated job descriptions for each category of staff that include:
a.) Qualification, training and experience for the position
b.) Lines of authority
c.) Accountability, functions and responsibilities
d.) Reviewed when required if there is major change in job scope
e.) Statutory regulations
f.) Administrative and clinical job scope'),
('23f','23f.2','23f.2.2','The staff holds current registration with the relevant professional body.'),
('23f','23f.2','23f.2.3','The staff works within their job description and job scope.'),
('23f','23f.2','23f.2.4','There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice.'),
('23f','23f.2','23f.2.5','The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.'),
('23f','23f.2','23f.2.6','In a Facility where undergraduate medical, nursing and allied health training programmes are conducted, the Facility shall ensure there are sufficient skilled trained staff to provide clinical supervision of students.'),
('23f','23f.2','23f.2.7','Staff including medical practitioners receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('23f','23f.2','23f.2.8','Where appropriate, the Facility shall endeavour to undertake clinical research using available resources.'),
('23f','23f.2','23f.2.9','Staffing levels are based on the following;
a.) The number of persons deployed is proportional to the number of patients being cared for as per regulatory requirements and for the intensity of care provided
b.) The categories of service providers reflect the complexity of clinical problems being managed
c.) Staffing needs shall take into consideration absences due to leave or illness; double shift duties by clinical staff shall be documented and monitored
d.) Adequate staffing levels of appropriate competency shall be maintained throughout the hours the services are in operation.
e.) Where it is not possible to have service providers on duty on site, e.g. after working hours, provision is made for relevant medical practitioner to be available on call.'),
('23f','23f.2','23f.2.10','There is a structured orientation programme for all newly appointed staff to the Ophthalmology Services including medical practitioners and for those new to specific areas that include the following;
a.) Explanation of the goals, objectives, policies and procedures of the Facility and those of the Ophthalmology Services
b.) Lines of authority and areas of responsibility
c.) Explanation of duties and functions
d.) Explanation of the methods of assigning clinical care and the standards of clinical practice
e.) Handover communication
f.) Processes for resolving practice/ethical dilemmas in a timely manner
g.) Information about safety procedures
h.) Training in basic/advanced life support techniques
i.) Methods of obtaining appropriate resource materials
j.) Staff appraisal procedures for the Ophthalmology Services
k.) Education on Patient and Family Rights'),
('23f','23f.3','23f.3.1','There are written policies and procedures for the Ophthalmology Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.'),
('23f','23f.3','23f.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('23f','23f.3','23f.3.3','The policies and procedures documentation shall address at least the following topics;
a.) Description of the organisational structure of the Ophthalmology Services
b.) The use of updated Standard Treatment Guidelines.
c.) Handover communication
d.) Drug prescription, dispensing and administration
e.) Blood transfusion
f.) Continuing of care including regular review of patient and review of investigation results
g.) Admission and Discharge (planned or “At Own Risk”)
h.) Referrals and Repatriations
i.) Guardians for patients
j.) Management of cases with an infectious disease including notification of notifiable diseases
k.) Internal and External Disaster
l.) Incident reports
m.) Management of deaths.
n.) Health information system and Medical Records.
o.) Outreach and supervisory visits including school visits.
p.) Infection Prevention and Control
q.) Management of acutely deteriorating patients.
r.) Patient feedback and complaint mechanism.
s.) Informed consent
t.) Use of sedation in procedures.
u.) Safe use of lasers and other optic radiation devices.'),
('23f','23f.3','23f.3.4','The service shall operate on a 24- hour basis providing level of care appropriate to the facility.'),
('23f','23f.3','23f.3.5','The service shall ensure that provision of patient care and services achieve effective outcomes and is safe.'),
('23f','23f.3','23f.3.6','There is a standardised patient medical record.
This record should have the following;
a.) An identification page with patient’s weight and immunisation status.
b.) Vital sign monitoring sheet (BP, HR, SpO2, Conscious level)
c.) Patient history
d.) Clinical notes
e.) Consent form
f.) Diagnostic reports
g.) Final diagnosis and code at time of discharge
h.) Drug order/medication sheet
i.) Operating theatre sheet (if appropriate)
j.) Allergy and adverse reaction documentation
k.) Behaviour issues that may pose a risk.
l.) Discharge summary
m.) Referral form (if applicable)'),
('23f','23f.4','23f.4.1','There are adequate and appropriate facilities and equipment with proper utilisation of space to enable staff to carry out their professional, teaching and administrative functions.'),
('23f','23f.4','23f.4.2','Existing facilities shall consider the safety and comfort of staff and patients.'),
('23f','23f.4','23f.4.3','Suitable forms of communication systems and equipment are provided to enable clinical staff to communicate among themselves and with the other members of the healthcare team.'),
('23f','23f.4','23f.4.4','There is optimal management of beds at the Department with documentation of total number of beds and monitoring of bed occupancy rates.'),
('23f','23f.4','23f.4.5','Facilities are suitably located to facilitate easy access and to provide an atmosphere of user, environmental and ‘disabled’ friendly.'),
('23f','23f.4','23f.4.6','Equipment, both for emergency and non-emergency usage, shall be appropriate to the level of care.'),
('23f','23f.4','23f.4.7','There is evidence that the facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order.'),
('23f','23f.4','23f.4.8','Where specialised equipment is used, there is evidence that only staff who are trained and authorised by the Facility operate such equipment.'),
('23f','23f.4','23f.4.9','The Specialist Outpatient Services shall have the following features;
a.) The organisation and management of the clinics are planned to ensure minimal waiting time, and avoidance of unnecessary visits by the patients.
b.) Record keeping shall be efficient.
c.) An appointment or queuing system is used to manage patient consultations.
d.) The clinic is easily accessible including for non-ambulant patients and is easily identified through adequate signage.
e.) The clinic is located close to other facilities, e.g. radiology, laboratories and pharmacy.
f.) Adequate provision is made for patient comfort.
g.) Call back system (especially for high- risk cases)
h.) Avenue for patients to access service between appointments.
i.) Monitoring of data (e.g. Number of cases of cataract, refractive errors, corneal diseases, trauma, diabetic retinopathy)'),
('23f','23f.4','23f.4.10','At the Outpatient Clinic, adequate numbers of rooms are provided to ensure patient privacy and confidentiality for various patient care activities including:
a.) Consultation (not more than one patient in a room at any time).
b.) Minor procedures and nursing procedures.
c.) Performance of various tests.'),
('23f','23f.5','23f.5.1','There are planned activities for performance and quality improvement.'),
('23f','23f.5','23f.5.2','The Head of Ophthalmology Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.'),
('23f','23f.5','23f.5.3','Specific performance indicators (among others) are tracked e.g.;
a.) Number of cataract surgeries performed last year.
b.) Number of stock- outs of drugs experienced.');
CREATE TEMP TABLE import_e (standard_number text NOT NULL, criterion_number text NOT NULL, compliance_number text NOT NULL, number text NOT NULL, summary text NOT NULL) ON COMMIT DROP;
INSERT INTO import_e VALUES
('23b','23b.1','23b.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('23b','23b.1','23b.1.1','2','There is an endorsed and dated department Organisational chart with lines of functions and reporting relationships.'),
('23b','23b.1','23b.1.1','3','Relevant policies are available in the department. (National Health Plan, National Health Service Standards, Child and Adolescent Health Policy and Plan 2021-2030 etc.).'),
('23b','23b.1','23b.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('23b','23b.1','23b.1.1','5','Evidence of fee structure (if fees are collected).'),
('23b','23b.1','23b.1.2','1','Letter of appointment and terms of reference as the Head of Service.'),
('23b','23b.1','23b.1.2','2','Letter of appointment and terms of reference as a member of the Clinical Governance Advisory Committee.'),
('23b','23b.1','23b.1.2','3','Letter of appointment and terms of reference in other hospital committees.'),
('23b','23b.1','23b.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff.'),
('23b','23b.1','23b.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service.'),
('23b','23b.1','23b.1.3','3','Frequency of meetings are as scheduled.'),
('23b','23b.1','23b.1.3','4','Discussions and resolutions are implemented (problems not solved are brought forward to the next meeting till resolved).'),
('23b','23b.1','23b.1.4','1','The statistics and records from (a) to (f) are available.'),
('23b','23b.2','23b.2.1','1','There are dated and specific job descriptions for each staff that include (a) to (f).'),
('23b','23b.2','23b.2.1','2','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('23b','23b.2','23b.2.1','3','The scope of work in the job description aligns with the training, skill and experience of the staff (credentialling)'),
('23b','23b.2','23b.2.2','1','Evidence of current registration for all cadres of staff (annual practicing certificate).'),
('23b','23b.2','23b.2.3','1','Observation that cadres of staff are working according to their job description and job scope.'),
('23b','23b.2','23b.2.4','1','Training calendar includes in-house/ external courses/ workshops/ conferences.'),
('23b','23b.2','23b.2.4','2','Training for each staff including training in life support is kept in the Department.'),
('23b','23b.2','23b.2.4','3','There are ongoing Continuous Professional Activities in the Department.'),
('23b','23b.2','23b.2.5','1','Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.'),
('23b','23b.2','23b.2.6','1','Evidence of sufficient skilled trained staff to provide clinical supervision as per terms of Memorandum of Understanding.'),
('23b','23b.2','23b.2.7','1','Performance appraisal for staff including medical practitioners is completed upon probationary period and as an annual exercise.'),
('23b','23b.2','23b.2.8','1','Documented evidence of research activities in the Department.'),
('23b','23b.2','23b.2.9','1','Planning of staff allocation and movement within the Department includes the following;
a.) Deployment based on staff to patient ratio, bed occupancy rate and complexity of cases.
b.) Special skills/training of staff.
c.) Contingency plan for acute shortage.
d.) Duty roster.
e.) Evidence that all clinicians re not made to work more than the stipulated hours.'),
('23b','23b.2','23b.2.10','1','Evidence of policy stating that all staff have to attend a structured orientation programme.'),
('23b','23b.2','23b.2.10','2','Attendance list of those having attended the orientation programme.'),
('23b','23b.3','23b.3.1','1','Evidence of documented policies and procedures for the service.'),
('23b','23b.3','23b.3.1','2','The policies and procedures are endorsed and dated.'),
('23b','23b.3','23b.3.1','3','There is a periodic review at least once in three years.'),
('23b','23b.3','23b.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference.'),
('23b','23b.3','23b.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('23b','23b.3','23b.3.3','1','Documented policies and procedures that address (a) to (s).'),
('23b','23b.3','23b.3.3','2','Staff are briefed on the policies and procedures (meeting minutes or circulation acknowledgement).'),
('23b','23b.3','23b.3.4','1','Operational policy on 24-hour service.'),
('23b','23b.3','23b.3.4','2','Staffing level reflects a good mix of senior and junior staff.'),
('23b','23b.3','23b.3.4','3','On call roster is dated and authorised.'),
('23b','23b.3','23b.3.5','1','Relevant Standard Treatment Guidelines are available in the division (Paediatric Treatment Guidelines, Medical and Dental Catalogue).'),
('23b','23b.3','23b.3.5','2','Patient register is updated daily.'),
('23b','23b.3','23b.3.5','3','Evidence of appropriate admission process.'),
('23b','23b.3','23b.3.5','4','Evidence of in-patient and guardian orientation process during admission.'),
('23b','23b.3','23b.3.5','5','Evidence of initial assessment and provisional diagnosis.'),
('23b','23b.3','23b.3.5','6','Evidence and documentation of morning and evening rounds.'),
('23b','23b.3','23b.3.5','7','Evidence of regular vital sign documentation.'),
('23b','23b.3','23b.3.5','8','Documentation of discussions with patient/family/guardian about the patient’s condition.'),
('23b','23b.3','23b.3.5','9','Evidence of discussions with other disciplines and referrals if necessary.'),
('23b','23b.3','23b.3.5','10','Evidence of patient handover during shift change (documentation and observed).'),
('23b','23b.3','23b.3.5','11','Evidence of documented informed consent for procedures.'),
('23b','23b.3','23b.3.5','12','Evidence of flowchart on patient deterioration or “Code Blue” procedures.'),
('23b','23b.3','23b.3.5','13','Discharge summaries are issued to patients on discharge with a care plan.'),
('23b','23b.3','23b.3.5','14','Evidence of a patient referral register.'),
('23b','23b.3','23b.3.6','1','Patient’s medical record has elements (a) to (k).'),
('23b','23b.3','23b.3.6','2','The Patient’s medical record has a unique identifier (MRN).'),
('23b','23b.3','23b.3.6','3','Evidence of clinical documentation which is signed, dated and with legible writing.'),
('23b','23b.3','23b.3.6','4','Evidence of use of appropriate abbreviations.'),
('23b','23b.3','23b.3.6','5','Colour coded paediatric monitoring and reporting charts are used.'),
('23b','23b.4','23b.4.1','1','The building is sound and there is adequate space to match the services.'),
('23b','23b.4','23b.4.1','2','Appropriate type of equipment to match the complexity of services.'),
('23b','23b.4','23b.4.1','3','Adequate facilities and equipment at each patient care area for safe care. (e.g. defibrillators, emergency trolley, hand washing facilities etc.).'),
('23b','23b.4','23b.4.1','4','Easy access and clear (unblocked) exit routes.'),
('23b','23b.4','23b.4.1','5','Absence of overcrowding.'),
('23b','23b.4','23b.4.1','6','Availability of an isolation area.'),
('23b','23b.4','23b.4.1','7','There are lights/lamps/solar for blackouts.'),
('23b','23b.4','23b.4.1','8','There is good ventilation within the ward/s.'),
('23b','23b.4','23b.4.1','9','There is running water in the facility.'),
('23b','23b.4','23b.4.1','10','Waste is segregated at the facility at the point of generation.'),
('23b','23b.4','23b.4.2','1','Design and layout of the unit, e.g. wards, treatment rooms, dirty and clean utility rooms, access, lighting, signage, etc. address the safety aspects of patients and staff.'),
('23b','23b.4','23b.4.2','2','Equipment should have scheduled planned preventive maintenance (PPM).'),
('23b','23b.4','23b.4.2','3','There is access to hand washing facilities.'),
('23b','23b.4','23b.4.2','4','Mattresses are covered with waterproof coverings and there is clean linen on every bed.'),
('23b','23b.4','23b.4.2','5','Sharps are disposed properly.'),
('23b','23b.4','23b.4.2','6','There is a separate area for adolescents.'),
('23b','23b.4','23b.4.2','7','There are rooming in facilities for mothers with sick newborns.'),
('23b','23b.4','23b.4.3','1','Appropriate telecommunication modalities available for daily operation and during emergencies.'),
('23b','23b.4','23b.4.4','1','There is up-to-date documentation of the total number of beds (overnight and day-only beds).'),
('23b','23b.4','23b.4.4','2','Evidence that any patient who occupies a bed for more than 4 hours and receives significant clinical care is classified as an “in-patient”.'),
('23b','23b.4','23b.4.4','3','Factors such as “bed occupancy rates” and “average length of stay” are monitored and analysed.'),
('23b','23b.4','23b.4.5','1','Floor plan indicates facility accessibility and is patient and user friendly.'),
('23b','23b.4','23b.4.5','2','Feedback from patient satisfaction surveys on the facilities.'),
('23b','23b.4','23b.4.5','3','Incident reporting relating to facilities if any.'),
('23b','23b.4','23b.4.5','4','Toilets have wheelchair access.'),
('23b','23b.4','23b.4.6','1','Availability of emergency and non-emergency equipment appropriate to level of care, such as defibrillator, emergency trolley, suction machine, electrocardiogram (ECG) machine, infusion or syringe pump, vital sign monitor, pulse oximeter, oxygen concentrator etc.'),
('23b','23b.4','23b.4.6','2','Scheduled checking of items in emergency trolley.'),
('23b','23b.4','23b.4.6','3','There are adequate patient transfer trolleys, wheelchairs, mobility aids and a dedicated drug fridge.'),
('23b','23b.4','23b.4.6','4','There is a dedicated cabinet for dangerous drugs which can be locked.'),
('23b','23b.4','23b.4.7','1','Planned Preventive Maintenance records such as schedule, stickers, etc.'),
('23b','23b.4','23b.4.7','2','Planned Replacement Programme where applicable.'),
('23b','23b.4','23b.4.7','3','Complaint records.'),
('23b','23b.4','23b.4.7','4','Asset inventory.'),
('23b','23b.4','23b.4.8','1','User training records.'),
('23b','23b.4','23b.4.8','2','List of staff trained and authorised to operate specialised equipment.'),
('23b','23b.4','23b.4.9','1','Evidence of list of services available and offered to patients.'),
('23b','23b.4','23b.4.9','2','Flow chart on work process.'),
('23b','23b.4','23b.4.9','3','Safe keeping of medical records.'),
('23b','23b.4','23b.4.9','4','Clinic appointment system.'),
('23b','23b.4','23b.4.9','5','Security of data in Health Information System.'),
('23b','23b.4','23b.4.9','6','Monitoring of waiting time.'),
('23b','23b.4','23b.4.9','7','Adequate and appropriate signage.'),
('23b','23b.4','23b.4.9','8','Floor plan indicates accessibility to supporting services and optimisation of space.'),
('23b','23b.4','23b.4.9','9','Adequate patient personal use items, e.g. wheelchair, mobility aids etc.'),
('23b','23b.4','23b.4.9','10','Adequate waiting area, toilets and reading material.'),
('23b','23b.4','23b.4.9','11','Standard clinic books are used for children under 5 years'),
('23b','23b.4','23b.4.9','12','Immunisation status is documented in the front of the clinic book.'),
('23b','23b.4','23b.4.9','13','Patient’s weight for age chart is plotted by the attending clinician.'),
('23b','23b.4','23b.4.10','1','Evidence of facilities with patient privacy ensured.'),
('23b','23b.4','23b.4.10','2','Procedure room appropriately equipped.'),
('23b','23b.4','23b.4.10','3','Patient monitoring device is available where required (vital signs).'),
('23b','23b.4','23b.4.10','4','List of procedures performed.'),
('23b','23b.5','23b.5.1','1','There is a designated person who monitors safety and performance improvement activities within the Medical Services.'),
('23b','23b.5','23b.5.1','2','There are records/registers on performance improvement activities.'),
('23b','23b.5','23b.5.1','3','There are meeting minutes for performance improvement meetings.'),
('23b','23b.5','23b.5.1','4','There are records on innovation (if any)'),
('23b','23b.5','23b.5.2','1','System for incident reporting is in place with the following;
a.) Training of staff in incident reporting
b.) Policy on incident reporting
c.) Method/SOP on Incident reporting
d.) Register of incidents'),
('23b','23b.5','23b.5.2','2','Completed incident reports.'),
('23b','23b.5','23b.5.2','3','Corrective and preventive action plans.'),
('23b','23b.5','23b.5.2','4','Minutes of meeting.'),
('23b','23b.5','23b.5.2','5','Involved staff given feedback about the incident report.'),
('23b','23b.5','23b.5.2','6','Acknowledgment by Head of Medical Service and Director of Curative Services.'),
('23b','23b.5','23b.5.3','1','Specific performance indicators are monitored.'),
('23b','23b.5','23b.5.3','2','Remedial action is taken when appropriate.'),
('23c','23c.1','23c.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('23c','23c.1','23c.1.1','2','There is an endorsed and dated department organisational chart with lines of functions and reporting relationships.'),
('23c','23c.1','23c.1.1','3','Relevant policies and guidelines are available in the department, i.e., National Health Plan, National Health Service Standards, etc.)'),
('23c','23c.1','23c.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('23c','23c.1','23c.1.1','5','Evidence of fee structure (if fees are collected).'),
('23c','23c.1','23c.1.2','1','Letter of appointment and terms of reference as the Head of Service.'),
('23c','23c.1','23c.1.2','2','Letter of appointment and terms of reference as a member of the Clinical Governance Advisory Committee and/or Maternal and Child Health subcommittee.'),
('23c','23c.1','23c.1.2','3','Letter of appointment and terms of reference in other hospital committees.'),
('23c','23c.1','23c.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff.'),
('23c','23c.1','23c.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service.'),
('23c','23c.1','23c.1.3','3','Frequency of meetings are as scheduled.'),
('23c','23c.1','23c.1.3','4','Discussions and resolutions are implemented. (problems not solved are brought forward to the next meeting till resolved).'),
('23c','23c.1','23c.1.4','1','The statistics and records from (a) to (f) are available.'),
('23c','23c.2','23c.2.1','1','There are dated and specific job descriptions for each staff that include (a) to (f).'),
('23c','23c.2','23c.2.1','2','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('23c','23c.2','23c.2.1','3','The scope of work in the job description aligns with the training, skill and experience of the staff (credentialling).'),
('23c','23c.2','23c.2.2','1','Evidence of current registration for all cadres of staff (annual practicing certificate).'),
('23c','23c.2','23c.2.3','1','Observation that cadres of staff are working according to their job description and job scope.'),
('23c','23c.2','23c.2.4','1','Training calendar includes in-house/ external courses/ workshops/ conferences.'),
('23c','23c.2','23c.2.4','2','Training for each staff including training in life support is kept in the Department.'),
('23c','23c.2','23c.2.4','3','There are ongoing Continuous Professional Activities in the Department.'),
('23c','23c.2','23c.2.5','1','Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.'),
('23c','23c.2','23c.2.6','1','Evidence of sufficient skilled trained staff to provide clinical supervision as per terms of Memorandum of Understanding.'),
('23c','23c.2','23c.2.7','1','Performance appraisal for staff including medical practitioners is completed upon probationary period and as an annual exercise.'),
('23c','23c.2','23c.2.8','1','Documented evidence of research activities in the Department.'),
('23c','23c.2','23c.2.9','1','Planning of staff allocation and movement within the Department includes the following;
a.) Deployment based on staff to patient ratio, bed occupancy rate and complexity of cases.
b.) Special skills/training of staff.
c.) Contingency plan for acute shortage.
d.) Duty roster.
e.) Evidence that all clinicians re not made to work more than the stipulated hours.'),
('23c','23c.2','23c.2.10','1','Evidence of policy stating that all staff have to attend a structured orientation programme.'),
('23c','23c.2','23c.2.10','2','Attendance list of those having attended the orientation programme.'),
('23c','23c.3','23c.3.1','1','Evidence of documented policies and procedures for the service.'),
('23c','23c.3','23c.3.1','2','The policies and procedures are endorsed and dated.'),
('23c','23c.3','23c.3.1','3','There is a periodic review at least once in three years.'),
('23c','23c.3','23c.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference.'),
('23c','23c.3','23c.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('23c','23c.3','23c.3.3','1','Documented policies and procedures that address (a) to (s).'),
('23c','23c.3','23c.3.3','2','Staff are briefed on the policies and procedures (meeting minutes or circulation acknowledgement).'),
('23c','23c.3','23c.3.4','1','Operational policy on 24-hour service.'),
('23c','23c.3','23c.3.4','2','Staffing level reflects a good mix of senior and junior staff.'),
('23c','23c.3','23c.3.4','3','On call roster is dated and authorised.'),
('23c','23c.3','23c.3.5','1','Relevant Standard Treatment Guidelines are available in the division (PNG O and G STG, Medical and Dental Catalogue).'),
('23c','23c.3','23c.3.5','2','Patient register is updated daily.'),
('23c','23c.3','23c.3.5','3','Evidence of appropriate admission process.'),
('23c','23c.3','23c.3.5','4','Evidence of in-patient and guardian orientation process during admission.'),
('23c','23c.3','23c.3.5','5','Evidence of initial assessment and provisional diagnosis.'),
('23c','23c.3','23c.3.5','6','Evidence and documentation of morning and evening rounds.'),
('23c','23c.3','23c.3.5','7','Evidence of regular vital sign documentation'),
('23c','23c.3','23c.3.5','8','Documentation of discussions with patient/family/guardian about the patient’s condition.'),
('23c','23c.3','23c.3.5','9','Evidence of discussions with other disciplines and referrals if necessary.'),
('23c','23c.3','23c.3.5','10','Evidence of patient handover during shift change (documentation and observed).'),
('23c','23c.3','23c.3.5','11','Evidence of documented informed consent for procedures.'),
('23c','23c.3','23c.3.5','12','Evidence of flowchart on patient deterioration or “Code Blue” procedures.'),
('23c','23c.3','23c.3.5','13','Discharge summaries are issued to patients on discharge with a care plan.'),
('23c','23c.3','23c.3.6','1','Patient’s medical record has elements (a) to (n).'),
('23c','23c.3','23c.3.6','2','The Patient’s medical record has a unique identifier (MRN).'),
('23c','23c.3','23c.3.6','3','Evidence of clinical documentation which is signed, dated and with legible writing.'),
('23c','23c.3','23c.3.6','4','Evidence of use of appropriate abbreviations.'),
('23c','23c.3','23c.3.6','5','Post delivery, there are separate maternal and baby medical records.'),
('23c','23c.3','23c.3.7','1','There are policies addressing (a) to (c).'),
('23c','23c.3','23c.3.7','2','There is documented evidence for patient’s medical record and foetal monitoring notes and observed compliance for (a) to (c)'),
('23c','23c.3','23c.3.8','1','Policy on issuance of antenatal and postnatal record.'),
('23c','23c.3','23c.3.8','2','Antenatal and postnatal patient records.'),
('23c','23c.3','23c.3.8','3','Observation for compliance with policy.'),
('23c','23c.3','23c.3.9','1','Policy on postnatal care that indicates that mothers are appropriately referred to health centre/health service for postnatal care.'),
('23c','23c.4','23c.4.1','1','Observation that the building is sound and there is adequate space to match the services.'),
('23c','23c.4','23c.4.1','2','There is appropriate equipment to match the complexity of services.'),
('23c','23c.4','23c.4.1','3','There are adequate facilities and equipment at each patient care area for safe care (e.g. defibrillators, emergency trolley, hand washing facilities etc.).'),
('23c','23c.4','23c.4.1','4','Access to the Oncology ward and clear (unblocked) exit routes.'),
('23c','23c.4','23c.4.1','5','Absence of overcrowding.'),
('23c','23c.4','23c.4.1','6','Availability of an isolation area.'),
('23c','23c.4','23c.4.1','7','There are lights/lamps/solar for blackouts.'),
('23c','23c.4','23c.4.1','8','There is good ventilation within the ward/s.'),
('23c','23c.4','23c.4.1','9','There is running water in the facility.'),
('23c','23c.4','23c.4.1','10','Waste is segregated at the facility at the point of generation.'),
('23c','23c.4','23c.4.2','1','Design and layout of the unit is appropriate e.g. wards, treatment rooms, dirty and clean utility rooms, access, lighting, signage, etc., address the safety aspects of patients and staff.'),
('23c','23c.4','23c.4.2','2','Equipment should have scheduled planned preventive maintenance (PPM).'),
('23c','23c.4','23c.4.2','3','There is access to hand washing facilities.'),
('23c','23c.4','23c.4.2','4','Mattresses are covered with waterproof coverings and there is clean linen on every bed.'),
('23c','23c.4','23c.4.2','5','Sharps are disposed properly.'),
('23c','23c.4','23c.4.3','1','Appropriate telecommunication modalities are available for daily operation and during emergencies.'),
('23c','23c.4','23c.4.4','1','There is up-to-date documentation of the total number of beds (overnight and day-only beds)'),
('23c','23c.4','23c.4.4','2','There is evidence that any patient who occupies a bed for more than 4 hours and receives significant clinical care is classified as an “in-patient”.'),
('23c','23c.4','23c.4.4','3','Factors such as “bed occupancy rates” and “average length of stay” are monitored and analysed.'),
('23c','23c.4','23c.4.5','1','Floor plan indicates facility accessibility and is patient and user friendly.'),
('23c','23c.4','23c.4.5','2','Feedback from patient satisfaction surveys on the facilities.'),
('23c','23c.4','23c.4.5','3','Incident reporting relating to facilities if any.'),
('23c','23c.4','23c.4.5','4','Toilets have wheelchair access.'),
('23c','23c.4','23c.4.6','1','Availability of emergency and non-emergency equipment appropriate to level of care, such as defibrillator, emergency trolley, suction machine, electrocardiogram (ECG) machine, infusion or syringe pump, vital sign monitor, pulse oximeter, oxygen concentrator etc.'),
('23c','23c.4','23c.4.6','2','Scheduled checking of items in emergency trolley (preferably once every shift).'),
('23c','23c.4','23c.4.6','3','There are adequate patient transfer trolleys, wheelchairs, mobility aids and a dedicated drug fridge.'),
('23c','23c.4','23c.4.6','4','There is a dedicated cabinet for dangerous drugs which can be locked.'),
('23c','23c.4','23c.4.7','1','Planned Preventive Maintenance records such as schedule, stickers, etc.'),
('23c','23c.4','23c.4.7','2','Planned Replacement Programme where applicable.'),
('23c','23c.4','23c.4.7','3','Complaint records.'),
('23c','23c.4','23c.4.7','4','Asset inventory.'),
('23c','23c.4','23c.4.8','1','User training records.'),
('23c','23c.4','23c.4.8','2','List of staff trained and authorised to operate specialised equipment.'),
('23c','23c.4','23c.4.9','1','Evidence of list of services available and offered to patients.'),
('23c','23c.4','23c.4.9','2','Flow chart on work process'),
('23c','23c.4','23c.4.9','3','Safe keeping of Oncology records'),
('23c','23c.4','23c.4.9','4','Clinic appointment system'),
('23c','23c.4','23c.4.9','5','Security of data in Health Information System'),
('23c','23c.4','23c.4.9','6','Monitoring of waiting time'),
('23c','23c.4','23c.4.9','7','Adequate and appropriate signage'),
('23c','23c.4','23c.4.9','8','Floor plan indicates accessibility to supporting services and optimisation of space'),
('23c','23c.4','23c.4.9','9','Adequate patient personal use items, e.g. wheelchair, mobility aids etc.'),
('23c','23c.4','23c.4.9','10','Adequate waiting area, toilets, reading material and parking space.'),
('23c','23c.4','23c.4.10','1','Evidence of facilities with patient privacy ensured.'),
('23c','23c.4','23c.4.10','2','Procedure room appropriately equipped.'),
('23c','23c.4','23c.4.10','3','Patient monitoring device is available where required (vital signs).'),
('23c','23c.4','23c.4.10','4','List of procedures performed.'),
('23c','23c.5','23c.5.1','1','There is a designated person who monitors safety and performance improvement activities within the Obstetrics & Gynaecology Services.'),
('23c','23c.5','23c.5.1','2','There are records/registers on performance improvement activities.'),
('23c','23c.5','23c.5.1','3','There are meeting minutes for performance improvement meetings.'),
('23c','23c.5','23c.5.1','4','There are records on innovation (if any).'),
('23c','23c.5','23c.5.2','1','System for incident reporting is in place with the following;
a.) Training of staff in incident reporting
b.) Policy on incident reporting
c.) Method/SOP on Incident reporting
d.) Register of incidents'),
('23c','23c.5','23c.5.2','2','Completed incident reports'),
('23c','23c.5','23c.5.2','3','Corrective and preventive action plans'),
('23c','23c.5','23c.5.2','4','Minutes of meeting'),
('23c','23c.5','23c.5.2','5','Involved staff given feedback about the incident report'),
('23c','23c.5','23c.5.2','6','Acknowledgment by Head of Oncology Service and Director of Curative Services.'),
('23c','23c.5','23c.5.3','1','Specific performance indicators are monitored.'),
('23c','23c.5','23c.5.3','2','Remedial action is taken when appropriate'),
('23d','23d.1','23d.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('23d','23d.1','23d.1.1','2','There is an endorsed and dated department organisational chart with lines of functions and reporting relationships.'),
('23d','23d.1','23d.1.1','3','Relevant policies and guidelines are available in the department, i.e., National Health Plan, National Health Service Standards, etc.)'),
('23d','23d.1','23d.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('23d','23d.1','23d.1.1','5','Evidence of fee structure (if fees are collected).'),
('23d','23d.1','23d.1.1','6','Clinical processes are endorsed by the Head of Emergency Services.'),
('23d','23d.1','23d.1.2','1','Letter of appointment and terms of reference as the Head of Service.'),
('23d','23d.1','23d.1.2','2','Letter of appointment and terms of reference as a member of the facility’s Clinical Governance committee or subcommittees.'),
('23d','23d.1','23d.1.2','3','Letter of appointment and terms of reference in other hospital committees.'),
('23d','23d.1','23d.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff.'),
('23d','23d.1','23d.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service.'),
('23d','23d.1','23d.1.3','3','Frequency of meetings are as scheduled.'),
('23d','23d.1','23d.1.3','4','Discussions and resolutions are implemented. (problems not solved are brought forward to the next meeting till resolved).'),
('23d','23d.1','23d.1.4','1','The statistics and records from (a) to (f) are available.'),
('23d','23d.2','23d.2.1','1','There are dated and specific job descriptions for each staff that include (a) to (f).'),
('23d','23d.2','23d.2.1','2','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('23d','23d.2','23d.2.1','3','The scope of work in the job description aligns with the training, skill and experience of the staff (credentialling).'),
('23d','23d.2','23d.2.2','1','Evidence of current registration for all cadres of staff (annual practicing certificate).'),
('23d','23d.2','23d.2.3','1','Observation that cadres of staff are working according to their job description and job scope.'),
('23d','23d.2','23d.2.4','1','Training calendar includes in-house/ external courses/ workshops/ conferences.'),
('23d','23d.2','23d.2.4','2','Training for each staff including training in life support is kept in the Department.'),
('23d','23d.2','23d.2.4','3','There are ongoing Continuous Professional Activities in the Department.'),
('23d','23d.2','23d.2.5','1','Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.'),
('23d','23d.2','23d.2.6','1','Evidence of sufficient skilled trained staff to provide clinical supervision as per terms of Memorandum of Understanding.'),
('23d','23d.2','23d.2.7','1','Performance appraisal for staff including medical practitioners is completed upon probationary period and as an annual exercise.'),
('23d','23d.2','23d.2.8','1','Documented evidence of research activities in the Department.'),
('23d','23d.2','23d.2.9','1','Planning of staff allocation and movement within the Department includes the following;
a.) Deployment based on staff to patient ratio, bed occupancy rate and complexity of cases.
b.) Special skills/training of staff.
c.) Contingency plan for acute shortage.
d.) Duty roster.
e.) Evidence that all clinicians re not made to work more than the stipulated hours.'),
('23d','23d.2','23d.2.10','1','Evidence of policy stating that all staff have to attend a structured orientation programme.'),
('23d','23d.2','23d.2.10','2','Attendance list of those having attended the orientation programme.'),
('23d','23d.3','23d.3.1','1','Evidence of documented policies and procedures for the service.'),
('23d','23d.3','23d.3.1','2','The policies and procedures are endorsed and dated.'),
('23d','23d.3','23d.3.1','3','There is a periodic review at least once in three years.'),
('23d','23d.3','23d.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference.'),
('23d','23d.3','23d.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('23d','23d.3','23d.3.3','1','Documented policies and procedures that address (a) to (s).'),
('23d','23d.3','23d.3.3','2','Staff are briefed on the policies and procedures (meeting minutes or circulation acknowledgement).'),
('23d','23d.3','23d.3.3','3','There is evidence of compliance to the policies and procedures (staff interview, observation, review of patient complaints, results of audits).'),
('23d','23d.3','23d.3.4','1','Operational policy on 24-hour service.'),
('23d','23d.3','23d.3.4','2','Staffing level reflects a good mix of senior and junior staff.'),
('23d','23d.3','23d.3.4','3','On call roster is dated and authorised.'),
('23d','23d.3','23d.3.5','1','Evidence of cross-departmental policy, SOP and key processes addressing (a) and (b).'),
('23d','23d.3','23d.3.5','2','Minutes of meetings and discussions.'),
('23d','23d.3','23d.3.5','3','Relevant documents on coordination, policy MOUs or agreements'),
('23d','23d.4','23d.4.1','1','The design and layout of the emergency department address (a) to (i)'),
('23d','23d.4','23d.4.2','1','There is a department action plan when the clinical areas exceed its patient capacity limit (e.g. due to access block).'),
('23d','23d.4','23d.4.2','2','Easy access and clear exit routes.'),
('23d','23d.4','23d.4.2','3','Absence of overcrowding.'),
('23d','23d.4','23d.4.2','4','Availability of an isolation area.'),
('23d','23d.4','23d.4.2','5','Design and layout of the unit, e.g. wards, treatment rooms, dirty and clean utility rooms, access, lighting, signage, etc. address the safety aspects of patients and staff.'),
('23d','23d.4','23d.4.2','6','Equipment should have scheduled planned preventive maintenance (PPM).'),
('23d','23d.4','23d.4.3','1','Onsite observation on the availability of items (a) to (i)'),
('23d','23d.4','23d.4.4','1','Onsite observation on availability of the drugs listed above in the emergency trolley.'),
('23d','23d.4','23d.4.4','2','Scheduled checking of items in emergency trolley.'),
('23d','23d.4','23d.4.5','1','Onsite observation of (a) to (o).'),
('23d','23d.4','23d.4.5','2','Training records for staff in the use of equipment (a) to (o).'),
('23d','23d.4','23d.4.6','1','There are adequate patient transfer trolleys, wheelchairs, mobility aids and a dedicated drug fridge.'),
('23d','23d.4','23d.4.6','2','There is a dedicated cabinet for dangerous drugs which can be locked.'),
('23d','23d.4','23d.4.6','3','There is access to hand washing facilities'),
('23d','23d.4','23d.4.6','4','There is an adequate waiting area for patients.'),
('23d','23d.4','23d.4.6','5','The Emergency Department is well ventilated.'),
('23d','23d.4','23d.4.7','1','Appropriate telecommunication modalities available for daily operation and during emergencies.'),
('23d','23d.4','23d.4.8','1','Floor plan indicates accessibility and patient and user friendly.'),
('23d','23d.4','23d.4.8','2','Feedback from patient satisfaction survey'),
('23d','23d.4','23d.4.8','3','Incident reporting relating to facilities if any.'),
('23d','23d.4','23d.4.9','1','Planned Preventive Maintenance records such as schedule, stickers, etc.'),
('23d','23d.4','23d.4.9','2','Planned Replacement Programme where applicable.'),
('23d','23d.4','23d.4.9','3','Complaint records.'),
('23d','23d.4','23d.4.9','4','Asset inventory'),
('23d','23d.4','23d.4.10','1','User training records'),
('23d','23d.4','23d.4.10','2','List of staff trained and authorised to operate specialised equipment.'),
('23d','23d.4','23d.4.11','1','Evidence of facilities with patient privacy ensured.'),
('23d','23d.4','23d.4.11','2','Procedure room appropriately equipped.'),
('23d','23d.4','23d.4.11','3','Patient monitoring device is available where required'),
('23d','23d.4','23d.4.11','4','List of procedures performed is recorded.'),
('23d','23d.5','23d.5.1','1','There is a designated person who monitors safety and performance improvement activities within the Medical Services.'),
('23d','23d.5','23d.5.1','2','There are records/registers on performance improvement activities.'),
('23d','23d.5','23d.5.1','3','There are meeting minutes for performance improvement meetings.'),
('23d','23d.5','23d.5.1','4','There are records on innovation (if any).'),
('23d','23d.5','23d.5.2','1','System for incident reporting is in place with the following;
a.) Training of staff in incident reporting
b.) Policy on incident reporting
c.) Method/SOP on Incident reporting
d.) Register of incidents'),
('23d','23d.5','23d.5.2','2','Completed incident reports'),
('23d','23d.5','23d.5.2','3','Corrective and preventive action plans'),
('23d','23d.5','23d.5.2','4','Minutes of meeting'),
('23d','23d.5','23d.5.2','5','Involved staff given feedback about the incident report'),
('23d','23d.5','23d.5.2','6','Acknowledgment by Head of Emergency Service and Director of Curative Services.'),
('23d','23d.5','23d.5.3','1','Specific performance indicators are monitored.'),
('23d','23d.5','23d.5.3','2','Remedial action is taken when appropriate'),
('23e','23e.1','23e.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('23e','23e.1','23e.1.1','2','There is an endorsed and dated department Organisational chart with lines of functions and reporting relationships.'),
('23e','23e.1','23e.1.1','3','Relevant policies are available in the department. (National Health Plan, National Health Service Standards, Child and Adolescent Health Policy and Plan 2021-2030 etc.).'),
('23e','23e.1','23e.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('23e','23e.1','23e.1.1','5','Evidence of fee structure (if fees are collected).'),
('23e','23e.1','23e.1.2','1','Letter of appointment and terms of reference as the Head of Service.'),
('23e','23e.1','23e.1.2','2','Letter of appointment and terms of reference as a member of the Clinical Governance Advisory Committee.'),
('23e','23e.1','23e.1.2','3','Letter of appointment and terms of reference in other hospital committees.'),
('23e','23e.1','23e.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff.'),
('23e','23e.1','23e.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service.'),
('23e','23e.1','23e.1.3','3','Frequency of meetings are as scheduled.'),
('23e','23e.1','23e.1.3','4','Discussions and resolutions are implemented (problems not solved are brought forward to the next meeting till resolved).'),
('23e','23e.1','23e.1.4','1','The statistics and records from (a) to (h) are available.'),
('23e','23e.2','23e.2.1','1','There are dated and specific job descriptions for each staff that include (a) to (f).'),
('23e','23e.2','23e.2.1','2','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('23e','23e.2','23e.2.1','3','The scope of work in the job description aligns with the training, skill and experience of the staff (credentialling)'),
('23e','23e.2','23e.2.2','1','Evidence of current registration for all cadres of staff (annual practicing certificate).'),
('23e','23e.2','23e.2.3','1','Observation that cadres of staff are working according to their job description and job scope.'),
('23e','23e.2','23e.2.4','1','Training calendar includes in-house/ external courses/ workshops/ conferences.'),
('23e','23e.2','23e.2.4','2','Training for each staff including training in life support is kept in the Department.'),
('23e','23e.2','23e.2.4','3','There are ongoing Continuous Professional Activities in the Department.'),
('23e','23e.2','23e.2.5','1','Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.'),
('23e','23e.2','23e.2.6','1','Evidence of sufficient skilled trained staff to provide clinical supervision as per terms of Memorandum of Understanding.'),
('23e','23e.2','23e.2.7','1','Performance appraisal for staff, including medical practitioners, is completed upon probationary period and as an annual exercise.'),
('23e','23e.2','23e.2.8','1','Documented evidence of research activities in the Department.'),
('23e','23e.2','23e.2.9','1','Planning of staff allocation and movement within the Department includes the following;
a.) Deployment based on staff to patient ratio, bed occupancy rate and complexity of cases.
b.) Special skills/training of staff.
c.) Contingency plan for acute shortage.
d.) Duty roster.
e.) Evidence that all clinicians re not made to work more than the stipulated hours.'),
('23e','23e.2','23e.2.10','1','Evidence of policy stating that all staff have to attend a structured orientation programme.'),
('23e','23e.2','23e.2.10','2','Attendance list of those having attended the orientation programme.'),
('23e','23e.3','23e.3.1','1','Evidence of documented policies and procedures for the service.'),
('23e','23e.3','23e.3.1','2','The policies and procedures are endorsed and dated.'),
('23e','23e.3','23e.3.1','3','There is a periodic review at least once in three years.'),
('23e','23e.3','23e.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference.'),
('23e','23e.3','23e.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('23e','23e.3','23e.3.2','2','Patients/guardians participate in the development of mental health services.'),
('23e','23e.3','23e.3.3','1','Documented policies and procedures that address (a) to (m).'),
('23e','23e.3','23e.3.3','2','Staff are briefed on the policies and procedures (meeting minutes or circulation acknowledgement).'),
('23e','23e.3','23e.3.3','3','There is evidence of compliance to the policies and procedures (staff interview, observation, review of patient complaints, results of audits).'),
('23e','23e.3','23e.3.4','1','Operational policy on 24-hour service.'),
('23e','23e.3','23e.3.4','2','Staffing level reflects a good mix of senior and junior staff.'),
('23e','23e.3','23e.3.4','3','On call roster is dated and authorised.'),
('23e','23e.4','23e.4.1','1','Adequate and proper utilisation of space.'),
('23e','23e.4','23e.4.1','2','Appropriate type of equipment to match the complexity of services.'),
('23e','23e.4','23e.4.1','3','Adequate facilities and equipment at each patient care area for safe care. (e.g. defibrillators, emergency trolley, hand washing facilities etc.).'),
('23e','23e.4','23e.4.1','4','Easy access and clear (unblocked) exit routes.'),
('23e','23e.4','23e.4.1','5','Absence of overcrowding.'),
('23e','23e.4','23e.4.1','6','Availability of an isolation area.'),
('23e','23e.4','23e.4.2','1','Design and layout of the unit, e.g. wards, treatment rooms, dirty and clean utility rooms, access, lighting, signage, etc. address the safety aspects of patients and staff.'),
('23e','23e.4','23e.4.2','2','Equipment should have scheduled planned preventive maintenance (PPM).'),
('23e','23e.4','23e.4.2','3','Availability of an area for patients requiring seclusion.'),
('23e','23e.4','23e.4.2','4','Availability of an area for patients requiring restraint.'),
('23e','23e.4','23e.4.3','1','Appropriate telecommunication modalities available for daily operation and during emergencies.'),
('23e','23e.4','23e.4.4','1','Floor plan indicates accessibility and patient and user friendly.'),
('23e','23e.4','23e.4.4','2','Feedback from patient satisfaction survey.'),
('23e','23e.4','23e.4.4','3','Incident reporting relating to facilities if any.'),
('23e','23e.4','23e.4.5','1','Availability of emergency and non-emergency equipment appropriate to level of care, such as defibrillator, emergency trolley, suction machine, electrocardiogram (ECG) machine, infusion or syringe pump, vital sign monitor, pulse oximeter, oxygen concentrator etc.'),
('23e','23e.4','23e.4.5','2','Scheduled checking of items in emergency trolley.'),
('23e','23e.4','23e.4.6','1','Planned Preventive Maintenance records such as schedule, stickers, etc.'),
('23e','23e.4','23e.4.6','2','Planned Replacement Programme where applicable.'),
('23e','23e.4','23e.4.6','3','Complaint records.'),
('23e','23e.4','23e.4.6','4','Asset inventory.'),
('23e','23e.4','23e.4.7','1','User training records.'),
('23e','23e.4','23e.4.7','2','List of staff trained and authorised to operate specialised equipment.'),
('23e','23e.4','23e.4.8','1','Medications (a) to (j) are available within the Psychiatry services.'),
('23e','23e.4','23e.4.9','1','Evidence of list of services available and offered to patients.'),
('23e','23e.4','23e.4.9','2','Flow chart on work process.'),
('23e','23e.4','23e.4.9','3','Safe keeping of medical records.'),
('23e','23e.4','23e.4.9','4','Clinic appointment system.'),
('23e','23e.4','23e.4.9','5','Security of data in Health Information System.'),
('23e','23e.4','23e.4.9','6','Monitoring of waiting time.'),
('23e','23e.4','23e.4.9','7','Adequate and appropriate signage.'),
('23e','23e.4','23e.4.9','8','Floor plan indicates accessibility to supporting services and optimisation of space.'),
('23e','23e.4','23e.4.9','9','Adequate patient personal use items, e.g. wheelchair, mobility aids etc.'),
('23e','23e.4','23e.4.9','10','Adequate waiting area, toilets and reading material.'),
('23e','23e.4','23e.4.9','11','There is a designated area for patient seclusion.'),
('23e','23e.4','23e.4.10','1','Evidence of facilities with patient privacy ensured.'),
('23e','23e.4','23e.4.10','2','Procedure room appropriately equipped.'),
('23e','23e.4','23e.4.10','3','Patient monitoring device is available where required (vital signs).'),
('23e','23e.4','23e.4.10','4','List of procedures performed.'),
('23e','23e.5','23e.5.1','1','There is a designated person who monitors safety and performance improvement activities within the Psychiatry Services.'),
('23e','23e.5','23e.5.1','2','There are records/registers on performance improvement activities.'),
('23e','23e.5','23e.5.1','3','There are meeting minutes for performance improvement meetings.'),
('23e','23e.5','23e.5.1','4','There are records on innovation (if any)'),
('23e','23e.5','23e.5.2','1','System for incident reporting is in place with the following;
a.) Training of staff in incident reporting
b.) Policy on incident reporting
c.) Method/SOP on Incident reporting
d.) Register of incidents'),
('23e','23e.5','23e.5.2','2','Completed incident reports.'),
('23e','23e.5','23e.5.2','3','Corrective and preventive action plans.'),
('23e','23e.5','23e.5.2','4','Minutes of meeting.'),
('23e','23e.5','23e.5.2','5','Involved staff given feedback about the incident report.'),
('23e','23e.5','23e.5.2','6','Acknowledgment by Head of Psychiatric Service and Director of Curative Services.'),
('23e','23e.5','23e.5.3','1','Specific performance indicators are monitored.'),
('23e','23e.5','23e.5.3','2','Remedial action is taken when appropriate.'),
('23f','23f.1','23f.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('23f','23f.1','23f.1.1','2','There is an endorsed and dated department organisational chart with lines of functions and reporting relationships.'),
('23f','23f.1','23f.1.1','3','Relevant policies and guidelines are available in the department, i.e., National Health Plan, National Health Service Standards, etc.).'),
('23f','23f.1','23f.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('23f','23f.1','23f.1.1','5','Evidence of fee structure (if fees are collected).'),
('23f','23f.1','23f.1.2','1','Letter of appointment and terms of reference as the Head of Service.'),
('23f','23f.1','23f.1.2','2','Letter of appointment and terms of reference in other hospital committees.'),
('23f','23f.1','23f.1.2','3','Evidence of (a) to (d) in meeting minutes/correspondence of the Ophthalmology Services indicating the involvement of the Head of Service.'),
('23f','23f.1','23f.1.2','4','Request for allocation for budget and staffing.'),
('23f','23f.1','23f.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff.'),
('23f','23f.1','23f.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service.'),
('23f','23f.1','23f.1.3','3','Frequency of meetings are as scheduled.'),
('23f','23f.1','23f.1.3','4','Discussions and resolutions are implemented. (problems not solved are brought forward to the next meeting till resolved).'),
('23f','23f.1','23f.1.4','1','The statistics and records from (a) to (f) are available.'),
('23f','23f.1','23f.1.4','2','The NHSS Toolkit Assessment (checklist) for the relevant level has been completed in the past 6 months.'),
('23f','23f.2','23f.2.1','1','There are dated and specific job descriptions for each staff that include (a) to (f).'),
('23f','23f.2','23f.2.1','2','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('23f','23f.2','23f.2.1','3','The scope of work in the job description aligns with the training, skill and experience of the staff. (credentialling).'),
('23f','23f.2','23f.2.2','1','Evidence of current registration for all cadres of staff (annual practicing certificate).'),
('23f','23f.2','23f.2.3','1','Observation that cadres of staff are working according to their job description and job scope.'),
('23f','23f.2','23f.2.4','1','Training calendar includes in-house/ external courses/ workshops/ conferences.'),
('23f','23f.2','23f.2.4','2','Training for each staff including training in life support is kept in the Department.'),
('23f','23f.2','23f.2.4','3','There are ongoing Continuous Professional Activities in the Department.'),
('23f','23f.2','23f.2.5','1','Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.'),
('23f','23f.2','23f.2.6','1','Evidence of sufficient skilled trained staff to provide clinical supervision as per terms of Memorandum of Understanding.'),
('23f','23f.2','23f.2.7','1','Performance appraisal for staff including medical practitioners is completed upon probationary period and as an annual exercise.'),
('23f','23f.2','23f.2.8','1','Documented evidence of research activities in the Department.'),
('23f','23f.2','23f.2.9','1','Planning of staff allocation and movement within the Department includes the following;
a.) Deployment based on staff to patient ratio, bed occupancy rate and complexity of cases.
b.) Special skills/training of staff.
c.) Contingency plan for acute shortage.
d.) Duty roster.
e.) Evidence that all clinicians are not made to work more than the stipulated hours.'),
('23f','23f.2','23f.2.10','1','Evidence of policy stating that all staff have to attend a structured orientation programme.'),
('23f','23f.2','23f.2.10','2','Attendance list of those having attended the orientation programme.'),
('23f','23f.3','23f.3.1','1','Evidence of documented policies and procedures for the service.'),
('23f','23f.3','23f.3.1','2','The policies and procedures are endorsed and dated.'),
('23f','23f.3','23f.3.1','3','There is a periodic review at least once in three years.'),
('23f','23f.3','23f.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference'),
('23f','23f.3','23f.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('23f','23f.3','23f.3.3','1','Documented policies and procedures that address (a) to (u).'),
('23f','23f.3','23f.3.3','2','Staff are briefed on the policies and procedures (meeting minutes or circulation acknowledgement).'),
('23f','23f.3','23f.3.4','1','Operational policy on 24-hour service.'),
('23f','23f.3','23f.3.4','2','Staffing level reflects a good mix of senior and junior staff.'),
('23f','23f.3','23f.3.4','3','On call roster is dated and authorised.'),
('23f','23f.3','23f.3.5','1','Relevant updated Standard Treatment Guidelines are available in the division.'),
('23f','23f.3','23f.3.5','2','Patient register is updated daily.'),
('23f','23f.3','23f.3.5','3','Evidence of appropriate admission process.'),
('23f','23f.3','23f.3.5','4','Evidence of in-patient and guardian orientation process during admission.'),
('23f','23f.3','23f.3.5','5','Evidence of initial assessment and provisional diagnosis.'),
('23f','23f.3','23f.3.5','6','Evidence and documentation of morning and evening rounds.'),
('23f','23f.3','23f.3.5','7','Evidence of regular vital sign documentation'),
('23f','23f.3','23f.3.5','8','Documentation of discussions with patient/family/guardian about the patient’s condition.'),
('23f','23f.3','23f.3.5','9','Evidence of discussions with other disciplines and referrals if necessary.'),
('23f','23f.3','23f.3.5','10','Evidence of patient handover during shift change (documentation and observed).'),
('23f','23f.3','23f.3.5','11','Evidence of documented informed consent for procedures.'),
('23f','23f.3','23f.3.5','12','Evidence of flowchart on patient deterioration or “Code Blue” procedures.'),
('23f','23f.3','23f.3.5','13','Discharge summaries are issued to patients on discharge with a care plan.'),
('23f','23f.3','23f.3.5','14','Evidence of a patient referral register'),
('23f','23f.3','23f.3.6','1','Patient’s medical record has elements (a) to (m).'),
('23f','23f.3','23f.3.6','2','The Patient’s medical record has a unique identifier (MRN).'),
('23f','23f.3','23f.3.6','3','Evidence of clinical documentation which is signed, dated and with legible writing.'),
('23f','23f.3','23f.3.6','4','Evidence of use of appropriate abbreviations.'),
('23f','23f.4','23f.4.1','1','The building is sound and there is adequate space to match the services.'),
('23f','23f.4','23f.4.1','2','Appropriate type of equipment to match the complexity of services.'),
('23f','23f.4','23f.4.1','3','Adequate facilities and equipment at each patient care area for safe care. (e.g. defibrillators, emergency trolley, hand washing facilities etc.).'),
('23f','23f.4','23f.4.1','4','Easy access and clear (unblocked) exit routes.'),
('23f','23f.4','23f.4.1','5','Absence of overcrowding.'),
('23f','23f.4','23f.4.1','6','Availability of an isolation area.'),
('23f','23f.4','23f.4.1','7','There are lights/lamps/solar for blackouts.'),
('23f','23f.4','23f.4.1','8','There is good ventilation within the ward/s.'),
('23f','23f.4','23f.4.1','9','There is running water in the facility'),
('23f','23f.4','23f.4.1','10','Waste is segregated at the facility at the point of generation.'),
('23f','23f.4','23f.4.2','1','Design and layout of the unit, e.g. wards, treatment rooms, dirty and clean utility rooms, access, lighting, signage, etc., address the safety aspects of patients and staff.'),
('23f','23f.4','23f.4.2','2','Equipment should have scheduled planned preventive maintenance (PPM).'),
('23f','23f.4','23f.4.2','3','There is access to hand washing facilities.'),
('23f','23f.4','23f.4.2','4','Mattresses are covered with waterproof coverings and there is clean linen on every bed.'),
('23f','23f.4','23f.4.2','5','Sharps are disposed properly.'),
('23f','23f.4','23f.4.2','6','There is a designated area in the ward for ill patients who require extra supervision.'),
('23f','23f.4','23f.4.3','1','Appropriate telecommunication modalities available for daily operation and during emergencies.'),
('23f','23f.4','23f.4.4','1','There is up-to-date documentation of the total number of beds (overnight and day-only beds)'),
('23f','23f.4','23f.4.4','2','Evidence that any patient who occupies a bed for more than 4 hours and receives significant clinical care is classified as an “in-patient”.'),
('23f','23f.4','23f.4.4','3','Factors such as “bed occupancy rates” and “average length of stay” are monitored and analysed.'),
('23f','23f.4','23f.4.5','1','Floor plan indicates facility accessibility and is patient and user friendly.'),
('23f','23f.4','23f.4.5','2','Feedback from patient satisfaction surveys on the facilities.'),
('23f','23f.4','23f.4.5','3','Incident reporting relating to facilities if any.'),
('23f','23f.4','23f.4.5','4','Toilets have wheelchair access.'),
('23f','23f.4','23f.4.6','1','Availability of emergency and non-emergency equipment appropriate to level of care, such as defibrillator, emergency trolley, suction machine, electrocardiogram (ECG) machine, infusion or syringe pump, vital sign monitor, pulse oximeter, oxygen concentrator etc.'),
('23f','23f.4','23f.4.6','2','Scheduled checking of items in emergency trolley.'),
('23f','23f.4','23f.4.6','3','There are adequate patient transfer trolleys, wheelchairs, mobility aids and a dedicated drug fridge.'),
('23f','23f.4','23f.4.6','4','There is a dedicated cabinet for dangerous drugs which can be locked.'),
('23f','23f.4','23f.4.7','1','Planned Preventive Maintenance records such as schedule, stickers, etc.'),
('23f','23f.4','23f.4.7','2','Planned Replacement Programme where applicable.'),
('23f','23f.4','23f.4.7','3','Complaint records.'),
('23f','23f.4','23f.4.7','4','Asset inventory.'),
('23f','23f.4','23f.4.8','1','User training records'),
('23f','23f.4','23f.4.8','2','List of staff trained and authorised to operate specialised equipment.'),
('23f','23f.4','23f.4.9','1','Evidence of list of services available and offered to patients.'),
('23f','23f.4','23f.4.9','2','Flow chart on work process'),
('23f','23f.4','23f.4.9','3','Safe keeping of medical records'),
('23f','23f.4','23f.4.9','4','Clinic appointment system'),
('23f','23f.4','23f.4.9','5','Security of data in Health Information System'),
('23f','23f.4','23f.4.9','6','Monitoring of waiting time'),
('23f','23f.4','23f.4.9','7','Adequate and appropriate signage'),
('23f','23f.4','23f.4.9','8','Floor plan indicates accessibility to supporting services and optimisation of space'),
('23f','23f.4','23f.4.9','9','Adequate patient personal use items, e.g. wheelchair, mobility aids etc.'),
('23f','23f.4','23f.4.9','10','Adequate waiting area, toilets and reading material.'),
('23f','23f.4','23f.4.10','1','Evidence of facilities with patient privacy ensured.'),
('23f','23f.4','23f.4.10','2','Procedure room appropriately equipped.'),
('23f','23f.4','23f.4.10','3','Patient monitoring device is available where required (vital signs).'),
('23f','23f.4','23f.4.10','4','List of procedures performed.'),
('23f','23f.4','23f.4.10','5','The following equipment are available (slit lamp bio microscope, ophthalmoscopes)'),
('23f','23f.5','23f.5.1','1','There is a designated person who monitors safety and performance improvement activities within the Medical Services.'),
('23f','23f.5','23f.5.1','2','There are records/registers on performance improvement activities.'),
('23f','23f.5','23f.5.1','3','There are meeting minutes for performance improvement meetings.'),
('23f','23f.5','23f.5.1','4','There are records on innovation (if any).'),
('23f','23f.5','23f.5.2','1','System for incident reporting is in place with the following;
a.) Training of staff in incident reporting
b.) Policy on incident reporting
c.) Method (SOP) on incident reporting
d.) Register of incidents'),
('23f','23f.5','23f.5.2','2','Completed incident reports.'),
('23f','23f.5','23f.5.2','3','Corrective and preventative action plans.'),
('23f','23f.5','23f.5.2','4','Minutes of meeting(s).'),
('23f','23f.5','23f.5.2','5','Involved staff given feedback about the incident report.'),
('23f','23f.5','23f.5.2','6','Acknowledgment by Head of Ophthalmology Service and Director of Curative Services.'),
('23f','23f.5','23f.5.3','1','Specific performance indicators are monitored'),
('23f','23f.5','23f.5.3','2','Remedial action is taken when appropriate');
INSERT INTO standards ("standardNumber","standardTitle","standardSummary","functionId","componentId") SELECT standard_number,title,summary,4,6 FROM import_s;
INSERT INTO criteria ("criterionNumber","criterionTitle","standardId","isApplicable") SELECT x.number,x.title,s."standardId",true FROM import_c x JOIN standards s ON s."standardNumber"=x.standard_number;
INSERT INTO compliances ("complianceNumber","complianceSummary","criterionId","isApplicable") SELECT x.number,x.summary,c."criterionId",true FROM import_co x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number;
INSERT INTO evidence ("evidenceNumber","evidenceSummary","complianceId","isApplicable") SELECT x.number,x.summary,co."complianceId",true FROM import_e x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number JOIN compliances co ON co."criterionId"=c."criterionId" AND co."complianceNumber"=x.compliance_number;
DO $$ BEGIN
IF (SELECT count(*) FROM import_s x JOIN standards s ON s."standardNumber"=x.standard_number AND s."standardTitle"=x.title AND s."standardSummary"=x.summary AND s."functionId"=4 AND s."componentId"=6)<>5 THEN RAISE EXCEPTION 'Standard verification failed'; END IF;
IF (SELECT count(*) FROM import_c x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.number AND c."criterionTitle"=x.title AND c."isApplicable")<>25 THEN RAISE EXCEPTION 'Criterion verification failed'; END IF;
IF (SELECT count(*) FROM import_co x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number JOIN compliances co ON co."criterionId"=c."criterionId" AND co."complianceNumber"=x.number AND co."complianceSummary"=x.summary AND co."isApplicable")<>166 THEN RAISE EXCEPTION 'Compliance verification failed'; END IF;
IF (SELECT count(*) FROM import_e x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number JOIN compliances co ON co."criterionId"=c."criterionId" AND co."complianceNumber"=x.compliance_number JOIN evidence e ON e."complianceId"=co."complianceId" AND e."evidenceNumber"=x.number AND e."evidenceSummary"=x.summary AND e."isApplicable")<>537 THEN RAISE EXCEPTION 'Evidence verification failed'; END IF;
END $$;
COMMIT;
SELECT json_build_object('standardNumber',s."standardNumber",'standardId',s."standardId",'criteria',count(distinct c."criterionId"),'compliances',count(distinct co."complianceId"),'evidence',count(e."evidenceId"),'importedAt',CURRENT_TIMESTAMP) FROM standards s JOIN criteria c ON c."standardId"=s."standardId" JOIN compliances co ON co."criterionId"=c."criterionId" JOIN evidence e ON e."complianceId"=co."complianceId" WHERE s."standardNumber" IN ('23b','23c','23d','23e','23f') GROUP BY s."standardId" ORDER BY s."standardNumber";