BEGIN;
SET LOCAL lock_timeout='5s';
LOCK TABLE standards,criteria,compliances,evidence,"complianceAssessments","complianceEvidenceChecks","surveyorReports","surveyorStandardSummaries","surveyToolkitSnapshotCompliances","surveyToolkitTemplateCompliances" IN SHARE ROW EXCLUSIVE MODE;
CREATE TABLE standard7_backup_20260924 (table_name text NOT NULL, row_data jsonb NOT NULL);
CREATE TEMP TABLE old_c AS SELECT * FROM criteria WHERE "standardId"=6;
CREATE TEMP TABLE old_co AS SELECT co.* FROM compliances co JOIN old_c c USING ("criterionId");
CREATE TEMP TABLE old_a AS SELECT a.* FROM "complianceAssessments" a JOIN old_co c USING ("complianceId");
CREATE TEMP TABLE affected AS SELECT DISTINCT "surveyId","surveyorId" FROM old_a;
DO $$ BEGIN
 IF NOT EXISTS (SELECT 1 FROM standards WHERE "standardId"=6 AND "standardNumber"='7') THEN RAISE EXCEPTION 'Standard identity changed'; END IF;
 IF EXISTS (SELECT "surveyId" FROM affected GROUP BY "surveyId" HAVING count(*)>1) THEN RAISE EXCEPTION 'Multiple owners require manual mapping'; END IF;
