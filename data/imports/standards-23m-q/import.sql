BEGIN;
SET LOCAL lock_timeout = '5s';
DO $$ BEGIN IF NOT EXISTS(SELECT 1 FROM functions WHERE "functionId"=4 AND "functionNumber"='4') OR NOT EXISTS(SELECT 1 FROM components WHERE "componentId"=6 AND "componentNumber"='6') THEN RAISE EXCEPTION 'Parent mapping changed'; END IF; IF EXISTS(SELECT 1 FROM standards WHERE lower("standardNumber") IN ('23m','23n','23p','23q')) THEN RAISE EXCEPTION 'Target standard already exists; review before importing'; END IF; END $$;
CREATE TEMP TABLE import_s (standard_number text NOT NULL, title text NOT NULL, summary text NOT NULL) ON COMMIT DROP;
INSERT INTO import_s VALUES
('23m','Dental services','Standard 23: provision of and continuity of care (mandatory standard)
The Healthcare Organisation ensures patients are provided with safe, high- quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.
The Healthcare Organisation should implement evidence-based practice and a have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.

Source references
Standard 17 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standard

Criterion guidance
23m.1 Organisation and management
The Dental Services shall be organised, directed and coordinated with other services in the Facility to provide a high standard of inpatient and outpatient care to the community in a safe, efficient, effective, evidence based and caring manner and with due regard for the needs, dignity and privacy of patients and confidentiality of their personal information. The Dental Services shall be easily accessible, and continuity of care assured.

23m.2 Human resources and development
The Dental Services shall be directed by a qualified and competent Dental practitioner, and staffed by suitably qualified and competent clinical staff to achieve the goals and objectives of the Dental Services. There are sufficient staffing levels, a staff supervision structure, performance appraisals and ongoing commitment to continuing medical education.

23m.3 Policies and procedures
There are written and dated policies for all activities of the Dental Services. These policies reflect current standards of dental practice, relevant regulations and statutory requirements. These policies and procedures, terms of reference, by laws, rules and regulations state how the clinical staff regulate themselves and provide patient care.

23m.4 Facilities and equipment
The Head of Dental Services shall ensure adequate facilities and equipment that are safe and appropriate are available for the staff to function effectively and to meet the goals and objectives of the Dental Services.

23m.5 Safety and performance improvement activities
The Head of Dental Services shall ensure the provision of quality performance with staff involvement in the continuous safety and performance improvement activities of the Dental Services.'),
('23n','Cancer services (oncology)','Standard 23: provision of and continuity of care (mandatory standard)
The Healthcare Organisation ensures patients are provided with safe, high- quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.
The Healthcare Organisation should implement evidence-based practice and a have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.

Source references
Standard 17 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standard

Criterion guidance
23n.1 Organisation and management
The Oncology Services shall be organised, directed and coordinated with other services in the facility to provide a standard of inpatient and outpatient care to the community in a safe, effective, efficient and caring manner. The Oncology services should be accessible, and continuity of care assured.

23n.2 Human resources and development
The Oncology Services shall be directed by a qualified and competent Oncology practitioner, and staffed by suitably qualified and competent clinical staff to achieve the goals and objectives of the Oncology Services. There are sufficient staffing levels, a staff supervision structure, performance appraisals and ongoing commitment to continuing Oncology education.

23n.3 Policies and procedures
There are written and dated policies for all activities of the Oncology Services. These policies reflect current standards of Oncology practice, relevant regulations and statutory requirements. These policies and procedures, terms of reference, by laws, rules and regulations state how the clinical staff regulate themselves and provide patient care. There shall be a list of procedures requiring informed consent specific to oncology. Possible risks and complications arising from procedures shall be documented either in specific consent forms or in patient''s records.

23n.4 Facilities and equipment
The Head of Oncology Services shall ensure adequate facilities and equipment that are safe and appropriate are available for the staff to function effectively and to meet the goals and objectives of the Oncology Services.

23n.5 Safety and performance improvement activities
The Head of Oncology Services shall ensure the provision of quality performance with staff involvement in the continuous safety and performance improvement activities of the Oncology Services.'),
('23p','Pathology','Standard 23: provision of and continuity of care (mandatory standard)
The Healthcare Organisation ensures patients are provided with safe, high- quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.
The Healthcare Organisation should implement evidence-based practice and a have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.

Source references
Standard 17 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standard

Criterion guidance
23p.1 Organisation and management
Pathology Services may be provided by a laboratory or laboratories within, or external to the Facility. The Pathology Services may include anatomical pathology, chemical pathology, haematology, microbiology and genetics. The services shall be organised and administered to provide a comprehensive and quality diagnostic service which is innovative, efficient and reliable for quality and safe patient care.

23p.2 Human resources and development
The Pathology Services shall be directed by a qualified and competent medical practitioner, and staffed by suitably qualified and competent staff to achieve the goals and objectives of the Pathology Services. There are sufficient staffing levels, a staff supervision structure, performance appraisals and ongoing commitment to continuing medical education.

23p.3 Policies and procedures
There are written and dated policies for all activities of the Pathology Services which reflect current knowledge and principles of laboratory practice.
They are consistent with statutory requirements and the objectives of the Pathology Services. There are current Laboratory User Manual and documented Standard Operating Procedures Manual available for staff reference.

23p.4 Facilities and equipment
Adequate facilities and equipment are available for the safe and efficient provision of Pathology Services taking into consideration the potentially hazardous circumstances of the operations.

23p.5 Safety and performance improvement activities
The Head of Pathology Services shall ensure the provision of quality performance with staff involvement in the continuous safety and performance improvement activities of the Pathology Services.'),
('23q','Mortuary services','Standard 23: provision of and continuity of care (mandatory standard)
The Healthcare Organisation ensures patients are provided with safe, high- quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.
The Healthcare Organisation should implement evidence-based practice and a have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.

Service scope
Mortuary services shall be provided within the Facility. The Mortuary Services shall include but are not limited to the provision of;
a.) Body reception
b.) Body services
c.) Body preparation/release area
d.) Body Area for body viewing
e.) Bereavement /Counselling room
f.) Post-mortem suite (where available)

Source references
Standard 17 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standard

Criterion guidance
23q.1 Organisation and management
The Mortuary Services are organised and administered to provide quality services appropriate to the level of mortuary services provided by the Facility.

23q.2 Human resources and development
The Mortuary Services shall be supervised by a suitably qualified, trained and competent practitioner and assisted by relevant categories of staff.

23q.3 Policies and procedures
There are written and dated policies for all activities of the Mortuary Services. These policies reflect current standards, relevant regulations and statutory requirements. These policies and procedures, terms of reference, by laws, rules and regulations state how the Mortuary Services staff regulate themselves and their operational practice.

23q.4 Facilities and equipment
The Officer in Charge of Mortuary Services shall ensure adequate facilities and equipment for the safe and efficient provision of Mortuary Services taking into consideration the scope of services and potentially hazardous circumstances of the Mortuary Services. This shall comply with relevant regulations and statutory requirements.

