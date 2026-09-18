import { useEffect, useMemo, useState } from "react";
import { Link, useParams, useSearchParams } from "react-router-dom";
import {
  getAll,
  getInternalAssessmentReferences,
  getMySurveyAssessments,
  getMySurveyEvidenceChecks,
  getOne,
  getSurveyAssessments,
  getSurveyEvidenceChecks,
} from "../../api/api";
import SurveyContextNav from "../../components/SurveyContextNav";
import { useAuth } from "../../context/AuthContext";
import { compareReferenceNumber } from "../../utils/numberSort";
import "../reports/surveyReports.css";

const sortReference = (first, second) => compareReferenceNumber(first, second);

const scoreText = (assessment) => {
  if (!assessment?.scoreId) return "Not recorded";
  return assessment.scoreValue == null ? "N/A" : `${assessment.scoreValue} · ${assessment.scoreLabel || "Recorded rating"}`;
};

function EvidenceList({ checks }) {
  if (!checks.length) return <p className="text-sm italic text-[#4b5f7a]">No evidence items are linked to this requirement.</p>;
  return <ol className="toolkit-evidence space-y-2">{checks.map((check) => <li key={check.complianceEvidenceCheckId} className="flex gap-2 text-sm leading-5 text-[#243e5f]">
    <span aria-label={check.isChecked ? "Evidence checked" : "Evidence not checked"} className="mt-0.5 text-base leading-4 text-[#16803a]">{check.isChecked ? "☑" : "☐"}</span>
    <span className="text-justify"><strong className="text-[#092a5a]">{check.evidenceNumber}.</strong> {check.evidenceSummary}</span>
  </li>)}</ol>;
}

function AssessmentRecord({ item, isExternal }) {
  const { assessment, evidence, internalReference } = item;
  return <article className="toolkit-compliance border-b border-[#c9d8e6] py-3">
    <div>
      <p className="text-[11px] font-bold uppercase tracking-[0.13em] text-[#16803a]">Compliance {assessment.complianceNumber}</p>
      <p className="mt-1 text-justify text-sm font-semibold leading-5 text-[#092a5a]">{assessment.complianceSummary}</p>
    </div>

    <section className="mt-3">
      <h4 className="text-[11px] font-bold uppercase tracking-[0.14em] text-[#876318]">Evidence</h4>
      <div className="mt-2"><EvidenceList checks={evidence} /></div>
    </section>

    {isExternal && <section className="toolkit-internal-reference mt-3 rounded border border-sky-300 bg-sky-50 p-3">
      <h4 className="text-[11px] font-bold uppercase tracking-[0.14em] text-sky-800">Internal self-assessment — reference only</h4>
      {internalReference ? <dl className="mt-2 grid gap-2 text-sm sm:grid-cols-[8rem_8rem_minmax(0,1fr)]"><div className="rounded border border-sky-200 bg-white px-2 py-1.5"><dt className="text-[10px] font-bold uppercase tracking-wider text-sky-700">Score</dt><dd className="mt-0.5 font-semibold text-[#092a5a]">{scoreText(internalReference)}</dd></div><div className="rounded border border-sky-200 bg-white px-2 py-1.5"><dt className="text-[10px] font-bold uppercase tracking-wider text-sky-700">Risk</dt><dd className="mt-0.5 font-semibold text-[#092a5a]">{internalReference.riskValue || "Not recorded"}</dd></div><div><dt className="text-[10px] font-bold uppercase tracking-wider text-sky-700">Comments</dt><dd className="mt-0.5 text-justify leading-5 text-[#385273]">{internalReference.complianceComments || "No internal comments recorded."}</dd></div></dl> : <p className="mt-1.5 text-sm text-sky-800">No internal self-assessment recorded.</p>}
    </section>}

    <section className="toolkit-writing-grid mt-3 grid gap-3 rounded border border-[#c9d8e6] bg-[#f1f7fb] p-3 text-sm sm:grid-cols-[8rem_8rem_minmax(0,1fr)]">
      <div><p className="text-[10px] font-bold uppercase tracking-wider text-[#4b5f7a]">Score</p><div aria-label="Blank score entry box" className="mt-1.5 h-8 rounded border border-[#8fa9c4] bg-white" /></div>
      <div><p className="text-[10px] font-bold uppercase tracking-wider text-[#4b5f7a]">Risk rating</p><div aria-label="Blank risk rating entry box" className="mt-1.5 h-8 rounded border border-[#8fa9c4] bg-white" /></div>
      <div><p className="text-[10px] font-bold uppercase tracking-wider text-[#4b5f7a]">Comments / recommendations</p><div aria-label="Four blank lines for surveyor comments" className="mt-1.5 space-y-3 pt-1">{[1, 2, 3, 4].map((line) => <div key={line} className="h-1 border-b border-[#8fa9c4]" />)}</div></div>
    </section>
  </article>;
}