END $$;
CREATE TEMP TABLE unchanged AS SELECT md5(coalesce(string_agg(row_to_json(a)::text,'|' ORDER BY a."complianceAssessmentId"),'')) checksum FROM "complianceAssessments" a WHERE a."complianceId" NOT IN (SELECT "complianceId" FROM old_co);
INSERT INTO standard7_backup_20260924 SELECT 'standards',to_jsonb(t) FROM "standards" t WHERE "standardId"=6;
INSERT INTO standard7_backup_20260924 SELECT 'criteria',to_jsonb(t) FROM "criteria" t WHERE "standardId"=6;
INSERT INTO standard7_backup_20260924 SELECT 'compliances',to_jsonb(t) FROM "compliances" t WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
INSERT INTO standard7_backup_20260924 SELECT 'evidence',to_jsonb(t) FROM "evidence" t WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
INSERT INTO standard7_backup_20260924 SELECT 'complianceAssessments',to_jsonb(t) FROM "complianceAssessments" t WHERE "complianceAssessmentId" IN (SELECT "complianceAssessmentId" FROM old_a);
INSERT INTO standard7_backup_20260924 SELECT 'complianceEvidenceChecks',to_jsonb(t) FROM "complianceEvidenceChecks" t WHERE "complianceAssessmentId" IN (SELECT "complianceAssessmentId" FROM old_a);
INSERT INTO standard7_backup_20260924 SELECT 'surveyorStandardSummaries',to_jsonb(t) FROM "surveyorStandardSummaries" t WHERE "standardId"=6;
INSERT INTO standard7_backup_20260924 SELECT 'surveyorReports',to_jsonb(t) FROM "surveyorReports" t WHERE ("surveyId","surveyorId") IN (SELECT * FROM affected);
INSERT INTO standard7_backup_20260924 SELECT 'surveyToolkitSnapshotCompliances',to_jsonb(t) FROM "surveyToolkitSnapshotCompliances" t WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
INSERT INTO standard7_backup_20260924 SELECT 'surveyToolkitTemplateCompliances',to_jsonb(t) FROM "surveyToolkitTemplateCompliances" t WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
CREATE TEMP TABLE snapshots AS SELECT DISTINCT "surveyToolkitSnapshotId" FROM "surveyToolkitSnapshotCompliances" WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
CREATE TEMP TABLE templates AS SELECT DISTINCT "surveyToolkitTemplateId" FROM "surveyToolkitTemplateCompliances" WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
INSERT INTO "surveyorReportReopens" ("surveyorReportId",reason,"reopenedByUsername","reopenedAt","previousSubmittedAt") SELECT "surveyorReportId",'Standard 7 replaced by user request; repeat assessment and summation required.','Standard 7 import',now(),"submittedAt" FROM "surveyorReports" WHERE "isSubmitted" AND ("surveyId","surveyorId") IN (SELECT * FROM affected);
UPDATE "surveyorReports" SET "isSubmitted"=false,"updatedAt"=now() WHERE "isSubmitted" AND ("surveyId","surveyorId") IN (SELECT * FROM affected);
DELETE FROM "surveyorStandardSummaries" WHERE "standardId"=6;
DELETE FROM "complianceEvidenceChecks" WHERE "complianceAssessmentId" IN (SELECT "complianceAssessmentId" FROM old_a);
DELETE FROM "complianceAssessments" WHERE "complianceAssessmentId" IN (SELECT "complianceAssessmentId" FROM old_a);
DELETE FROM "surveyToolkitSnapshotCompliances" WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
DELETE FROM "surveyToolkitTemplateCompliances" WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
DELETE FROM evidence WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
DELETE FROM compliances WHERE "complianceId" IN (SELECT "complianceId" FROM old_co);
DELETE FROM criteria WHERE "standardId"=6;
CREATE TEMP TABLE new_c (number text PRIMARY KEY,title text);
CREATE TEMP TABLE new_co (parent text,number text PRIMARY KEY,summary text);
CREATE TEMP TABLE new_e (parent text,number text,summary text,PRIMARY KEY(parent,number));
INSERT INTO new_c VALUES ('7.1','PLANNING, DESIGN AND SAFETY / ORGANISATION AND MANAGEMENT'),
('7.2','HUMAN RESOURCE DEVELOPMENT AND MANAGEMENT'),
('7.3','POLICIES AND PROCEDURES'),
('7.4','FACILITIES AND EQUIPMENT / PLANT, MEDICAL DEVICES, SUPPLIES'),
('7.5','SAFETY AND PERFORMANCE IMPROVEMENT ACTIVITIES'),
('7.6','SPECIAL REQUIREMENTS (TECHNICAL STANDARDS): BIOMEDICAL EQUIPMENT MANAGEMENT'),
('7.7','FACILITY MANAGEMENT'),
('7.8','MEDICAL GASES (CORE)'),
('7.9','ELECTRICAL SYSTEMS'),
('7.10','WATER SUPPLY'),
('7.11','CONNECTIVITY AND DATA CONTINUITY'),
('7.12','ASSET MANAGEMENT'),
('7.13','SECURITY'),
('7.14','USE OF UTILITIES');
INSERT INTO new_co VALUES ('7.1','7.1.1','Vision, Mission and values statements of the Facility are accessible. These statements are monitored, reviewed and revised as required and communicated to all staff.'),
('7.1','7.1.2','There is an organisation chart which: 
a) provides a clear representation of the structure, function and reporting relationships between the Head and the staff; 
b) is accessible to all staff and clients; 
c) includes off-site services if applicable; 
d) is revised when there is a major change in organisation, functions, reporting relationships or staffing patterns.'),
('7.1','7.1.3','Where the entire Facility and Biomedical Equipment Management and Safety Services or any part has been outsourced, there is a written agreement addressing: formal lines of communication and responsibilities; adequate numbers of qualified personnel; participation in committees; pickup and delivery; after-hours and emergency services within agreed response time; contingency plans; adequate facilities and equipment; appropriate KPIs; involvement in safety and quality activities; compliance with applicable national standards.'),
('7.1','7.1.4','Regular staff meetings are held between the Head of service and staff. Minutes are kept; decisions and resolutions are accessible, communicated to all staff and implemented.'),
('7.1','7.1.5','The Head of Facility and Biomedical Equipment Management and Safety Services is involved in the planning, justification and management of the budget and resource utilisation of the services.'),
('7.1','7.1.6','The Head of Facility and Biomedical Equipment Management and Safety Services is involved in the appointment and/or assignment of staff as well as endorsement of vendor.'),
('7.1','7.1.7','Appropriate statistics and records shall be maintained in relation to the provision of Facility and Biomedical Equipment Management and Safety Services and used for managing the services and patient care purposes.'),
('7.2','7.2.1','The Head and staff of the Facility and Biomedical Equipment Management and Safety Services shall be individuals qualified by education, training, experience and certification commensurate with the requirements of the various positions.'),
('7.2','7.2.2','The authority, responsibilities and accountabilities of the Head of Facility and Biomedical Equipment Management and Safety Services are clearly delineated and documented.'),
('7.2','7.2.3','Sufficient numbers of personnel and support staff with appropriate qualifications are employed to meet the need of the services.'),
('7.2','7.2.4','There are written and dated specific job descriptions for all categories of staff that include qualifications, training, experience and certification required; lines of authority; accountability, functions and responsibilities; and are reviewed when required or when there is major change.'),
('7.2','7.2.5','Personnel records on training, staff development, leave and others are maintained for every staff.'),
('7.2','7.2.6','There is a structured orientation programme where new staff are briefed on their services, operational policies and relevant aspects of the Facility.'),
('7.2','7.2.7','There is evidence of training needs assessment and staff development plan which provide the knowledge and skills required for staff to maintain competency.'),
('7.2','7.2.8','There are continuing education activities for staff including use of appropriate PPE, safety measures in hazardous workplaces, risk identification, nosocomial infections and compliance with relevant statutory regulations.'),
('7.2','7.2.9','Staff receive evaluation of their performance at the completion of the probationary period and annually thereafter, or as defined by the Facility.'),
('7.3','7.3.1','There are written policies and procedures for the Facility and Biomedical Equipment Management and Safety Services which are consistent with the overall policies of the Facility, regulatory requirements and current standard practices. These are signed, authorised and dated. There is a mechanism for periodic review at least once in every three years.'),
('7.3','7.3.2','Policies and procedures are developed by a committee in collaboration with staff, medical practitioners, Management and where required with other external service providers. Cross departmental collaboration is practised.'),
('7.3','7.3.3','Current policies and procedures are communicated to all staff.'),
('7.3','7.3.4','There is evidence of compliance with policies and procedures.'),
('7.3','7.3.5','Copies of policies and procedures, protocols, guidelines, relevant Acts, Regulations, By-Laws and statutory requirements are accessible to staff.'),
('7.3','7.3.6','The policies and procedures shall include emergency and contingency plans for the following outages: a) water; b) electricity; c) medical gas supply; d) communication system (PABX/Telephone/Nurse call system/PA system); e) internet connectivity.'),
('7.3','7.3.7','A permit-to-work shall always be issued before any work is carried out for all Facilities or Mechanical and Electrical works.'),
('7.4','7.4.1','There are adequate and appropriate facilities and equipment with proper utilisation of space to enable staff to carry out their professional and administrative functions.'),
('7.4','7.4.2','There is documented evidence that facilities and equipment in the Facility complies with relevant national/international standards and current statutory requirements (NHSS Volumes 1 and 3)'),
('7.4','7.4.3','There is evidence that the Facility has a comprehensive maintenance programme such as predictive maintenance, planned preventive maintenance and calibration activities, to ensure the facilities and equipment are in good working order. The maintenance programme and budget are reviewed.'),
('7.4','7.4.4','Where specialised equipment is used, there is evidence that only staff who are trained and authorised by the relevant bodies operate and maintain such equipment.'),
('7.4','7.4.5','Medical devices should be used safely with staff involved in the operation of medical devices undergoing necessary training and where necessary correct licences obtained. Devices are cleaned, sterilised and recommissioned separately from general cleaning processes.'),
('7.5','7.5.1','There are planned and systematic safety and performance improvement activities to monitor and evaluate the performance of the services. The process includes:
Planned activities
Data collection
Monitoring and evaluation 
Action plan for improvement
Implementation of action plan. 
Innovation is advocated.
Electrical safety testing'),
('7.5','7.5.2','The Head has assigned the responsibilities for planning, monitoring and managing safety and performance improvement activities to appropriate individual/personnel within the respective services.'),
('7.5','7.5.3','Staff are trained and complete incident reports which are promptly reported, investigated, discussed with learning objectives and forwarded to the PIC. Incidents have Root Cause Analysis done and action taken within the agreed time frame to prevent recurrence.'),
('7.5','7.5.4','There is tracking and trending of specific performance indicators not limited to but at least three of the following: a) percentage of planned preventive maintenance being done on schedule (Target: 98%); b) percentage of system/service uptime (Target: 92%); c) response time to equipment failure (Critical care -15 minutes; Other- 2 hours); d) repair time (Target: 7 working days).'),
('7.6','7.6.1','All biomedical equipment shall comply with the relevant national Medical Device legislation, radiation protection / Atomic Energy legislation and other applicable Acts for specific medical devices; the associated Regulations, Guidelines and national standards, where applicable. (Medical Device Regulations ISO13485)'),
('7.6','7.6.2','Life cycle costs and utilisation of biomedical equipment are reviewed and documented to support decisions on replacement, upgrade or disposal.'),
('7.6','7.6.3','There is a documented inventory of all biomedical equipment that is current, accurate and accessible.'),
('7.6','7.6.4','All biomedical equipment is included in a planned preventive maintenance (PPM) and calibration programme that follows manufacturer specifications and relevant authority requirements.'),
('7.6','7.6.5','Medical equipment breakdown repairs shall be recorded, prioritised and, where parts are required, genuine parts shall be used; repairs shall be performed by competent personnel. Upon completion of repair, performance test and electrical safety test shall be performed (if required).'),
('7.6','7.6.6','Relevant licences / certificates of fitness are acquired and kept current as required for applicable equipment (including Radiology / Diagnostic Imaging, Medical Laboratory and other regulated devices).'),
('7.6','7.6.7','Only staff who are trained and authorised operate specialised biomedical equipment. Training records and competency assessments are maintained.'),
('7.6','7.6.8','Medical equipment must be decontaminated before being sent to the biomedical workshop. The biomedical workshop shall be equipped with a cleaning area. (Cross-reference Infection Prevention & Control standards).'),
('7.6','7.6.9','There is an annual Medical Equipment Management Programme Performance Evaluation with tracking of performance indicators, audits and continual improvement projects whose results are evaluated.'),
('7.6','7.6.10','Action taken on field safety notice (FSN) / field safety corrective action (FSCA) / recall issued by the national Medical Device Authority or manufacturer is documented.'),
('7.6','7.6.11','A medical device which is no longer safe and effective for use shall be taken out of operation, removed from the facility and stored appropriately. A medical device shall be condemned or decommissioned if it is Beyond Economical Repair (BER), obsolete, or spare parts are unavailable in the market.'),
('7.6','7.6.12','A medical device which has been taken out of operation shall be removed and disposed of in a safe manner that eliminates or reduces danger and injury, danger of contamination with biological material or other contaminants, danger of environmental damage, and danger of it being re-used.'),
('7.7','7.7.1','Building structure, finishes and layout support safe patient care, infection control, accessibility and emergency egress in accordance with applicable building codes and healthcare facility guidelines.'),
('7.8','7.8.1','All staff handling the Medical Gas System (MGS) must be competent. An Authorised Person system is in place. A 24-hour monitoring alarm panel is installed at a manned staff location.'),
('7.8','7.8.2','Medical Air System is supplied at the required pressure (typically 400 kPa) for ventilators and other clinical uses and is maintained accordingly.'),
('7.8','7.8.3','Vacuum System is maintained and monitored.'),
('7.8','7.8.4','Active Anaesthetic Gas Scavenging System is installed and functioning where required.'),
('7.9','7.9.1','Electrical System – General Compliance: complies with applicable energy licensing and electrical safety requirements for medical electrical systems.'),
('7.9','7.9.2','Electrical System for Critical Areas: adequate emergency electrical generator with automatic transfer switch; Uninterrupted Power Supply (UPS) provided for life-support systems.'),
('7.10','7.10.1','Water Supply is treated as necessary. The Facility obtains water quality reports. Contingency arrangements for supply failure are in place.'),
('7.11','7.11.1','Connectivity is maintained in a stable state that supports clinical and administrative functions. Disaster recovery and data backup arrangements are documented and tested.'),
('7.12','7.12.1','There is a current asset register maintained by a designated officer covering plant, equipment and biomedical devices. New items are recorded. An asset disposal strategy exists.'),
('7.13','7.13.1','Security measures are taken to ensure the protection of patients and staff from assault and loss of property, and the Facility from damage and loss. High-risk areas (Emergency Department, treatment rooms, plant rooms, pharmacies, drug stores) are considered in planning.'),
('7.14','7.14.1','There is monitoring of water and electricity use. Efforts are made to improve efficiency. Documented contingency plans exist to address utility failures (water, electricity, medical gas, communication, internet).');
INSERT INTO new_e VALUES ('7.1.1','1','Vision, Mission and values statements of the Facility are available, endorsed and dated by the Governing Body.'),
('7.1.1','2','Goals and objectives of the Facility and Biomedical Equipment Management and Safety Services in line with the Facility statements are available, endorsed and dated.'),
('7.1.1','3','Evidence of planned reviews of the above statements.'),
('7.1.1','4','These statements are communicated to all staff (orientation programme, minutes of meeting, etc).'),
('7.1.1','5','Achievement of goals and objectives are monitored, reviewed and revised accordingly.'),
('7.1.2','1','Clearly delineated current organisation chart with line of functions and reporting relationships.'),
('7.1.2','2','Organisation chart of the service is endorsed, dated and accessible.'),
('7.1.2','3','The organisation chart is revised when there is a major change in any of the items listed.'),
('7.1.3','1','The Contract Agreement between the Facility and the external service provider(s) addresses all required items.'),
('7.1.3','2','Evaluation of service provider performance.'),
('7.1.4','1','Minutes are accessible, disseminated and acknowledged by the staff.'),
('7.1.4','2','Attendance list of members with adequate representatives of the service.'),
('7.1.4','3','Frequency of meetings as scheduled.'),
('7.1.4','4','Discussion and resolutions are implemented. Problems not solved are brought forward until resolved.'),
('7.1.5','1','Minutes of Facility-wide management meeting.'),
('7.1.5','2','Documented evidence on request for allocation of budget and resources (staffing, equipment, etc).'),
('7.1.5','3','Approved budget and resources.'),
('7.1.6','1','Records on staff interview (if applicable).'),
('7.1.6','2','Appointment/assignment letter of Head of Service.'),
('7.1.6','3','Job description of Head of Service.'),
('7.1.6','4','Records on staff deployment.'),
('7.1.6','5','Duty roster.'),
('7.1.6','6','Records on evaluation of vendor’s performance.'),
('7.1.7','1','Records  are available for statistics on technical performance indicators.'),
('7.1.7','2','Records are available for asset register.'),
('7.1.7','3','Records are available for maintenance of equipment.'),
('7.1.7','4','Records are available for staffing number and staff profiles.'),
('7.1.7','5','Records are available for staff training records.'),
('7.1.7','6','Records are available for incident reports/accidents.'),
('7.2.1','1','The head of service or any management staff shall possess relevant qualification.'),
('7.2.1','2','The head of service or any management staff shall possess at least 5 years of experience in healthcare facility management.'),
('7.2.2','1','Appointment/assignment letter for Head of Service.'),
('7.2.2','2','Description of duties and responsibilities.'),
('7.2.3','1','Number of staff and qualification should commensurate with number of equipment.'),
('7.2.3','2','Staff to have valid registration with professional and relevant authorities bodies.'),
('7.2.3','3','Staffing pattern.'),
('7.2.3','4','There is 24 hour duty roster.'),
('7.2.3','5','Census and statistics.'),
('7.2.4','1','Updated specific job description is available for each staff.'),
('7.2.4','2','Job description shall include specialisation skills.'),
('7.2.4','3','Certification by relevant bodies.'),
('7.2.4','4','The job description is acknowledged by the staff and signed by the Head of Service and dated.'),
('7.2.5','1','Staff personal records include: staff biodata; qualification and experience; evidence of current registration; training record; competency record and certification; leave record; confidentiality agreement.'),
('7.2.6','1','Policy requiring all new staff to attend a structured orientation programme.'),
('7.2.6','2','Records on structured orientation programme.'),
('7.2.6','3','Orientation module.'),
('7.2.6','4','List of attendance.'),
('7.2.7','1','Training needs assessment is carried out and includes various risks and gaps identified.'),
('7.2.7','2','A staff development plan based on training needs assessment is available.'),
('7.2.7','3','Training schedule/calendar is in place.'),
('7.2.7','4','Training module.'),
('7.2.8','1','Training calendar includes in-house/external courses/workshop/conferences.'),
('7.2.8','2','Contents of training programme.'),
('7.2.8','3','Staff education and development programme.'),
('7.2.8','4','Records on training attended.'),
('7.2.8','5','Specific training programme on clinical risks attended.'),
('7.2.9','1','Performance appraisal for staff is completed upon probationary period and as an annual exercise.'),
('7.3.1','1','Documented policies and procedures for the service.'),
('7.3.1','2','Policies and procedures are consistent with regulatory requirements and current standard practices.'),
('7.3.1','3','Policies and procedures are updated, endorsed and dated.'),
('7.3.1','4','Evidence of periodic review.'),
('7.3.2','1','Minutes of committee meetings on development and revision on policies and procedures.'),
('7.3.2','2','Minutes of meeting with evidence of cross reference with other departments.'),
('7.3.2','3','Documented cross departmental policies.'),
('7.3.3','1','Training and briefing on the current policies and procedures / Minutes of meetings.'),
('7.3.3','2','Circulation list and acknowledgement.'),
('7.3.4','1','Compliance verified through: interview of staff on practices; observation on practices; results of audit on practices; practices in line with established policies and procedures.'),
('7.3.5','1','Copies are accessible on-site for staff reference.'),
('7.3.6','1','Policies and procedures for emergency response plan (ERP) that address items (a) to (e) are in place.'),
('7.3.6','2','Contact numbers of staff in-charge / relevant authorities / vendors / suppliers is made available.'),
('7.3.6','3','Flow chart on line of communication.'),
('7.3.7','1','Documented permit for any Facilities / Mechanical and electrical works from the relevant authority is available if any works authorised.'),
('7.3.7','2','All relevant tests satisfactorily done for new works.'),
('7.4.1','1','Adequate facilities, equipment and proper utilisation of space: as-built drawings; appropriate office and workshop; appropriate equipment for repairs, testing, calibration, etc.'),
('7.4.2','1','As built drawings endorsed by Professional Engineers/Architect.'),
('7.4.2','2','Operation and Maintenance Manual.'),
('7.4.2','3','Evidence of compliance to standards, e.g. testing and commissioning records, asset records, log book and log sheet.'),
('7.4.2','4','Relevant warranty certificates.'),
('7.4.3','1','Operation and Maintenance Manual.'),
('7.4.3','2','Maintenance records.'),
('7.4.3','3','Calibration, testing and commissioning records (schedule, stickers, etc).'),
('7.4.3','4','Asset register.'),
('7.4.3','5','Planned Predictive Maintenance (PdM).'),
('7.4.3','6','Planned Preventive Maintenance (PPM) records.'),
('7.4.3','7','Planned Corrective Maintenance records.'),
('7.4.3','8','Planned Replacement Programme.'),
('7.4.3','9','Complaint records and records on work orders.'),
('7.4.3','10','Log book and log sheet.'),
('7.4.4','1','List of personnel authorised by the Person In Charge (PIC) to operate specialised equipment.'),
('7.4.4','2','Letter of authorisation.'),
('7.4.4','3','Training records.'),
('7.4.4','4','Staff profile of authorised personnel.'),
('7.4.4','5','Competency assessment records.'),
('7.4.4','6','Certificate/registration of competent person as required.'),
('7.4.5','1','Evidence that medical devices are installed, calibrated, maintained, repaired and decommissioned by qualified individuals.'),
('7.4.5','2','Medical devices are operated by staff who have received necessary training and/or licensing.'),
('7.4.5','3','Evidence of calibration when necessary (review log).'),
('7.4.5','4','Evidence that medical devices are cleaned and sterilised separately from general cleaning.'),
('7.5.1','1','Planned performance improvement activities include all steps listed.'),
('7.5.1','2','Records on performance improvement activities.'),
('7.5.1','3','Minutes of performance improvement meetings.'),
('7.5.1','4','Quality improvement studies.'),
('7.5.1','5','Records on innovation if available.'),
('7.5.1','6','Electrical safety testing'),
('7.5.2','1','Minutes of meetings.'),
('7.5.2','2','Letter of assignment of responsibilities.'),
('7.5.2','3','Job description.'),
('7.5.3','1','System for incident reporting is in place (training of staff, policy, methodology, register/records).'),
('7.5.3','2','Completed incident reports and statistics.'),
('7.5.3','3','Root Cause Analysis.'),
('7.5.3','4','Corrective and preventive action plans and remedial measures.'),
('7.5.3','5','Minutes of meetings and acknowledgment by Head of Service and PIC/Hospital Director.'),
('7.5.3','6','Feedback given to staff regarding incident reporting.'),
('7.5.4','1','Records showing tracking and trending of at least three of the listed performance indicators against the stated targets.'),
('7.6.1','1','Relevant documents pertaining to the national Medical Device legislation and applicable standards are available.'),
('7.6.1','2','Evidence of medical devices/equipment procured from licensed / authorised establishments.'),
('7.6.1','3','Medical device registration certificate (or equivalent authorisation) from the national Medical Device Authority or competent body.'),
('7.6.2','1','Records of life-cycle cost analysis and utilisation review.'),
('7.6.2','2','Equipment replacement / upgrade plan based on the review findings.'),
('7.6.3','1','Current asset / inventory register of biomedical equipment.'),
('7.6.3','2','Records show unique identification, location, status and ownership.'),
('7.6.4','1','Documented planned maintenance programme addressing inspections, supervision of service contracts and calibration of test equipment.'),
('7.6.4','2','PPM schedule follows manufacturer/supplier specifications and/or relevant authorities’ regulation.'),
('7.6.4','3','Completed planned preventive maintenance service checklist / report.'),
('7.6.4','4','Test equipment calibration report certified by an accredited third party or the manufacturer.'),
('7.6.4','5','Vendors approved by relevant authorities.'),
('7.6.5','1','Repair service log.'),
('7.6.5','2','Repair service reports.'),
('7.6.5','3','Spare-part list (evidence of genuine parts where applicable).'),
('7.6.6','1','All licenses / certificates for equipment are current and complied with.'),
('7.6.6','2','Equipment used for Radiology / Diagnostic Imaging, Medical Laboratory and other regulated areas have valid certificates of fitness / licences.'),
('7.6.7','1','List of personnel authorised by the Person in Charge (PIC) to operate specialised equipment.'),
('7.6.7','2','Letter of authorisation.'),
('7.6.7','3','Training records and competency assessment records.'),
('7.6.7','4','Certificate / registration of competent person as required by national regulations.'),
('7.6.8','1','Designated area for cleaning within the biomedical equipment workshop.'),
('7.6.8','2','Procedure for cleaning is in place and being practiced.'),
('7.6.9','1','Annual Medical Equipment Management Programme Performance Evaluation Report.'),
('7.6.9','2','Records on performance indicators and audits.'),
('7.6.9','3','Continual improvement project record / report.'),
('7.6.10','1','Recall notice (if any) and evidence of compliance.'),
('7.6.10','2','Action taken on safety notice issued by any competent authority.'),
('7.6.11','1','Condition appraisal by a qualified biomedical engineer / vendor.'),
('7.6.11','2','Recommendation from users and/or technical experts on the ineffectiveness of any medical device.'),
('7.6.12','1','Plan / Programme for disposal of equipment is available.'),
('7.6.12','2','Contractor / vendor for the disposal programme is qualified and competent.'),
('7.6.12','3','Disposal of radioactive-related equipment complies with the requirements of the relevant national environmental and radiation protection authorities.'),
('7.7.1','1','As-built drawings endorsed by Professional Engineers / Architect.'),
('7.7.1','2','Evidence of compliance with relevant building and fire safety codes.'),
('7.7.1','3','Accessibility features (ramps, handrails, signage) documented.'),
('7.8.1','1','List of Authorised Persons for the Medical Gas System with competency records.'),
('7.8.1','2','Training and competency assessment records for MGS handlers.'),
('7.8.1','3','Evidence of 24-hour monitoring alarm panel installed at a manned location.'),
('7.8.1','4','Alarm response procedures and records of tests.'),
('7.8.2','1','Pressure monitoring records meeting the required specification.'),
('7.8.2','2','Maintenance and test records for the Medical Air System.'),
('7.8.3','1','Maintenance records for the vacuum system.'),
('7.8.3','2','Performance monitoring logs.'),
('7.8.4','1','Evidence of installation and functional testing of the scavenging system.'),
('7.8.4','2','Maintenance records.'),
('7.9.1','1','Valid electrical licences / certificates of fitness.'),
('7.9.1','2','Periodic inspection and testing records.'),
('7.9.1','3','Compliance documentation with relevant electrical safety standards for medical installations.'),
('7.9.2','1','Generator capacity and automatic transfer switch test records.'),
('7.9.2','2','UPS for life-support and critical systems – capacity and test records.'),
('7.9.2','3','Emergency power test logs and maintenance records.'),
('7.10.1','1','Current water quality test reports.'),
('7.10.1','2','Treatment system maintenance records (if applicable).'),
('7.10.1','3','Documented contingency plan for water supply failure including storage and alternative sources.'),
('7.10.1','4','Contact list of relevant authorities / vendors for emergency water supply.'),
('7.11.1','1','Network / Wi-Fi connectivity arrangements that ensure clinical staff reachability.'),
('7.11.1','2','Data recovery process documented and tested.'),
('7.11.1','3','Back-up data stored off premises to prevent loss.'),
('7.11.1','4','Effective disaster recovery plan to restore medical data with minimal downtime.'),
('7.11.1','5','Important files backed up at minimum once a week (preferably every 24 hours), manually or automatically.'),
('7.11.1','6','System in place allowing recovery of data and archive of computer data in case of corruption or deletion.'),
('7.12.1','1','Evidence of a current assets register (condition, availability and performance).'),
('7.12.1','2','Evidence of a designated officer to manage the assets register.'),
('7.12.1','3','Evidence that new items are recorded in asset registration.'),
('7.12.1','4','The asset register contains information on plants, equipment and biomedical devices.'),
('7.12.1','5','There is an asset disposal strategy.'),
('7.13.1','1','Organisation-wide system to identify major security risks and implement controls.'),
('7.13.1','2','Memorandum of Agreement if external security services are used.'),
('7.13.1','3','Lighting in potential risk areas; security cameras; access restriction (swipe cards / code pads); escape routes; zero-aggression measures.'),
('7.14.1','1','Evidence of monitoring water and energy use (reports).'),
('7.14.1','2','Evidence of efforts to improve efficiency.'),
('7.14.1','3','Evidence of documented contingency plans to address utility failures (water, electricity, medical gas, communication system, internet connectivity).');
UPDATE standards SET "standardTitle"='PHYSICAL INFRASTRUCTURE, ENGINEERING, ENVIRONMENT MANAGEMENT AND SAFETY PROTOCOLS',"standardSummary"='STANDARD: The infrastructure for a Health Service Organisation (HSO) is developed based on population, disease burden and geography. Environmental Management Standards are implemented to support the safety and maintenance of buildings and the surrounding areas; including walkways, plant and other equipment, medical devices, the management of its supplies and consumables, utilities including electricity and water, and workplace design, signage and fire safety.
The organisation’s management of its assets, goods and general services is an aspect of its responsibility to ensure the safety of consumers / patients and guardians, staff, contractors and other visitors and to manage risk.
Source(s)
Standard 7, National Health Service Standards (NHSS) Vol. 2 (2nd Edition) 2021-2030 (National Quality Standards)
National Health Service Standards (NHSS) Vol. 1 and 3 (2nd Edition) 2021-2030 (National Quality Standards)
Design Standards for Health Facilities Development
Health Facilities Infrastructure Design, Standard and Compliance
Rapid Assessment Tool for Health Facilities L3-5
Asset Management Policy 2015' WHERE "standardId"=6;
INSERT INTO criteria ("criterionNumber","criterionTitle","standardId","isApplicable") SELECT number,title,6,true FROM new_c;
INSERT INTO compliances ("complianceNumber","complianceSummary","criterionId","isApplicable") SELECT n.number,n.summary,c."criterionId",true FROM new_co n JOIN criteria c ON c."criterionNumber"=n.parent AND c."standardId"=6;
INSERT INTO evidence ("evidenceNumber","evidenceSummary","complianceId","isApplicable") SELECT n.number,n.summary,co."complianceId",true FROM new_e n JOIN compliances co ON co."complianceNumber"=n.parent JOIN criteria c ON c."criterionId"=co."criterionId" AND c."standardId"=6;
CREATE TEMP TABLE replacement AS SELECT co.* FROM compliances co JOIN criteria c USING ("criterionId") WHERE c."standardId"=6;
INSERT INTO "complianceAssessments" ("surveyId","surveyorId","complianceId") SELECT a."surveyId",a."surveyorId",c."complianceId" FROM affected a CROSS JOIN replacement c;
INSERT INTO "complianceEvidenceChecks" ("complianceAssessmentId","evidenceId","isChecked") SELECT a."complianceAssessmentId",e."evidenceId",false FROM "complianceAssessments" a JOIN replacement c USING ("complianceId") JOIN evidence e USING ("complianceId");
INSERT INTO "surveyToolkitSnapshotCompliances" ("surveyToolkitSnapshotId","complianceId") SELECT s."surveyToolkitSnapshotId",c."complianceId" FROM snapshots s CROSS JOIN replacement c;
INSERT INTO "surveyToolkitTemplateCompliances" ("surveyToolkitTemplateId","complianceId") SELECT s."surveyToolkitTemplateId",c."complianceId" FROM templates s CROSS JOIN replacement c;
DO $$ BEGIN
 IF (SELECT count(*) FROM criteria WHERE "standardId"=6)<>14 OR (SELECT count(*) FROM replacement)<>56 OR (SELECT count(*) FROM evidence e JOIN replacement c USING ("complianceId"))<>187 THEN RAISE EXCEPTION 'Framework counts failed'; END IF;
 IF (SELECT count(*) FROM "complianceAssessments" a JOIN replacement c USING ("complianceId")) <> 56*(SELECT count(*) FROM affected) THEN RAISE EXCEPTION 'Checklist counts failed'; END IF;
 IF (SELECT checksum FROM unchanged) IS DISTINCT FROM (SELECT md5(coalesce(string_agg(row_to_json(a)::text,'|' ORDER BY a."complianceAssessmentId"),'')) FROM "complianceAssessments" a WHERE a."complianceId" NOT IN (SELECT "complianceId" FROM replacement)) THEN RAISE EXCEPTION 'Other assessments changed'; END IF;
END $$;
SELECT json_build_object('standardId',6,'criteria',14,'compliances',56,'evidence',187,'affectedSurveys',(SELECT json_agg("surveyId") FROM affected),'resetAssessments',(SELECT count(*) FROM old_a),'newAssessments',56*(SELECT count(*) FROM affected),'backupRows',(SELECT count(*) FROM standard7_backup_20260924));
COMMIT;