23q.5 Safety and performance improvement activities
The Head of Mortuary Services shall ensure the provision of quality performance with staff involvement in the continuous safety and performance improvement activities of the Mortuary Services.');
CREATE TEMP TABLE import_c (standard_number text NOT NULL, number text NOT NULL, title text NOT NULL) ON COMMIT DROP;
INSERT INTO import_c VALUES
('23m','23m.1','Organisation and management'),
('23m','23m.2','Human resources and development'),
('23m','23m.3','Policies and procedures'),
('23m','23m.4','Facilities and equipment'),
('23m','23m.5','Safety and performance improvement activities'),
('23n','23n.1','Organisation and management'),
('23n','23n.2','Human resources and development'),
('23n','23n.3','Policies and procedures'),
('23n','23n.4','Facilities and equipment'),
('23n','23n.5','Safety and performance improvement activities'),
('23p','23p.1','Organisation and management'),
('23p','23p.2','Human resources and development'),
('23p','23p.3','Policies and procedures'),
('23p','23p.4','Facilities and equipment'),
('23p','23p.5','Safety and performance improvement activities'),
('23q','23q.1','Organisation and management'),
('23q','23q.2','Human resources and development'),
('23q','23q.3','Policies and procedures'),
('23q','23q.4','Facilities and equipment'),
('23q','23q.5','Safety and performance improvement activities');
CREATE TEMP TABLE import_co (standard_number text NOT NULL, criterion_number text NOT NULL, number text NOT NULL, summary text NOT NULL) ON COMMIT DROP;
INSERT INTO import_co VALUES
('23m','23m.1','23m.1.1',''),
('23m','23m.1','23m.1.2','There is a mechanism to ensure effective interaction between the Head of the Services or the Officer in Charge (OIC) and the Organisation’s Governing Body and Senior Management. The Head of Services shall also be involved for the following aspects of management of the services;
a.) Preparation of budget and ensuring that expenditure remains within the budget allocated
b.)  Human resource
c.) Facility and equipment management
d.) Safety and performance improvement activities and risk management'),
('23m','23m.1','23m.1.3','Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the Dental Services. These meetings are minuted and communicated to all staff.'),
('23m','23m.1','23m.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care. The following (among others) are available;
a.) Workload/census for inpatients and outpatients
b.) Quarterly and annual report
c.) Incident reports and register
d.) Staffing number and staff profile
e.) Staff training records
f.) Data on performance improvement
g.) Number of referrals to the Dental Services.'),
('23m','23m.2','23m.2.1','The are written and dated job descriptions for each category of staff that include;
a.) Qualification, training and experience for the position
b.) Lines of authority
c.) Accountability, functions and responsibilities
d.) Reviewed when required if there is major change in job scope
e.) Statutory regulations
f.) Administrative and clinical job scope'),
('23m','23m.2','23m.2.2','The staff holds current registration with the relevant professional body.'),
('23m','23m.2','23m.2.3','The staff works within their job description and job scope.'),
('23m','23m.2','23m.2.4','There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice.'),
('23m','23m.2','23m.2.5','The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.'),
('23m','23m.2','23m.2.6','In a Facility where undergraduate medical, nursing and allied health training programmes are conducted, the Facility shall ensure there are sufficient skilled trained staff to provide clinical supervision of students.'),
('23m','23m.2','23m.2.7','Staff receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('23m','23m.2','23m.2.8','Where appropriate, the Department shall endeavour to undertake clinical research using available resources.'),
('23m','23m.2','23m.2.9','Staffing levels are based on the following;
a.) The number of persons deployed is proportional to the number of patients being cared for as per regulatory requirements and for the intensity of care provided
b.) The categories of service providers reflect the complexity of clinical problems being managed.
c.) Staffing needs shall take into consideration absences due to leave or illness.
d.) Adequate staffing levels of appropriate competency shall be maintained throughout the hours the services are in operation.
e.) Where it is not possible to have service providers on duty on site, e.g. after working hours, provision is made for relevant medical practitioner to be available on call.'),
('23m','23m.2','23m.2.10','There is a structured orientation programme for all newly appointed staff to the Dental Services including medical practitioners and for those new to specific areas that include the following;
a.) Explanation of the goals, objectives, policies and procedures of the Facility and those of the Dental Services
b.) Lines of authority and areas of responsibility
c.) Explanation of duties and functions
d.) Explanation of the methods of assigning clinical care and the standards of clinical practice
e.) Handover communication
f.) Processes for resolving practice/ethical dilemmas in a timely manner
g.) Information about safety procedures
h.) Training in basic/advanced life support techniques
i.) Methods of obtaining appropriate resource materials
j.) Staff appraisal procedures for the Dental Services
k.) Education on Patient and Family Rights'),
('23m','23m.3','23m.3.1','There are written policies and procedures for the Dental Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.'),
('23m','23m.3','23m.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('23m','23m.3','23m.3.3','The policies and procedures documentation shall address at least the following topics;
a.) Description of the organisational structure of the Dental Services
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
('23m','23m.3','23m.3.4','Adequate information on the practice hours is available. The service should operate on a 24- hour basis if needed, providing level of care appropriate to the facility.'),
('23m','23m.3','23m.3.5','During admission, the service shall ensure that provision of patient care and services achieve effective outcomes and is safe.'),
('23m','23m.3','23m.3.6','There is a standardised patient medical record during admission. This record should have the following;
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
('23m','23m.4','23m.4.1','There are adequate and appropriate facilities and equipment with proper utilisation of space to enable staff to carry out their professional, teaching and administrative functions.'),
('23m','23m.4','23m.4.2','Existing facilities shall consider the safety and comfort of staff and patients.'),
('23m','23m.4','23m.4.3','Suitable forms of communication systems and equipment are provided to enable clinical staff to communicate among themselves and with the other members of the healthcare team.'),
('23m','23m.4','23m.4.4','The dental clinic front office staff are able to prioritise patients according to urgency of their condition.'),
('23m','23m.4','23m.4.5','The Dental Clinic shall have the following features;
a.) The organisation and management of the clinics are planned to ensure minimal waiting time, and avoidance of unnecessary visits by the patients
b.) Record keeping shall be efficient
c.) An appointment or queuing system is used to manage patient consultations
d.) The clinic is easily accessible including for non-ambulant patients and is easily identified through adequate signage
e.) The clinic is located close to other facilities, e.g. radiology, laboratories and pharmacy
f.) Adequate provision is made for patient comfort
g.) Call back system (especially for high- risk cases)
h.) Avenue for patients to access service between appointments
i.) Monitoring of data'),
('23m','23m.4','23m.4.6','Patient assessment shall be appropriate, comprehensive and documented. Patient health records should contain sufficient information to identify the patient and to document reasons for visit, assessment, management, progress and outcome.'),
('23m','23m.4','23m.4.7','Facilities are suitably located to facilitate easy access and to provide an atmosphere of user, environmental and ‘disabled’ friendly.'),
('23m','23m.4','23m.4.8','Equipment, both for emergency and non-emergency usage, shall be appropriate to the level of care.'),
('23m','23m.4','23m.4.9','There is evidence that the facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order.'),
('23m','23m.4','23m.4.10','Where specialised equipment is used, there is evidence that only staff who are trained and authorised by the Facility operate such equipment.'),
('23m','23m.4','23m.4.11','At the Outpatient Clinic, adequate numbers of rooms are provided to ensure patient privacy and confidentiality for various patient care activities including;
a.) Consultation (not more than one patient in a room at any time).
b.) Minor procedures and nursing procedures.
c.) Performance of various tests.'),
('23m','23m.5','23m.5.1','There are planned activities for performance and quality improvement.'),
('23m','23m.5','23m.5.2','The Head of Dental Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.'),
('23m','23m.5','23m.5.3','Specific performance indicators (among others) are tracked e.g.
a.) Unplanned return to Operating Theatre within the same hospital admission following surgery
b.) Waiting time at the dental clinic.'),
('23n','23n.1','23n.1.1','The Vision, Mission of the Facility are visible. The Goals of the Oncology Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.'),
('23n','23n.1','23n.1.2','There is a mechanism to ensure effective interaction between the Head of the Services and the Organisation’s Governing Body and Senior Management.'),
('23n','23n.1','23n.1.3','Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the Oncology Services. These meetings are minuted and communicated to all staff.'),
('23n','23n.1','23n.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care. The following (among others) are available;
a. workload/census for inpatients and outpatients
b. quarterly and annual report
c. incident reports and register
d. staffing number and staff profile
e. staff training records
f. data on performance improvement'),
('23n','23n.2','23n.2.1','The are written and dated job descriptions for each category of staff that include;
a. Qualification, training and experience for the position
b. Lines of authority
c. Accountability, functions and responsibilities
d. Reviewed when required if there is major change in job scope
e. Statutory regulations
f. Administrative and clinical job scope'),
('23n','23n.2','23n.2.2','The staff holds current registration with the relevant professional body.'),
('23n','23n.2','23n.2.3','The staff works within their job description and job scope.
There are policies in place determining those who can prescribe chemotherapy and radiotherapy are clinical and radiation oncologists.'),
('23n','23n.2','23n.2.4','There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice.'),
('23n','23n.2','23n.2.5','The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.'),
('23n','23n.2','23n.2.6','In a Facility where undergraduate or postgraduate Oncology, nursing and allied health training programmes are conducted, the Facility shall ensure there are sufficient skilled trained staff to provide clinical supervision of students.'),
('23n','23n.2','23n.2.7','Staff including Oncology practitioners receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('23n','23n.2','23n.2.8','Where appropriate the Facility shall endeavour to undertake clinical research using available resources.'),
('23n','23n.2','23n.2.9','Staffing levels are based on the following;
a. The number of persons deployed is proportional to the number of patients being cared for as per regulatory requirements and for the intensity of care provided
b. The categories of service providers reflect the complexity of clinical problems being managed
c. Staffing needs shall take into consideration absences due to leave or illness; double shift duties by clinical staff shall be documented and monitored
d. Adequate staffing levels of appropriate competency shall be maintained throughout the hours the services are in operation.
e. Where it is not possible to have service providers on duty on site, e.g. after working hours, provision is made for relevant Oncology practitioner to be available on call.'),
('23n','23n.2','23n.2.10','There is a structured orientation programme for all newly appointed staff to the Oncology Services that include the following;
a. Explanation of the goals, objectives, policies and procedures of the Facility and those of the Oncology Services
b. Lines of authority and areas of responsibility
c. Explanation of duties and functions
d. Explanation of the methods of assigning clinical care and the standards of clinical practice
e. Handover communication
f. Processes for resolving practice/ethical dilemmas in a timely manner
g. Information about safety procedures
h. Training in basic/advanced life support techniques
i. Methods of obtaining appropriate resource materials
j. Staff appraisal procedures for the Oncology Services
k. Education on Patient and Family Rights'),
('23n','23n.3','23n.3.1','There are written policies and procedures for the Oncology Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.'),
('23n','23n.3','23n.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('23n','23n.3','23n.3.3','The policies and procedures documentation shall address at least the following topics;
a. Description of the organisational structure of the Oncology Services
b. The use of updated Standard Treatment Guidelines.
c. Handover communication
d. Drug prescription, dispensing and administration
e. Blood transfusion
f. Continuing of care including regular review of patient and review of investigation results
g. Admission and Discharge (planned or “At Own Risk”)
h. Referrals and Repatriations
i. Guardians for patients
j. Management of cases with an infectious disease including notification of notifiable diseases
k. Internal and External Disaster
l. Incident reports
m. Management of deaths.
n. Health information system and Oncology Records.
o. Outreach and supervisory visits
p. Infection Prevention and Control
q. Management of acutely deteriorating patients.
r. Patient feedback and complaint mechanism.
s. Informed consent
t. Pain management'),
('23n','23n.3','23n.3.4','The service shall operate on a 24- hour basis providing level of care appropriate the facility.'),
('23n','23n.3','23n.3.5','The service shall ensure that provision of patient care and services achieve effective outcomes and is safe.'),
('23n','23n.3','23n.3.6','There is a standardised patient Oncology record.
This record should have the following:
a. An identification page
b. Vital sign monitoring sheet (BP, HR, SpO2, Conscious level)
c. Patient history
d. Clinical notes
e. Consent form
f. Diagnostic reports including histopathology
g. Final diagnosis and code at time of discharge
h. Drug order/medication sheet
i. Operating theatre sheet (if appropriate)
j. Allergy and adverse reaction documentation
k. Behaviour issues that may pose a risk.
l. Discharge summary
m. Referral form (if applicable)
n. Checklist for chemotherapy or radiation therapy where applicable'),
('23n','23n.4','23n.4.1','There are adequate and appropriate facilities and equipment with proper utilisation of space to enable staff to carry out their professional, teaching and administrative functions.'),
('23n','23n.4','23n.4.2','Existing facilities shall consider the safety and comfort of staff and patients.'),
('23n','23n.4','23n.4.3','Suitable forms of communication systems and equipment are provided to enable clinical staff to communicate among themselves and with the other members of the healthcare team.'),
('23n','23n.4','23n.4.4','There is optimal management of beds at the Oncology Services with documentation of total number of beds and monitoring of bed occupancy rates.'),
('23n','23n.4','23n.4.5','Facilities are suitably located to facilitate easy access and to provide an atmosphere of user, environmental and ‘disabled’ friendly.'),
('23n','23n.4','23n.4.6','Equipment, both for emergency and non-emergency usage, shall be appropriate to the level of care.'),
('23n','23n.4','23n.4.7','There is evidence that the facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order.'),
('23n','23n.4','23n.4.8','Where specialised equipment is used, there is evidence that only staff who are trained and authorised by the Facility operate such equipment.'),
('23n','23n.4','23n.4.9','The Specialist Outpatient Services shall have the following features;
a. The organisation and management of the clinics are planned to ensure minimal waiting time, and avoidance of unnecessary visits by the patients.
b. Record keeping shall be efficient.
c. An appointment or queuing system is used to manage patient consultations.
d. The clinic is easily accessible including for non-ambulant patients and is easily identified through adequate signage.
e. The clinic is located close to other facilities, e.g. radiology, laboratories and pharmacy.
f. Adequate provision is made for patient comfort.
g. Call back system (especially for high- risk cases)
h. Avenue for patients to access service between appointments.'),
('23n','23n.4','23n.4.10','At the Outpatient Clinic, adequate numbers of rooms are provided to ensure patient privacy and confidentiality for various patient care activities including:
a. Consultation (not more than one patient in a room at any time).
b. Minor procedures and nursing procedures.
c. Performance of various tests.'),
('23n','23n.5','23n.5.1','There are planned activities for performance and quality improvement.'),
('23n','23n.5','23n.5.2','The Head of Oncology Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.'),
('23n','23n.5','23n.5.3','Specific performance indicators are tracked for e.g., number of mortality audits being done, percentage of patients who develop chemotherapy extravasation.'),
('23p','23p.1','23p.1.1','The Vision, Mission of the Facility are visible. The Goals of the Oncology Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.
All off-site hospital laboratory under the purview of Pathology Services shall be included in the main organisation chart.'),
('23p','23p.1','23p.1.2','There is a mechanism to ensure effective interaction between the Head of the Services and the Organisation’s Governing Body and Senior Management. The Head of Services shall also be involved for the following aspects of management of the services;
a.) Preparation of budget and ensuring that expenditure remains within the budget allocated
b.) Human resource
c.) Facility and equipment management
d.) Safety and performance improvement activities and risk management'),
('23p','23p.1','23p.1.3','Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the Pathology Services. These meetings are minuted and communicated to all staff.'),
('23p','23p.1','23p.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care. The following (among others) are available;
a.) Workload/census for inpatients and outpatients
b.) Quarterly and annual report
c.) Incident reports and register
d.) Staffing number and staff profile
e.) Staff training records
f.) Data on performance improvement
g.) Number of referrals
h.) Number of autopsies performed (hospital/coroner’s case)'),
('23p','23p.1','23p.1.5','Facilities that do not have their own Pathology Services or cannot provide a full range of laboratory services, can arrange with an external laboratory or laboratories to provide the services needed.'),
('23p','23p.2','23p.2.1','The are written and dated job descriptions for each category of staff that include;
a. Qualification, training and experience for the position
b. Lines of authority
c. Accountability, functions and responsibilities
d. Reviewed when required if there is major change in job scope
e. Statutory regulations
f. Administrative and clinical job scope'),
('23p','23p.2','23p.2.2','The staff holds current registration with the relevant professional body.'),
('23p','23p.2','23p.2.3','The staff works within their job description and job scope.'),
('23p','23p.2','23p.2.4','There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice.'),
('23p','23p.2','23p.2.5','The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.'),
('23p','23p.2','23p.2.6','Where applicable, the functions of the Pathology Services include undergraduate, postgraduate and other health professional education, research projects and special studies, as appropriate.'),
('23p','23p.2','23p.2.7','Staff including medical practitioners receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('23p','23p.2','23p.2.8','Where appropriate, the Facility shall endeavour to undertake clinical research using available resources.'),
('23p','23p.2','23p.2.9','The Pathology Services shall provide a continuing education activity for non-laboratory health professional staff to keep them informed of matters related to Pathology Services.'),
('23p','23p.2','23p.2.10','There is a structured orientation programme for all newly appointed staff to the Pathology Services including medical practitioners and for those new to specific areas that include the following;
a. Explanation of the goals, objectives, policies and procedures of the Facility and those of the Pathology Services
b. Lines of authority and areas of responsibility
c. Explanation of duties and functions
d. Rules and regulations especially related to health hazards and safety precautions
e. Handover communication
f. Staff appraisal procedures for the Pathology Services
g. Requirements for immunisation against certain high-risk diseases'),
('23p','23p.3','23p.3.1','There are written policies and procedures for the Pathology Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices. These policies include;
a. The conduct of professional activities in accordance with the ethical standards of the professions involved
b. Provide ready but controlled access to laboratory results
c. Introduction of new tests, improvement on techniques, and undertaking research, where appropriate
d. Provision of services on a 24-hour basis
e. Contribution to the provision of high- quality patient care by assisting in the review and evaluation of clinical practice within the Facility
f. Provision of consultative service for the medical profession and other relevant staff in the selection of the laboratory investigations, their interpretation, and repeat test if required
g. Communication with medical, nursing, and other relevant staff on matters related to the services provided.
h. Internal and external disaster plan
i. Identify, assess and manage risks.'),
('23p','23p.3','23p.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('23p','23p.3','23p.3.3','Staff are aware of these policies and procedures.'),
('23p','23p.3','23p.3.4','There is evidence of compliance with the policies and procedures.'),
('23p','23p.3','23p.3.5','There are policies and procedures relating to requests for laboratory tests which include;
a. Authorised person who can request for the test
b. Written confirmation of all verbal request
c. Identification of the patient by full name, medical record number, date of birth and sex
d. Relevant medical history of patient
e. Relevant medications of patient
f. Tests requested
g. Name of the requesting doctor
h. Identification of the nature of the specimen on the request form and clear labelling of specimens requiring precautionary handling'),
('23p','23p.3','23p.3.6','There are written instructions for the proper collection, labelling, storage, preservation and transportation of specimens; and safety measures to be observed.
These instructions are readily accessible to all staff who may be involved in obtaining specimens from patients.
There are written policies determining the length of time for which reports and specimens are retained.'),
('23p','23p.3','23p.3.7','All pathology reports of investigations done on-site or off-site are included in the patient''s medical record:
a. Copies of all pathology reports are promptly sent to be reviewed and filed in the patient''s medical record.
b. Report/forms/results are designed to facilitate comparison of sequential tests/reports.
c. There is provision for immediate communication of results with critical range.
d. When the reports are communicated via phone, the results are documented in the patient’s notes with the following details;
• the person providing the report
• the person receiving the report
• patient identity
• pathology results
• date and time of receipt of the results'),
('23p','23p.3','23p.3.8','Frozen section reports are transmitted directly to the surgeon concerned and followed by a written report.'),
('23p','23p.3','23p.3.9','There is evidence that there are Standards Precaution and Safety guidelines available specifically for Pathology Services.'),
('23p','23p.4','23p.4.1','The office is separated from the technical laboratory area.'),
('23p','23p.4','23p.4.2','There are designated areas for handling of potentially hazardous material.'),
('23p','23p.4','23p.4.3','Work benches shall be adequately spaced and arranged in such a way as to ensure safety and efficiency in the use of equipment in accordance with manufacturer''s recommendation and safety regulations.'),
('23p','23p.4','23p.4.4','There are adequate and proper storage areas of reagents, tissue specimens, consumables and other materials'),
('23p','23p.4','23p.4.5','There are separate and suitable stores for inflammable solvents and acid.'),
('23p','23p.4','23p.4.6','There are suitably located staff facilities for emergency shower and eye wash, changing room, locker facilities and storage for protective clothing.'),
('23p','23p.4','23p.4.7','There is suitable, adequate and safe provision for air conditioning, ventilation, lighting, power, gases, water and drainage in the laboratory.'),
('23p','23p.4','23p.4.8','The pathology equipment is appropriate and adequate to meet the demands of the service and are properly maintained.'),
('23p','23p.4','23p.4.9','Where specialised equipment is used, there is evidence that only staff who are trained and authorised by the Facility operate such equipment.'),
('23p','23p.4','23p.4.10','Inventory of equipment, reagents and consumables shall be maintained.'),
('23p','23p.4','23p.4.11','Each equipment/instrument has a logbook and maintenance record and these shall be made available when required.'),
('23p','23p.4','23p.4.12','There is evidence that the facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order.'),
('23p','23p.4','23p.4.13','There is evidence of general cleanliness in the laboratory. There are proper facilities for the disposal of biohazard material as either effluent or containerised material.'),
('23p','23p.5','23p.5.1','There are planned activities for performance and quality improvement.'),
('23p','23p.5','23p.5.2','The Head of Pathology Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.'),
('23p','23p.5','23p.5.3','Specific performance indicators (among others) are tracked e.g.;
a.) Timeliness of urgent requests
b.) Rejection rate of specimens'),
('23p','23p.5','23p.5.4','The Pathology Services has quality control programmes for all tests provided.'),
('23q','23q.1','23q.1.1','The Vision, Mission of the Facility are accessible. The Goals of the Mortuary Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.'),
('23q','23q.1','23q.1.2','There is a mechanism to ensure effective interaction between the Officer in Charge (OIC) and the Organisation’s Governing Body and Senior Management.'),
('23q','23q.1','23q.1.3','Regular staff meetings are held between the Officer Head of Service and staff with sufficient regularity to discuss issues pertaining to the Mortuary Services. These meetings are minuted and communicated to all staff.'),
('23q','23q.1','23q.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care.
The following (among others) are available:
a.) workload
b.) quarterly and annual report
c.) incident reports and register
d.) staffing number and staff profile
e.) staff training records
f.) data on performance improvement'),
('23q','23q.2','23q.2.1','The Officer in Charge and staff of the Mortuary Services shall be individuals qualified by education, training, experience and certification to meet the demands of the various positions and to achieve the objectives of the services.
There is evidence that the staff have some training or experience in the processes governing the mortuary.'),
('23q','23q.2','23q.2.2','The are written and dated job descriptions for each category of staff that include:
a.) Qualification, training and experience for the position
b.) Lines of authority
c.) Accountability, functions and responsibilities
d.) Administrative and clinical job scope'),
('23q','23q.2','23q.2.3','The staff holds current registration with the relevant professional body (for relevant staff).'),
('23q','23q.2','23q.2.4','The staff works within their job description and job scope.'),
('23q','23q.2','23q.2.5','There are continuing education activities for staff to maintain competency in their current positions.'),
('23q','23q.2','23q.2.6','The educational needs of staff are addressed following findings from incidents reports and performance improvement studies.'),
('23q','23q.2','23q.2.7','Staff receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('23q','23q.2','23q.2.8','Staffing levels are based on the following;
a.) Number of staff proportional to the workload.
b.) Adequate staffing levels of appropriate competency shall be maintained throughout the hours the services are in operation.
c.) There is an on-call roster if applicable.'),
('23q','23q.2','23q.2.9','There is a structured orientation programme for all Mortuary Services staff;
a.) Explanation of the goals, objectives, policies and procedures of the Facility.
b.) Lines of authority and areas of responsibility.
c.) Explanation of duties and functions.
d.) Processes for resolving practice/ethical dilemmas in a timely manner
e.) Relevant information about occupational hazards and safety procedures including handling of specimens and Infection Prevention and Control.'),
('23q','23q.3','23q.3.1','There are written policies and procedures for the Mortuary Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.'),
('23q','23q.3','23q.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('23q','23q.3','23q.3.3','There are policies and procedures relating to all post-mortem examinations (coroner’s cases);
a.) Persons who are authorised to order for a post-mortem examination;
b.) Written orders for a medico-legal post-mortem examination
c.) Identification of body part or the deceased by full name*/identification document number/passport/police report number/post-mortem number and/or medical record number;
d.) Name and rank of the officer ordering the forensic post-mortem examination;
e.) Retention of records and specimens;
f.) Types of specimens collected at post-mortem which are to be submitted for histopathological, microbiological/virological, toxicological and other relevant investigation.
Papua New Guinea’s Coroners Act 1953 (Chapter 32)'),
('23q','23q.3','23q.3.4','There are written instructions for the proper handling of the specimens as required by law which include collection, labelling, sealing, packaging, transport of specimens, dispatch/handing over to relevant authority.
These instructions are readily accessible to the staff. The preservation of chain of evidence shall be maintained throughout the process of specimen handling.'),
('23q','23q.3','23q.3.5','Complete records and documentation of body management shall be maintained where applicable;
a.) Registration of bodies received.
b.) Records on specimens forwarded to other laboratories.
c.) All specimens and evidences taken from the deceased.
d.) All relevant forensic medicine reports (e.g. post-mortem reports, laboratory results) are filed appropriately
e.) All movement of records or reports out of the forensic services.'),
('23q','23q.3','23q.3.6','There is evidence of compliance with policies and procedures. These include but not limited top;
a.) Preparation of the dead body in the ward before transfer to mortuary
b.) Tagging of the deceased for proper identification
c.) Method of transportation to the mortuary
d.) Record of receiving the deceased in the mortuary
e.) Viewing of the deceased by relatives
f.) Procedures for releasing the deceased to the next of kin
g.) Procedures of burial of unclaimed bodies.'),
('23q','23q.3','23q.3.7','There are written safety procedures and manuals on hazards and safety precautions specific to the Mortuary Services. All staff shall practice Standard Precautions and Safety Guidelines.'),
('23q','23q.4','23q.4.1','The mortuary shall be accessible from an outside entrance and following a designated route of the Facility. Appropriate transport for transferring bodies to the mortuary that to ensure dignity and respect is accorded to the deceased.'),
('23q','23q.4','23q.4.2','There are appropriate areas for the following;
a.) Body receiving area shall be of a suitable size and design to facilitate incoming and outgoing of bodies;
b.) Clean and dirty areas are clearly designated;
c.) There is sufficient space and refrigeration for storage of bodies with provision for accurate identification of bodies;
d.) The temperature of the body freezer (2-8⁰C ± 2) shall be maintained, monitored and documented;
e.) There are adequate space, facilities and equipment for the administrative, professional, and technical functions of the Mortuary Services.'),
('23q','23q.4','23q.4.3','There are appropriate areas for the post-mortem room (where applicable), which include;
a.) Access to the post-mortem room shall be controlled
b.) The post-mortem room is clean and has adequate space, ventilation and lighting;
c.) There are adequate facilities for performing post-mortem examination, recording of findings, specimen handling and storage;
d.) The post-mortem equipment is appropriate, adequate and is properly maintained;
e.) Post-mortem table is of a suitable design with proper facilities for the disposal of effluent into the sewage system to ensure safety;
f.) There is adequate ventilation with extraction for fumes and odours in the work area where appropriate'),
('23q','23q.4','23q.4.4','There is suitable, adequate and safe provision for;
a.) Lighting, power, water, and drainage, appropriate to the scope of services provided which include;
b.) Power supply, which shall be adequate, and there are sufficient power sockets which are suitably located.
c.) Adequate and appropriate lighting.'),
('23q','23q.4','23q.4.5','There are designated areas for reception and the handling of decomposed bodies and high- risk cases (for infection) where appropriate.'),
('23q','23q.4','23q.4.6','There are designated areas for body cleansing/preparation, body viewing, bereavement, performing cultural rites and release of bodies.'),
('23q','23q.4','23q.4.7','Where appropriate, there are staff facilities with changing room, shower, locker facilities, and storage for protective clothing/gear and they are suitably located.'),
('23q','23q.4','23q.4.8','There are adequate and appropriate data processing, retrieval, and communication facilities.'),
('23q','23q.4','23q.4.9','Where specialised equipment such as autopsy saw and chemicals, e.g. 10% formaldehyde and other hazardous chemicals are used, there is evidence that only staff who are trained and authorised operate such equipment/chemicals.'),
('23q','23q.4','23q.4.10','There are adequate and designated storage area for consumables and chemicals.'),
('23q','23q.4','23q.4.11','There is evidence of general cleanliness in the Mortuary Services. Biohazardous materials are appropriately disposed.'),
('23q','23q.5','23q.5.1','There are planned activities for performance and quality improvement.'),
('23q','23q.5','23q.5.2','The Head of the Mortuary Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff with learning objectives.
Incidents reported have had Root Cause Analysis done and action taken within the agreed time frame to prevent recurrence.'),
('23q','23q.5','23q.5.3','Specific performance indicators are tracked for e.g.;
a.) Turnaround time for release of bodies to the next of kin (non-police) cases is less than 3 hours
b.) Post mortems reports are completed within 12 weeks of the post mortem.');
CREATE TEMP TABLE import_e (standard_number text NOT NULL, criterion_number text NOT NULL, compliance_number text NOT NULL, number text NOT NULL, summary text NOT NULL) ON COMMIT DROP;
INSERT INTO import_e VALUES
('23m','23m.1','23m.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('23m','23m.1','23m.1.1','2','There is an endorsed and dated department organisational chart with lines of functions and reporting relationships.'),
('23m','23m.1','23m.1.1','3','Relevant policies and guidelines are available in the department, i.e., National Health Plan, National Health Service Standards, etc.)'),
('23m','23m.1','23m.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('23m','23m.1','23m.1.1','5','Evidence of fee structure (if fees are collected).'),
('23m','23m.1','23m.1.2','1','Letter of appointment and terms of reference as the Head of Service.'),
('23m','23m.1','23m.1.2','2','Letter of appointment and terms of reference in other hospital committees.'),
('23m','23m.1','23m.1.2','3','Evidence of (a) to (d) in meeting minutes/correspondence of the Dental Services indicating the involvement of the Head of Service.'),
('23m','23m.1','23m.1.2','4','Request for allocation for budget and staffing.'),
('23m','23m.1','23m.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff.'),
('23m','23m.1','23m.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service.'),
('23m','23m.1','23m.1.3','3','Frequency of meetings are as scheduled.'),
('23m','23m.1','23m.1.3','4','Discussions and resolutions are implemented. (problems not solved are brought forward to the next meeting till resolved).'),
('23m','23m.1','23m.1.4','1','The statistics and records from (a) to (g) are available.'),
('23m','23m.1','23m.1.4','2','The NHSS Toolkit Assessment (checklist) for the relevant level has been completed in the past 6 months.'),
('23m','23m.2','23m.2.1','1','There are dated and specific job descriptions for each staff that include (a) to (f).'),
('23m','23m.2','23m.2.1','2','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('23m','23m.2','23m.2.1','3','The scope of work in the job description aligns with the training, skill and experience of the staff. (credentialling)'),
('23m','23m.2','23m.2.2','1','Evidence of current registration for all cadres of staff (annual practicing certificate).'),
('23m','23m.2','23m.2.3','1','Observation that cadres of staff are working according to their job description and job scope.'),
('23m','23m.2','23m.2.4','1','Training calendar includes in-house/ external courses/ workshops/ conferences.'),
('23m','23m.2','23m.2.4','2','Training for each staff including training in life support is kept in the Department.'),
('23m','23m.2','23m.2.4','3','There are ongoing Continuous Professional Activities in the Department.'),
('23m','23m.2','23m.2.5','1','Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.'),
('23m','23m.2','23m.2.6','1','Evidence of sufficient skilled trained staff to provide clinical supervision as per terms of Memorandum of Understanding.'),
('23m','23m.2','23m.2.7','1','Performance appraisal for staff including medical practitioners is completed upon probationary period and as an annual exercise.'),
('23m','23m.2','23m.2.8','1','Documented evidence of research activities in the Department.'),
('23m','23m.2','23m.2.9','1','Planning of staff allocation and movement within the Department includes the following;
a.) Deployment based on staff to patient ratio, and complexity of cases
b.) Special skills/training of staff
c.) Contingency plan for acute shortage
d.) Duty roster
e.) Evidence that all clinicians are not made to work more than the stipulated hours'),
('23m','23m.2','23m.2.9','2','Number of support staff match the number of practitioners
a.) A ratio of 1 operator: 1 clinical support staff
b.) A ratio of 1 clinical support staff: 1 dental chair'),
('23m','23m.2','23m.2.10','1','Evidence of policy stating that all staff have to attend a structured orientation programme.'),
('23m','23m.2','23m.2.10','2','Attendance list of those having attended the orientation programme.'),
('23m','23m.2','23m.2.10','3','Clinical staff are vaccinated against hepatitis B.'),
('23m','23m.3','23m.3.1','1','Evidence of documented policies and procedures for the service.'),
('23m','23m.3','23m.3.1','2','The policies and procedures are endorsed and dated.'),
('23m','23m.3','23m.3.1','3','There is a periodic review at least once in three years.'),
('23m','23m.3','23m.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference.'),
('23m','23m.3','23m.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('23m','23m.3','23m.3.3','1','Documented policies and procedures that address (a) to (s).'),
('23m','23m.3','23m.3.3','2','Staff are briefed on the policies and procedures (meeting minutes or circulation acknowledgement).'),
('23m','23m.3','23m.3.4','1','Operating hours outside the clinic is well displayed.'),
('23m','23m.3','23m.3.4','2','Operational policy on 24-hour service is available.'),
('23m','23m.3','23m.3.4','3','On call roster is dated and authorised.'),
('23m','23m.3','23m.3.4','4','Staffing level reflects a good mix of senior and junior staff.'),
('23m','23m.3','23m.3.4','5','List of available services is displayed in the clinic.'),
('23m','23m.3','23m.3.5','1','Relevant updated Standard Treatment Guidelines are available in the division.'),
('23m','23m.3','23m.3.5','2','Patient register is updated daily.'),
('23m','23m.3','23m.3.5','3','Evidence of appropriate admission process.'),
('23m','23m.3','23m.3.5','4','Evidence of in-patient and guardian orientation process during admission.'),
('23m','23m.3','23m.3.5','5','Evidence of initial assessment and provisional diagnosis.'),
('23m','23m.3','23m.3.5','6','Evidence and documentation of morning and evening rounds.'),
('23m','23m.3','23m.3.5','7','Evidence of regular vital sign documentation'),
('23m','23m.3','23m.3.5','8','Documentation of discussions with patient/family/guardian about the patient’s condition.'),
('23m','23m.3','23m.3.5','9','Evidence of discussions with other disciplines and referrals if necessary.'),
('23m','23m.3','23m.3.5','10','Evidence of patient handover during shift change (documentation and observed).'),
('23m','23m.3','23m.3.5','11','Evidence of documented informed consent for procedures.'),
('23m','23m.3','23m.3.5','12','Evidence of flowchart on patient deterioration or “Code Blue” procedures.'),
('23m','23m.3','23m.3.5','13','Discharge summaries are issued to patients on discharge with a care plan.'),
('23m','23m.3','23m.3.5','14','Evidence of a patient referral register.'),
('23m','23m.3','23m.3.6','1','Patient’s medical record has elements (a) to (m).'),
('23m','23m.3','23m.3.6','2','The Patient’s medical record has a unique identifier (MRN).'),
('23m','23m.3','23m.3.6','3','Evidence of clinical documentation which is signed, dated and with legible writing.'),
('23m','23m.3','23m.3.6','4','Evidence of use of appropriate abbreviations.'),
('23m','23m.4','23m.4.1','1','The building is sound and there is adequate space to match the services.'),
('23m','23m.4','23m.4.1','2','Appropriate type of equipment to match the complexity of services.'),
('23m','23m.4','23m.4.1','3','Easy access and clear (unblocked) exit routes.'),
('23m','23m.4','23m.4.1','4','Absence of overcrowding.'),
('23m','23m.4','23m.4.1','5','Availability of an isolation area.'),
('23m','23m.4','23m.4.1','6','There are lights/lamps/solar for blackouts.'),
('23m','23m.4','23m.4.1','7','There is good ventilation within the clinic.'),
('23m','23m.4','23m.4.1','8','There is running water in the facility.'),
('23m','23m.4','23m.4.1','9','Waste is segregated at the facility at the point of generation.'),
('23m','23m.4','23m.4.2','1','Design and layout of the unit, e.g. wards, treatment rooms, dirty and clean utility rooms, access, lighting, signage, etc address the safety aspects of patients and staff.'),
('23m','23m.4','23m.4.2','2','Equipment should have scheduled planned preventive maintenance (PPM).'),
('23m','23m.4','23m.4.2','3','There is access to hand washing facilities.'),
('23m','23m.4','23m.4.2','4','Sharps are disposed properly.'),
('23m','23m.4','23m.4.2','5','There is appropriate handling of amalgam (where applicable).'),
('23m','23m.4','23m.4.2','6','A closed non-fragile container is used for the storage of waste amalgam.'),
('23m','23m.4','23m.4.2','7','Waste amalgam is stored dry.'),
('23m','23m.4','23m.4.2','8','If x-rays are used, warning sign/light is evident during the procedure.'),
('23m','23m.4','23m.4.2','9','Protective equipment (lead apron with thyroid shield for conventional radiography) is used and in good condition.'),
('23m','23m.4','23m.4.2','10','Precautionary signage for antenatal mothers is displayed.'),
('23m','23m.4','23m.4.2','11','If a dental laboratory is available;
• Machines used for polishing prosthesis should have a vacuum system and safety projector
• There are material and equipment for disinfection
• A fume cupboard is available where acrylic work is carried out'),
('23m','23m.4','23m.4.3','1','Appropriate telecommunication modalities available for daily operation and during emergencies.'),
('23m','23m.4','23m.4.4','1','There is a list of conditions defined as “Urgent” based on the services offered.'),
('23m','23m.4','23m.4.4','2','Front office staff are able to identify “Urgent/priority” cases.'),
('23m','23m.4','23m.4.5','1','Flow chart on work process.'),
('23m','23m.4','23m.4.5','2','Clinic appointment system.'),
('23m','23m.4','23m.4.5','3','Security of data in Health Information System.'),
('23m','23m.4','23m.4.5','4','Monitoring of waiting time.'),
('23m','23m.4','23m.4.5','5','Adequate and appropriate signage.'),
('23m','23m.4','23m.4.5','6','Floor plan indicates accessibility to supporting services and optimisation of space.'),
('23m','23m.4','23m.4.5','7','Adequate patient personal use items, e.g. wheelchair, mobility aids etc.'),
('23m','23m.4','23m.4.5','8','Adequate waiting area, toilets and reading material.'),
('23m','23m.4','23m.4.6','1','There is evidence of appropriate assessment and reassessment.'),
('23m','23m.4','23m.4.6','2','Each patient has an individual dental record containing relevant information.'),
('23m','23m.4','23m.4.6','3','There is efficient record keeping.'),
('23m','23m.4','23m.4.6','4','An initial patient record should have medical history, full dental charting, risk habits (buai, i.e., betel nuit, tobacco use), periodontal status, soft tissue examination, appliances use.'),
('23m','23m.4','23m.4.6','5','There is a daily record of patients attending the clinic.'),
('23m','23m.4','23m.4.7','1','Floor plan indicates facility accessibility and is patient and user friendly.'),
('23m','23m.4','23m.4.7','2','Feedback from patient satisfaction surveys on the facilities.'),
('23m','23m.4','23m.4.7','3','Incident reporting relating to facilities if any.'),
('23m','23m.4','23m.4.7','4','Toilets have wheelchair access.'),
('23m','23m.4','23m.4.8','1','Availability of emergency and non-emergency equipment appropriate to level of care, such as defibrillator, emergency trolley, suction machine, electrocardiogram (ECG) machine, infusion or syringe pump, vital sign monitor, pulse oximeter, oxygen concentrator etc.'),
('23m','23m.4','23m.4.8','2','Scheduled checking of items in emergency trolley.'),
('23m','23m.4','23m.4.8','3','There are adequate patient transfer trolleys, wheelchairs, mobility aids and a dedicated drug fridge.'),
('23m','23m.4','23m.4.8','4','There is a dedicated cabinet for dangerous drugs which can be locked.'),
('23m','23m.4','23m.4.9','1','Planned Preventive Maintenance records such as schedule, stickers, etc.'),
('23m','23m.4','23m.4.9','2','Planned Replacement Programme where applicable.'),
('23m','23m.4','23m.4.9','3','Complaint records.'),
('23m','23m.4','23m.4.9','4','Asset inventory'),
('23m','23m.4','23m.4.10','1','User training records.'),
('23m','23m.4','23m.4.10','2','List of staff trained and authorised to operate specialised equipment.'),
('23m','23m.4','23m.4.11','1','Evidence of facilities with patient privacy ensured.'),
('23m','23m.4','23m.4.11','2','Procedure room appropriately equipped.'),
('23m','23m.4','23m.4.11','3','Patient monitoring device is available where required (vital signs).'),
('23m','23m.4','23m.4.11','4','List of procedures performed.'),
('23m','23m.5','23m.5.1','1','There is a designated person who monitors safety and performance improvement activities within the Dental Services.'),
('23m','23m.5','23m.5.1','2','There are records/registers on performance improvement activities.'),
('23m','23m.5','23m.5.1','3','There are meeting minutes for performance improvement meetings.'),
('23m','23m.5','23m.5.1','4','There are records on innovation (if any).'),
('23m','23m.5','23m.5.2','1','System for incident reporting is in place with the following;
a.) Training of staff in incident reporting
b.) Policy on incident reporting
c.) Method/SOP on Incident reporting
d.) Register of incidents'),
('23m','23m.5','23m.5.2','2','Completed incident reports.'),
('23m','23m.5','23m.5.2','3','Corrective and preventive action plans.'),
('23m','23m.5','23m.5.2','4','Minutes of meeting.'),
('23m','23m.5','23m.5.2','5','Involved staff given feedback about the incident report.'),
('23m','23m.5','23m.5.2','6','Acknowledgment by Head of Dental Service and Director of Curative Services.'),
('23m','23m.5','23m.5.3','1','Specific performance indicators are monitored.'),
('23m','23m.5','23m.5.3','2','Remedial action is taken when appropriate.'),
('23n','23n.1','23n.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('23n','23n.1','23n.1.1','2','There is an endorsed and dated department organisational chart with lines of functions and reporting relationships.'),
('23n','23n.1','23n.1.1','3','Relevant policies and guidelines are available in the department, i.e., National Health Plan, National Health Service Standards, etc.)'),
('23n','23n.1','23n.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('23n','23n.1','23n.1.1','5','Evidence of fee structure (if fees are collected).'),
('23n','23n.1','23n.1.2','1','Letter of appointment and terms of reference as the Head of Service.'),
('23n','23n.1','23n.1.2','2','Letter of appointment and terms of reference as a member of the Clinical Governance Advisory Committee.'),
('23n','23n.1','23n.1.2','3','Letter of appointment and terms of reference in other hospital committees.'),
('23n','23n.1','23n.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff.'),
('23n','23n.1','23n.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service.'),
('23n','23n.1','23n.1.3','3','Frequency of meetings are as scheduled.'),
('23n','23n.1','23n.1.3','4','Discussions and resolutions are implemented. (problems not solved are brought forward to the next meeting till resolved).'),
('23n','23n.1','23n.1.4','1','The statistics and records  from (a) to (f) are available.'),
('23n','23n.2','23n.2.1','1','There are dated and specific job descriptions for each staff that include (a) to (f).'),
('23n','23n.2','23n.2.1','2','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('23n','23n.2','23n.2.1','3','The scope of work in the job description aligns with the training, skill and experience of the staff (credentialling).'),
('23n','23n.2','23n.2.2','1','Evidence of current registration for all cadres of staff (annual practicing certificate).'),
('23n','23n.2','23n.2.3','1','Observation that cadres of staff are working according to their job description and job scope.'),
('23n','23n.2','23n.2.3','2','Only clinical and radiation oncologists can prescribe radiation therapy.'),
('23n','23n.2','23n.2.3','3','Only clinical and medical oncologists can prescribe radiation therapy'),
('23n','23n.2','23n.2.4','1','Training calendar includes in-house/ external courses/ workshops/ conferences.'),
('23n','23n.2','23n.2.4','2','Training for each staff including training in life support is kept in the Department.'),
('23n','23n.2','23n.2.4','3','There are ongoing Continuous Professional Activities in the Department.'),
('23n','23n.2','23n.2.5','1','Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.'),
('23n','23n.2','23n.2.6','1','Evidence of sufficient skilled trained staff to provide clinical supervision as per terms of Memorandum of Understanding.'),
('23n','23n.2','23n.2.6','2','There is Memorandum of Understanding with the relevant training institutions.'),
('23n','23n.2','23n.2.7','1','Performance appraisal for staff including Oncology practitioners is completed upon probationary period and as an annual exercise.'),
('23n','23n.2','23n.2.8','1','Documented evidence of research activities in the Department.'),
('23n','23n.2','23n.2.9','1','Planning of staff allocation and movement within the Department includes the following;
a. Staff allocation in the Oncology Services is based on staff to patient ratio, bed occupancy rate and complexity of cases.
b. There are staff with postgraduate Oncology skills in each shift.
c. Contingency plan for acute shortage
d. Duty roster'),
('23n','23n.2','23n.2.10','1','Evidence of policy stating that all staff have to attend a structured orientation programme.'),
('23n','23n.2','23n.2.10','2','Attendance list of those having attended the orientation programme.'),
('23n','23n.3','23n.3.1','1','Evidence of documented policies and procedures for the service.'),
('23n','23n.3','23n.3.1','2','The policies and procedures are endorsed and dated.'),
('23n','23n.3','23n.3.1','3','There is a periodic review at least once in three years.'),
('23n','23n.3','23n.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference.'),
('23n','23n.3','23n.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('23n','23n.3','23n.3.3','1','Documented policies and procedures that address (a) to (t).'),
('23n','23n.3','23n.3.3','2','Staff are briefed on the policies and procedures (meeting/briefing minutes or circulation acknowledgement).'),
('23n','23n.3','23n.3.4','1','There is an operational policy on 24-hour service.'),
('23n','23n.3','23n.3.4','2','Staffing level reflects a good mix of senior and junior staff.'),
('23n','23n.3','23n.3.4','3','On call roster is dated and authorised.'),
('23n','23n.3','23n.3.5','1','Relevant Standard Treatment Guidelines are available in the division'),
('23n','23n.3','23n.3.5','2','Patient register is updated daily.'),
('23n','23n.3','23n.3.5','3','Evidence of appropriate admission process.'),
('23n','23n.3','23n.3.5','4','Evidence of in-patient and guardian orientation process during admission.'),
('23n','23n.3','23n.3.5','5','Evidence of initial assessment and provisional diagnosis.'),
('23n','23n.3','23n.3.5','6','Evidence and documentation of morning and evening rounds.'),
('23n','23n.3','23n.3.5','7','Evidence of regular vital sign documentation'),
('23n','23n.3','23n.3.5','8','Documentation of discussions with patient/family/guardian about the patient’s condition.'),
('23n','23n.3','23n.3.5','9','Evidence of discussions with other disciplines and referrals if necessary.'),
('23n','23n.3','23n.3.5','10','Evidence of patient handover during shift change (documentation and observed).'),
('23n','23n.3','23n.3.5','11','Evidence of documented informed consent for procedures.'),
('23n','23n.3','23n.3.5','12','Evidence of flowchart on patient deterioration or “Code Blue” procedures.'),
('23n','23n.3','23n.3.5','13','Discharge summaries are issued to patients on discharge with a care plan.'),
('23n','23n.3','23n.3.6','1','Observation onsite that the patient’s Oncology record has elements (a) to (m).'),
('23n','23n.3','23n.3.6','2','The patient’s Oncology record has a unique identifier (MRN).'),
('23n','23n.3','23n.3.6','3','Evidence of clinical documentation which is signed, dated and with legible writing.'),
('23n','23n.3','23n.3.6','4','Evidence of use of appropriate abbreviations.'),
('23n','23n.4','23n.4.1','1','Observation that the building is sound and there is adequate space to match the services.'),
('23n','23n.4','23n.4.1','2','There is appropriate equipment to match the complexity of services.'),
('23n','23n.4','23n.4.1','3','There are adequate facilities and equipment at each patient care area for safe care (e.g. defibrillators, emergency trolley, hand washing facilities etc.).'),
('23n','23n.4','23n.4.1','4','Access to the Oncology ward and clear (unblocked) exit routes.'),
('23n','23n.4','23n.4.1','5','Absence of overcrowding.'),
('23n','23n.4','23n.4.1','6','Availability of an isolation area.'),
('23n','23n.4','23n.4.1','7','There are lights/lamps/solar for blackouts.'),
('23n','23n.4','23n.4.1','8','There is good ventilation within the ward/s.'),
('23n','23n.4','23n.4.1','9','There is running water in the facility.'),
('23n','23n.4','23n.4.1','10','Waste is segregated at the facility at the point of generation.'),
('23n','23n.4','23n.4.2','1','Design and layout of the unit is appropriate e.g. wards, treatment rooms, dirty and clean utility rooms, access, lighting, signage, etc., address the safety aspects of patients and staff.'),
('23n','23n.4','23n.4.2','2','Equipment should have scheduled planned preventive maintenance (PPM).'),
('23n','23n.4','23n.4.2','3','There is access to hand washing facilities.'),
('23n','23n.4','23n.4.2','4','Mattresses are covered with waterproof coverings and there is clean linen on every bed.'),
('23n','23n.4','23n.4.2','5','Sharps are disposed properly.'),
('23n','23n.4','23n.4.2','6','There is a Biological Safety Cabinet for preparation of chemotherapy drugs.'),
('23n','23n.4','23n.4.2','7','There are sterile, disposable equipment for all cancer-chemotherapy drugs, luer-lock devices etc.'),
('23n','23n.4','23n.4.3','1','Appropriate telecommunication modalities are available for daily operation and during emergencies.'),
('23n','23n.4','23n.4.4','1','There is up-to-date documentation of the total number of beds (overnight and day-only beds)'),
('23n','23n.4','23n.4.4','2','There is evidence that any patient who occupies a bed for more than 4 hours and receives significant clinical care is classified as an “in-patient”.'),
('23n','23n.4','23n.4.4','3','Factors such as “bed occupancy rates” and “average length of stay” are monitored and analysed.'),
('23n','23n.4','23n.4.5','1','Floor plan indicates facility accessibility and is patient and user friendly.'),
('23n','23n.4','23n.4.5','2','Feedback from patient satisfaction surveys on the facilities.'),
('23n','23n.4','23n.4.5','3','Incident reporting relating to facilities if any.'),
('23n','23n.4','23n.4.5','4','Toilets have wheelchair access.'),
('23n','23n.4','23n.4.6','1','Availability of emergency and non-emergency equipment appropriate to level of care, such as defibrillator, emergency trolley, suction machine, electrocardiogram (ECG) machine, infusion or syringe pump, vital sign monitor, pulse oximeter, oxygen concentrator etc.'),
('23n','23n.4','23n.4.6','2','Scheduled checking of items in emergency trolley (preferably once every shift).'),
('23n','23n.4','23n.4.6','3','There are adequate patient transfer trolleys, wheelchairs, mobility aids and a dedicated drug fridge.'),
('23n','23n.4','23n.4.6','4','There is a dedicated cabinet for dangerous drugs which can be locked.'),
('23n','23n.4','23n.4.7','1','Planned Preventive Maintenance records such as schedule, stickers, etc.'),
('23n','23n.4','23n.4.7','2','Planned Replacement Programme where applicable.'),
('23n','23n.4','23n.4.7','3','Complaint records.'),
('23n','23n.4','23n.4.7','4','Asset inventory.'),
('23n','23n.4','23n.4.8','1','User training records.'),
('23n','23n.4','23n.4.8','2','List of staff trained and authorised to operate specialised equipment.'),
('23n','23n.4','23n.4.9','1','Evidence of list of services available and offered to patients.'),
('23n','23n.4','23n.4.9','2','Flow chart on work process'),
('23n','23n.4','23n.4.9','3','Safe keeping of Oncology records'),
('23n','23n.4','23n.4.9','4','Clinic appointment system'),
('23n','23n.4','23n.4.9','5','Security of data in Health Information System'),
('23n','23n.4','23n.4.9','6','Monitoring of waiting time'),
('23n','23n.4','23n.4.9','7','Adequate and appropriate signage'),
('23n','23n.4','23n.4.9','8','Floor plan indicates accessibility to supporting services and optimisation of space'),
('23n','23n.4','23n.4.9','9','Adequate patient personal use items, e.g. wheelchair, mobility aids etc.'),
('23n','23n.4','23n.4.9','10','Adequate waiting area, toilets, reading material and parking space.'),
('23n','23n.4','23n.4.10','1','Evidence of facilities with patient privacy ensured.'),
('23n','23n.4','23n.4.10','2','Procedure room appropriately equipped.'),
('23n','23n.4','23n.4.10','3','Patient monitoring device is available where required (vital signs).'),
('23n','23n.4','23n.4.10','4','List of procedures performed.'),
('23n','23n.5','23n.5.1','1','There is a designated person who monitors safety and performance improvement activities within the Dental Services.'),
('23n','23n.5','23n.5.1','2','There are records/registers on performance improvement activities.'),
('23n','23n.5','23n.5.1','3','There are meeting minutes for performance improvement meetings.'),
('23n','23n.5','23n.5.1','4','There are records on innovation (if any).'),
('23n','23n.5','23n.5.2','1','System for incident reporting is in place with the following;
a. Training of staff in incident reporting
b. Policy on incident reporting
c. Method/SOP on Incident reporting
d. Register of incidents'),
('23n','23n.5','23n.5.2','2','Completed incident reports'),
('23n','23n.5','23n.5.2','3','Corrective and preventive action plans'),
('23n','23n.5','23n.5.2','4','Minutes of meeting'),
('23n','23n.5','23n.5.2','5','Involved staff given feedback about the incident report'),
('23n','23n.5','23n.5.2','6','Acknowledgment by Head of Oncology Service and Director of Curative Services.'),
('23n','23n.5','23n.5.3','1','Specific performance indicators are monitored.'),
('23n','23n.5','23n.5.3','2','Remedial action is taken when appropriate'),
('23p','23p.1','23p.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('23p','23p.1','23p.1.1','2','There is an endorsed and dated department organisational chart with lines of functions and reporting relationships (including with off-site hospital facilities being serviced).'),
('23p','23p.1','23p.1.1','3','Relevant policies and guidelines are available in the department, i.e., National Health Plan, National Health Service Standards, etc.).'),
('23p','23p.1','23p.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('23p','23p.1','23p.1.1','5','Evidence of fee structure (if fees are collected).'),
('23p','23p.1','23p.1.2','1','Letter of appointment and terms of reference as the Head of Service'),
('23p','23p.1','23p.1.2','2','Letter of appointment and terms of reference in other hospital committees.'),
('23p','23p.1','23p.1.2','3','Evidence of (a) to (d) in meeting minutes/corespondence of the Pathology Services indicating the involvement of the Head of Service.'),
('23p','23p.1','23p.1.2','4','Request for allocation for budget and staffing.'),
('23p','23p.1','23p.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff.'),
('23p','23p.1','23p.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service.'),
('23p','23p.1','23p.1.3','3','Frequency of meetings are as scheduled.'),
('23p','23p.1','23p.1.3','4','Discussions and resolutions are implemented. (problems not solved are brought forward to the next meeting till resolved).'),
('23p','23p.1','23p.1.4','1','The statistics and records  from (a) to (h) are available.'),
('23p','23p.1','23p.1.4','2','The NHSS Toolkit Assessment (checklist) for the relevant level has been completed in the past 6 months.'),
('23p','23p.1','23p.1.5','1','There is a written agreement with the external laboratory.'),
('23p','23p.1','23p.1.5','2','The type and nature of tests and investigation that are available is specified.'),
('23p','23p.1','23p.1.5','3','Requests for tests/investigations should be documented in a register.'),
('23p','23p.1','23p.1.5','4','There is a safe mode of transport of specimens.'),
('23p','23p.1','23p.1.5','5','There is provision for immediate communication of results which are “out of the normal” range.'),
('23p','23p.1','23p.1.5','6','There are arrangements for after-hours and emergency work.'),
('23p','23p.1','23p.1.5','7','There are quality systems in place  e.g. the lab participants in External Quality Assurance (EQA) activities.'),
('23p','23p.2','23p.2.1','1','There are dated and specific job descriptions for each staff that include (a) to (f).'),
('23p','23p.2','23p.2.1','2','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('23p','23p.2','23p.2.1','3','The scope of work in the job description aligns with the training, skill and experience of the staff (credentialling).'),
('23p','23p.2','23p.2.2','1','Evidence of current registration for all cadres of staff (annual practicing certificate).'),
('23p','23p.2','23p.2.3','1','Observation that cadres of staff are working according to their job description and job scope.'),
('23p','23p.2','23p.2.4','1','Training calendar includes in-house/ external courses/ workshops/ conferences.'),
('23p','23p.2','23p.2.4','2','Training for each staff including training in life support is kept in the Department.'),
('23p','23p.2','23p.2.4','3','There are ongoing Continuous Professional Activities in the Department.'),
('23p','23p.2','23p.2.5','1','Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.'),
('23p','23p.2','23p.2.6','1','Evidence of sufficient skilled trained staff to provide supervision as per terms of Memorandum of Understanding.'),
('23p','23p.2','23p.2.6','2','There is a Memorandum of Understanding with the relevant institution/entity.'),
('23p','23p.2','23p.2.7','1','Performance appraisal for staff including medical practitioners is completed upon probationary period and as an annual exercise.'),
('23p','23p.2','23p.2.8','1','Documented evidence of research activities in the Department.'),
('23p','23p.2','23p.2.9','1','Continuing medical education for non-laboratory health professional staff.'),
('23p','23p.2','23p.2.9','2','Records on attendance.'),
('23p','23p.2','23p.2.10','1','Evidence of policy stating that all staff have to attend a structured orientation programme.'),
('23p','23p.2','23p.2.10','2','Attendance list of those having attended the orientation programme.'),
('23p','23p.3','23p.3.1','1','Evidence of documented policies and procedures  (a) to (i) for the service.'),
('23p','23p.3','23p.3.1','2','The policies and procedures are endorsed and dated.'),
('23p','23p.3','23p.3.1','3','There is a periodic review at least once in three years.'),
('23p','23p.3','23p.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference.'),
('23p','23p.3','23p.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('23p','23p.3','23p.3.3','1','Training or briefing on the policies (meeting minutes or circulation acknowledgement).'),
('23p','23p.3','23p.3.4','1','Verify observation on practices on-site.'),
('23p','23p.3','23p.3.4','2','Interview staff on procedures.'),
('23p','23p.3','23p.3.4','3','Review audits on practices (if there are any).'),
('23p','23p.3','23p.3.5','1','Documented policies and procedures relating to laboratory tests including (a) to (h).'),
('23p','23p.3','23p.3.6','1','There is laboratory user guide available.'),
('23p','23p.3','23p.3.6','2','There is proof that the user guide has been sighted by laboratory services staff.'),
('23p','23p.3','23p.3.6','3','Observe and verify practice during survey.'),
('23p','23p.3','23p.3.6','4','Policy is available on how long reports and specimens should be retained.'),
('23p','23p.3','23p.3.7','1','Evidence of reports in patient’s records (observed).'),
('23p','23p.3','23p.3.7','2','Evidence that critical results were informed (documentation).'),
('23p','23p.3','23p.3.7','3','Evidence of documentation of reports received by phone in the patient’s medical records.'),
('23p','23p.3','23p.3.8','1','Evidence of communication with the respective surgeon.'),
('23p','23p.3','23p.3.8','2','Copy of result is observed in the patient’s record.'),
('23p','23p.3','23p.3.9','1','Documented safety procedures specific to the Pathology Services.'),
('23p','23p.3','23p.3.9','2','Record of training/briefing of staff on these safety guidelines.'),
('23p','23p.4','23p.4.1','1','On-site observation that the office space complies with the above.'),
('23p','23p.4','23p.4.1','2','Layout of the laboratory complies with the set requirements.'),
('23p','23p.4','23p.4.2','1','Designated areas include;
a.) Reception to receive samples
b.) Separation
c.) Storage area
d.) Dispatch area'),
('23p','23p.4','23p.4.3','1','On-site observation on;
a.) Adequately-spaced work-benches
b.) Equipment arrangement ensures safety and efficiency of the laboratory’s operation.'),
('23p','23p.4','23p.4.4','1','Onsite observation on;
a.) Adequate storage areas
b.) Designated areas for reagents, tissue specimens, consumables, and other materials.'),
('23p','23p.4','23p.4.5','1','Onsite observation on separate storage for inflammables and acids according to guidelines.'),
('23p','23p.4','23p.4.6','1','Observation onsite on the availability of;
a.) Emergency shower
b.) Eye wash
c.) Locker facilities
d.) Storage for protective clothing'),
('23p','23p.4','23p.4.7','1','On-site observation of adequate ventilation with fume extraction.'),
('23p','23p.4','23p.4.7','2','Adequate power supply and suitable location of power sockets.'),
('23p','23p.4','23p.4.7','3','Adequate lighting.'),
('23p','23p.4','23p.4.7','4','Supply of gases follow safety regulations.'),
('23p','23p.4','23p.4.7','5','Adequate supply of de-ionised and distilled water for laboratory use'),
('23p','23p.4','23p.4.8','1','On-site observation of adequate equipment suitable to the service.'),
('23p','23p.4','23p.4.8','2','There is proper equipment maintenance (see maintenance record)'),
('23p','23p.4','23p.4.8','3','Availability of a back-up system'),
('23p','23p.4','23p.4.8','4','There is a dedicated cabinet for dangerous drugs which can be locked.'),
('23p','23p.4','23p.4.9','1','User training records.'),
('23p','23p.4','23p.4.9','2','List of staff trained and authorised to operate specialised equipment.'),
('23p','23p.4','23p.4.10','1','On site observation of record ot equipment inventory.'),
('23p','23p.4','23p.4.10','2','On site observation of record of reagent inventory.'),
('23p','23p.4','23p.4.10','3','Onsite observation of record of consumable inventory'),
('23p','23p.4','23p.4.11','1','Observe the equipment/instrument log book.'),
('23p','23p.4','23p.4.11','2','Equipment/instrument maintenance record.'),
('23p','23p.4','23p.4.12','1','There is observed preventive maintenance schedule.'),
('23p','23p.4','23p.4.12','2','There is an asset inventory.'),
('23p','23p.4','23p.4.12','3','There is a complaint records on equipment made.'),
('23p','23p.4','23p.4.13','1','There is a cleaning schedule.'),
('23p','23p.4','23p.4.13','2','Good housekeeping is evidenced.'),
('23p','23p.4','23p.4.13','3','There is proper disposal of biohazardous material.'),
('23p','23p.5','23p.5.1','1','There is a designated person who monitors safety and performance improvement activities within the Dental Services.'),
('23p','23p.5','23p.5.1','2','There are records/registers on performance improvement activities.'),
('23p','23p.5','23p.5.1','3','There are meeting minutes for performance improvement meetings.'),
('23p','23p.5','23p.5.1','4','There are records on innovation (if any).'),
('23p','23p.5','23p.5.2','1','System for incident reporting is in place with the following;
a.) Training of staff in incident reporting
b.) Policy on incident reporting
c.) Method/SOP on Incident reporting
d.) Register of incidents'),
('23p','23p.5','23p.5.2','2','Completed incident reports.'),
('23p','23p.5','23p.5.2','3','Corrective and preventive action plans.'),
('23p','23p.5','23p.5.2','4','Minutes of meeting.'),
('23p','23p.5','23p.5.2','5','Involved staff given feedback about the incident report.'),
('23p','23p.5','23p.5.2','6','Acknowledgment by Head of Pathology Service and Director of Curative Services.'),
('23p','23p.5','23p.5.3','1','Specific performance indicators are monitored.'),
('23p','23p.5','23p.5.3','2','Remedial action is taken when appropriate.'),
('23p','23p.5','23p.5.4','1','There is an Internal Quality Control (ICQ) Programme'),
('23p','23p.5','23p.5.4','2','There is an External Quality Control (ECQ) Programme'),
('23q','23q.1','23q.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('23q','23q.1','23q.1.1','2','There is an endorsed and dated department organisational chart with lines of functions and reporting relationships.'),
('23q','23q.1','23q.1.1','3','Relevant policies and guidelines are available in the department, i.e., National Health Plan, National Health Service Standards, etc.)'),
('23q','23q.1','23q.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('23q','23q.1','23q.1.1','5','Evidence of fee structure (if fees are collected).'),
('23q','23q.1','23q.1.2','1','Letter of appointment and terms of reference as the Officer in Charge'),
('23q','23q.1','23q.1.2','2','Letter of appointment and terms of reference in other hospital committees.'),
('23q','23q.1','23q.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff.'),
('23q','23q.1','23q.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service.'),
('23q','23q.1','23q.1.3','3','Frequency of meetings are as scheduled.'),
('23q','23q.1','23q.1.3','4','Discussions and resolutions are implemented. (problems not solved are brought forward to the next meeting till resolved).'),
('23q','23q.1','23q.1.4','1','The statistics and records from (a) to (f) are available.'),
('23q','23q.2','23q.2.1','1','Appointment letter.'),
('23q','23q.2','23q.2.1','2','Training records.'),
('23q','23q.2','23q.2.1','3','Certifications.'),
('23q','23q.2','23q.2.2','1','There are dated and specific job descriptions for each staff that include (a) to (d).'),
('23q','23q.2','23q.2.2','2','The job description is acknowledged by the staff and signed by the OIC and dated.'),
('23q','23q.2','23q.2.2','3','The scope of work in the job description aligns with the training, skill and experience of the staff (credentialling).'),
('23q','23q.2','23q.2.3','1','Evidence of current registration for all cadres of staff (annual practicing certificate).'),
('23q','23q.2','23q.2.4','1','Observation that cadres of staff are working according to their job description and job scope.'),
('23q','23q.2','23q.2.5','1','Training calendar includes in-house/ external courses/ workshops/ conferences.'),
('23q','23q.2','23q.2.5','2','There are ongoing Continuous Professional Activities in the Department.'),
('23q','23q.2','23q.2.6','1','Staff receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('23q','23q.2','23q.2.7','1','Performance appraisal for staff including medical practitioners is completed upon probationary period and as an annual exercise.'),
('23q','23q.2','23q.2.8','1','There is adequate number of staff based on the workload.'),
('23q','23q.2','23q.2.8','2','There is an on-call roster.'),
('23q','23q.2','23q.2.9','1','Evidence of policy stating that all staff have to attend a structured orientation programme.'),
('23q','23q.2','23q.2.9','2','Attendance list of those having attended the orientation programme.'),
('23q','23q.3','23q.3.1','1','Evidence of documented policies and procedures for the service.'),
('23q','23q.3','23q.3.1','2','The policies and procedures are endorsed and dated.'),
('23q','23q.3','23q.3.1','3','There is a periodic review at least once in three years.'),
('23q','23q.3','23q.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference.'),
('23q','23q.3','23q.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('23q','23q.3','23q.3.2','2','The policies and procedures are communicated to all Mortuary staff (Signed acknowledgement of having read the policy)'),
('23q','23q.3','23q.3.3','1','Documented policies and procedures that address (a) to (m).'),
('23q','23q.3','23q.3.3','2','Staff are briefed on the policies and procedures (meeting minutes or circulation acknowledgement).'),
('23q','23q.3','23q.3.3','3','There is evidence of compliance to the policies and procedures (staff interview, observation, review of patient complaints, results of audits).'),
('23q','23q.3','23q.3.4','1','There are Standard Operating Procedures /work instructions on how to handle specimens.'),
('23q','23q.3','23q.3.4','2','Specimen dispatch book.'),
('23q','23q.3','23q.3.4','3','Specimen handling form'),
('23q','23q.3','23q.3.5','1','Complete records and documentation of body management including (a) to (e).'),
('23q','23q.3','23q.3.6','1','Compliance to policies and procedures through interview(s) with staff, observations.'),
('23q','23q.3','23q.3.7','1','Standard Operating Procedures and manuals on safety procedures are available.'),
('23q','23q.3','23q.3.7','2','Verification on practices through observation.'),
('23q','23q.4','23q.4.1','1','Mortuary is accessible from an outside entrance to the Facility.'),
('23q','23q.4','23q.4.1','2','Conveyance of body to the Mortuary is via a designated route and entrance.'),
('23q','23q.4','23q.4.1','3','Proper covered body trolley and appropriate transport are available to transfer the body'),
('23q','23q.4','23q.4.2','1','There are designated areas for (a) to (e).'),
('23q','23q.4','23q.4.3','1','Appropriate areas for post- mortem which include (a) to (f).'),
('23q','23q.4','23q.4.4','1','Adequate lighting'),
('23q','23q.4','23q.4.4','2','Adequate power supply'),
('23q','23q.4','23q.4.4','3','Adequate water supply'),
('23q','23q.4','23q.4.4','4','Adequate effluent drainage.'),
('23q','23q.4','23q.4.5','1','Designated area for high-risk cases.'),
('23q','23q.4','23q.4.6','1','Designated area for;
a.) Body preparation
b.) Body viewing
c.) Bereavement
d.) Performing cultural rites
e.) Release of bodies'),
('23q','23q.4','23q.4.7','1','Staff facilities are available;
a.) Changing rooms
b.) Shower
c.) Locker facilities
d.) Storage area for personal protective equipment (PPE)'),
('23q','23q.4','23q.4.8','1','Documentation on death registration'),
('23q','23q.4','23q.4.8','2','Communication facilities'),
('23q','23q.4','23q.4.9','1','List of staff trained to use the specialised equipment.'),
('23q','23q.4','23q.4.10','1','Storage area for consumables and chemicals.'),
('23q','23q.4','23q.4.10','2','Inventory list for consumables and chemicals.'),
('23q','23q.4','23q.4.11','1','There is evidence of general cleanliness in the Mortuary services.'),
('23q','23q.4','23q.4.11','2','There is proper disposal of biohazardous material.'),
('23q','23q.5','23q.5.1','1','There is a designated person who monitors safety and performance improvement activities within the Medical Services.'),
('23q','23q.5','23q.5.1','2','There are records/registers on performance improvement activities.'),
('23q','23q.5','23q.5.1','3','There are meeting minutes for performance improvement meetings.'),
('23q','23q.5','23q.5.1','4','There are records on innovation (if any).'),
('23q','23q.5','23q.5.2','1','System for incident reporting is in place with the following;
a.) Training of staff in incident reporting
b.) Policy on incident reporting
c.) Method/SOP on Incident reporting
d.) Register of incidents'),
('23q','23q.5','23q.5.2','2','Completed incident reports'),
('23q','23q.5','23q.5.2','3','Corrective and preventive action plans'),
('23q','23q.5','23q.5.2','4','Minutes of meeting'),
('23q','23q.5','23q.5.2','5','Involved staff given feedback about the incident report'),
('23q','23q.5','23q.5.2','6','Acknowledgment by Head of Mortuary Service and Director of Curative Services.'),
('23q','23q.5','23q.5.3','1','Specific performance indicators are monitored.'),
('23q','23q.5','23q.5.3','2','Remedial action is taken when appropriate');
INSERT INTO standards ("standardNumber","standardTitle","standardSummary","functionId","componentId") SELECT standard_number,title,summary,4,6 FROM import_s;
INSERT INTO criteria ("criterionNumber","criterionTitle","standardId","isApplicable") SELECT x.number,x.title,s."standardId",true FROM import_c x JOIN standards s ON s."standardNumber"=x.standard_number;
INSERT INTO compliances ("complianceNumber","complianceSummary","criterionId","isApplicable") SELECT x.number,x.summary,c."criterionId",true FROM import_co x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number;
INSERT INTO evidence ("evidenceNumber","evidenceSummary","complianceId","isApplicable") SELECT x.number,x.summary,co."complianceId",true FROM import_e x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number JOIN compliances co ON co."criterionId"=c."criterionId" AND co."complianceNumber"=x.compliance_number;
DO $$ BEGIN
IF (SELECT count(*) FROM import_s x JOIN standards s ON s."standardNumber"=x.standard_number AND s."standardTitle"=x.title AND s."standardSummary"=x.summary AND s."functionId"=4 AND s."componentId"=6)<>4 THEN RAISE EXCEPTION 'Standard verification failed'; END IF;
IF (SELECT count(*) FROM import_c x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.number AND c."criterionTitle"=x.title AND c."isApplicable")<>20 THEN RAISE EXCEPTION 'Criterion verification failed'; END IF;
IF (SELECT count(*) FROM import_co x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number JOIN compliances co ON co."criterionId"=c."criterionId" AND co."complianceNumber"=x.number AND co."complianceSummary"=x.summary AND co."isApplicable")<>142 THEN RAISE EXCEPTION 'Compliance verification failed'; END IF;
IF (SELECT count(*) FROM import_e x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number JOIN compliances co ON co."criterionId"=c."criterionId" AND co."complianceNumber"=x.compliance_number JOIN evidence e ON e."complianceId"=co."complianceId" AND e."evidenceNumber"=x.number AND e."evidenceSummary"=x.summary AND e."isApplicable")<>425 THEN RAISE EXCEPTION 'Evidence verification failed'; END IF;
END $$;
COMMIT;
SELECT json_build_object('standardNumber',s."standardNumber",'standardId',s."standardId",'criteria',count(distinct c."criterionId"),'compliances',count(distinct co."complianceId"),'evidence',count(e."evidenceId"),'importedAt',CURRENT_TIMESTAMP) FROM standards s JOIN criteria c ON c."standardId"=s."standardId" JOIN compliances co ON co."criterionId"=c."criterionId" JOIN evidence e ON e."complianceId"=co."complianceId" WHERE s."standardNumber" IN ('23m','23n','23p','23q') GROUP BY s."standardId" ORDER BY s."standardNumber";