function StandardResultsSummary({ standard }) {
  return <section className="toolkit-standard-summary mt-4 overflow-hidden border border-[#1e293b] bg-white">
    <header className="border-b border-[#1e293b] bg-[#d7ebc7] px-3 py-2"><p className="font-serif text-sm font-bold uppercase text-black">Summary sheet</p><h3 className="mt-1 font-serif text-sm font-bold text-black">Standard {standard.standardNumber}: {standard.standardTitle}</h3></header>
    <table className="w-full border-collapse text-left text-xs text-black"><thead><tr className="bg-[#f7cfac]"><th className="border border-[#1e293b] px-2 py-2">No.</th><th className="border border-[#1e293b] px-2 py-2 text-left">Criteria for Compliance &amp; Annotation</th><th className="border border-[#1e293b] px-2 py-2">Score</th><th className="border border-[#1e293b] px-2 py-2">Risk Rating</th><th className="border border-[#1e293b] px-2 py-2">Summary of Recommendation(s) / Comments</th></tr></thead><tbody>{standard.criteria.map((criterion) => <tr key={criterion.criterionId} className="align-top"><td className="border border-[#1e293b] px-2 py-3 font-semibold">{criterion.criterionNumber}</td><td className="border border-[#1e293b] px-2 py-3 text-left font-semibold">{criterion.criterionTitle}</td><td className="border border-[#1e293b] px-2 py-3" /><td className="border border-[#1e293b] px-2 py-3" /><td className="border border-[#1e293b] px-2 py-3" /></tr>)}<tr className="bg-[#f7cfac]"><td colSpan="2" className="border border-[#1e293b] px-2 py-3 text-right font-bold">TOTALS:</td><td className="border border-[#1e293b] px-2 py-3" /><td className="border border-[#1e293b] px-2 py-3" /><td className="border border-[#1e293b] px-2 py-3" /></tr></tbody></table>
  </section>;
}

function CalculationGuide() {
  return <section className="toolkit-calculation-guide mt-5 rounded border-2 border-[#315c88] bg-[#edf5fc] p-4 text-sm text-[#092a5a]"><h2 className="text-sm font-bold uppercase tracking-[0.12em]">Scoring calculation guide</h2><ul className="mt-2 space-y-1.5 leading-5"><li><strong>Compliance score:</strong> record 1 (Poor), 2 (Fair), 3 (Good), or 4 (Full achievement). Record N/A only where the requirement does not apply.</li><li><strong>Criterion score (%):</strong> total the numeric compliance scores in that criterion ÷ (number of assessed, applicable compliance items × 4) × 100.</li><li><strong>Standard score (%):</strong> total the numeric compliance scores in that standard ÷ (number of assessed, applicable compliance items × 4) × 100.</li><li><strong>Important:</strong> N/A and unassessed requirements are excluded. A result remains provisional until all applicable requirements are scored.</li></ul></section>;
}

