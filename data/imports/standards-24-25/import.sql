BEGIN;
SET LOCAL lock_timeout = '5s';
DO $$ BEGIN IF NOT EXISTS(SELECT 1 FROM functions WHERE "functionId"=4 AND "functionNumber"='4') OR NOT EXISTS(SELECT 1 FROM components WHERE "componentId"=6 AND "componentNumber"='6') THEN RAISE EXCEPTION 'Parent mapping changed'; END IF; IF EXISTS(SELECT 1 FROM standards WHERE lower("standardNumber") IN ('24','25')) THEN RAISE EXCEPTION 'Target standard already exists; review before importing'; END IF; END $$;
CREATE TEMP TABLE import_s (standard_number text NOT NULL, title text NOT NULL, summary text NOT NULL) ON COMMIT DROP;
INSERT INTO import_s VALUES
('24','Medication management','Standard 24: medication management
The Healthcare Organisation focuses on medication management systems to support the safe and effective use of medicines.

Source references
Standard 24 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standards
NHSS Toolkit Assessment for Level 5 and 6 Facilities in Papua New Guinea 2021-2030

Criterion guidance
24.1 Organisation and management
The Pharmacy Services shall be organised and administered to provide efficient pharmaceutical care services including the purchase, distribution, and control of pharmaceutical products; and to disseminate appropriate drug information to the healthcare team and patients of the Facility in accordance with prevailing standards of pharmacy practice.

24.2 Human resource and development
The Pharmacy Services shall be managed by a suitably qualified, experienced and registered pharmacist; and supported by other registered pharmacists, pharmacy assistants and other supporting staff to achieve the objectives of the services.

24.3 Policies and procedures
There are written and dated policies for all activities of the Pharmacy Services. These policies reflect current standards of pharmaceutical practice, relevant regulations and statutory requirements. These policies and procedures, terms of reference, by laws, rules and regulations state how the clinical staff regulate themselves and provide patient care.

24.4 Facilities and equipment
The Head of Pharmacy Services shall ensure adequate facilities and equipment are safe and appropriate are available for the staff to function effectively and to meet the goals and objectives of the Pharmacy Services.

24.5 Safety and performance improvement activities
The Head of Pharmacy Department shall ensure the provision of quality performance with staff involvement in the continuous safety and performance improvement activities of the Services.'),
('25','Surgical safety','Standard 25: surgical safety
The Healthcare Organisation will implement steps to ensure the safety of consumers / patients whilst undergoing surgical procedures and in post-operative care; any surgical intervention provided within a health facility is appropriate, is provided in the most appropriate setting and that it is effective in providing the expected, or desired outcomes. Surgical safety depends upon correct identification of the patient, correct identification of the procedure, correct identification of the site and correct documentation.

Source references
Standard 17 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standard
NHSS Toolkit Assessment for Level 5 and 6 Facilities in Papua New Guinea 2021-2030

Criterion guidance
25.1 Organisation and management
The Surgical Services shall be organised, directed and coordinated with other services in the facility to provide a standard of inpatient and outpatient care to the community in a safe, effective, efficient and caring manner. The Surgical services should be accessible, and continuity of care assured.

25.2 Human resource and development
The Surgical Services shall be directed by a qualified and competent Surgical practitioner, and staffed by suitably qualified and competent clinical staff to achieve the goals and objectives of the Surgical Services. There is sufficient staffing levels, a staff supervision structure, performance appraisals and ongoing commitment to continuing Surgical education.

25.3 Policies and procedures
There are written and dated policies for all activities of the Surgical Services. These policies reflect current standards of Surgical practice, relevant regulations and statutory requirements. These policies and procedures, terms of reference, by laws, rules and regulations state how the clinical staff regulate themselves and provide patient care.
There shall be a list of procedures requiring informed consent specific to Surgical. Possible risks and complications arising from procedures shall be documented either in specific consent forms or in patient''s records.

25.4 Facilities and equipment
The Head of Surgical Services shall ensure adequate facilities and equipment that are safe and appropriate are available for the staff to function effectively and to meet the goals and objectives of the Surgical Services.

25.5 Safety and performance improvement activities
The Head of Surgical Services shall ensure the provision of quality performance with staff involvement in the continuous safety and performance improvement activities of the Surgical Services.');
CREATE TEMP TABLE import_c (standard_number text NOT NULL, number text NOT NULL, title text NOT NULL) ON COMMIT DROP;
INSERT INTO import_c VALUES
('24','24.1','Organisation and management'),
('24','24.2','Human resource and development'),
('24','24.3','Policies and procedures'),
('24','24.4','Facilities and equipment'),
('24','24.5','Safety and performance improvement activities'),
('25','25.1','Organisation and management'),
('25','25.2','Human resource and development'),
('25','25.3','Policies and procedures'),
('25','25.4','Facilities and equipment'),
('25','25.5','Safety and performance improvement activities');
CREATE TEMP TABLE import_co (standard_number text NOT NULL, criterion_number text NOT NULL, number text NOT NULL, summary text NOT NULL) ON COMMIT DROP;
INSERT INTO import_co VALUES
('24','24.1','24.1.1','The Vision, Mission of the Facility are visible. The Goals of the Pharmacy Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.'),
('24','24.1','24.1.2','There is a mechanism to ensure effective interaction between the Head of the Services and the Organisation’s Governing Body and Senior Management.'),
('24','24.1','24.1.3','Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the Pharmacy Services. These meetings are minuted and communicated to all staff.'),
('24','24.1','24.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care.
The following (among others) are available:
a.) workload/census for inpatients and outpatients
b.) quarterly and annual report
c.) incident reports and register
d.) staffing number and staff profile
e.) staff training records
f.) data on performance improvement'),
('24','24.2','24.2.1','The are written and dated job descriptions for each category of staff that include:
a.) Qualification, training and experience for the position
b.) Lines of authority
c.) Accountability, functions and responsibilities
d.) Reviewed when required if there is major change in job scope
e.) Statutory regulations
f.) Administrative and clinical job scope'),
('24','24.2','24.2.2','The staff holds current registration with the relevant professional body (Pharmacy Board of PNG).'),
('24','24.2','24.2.3','The staff works within their job description and job scope.'),
('24','24.2','24.2.4','There is a structured orientation programme where new staff are briefed on their services, operational policies and relevant aspects of the Facility to prepare them for their roles and responsibilities.

The Orientation Programme should include:
a) Goals, objectives, policies and procedures of the Facility and those of Pharmacy Services including the National Competency Standards Framework for Pharmacists in PNG 2017
a.) Lines of authority and areas of responsibility
b.) Explanation of duties and functions
c.) Handover communication
d.) Information about safety procedures
e.) Methods of obtaining appropriate resource materials
f.) Staff appraisal procedures for the Pharmacy Services
g.) Education on Patient and Family Rights'),
('24','24.2','24.2.5','The Pharmacy staff are attired appropriately.'),
('24','24.2','24.2.6','There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice.'),
('24','24.2','24.2.7','The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.'),
('24','24.2','24.2.8','In a Facility where undergraduate or postgraduate Pharmacy training programmes are conducted, the Facility shall ensure there are sufficient skilled trained staff to provide clinical supervision of students.'),
('24','24.2','24.2.9','Pharmacy practitioners receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('24','24.2','24.2.10','Where appropriate the Facility shall endeavour to undertake clinical research using available resources.'),
('24','24.2','24.2.11','Staffing levels should be adequate with appropriate qualification and training.
a.) The number of persons deployed is proportional to the number of cases handled.
b.) There are different cadres of staff with appropriate qualification: pharmacists, pharmacy technicians, pharmacy technicians, storeman, cleaners.
c.) Staffing needs shall take into consideration absences due to leave or illness.
d.) Adequate staffing levels of appropriate competency shall be maintained throughout the hours the services are in operation.
e.) Where it is not possible to have service providers on duty on site, e.g. after working hours, provision is made for relevant Pharmacy practitioner to be available on call.
Planning of staff allocation and movement within the Department includes the following;'),
('24','24.3','24.3.1','There are written policies and procedures for the Pharmacy Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.'),
('24','24.3','24.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('24','24.3','24.3.3','The Pharmacy service has a Quality Management System (QMS).'),
('24','24.3','24.3.4','There are standard operating procedures on medicines and supplies control and record keeping.'),
('24','24.3','24.3.5','There are standard operating procedures on the dispensing of prescriptions.'),
('24','24.3','24.3.6','The pharmacy has SOPs for storage, distribution and disposal of medicines.'),
('24','24.3','24.3.7','The Pharmacy has good clinical governance systems in place.'),
('24','24.4','24.4.1','There are adequate and appropriate facilities and equipment with proper utilisation of space to enable staff to carry out their professional, teaching and administrative functions.'),
('24','24.4','24.4.2','Existing facilities shall consider the safety and comfort of staff and patients.'),
('24','24.4','24.4.3','Suitable forms of communication systems and equipment are provided to enable Pharmacy staff to communicate among themselves and with the other members of the healthcare team.'),
('24','24.4','24.4.4','There is adequate equipment in the Pharmacy Department.'),
('24','24.4','24.4.5','Facilities are suitably located to facilitate easy access and to provide an atmosphere of user, environmental and ‘disabled’ friendly.'),
('24','24.5','24.5.1','There are planned activities for performance and quality improvement.'),
('24','24.5','24.5.2','The Head of Pharmacy Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.'),
('24','24.5','24.5.3','Specific performance indicators are tracked. (e.g. percentage of prescription error, percentage of dispensing error, average time taken for prescription to be dispensed from time received at counter, number, value of expired drugs for a specific period).'),
('25','25.1','25.1.1','The Vision, Mission of the Facility are visible. The Goals of the Surgical Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.'),
('25','25.1','25.1.2','There is a mechanism to ensure effective interaction between the Head of the Services and the Organisation’s Governing Body and Senior Management. The Head of Services shall also be involved for the following aspects of
management of the services;
a.) Preparation of budget and ensuring that expenditure remains within the budget allocated
b.) Human resource
c.) Facility and equipment management
d.) Safety and performance improvement activities and risk management'),
('25','25.1','25.1.3','Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the Surgical Services. These meetings are minuted and communicated to all staff.'),
('25','25.1','25.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care. The following (among others) are available;
a.) workload/census for inpatients and outpatients
b.) quarterly and annual report
c.) incident reports and register
d.) staffing number and staff profile
e.) staff training records
f.) data on performance improvement
g.) number of referrals to the Surgical Service'),
('25','25.2','25.2.1','The are written and dated job descriptions for each category of staff that include:
a.) Qualification, training and experience for the position
b.) Lines of authority
c.) Accountability, functions and responsibilities
d.) Reviewed when required if there is major change in job scope
e.) Statutory regulations
f.) Administrative and clinical job scope'),
('25','25.2','25.2.2','The staff holds current registration with the relevant professional body.'),
('25','25.2','25.2.3','The staff works within their job description and job scope.'),
('25','25.2','25.2.4','There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice.'),
('25','25.2','25.2.5','The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.'),
('25','25.2','25.2.6','In a Facility where undergraduate or postgraduate Surgical, nursing and allied health training programmes are conducted, the Facility shall ensure there are sufficient skilled trained staff to provide clinical supervision of students.'),
('25','25.2','25.2.7','Staff including Surgical practitioners receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('25','25.2','25.2.8','Where appropriate the Facility shall endeavour to undertake clinical research using available resources.'),
('25','25.2','25.2.9','Staffing levels are based on the following;
a.) The number of persons deployed is proportional to the number of patients being cared for as per regulatory requirements and for the intensity of care provided
b.) The categories of service providers reflect the complexity of clinical problems being managed
c.) Staffing needs shall take into consideration absences due to leave or illness; double shift duties by clinical staff shall be documented and monitored
d.) Adequate staffing levels of appropriate competency shall be maintained throughout the hours the services are in operation.
e.) Where it is not possible to have service providers on duty on site, e.g. after working hours, provision is made for relevant Surgical practitioner to be available on call.'),
('25','25.2','25.2.10','There is a structured orientation programme for all newly appointed staff to the Surgical Services that include the following;
a.) Explanation of the goals, objectives, policies and procedures of the Facility and those of the Surgical Services
b.) Lines of authority and areas of responsibility
c.) Explanation of duties and functions
d.) Explanation of the methods of assigning clinical care and the standards of clinical practice
e.) Handover communication
f.) Processes for resolving practice/ethical dilemmas in a timely manner
g.) Information about safety procedures
h.) Training in basic/advanced life support techniques
i.) Methods of obtaining appropriate resource materials
j.) Staff appraisal procedures for the Surgical Services
k.) Education on Patient and Family Rights'),
('25','25.3','25.3.1','There are written policies and procedures for the Surgical Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.'),
('25','25.3','25.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('25','25.3','25.3.3','The policies and procedures documentation shall address at least the following topics;
a.) Description of the organisational structure of the Surgical Services
b.) The use of updated Standard Treatment Guidelines.
c.) Handover communication
d.) Drug prescription, dispensing and administration
e.) Blood transfusion
f.) Continuing of care including regular review of patient and review of investigation results
g.) Admission and Discharge (planned or “At Own Risk”)
h.) Referrals and Repatriations
i.) Guardians for patients
j.) Management of cases with an infectious disease including notification of notifiable diseases
k.) Internal (fire, etc) and External Disasters (earthquake etc.)
l.) Incident reports
m.) Management of deaths.
n.) Health information system and Surgical Records.
o.) Outreach and supervisory visits
p.) Infection Prevention and Control
q.) Management of acutely deteriorating patients.
r.) Management of high-risk patients (emergency, comatose, immunosuppressed, patient on life support or dialysis, patient with communicable disease, vulnerable patients, patient on chemotherapy)
s.) Patient feedback and complaint mechanism.
t.) Informed consent
u.) Pain management'),
('25','25.3','25.3.4','The service shall operate on a 24- hour basis providing level of care appropriate the facility.'),
('25','25.3','25.3.5','The service shall ensure that provision of patient care and services achieve effective outcomes and is safe.'),
('25','25.3','25.3.6','There is a standardised patient Surgical record.
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
('25','25.3','25.3.7','The facility adheres to approved guidelines to address correct patient identification, correct procedure and correct site prior to any clinical intervention.
This can be done through verification of patient information, matching information against documentation (health records, test results, and any other relevant materials), marking the correct site for intervention and taking time out for team verification.
Evidence that the patient and their guardian are involved in the patient identification and verification.'),
('25','25.3','25.3.8','The Facility ensures that written and verbal information is provided to patients and guardians about the procedure, the risks involved and the costs prior to taking consent. Informed consent should be taken in the appropriate format and language.'),
('25','25.3','25.3.9','The Surgical services ensures that standardised stepwise preparations are made for surgery which involve all members of the team as this can significantly reduce the risk of error.
The steps should include pre-induction, after induction and before the surgical incision, and immediately after wound closure before removing the patient from the operating room.'),
('25','25.3','25.3.10','There is an approved Standard Operating Procedures to address the management of instruments, accountable items and other items used for surgery or procedures. This includes;
• Soft goods such as sponges and towels
• Needles and other sharps
• Instruments
• Miscellaneous items, including un-retrieved device components or fragments (such as broken parts of instruments), stapler components, parts of laparoscopic trocars, guidewires, catheters, and pieces of drains
• “Sign off” processes are conducted at end of every procedure which requires;
• confirmation of the procedure
• completion of item counts
• completion and checking of specimen labelling
• any equipment problems'),
('25','25.4','25.4.1','There are adequate and appropriate facilities and equipment with proper utilisation of space to enable staff to carry out their professional, teaching and administrative functions.'),
('25','25.4','25.4.2','Existing facilities shall consider the safety and comfort of staff and patients.'),
('25','25.4','25.4.3','Suitable forms of communication systems and equipment are provided to enable clinical staff to communicate among themselves and with the other members of the healthcare team.'),
('25','25.4','25.4.4','There is optimal management of beds at the department with documentation of total number of beds and monitoring of bed occupancy rates.'),
('25','25.4','25.4.5','Facilities are suitably located to facilitate easy access and to provide an atmosphere of user, environmental and ‘disabled’ friendly.'),
('25','25.4','25.4.6','Equipment, both for emergency and non-emergency usage, shall be appropriate to the level of care.'),
('25','25.4','25.4.7','There is evidence that the facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order.'),
('25','25.4','25.4.8','Where specialised equipment is used, there is evidence that only staff who are trained and authorised by the Facility operate such equipment.'),
('25','25.4','25.4.9','The Specialist Outpatient Services shall have the following features;
a.) The organisation and management of the clinics are planned to ensure minimal waiting time, and avoidance of unnecessary visits by the patients.
b.) Record keeping shall be efficient.
c.) An appointment or queuing system is used to manage patient consultations.
d.) The clinic is easily accessible including for non-ambulant patients and is easily identified through adequate signage.
e.) The clinic is located close to other facilities, e.g. radiology, laboratories and pharmacy.
f.) Adequate provision is made for patient comfort.
g.) Call back system (especially for high- risk cases)
h.) Avenue for patients to access service between appointments.'),
('25','25.4','25.4.10','At the Outpatient Clinic, adequate numbers of rooms are provided to ensure patient privacy and confidentiality for various patient care activities including;
a.) Consultation (not more than one patient in a room at any time).
b.) Minor procedures and nursing procedures
c.) Performance of various tests'),
('25','25.4','25.4.11','Equipment is upgraded (based on evidence) from time to time to keep pace with advancement in operative and diagnostic techniques and technology.'),
('25','25.5','25.5.1','There are planned activities for performance and quality improvement.'),
('25','25.5','25.5.2','The Head of Surgical Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.'),
('25','25.5','25.5.3','Specific performance indicators are tracked for e.g.;
a.) Number of mortality/morbidity audits conducted in the department
b.) Unplanned return to OT within the same hospital admission following surgery.');
CREATE TEMP TABLE import_e (standard_number text NOT NULL, criterion_number text NOT NULL, compliance_number text NOT NULL, number text NOT NULL, summary text NOT NULL) ON COMMIT DROP;
INSERT INTO import_e VALUES
('24','24.1','24.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('24','24.1','24.1.1','2','There is an endorsed and dated department Organisational chart with lines of functions and reporting relationships.'),
('24','24.1','24.1.1','3','Relevant policies and acts are available in the department (National Health Plan, National Health Service Standards, Service Improvement Plan, Medicines Cosmetics Act 1999 and Regulations 2001, etc.).'),
('24','24.1','24.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('24','24.1','24.1.1','5','Evidence of fee structure (if fees are collected).'),
('24','24.1','24.1.2','1','Letter of appointment and terms of reference as the Head of Service'),
('24','24.1','24.1.2','2','Letter of appointment and terms of reference as a member of the Clinical Governance Advisory Committee.'),
('24','24.1','24.1.2','3','Letter of appointment and terms of reference in other hospital committees (including the Medicine and Therapeutics Committee).'),
('24','24.1','24.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff (see initialing).'),
('24','24.1','24.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service (see attendance sheets)'),
('24','24.1','24.1.3','3','Frequency of meetings are as scheduled (minutes or meeting reports)'),
('24','24.1','24.1.3','4','Discussions and resolutions are implemented. (problems not solved are brought forward to the next meeting till resolved).'),
('24','24.1','24.1.4','1','The statistics and records from (a) to (f) are available.'),
('24','24.2','24.2.1','1','There are dated and specific job descriptions for each staff that include (a) to (f).'),
('24','24.2','24.2.1','2','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('24','24.2','24.2.1','3','The scope of work in the job description aligns with the training, skill and experience of the staff (including specialisation).'),
('24','24.2','24.2.2','1','Evidence of current registration for all cadres of staff (annual practicing certificate) with the Pharmacy Board.'),
('24','24.2','24.2.3','1','Observation that cadres of staff are working according to their job description and job scope.'),
('24','24.2','24.2.4','1','There is a policy requiring new staff to attend an orientation programme.'),
('24','24.2','24.2.4','2','Records of staff attendance to orientation programme.'),
('24','24.2','24.2.5','1','The staff wear neat apron/coats.'),
('24','24.2','24.2.5','2','The staff have a badge displaying their names and the word “Pharmacist”'),
('24','24.2','24.2.6','1','Training calendar includes in-house/ external courses/ workshops/ conferences'),
('24','24.2','24.2.6','2','Training for each staff is kept in the Department (see list).'),
('24','24.2','24.2.6','3','There are ongoing Continuous Professional Activities in the Department (see training reports, minutes)'),
('24','24.2','24.2.7','1','Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews (see audits and remedial action).'),
('24','24.2','24.2.8','1','Evidence of sufficient skilled trained staff to provide clinical supervision as per terms of Memorandum of Understanding.'),
('24','24.2','24.2.8','2','There is Memorandum of Understanding with the relevant training institutions.'),
('24','24.2','24.2.9','1','Performance appraisal for staff including Pharmacy practitioners is completed upon probationary period and as an annual exercise.'),
('24','24.2','24.2.10','1','Documented evidence of research activities in the Department.'),
('24','24.2','24.2.11','1','Evidence of staff allocation in the Pharmacy Services is based on workload (see workload and staff figures)'),
('24','24.2','24.2.11','2','Evidence of contingency plan for acute shortage'),
('24','24.2','24.2.11','3','Evidence of duty roster and on-call roster'),
('24','24.2','24.2.11','4','Evidence that there is a gazetted pharmaceutical inspector'),
('24','24.3','24.3.1','1','Evidence of documented policies and procedures for the service.'),
('24','24.3','24.3.1','2','The policies and procedures are endorsed and dated.'),
('24','24.3','24.3.1','3','There is a periodic review at least once in three years.'),
('24','24.3','24.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference'),
('24','24.3','24.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('24','24.3','24.3.3','1','There is a Quality Management System (QMS) manual.'),
('24','24.3','24.3.3','2','All QMS activities are documented.'),
('24','24.3','24.3.3','3','The Quality manual is reviewed and updated.'),
('24','24.3','24.3.3','4','There are written SOPs for receipt of stocks including vaccines.'),
('24','24.3','24.3.3','5','There are SOPs for effective stock rotation (FEFO/FIFO)'),
('24','24.3','24.3.3','6','There are written procedures for disposal of expired, contaminated or damaged stock.'),
('24','24.3','24.3.3','7','There is evidence that staff have been trained in the procedures (training attendance or staff initials after reading SOP.'),
('24','24.3','24.3.3','8','There is an SOP on recall of medicines.'),
('24','24.3','24.3.4','1','There is a computerised programme for drug dispensing (sight).'),
('24','24.3','24.3.4','2','There is an effective stock control system in place that records all medicines and supplies (see online system or stock cards).'),
('24','24.3','24.3.4','3','There is a computerised system or prescription book for medicines records and number of prescriptions dispensed.'),
('24','24.3','24.3.4','4','There is lock and key cupboard with a register for dangerous drugs.'),
('24','24.3','24.3.4','5','There are copies maintained of records and registers.'),
('24','24.3','24.3.5','1','There is a SOP for prescription handling.'),
('24','24.3','24.3.5','2','Dispensed medicine are labelled according to Medicines and Cosmetics Regulation requirements.'),
('24','24.3','24.3.5','3','Every prescription dispensed is checked and signed off by a pharmacist.'),
('24','24.3','24.3.5','4','There is a Good Pharmacy Practice Standard Guideline available in the Facility.'),
('24','24.3','24.3.5','5','There is evidence that the pharmacist provides appropriate counselling during dispensing. (interview/observation)'),
('24','24.3','24.3.5','6','The pharmacy promotes rational drug use to the public and medical profession (interview, observation, medical records).'),
('24','24.3','24.3.6','1','There is a SOP for medicines storage.'),
('24','24.3','24.3.6','2','There are SOPs for distribution of medicines.'),
('24','24.3','24.3.6','3','The pharmacy does ward impress rounds (interview, observe, see documentation).'),
('24','24.3','24.3.6','4','There are Good Storage Practice Standards (GSPS) guidelines available in the Pharmacy.'),
('24','24.3','24.3.6','5','Storage areas are secured and locked when required.'),
('24','24.3','24.3.6','6','Medicines are stored at stipulated temperature, protected from light, dust, humidity (observe, interview).'),
('24','24.3','24.3.6','7','There is regular stock rotation done.'),
('24','24.3','24.3.6','8','There is a list of expired drugs.'),
('24','24.3','24.3.7','1','There is an SOP to handle patient complaints.'),
('24','24.3','24.3.7','2','There is a system to document all events in the pharmacy.'),
('24','24.3','24.3.7','3','Copies of meeting minutes of the Medicine and Therapeutics committee are available in the pharmacy and is read by staff (sight copy and see staff initials).'),
('24','24.3','24.3.7','4','There is a SOP on reporting and monitoring of adverse events (see SOP)'),
('24','24.3','24.3.7','5','Adverse Drug Reaction (ADR) forms are filled appropriately and conform to SOP (see ADR form and compliance to reporting pathway).'),
('24','24.3','24.3.7','6','There is an established drug information system established and in use in the Pharmacy Department.'),
('24','24.3','24.3.7','7','The Pharmacy Department has a collection of reference books.'),
('24','24.4','24.4.1','1','The building is sound and there is adequate space to match the services (medicine holding shelves, display counter, counselling area, compounding and dispensing).'),
('24','24.4','24.4.1','2','The environment around the pharmacy is neat and tidy.'),
('24','24.4','24.4.1','3','There is signage to the Pharmacy department.'),
('24','24.4','24.4.1','4','There is a “Pharmacy” sign in front of the pharmacy.'),
('24','24.4','24.4.1','5','Pharmacy services and hours are clearly demonstrated in English and Pidgin.'),
('24','24.4','24.4.1','6','The pharmacist is easily accessible to public for counselling and information (observe and interview).'),
('24','24.4','24.4.1','7','There is constant supply of electricity particularly for the refrigerators.'),
('24','24.4','24.4.1','8','There is good ventilation within the pharmacy'),
('24','24.4','24.4.1','9','There is running water in the facility'),
('24','24.4','24.4.1','10','There is a record of pest control measures taken.'),
('24','24.4','24.4.1','11','The pharmacy has adequate lighting.'),
('24','24.4','24.4.2','1','There is provision of drinking water for patients to take their medication and for staff.'),
('24','24.4','24.4.2','2','There is access to hand washing facilities.'),
('24','24.4','24.4.2','3','There are sharp bins for disposal of sharps.'),
('24','24.4','24.4.2','4','There is adequate PPE (observe and interview).'),
('24','24.4','24.4.2','5','There are separate rubbish bins for patients and pharmacy personnel.'),
('24','24.4','24.4.2','6','There is detergent for cleaning.'),
('24','24.4','24.4.3','1','Appropriate telecommunication modalities available for daily operation and during emergencies.'),
('24','24.4','24.4.4','1','There is a working refrigerator or cool room for medicines and vaccines storage.'),
('24','24.4','24.4.4','2','There are adequate tablet counting trays, spatulas, dispensing bags and bottles and containers.'),
('24','24.4','24.4.4','3','There are a range of graduated, stamped glassware measures.'),
('24','24.4','24.4.4','4','The pharmacy has a mortar and pestle and an area to prepare topical preparations.'),
('24','24.4','24.4.4','5','There is evidence of cautionary and advisory labels or clear warning indications on labels.'),
('24','24.4','24.4.4','6','There is a suitable, validated laminar airflow cabinet for preparation of oncology drugs.'),
('24','24.4','24.4.4','7','Computers and printers are available for the labelling and dispensing of medicines.'),
('24','24.4','24.4.5','1','The Pharmacy is accessible to people living with disabilities (PLWD).'),
('24','24.4','24.4.5','2','Feedback from patient satisfaction surveys on the facilities.'),
('24','24.4','24.4.5','3','Incident reporting relating to facilities if any.'),
('24','24.5','24.5.1','1','There is a designated person who monitors safety and performance improvement activities within the Pharmacy Services.'),
('24','24.5','24.5.1','2','There are records/registers on performance improvement activities.'),
('24','24.5','24.5.1','3','There are meeting minutes for performance improvement meetings'),
('24','24.5','24.5.1','4','There are records on innovation (if any)'),
('24','24.5','24.5.2','1','System for incident reporting is in place with the following;
a.) Training of staff in incident reporting
b.) Policy on incident reporting
c.) Method/SOP on Incident reporting
d.) Register of incidents'),
('24','24.5','24.5.2','2','Completed incident reports'),
('24','24.5','24.5.2','3','Corrective and preventive action plans'),
('24','24.5','24.5.2','4','Minutes of meeting'),
('24','24.5','24.5.2','5','Involved staff given feedback about the incident report'),
('24','24.5','24.5.2','6','Acknowledgment by Head of Pharmacy Service and Director of Curative Services.'),
('24','24.5','24.5.3','1','Specific performance indicators are monitored.'),
('24','24.5','24.5.3','2','Remedial action is taken when appropriate'),
('25','25.1','25.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('25','25.1','25.1.1','2','There is an endorsed and dated department organisational chart with lines of functions and reporting relationships.'),
('25','25.1','25.1.1','3','Relevant policies and guidelines are available in the department, i.e., National Health Plan, National Health Service Standards, etc.)'),
('25','25.1','25.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('25','25.1','25.1.1','5','Evidence of fee structure (if fees are collected).'),
('25','25.1','25.1.2','1','Letter of appointment and terms of reference as the Head of Service'),
('25','25.1','25.1.2','2','Letter of appointment and terms of reference as a member of the Clinical Governance Advisory Committee.'),
('25','25.1','25.1.2','3','Letter of appointment and terms of reference in other hospital committees.'),
('25','25.1','25.1.2','4','Evidence of (a) to (d) in meeting minutes/correspondence of the Surgical Services indicating the involvement of the Head of Service.'),
('25','25.1','25.1.2','5','There is correspondence requesting allocation for budget and staffing.'),
('25','25.1','25.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff.'),
('25','25.1','25.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service.'),
('25','25.1','25.1.3','3','Frequency of meetings are as scheduled.'),
('25','25.1','25.1.3','4','Discussions and resolutions are implemented. (problems not solved are brought forward to the next meeting till resolved).'),
('25','25.1','25.1.4','1','The statistics and records from (a) to (g) are available.'),
('25','25.1','25.1.4','2','The NHSS Toolkit Assessment (checklist) for the relevant level has been completed in the past 6 months.'),
('25','25.2','25.2.1','1','There are dated and specific job descriptions for each staff that include (a) to (f).'),
('25','25.2','25.2.1','2','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('25','25.2','25.2.1','3','The scope of work in the job description aligns with the training, skill and experience of the staff. (credentialling)'),
('25','25.2','25.2.1','4','The staff operate within the areas in which they have been privileged.'),
('25','25.2','25.2.2','1','Evidence of current registration for all cadres of staff (annual practicing certificate).'),
('25','25.2','25.2.3','1','Observation that cadres of staff are working according to their job description and job scope.'),
('25','25.2','25.2.4','1','Training calendar includes in-house/ external courses/ workshops/ conferences'),
('25','25.2','25.2.4','2','Training for each staff including training in life support is kept in the Department.'),
('25','25.2','25.2.4','3','There are ongoing Continuous Professional Activities in the Department.'),
('25','25.2','25.2.5','1','Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.'),
('25','25.2','25.2.6','1','Evidence of sufficient skilled trained staff to provide clinical supervision as per terms of Memorandum of Understanding.'),
('25','25.2','25.2.6','2','There is Memorandum of Understanding with the relevant training institutions.'),
('25','25.2','25.2.7','1','Performance appraisal for staff including Surgical practitioners is completed upon probationary period and as an annual exercise.'),
('25','25.2','25.2.8','1','Documented evidence of research activities in the Department.'),
('25','25.2','25.2.9','1','Planning of staff allocation and movement within the Department includes the following;
a.) Staff allocation in the Surgical Services is based on staff to patient ratio, bed occupancy rate and complexity of cases
b.) There are staff with postgraduate Surgical skills in each shift
c.) Contingency plan for acute shortage
d.) Duty roster'),
('25','25.2','25.2.10','1','Evidence of policy stating that all staff have to attend a structured orientation programme covering (a) to (k).'),
('25','25.2','25.2.10','2','Attendance list of those having attended the orientation programme.'),
('25','25.3','25.3.1','1','Evidence of documented policies and procedures for the service.'),
('25','25.3','25.3.1','2','The policies and procedures are endorsed and dated.'),
('25','25.3','25.3.1','3','There is a periodic review at least once in three years.'),
('25','25.3','25.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference.'),
('25','25.3','25.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('25','25.3','25.3.3','1','Documented policies and procedures that address (a) to (u).'),
('25','25.3','25.3.3','2','Staff are briefed on the policies and procedures (meeting/briefing minutes or circulation acknowledgement).'),
('25','25.3','25.3.3','3','Copies of the policies are available onsite for staff reference.'),
('25','25.3','25.3.4','1','Operational policy on 24-hour service.'),
('25','25.3','25.3.4','2','Staffing level reflects a good mix of senior and junior staff.'),
('25','25.3','25.3.4','3','On call roster is dated and authorised.'),
('25','25.3','25.3.5','1','Relevant Standard Treatment Guidelines are available in the division'),
('25','25.3','25.3.5','2','Patient register is updated daily.'),
('25','25.3','25.3.5','3','Evidence of appropriate admission process.'),
('25','25.3','25.3.5','4','Evidence of in-patient and guardian orientation process during admission.'),
('25','25.3','25.3.5','5','Evidence of initial assessment and provisional diagnosis.'),
('25','25.3','25.3.5','6','Evidence and documentation of morning and evening rounds.'),
('25','25.3','25.3.5','7','Evidence of regular vital sign documentation'),
('25','25.3','25.3.5','8','Documentation of discussions with patient/family/guardian about the patient’s condition.'),
('25','25.3','25.3.5','9','Evidence of discussions with other disciplines and referrals if necessary.'),
('25','25.3','25.3.5','10','Evidence of patient handover during shift change (documentation and observed).'),
('25','25.3','25.3.5','11','Evidence of documented informed consent for procedures.'),
('25','25.3','25.3.5','12','Evidence of flowchart on patient deterioration or “Code Blue” procedures.'),
('25','25.3','25.3.5','13','Discharge summaries are issued to patients on discharge with a care plan.'),
('25','25.3','25.3.6','1','Observation onsite that the patient’s Surgical record has elements (a) to (l).'),
('25','25.3','25.3.6','2','The patient’s Surgical record has a unique identifier (MRN).'),
('25','25.3','25.3.6','3','Evidence of clinical documentation which is signed, dated and with legible writing.'),
('25','25.3','25.3.6','4','Evidence of use of appropriate abbreviations.'),
('25','25.3','25.3.7','1','There is a standing operating procedure for the checking of patient’s identification.'),
('25','25.3','25.3.7','2','There is documented evidence of verification of surgical site.'),
('25','25.3','25.3.7','3','Evidence that the patient and their guardian are involved in the patient identification and verification.'),
('25','25.3','25.3.7','4','Patient and their guardians are provided with resources (e.g. brochure) to understand verification processes.'),
('25','25.3','25.3.8','1','Observation onsite that informed consent from the patient is obtained and is documented in the patient’s notes'),
('25','25.3','25.3.8','2','Documentation that informed consent has been taken appropriately.'),
('25','25.3','25.3.9','1','Evidence that a Surgical Safety checklist is being used for a patient undergoing surgery.'),
('25','25.3','25.3.10','1','Documented verification of all instruments and other accountable items, are done at the end of surgery.'),
('25','25.3','25.3.10','2','All staff professionals involved in the surgery jointly sign off on the procedure (documented evidence).'),
('25','25.3','25.3.10','3','Incident reporting is done and investigated for incorrect counting and lost item.'),
('25','25.4','25.4.1','1','The building is sound and there is adequate space to match the services.'),
('25','25.4','25.4.1','2','Appropriate type of equipment to match the complexity of services.'),
('25','25.4','25.4.1','3','Adequate facilities and equipment at each patient care area for safe care. (e.g. defibrillators, emergency trolley, hand washing facilities etc.).'),
('25','25.4','25.4.1','4','Easy access and clear (unblocked) exit routes.'),
('25','25.4','25.4.1','5','Absence of overcrowding.'),
('25','25.4','25.4.1','6','Availability of an isolation area.'),
('25','25.4','25.4.1','7','There are lights/lamps/solar for blackouts.'),
('25','25.4','25.4.1','8','There is good ventilation within the ward/s.'),
('25','25.4','25.4.1','9','There is running water in the facility'),
('25','25.4','25.4.1','10','Waste is segregated at the facility at the point of generation.'),
('25','25.4','25.4.2','1','Design and layout of the unit, e.g. wards, treatment rooms, dirty and clean utility rooms, access, lighting, signage, etc. address the safety aspects of patients and staff.'),
('25','25.4','25.4.2','2','Equipment should have scheduled planned preventive maintenance (PPM).'),
('25','25.4','25.4.2','3','There is access to hand washing facilities.'),
('25','25.4','25.4.2','4','Mattresses are covered with waterproof coverings and there is clean linen on every bed.'),
('25','25.4','25.4.2','5','Sharps are disposed properly.'),
('25','25.4','25.4.3','1','Appropriate telecommunication modalities available for daily operation and during emergencies.'),
('25','25.4','25.4.4','1','There is up-to-date documentation of the total number of beds (overnight and day-only beds)'),
('25','25.4','25.4.4','2','Evidence that any patient who occupies a bed for more than 4 hours and receives significant clinical care is classified as an “in-patient”.'),
('25','25.4','25.4.4','3','Factors such as “bed occupancy rates” and “average length of stay” are monitored and analysed.'),
('25','25.4','25.4.5','1','Floor plan indicates facility accessibility and is patient and user friendly.'),
('25','25.4','25.4.5','2','Feedback from patient satisfaction surveys on the facilities.'),
('25','25.4','25.4.5','3','Incident reporting relating to facilities if any.'),
('25','25.4','25.4.5','4','Toilets have wheelchair access.'),
('25','25.4','25.4.6','1','Availability of emergency and non-emergency equipment appropriate to level of care, such as defibrillator, emergency trolley, suction machine, electrocardiogram (ECG) machine, infusion or syringe pump, vital sign monitor, pulse oximeter, oxygen concentrator etc.'),
('25','25.4','25.4.6','2','Scheduled checking of items in emergency trolley.'),
('25','25.4','25.4.6','3','There are adequate patient transfer trolleys, wheelchairs, mobility aids and a dedicated drug fridge.'),
('25','25.4','25.4.6','4','There is a dedicated cabinet for dangerous drugs which can be locked.'),
('25','25.4','25.4.7','1','Planned Preventive Maintenance records such as schedule, stickers, etc.'),
('25','25.4','25.4.7','2','Planned Replacement Programme where applicable.'),
('25','25.4','25.4.7','3','Complaint records.'),
('25','25.4','25.4.7','4','Asset inventory'),
('25','25.4','25.4.8','1','User training records'),
('25','25.4','25.4.8','2','List of staff trained and authorised to operate specialised equipment.'),
('25','25.4','25.4.9','1','Evidence of list of services available and offered to patients.'),
('25','25.4','25.4.9','2','Flow chart on work process'),
('25','25.4','25.4.9','3','Safe keeping of Surgical records'),
('25','25.4','25.4.9','4','Clinic appointment system'),
('25','25.4','25.4.9','5','Security of data in Health Information System'),
('25','25.4','25.4.9','6','Monitoring of waiting time'),
('25','25.4','25.4.9','7','Adequate and appropriate signage'),
('25','25.4','25.4.9','8','Floor plan indicates accessibility to supporting services and optimisation of space'),
('25','25.4','25.4.9','9','Adequate patient personal use items, e.g. wheelchair, mobility aids etc.'),
('25','25.4','25.4.9','10','Adequate waiting area, toilets, reading material and parking space.'),
('25','25.4','25.4.10','1','Evidence of facilities with patient privacy ensured.'),
('25','25.4','25.4.10','2','Procedure room appropriately equipped.'),
('25','25.4','25.4.10','3','Patient monitoring device is available where required (vital signs).'),
('25','25.4','25.4.10','4','List of procedures performed.'),
('25','25.4','25.4.11','1','There is evidence that equipment is upgraded in a systematic manner.'),
('25','25.5','25.5.1','1','There is a designated person who monitors safety and performance improvement activities within the Surgical Services.'),
('25','25.5','25.5.1','2','There are records/registers on performance improvement activities.'),
('25','25.5','25.5.1','3','There are meeting minutes for performance improvement meetings.'),
('25','25.5','25.5.1','4','There are records on innovation (if any).'),
('25','25.5','25.5.2','1','System for incident reporting is in place with the following;
a.) Training of staff in incident reporting
b.) Policy on incident reporting
c.) Method/SOP on Incident reporting
d.) Register of incidents'),
('25','25.5','25.5.2','2','Completed incident reports'),
('25','25.5','25.5.2','3','Corrective and preventive action plans'),
('25','25.5','25.5.2','4','Minutes of meeting'),
('25','25.5','25.5.2','5','Involved staff given feedback about the incident report'),
('25','25.5','25.5.2','6','Acknowledgment by Head of Surgical Service and Director of Curative Services.'),
('25','25.5','25.5.3','1','Specific performance indicators are monitored.'),
('25','25.5','25.5.3','2','Remedial action is taken when appropriate.');
INSERT INTO standards ("standardNumber","standardTitle","standardSummary","functionId","componentId") SELECT standard_number,title,summary,4,6 FROM import_s;
INSERT INTO criteria ("criterionNumber","criterionTitle","standardId","isApplicable") SELECT x.number,x.title,s."standardId",true FROM import_c x JOIN standards s ON s."standardNumber"=x.standard_number;
INSERT INTO compliances ("complianceNumber","complianceSummary","criterionId","isApplicable") SELECT x.number,x.summary,c."criterionId",true FROM import_co x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number;
INSERT INTO evidence ("evidenceNumber","evidenceSummary","complianceId","isApplicable") SELECT x.number,x.summary,co."complianceId",true FROM import_e x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number JOIN compliances co ON co."criterionId"=c."criterionId" AND co."complianceNumber"=x.compliance_number;
DO $$ BEGIN
IF (SELECT count(*) FROM import_s x JOIN standards s ON s."standardNumber"=x.standard_number AND s."standardTitle"=x.title AND s."standardSummary"=x.summary AND s."functionId"=4 AND s."componentId"=6)<>2 THEN RAISE EXCEPTION 'Standard verification failed'; END IF;
IF (SELECT count(*) FROM import_c x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.number AND c."criterionTitle"=x.title AND c."isApplicable")<>10 THEN RAISE EXCEPTION 'Criterion verification failed'; END IF;
IF (SELECT count(*) FROM import_co x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number JOIN compliances co ON co."criterionId"=c."criterionId" AND co."complianceNumber"=x.number AND co."complianceSummary"=x.summary AND co."isApplicable")<>68 THEN RAISE EXCEPTION 'Compliance verification failed'; END IF;
IF (SELECT count(*) FROM import_e x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number JOIN compliances co ON co."criterionId"=c."criterionId" AND co."complianceNumber"=x.compliance_number JOIN evidence e ON e."complianceId"=co."complianceId" AND e."evidenceNumber"=x.number AND e."evidenceSummary"=x.summary AND e."isApplicable")<>244 THEN RAISE EXCEPTION 'Evidence verification failed'; END IF;
END $$;
COMMIT;
SELECT json_build_object('standardNumber',s."standardNumber",'standardId',s."standardId",'criteria',count(distinct c."criterionId"),'compliances',count(distinct co."complianceId"),'evidence',count(e."evidenceId"),'importedAt',CURRENT_TIMESTAMP) FROM standards s JOIN criteria c ON c."standardId"=s."standardId" JOIN compliances co ON co."criterionId"=c."criterionId" JOIN evidence e ON e."complianceId"=co."complianceId" WHERE s."standardNumber" IN ('24','25') GROUP BY s."standardId" ORDER BY s."standardNumber";