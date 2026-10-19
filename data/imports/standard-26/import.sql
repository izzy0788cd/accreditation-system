BEGIN;
SET LOCAL lock_timeout = '5s';
DO $$ BEGIN
IF EXISTS (SELECT 1 FROM standards WHERE "standardNumber"='26' OR lower("standardTitle") LIKE '%blood%') THEN
 RAISE EXCEPTION 'Blood products standard already exists; stop and review'; END IF;
IF NOT EXISTS (SELECT 1 FROM functions WHERE "functionId"=4 AND "functionTitle"='Essential Clinical Care')
 OR NOT EXISTS (SELECT 1 FROM components WHERE "componentId"=6 AND "componentName"='Essential Clinical Care') THEN
 RAISE EXCEPTION 'Parent mapping changed'; END IF;
END $$;
CREATE TEMP TABLE import_c (number text PRIMARY KEY, title text NOT NULL) ON COMMIT DROP;
CREATE TEMP TABLE import_co (criterion_number text NOT NULL, number text PRIMARY KEY, summary text NOT NULL) ON COMMIT DROP;
CREATE TEMP TABLE import_e (compliance_number text NOT NULL, number text NOT NULL, summary text NOT NULL, PRIMARY KEY(compliance_number,number)) ON COMMIT DROP;
INSERT INTO import_c VALUES
('26.1','Administration of blood and blood components / products and associated risks'),
('26.2','Storage conditions and transportation of samples and blood and blood products'),
('26.3','Ongoing education'),
('26.4','Patient education'),
('26.5','Risk management');
INSERT INTO import_co VALUES
('26.1','26.1.1','The Facility assures an effective blood, blood component, blood product and transfusion management system. Approved procedures should include:
Patient identification
Prescription and documentation of blood products
Adverse event management
Blood product storage
Minimum information for samples, request forms, sampling and labelling
Timeliness of urgent requests
Consent for transfusion/Pathway if consent not given
Appropriateness of blood component therapy
Blood conservation therapy and alternatives to transfusion
High-risk situations such as massive transfusion'),
('26.1','26.1.2','The Facility ensures the safe management of blood and blood component / product administration requires the organisation to provide patients and guardians with all relevant information, and to obtain informed consent from the patient.'),
('26.2','26.2.1','The Facility ensures it has guidelines addressing storage conditions and transportation of samples and blood and blood products. 
These guidelines should include conditions and transportation of samples and blood and blood products, and include: 
(i) validating, monitoring and recording of temperature for all blood fridges 
(ii) maintenance standards for all blood fridges
(iii) the response to blood fridge alarms 
(iv) delivery, placement and removal of blood and blood products from any blood fridge / controlled storage / pneumatic tubes / other transportation systems 
(v) monitoring of blood and blood product usage and wastage 
(vi) documented audit trails'),
('26.3','26.3.1','The Facility ensures that all relevant health professionals are provided with orientation and ongoing education on blood products. This should include:
Patient identification and sample collection
Storage and transportation of samples and blood products
Blood product therapy prescription and safe administration'),
('26.4','26.4.1','The Facility ensures that patients and guardians are fully informed.

Patients are given information in verbal and/or printed form, with the use of appropriate languages / formats and the assistance of an interpreter when required, to ensure that the patient can give informed consent or refuse consent'),
('26.5','26.5.1','The Facility ensures that transfusing blood, blood components or blood products, regardless of how infrequently it occurs, have effective systems that promote safe and appropriate blood management.');
INSERT INTO import_e VALUES
('26.1.1','1','The Facility has guidelines addressing blood management which are consistent with relevant legislation, standards, guidelines and/or codes of practice.'),
('26.1.1','2','Evidence of documentation of indication and prescription of blood products'),
('26.1.1','3','Evidence of  management of adverse reaction to blood product.'),
('26.1.1','4','Evidence of timeliness of urgent blood product administration.'),
('26.1.1','5','Evidence of proper labelling of blood samples.'),
('26.1.1','6','Evidence of verification of correct patient and blood product'),
('26.1.2','1','Informed consent is taken for administration of a blood product'),
('26.1.2','2','There is documentation in patient’s notes on the discussion with the patient for the need of blood products including risks  and benefits.'),
('26.1.2','3','There are relevant brochures etc.that can be handed to patients in addition to verbal explanations.'),
('26.1.2','4','There is a standard blood donor questionnaire (sight).'),
('26.2.1','1','Evidence that blood fridge temperatues are monitored.'),
('26.2.1','2','Evidence that fridge maintenance standards are adhered to.'),
('26.2.1','3','Evidence of response to blood fridge alarms.'),
('26.2.1','4','Monitoring of blood product usage and wastage.'),
('26.2.1','5','Inventory register of blood products.'),
('26.2.1','6','Evidence that labels are checked every time a blood product is handled.'),
('26.3.1','1','Evidence that all relevant staff have been trained in the correct techniques and for sample collection and the administration of blood and blood components / products.'),
('26.3.1','2','Evidence of competency assessment of patient identification, consent process, sample collection correct blood product presciption and collection and management of adverse events for health staff.'),
('26.4.1','1','Evidence that.'),
('26.4.1','2','Evidence that patients and guardians are being kept informed of the risks and benefits of, and alternatives to, transfusion, and the risks from non-administration.'),
('26.5.1','1','Evidence that health professionals report blood transfusion related incidents.'),
('26.5.1','2','Evidence that sampling and blood product errors, near misses and adverse events are regularly analysed and strategies are taken to mitigate the risk.'),
('26.5.1','3','Reports of the evaluation of the blood management system is reported to the CEO, management team  and the clinial governance committee');
INSERT INTO standards ("standardNumber","standardTitle","standardSummary","functionId","componentId") VALUES ('26','Blood products','The Standard is that the Facility manages sample collection, blood, blood components / blood products and patient blood management to ensure safe and appropriate practice.

Source references
Standard 26, National Health Service Standards (NHSS) Vol. 2 (2nd Edition) 2021-2030
NHSS Toolkit Assessment for Level 5 and 6 Facilities in Papua New Guinea 2021-2030',4,6);
INSERT INTO criteria ("criterionNumber","criterionTitle","standardId","isApplicable")
 SELECT x.number,x.title,s."standardId",true FROM import_c x CROSS JOIN standards s WHERE s."standardNumber"='26';
INSERT INTO compliances ("complianceNumber","complianceSummary","criterionId","isApplicable")
 SELECT x.number,x.summary,c."criterionId",true FROM import_co x JOIN criteria c ON c."criterionNumber"=x.criterion_number
 JOIN standards s ON s."standardId"=c."standardId" WHERE s."standardNumber"='26';
INSERT INTO evidence ("evidenceNumber","evidenceSummary","complianceId","isApplicable")
 SELECT x.number,x.summary,co."complianceId",true FROM import_e x JOIN compliances co ON co."complianceNumber"=x.compliance_number
 JOIN criteria c ON c."criterionId"=co."criterionId" JOIN standards s ON s."standardId"=c."standardId" WHERE s."standardNumber"='26';
DO $$ BEGIN
IF (SELECT count(*) FROM import_c x JOIN criteria c ON c."criterionNumber"=x.number AND c."criterionTitle"=x.title
 JOIN standards s ON s."standardId"=c."standardId" WHERE s."standardNumber"='26')<>5 THEN RAISE EXCEPTION 'Criterion verification failed'; END IF;
IF (SELECT count(*) FROM import_co x JOIN compliances co ON co."complianceNumber"=x.number AND co."complianceSummary"=x.summary
 JOIN criteria c ON c."criterionId"=co."criterionId" AND c."criterionNumber"=x.criterion_number
 JOIN standards s ON s."standardId"=c."standardId" WHERE s."standardNumber"='26')<>6 THEN RAISE EXCEPTION 'Compliance verification failed'; END IF;
IF (SELECT count(*) FROM import_e x JOIN compliances co ON co."complianceNumber"=x.compliance_number
 JOIN criteria c ON c."criterionId"=co."criterionId" JOIN standards s ON s."standardId"=c."standardId"
 JOIN evidence e ON e."complianceId"=co."complianceId" AND e."evidenceNumber"=x.number AND e."evidenceSummary"=x.summary
 WHERE s."standardNumber"='26')<>23 THEN RAISE EXCEPTION 'Evidence verification failed'; END IF;
END $$;
COMMIT;
SELECT json_build_object('standardId',s."standardId",'standardNumber',s."standardNumber",'title',s."standardTitle",
 'criteria',count(distinct c."criterionId"),'compliances',count(distinct co."complianceId"),'evidence',count(e."evidenceId"), 'importedAt',CURRENT_TIMESTAMP)
 FROM standards s JOIN criteria c ON c."standardId"=s."standardId" JOIN compliances co ON co."criterionId"=c."criterionId"
 JOIN evidence e ON e."complianceId"=co."complianceId" WHERE s."standardNumber"='26' GROUP BY s."standardId";