export default function SurveyToolkitPrintPage() {
  const { surveyId } = useParams();
  const [searchParams] = useSearchParams();
  const { auth } = useAuth();
  const [survey, setSurvey] = useState(null);
  const [assessments, setAssessments] = useState([]);
  const [criteria, setCriteria] = useState([]);
  const [compliances, setCompliances] = useState([]);
  const [standardDefinitions, setStandardDefinitions] = useState([]);
  const [checks, setChecks] = useState([]);
  const [internalReferences, setInternalReferences] = useState([]);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);
  const [standardFilter, setStandardFilter] = useState("");
  const [surveyorFilter, setSurveyorFilter] = useState("");
  const isAdminSurveyorMode = auth?.roleName === "Admin" && searchParams.get("mode") === "surveyor";
  const assignedOnly = auth?.roleName === "Surveyor" || isAdminSurveyorMode;
  const isExternal = survey?.surveyTypeName === "External";

  useEffect(() => {
    let active = true;
    const load = async () => {
      try {
        setLoading(true);
        const [surveyResponse, assessmentResponse, evidenceResponse, criteriaResponse, complianceResponse, standardResponse, referenceResponse] = await Promise.all([
          getOne("surveys", surveyId),
          assignedOnly ? getMySurveyAssessments(surveyId) : getSurveyAssessments(surveyId),
          assignedOnly ? getMySurveyEvidenceChecks(surveyId) : getSurveyEvidenceChecks(surveyId),
          getAll("criteria"),
          getAll("compliances"),
          getAll("standards"),
          getInternalAssessmentReferences(surveyId).catch(() => ({ data: [] })),
        ]);
        if (!active) return;
        setSurvey(surveyResponse.data);
        setAssessments(assessmentResponse.data);
        setChecks(evidenceResponse.data);
        setCriteria(criteriaResponse.data);
        setCompliances(complianceResponse.data);
        setStandardDefinitions(standardResponse.data);
        setInternalReferences(referenceResponse.data);
        setError("");
      } catch (loadError) {
        console.error(loadError);
        if (active) setError("The printable toolkit could not be loaded. Please confirm that this survey has generated its checklist.");
      } finally {
        if (active) setLoading(false);
      }
    };
    load();
    return () => { active = false; };
  }, [surveyId, assignedOnly]);

  const standards = useMemo(() => {
    const complianceById = new Map(compliances.map((compliance) => [compliance.complianceId, compliance]));
    const criterionById = new Map(criteria.map((criterion) => [criterion.criterionId, criterion]));
    const standardById = new Map(standardDefinitions.map((standard) => [standard.standardId, standard]));
    const checksByAssessment = checks.reduce((map, check) => {
      const existing = map.get(check.complianceAssessmentId) || [];
      existing.push(check);
      map.set(check.complianceAssessmentId, existing);
      return map;
    }, new Map());
    const internalByCompliance = new Map(internalReferences.map((reference) => [reference.complianceId, reference]));
    const grouped = new Map();

    assessments.forEach((assessment) => {
      const compliance = complianceById.get(assessment.complianceId);
      const criterion = criterionById.get(compliance?.criterionId);
      if (!criterion) return;
      const standardKey = String(criterion.standardId);
      if (!grouped.has(standardKey)) grouped.set(standardKey, {
        standardId: criterion.standardId,
        standardNumber: criterion.standardNumber || "—",
        standardTitle: criterion.standardTitle || "Standard title not available",
        standardSummary: standardById.get(criterion.standardId)?.standardSummary || "",
        criteria: new Map(),
      });
      const standard = grouped.get(standardKey);
      const criterionKey = String(criterion.criterionId);
      if (!standard.criteria.has(criterionKey)) standard.criteria.set(criterionKey, {
        criterionId: criterion.criterionId,
        criterionNumber: criterion.criterionNumber || "—",
        criterionTitle: criterion.criterionTitle || "Criterion title not available",
        items: [],
      });
      standard.criteria.get(criterionKey).items.push({
        assessment,
        evidence: (checksByAssessment.get(assessment.complianceAssessmentId) || []).slice().sort((first, second) => sortReference(first.evidenceNumber, second.evidenceNumber)),
        internalReference: internalByCompliance.get(assessment.complianceId),
      });
    });

    return [...grouped.values()].map((standard) => ({
      ...standard,
      criteria: [...standard.criteria.values()].map((criterion) => ({
        ...criterion,
        items: criterion.items.sort((first, second) => sortReference(first.assessment.complianceNumber, second.assessment.complianceNumber)),
      })).sort((first, second) => sortReference(first.criterionNumber, second.criterionNumber)),
    })).sort((first, second) => sortReference(first.standardNumber, second.standardNumber));
  }, [assessments, checks, compliances, criteria, internalReferences, standardDefinitions]);

  const surveyors = useMemo(() => [...new Set(assessments.map((assessment) => assessment.surveyorName).filter(Boolean))]
    .sort((first, second) => first.localeCompare(second)), [assessments]);
  const filteredStandards = useMemo(() => standards
    .filter((standard) => !standardFilter || String(standard.standardId) === standardFilter)
    .map((standard) => ({
      ...standard,
      criteria: standard.criteria.map((criterion) => ({
        ...criterion,
        items: criterion.items.filter((item) => !surveyorFilter || item.assessment.surveyorName === surveyorFilter),
      })).filter((criterion) => criterion.items.length),
    })).filter((standard) => standard.criteria.length), [standards, standardFilter, surveyorFilter]);

  const selectedStandards = filteredStandards.map((standard) => standard.standardNumber).join(", ");

  if (loading) return <main className="mx-auto max-w-7xl px-4 py-12 text-sm text-[#4b5f7a] sm:px-6">Preparing printable toolkit…</main>;
  if (error) return <main className="mx-auto max-w-7xl px-4 py-12 sm:px-6"><p className="rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-800">{error}</p></main>;

  return <main className="survey-toolkit-print mx-auto max-w-6xl px-4 py-6 sm:px-6 lg:px-8">
    <div className="print:hidden flex flex-wrap items-center justify-between gap-3">
      <Link to={`/surveys/${surveyId}${isAdminSurveyorMode ? "?mode=surveyor" : ""}`} className="rounded-lg border border-[#c5d5e8] bg-white px-3 py-2 text-sm font-semibold text-[#385273] transition hover:bg-[#f3faf8] hover:text-[#16803a]">← Back to assessment</Link>
      <button type="button" onClick={() => window.print()} className="rounded-lg bg-[#16803a] px-4 py-2 text-sm font-bold text-white shadow-sm transition hover:bg-[#0f6b3c]">Print / Save PDF</button>
    </div>
    <SurveyContextNav surveyId={surveyId} />

    <section className="print:hidden mt-5 rounded-xl border border-[#dbe5ef] bg-white p-4 shadow-sm sm:p-5">
      <div className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between"><div><p className="text-xs font-bold uppercase tracking-[0.14em] text-[#16803a]">Print scope</p><h2 className="mt-1 font-bold text-[#092a5a]">Choose what to include</h2><p className="mt-1 text-sm text-[#4b5f7a]">Filters apply immediately to the on-screen toolkit and the printed PDF.</p></div><button type="button" onClick={() => { setStandardFilter(""); setSurveyorFilter(""); }} className="text-sm font-semibold text-[#16803a] hover:text-[#0f6b3c]">Clear filters</button></div>
      <div className="mt-4 grid gap-4 sm:grid-cols-2"><label className="text-sm font-semibold text-[#385273]">Standard<select value={standardFilter} onChange={(event) => setStandardFilter(event.target.value)} className="mt-1.5 w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm text-[#092a5a]"><option value="">All standards</option>{standards.map((standard) => <option key={standard.standardId} value={standard.standardId}>{standard.standardNumber} · {standard.standardTitle}</option>)}</select></label><label className="text-sm font-semibold text-[#385273]">Assigned surveyor<select value={surveyorFilter} onChange={(event) => setSurveyorFilter(event.target.value)} className="mt-1.5 w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm text-[#092a5a]"><option value="">All assigned surveyors</option>{surveyors.map((surveyor) => <option key={surveyor} value={surveyor}>{surveyor}</option>)}</select></label></div>
    </section>

    <article className="survey-report toolkit-document mt-6">
    <header className="report-cover toolkit-cover">
      <div className="report-masthead"><span>Health facility accreditation</span><span>Survey #{survey?.surveyId}</span></div>
      <p className="report-eyebrow">{survey?.surveyTypeName} survey toolkit</p><h1>{survey?.facilityName || "Survey facility"}</h1><p className="report-subtitle">Field assessment checklist</p>
      <dl className="report-metadata toolkit-meta"><div><dt>Assessment period</dt><dd>{survey?.startDate} — {survey?.endDate}</dd></div><div><dt>Survey type</dt><dd>{survey?.surveyTypeName || "Not recorded"}</dd></div><div><dt>Team lead</dt><dd>{survey?.surveyorName || "Not recorded"}</dd></div><div><dt>Surveyor</dt><dd className="min-h-5 border-b border-[#8fa9c4]">{surveyorFilter || ""}</dd></div><div><dt>Standard(s)</dt><dd>{selectedStandards || "No standards selected"}</dd></div></dl>
      {isExternal && <p className="report-method"><strong>External survey:</strong> internal score, risk and comments are reference-only.</p>}
    </header>

    <div className="mt-5 space-y-5">{filteredStandards.length ? filteredStandards.map((standard) => <section key={standard.standardId} className="toolkit-standard">
      <header className="bg-[#0f6b3c] px-4 py-3 text-white"><p className="text-[10px] font-bold uppercase tracking-[0.15em] text-[#b9f5d1]">Standard {standard.standardNumber}</p><h2 className="mt-0.5 text-sm font-bold leading-5">{standard.standardTitle}</h2></header>
      <div className="space-y-4 pt-3">{standard.criteria.map((criterion) => <section key={criterion.criterionId} className="toolkit-criterion">
        <header className="border-b-2 border-[#16803a] pb-1"><p className="text-[10px] font-bold uppercase tracking-[0.13em] text-[#876318]">Criterion {criterion.criterionNumber}</p><h3 className="mt-0.5 text-justify text-sm font-semibold leading-5 text-[#092a5a]">{criterion.criterionTitle}</h3></header>
        <div className="space-y-3">{criterion.items.map((item) => <AssessmentRecord key={item.assessment.complianceAssessmentId} item={item} isExternal={isExternal} />)}</div>
      </section>)}<StandardResultsSummary standard={standard} /></div>
    </section>) : <section className="rounded-xl border border-[#dbe5ef] bg-white p-8 text-center text-sm text-[#4b5f7a]">No checklist requirements are available for this survey scope.</section>}</div>
    <CalculationGuide />
    </article>

    <style>{`@media print { @page { size: A4; margin: 13mm 14mm; } body { background: #fff !important; } .print\\:hidden { display: none !important; } .survey-toolkit-print { max-width: none !important; padding: 0 !important; } .toolkit-document { max-width: none !important; } .toolkit-cover { margin-top: 0 !important; } .toolkit-standard { break-before: auto !important; break-inside: auto !important; margin-bottom: 10px !important; } .toolkit-standard header { padding: 7px 9px !important; } .toolkit-standard h2, .toolkit-criterion h3 { font-size: 9pt !important; line-height: 1.25 !important; } .toolkit-compliance { break-inside: auto !important; padding: 6px 0 !important; } .toolkit-criterion { break-inside: auto !important; } .toolkit-evidence { font-size: 8pt !important; line-height: 1.25 !important; } .toolkit-internal-reference { font-size: 8pt !important; } .toolkit-writing-grid { grid-template-columns: 90px 90px minmax(0, 1fr) !important; gap: 8px !important; } .toolkit-standard-summary { break-before: page; break-inside: avoid; } .toolkit-standard-summary th, .toolkit-standard-summary td { text-align: left !important; vertical-align: top !important; } .toolkit-standard-summary th:nth-child(1) { width: 5%; } .toolkit-standard-summary th:nth-child(2) { width: 42%; } .toolkit-standard-summary th:nth-child(3) { width: 8%; } .toolkit-standard-summary th:nth-child(4) { width: 9%; } .toolkit-standard-summary th:nth-child(5) { width: 36%; } .toolkit-calculation-guide { break-inside: avoid; } }`}</style>
  </main>;
}
