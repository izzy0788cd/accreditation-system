BEGIN;
SET LOCAL lock_timeout = '5s';
DO $$ BEGIN IF NOT EXISTS(SELECT 1 FROM functions WHERE "functionId"=4 AND "functionNumber"='4') OR NOT EXISTS(SELECT 1 FROM components WHERE "componentId"=6 AND "componentNumber"='6') THEN RAISE EXCEPTION 'Parent mapping changed'; END IF; IF EXISTS(SELECT 1 FROM standards WHERE lower("standardNumber") IN ('23g','23h','23j','23k','23l')) THEN RAISE EXCEPTION 'Target standard already exists; review before importing'; END IF; END $$;
CREATE TEMP TABLE import_s (standard_number text NOT NULL, title text NOT NULL, summary text NOT NULL) ON COMMIT DROP;
INSERT INTO import_s VALUES
('23g','Otorhinolaryngology (ear, nose and throat)','Standard 23: provision of and continuity of care (mandatory standard)
The Healthcare Organisation ensures patients are provided with safe, high- quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.
The Healthcare Organisation should implement evidence-based practice and a have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.

Source references
Standard 17 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standard

Criterion guidance
23g.1 Organisation and management
The Otorhinolaryngology Services shall be organised, directed and coordinated with other services in the facility to provide a standard of inpatient and outpatient care to the community in a safe, effective, efficient and caring manner. The Otorhinolaryngology services should be accessible, and continuity of care assured.

23g.2 Human resources and development
The Otorhinolaryngology Services shall be directed by a qualified and competent medical practitioner, and staffed by suitably qualified and competent clinical staff to achieve the goals and objectives of the Otorhinolaryngology Services. There are sufficient staffing levels, a staff supervision structure, performance appraisals and ongoing commitment to continuing medical education.

23g.3 Policies and procedures
There are written and dated policies for all activities of the Otorhinolaryngology Services. These policies reflect current standards of medical practice, relevant regulations and statutory requirements. These policies and procedures, terms of reference, by laws, rules and regulations state how the clinical staff regulate themselves and provide patient care.

23g.4 Facilities and equipment
The Head of Otorhinolaryngology Services shall ensure adequate facilities and equipment that are safe and appropriate are available for the staff to function effectively and to meet the goals and objectives of the Otorhinolaryngology Services.

23g.5 Safety and performance improvement activities
The Head of Otorhinolaryngology Services shall ensure the provision of quality performance with staff involvement in the continuous safety and performance improvement activities of the Otorhinolaryngology Services.'),
('23h','Radiology','Standard 23: provision of and continuity of care (mandatory standard)
The Healthcare Organisation ensures patients are provided with safe, high- quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.
The Healthcare Organisation should implement evidence-based practice and a have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.

Source references
Standard 17 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standard

Criterion guidance
23h.1 Organisation and management
The Radiology Services shall provide safe and efficient radiological services. The services shall be coordinated with other departments and services of the Facility.

23h.2 Human resources and development
The Radiology Services shall be directed by a qualified and competent medical practitioner, and staffed by suitably qualified and competent clinical staff to achieve the goals and objectives of the Radiology Services. There are sufficient staffing levels, a staff supervision structure, performance appraisals and ongoing commitment to continuing medical education.

23h.3 Policies and procedures
There are written and dated policies for all activities of the Radiology Services. These policies reflect current standards of radiology/diagnostic imaging practices, relevant regulations and statutory requirements. Throughout the Facility, a list of procedures requiring informed consent specific to radiology/diagnostic imaging procedures should be available. Possible risks and complications arising from procedures should be documented either in specific consent forms or in patient''s medical record.

23h.4 Facilities and equipment
The Head of Radiology Services shall ensure adequate facilities and equipment that are safe and appropriate are available for the staff to function effectively and to meet the goals and objectives of the Radiology Services.

23h.5 Safety and performance improvement activities
There are safety and performance improvement programmes to improve staff performance, clinical practices and ethical standards of the Radiology Services. There is evidence that the statistical data collected are analysed and utilised for the ongoing improvement of the Radiology Services.'),
('23j','Operating theatre','Standard 23: provision of and continuity of care (mandatory standard)
The Healthcare Organisation ensures patients are provided with safe, high- quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.
The Healthcare Organisation should implement evidence-based practice and a have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.

Source references
Standard 17 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standard

Criterion guidance
23j.1 Organisation and management
The Operating Theatre Services have combined multidisciplinary healthcare personnel, e.g. surgeons, anaesthetists, nurses, theatre technician and other support staff in delivering a high standard of comprehensive patient care to those who require operative procedures during their stay in the Facility.

23j.2 Human resources and development
The Operating Theatre Services shall be directed by a qualified and competent medical practitioner, and staffed by suitably qualified and competent clinical staff to achieve the goals and objectives of the Services. There are sufficient staffing levels, a staff supervision structure, performance appraisals and ongoing commitment to continuing medical education.

23j.3 Policies and procedures
There are written and dated policies for all activities of the Operating Theatre Services. These policies reflect current standards of medical practice, relevant regulations and statutory requirements. These policies and procedures, terms of reference, by laws, rules and regulations state how the clinical staff regulate themselves and provide patient care.

23j.4 Facilities and equipment
The Head of Operating Theatre Services shall ensure adequate facilities and equipment that are safe and appropriate are available for the staff to function effectively and to meet the goals and objectives of the Services.

23j.5 Safety and performance improvement activities
There are safety and performance improvement programmes to improve staff performance, clinical practices and ethical standards of the Radiology Services. There is evidence that the statistical data collected are analysed and utilised for the ongoing improvement of the Operating Theatre Services.'),
('23k','Intensive care unit (ICU) / High dependency unit (HDU)','Standard 23: provision of and continuity of care (mandatory standard)
The Healthcare Organisation ensures patients are provided with safe, high- quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.
The Healthcare Organisation should implement evidence-based practice and a have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.

Service scope
Critical Care Services are provided in a specially staffed and equipped, separate and self-contained area of a hospital dedicated to the management of patients with life-threatening illnesses, injuries and complications, and monitoring of potentially life-threatening conditions.
Levels of Intensive Care Units
Each ICU should declare the level of intensive care it provides which should be consistent with the Facility’s overall mission.
Level 1
This is equivalent to the ‘High Dependency Unit (HDU)’. The unit shall be able to provide basic haemodynamic support, monitoring and oxygen therapy or non-invasive ventilation in a stable patient. The nurse-to-patient ratio shall be 1:2.
Level 2
This unit shall be able to provide mechanical ventilation and invasive hemodynamic monitoring. An anaesthetist/intensivist shall spend full time in the unit to manage all patients in the unit. The nurse-to-patient ratio shall be 1:1 for ventilated patients and 1:2 for non-ventilated patients.
Level 3
This unit shall be able to provide advanced mechanical ventilation, advanced hemodynamic monitoring and extracorporeal organ support, e.g. extracorporeal renal support, extracorporeal liver support, extracorporeal membrane oxygenation etc. Operating this unit as a "closed" unit is which is directed by an intensivist who shall spend full time in the unit to manage all patients in the unit. The nurse-to-patient ratio shall be 1:1 in every shift or more in highly complex cases.

Source references
Standard 17 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standard
Marilyn T. Haupt et al. Guidelines on critical care services and personnel: Recommendations based on a system of categorisation of three levels of care. Critical Care Medicine 2003

Criterion guidance
23k.1 Organisation and management
The Critical Care Services (CCS) shall be organised to provide safe, efficient, and effective critical care services in accordance with the identified level of care. The level of care identified shall be in tandem with the actual level of care provided in terms of all aspects of care, i.e. organisation, human resource, policies, facilities and performance improvement activities.

23k.2 Human resources and development
The ICU/HDU Services shall be directed by a qualified and competent medical practitioner, and staffed by suitably qualified and competent clinical staff to achieve the goals and objectives of its Services. There are sufficient staffing levels, a staff supervision structure, performance appraisals and ongoing commitment to continuing medical education.
For all levels of care of the ICU/HDU services, the Head is a clinician appointed to take overall responsibility for the operation of the unit.
a. For Level 1 Care: A clinician shall be responsible for the management of the patient.
b. For Level 2 Care: An Anaesthetist/Intensivist shall spend full time in the unit and be responsible for the management of all patients in the unit.
c. For Level 3 Care: An Intensivist shall spend full time in the unit and be responsible for the management of all patients in the unit.

23k.3 Policies and procedures
There are written and dated policies for all activities of the ICU/HDU Services. These policies reflect current standards of medical practice, relevant regulations and statutory requirements. These policies and procedures, terms of reference, by laws, rules and regulations state how the clinical staff regulate themselves and provide patient care.

23k.4 Facilities and equipment
The Head of ICU/HDU Services shall ensure adequate facilities and equipment that are safe and appropriate are available for the staff to function effectively and to meet the goals and objectives of the Services.

23k.5 Safety and performance improvement activities
The Head of ICU/HDU Services shall ensure the provision of quality performance with staff involvement in the continuous safety and performance improvement activities of the ICU/HDU Services.'),
('23l','Central supply sterilising department (CSSD)','Standard 23: provision of and continuity of care (mandatory standard)
The Healthcare Organisation ensures patients are provided with safe, high- quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.
The Healthcare Organisation should implement evidence-based practice and a have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.

Service scope
The Central Sterilising Supply Department (CSSD) provide sterilising services for all areas within the Facility. It shall comprise all activities relating to disinfection and sterilisation processes in the Facility.

Source references
Standard 17 National Health Service Standards (NHSS) Vol. 2 (2nd Edition) National Quality Standard

Criterion guidance
23l.1 Organisation and management


23l.2 Human resources and development
The CSSD Services shall be directed by a qualified and competent medical practitioner, and staffed by suitably qualified and competent clinical staff to achieve the goals and objectives of the CSSD Services. There are sufficient staffing levels, a staff supervision structure, performance appraisals and ongoing commitment to continuing medical education.

23l.3 Policies and procedures
There are documented policies and procedures that reflect current principles of disinfection and sterilising practices and processes of CSSD. These policies and procedures shall be consistent with relevant regulations, statutory requirements and goals and objectives of the CSSD.

23l.4 Facilities and equipment
There are adequate facilities and equipment to enable the CSSD to meet its goals and objectives in accordance with regulatory requirements.

23l.5 Safety and performance improvement activities
The Head of CSSD Services shall ensure the provision of quality performance with staff involvement in the continuous safety and performance improvement activities of the CSSD Services.');
CREATE TEMP TABLE import_c (standard_number text NOT NULL, number text NOT NULL, title text NOT NULL) ON COMMIT DROP;
INSERT INTO import_c VALUES
('23g','23g.1','Organisation and management'),
('23g','23g.2','Human resources and development'),
('23g','23g.3','Policies and procedures'),
('23g','23g.4','Facilities and equipment'),
('23g','23g.5','Safety and performance improvement activities'),
('23h','23h.1','Organisation and management'),
('23h','23h.2','Human resources and development'),
('23h','23h.3','Policies and procedures'),
('23h','23h.4','Facilities and equipment'),
('23h','23h.5','Safety and performance improvement activities'),
('23j','23j.1','Organisation and management'),
('23j','23j.2','Human resources and development'),
('23j','23j.3','Policies and procedures'),
('23j','23j.4','Facilities and equipment'),
('23j','23j.5','Safety and performance improvement activities'),
('23k','23k.1','Organisation and management'),
('23k','23k.2','Human resources and development'),
('23k','23k.3','Policies and procedures'),
('23k','23k.4','Facilities and equipment'),
('23k','23k.5','Safety and performance improvement activities'),
('23l','23l.1','Organisation and management'),
('23l','23l.2','Human resources and development'),
('23l','23l.3','Policies and procedures'),
('23l','23l.4','Facilities and equipment'),
('23l','23l.5','Safety and performance improvement activities');
CREATE TEMP TABLE import_co (standard_number text NOT NULL, criterion_number text NOT NULL, number text NOT NULL, summary text NOT NULL) ON COMMIT DROP;
INSERT INTO import_co VALUES
('23g','23g.1','23g.1.1','The Vision, Mission of the Facility are accessible. The Goals of the Otorhinolaryngology Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.'),
('23g','23g.1','23g.1.2','There is a mechanism to ensure effective interaction between the Head of the Services and the Organisation’s Governing Body and Senior Management. The Head of Services shall also be involved for the following aspects of
management of the services;
a.) Preparation of budget and ensuring that expenditure remains within the budget allocated
b.) Human resource
c.) Facility and equipment management
d.) Safety and performance improvement activities and risk management'),
('23g','23g.1','23g.1.3','Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the Otorhinolaryngology Services. These meetings are minuted and communicated to all staff.'),
('23g','23g.1','23g.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care.
The following (among others) are available;
a.) Workload/census for inpatients and outpatients
b.) Quarterly and annual report
c.) Incident reports and register
d.) Staffing number and staff profile
e.) Staff training records
f.) Data on performance improvement
g.) Number of referrals to the Otorhinolaryngology Services'),
('23g','23g.2','23g.2.1','The are written and dated job descriptions for each category of staff that include:
a.) Qualification, training and experience for the position
b.) Lines of authority
c.) Accountability, functions and responsibilities
d.) Reviewed when required if there is major change in job scope
e.) Statutory regulations
f.) Administrative and clinical job scope'),
('23g','23g.2','23g.2.2','The staff holds current registration with the relevant professional body.'),
('23g','23g.2','23g.2.3','The staff works within their job description and job scope.'),
('23g','23g.2','23g.2.4','There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice.'),
('23g','23g.2','23g.2.5','The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.'),
('23g','23g.2','23g.2.6','In a Facility where undergraduate medical, nursing and allied health training programmes are conducted, the Facility shall ensure there are sufficient skilled trained staff to provide clinical supervision of students.'),
('23g','23g.2','23g.2.7','Staff, including medical practitioners, receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('23g','23g.2','23g.2.8','Where appropriate the Facility shall endeavour to undertake clinical research using available resources.'),
('23g','23g.2','23g.2.9','Staffing levels are based on the following;
a.) The number of persons deployed is proportional to the number of patients being cared for as per regulatory requirements and for the intensity of care provided
b.) The categories of service providers reflect the complexity of clinical problems being managed
c.) Staffing needs shall take into consideration absences due to leave or illness; double shift duties by clinical staff shall be documented and monitored
d.) Adequate staffing levels of appropriate competency shall be maintained throughout the hours the services are in operation.
e.) Where it is not possible to have service providers on duty on site, e.g. after working hours, provision is made for relevant medical practitioner to be available on call.'),
('23g','23g.2','23g.2.10','There is a structured orientation programme for all newly appointed staff to the Psychiatry Services including medical practitioners and for those new to specific areas that include the following;
a.) Explanation of the goals, objectives, policies and procedures of the Facility and those of the Psychiatry Services
b.) Lines of authority and areas of responsibility
c.) Explanation of duties and functions
d.) Explanation of the methods of assigning clinical care and the standards of clinical practice
e.) Handover communication
f.) Processes for resolving practice/ethical dilemmas in a timely manner
g.) Information about safety procedures
h.) Training in basic/advanced life support techniques
i.) Methods of obtaining appropriate resource materials
j.) Staff appraisal procedures for the Otorhinolaryngology Services
k.) Education on Patient and Family Rights'),
('23g','23g.3','23g.3.1','There are written policies and procedures for the Otorhinolaryngology Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.'),
('23g','23g.3','23g.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('23g','23g.3','23g.3.3','The policies and procedures documentation shall address at least the following topics;
a.) Description of the organisational structure of the Otorhinolaryngology Services
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
('23g','23g.3','23g.3.4','The service shall operate on a 24-hour basis providing level of care appropriate the facility.'),
('23g','23g.3','23g.3.5','The service shall ensure that provision of patient care and services achieve effective outcomes and is safe.'),
('23g','23g.3','23g.3.6','There is a standardised patient medical record.
This record should have the following:
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
('23g','23g.4','23g.4.1','There are adequate and appropriate facilities and equipment with proper utilisation of space to enable staff to carry out their professional, teaching and administrative functions.'),
('23g','23g.4','23g.4.2','Existing facilities shall consider the safety and comfort of staff and patients.'),
('23g','23g.4','23g.4.3','Suitable forms of communication systems and equipment are provided to enable clinical staff to communicate among themselves and with the other members of the healthcare team.'),
('23g','23g.4','23g.4.4','There is optimal management of beds at the Department with documentation of total number of beds and monitoring of bed occupancy rates.'),
('23g','23g.4','23g.4.5','Facilities are suitably located to facilitate easy access and to provide an atmosphere of user, environmental and ‘disabled'' friendly'),
('23g','23g.4','23g.4.6','Equipment, both for emergency and non-emergency usage, shall be appropriate to the level of care.'),
('23g','23g.4','23g.4.7','There is evidence that the facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order.'),
('23g','23g.4','23g.4.8','Where specialised equipment is used, there is evidence that only staff who are trained and authorised by the Facility operate such equipment.'),
('23g','23g.4','23g.4.9','The Specialist Outpatient Services shall have the following features;
a.) The organisation and management of the clinics are planned to ensure minimal waiting time, and avoidance of unnecessary visits by the patients
b.) Record keeping shall be efficient
c.) An appointment or queuing system is used to manage patient consultations
d.) The clinic is easily accessible including for non-ambulant patients and is easily identified through adequate signage
e.) The clinic is located close to other facilities, e.g. radiology, laboratories and pharmacy
f.) Adequate provision is made for patient comfort
g.) Call back system (especially for high- risk cases)
h.) Avenue for patients to access service between appointments
i.) Monitoring of data'),
('23g','23g.4','23g.4.10','At the Outpatient Clinic, adequate numbers of rooms are provided to ensure patient privacy and confidentiality for various patient care activities including:
a.) Consultation (not more than one patient in a room at any time).
b.) Minor procedures and nursing procedures.
c.) Performance of various tests.'),
('23g','23g.5','23g.5.1','There are planned activities for performance and quality improvement.'),
('23g','23g.5','23g.5.2','The Head of Otorhinolaryngology Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.'),
('23g','23g.5','23g.5.3','Specific performance indicators are tracked for e.g.;
a.) Something to go here??'),
('23h','23h.1','23h.1.1','The Vision, Mission of the Facility are accessible. The Goals of the Radiology Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.'),
('23h','23h.1','23h.1.2','There is a mechanism to ensure effective interaction between the Head of the Services and the Organisation’s Governing Body and Senior Management. In the case there is no resident radiologist, the Head of Service will be the Officer in Charge (OIC), and the services should be supervised by a designated radiologist.'),
('23h','23h.1','23h.1.3','Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the Medical Services. These meetings are minuted and communicated to all staff.'),
('23h','23h.1','23h.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care.
The following (among others) are available:
a.) Workload/census for inpatients and outpatients.
b.) Quarterly and annual report
c.) Incident reports and register
d.) Staffing number and staff profile
e.) Staff training records
f.) Data on performance improvement'),
('23h','23h.1','23h.1.5','The Radiology Services staff shall participate in the following:
a.) Where applicable, the clinical aspects of patient care and other radiological matters in the Facility.'),
('23h','23h.2','23h.2.1','The are written and dated job descriptions for each category of staff that include:
a.) Qualification, training and experience for the position
b.) Lines of authority
c.) Accountability, functions and responsibilities
d.) Reviewed when required if there is major change in job scope
e.) Statutory regulations
f.) Administrative and clinical job scope'),
('23h','23h.2','23h.2.2','The staff holds current registration with the relevant professional body.'),
('23h','23h.2','23h.2.3','All radiographic procedures shall be carried out by appropriately qualified and competent personnel.'),
('23h','23h.2','23h.2.4','A radiographer and a radiologist shall be on duty or be available on call after normal working hours.'),
('23h','23h.2','23h.2.5','There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice.'),
('23h','23h.2','23h.2.6','The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.'),
('23h','23h.2','23h.2.7','In a Facility where undergraduate medical, nursing and allied health training programmes are conducted, the Facility shall ensure there are sufficient skilled trained staff to provide clinical supervision of students.'),
('23h','23h.2','23h.2.8','Staff including medical practitioners receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('23h','23h.2','23h.2.9','Where appropriate the Facility shall endeavour to undertake clinical research using available resources.'),
('23h','23h.2','23h.2.10','There is a structured orientation programme for all newly appointed staff to the Radiology Services including medical practitioners and for those new to specific areas that include the following:
a.) Explanation of the goals, objectives, policies and procedures of the Facility and those of the Radiology Services
b.) Lines of authority and areas of responsibility
c.) Explanation of duties and functions
d.) Explanation of the methods of assigning clinical care and the standards of clinical practice
e.) Handover communication
f.) Processes for resolving practice/ethical dilemmas in a timely manner
g.) Information about safety procedures
h.) Training in basic/advanced life support techniques
i.) Methods of obtaining appropriate resource materials
j.) Staff appraisal procedures for the Radiology Services
k.) Education on Patient and Family Rights'),
('23h','23h.3','23h.3.1','There are written policies and procedures for the Radiology Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.'),
('23h','23h.3','23h.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('23h','23h.3','23h.3.3','The policies and procedures documentation shall address at least the following topics:

a.) Description of the organisational structure of the Radiology Services
b.) General operational policy
c.) Scheduling of patients for imaging
d.) Performing of radiological procedures
e.) Reporting, consultation and image management
f.) Safety in radiology e.g.
• Radiation safety
• MR safety (if applicable)
• Drugs and contrast medical safety (if applicable)
• Fire safety
• Occupational safety
g.) Communication with referrer, nursing, and other relevant staff on matters related to the services provided.
h.) Informed consent
i.) Identification of patients, correct procedure, correct site before performing the imaging
j.) Radiological examinations in areas other than the Radiology Department (if applicable)
k.) Imaging of patients having special needs including those who are critically ill and those needing isolation, physically or mentally challenged patients, paediatric and geriatric patients, pregnant staff and patients, person under custody, highly infectious patients.
l.) Relevant procedures and safety measures for each radiological modality where necessary.
m.) Handling of patient’s valuables
n.) Patient and family rights'),
('23h','23h.3','23h.3.4','There is evidence of compliance with policies and procedures.'),
('23h','23h.3','23h.3.5','Radiological investigation or procedure will be performed upon request by a medical practitioner or when deemed as indicated by a radiologist. Such requests will be made in writing and contain sufficient clinical information to justify the examination.'),
('23h','23h.3','23h.3.6','Reports on radiological examinations are made by a radiologist. In the absence of a radiologist, the interpretation of the examination shall be made by a competent medical practitioner.'),
('23h','23h.3','23h.3.7','The special radiological examination (excluding plain radiograph) for inpatients shall be reported within two (2) days. A copy of report shall be kept in the patient''s medical record.'),
('23h','23h.3','23h.3.8','The radiologist shall consult with the referring practitioner immediately when there are critical or unexpected findings.'),
('23h','23h.3','23h.3.9','Where hard copies need to be stored in the Facility, these shall be stored vertically in suitable environmental conditions to prevent fungus and in a manner for easy retrieval. There is a method of retrieving the hard copies if needed.'),
('23h','23h.3','23h.3.10','Proper documented instructions are available, and safety precautions are implemented for the protection of patients and staff who are exposed to hazardous equipment.
Staff shall also ensure that patient exposure is kept low as reasonably achievable using time, distance, shielding and collimation during the radiological examination while not compromising quality of the radiological image.'),
('23h','23h.3','23h.3.11','There are written procedures for the management of;
a.) Adverse drug or contrast media reaction anaphylactic reaction.
b.) Complication of diagnostic and therapeutic interventional procedures.
c.) There is easy access to emergency and resuscitation equipment and medical alerts.'),
('23h','23h.3','23h.3.12','Guidelines for patient preparation and procedures for radiological examinations shall be available to all relevant staff.'),
('23h','23h.3','23h.3.13','A technical manual for equipment shall be available within the Radiology Services.'),
('23h','23h.3','23h.3.14','There is a policy to ensure safety and confidentiality of all images.'),
('23h','23h.3','23h.3.15','Staff involved in the operating of ionising equipment shall undergo medical examinations. Full medical examination and a full blood examination to be conducted by a registered medical practitioner;
a.) Pre-employment medical examination;
b.) Regular medical examination (at least once in three years and more frequent for those exposed to higher ionizing radiation)
c.) Termination/completion of services.'),
('23h','23h.3','23h.3.16','Staff working with ionising radiation are monitored regularly. The exposure readings shall be sent to and reported by a licensed laboratory.
The radiation exposure results of every staff shall be monitored by the Radiation Safety Officer.
For staff having exceeded the maximum permissible dose, there is a protocol for reporting, investigation, and immediate and long -term remedial actions'),
('23h','23h.4','23h.4.1','There are adequate and appropriate facilities and equipment with proper utilisation of space to enable staff to carry out their professional, teaching and administrative functions.'),
('23h','23h.4','23h.4.2','There is documented evidence that equipment complies with relevant national/international standards and current statutory requirements.'),
('23h','23h.4','23h.4.3','There is evidence that the facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order.'),
('23h','23h.4','23h.4.4','Where specialised equipment is used (CT, MRI, mammography), there is evidence that only staff who are trained and authorised by the Facility operate such equipment.'),
('23h','23h.4','23h.4.5','Staff working with ionising equipment shall wear appropriate monitoring devices to be assessed periodically.
Patients are given appropriate radiation protection during radiological examination.'),
('23h','23h.4','23h.4.6','Multilingual signs and graphic images warning women of childbearing age with regards to radiation exposure and pregnancy shall be prominently displayed.'),
('23h','23h.4','23h.4.7','There shall be suitable changing rooms for patients and facilities to keep their personal valuables.'),
('23h','23h.4','23h.4.8','There is adequate space or area for patient preparation and observation pre and post radiological procedure.'),
('23h','23h.4','23h.4.9','There is designated area for patient and accompanying person for:
a.) Breast feeding patients
b.) Special handling/need patient e.g. irradiated patient, psychiatric patient and person under custody
c.) Consultation, grievances and physical privacy'),
('23h','23h.4','23h.4.10','Ultrasound Diagnostic Services shall be performed by credentialed medical practitioners/sonographers and reported by specialists.'),
('23h','23h.4','23h.4.11','There are functional and safe equipment and facilities that meet the regulatory requirements for the Mobile X-Rays and Mobile C-Arm (Image Intensifier) services in the Facility. The Mobile X- Rays and C-Arm shall be operated by a qualified radiographer.'),
('23h','23h.4','23h.4.12','When mobile x-rays are performed in the wards, efforts should be made to ensure that the neighbouring patients are protected adequately from scatter radiation.'),
('23h','23h.4','23h.4.13','There are guidelines on the handling, transport and storage of mobile x-ray machines and their accessories.'),
('23h','23h.4','23h.4.14','Mammography: Mammography services shall be performed only by adequately trained, radiographer/mammographer.
A radiologist trained to read mammograms shall report on the mammogram images.
The facilities and equipment for mammography examinations shall be safe and routine Quality Control is performed to ensure reliable results.'),
('23h','23h.4','23h.4.15','CT Scan: The Facility ensures that Computer Tomography (CT) examinations are performed on selective patients and they are provided with current and accurate information about its benefits and risks.
The staffs performing CT examination are adequately trained, and privileged. Adherence to relevant regulations and guidelines regarding safety and use of ionising radiation are observed by the imaging personnel.
The CT scan facilities and equipment are monitored regularly by a medical physicist to ensure that the equipment is functioning properly and taking optimal images.
There are guidelines for the handling of the following patients;
a.) Ambulatory
b.) Acute stroke
c.) Requiring oxygen support
d.) Critically ill on a ventilator
e.) Infants and children
f.) Patients with special needs
g.) Pregnant patient
h.) Patients with suspected renal failure
i.) Infectious disease patient
j.) Polytrauma patients'),
('23h','23h.4','23h.4.16','MRI: Magnetic Resonance Imaging (MRI) examination shall be performed by a qualified radiographer.
All MRIs should be reported by a radiologist or a specialist in their area of expertise.
There are policies and procedures addressing the safety, operations and maintenance of the MRI equipment.
There are guidelines for the handling of the following patients;
a.) Ambulatory
b.) On wheelchair and trolley
c.) Requiring oxygen support
d.) Critically ill on a ventilator
e.) Infants and children
f.) Patients with implants
g.) Patients with special needs
h.) Pregnant patient
i.) Patients with suspected renal failure
j.) Infectious disease patient
k.) Polytrauma patients'),
('23h','23h.4','23h.4.17','Darkroom: The Head of Radiology Services should ensure safety precautions are taken to provide an environment within the darkroom to address the safety aspects of staff and radiological films.
The darkroom or area/equipment shall be equipped with an effective exhaust system and adequate ventilation.
There should be measures to avoid films being accidentally exposed to light.'),
('23h','23h.4','23h.4.18','Picture Archiving and Communications Systems (PACS): There shall be adequate provisions with regards to the secure use, access and maintenance of the Picture Archiving and Communications System (PACS), both within and outside the Radiology Services/Department.
There is a policy to ensure safety and confidentially of images archived.'),
('23h','23h.4','23h.4.19','There are proper arrangements made for the labelling, storage and disposal of chemical waste.'),
('23h','23h.5','23h.5.1','There are planned activities for performance and quality improvement.'),
('23h','23h.5','23h.5.2','The Head of Radiology Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.'),
('23h','23h.5','23h.5.3','Specific performance indicators (among others) are tracked e.g.;
a.) Workload indicator summary for different imaging modalities.
b.) Number of rejected films (reject rate).'),
('23j','23j.1','23j.1.1','The Vision, Mission of the Facility are accessible. The Goals of the Operating Theatre Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.'),
('23j','23j.1','23j.1.2','There is a mechanism to ensure effective interaction between the Head of the Services or the Officer in Charge (OIC) and the Organisation’s Governing Body and Senior Management. The Head of Services shall also be involved for the following aspects of management of the services;
a.) Preparation of budget and ensuring that expenditure remains within the budget allocated
b.) Human resource
c.) Facility and equipment management
d.) Safety and performance improvement activities and risk management'),
('23j','23j.1','23j.1.3','Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the Operating Theatre Services. These meetings are minuted and communicated to all staff.'),
('23j','23j.1','23j.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care. The following (among others) are available;
a.) Workload/census for types of OT and nature of cases.
b.) Quarterly and annual report
c.) Incident reports and register
d.) Staffing number and staff profile
e.) Staff training records
f.) Data on performance improvement
g.) Intensive Care workload such as number of admissions, bed occupancy rate, ventilator days, average length of stay'),
('23j','23j.1','23j.1.5','There is a list of services provided to other Units in the Facility.'),
('23j','23j.1','23j.1.6','The records maintained by the Operating Suite Services are adequate for clinical, medicolegal, and evaluation purposes and include the following;
a.) Consent taken by surgeon and anaesthetist in writing and documented according to guidelines;
b.) A documented system for tissues/specimens sent for laboratory examination;
c.) A register of operations performed within the suite;
d.) Standard anaesthetic and drug administration records and regulations relating to the control of drugs;
e.) A record of the surgical procedure performed which shall also be written into the patient''s medical record.
(Each record contains details of the procedure and personnel involved, the dressings applied and drainage systems inserted, prostheses used, and the postoperative orders. Such entries in the records are signed with designation of the surgeon and dated accordingly.)'),
('23j','23j.1','23j.1.7','Documented evidence of the counting of accountable (e.g. gauze, instruments etc) items used and a copy of the record is included in the patient''s medical record.'),
('23j','23j.1','23j.1.8','Support services such as radiology, pathology, and blood bank are available. Effective communication and relationships with these services are maintained.'),
('23j','23j.2','23j.2.1','The are written and dated job descriptions for each category of staff that include:
a.) Qualification, training and experience for the position
b.) Lines of authority
c.) Accountability, functions and responsibilities
d.) Reviewed when required if there is major change in job scope
e.) Statutory regulations
f.) Administrative and clinical job scope'),
('23j','23j.2','23j.2.2','The Operating Theatre Services Nurse Manager has a postgraduate training in peri-operative nursing and has management skills.'),
('23j','23j.2','23j.2.3','All staff holds current registration with the relevant professional body.'),
('23j','23j.2','23j.2.4','The staff works within their job description and job scope.'),
('23j','23j.2','23j.2.5','There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice. This should include;
a.) New surgical, anaesthetic and OT procedures
b.) Regular fire and evacuation drills
c.) Resuscitation techniques
d.) Use of new equipment in surgical operations and its maintenance and calibration
e.) Infection prevention and control'),
('23j','23j.2','23j.2.6','The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.'),
('23j','23j.2','23j.2.7','In a Facility where undergraduate medical, nursing and allied health training programmes are conducted, the Facility shall ensure there are sufficient skilled trained staff to provide clinical supervision of students.'),
('23j','23j.2','23j.2.8','Staff including medical practitioners receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('23j','23j.2','23j.2.9','Where appropriate, the Facility shall endeavour to undertake clinical research using available resources.'),
('23j','23j.2','23j.2.10','Enough personnel and support staff with appropriate qualifications are employed to enable the services to meet the need of the services.'),
('23j','23j.2','23j.2.11','There is a structured orientation programme for all newly appointed staff to the Operating Theatre Services including medical practitioners and for those new to specific areas that include the following;
a.) Explanation of the goals, objectives, policies and procedures of the Facility and those of the Operating Theatre Services.
b.) Lines of authority and areas of responsibility.
c.) Explanation of duties and functions.
d.) Explanation of the methods of assigning clinical care and the standards of clinical practice.
e.) Handover communication.
f.) Processes for resolving practice/ethical dilemmas in a timely manner.
g.) Information about safety procedures.
h.) Training in basic/advanced life support techniques.
i.) Methods of obtaining appropriate resource materials.
j.) Staff appraisal procedures for the Operating Theatre services
k.) Education on Patient and Family Rights'),
('23j','23j.3','23j.3.1','There are written policies and procedures for the Operating Theatre Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.'),
('23j','23j.3','23j.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('23j','23j.3','23j.3.3','The policies and procedures documentation shall address at least the following topics;
a.) Description of the organisational structure of the OT Services
b.) The use of updated Standard Treatment Guidelines.
c.) Handover communication
d.) Drug prescription, dispensing and administration
e.) Blood transfusion
f.) Incident reports
g.) Infection Prevention and Control, including aseptic procedures, terminal cleaning and procedures for infectious patients
h.) Informed consent
i.) Handling and disposal of sharps
j.) Prevention of anaesthetic equipment hazards
k.) Maintenance of scavenging equipment for removal of various vapours and anaesthetic gases
l.) Patient identification, with the nature and site of the operation marked and verified by the surgeon and the consent documents checked
m.) Counting procedures for accountable items including the procedures to be adopted in the event of incorrect counts
n.) Patient management during recovery from anaesthesia and surgery
o.) The role of the OT Services in the fire and disaster plans of the Facility
p.) Priorities in the use of OT time and space
q.) "Group Cross Match" and "Screen and hold" policy for blood transfusion practices for patients undergoing surgery
r.) Clear communication lines for obtaining emergency blood and blood products for cases of unexpected haemorrhage.
s.) Clear written policies and procedure for the involvement of vendor in providing specialized equipment/consumables for patient care in the OT where applicable'),
('23j','23j.3','23j.3.4','The service shall operate on a 24-hour basis providing level of care appropriate to the facility.'),
('23j','23j.4','23j.4.1','The design of the Operating Suite Services provides adequate space for the reception, anaesthesia induction, surgery, post-surgical recovery and observation of patients. This shall include;
a.) Suitable areas for reception and for patients awaiting surgery
b.) Operating theatres
c.) Recovery area
d.) Adequate storage space for equipment, surgical supplies, linen, housekeeping equipment, and pharmaceutical supplies, including dangerous and psychotropic drugs
e.) Areas for administrative office, and where required, teaching facilities
f.) Areas for the collection and disposal of used equipment and waste;
g.) Male and female staff change rooms;
h.) Staff facilities like pantry, locker area, on-call room;
i.) There is plan for providing improved staff facilities when the Facility undergoes refurbishment or redevelopment if any of the above are deemed inadequate.'),
('23j','23j.4','23j.4.2','The design of the Operating Suite Services supports efficient systems for the management of perioperative services which include;
a.) Operating rooms are treated as "clean" rooms.
b.) Fire alarm and fire-fighting equipment and appropriate sign posting.
c.) Ventilation system should provide positive pressure from the cleanest areas to less clean area
d.) Definitive traffic flow patterns and demarcation of sterile and non-sterile zones.
e.) Ready access for routing emergency patients
f.) Free movement of patient trolleys throughout the suite with a minimum of cross traffic.
g.) Reception of the patient near the junction of sterile and non-sterile zones (air-lock zone);
h.) Uninterrupted power supply (UPS) system in operating theatres shall be provided with an alarm system at the reception counter which will be triggered when the system is not charged.
i.) The medical gas system in the operating theatres shall be monitored to ensure that it is functioning.
j.) Colour coding for electrical outlets shall be according to international standards.'),
('23j','23j.4','23j.4.3','Perioperative services must have the following systems;
a.) Adequate numbers of general power outlets distributed according to needs of each area.
b.) Adequate provision for emergency power outlets for lighting and suction of an appropriate nature.
c.) Suitable lighting.
d.) Adequate medical gas and suction supplies
e.) A means of environmental control of temperature and humidity within safe limits for anaesthetised patients undergoing surgery/procedures.'),
('23j','23j.4','23j.4.4','The Operating Suite Services shall comply with all safety features in accordance with regulatory requirements which include;
a.) Scavenging of anaesthetic gases and vapours
b.) Regular maintenance and monitoring of facilities and equipment, and a system to respond immediately to breakdown, repair, and replacement;
c.) Electrical equipment which complies with Standards
d.) Appropriate shielding and protective clothing are provided in the presence of biohazards or radiographic equipment.'),
('23j','23j.4','23j.4.5','The requirements for equipment used in the Operating Suite Services shall include the following;
a.) A range of basic and general surgical equipment in quantities sufficient to support the surgical programme
b.) Where specialised equipment appropriate to the surgical procedure is provided by the surgeon, such equipment shall have prior approval by the Person in Charge (PIC) of the Facility and shall be checked to comply with the relevant safety requirements and be appropriately sterilised before use
c.) Emergency and resuscitation equipment and supplies with clearly defined instructions on how to operate the equipment and there is evidence that staff are trained to use the equipment
d.) Availability of point of care testing equipment for urgent laboratory tests (e.g. Arterial Blood Gas investigation) OR process to ensure that results of such tests sent to the laboratory can be reported immediately
e.) There are refrigerator or alternative storage facilities for group and cross matched blood in the operating room'),
('23j','23j.4','23j.4.6','Suitable forms of communication systems and equipment are provided to enable clinical staff to communicate among themselves and with the other members of the healthcare team.'),
('23j','23j.4','23j.4.7','Equipment, both for emergency and non-emergency usage, shall be appropriate to the level of care.'),
('23j','23j.4','23j.4.8','There is evidence that the facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order.'),
('23j','23j.4','23j.4.9','Where specialised equipment is used, there is evidence that only staff who are trained and authorised by the Facility operate such equipment.'),
('23j','23j.4','23j.4.10','At the Outpatient Specialist Clinic, adequate numbers of rooms are provided to ensure patient privacy and confidentiality for various patient care activities including;
a.) Consultation (not more than one patient in a room at any time).
b.) Minor procedures and nursing procedures.
c.) Performance of various tests.'),
('23j','23j.5','23j.5.1','There are planned activities for performance and quality improvement.'),
('23j','23j.5','23j.5.2','The Head of Operating Theatre Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.'),
('23j','23j.5','23j.5.3','Specific performance indicators (among others) are tracked e.g.;
a.) Election operation cancellation rate
b.) Percentage of patients returning to surgery within 24 hours'),
('23k','23k.1','23k.1.1','The Vision, Mission of the Facility are accessible. The Goals of the HDU/ICU Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the community.'),
('23k','23k.1','23k.1.2','There is a mechanism to ensure effective interaction between the Head of the Services and the Organisation’s Governing Body and Senior Management.
The Head of Services shall also be involved for the following aspects of management of the services;
i. Preparation of budget and ensuring that expenditure remains within the budget allocated
ii. Human Resources
iii. Facility and Equipment Management
iv. Safety and performance improvement activities and risk management'),
('23k','23k.1','23k.1.3','Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the HDU/ICU Services. These meetings are minuted and communicated to all staff.'),
('23k','23k.1','23k.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care.
The following (among others) are available:
a. Workload/census for types of anaesthesia and nature of surgeries.
b. Quarterly and annual report
c. Incident reports and register
d. Staffing number and staff profile
e. Staff training records
f. Data on performance improvement
g. Number of referrals to the HDU/ICU
h. Intensive Care workload such as number of admissions, bed occupancy rate, ventilator days, average length of stay'),
('23k','23k.1','23k.1.5','There is a list of services provided to other Units in the Facility.'),
('23k','23k.2','23k.2.1','The are written and dated job descriptions for each category of staff that include:
a. Qualification, training and experience for the position
b. Lines of authority
c. Accountability, functions and responsibilities
d. Reviewed when required if there is major change in job scope
e. Statutory regulations
f. Administrative and clinical job scope'),
('23k','23k.2','23k.2.2','The staff holds current registration with the relevant professional body.'),
('23k','23k.2','23k.2.3','The staff works within their job description and job scope.'),
('23k','23k.2','23k.2.4','There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice.'),
('23k','23k.2','23k.2.5','The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.'),
('23k','23k.2','23k.2.6','In a Facility where undergraduate medical, nursing and allied health training programmes are conducted, the Facility shall ensure there are sufficient skilled trained staff to provide clinical supervision of students.'),
('23k','23k.2','23k.2.7','Staff including medical practitioners receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('23k','23k.2','23k.2.8','Where appropriate, the Facility shall endeavour to undertake clinical research using available resources.'),
('23k','23k.2','23k.2.9','There should be sufficient numbers of personnel and support staff with appropriate qualifications who are employed to meet the need of the services as follows:
a. A resident medical officer trained in anaesthesia/ICU is appointed to be predominantly present in the unit after office hours for Level 2 and 3 ICUs
b. a nursing sister in-charge of the unit is appointed and has qualification in post basic nursing appropriate for the unit
c. a nursing staff with post basic appropriate for the unit is in-charge of the unit each shift
d. a minimum percentage of nurses trained in intensive care nursing in the unit;
• 30% for Level 2 Care
• 50% for Level 3 Care
e. nurse/patient ratio of 1:1 for ventilated patient
f. nurse/patient ratio of 1:2 for non-ventilated patient
g. a biomedical technician is available on 24 -hour basis
h. cleaning personnel familiar with ICU environment and infection control/ environmental cleaning protocols are available on 24- hour basis
i. for Level 2 and 3 Care, physiotherapist and dietitian are available during working hours'),
('23k','23k.2','23k.2.10','There is a structured orientation programme for all newly appointed staff to the HDU/ICU including medical practitioners and for those new to specific areas that include the following:
a. Explanation of the goals, objectives, policies and procedures of the Facility and those of the HDU/ICU services
b. Lines of authority and areas of responsibility
c. Explanation of duties and functions
d. Explanation of the methods of assigning clinical care and the standards of clinical practice
e. Handover communication
f. Processes for resolving practice/ethical dilemmas in a timely manner
g. Information about safety procedures
h. Training in basic/advanced life support techniques
i. Methods of obtaining appropriate resource materials
j. Staff appraisal procedures for the HDU/ICU services.
k. Education on Patient and Family Rights'),
('23k','23k.3','23k.3.1','There are written policies and procedures for the ICU/HDU Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.'),
('23k','23k.3','23k.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('23k','23k.3','23k.3.3','The policies and procedures documentation shall address at least the following topics:
a. Operational policy
b. Admission, discharge and referral
c. Visitation policy
d. Credentialing and privileging on special procedures, e.g. mechanical ventilation, renal replacement therapy;
e. Clinical management protocol, e.g. weaning from mechanical ventilation, thromboprophylaxis,
f. Drug administration
g. Procedural policy, e.g. central line catheterisation;
h. Antibiotic policy
i. Infection control
j. Needle stick injury
k. Transport of patients
l. Withholding and withdrawal of therapy'),
('23k','23k.3','23k.3.4','The service shall operate on a 24- hour basis providing level of care appropriate to the facility.'),
('23k','23k.3','23k.3.5','The service shall ensure that provision of patient care and services achieve effective outcomes and is safe.'),
('23k','23k.3','23k.3.6','There is a standarised patient medical record. This record should have the following:
a. An identification page with patient’s weight and immunisation status.
b. ICU monitoring sheet
c. Patient history
d. Clinical notes
e. Consent form
f. Diagnostic reports
g. Final diagnosis and code at time of discharge
h. Drug order/medication sheet
i. Operating theatre sheet (if appropriate)
j. Allergy  and adverse reaction documentation
k. Behaviour issues that may pose a risk.
l. Discharge summary
m. Referral form (if applicable)'),
('23k','23k.4','23k.4.1','There are adequate and appropriate facilities and equipment with proper utilisation of space to enable staff to carry out their professional, teaching and administrative functions.
The HDU/ICU services should be in an area close to areas which have the greatest requirement for its services, such as the Operating Theatre, Emergency Department etc.'),
('23k','23k.4','23k.4.2','Existing facilities shall consider the safety and comfort of staff and patients.'),
('23k','23k.4','23k.4.3','There shall be provision for isolation of different categories of patients, e.g. those with airborne infectious disease:
a. Isolation room with its own wash basin, en-suite, ante room of at least 2.5m2 and control of airflow
b. Level 2 Care: Negative pressure isolation room'),
('23k','23k.4','23k.4.4','Suitable forms of communication systems and equipment are provided to enable clinical staff to communicate among themselves and with the other members of the healthcare team.'),
('23k','23k.4','23k.4.5','There are facilities for patients, staff and relatives.
a. Rest room for staff
b. Counselling room for relatives
c. Waiting area for relatives'),
('23k','23k.4','23k.4.6','The ICU/HDU shall have 24-hour access to on-site laboratory services such as:
a. Point of care testing, e.g. blood gas, glucose, etc.;
b. Laboratory test results i.e. full blood count, urinalysis, biochemistry (electrolytes, urea, creatinine, calcium), coagulation profile and lactate
c. Laboratory test results i.e. osmolality, serum magnesium and phosphorus and toxicology screening
d. Culture and Gram-stain results are available 24 hours a day.'),
('23k','23k.4','23k.4.7','The ICU/HDU services shall have 24- hour access to Radiology/Diagnostic Imaging services and blood bank services.'),
('23k','23k.4','23k.4.8','There are adequate numbers of vacuum outlets, oxygen and compressed air outlets, and suction facilities as well as properly grounded electrical outlets with duplicate or independent circuits available to every patient.
a. Minimum 12 electrical outlets per bed for Level 1 Care
b. Minimum 16 electrical outlets per bed for Level 2 and 3 Care
c. Minimum 2 vacuum outlets per bed for Level 2 Care
d. Minimum 3 vacuum outlets per bed for Level 3 Care
e. Minimum 2 oxygen outlets per bed for Level 2 Care
f. Minimum 3 oxygen outlets per bed for Level 3 Care
g. Minimum 2 compressed air outlets per bed for Level 2 Care
h. Minimum 3 compressed air outlets per bed for Level 3 Care'),
('23k','23k.4','23k.4.9','The ICU/HDU beds are readily adjustable to various therapeutic positions, easily moved for transport and with locking mechanisms for a secure stationary position, side-rails, and removable headboard'),
('23k','23k.4','23k.4.10','The equipment for monitoring as well as intervention shall be appropriate to the Level of Care provided by the unit as follows:
a. For Level 1 Care, monitoring equipment with trending capability and visible and audible alarms with simultaneous display of electrocardiography (ECG), non-invasive pressure, temperature and pulse oximetry.
b. For Level 2 and 3 Care, monitoring equipment with modular systems, trending capability and visible and audible alarms with simultaneous display of 4 waveforms and selectable digital values for ECG, non-invasive pressure, temperature, pulse oximetry, arterial pressure, central venous pressure, intra- cranial pressure and capnography.'),
('23k','23k.4','23k.4.11','Facilities and equipment are appropriate to the Services and shall include the following:
a. Uninterrupted power supply system
b. Central air conditioning system which allows control of temperature, humidity and air exchange according to relevant standards. Recirculated air shall pass through appropriate filters with 99% filtration efficiency
c. An alarm system for HDU/ICU personnel to summon additional staff in an emergency
d. Variable lighting systems for day and night mode and high illumination and spot lighting for procedures
e. Alternate emergency lighting, gas and power sources or other appropriate mechanisms available to operate all life support systems including suction apparatus
f. Adequate supplies of medications and intravenous fluids available 24 hours a day in the unit
g. Hand ventilating assemblies
h. Suction apparatus
i. Vascular access equipment including access to ultrasound for placement of intravascular catheters
j. Equipment to control patient temperature
k. Chest drainage equipment
l. Portable transport equipment
m. Lifting/weighing equipment including apparatus for mobilizing patients early out of bed, e.g. hoist, rehabilitation chair, walking frame
n. Sufficient number of volumetric and syringe pumps appropriate to the Level of Care
o. For Level 2 and 3 Care, invasive and non-invasive ventilators appropriate to the Level of Care provided
p. For Level 3 Care, renal replacement therapy services are available 24 hours per day'),
('23k','23k.4','23k.4.12','All other emergency and life support equipment are readily accessible and functional, including airway access equipment to assist with management of the difficult airway.'),
('23k','23k.4','23k.4.13','There is evidence that the facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order.'),
('23k','23k.4','23k.4.14','Where specialised equipment is used, there is evidence that only staff who are trained and authorised by the Facility operate such equipment.'),
('23k','23k.5','23k.5.1','There are planned activities for performance and quality improvement.'),
('23k','23k.5','23k.5.2','The Head of ICU/HDU shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.'),
('23k','23k.5','23k.5.3','Specific performance indicators (among others) are tracked. For example;
• Rate of pressure ulcers
• Rate of unplanned extubation'),
('23l','23l.1','23l.1.1','The Vision, Mission of the Facility are accessible. The Goals of the CSSD Services suit its scope and are clearly documented. It should reflect the aspirations of the service and the needs of the Facility.'),
('23l','23l.1','23l.1.2','There is a mechanism to ensure effective interaction between the Head of the Services and the Organisation’s Governing Body and Senior Management.
The Head of Services shall also be involved for the following aspects of
management of the services:
a.) Preparation of budget and ensuring that expenditure remains within the budget allocated
b.) Human resource
c.) Facility and equipment management
d.) Safety and performance improvement activities and risk management'),
('23l','23l.1','23l.1.3','Regular staff meetings are held between Head of Service and staff with sufficient regularity to discuss issues pertaining to the CSSD Services. These meetings are minuted and communicated to all staff.'),
('23l','23l.1','23l.1.4','Appropriate statistics and records are maintained in the department in and used for managing services and patient care.
The following (among others) are available:
a.) Workload/census
b.) Quarterly and annual report
c.) Incident reports and register
d.) Staffing number and staff profile
e.) Staff training records
f.) Data on performance improvement'),
('23l','23l.1','23l.1.5','There is a list of services provided to other Units in the Facility.'),
('23l','23l.2','23l.2.1','The Head and staff of CSSD shall be a healthcare professional with training and experience and shall be responsible to coordinate all (on-site or off-site) disinfection and sterilisation processes in the Facility. He/she should minimally have training in perioperative care with CSSD modules.
There are written and dated job descriptions for each category of staff that include;
a.) Qualification, training and experience for the position.
b.) Lines of authority
c.) Accountability, functions and responsibilities'),
('23l','23l.2','23l.2.2','The staff holds current registration with the relevant professional body.'),
('23l','23l.2','23l.2.3','The staff works within their job description and job scope.'),
('23l','23l.2','23l.2.4','There are continuing education activities for staff to pursue professional interests and to prepare for current and future changes in practice.'),
('23l','23l.2','23l.2.5','The educational needs of staff are addressed following findings from incidents reports, mortality audits and performance improvement studies.'),
('23l','23l.2','23l.2.6','In a Facility where undergraduate medical, nursing and allied health training programmes are conducted, the Facility shall ensure there are sufficient skilled trained staff to provide clinical supervision of students.'),
('23l','23l.2','23l.2.7','Staff including medical practitioners receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Organisation.'),
('23l','23l.2','23l.2.8','Where appropriate, the Facility shall endeavour to undertake clinical research using available resources.'),
('23l','23l.2','23l.2.9','Enough personnel and support staff with appropriate qualifications are employed to meet the need of the services.'),
('23l','23l.2','23l.2.10','There is a structured orientation programme for all newly appointed staff to the CSSD Services including medical practitioners and for those new to specific areas that include the following;
a.) Explanation of the goals, objectives, policies and procedures of the Facility and those of the CSSD Services
b.) Lines of authority and areas of responsibility
c.) Explanation of duties and functions
d.) Explanation of the methods of assigning clinical care and the standards of clinical practice
e.) Handover communication
f.) Processes for resolving practice/ethical dilemmas in a timely manner
g.) Information about safety procedures
h.) Training in basic/advanced life support techniques
i.) Methods of obtaining appropriate resource materials
j.) Staff appraisal procedures for the CSSD Services'),
('23l','23l.2','23l.2.11','There is a vaccination programmes for all staff exposed to sharps injury and biological hazards.'),
('23l','23l.3','23l.3.1','There are written policies and procedures for the CSSD Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices.'),
('23l','23l.3','23l.3.2','Policies and procedures are developed by a committee in collaboration with staff and with other departments if needed.'),
('23l','23l.3','23l.3.3','The policies and procedures documentation shall address at least the following topics;
a.) Receiving and decontamination processes (disassembling, washing, cleaning and disinfection);
b.) Packaging process (inspection, functionality check and packing)
c.) Sterilisation process
d.) Validation processes
e.) Sterile storage and distribution
f.) Traceability and product recall
g.) Services provided to other healthcare facilities
h.) Environmental control (storage condition, effective maintenance of sterility)
i.) Management of sterile items (event related or shelf life)
j.) Safety practices in CSSD
k.) Utilisation of autoclave'),
('23l','23l.3','23l.3.4','Disinfection and sterilising processes in other services, e.g. Dental Services, Operating Theatre Endoscopy, Cardiovascular Invasive Laboratory, etc should be consistent with the requirements of policies and procedures of the CSSD.'),
('23l','23l.3','23l.3.5','Records for all activities in the processing of sterile items shall be maintained for a period as per policy of the healthcare facility.'),
('23l','23l.4','23l.4.1','The design and set up of the CSSD allows for;
a.) The CSSD to be equipped and arranged to provide proper separation of clean and dirty routes and processes with clear demarcation of the different zones. The airflow is from clean to soiled areas.
b.) Areas within CSSD shall be adequate to provide for;
i. Receiving of unsterile supplies
• Handling of supplies and equipment in accordance with planned stores and supply system and parking of carts.
• Facilities for receiving, disassembling and cleaning of supplies and equipment shall be appropriately located avoiding non-sterile items passing through sterile areas of the CSSS.
ii. Assembling and Packaging
• Facilities for assembling, packaging supplies and equipment shall have hand hygiene facilities, work counter or its equivalent as required by types and volume of items.
iii. Sterilising
• Facilities for sterilising shall be located between packaging area and sterile storage area.
• An exhaust is installed over the back room of sterilisers to prevent condensation and heat building up.
• A designated cooling area with good ventilation to allow cooling of sterilised items.
iv. Storage Facilities
• Dedicated store for storage and issue of sterile instruments and supplies
• Facilities for storage and issues of unsterilised linen for sterilisation.
• Facilities for storage and issue of unsterile instruments,
• Facilities for storage and issue of chemical detergents and disinfectants
• Facilities for storage of soft goods
• Facilities for storage (sterilisation wrapping paper, autoclave tape etc.
c.) Hand washing facilities
d.) Staff changing room are readily available
e.) Suitably planned layout of work benches and equipment'),
('23l','23l.4','23l.4.2','Where specialised equipment is used, there is evidence that only staff who are trained and authorised by the Facility operate such equipment, e.g. autoclave.'),
('23l','23l.4','23l.4.3','There is evidence that the Facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order.'),
('23l','23l.5','23l.5.1','There are planned activities for performance and quality improvement.'),
('23l','23l.5','23l.5.2','The Head of CSSD Services shall ensure that the staff are trained and complete incident reports which are promptly reported, investigated, discussed by the staff and forwarded to the Officer in Charge (OIC) of the Facility. Selected incidents have Root Cause Analysis (RCA) done in an agreed time frame to prevent recurrence.'),
('23l','23l.5','23l.5.3','Specific performance indicators (among others) are tracked e.g.
a.) Percentage of sterile equipment rejected
b.) Percentage of incident reports with RCA done');
CREATE TEMP TABLE import_e (standard_number text NOT NULL, criterion_number text NOT NULL, compliance_number text NOT NULL, number text NOT NULL, summary text NOT NULL) ON COMMIT DROP;
INSERT INTO import_e VALUES
('23g','23g.1','23g.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('23g','23g.1','23g.1.1','2','There is an endorsed and dated department Organisational chart with lines of functions and reporting relationships.'),
('23g','23g.1','23g.1.1','3','Relevant policies are available in the department. (National Health Plan, National Health Service Standards, etc.).'),
('23g','23g.1','23g.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('23g','23g.1','23g.1.1','5','Evidence of fee structure (if fees are collected).'),
('23g','23g.1','23g.1.2','1','Letter of appointment and terms of reference as the Head of Service'),
('23g','23g.1','23g.1.2','2','Letter of appointment and terms of reference in other hospital committees.'),
('23g','23g.1','23g.1.2','3','Evidence of (a) to (d) in meeting minutes/correspondence of the Otorhinolaryngology Services indicating the involvement of the Head of Service.'),
('23g','23g.1','23g.1.2','4','Request for allocation for budget and staffing.'),
('23g','23g.1','23g.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff.'),
('23g','23g.1','23g.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service.'),
('23g','23g.1','23g.1.3','3','Frequency of meetings are as scheduled.'),
('23g','23g.1','23g.1.3','4','Discussions and resolutions are implemented (problems not solved are brought forward to the next meeting till resolved).'),
('23g','23g.1','23g.1.4','1','The statistics and records from (a) to (f) are available.'),
('23g','23g.1','23g.1.4','2','The NHSS Toolkit Assessment (checklist) for the relevant level has been completed in the past 6 months.'),
('23g','23g.2','23g.2.1','1','There are dated and specific job descriptions for each staff that include (a) to (f).'),
('23g','23g.2','23g.2.1','2','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('23g','23g.2','23g.2.1','3','The scope of work in the job description aligns with the training, skill and experience of the staff (credentialling)'),
('23g','23g.2','23g.2.2','1','Evidence of current registration for all cadres of staff (annual practicing certificate).'),
('23g','23g.2','23g.2.3','1','Observation that cadres of staff are working according to their job description and job scope.'),
('23g','23g.2','23g.2.4','1','Training calendar includes in-house/ external courses/ workshops/ conferences.'),
('23g','23g.2','23g.2.4','2','Training for each staff including training in life support is kept in the Department.'),
('23g','23g.2','23g.2.4','3','There are ongoing Continuous Professional Activities in the Department.'),
('23g','23g.2','23g.2.5','1','Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.'),
('23g','23g.2','23g.2.6','1','Evidence of sufficient skilled trained staff to provide clinical supervision as per terms of Memorandum of Understanding.'),
('23g','23g.2','23g.2.7','1','Performance appraisal for staff, including medical practitioners, is completed upon probationary period and as an annual exercise.'),
('23g','23g.2','23g.2.8','1','Documented evidence of research activities in the Department.'),
('23g','23g.2','23g.2.9','1','Planning of staff allocation and movement within the Department includes the following;
a.) Deployment based on staff to patient ratio, bed occupancy rate and complexity of cases.
b.) Special skills/training of staff.
c.) Contingency plan for acute shortage.
d.) Duty roster.
e.) Evidence that all clinicians re not made to work more than the stipulated hours.'),
('23g','23g.2','23g.2.10','1','Evidence of policy stating that all staff have to attend a structured orientation programme.'),
('23g','23g.2','23g.2.10','2','Attendance list of those having attended the orientation programme.'),
('23g','23g.3','23g.3.1','1','Evidence of documented policies and procedures for the service.'),
('23g','23g.3','23g.3.1','2','The policies and procedures are endorsed and dated.'),
('23g','23g.3','23g.3.1','3','There is a periodic review at least once in three years.'),
('23g','23g.3','23g.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference.'),
('23g','23g.3','23g.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('23g','23g.3','23g.3.3','1','Documented policies and procedures that address (a) to (s).'),
('23g','23g.3','23g.3.3','2','Staff are briefed on the policies and procedures (meeting minutes or circulation acknowledgement).'),
('23g','23g.3','23g.3.4','1','Operational policy on 24-hour service.'),
('23g','23g.3','23g.3.4','2','Staffing level reflects a good mix of senior and junior staff.'),
('23g','23g.3','23g.3.4','3','On call roster is dated and authorised.'),
('23g','23g.3','23g.3.5','1','Relevant updated Standard Treatment Guidelines are available in the division.'),
('23g','23g.3','23g.3.5','2','Patient register is updated daily.'),
('23g','23g.3','23g.3.5','3','Evidence of appropriate admission process.'),
('23g','23g.3','23g.3.5','4','Evidence of in-patient and guardian orientation process during admission.'),
('23g','23g.3','23g.3.5','5','Evidence of initial assessment and provisional diagnosis.'),
('23g','23g.3','23g.3.5','6','Evidence and documentation of morning and evening rounds.'),
('23g','23g.3','23g.3.5','7','Evidence of regular vital sign documentation.'),
('23g','23g.3','23g.3.5','8','Documentation of discussions with patient/family/guardian about the patient’s condition.'),
('23g','23g.3','23g.3.5','9','Evidence of discussions with other disciplines and referrals if necessary.'),
('23g','23g.3','23g.3.5','10','Evidence of patient handover during shift change (documentation and observed).'),
('23g','23g.3','23g.3.5','11','Evidence of documented informed consent for procedures.'),
('23g','23g.3','23g.3.5','12','Evidence of flowchart on patient deterioration or “Code Blue” procedures.'),
('23g','23g.3','23g.3.5','13','Discharge summaries are issued to patients on discharge with a care plan.'),
('23g','23g.3','23g.3.5','14','Evidence of a patient referral register.'),
('23g','23g.3','23g.3.6','1','Patient’s medical record has elements (a) to (m).'),
('23g','23g.3','23g.3.6','2','The Patient’s medical record has a unique identifier (MRN).'),
('23g','23g.3','23g.3.6','3','Evidence of clinical documentation which is signed, dated and with legible writing.'),
('23g','23g.3','23g.3.6','4','Evidence of use of appropriate abbreviations.'),
('23g','23g.4','23g.4.1','1','The building is sound and there is adequate space to match the services.'),
('23g','23g.4','23g.4.1','2','Appropriate type of equipment to match the complexity of services.'),
('23g','23g.4','23g.4.1','3','Adequate facilities and equipment at each patient care area for safe care. (e.g. defibrillators, emergency trolley, hand washing facilities etc).'),
('23g','23g.4','23g.4.1','4','Easy access and clear (unblocked) exit routes.'),
('23g','23g.4','23g.4.1','5','Absence of overcrowding.'),
('23g','23g.4','23g.4.1','6','Availability of an isolation area.'),
('23g','23g.4','23g.4.1','7','There are lights/lamps/solar for blackouts.'),
('23g','23g.4','23g.4.1','8','There is good ventilation within the ward/s.'),
('23g','23g.4','23g.4.1','9','There is running water in the facility'),
('23g','23g.4','23g.4.1','10','Waste is segregated at the facility at the point of generation.'),
('23g','23g.4','23g.4.2','1','Design and layout of the unit, e.g. wards, treatment rooms, dirty and clean utility rooms, access, lighting, signage, etc. address the safety aspects of patients and staff.'),
('23g','23g.4','23g.4.2','2','Equipment should have scheduled planned preventive maintenance (PPM).'),
('23g','23g.4','23g.4.2','3','There is access to hand washing facilities.'),
('23g','23g.4','23g.4.2','4','Mattresses are covered with waterproof coverings and there is clean linen on every bed.'),
('23g','23g.4','23g.4.2','5','Sharps are disposed properly.'),
('23g','23g.4','23g.4.2','6','There is a designated area in the ward for ill patients who require extra supervision.'),
('23g','23g.4','23g.4.3','1','Appropriate telecommunication modalities available for daily operation and during emergencies.'),
('23g','23g.4','23g.4.4','1','There is up-to-date documentation of the total number of beds (overnight and day-only beds).'),
('23g','23g.4','23g.4.4','2','Evidence that any patient who occupies a bed for more than 4 hours and receives significant clinical care is classified as an “in-patient”.'),
('23g','23g.4','23g.4.4','3','Factors such as “bed occupancy rates” and “average length of stay” are monitored and analysed.'),
('23g','23g.4','23g.4.5','1','Floor plan indicates accessibility and patient and user friendly.'),
('23g','23g.4','23g.4.5','2','Feedback from patient satisfaction survey.'),
('23g','23g.4','23g.4.5','3','Incident reporting relating to facilities if any.'),
('23g','23g.4','23g.4.5','4','Toilets have wheelchair access.'),
('23g','23g.4','23g.4.6','1','Availability of emergency and non-emergency equipment appropriate to level of care, such as defibrillator, emergency trolley, suction machine, electrocardiogram (ECG) machine, infusion or syringe pump, vital sign monitor, pulse oximeter, oxygen concentrator etc.'),
('23g','23g.4','23g.4.6','2','Scheduled checking of items in emergency trolley.'),
('23g','23g.4','23g.4.6','3','There are adequate patient transfer trolleys, wheelchairs, mobility aids and a dedicated drug fridge.'),
('23g','23g.4','23g.4.6','4','There is a dedicated cabinet for dangerous drugs which can be locked.'),
('23g','23g.4','23g.4.7','1','Planned Preventive Maintenance records such as schedule, stickers, etc.'),
('23g','23g.4','23g.4.7','2','Planned Replacement Programme where applicable.'),
('23g','23g.4','23g.4.7','3','Complaint records.'),
('23g','23g.4','23g.4.7','4','Asset inventory.'),
('23g','23g.4','23g.4.8','1','User training records.'),
('23g','23g.4','23g.4.8','2','List of staff trained and authorised to operate specialised equipment.'),
('23g','23g.4','23g.4.9','1','Evidence of list of services available and offered to patients.'),
('23g','23g.4','23g.4.9','2','Flow chart on work process.'),
('23g','23g.4','23g.4.9','3','Safe keeping of medical records.'),
('23g','23g.4','23g.4.9','4','Clinic appointment system.'),
('23g','23g.4','23g.4.9','5','Security of data in Health Information System.'),
('23g','23g.4','23g.4.9','6','Monitoring of waiting time.'),
('23g','23g.4','23g.4.9','7','Adequate and appropriate signage.'),
('23g','23g.4','23g.4.9','8','Floor plan indicates accessibility to supporting services and optimisation of space.'),
('23g','23g.4','23g.4.9','9','Adequate patient personal use items, e.g. wheelchair, mobility aids etc.'),
('23g','23g.4','23g.4.9','10','Adequate waiting area, toilets and reading material.'),
('23g','23g.4','23g.4.9','11','Evidence of data collected as per point (i).'),
('23g','23g.4','23g.4.10','1','Evidence of facilities with patient privacy ensured.'),
('23g','23g.4','23g.4.10','2','Procedure room appropriately equipped.'),
('23g','23g.4','23g.4.10','3','Patient monitoring device is available where required (vital signs).'),
('23g','23g.4','23g.4.10','4','List of procedures performed.'),
('23g','23g.4','23g.4.10','5','The following equipment are available (slit lamp bio microscope, ophthalmoscopes).'),
('23g','23g.5','23g.5.1','1','There is a designated person who monitors safety and performance improvement activities within the Psychiatry Services.'),
('23g','23g.5','23g.5.1','2','There are records/registers on performance improvement activities.'),
('23g','23g.5','23g.5.1','3','There are meeting minutes for performance improvement meetings.'),
('23g','23g.5','23g.5.1','4','There are records on innovation (if any)'),
('23g','23g.5','23g.5.2','1','System for incident reporting is in place with the following;
a.) Training of staff in incident reporting
b.) Policy on incident reporting
c.) Method/SOP on Incident reporting
d.) Register of incidents'),
('23g','23g.5','23g.5.2','2','Completed incident reports.'),
('23g','23g.5','23g.5.2','3','Corrective and preventive action plans.'),
('23g','23g.5','23g.5.2','4','Minutes of meeting.'),
('23g','23g.5','23g.5.2','5','Involved staff given feedback about the incident report.'),
('23g','23g.5','23g.5.2','6','Acknowledgment by Head of Otorhinolaryngology Service and Director of Curative Services.'),
('23g','23g.5','23g.5.3','1','Specific performance indicators are monitored.'),
('23g','23g.5','23g.5.3','2','Remedial action is taken when appropriate.'),
('23h','23h.1','23h.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('23h','23h.1','23h.1.1','2','There is an endorsed and dated department Organisational chart with lines of functions and reporting relationships.'),
('23h','23h.1','23h.1.1','3','Relevant policies are available in the department. (National Health Plan, National Health Service Standards, etc.).'),
('23h','23h.1','23h.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('23h','23h.1','23h.1.1','5','Evidence of fee structure (if fees are collected).'),
('23h','23h.1','23h.1.2','1','Letter of appointment and terms of reference as the Head of Service.'),
('23h','23h.1','23h.1.2','2','Letter of appointment and terms of reference in other hospital committees.'),
('23h','23h.1','23h.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff.'),
('23h','23h.1','23h.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service.'),
('23h','23h.1','23h.1.3','3','Frequency of meetings are as scheduled.'),
('23h','23h.1','23h.1.3','4','Discussions and resolutions are implemented. (problems not solved are brought forward to the next meeting till resolved).'),
('23h','23h.1','23h.1.4','1','The statistics and records from (a) to (f) are available.'),
('23h','23h.1','23h.1.5','1','Attendance in department/facility-wide mortality and morbidity meetings or conferences.'),
('23h','23h.1','23h.1.5','2','Participation in interdepartmental clinical radiological discussion/conference and multidisciplinary meetings.'),
('23h','23h.2','23h.2.1','1','There are dated and specific job descriptions for each staff that include (a) to (f).'),
('23h','23h.2','23h.2.1','2','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('23h','23h.2','23h.2.1','3','The scope of work in the job description aligns with the training, skill and experience of the staff (credentialling)'),
('23h','23h.2','23h.2.2','1','Evidence of current registration for all cadres of staff (annual practicing certificate).'),
('23h','23h.2','23h.2.3','1','Qualified radiographer to carry out radiographic procedures.'),
('23h','23h.2','23h.2.3','2','Credentialling processes are in place.'),
('23h','23h.2','23h.2.4','1','Duty roster of the Department.'),
('23h','23h.2','23h.2.4','2','On call roster.'),
('23h','23h.2','23h.2.5','1','Training calendar includes in-house/ external courses/ workshops/ conferences.'),
('23h','23h.2','23h.2.5','2','Training for each staff including training in life support is kept in the Department.'),
('23h','23h.2','23h.2.5','3','There are ongoing Continuous Professional Activities in the Department.'),
('23h','23h.2','23h.2.6','1','Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.'),
('23h','23h.2','23h.2.7','1','Evidence of sufficient skilled trained staff to provide clinical supervision as per terms of Memorandum of Understanding.'),
('23h','23h.2','23h.2.8','1','Performance appraisal for staff including medical practitioners is completed upon probationary period and as an annual exercise.'),
('23h','23h.2','23h.2.9','1','Documented evidence of research activities in the Department or involvement in research projects.'),
('23h','23h.2','23h.2.10','1','Evidence of policy stating that all staff have to attend a structured orientation programme.'),
('23h','23h.2','23h.2.10','2','Attendance list of those having attended the orientation programme.'),
('23h','23h.3','23h.3.1','1','Evidence of documented policies and procedures for the service.'),
('23h','23h.3','23h.3.1','2','The policies and procedures are endorsed and dated.'),
('23h','23h.3','23h.3.1','3','There is a periodic review at least once in three years.'),
('23h','23h.3','23h.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference'),
('23h','23h.3','23h.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('23h','23h.3','23h.3.3','1','Documented policies and procedures that address (a) to (n).'),
('23h','23h.3','23h.3.3','2','Staff are briefed on the policies and procedures (meeting minutes or circulation acknowledgement).'),
('23h','23h.3','23h.3.3','3','Standard anaesthetic and drug administrative records are maintained.'),
('23h','23h.3','23h.3.3','4','There are documentations of all procedures.'),
('23h','23h.3','23h.3.4','1','Compliance is evident through the following:
Interview with staff on practices.'),
('23h','23h.3','23h.3.4','2','Verify with observation on practices.'),
('23h','23h.3','23h.3.4','3','Audits if conducted.'),
('23h','23h.3','23h.3.5','1','Policy on requesting for a radiological investigation or procedure.'),
('23h','23h.3','23h.3.5','2','Clinical indication/information is available on the request form/clinical order entry prior to the examination.'),
('23h','23h.3','23h.3.6','1','Reports of radiological examinations are made by a radiologist/medical practitioner under the supervision of a radiologist.'),
('23h','23h.3','23h.3.6','2','All radiological reports shall be signed and dated by radiologist and/or medical practitioner based on the local policy.'),
('23h','23h.3','23h.3.7','1','Special radiological reports are available within 2 days.'),
('23h','23h.3','23h.3.7','2','Special radiological reports are made in consultation with a radiologist.'),
('23h','23h.3','23h.3.7','3','A copy of the report is kept by the Radiology department.'),
('23h','23h.3','23h.3.8','1','Documented evidence that the clinician has been informed on the critical or unexpected findings.'),
('23h','23h.3','23h.3.9','1','There is evidence of proper storage of the films.'),
('23h','23h.3','23h.3.9','2','There is proper documentation to allow tracking/retrieval of the films.'),
('23h','23h.3','23h.3.10','1','Documented policy on radiation protection.'),
('23h','23h.3','23h.3.10','2','Observation of practice.'),
('23h','23h.3','23h.3.11','1','Documented procedures for management of adverse drug or contrast media reaction, anaphylactic reaction, or any complications during radiological procedures.'),
('23h','23h.3','23h.3.11','2','Evidence of availability of emergency and resuscitation equipment.'),
('23h','23h.3','23h.3.12','1','The documented standard operational procedures and protocols for all radiological examinations must be available.'),
('23h','23h.3','23h.3.13','1','A technical manual for equipment is available.'),
('23h','23h.3','23h.3.14','1','There are user access and control on images.'),
('23h','23h.3','23h.3.15','1','Evidence of medical examination by medical practitioner including full blood count and chest x-ray as per items (a) to (c).'),
('23h','23h.3','23h.3.16','1','Record on individual staff radiation exposure dose.'),
('23h','23h.3','23h.3.16','2','Protocol for reporting, investigation and action taken for staff having exceeded the maximum permissible dose.'),
('23h','23h.4','23h.4.1','1','The building is sound and there is adequate space to match the services.'),
('23h','23h.4','23h.4.1','2','Appropriate type of equipment to match the complexity of services.'),
('23h','23h.4','23h.4.1','3','Adequate facilities and equipment at each patient care area for safe care. (e.g. defibrillators, emergency trolley, hand washing facilities etc).'),
('23h','23h.4','23h.4.1','4','Easy access and clear (unblocked) exit routes.'),
('23h','23h.4','23h.4.1','5','Absence of overcrowding.'),
('23h','23h.4','23h.4.2','1','There is certification of equipment from certified bodies.'),
('23h','23h.4','23h.4.2','2','Testing, commissioning and calibration records.'),
('23h','23h.4','23h.4.3','1','Planned Preventive Maintenance records such as schedule, stickers, etc.'),
('23h','23h.4','23h.4.3','2','Planned Replacement Programme where applicable.'),
('23h','23h.4','23h.4.3','3','Complaint records.'),
('23h','23h.4','23h.4.3','4','Asset inventory.'),
('23h','23h.4','23h.4.4','1','User training records.'),
('23h','23h.4','23h.4.4','2','List of staff trained and authorised to operate specialised equipment.'),
('23h','23h.4','23h.4.5','1','Verification of practices for staff and patient.'),
('23h','23h.4','23h.4.5','2','Documented evidence of personal radiation protective device testing and record.'),
('23h','23h.4','23h.4.6','1','Evidence of appropriate signage.'),
('23h','23h.4','23h.4.7','1','Changing rooms and facilities to keep patient’s valuables are available.'),
('23h','23h.4','23h.4.8','1','Adequate space for patient preparation and observation pre and post radiological procedures.'),
('23h','23h.4','23h.4.8','2','Verification of practices by observation.'),
('23h','23h.4','23h.4.9','1','Ensure available space for (a) to (c).'),
('23h','23h.4','23h.4.10','1','Records on training of sonographer or trained medical personnel on ultrasonography.'),
('23h','23h.4','23h.4.11','1','Records on the qualification of the radiographer.'),
('23h','23h.4','23h.4.11','2','Verification by on-site observation.'),
('23h','23h.4','23h.4.12','1','There is a documented standard operating procedure for the use of mobile radiography in the wards.'),
('23h','23h.4','23h.4.12','2','Verification on the procedure by onsite observation.'),
('23h','23h.4','23h.4.13','1','Availability of guidelines on the handling, transport and storage of mobile x- ray machines and their accessories.'),
('23h','23h.4','23h.4.13','2','Verify that the procedures are followed by onsite observation.'),
('23h','23h.4','23h.4.14','1','Mammography shall be performed by a qualified female radiographer.'),
('23h','23h.4','23h.4.14','2','The staff has evidence of appropriate credentialing and privileging.'),
('23h','23h.4','23h.4.14','3','The mammography is reported by the radiologist (verify mammography report onsite).'),
('23h','23h.4','23h.4.14','4','Documentation of Quality Control (QC) test.'),
('23h','23h.4','23h.4.15','1','Evidence of training for the relevant staff conducting CT scans.'),
('23h','23h.4','23h.4.15','2','The CT scan room shall meet the required specifications for such facilities in accordance with the requirements of the National Department of Health.'),
('23h','23h.4','23h.4.15','3','All CT scan examinations shall be interpreted and reported by a radiologist.'),
('23h','23h.4','23h.4.15','4','Observe sample of CT scan report onsite.'),
('23h','23h.4','23h.4.15','5','The indication to perform the CT scan is justified (onsite observation).'),
('23h','23h.4','23h.4.15','6','There are policies addressing safety, operations and maintenance of the CT scan equipment.'),
('23h','23h.4','23h.4.15','7','There are guidelines for the handling of patients (a) to (j).'),
('23h','23h.4','23h.4.15','8','Records on monitoring of CT machine by a trained person is available.'),
('23h','23h.4','23h.4.15','9','Evidence of patient dose monitoring is available.'),
('23h','23h.4','23h.4.16','1','Evidence of training of radiographer on MRI (training records or credentials).'),
('23h','23h.4','23h.4.16','2','Onsite sampling of MRI records to observe who reported the MRI.'),
('23h','23h.4','23h.4.16','3','There are policies for safety, operations and maintenance of MRI equipment.'),
('23h','23h.4','23h.4.16','4','Onsite verification of practices.'),
('23h','23h.4','23h.4.16','5','Check onsite maintenance workers/staff for their knowledge on safety and compliance.'),
('23h','23h.4','23h.4.16','6','There are guidelines for handling (a) to (k).'),
('23h','23h.4','23h.4.16','7','There should be procedures for handling emergencies (fire, accidents, patient collapse).'),
('23h','23h.4','23h.4.16','8','There should be availability of MRI compatible equipment.'),
('23h','23h.4','23h.4.17','1','There are adequate exhaust and ventilation systems in the darkroom area.'),
('23h','23h.4','23h.4.17','2','The darkroom environment is odour free.'),
('23h','23h.4','23h.4.17','3','There is provision for light exposure such as light-proof single or double door.'),
('23h','23h.4','23h.4.17','4','There is a door- bell.'),
('23h','23h.4','23h.4.17','5','The room is clutter free and easy to move around in.'),
('23h','23h.4','23h.4.18','1','There are policies on the secure use, access and maintenance of PACS'),
('23h','23h.4','23h.4.18','2','There is a policy on the safety and confidentiality of images archived.'),
('23h','23h.4','23h.4.18','3','Verification of practices with onsite observation.'),
('23h','23h.4','23h.4.19','1','There is a standard operating procedure on the storage and disposal of waste in Radiology Services.'),
('23h','23h.4','23h.4.19','2','Verification on practices during survey.'),
('23h','23h.5','23h.5.1','1','There is a designated person who monitors safety and performance improvement activities within the Radiology Services.'),
('23h','23h.5','23h.5.1','2','There are records/registers on performance improvement activities.'),
('23h','23h.5','23h.5.1','3','There are meeting minutes for performance improvement meetings.'),
('23h','23h.5','23h.5.1','4','There are records on innovation (if any).'),
('23h','23h.5','23h.5.2','1','System for incident reporting is in place with the following;
a.) Training of staff in incident reporting
b.) Policy on incident reporting
c.) Method/SOP on Incident reporting
d.) Register of incidents'),
('23h','23h.5','23h.5.2','2','Completed incident reports.'),
('23h','23h.5','23h.5.2','3','Corrective and preventive action plans.'),
('23h','23h.5','23h.5.2','4','Minutes of meeting.'),
('23h','23h.5','23h.5.2','5','Involved staff given feedback about the incident report.'),
('23h','23h.5','23h.5.2','6','Acknowledgment by Head of Radiology Service and Director of Curative Services.'),
('23h','23h.5','23h.5.3','1','Specific performance indicators are monitored.'),
('23h','23h.5','23h.5.3','2','Remedial action is taken when appropriate.'),
('23j','23j.1','23j.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('23j','23j.1','23j.1.1','2','There is an endorsed and dated department Organisational chart with lines of functions and reporting relationships.'),
('23j','23j.1','23j.1.1','3','Relevant policies are available in the department. (National Health Plan, National Health Service Standards, etc.).'),
('23j','23j.1','23j.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('23j','23j.1','23j.1.1','5','Evidence of fee structure (if fees are collected).'),
('23j','23j.1','23j.1.2','1','Letter of appointment and terms of reference as the Head of Service.'),
('23j','23j.1','23j.1.2','2','Letter of appointment and terms of reference of the Head of Service in other hospital committees.'),
('23j','23j.1','23j.1.2','3','Evidence of (a) to (d) in meeting minutes/correspondence indicating the involvement of the Head of Service.'),
('23j','23j.1','23j.1.2','4','Request for allocation for budget and staffing.'),
('23j','23j.1','23j.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff.'),
('23j','23j.1','23j.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service.'),
('23j','23j.1','23j.1.3','3','Frequency of meetings are as scheduled.'),
('23j','23j.1','23j.1.3','4','Discussions and resolutions are implemented. (problems not solved are brought forward to the next meeting till resolved).'),
('23j','23j.1','23j.1.4','1','The statistics and records from (a) to (h) are available.'),
('23j','23j.1','23j.1.4','2','The NHSS Toolkit Assessment (checklist) for the relevant level has been completed in the past 6 months.'),
('23j','23j.1','23j.1.5','1','Documented list of services provided to other Units in the Facility by the Operating Theatre Services'),
('23j','23j.1','23j.1.6','1','Records (a) to (e) are maintained in the OT.'),
('23j','23j.1','23j.1.6','2','Verification of the following by on-site inspection;
a.) Filled consent taking form.
b.) Specimen book for lab investigations.
c.) Anaesthetic and drug records
d.) Register of all operations done in the OT.'),
('23j','23j.1','23j.1.6','3','Documentation on disposal of dangerous drugs.'),
('23j','23j.1','23j.1.6','4','Patient medical records in details of procedure and surgeon and personnel involved.'),
('23j','23j.1','23j.1.7','1','Swab count and instrument count record are in patient records.'),
('23j','23j.1','23j.1.8','1','Cross departmental policies regarding the related support services are available.'),
('23j','23j.1','23j.1.8','2','Evidence of compliance to such policies are observed on-site.'),
('23j','23j.2','23j.2.1','1','There are records of credentials of Head of Services.'),
('23j','23j.2','23j.2.1','2','There are dated and specific job descriptions for each staff that include (a) to (f).'),
('23j','23j.2','23j.2.1','3','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('23j','23j.2','23j.2.1','4','The scope of work in the job description aligns with the training, skill and experience of the staff (credentialling)'),
('23j','23j.2','23j.2.2','1','Letter of appointment of the Operating Services Nurse Manager.'),
('23j','23j.2','23j.2.2','2','Credentials of the OT Nurse Manager.'),
('23j','23j.2','23j.2.3','1','Evidence of current registration for all cadres of staff (annual practicing certificate).'),
('23j','23j.2','23j.2.4','1','Observation that cadres of staff are working according to their job description and job scope.'),
('23j','23j.2','23j.2.5','1','Training calendar includes in-house/ external courses/ workshops/ conferences.'),
('23j','23j.2','23j.2.5','2','Training for each staff including training in life support is kept in the Department.'),
('23j','23j.2','23j.2.5','3','There are ongoing Continuous Professional Activities in the Department.'),
('23j','23j.2','23j.2.6','1','Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.'),
('23j','23j.2','23j.2.7','1','Evidence of a Memorandum of Understanding (MoU).'),
('23j','23j.2','23j.2.7','2','Ratio of supervisor to students.'),
('23j','23j.2','23j.2.7','3','Training timetable and attendance.'),
('23j','23j.2','23j.2.8','1','Performance appraisal for staff including medical practitioners is completed upon probationary period and as an annual exercise.'),
('23j','23j.2','23j.2.9','1','Documented evidence of research activities in the Department.'),
('23j','23j.2','23j.2.10','1','Number of staff and qualification should commensurate with workload.'),
('23j','23j.2','23j.2.10','2','There should be one anaesthetic scientific officer per OT.'),
('23j','23j.2','23j.2.10','3','There should be one perioperative postgraduate nurse per OT.'),
('23j','23j.2','23j.2.10','4','In the recovery area, there should be 1 qualified nurse to 3 patients.'),
('23j','23j.2','23j.2.10','5','Observe the duty roster.'),
('23j','23j.2','23j.2.10','6','Observe the on-call roster.'),
('23j','23j.2','23j.2.11','1','Evidence of policy stating that all staff have to attend a structured orientation programme.'),
('23j','23j.2','23j.2.11','2','Attendance list of those having attended the orientation programme.'),
('23j','23j.3','23j.3.1','1','Evidence of documented policies and procedures for the service.'),
('23j','23j.3','23j.3.1','2','The policies and procedures are endorsed and dated.'),
('23j','23j.3','23j.3.1','3','There is a periodic review at least once in three years.'),
('23j','23j.3','23j.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference'),
('23j','23j.3','23j.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('23j','23j.3','23j.3.3','1','Documented policies and procedures that address (a) to (s).'),
('23j','23j.3','23j.3.3','2','Staff are briefed on the policies and procedures (meeting minutes or circulation acknowledgement).'),
('23j','23j.3','23j.3.4','1','Operational policy on 24-hour service.'),
('23j','23j.3','23j.3.4','2','Staffing level reflects a good mix of senior and junior staff.'),
('23j','23j.3','23j.3.4','3','On call roster is dated and authorised.'),
('23j','23j.4','23j.4.1','1','The design and layout of the Operating Theatre provides adequate space and includes features listed in (a) to (i).'),
('23j','23j.4','23j.4.2','1','Design and layout of the Operating Theatre with features (a) to (j).'),
('23j','23j.4','23j.4.2','2','Fire escape plan clearly posted.'),
('23j','23j.4','23j.4.2','3','Verification of appropriateness of design of the OT by inspection.'),
('23j','23j.4','23j.4.2','4','Log book on medical gas monitoring.'),
('23j','23j.4','23j.4.3','1','Verification of items (a) to (e).'),
('23j','23j.4','23j.4.3','2','Onsite verification of the above during inspection.'),
('23j','23j.4','23j.4.4','1','The operating theatre complies with safety features in accordance with (a) to (d).'),
('23j','23j.4','23j.4.4','2','Onsite verification of the above during inspection.'),
('23j','23j.4','23j.4.5','1','The equipment in OT comply to (a) to (e).'),
('23j','23j.4','23j.4.6','1','Appropriate telecommunication modalities available for daily operation and during emergencies.'),
('23j','23j.4','23j.4.7','1','Availability of emergency and non-emergency equipment appropriate to level of care, such as defibrillator, emergency trolley, suction machine, electrocardiogram (ECG) machine, infusion or syringe pump, vital sign monitor, pulse oximeter, oxygen concentrator etc.'),
('23j','23j.4','23j.4.7','2','Scheduled checking of items in emergency trolley.'),
('23j','23j.4','23j.4.7','3','There are adequate patient transfer trolleys, wheelchairs, mobility aids and a dedicated drug fridge.'),
('23j','23j.4','23j.4.7','4','There is a dedicated cabinet for dangerous drugs which can be locked.'),
('23j','23j.4','23j.4.8','1','Planned Preventive Maintenance records such as schedule, stickers, etc.'),
('23j','23j.4','23j.4.8','2','Planned Replacement Programme where applicable.'),
('23j','23j.4','23j.4.8','3','Complaint records.'),
('23j','23j.4','23j.4.8','4','Asset inventory.'),
('23j','23j.4','23j.4.9','1','User training records.'),
('23j','23j.4','23j.4.9','2','List of staff trained and authorised to operate specialised equipment.'),
('23j','23j.4','23j.4.9','3','Adequate waiting area, toilets and reading material.'),
('23j','23j.4','23j.4.9','4','Evidence of data collected.'),
('23j','23j.4','23j.4.10','1','Evidence of facilities with patient privacy ensured.'),
('23j','23j.4','23j.4.10','2','Procedure room appropriately equipped.'),
('23j','23j.4','23j.4.10','3','Patient monitoring device is available where required (vital signs).'),
('23j','23j.4','23j.4.10','4','List of procedures performed is available.'),
('23j','23j.5','23j.5.1','1','There is a designated person who monitors safety and performance improvement activities within the Radiology Services.'),
('23j','23j.5','23j.5.1','2','There are records/registers on performance improvement activities.'),
('23j','23j.5','23j.5.1','3','There are meeting minutes for performance improvement meetings.'),
('23j','23j.5','23j.5.1','4','There are records on innovation (if any).'),
('23j','23j.5','23j.5.2','1','System for incident reporting is in place with the following;
a.) Training of staff in incident reporting
b.) Policy on incident reporting
c.) Method/SOP on Incident reporting
d.) Register of incidents'),
('23j','23j.5','23j.5.2','2','Completed incident reports.'),
('23j','23j.5','23j.5.2','3','Corrective and preventive action plans.'),
('23j','23j.5','23j.5.2','4','Minutes of meeting.'),
('23j','23j.5','23j.5.2','5','Involved staff given feedback about the incident report.'),
('23j','23j.5','23j.5.2','6','Acknowledgment by Head of Radiology Service and Director of Curative Services.'),
('23j','23j.5','23j.5.3','1','Specific performance indicators are monitored.'),
('23j','23j.5','23j.5.3','2','Remedial action is taken when appropriate.'),
('23k','23k.1','23k.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('23k','23k.1','23k.1.1','2','There is an endorsed and dated department organisational chart with lines of functions and reporting relationships.'),
('23k','23k.1','23k.1.1','3','Relevant policies and guidelines are available in the department. (National Health Plan, National Health Service Standards, etc.).'),
('23k','23k.1','23k.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('23k','23k.1','23k.1.1','5','Evidence of fee structure (if fees are collected).'),
('23k','23k.1','23k.1.2','1','Letter of appointment and terms of reference as the Head of Service.'),
('23k','23k.1','23k.1.2','2','Letter of appointment and terms of reference in other hospital committees.'),
('23k','23k.1','23k.1.2','3','Evidence of (a) to (d) in meeting minutes/correspondence of the Critical Care Services indicating the involvement of the Head of Service.'),
('23k','23k.1','23k.1.2','4','Request for allocation for budget and staffing.'),
('23k','23k.1','23k.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff.'),
('23k','23k.1','23k.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service.'),
('23k','23k.1','23k.1.3','3','Frequency of meetings are as scheduled.'),
('23k','23k.1','23k.1.3','4','Discussions and resolutions are implemented. (problems not solved are brought forward to the next meeting till resolved).'),
('23k','23k.1','23k.1.4','1','The statistics and records from (a) to (h) are available.'),
('23k','23k.1','23k.1.4','2','The NHSS Toolkit Assessment (checklist) for the relevant level has been completed in the past 6 months.'),
('23k','23k.1','23k.1.5','1','Documented list of services provided to other Units in the Facility by the Critical Care Services.'),
('23k','23k.2','23k.2.1','1','There are records of credentials of Head of Services appropriate to the level of the ICU/HDU.'),
('23k','23k.2','23k.2.1','2','There are dated and specific job descriptions for each staff that include (a) to (f).'),
('23k','23k.2','23k.2.1','3','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('23k','23k.2','23k.2.1','4','The scope of work in the job description aligns with the training, skill and experience of the staff. (credentialling)'),
('23k','23k.2','23k.2.2','1','Evidence of current registration for all cadres of staff (annual practicing certificate).'),
('23k','23k.2','23k.2.3','1','Observation that cadres of staff are working according to their job description and job scope.'),
('23k','23k.2','23k.2.4','1','Training calendar includes in-house/ external courses/ workshops/ conferences'),
('23k','23k.2','23k.2.4','2','Training for each staff including training in life support is kept in the Department.'),
('23k','23k.2','23k.2.4','3','There are ongoing Continuous Professional Activities in the Department.'),
('23k','23k.2','23k.2.5','1','Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.'),
('23k','23k.2','23k.2.6','1','Evidence of sufficient skilled trained staff to provide clinical supervision as per terms of Memorandum of Understanding.'),
('23k','23k.2','23k.2.7','1','Performance appraisal for staff including medical practitioners is completed upon probationary period and as an annual exercise.'),
('23k','23k.2','23k.2.8','1','Documented evidence of research activities in the Department.'),
('23k','23k.2','23k.2.9','1','Number of staff and qualification should match the workload according to (a) to (i).'),
('23k','23k.2','23k.2.9','2','Duty roster of medical officer trained in anaesthesia/ICU and nursing staff.'),
('23k','23k.2','23k.2.9','3','Duty roster of physiotherapist and dietician in Level 2 and 3 care'),
('23k','23k.2','23k.2.10','1','Evidence of policy stating that all staff have to attend a structured orientation programme.'),
('23k','23k.2','23k.2.10','2','Attendance list of those having attended the orientation programme.'),
('23k','23k.3','23k.3.1','1','Evidence of documented policies and procedures for the service.'),
('23k','23k.3','23k.3.1','2','The policies and procedures are endorsed and dated.'),
('23k','23k.3','23k.3.1','3','There is a periodic review at least once in three years.'),
('23k','23k.3','23k.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference'),
('23k','23k.3','23k.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('23k','23k.3','23k.3.3','1','Documented policies and procedures that address (a) to (l).'),
('23k','23k.3','23k.3.3','2','Staff are briefed on the policies and procedures (meeting minutes or circulation acknowledgement).'),
('23k','23k.3','23k.3.4','1','Operational policy on 24-hour service.'),
('23k','23k.3','23k.3.4','2','Staffing level reflects a good mix of senior and junior staff.'),
('23k','23k.3','23k.3.4','3','On-call roster is dated and authorised.'),
('23k','23k.3','23k.3.5','1','Relevant updated Standard Treatment Guidelines are available in the division.'),
('23k','23k.3','23k.3.5','2','Patient register is updated daily.'),
('23k','23k.3','23k.3.5','3','Evidence of appropriate admission process.'),
('23k','23k.3','23k.3.5','4','Evidence of in-patient and guardian orientation process during admission.'),
('23k','23k.3','23k.3.5','5','Evidence of initial assessment and provisional diagnosis.'),
('23k','23k.3','23k.3.5','6','Evidence and documentation of morning, afternoon and evening rounds.'),
('23k','23k.3','23k.3.5','7','Evidence of regular vital sign documentation'),
('23k','23k.3','23k.3.5','8','Documentation of discussions with patient/family/guardian about the patient’s condition.'),
('23k','23k.3','23k.3.5','9','Evidence of discussions with other disciplines and referrals if necessary.'),
('23k','23k.3','23k.3.5','10','Evidence of patient handover during shift change (documentation and observed).'),
('23k','23k.3','23k.3.5','11','Evidence of documented informed consent for procedures.'),
('23k','23k.3','23k.3.5','12','Evidence of flowchart on patient deterioration or “Code Blue” procedures.'),
('23k','23k.3','23k.3.5','13','Discharge summaries are issued to patients on discharge with a care plan.'),
('23k','23k.3','23k.3.5','14','Evidence of a patient referral register'),
('23k','23k.3','23k.3.6','1','Patient’s medical record has elements (a) to (m).'),
('23k','23k.3','23k.3.6','2','The Patient’s medical record has a unique identifier (MRN).'),
('23k','23k.3','23k.3.6','3','Evidence of clinical documentation which is signed, dated and with legible writing.'),
('23k','23k.3','23k.3.6','4','Evidence of use of appropriate abbreviations.'),
('23k','23k.4','23k.4.1','1','The building is sound and there is adequate space to match the services.'),
('23k','23k.4','23k.4.1','2','Appropriate type of equipment to match the complexity of services.'),
('23k','23k.4','23k.4.1','3','Adequate facilities and equipment at each patient care area for safe care. (e.g. defibrillators, emergency trolley, hand washing facilities etc.).'),
('23k','23k.4','23k.4.1','4','Easy access and clear (unblocked) exit routes.'),
('23k','23k.4','23k.4.1','5','Absence of overcrowding.'),
('23k','23k.4','23k.4.1','6','Availability of an isolation area.'),
('23k','23k.4','23k.4.1','7','There are lights/lamps/solar for blackouts.'),
('23k','23k.4','23k.4.1','8','There is good ventilation within the ward/s.'),
('23k','23k.4','23k.4.1','9','There is running water in the facility'),
('23k','23k.4','23k.4.1','10','Waste is segregated at the facility at the point of generation.'),
('23k','23k.4','23k.4.2','1','Design and layout of the unit, e.g. wards, treatment rooms access, lighting, signage, etc address the safety aspects of patients and staff.'),
('23k','23k.4','23k.4.2','2','Equipment should have scheduled planned preventive maintenance (PPM).'),
('23k','23k.4','23k.4.2','3','There is access to hand washing facilities particularly:
• Sinks with elbow or foot operated faucets
• Alcohol-based hand rub for each bed
• Hand-drying facility e.g. disposable paper towels'),
('23k','23k.4','23k.4.2','4','Mattresses are covered with waterproof coverings and there is clean linen on every bed.'),
('23k','23k.4','23k.4.2','5','Sharps are disposed properly in sharp bins.'),
('23k','23k.4','23k.4.2','6','Separate clean and dirty utility rooms'),
('23k','23k.4','23k.4.2','7','Endotracheal suctioning is done via a closed system or single used disposable catheter.'),
('23k','23k.4','23k.4.2','8','There are adequate patient transfer trolleys, wheelchairs, mobility aids and a dedicated drug fridge.'),
('23k','23k.4','23k.4.2','9','There is a dedicated cabinet for dangerous drugs which can be locked'),
('23k','23k.4','23k.4.2','10','There is scheduled checking of items in emergency trolley'),
('23k','23k.4','23k.4.3','1','Isolation rooms are appropriate to the level of care.'),
('23k','23k.4','23k.4.4','1','Appropriate telecommunication modalities available for daily operation and during emergencies.'),
('23k','23k.4','23k.4.5','1','Presence of (a) to (c).'),
('23k','23k.4','23k.4.6','1','Blood gas machine is available and functional in the unit.'),
('23k','23k.4','23k.4.6','2','Records on maintenance of blood gas machine'),
('23k','23k.4','23k.4.6','3','Quality control of blood gas machine'),
('23k','23k.4','23k.4.6','4','Availability of laboratory results which are reviewed, signed with a plan of action.'),
('23k','23k.4','23k.4.6','5','Availability of culture results 24 hours a day'),
('23k','23k.4','23k.4.7','1','Evidence of 24- hour availability to Radiology and Blood bank services (interview and documented patient records).'),
('23k','23k.4','23k.4.8','1','The number of vacuum outlets, oxygen, compressed air outlets and suction facilities are suitable for the level of service provided.'),
('23k','23k.4','23k.4.9','1','All beds are functional as per standard requirement.'),
('23k','23k.4','23k.4.10','1','All the listed equipment is available in the appropriate level of care and are functional.'),
('23k','23k.4','23k.4.11','1','The items in (a) to (p) are available.'),
('23k','23k.4','23k.4.12','1','Emergency and life support equipment are available and functional as required.'),
('23k','23k.4','23k.4.12','2','Resuscitation trolley, defibrillator and equipment to manage difficult airway are available.'),
('23k','23k.4','23k.4.13','1','Planned Preventive Maintenance records such as schedule, stickers, etc.'),
('23k','23k.4','23k.4.13','2','Planned Replacement Programme where applicable.'),
('23k','23k.4','23k.4.13','3','Complaint records.'),
('23k','23k.4','23k.4.13','4','Asset inventory.'),
('23k','23k.4','23k.4.14','1','User training records.'),
('23k','23k.4','23k.4.14','2','List of staff trained and authorised to operate specialised equipment.'),
('23k','23k.5','23k.5.1','1','There is a designated person who monitors safety and performance improvement activities within the ICU/HDU Services.'),
('23k','23k.5','23k.5.1','2','There are records/registers on performance improvement activities.'),
('23k','23k.5','23k.5.1','3','There are meeting minutes for performance improvement meetings.'),
('23k','23k.5','23k.5.1','4','There are records on innovation (if any).'),
('23k','23k.5','23k.5.2','1','System for incident reporting is in place with the following:
a. Training of staff in incident reporting
b. Policy on incident reporting
c. Method/SOP on Incident reporting
d. Register of incidents'),
('23k','23k.5','23k.5.2','2','Completed incident reports.'),
('23k','23k.5','23k.5.2','3','Corrective and preventive action plans.'),
('23k','23k.5','23k.5.2','4','Minutes of meeting.'),
('23k','23k.5','23k.5.2','5','Involved staff given feedback about the incident report.'),
('23k','23k.5','23k.5.2','6','Acknowledgment by Head of ICU/HDU Service and Director of Curative Services.'),
('23k','23k.5','23k.5.3','1','Specific performance indicators are monitored'),
('23k','23k.5','23k.5.3','2','Remedial action is taken when appropriate'),
('23l','23l.1','23l.1.1','1','The Mission, Vision and Goals of the Organisation are visible, endorsed and dated.'),
('23l','23l.1','23l.1.1','2','There is an endorsed and dated department organisational chart with lines of functions and reporting relationships.'),
('23l','23l.1','23l.1.1','3','Relevant policies and guidelines are available in the department. (National Health Plan, National Health Service Standards, Occupational Health and Safety, Infection prevention and Control etc.).'),
('23l','23l.1','23l.1.1','4','Evidence of submission of an Annual Implementation Plan and budget.'),
('23l','23l.1','23l.1.2','1','Letter of appointment and terms of reference as the Head of Service.'),
('23l','23l.1','23l.1.2','2','Letter of appointment and terms of reference in other hospital committees.'),
('23l','23l.1','23l.1.2','3','Evidence of (a) to (d) in meeting minutes/correspondence of the CSSD Services indicating the involvement of the Head of Service.'),
('23l','23l.1','23l.1.2','4','Request for allocation for budget and staffing.'),
('23l','23l.1','23l.1.3','1','Meeting minutes are available, disseminated and acknowledged by staff.'),
('23l','23l.1','23l.1.3','2','There is sufficient attendance for the meetings with adequate representatives of the service.'),
('23l','23l.1','23l.1.3','3','Frequency of meetings are as scheduled.'),
('23l','23l.1','23l.1.3','4','Discussions and resolutions are implemented. (problems not solved are brought forward to the next meeting till resolved).'),
('23l','23l.1','23l.1.4','1','The statistics and records from (a) to (f) are available.'),
('23l','23l.1','23l.1.4','2','The NHSS Toolkit Assessment (checklist) for the relevant level has been completed in the past 6 months.'),
('23l','23l.1','23l.1.5','1','Documented list of services provided to other Units in the Facility by the CSSD Services.'),
('23l','23l.2','23l.2.1','1','There are records of credentials of Head of Services.'),
('23l','23l.2','23l.2.1','2','There are dated and specific job descriptions for each staff that include (a) to (c).'),
('23l','23l.2','23l.2.1','3','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('23l','23l.2','23l.2.1','4','Staff have training records for infection prevention and required certification (e.g. for autoclave operator).'),
('23l','23l.2','23l.2.2','1','Evidence of current registration for all cadres of staff (annual practicing certificate).'),
('23l','23l.2','23l.2.3','1','Observation that cadres of staff are working according to their job description and job scope.'),
('23l','23l.2','23l.2.4','1','Training calendar includes in-house/ external courses/ workshops/ conferences.'),
('23l','23l.2','23l.2.4','2','Training for each staff including training in life support is kept in the Department.'),
('23l','23l.2','23l.2.4','3','There are ongoing Continuous Professional Activities in the Department.'),
('23l','23l.2','23l.2.5','1','Evidence of staff training because of recommendations made from incident reports or mortality and morbidity reviews.'),
('23l','23l.2','23l.2.6','1','Evidence of sufficient skilled trained staff to provide clinical supervision as per terms of Memorandum of Understanding.'),
('23l','23l.2','23l.2.7','1','Performance appraisal for staff including medical practitioners is completed upon probationary period and as an annual exercise.'),
('23l','23l.2','23l.2.8','1','Documented evidence of research activities in the Department.'),
('23l','23l.2','23l.2.9','1','Number of staff should match the workload.'),
('23l','23l.2','23l.2.9','2','Staffing pattern and duty roster.'),
('23l','23l.2','23l.2.10','1','Evidence of policy stating that all staff have to attend a structured orientation programme.'),
('23l','23l.2','23l.2.10','2','Attendance list of those having attended the orientation programme.'),
('23l','23l.2','23l.2.11','1','Evidence of vaccination programme and records.'),
('23l','23l.3','23l.3.1','1','Evidence of documented policies and procedures for the service.'),
('23l','23l.3','23l.3.1','2','The policies and procedures are endorsed and dated.'),
('23l','23l.3','23l.3.1','3','There is a periodic review at least once in three years.'),
('23l','23l.3','23l.3.1','4','Copies of policies, by laws, regulations and relevant acts are accessible on site for staff reference'),
('23l','23l.3','23l.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('23l','23l.3','23l.3.3','1','Documented policies and procedures that address (a) to (k).'),
('23l','23l.3','23l.3.3','2','Staff are briefed on the policies and procedures (meeting minutes or circulation acknowledgement).'),
('23l','23l.3','23l.3.4','1','Specific policies addressing CSSD in other services are sighted.'),
('23l','23l.3','23l.3.5','1','Daily production statistics to assess stock (e.g. medical-surgical instruments, equipment or supplies) level for safe, continuous service, efficient stock and cost control.'),
('23l','23l.3','23l.3.5','2','Steriliser records (e.g. number of records).'),
('23l','23l.4','23l.4.1','1','The design of the CSSD addresses (a) to (e).'),
('23l','23l.4','23l.4.2','1','List of staff trained and authorised to operate specialised equipment.'),
('23l','23l.4','23l.4.3','1','Equipment should have scheduled planned preventive maintenance (PPM).'),
('23l','23l.4','23l.4.3','2','There should be an asset inventory.'),
('23l','23l.4','23l.4.3','3','There should be a record of complaints.'),
('23l','23l.5','23l.5.1','1','There is a designated person who monitors safety and performance improvement activities within the CSSD Services.'),
('23l','23l.5','23l.5.1','2','There is a risk register.'),
('23l','23l.5','23l.5.1','3','There are meeting minutes for performance improvement meetings.'),
('23l','23l.5','23l.5.1','4','There are records on innovation (if any).'),
('23l','23l.5','23l.5.2','1','System for incident reporting is in place with the following;
a.) Training of staff in incident reporting
b.) Policy on incident reporting
c.) Method/SOP on Incident reporting
d.) Register of incidents'),
('23l','23l.5','23l.5.2','2','Completed incident reports.'),
('23l','23l.5','23l.5.2','3','Corrective and preventive action plans.'),
('23l','23l.5','23l.5.2','4','Minutes of meeting.'),
('23l','23l.5','23l.5.2','5','Involved staff given feedback about the incident report.'),
('23l','23l.5','23l.5.2','6','Acknowledgment by Head of CSSD Service and Director of Curative Services.'),
('23l','23l.5','23l.5.3','1','Specific performance indicators are monitored.'),
('23l','23l.5','23l.5.3','2','Remedial action is taken when appropriate.');
INSERT INTO standards ("standardNumber","standardTitle","standardSummary","functionId","componentId") SELECT standard_number,title,summary,4,6 FROM import_s;
INSERT INTO criteria ("criterionNumber","criterionTitle","standardId","isApplicable") SELECT x.number,x.title,s."standardId",true FROM import_c x JOIN standards s ON s."standardNumber"=x.standard_number;
INSERT INTO compliances ("complianceNumber","complianceSummary","criterionId","isApplicable") SELECT x.number,x.summary,c."criterionId",true FROM import_co x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number;
INSERT INTO evidence ("evidenceNumber","evidenceSummary","complianceId","isApplicable") SELECT x.number,x.summary,co."complianceId",true FROM import_e x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number JOIN compliances co ON co."criterionId"=c."criterionId" AND co."complianceNumber"=x.compliance_number;
DO $$ BEGIN
IF (SELECT count(*) FROM import_s x JOIN standards s ON s."standardNumber"=x.standard_number AND s."standardTitle"=x.title AND s."standardSummary"=x.summary AND s."functionId"=4 AND s."componentId"=6)<>5 THEN RAISE EXCEPTION 'Standard verification failed'; END IF;
IF (SELECT count(*) FROM import_c x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.number AND c."criterionTitle"=x.title AND c."isApplicable")<>25 THEN RAISE EXCEPTION 'Criterion verification failed'; END IF;
IF (SELECT count(*) FROM import_co x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number JOIN compliances co ON co."criterionId"=c."criterionId" AND co."complianceNumber"=x.number AND co."complianceSummary"=x.summary AND co."isApplicable")<>187 THEN RAISE EXCEPTION 'Compliance verification failed'; END IF;
IF (SELECT count(*) FROM import_e x JOIN standards s ON s."standardNumber"=x.standard_number JOIN criteria c ON c."standardId"=s."standardId" AND c."criterionNumber"=x.criterion_number JOIN compliances co ON co."criterionId"=c."criterionId" AND co."complianceNumber"=x.compliance_number JOIN evidence e ON e."complianceId"=co."complianceId" AND e."evidenceNumber"=x.number AND e."evidenceSummary"=x.summary AND e."isApplicable")<>525 THEN RAISE EXCEPTION 'Evidence verification failed'; END IF;
END $$;
COMMIT;
SELECT json_build_object('standardNumber',s."standardNumber",'standardId',s."standardId",'criteria',count(distinct c."criterionId"),'compliances',count(distinct co."complianceId"),'evidence',count(e."evidenceId"),'importedAt',CURRENT_TIMESTAMP) FROM standards s JOIN criteria c ON c."standardId"=s."standardId" JOIN compliances co ON co."criterionId"=c."criterionId" JOIN evidence e ON e."complianceId"=co."complianceId" WHERE s."standardNumber" IN ('23g','23h','23j','23k','23l') GROUP BY s."standardId" ORDER BY s."standardNumber";