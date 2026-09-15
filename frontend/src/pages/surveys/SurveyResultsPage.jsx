import { useEffect, useMemo, useState } from "react";
import { Link, useParams } from "react-router-dom";
import { getAll, getInternalAssessmentReferences, getOne, getSurveyAssessments, getSurveyAssessmentOverview, getSurveyEvidenceChecks } from "../../api/api";
import { useAuth } from "../../context/AuthContext";
import { MAX_SCORE_VALUE, isPriorityScore, scoreOutcomeLabel, scoreTone } from "../../utils/scoring";

const numberSort = (first, second) => String(first ?? "").localeCompare(String(second ?? ""), undefined, { numeric: true });
const percent = (value, total) => total ? Math.round((value / total) * 100) : 0;
const isPriorityRisk = (riskValue) => ["H", "E", "HIGH", "EXTREME", "CRITICAL", "SEVERE"].includes(String(riskValue || "").trim().toUpperCase());
function OutcomeValue({ assessment }) {
  const label = assessment.scoreValue != null ? (assessment.scoreLabel || scoreOutcomeLabel(assessment.scoreValue)) : assessment.scoreId ? "N/A" : "Not scored";
  const tone = assessment.scoreValue != null ? scoreTone(assessment.scoreValue) : "bg-slate-100 text-slate-600 ring-slate-200";
  return <span className={`inline-flex rounded-full px-2.5 py-1 text-xs font-bold ring-1 ring-inset ${tone}`}>{label}</span>;
}

function SurveyTypeBadge({ surveyTypeName }) {
  const external = surveyTypeName === "External";
  return <span className={`mt-3 inline-flex rounded-full px-3 py-1 text-xs font-bold ring-1 ring-inset ${external ? "bg-violet-50 text-violet-800 ring-violet-200" : "bg-sky-50 text-sky-800 ring-sky-200"}`}>{external ? "External survey" : "Internal survey"}</span>;
}

function Bar({ value, tone = "bg-[#16803a]" }) {
  return <div className="h-2.5 overflow-hidden rounded-full bg-[#dbe5ef]"><div className={`h-full rounded-full ${tone}`} style={{ width: `${value}%` }} /></div>;
}

function riskColour(riskValue) {
  const value = String(riskValue || "").trim().toUpperCase();
  if (["E", "EXTREME", "CRITICAL", "SEVERE"].includes(value)) return "#991b1b";
  if (["H", "HIGH"].includes(value)) return "#dc2626";
  if (["M", "MEDIUM", "MODERATE"].includes(value)) return "#d97706";
  if (["L", "LOW"].includes(value)) return "#16803a";
  return "#64748b";
}

function RiskPieChart({ breakdown, compact = false }) {
  const total = breakdown.reduce((sum, item) => sum + item.count, 0);
  if (!total) return <p className="text-sm text-[#68778c]">No risk ratings recorded.</p>;
  const slices = breakdown.reduce(({ position, values }, item) => {
    const nextPosition = position + (item.count / total) * 100;
    return { position: nextPosition, values: [...values, `${riskColour(item.label)} ${position}% ${nextPosition}%`] };
  }, { position: 0, values: [] }).values.join(", ");
  return <div className={`flex items-center ${compact ? "gap-3" : "gap-4"}`}>
    <div role="img" aria-label={`Risk rating breakdown: ${breakdown.map((item) => `${item.label} ${item.count}`).join(", ")}`} className={`relative ${compact ? "h-16 w-16" : "h-24 w-24"} shrink-0 rounded-full`} style={{ background: `conic-gradient(${slices})` }}><div className={`absolute inset-0 m-auto flex ${compact ? "h-10 w-10 text-xs" : "h-16 w-16 text-sm"} items-center justify-center rounded-full bg-white font-bold text-[#092a5a]`}>{total}</div></div>
    <ul className="min-w-0 space-y-1 text-xs text-[#4b5f7a]">{breakdown.map((item) => <li key={item.label} className="flex items-center gap-2"><span className="h-2.5 w-2.5 shrink-0 rounded-full" style={{ backgroundColor: riskColour(item.label) }} /><span className="truncate">{item.label}</span><strong className="ml-auto text-[#092a5a]">{item.count}</strong></li>)}</ul>
  </div>;
}

function FindingsQueue({ findings, onSelect }) {
  const visible = findings.slice(0, 6);
  return <section className="mt-6 overflow-hidden rounded-xl border border-[#f1d7b6] bg-white shadow-sm"><div className="flex flex-col gap-3 border-b border-[#f5e4cf] bg-[#fffbf4] px-5 py-4 sm:flex-row sm:items-center sm:justify-between"><div><p className="text-xs font-bold uppercase tracking-[.16em] text-[#9a5b13]">Priority review</p><h2 className="mt-1 text-lg font-bold text-[#092a5a]">Findings queue</h2><p className="mt-1 text-sm text-[#68778c]">Poor or fair achievement ratings with High or Extreme risk.</p></div><span className="w-fit rounded-full bg-amber-100 px-3 py-1 text-xs font-bold text-amber-800">{findings.length} priority finding{findings.length === 1 ? "" : "s"}</span></div>{visible.length === 0 ? <p className="px-5 py-8 text-sm text-[#68778c]">No high- or extreme-risk compliance gaps have been recorded.</p> : <div className="divide-y divide-[#f5e4cf]">{visible.map((detail) => <button key={detail.complianceAssessmentId} onClick={() => onSelect(detail.standard)} className="flex w-full items-start gap-4 px-5 py-4 text-left transition hover:bg-[#fffaf2]"><span className="min-w-0 flex-1"><span className="text-xs font-bold uppercase tracking-wider text-[#9a5b13]">Standard {detail.standard.standardNumber} · {detail.compliance?.complianceNumber}</span><span className="mt-1 block text-justify text-sm font-semibold leading-6 text-[#092a5a]">{detail.compliance?.complianceSummary}</span><span className="mt-1 block text-sm text-[#4b5f7a]">Risk: {detail.riskValue}</span></span><span className="w-36 shrink-0 pt-1 text-right"><OutcomeValue assessment={detail} /></span></button>)}</div>}{findings.length > visible.length && <p className="border-t border-[#f5e4cf] px-5 py-3 text-sm text-[#68778c]">Showing the first {visible.length} priority findings. Use the Results Workspace filters to review the rest.</p>}</section>;
}

function SurveyResultsPage() {
  const { surveyId } = useParams();
  const { auth, profile } = useAuth();
  const [survey, setSurvey] = useState(null);
  const [assessments, setAssessments] = useState([]);
  const [checks, setChecks] = useState([]);
  const [criteria, setCriteria] = useState([]);
  const [compliances, setCompliances] = useState([]);
  const [standards, setStandards] = useState([]);
  const [components, setComponents] = useState([]);
  const [internalReferences, setInternalReferences] = useState({});
  const [canViewFullResults, setCanViewFullResults] = useState(false);
  const [error, setError] = useState("");
  const [viewMode, setViewMode] = useState("overview");
  const [componentFilter, setComponentFilter] = useState("");
  const [standardFilter, setStandardFilter] = useState("");
  const [surveyorFilter, setSurveyorFilter] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");
  const [expandedStandards, setExpandedStandards] = useState([]);

  useEffect(() => {
    const load = async () => {
      try {
        setError("");
        const [surveyRes, surveyorRes] = await Promise.all([getOne("surveys", surveyId), getAll("surveyors")]);
        const currentSurveyor = surveyorRes.data.find((item) => item.userId === profile?.userId);
        const isAdmin = auth?.roleName === "Admin";
        const isTeamLead = auth?.roleName === "Team Lead" && surveyRes.data.surveyorId === currentSurveyor?.surveyorId;
        const showFullResults = isAdmin || isTeamLead;
        const [assessmentRes, checkRes, criterionRes, complianceRes, standardRes, componentRes, internalReferenceRes] = await Promise.all([
          showFullResults ? getSurveyAssessmentOverview(surveyId) : getSurveyAssessments(surveyId),
          getSurveyEvidenceChecks(surveyId),
          getAll("criteria"),
          getAll("compliances"),
          getAll("standards"),
          getAll("components"),
          surveyRes.data.surveyTypeName === "External" ? getInternalAssessmentReferences(surveyId) : Promise.resolve({ data: [] }),
        ]);
        setSurvey(surveyRes.data);
        setAssessments(assessmentRes.data);
        setChecks(checkRes.data);
        setCriteria(criterionRes.data);
        setCompliances(complianceRes.data);
        setStandards(standardRes.data);
        setComponents(componentRes.data);
        setInternalReferences(Object.fromEntries(internalReferenceRes.data.map((reference) => [reference.complianceId, reference])));
        setCanViewFullResults(showFullResults);
      } catch (loadError) {
        console.error(loadError);
        setError("Your results could not be loaded. Please make sure you are assigned to this survey.");
      }
    };
    if (auth && profile) load();
  }, [surveyId, auth?.roleName, profile?.userId]);

  const result = useMemo(() => {
    const complianceById = new Map(compliances.map((item) => [item.complianceId, item]));
    const criterionById = new Map(criteria.map((item) => [item.criterionId, item]));
    const standardById = new Map(standards.map((item) => [item.standardId, item]));
    const visibleAssessmentIds = new Set(assessments.map((item) => item.complianceAssessmentId));
    const visibleChecks = checks.filter((check) => visibleAssessmentIds.has(check.complianceAssessmentId));
    const standardRows = [...new Map(assessments.map((assessment) => {
      const compliance = complianceById.get(assessment.complianceId);
      const criterion = criterionById.get(compliance?.criterionId);
      const standard = standardById.get(criterion?.standardId);
      return [standard?.standardId, standard];
    })).values()].filter(Boolean).map((standard) => {
      const rows = assessments.filter((assessment) => {
        const compliance = complianceById.get(assessment.complianceId);
        return criterionById.get(compliance?.criterionId)?.standardId === standard.standardId;
      });
      const details = rows.map((row) => {
        const compliance = complianceById.get(row.complianceId);
        const criterion = criterionById.get(compliance?.criterionId);
        const evidence = visibleChecks.filter((check) => check.complianceAssessmentId === row.complianceAssessmentId);
        const statusKey = row.scoreId == null ? "unscored" : row.scoreValue == null ? "na" : String(row.scoreValue);
        return { ...row, compliance, criterion, evidence, statusKey, internalReference: internalReferences[row.complianceId] };
      }).sort((first, second) => numberSort(first.criterion?.criterionNumber, second.criterion?.criterionNumber)
        || numberSort(first.compliance?.complianceNumber, second.compliance?.complianceNumber));
      const completed = rows.filter((row) => row.scoreId);
      const scored = completed.filter((row) => row.scoreValue != null);
      const score = scored.length ? percent(scored.reduce((sum, row) => sum + row.scoreValue, 0), scored.length * MAX_SCORE_VALUE) : null;
      const evidence = visibleChecks.filter((check) => rows.some((row) => row.complianceAssessmentId === check.complianceAssessmentId));
      const status = completed.length === 0 ? "Not started" : completed.length < rows.length ? "In progress" : score == null ? "N/A" : "Completed";
      const criteriaSummary = [...new Map(details.map((detail) => [detail.criterion?.criterionId, detail.criterion])).entries()]
        .filter(([, criterion]) => criterion)
        .map(([criterionId, criterion]) => {
          const criterionDetails = details.filter((detail) => detail.criterion?.criterionId === criterionId);
          const internalDetails = criterionDetails.map((detail) => detail.internalReference).filter(Boolean);
          const summarise = (items) => {
            const completedItems = items.filter((item) => item.scoreId);
            const numeric = completedItems.filter((item) => item.scoreValue != null);
            const score = numeric.length ? percent(numeric.reduce((sum, item) => sum + item.scoreValue, 0), numeric.length * MAX_SCORE_VALUE) : null;
            return {
              score: numeric.length ? `${score}%` : completedItems.length ? "N/A" : "Not scored",
              risk: [...new Set(items.map((item) => item.riskValue).filter(Boolean))].join(", ") || "Not rated",
              comments: [...new Set(items.map((item) => item.complianceComments?.trim()).filter(Boolean))].join(" · ") || "No comments recorded.",
            };
          };
          return { criterion, current: summarise(criterionDetails), internal: internalDetails.length ? summarise(internalDetails) : null };
        }).sort((first, second) => numberSort(first.criterion.criterionNumber, second.criterion.criterionNumber));
      return {
        ...standard,
        rows,
        completed: completed.length,
        score,
        status,
        evidenceComplete: evidence.filter((check) => check.isChecked).length,
        evidenceTotal: evidence.length,
        risks: rows.filter((row) => row.riskRatingId).length,
        surveyors: [...new Set(rows.map((row) => row.surveyorName).filter(Boolean))],
        comments: [...new Set(rows.map((row) => row.complianceComments?.trim()).filter(Boolean))],
        details,
        criteriaSummary,
      };
    }).sort((first, second) => numberSort(first.standardNumber, second.standardNumber));
    const componentRows = components.map((component) => {
      const componentStandards = standardRows.filter((standard) => standard.componentNumber === component.componentNumber);
      const scoreValues = componentStandards.map((standard) => standard.score).filter((score) => score != null);
      const riskBreakdown = Object.entries(componentStandards.flatMap((standard) => standard.rows).reduce((counts, row) => {
        if (row.riskValue) counts[row.riskValue] = (counts[row.riskValue] || 0) + 1;
        return counts;
      }, {})).map(([label, count]) => ({ label, count })).sort((first, second) => second.count - first.count || first.label.localeCompare(second.label));
      return { ...component, standards: componentStandards, score: scoreValues.length ? Math.round(scoreValues.reduce((sum, score) => sum + score, 0) / scoreValues.length) : null, riskBreakdown };
    }).filter((component) => component.standards.length).sort((first, second) => numberSort(first.componentNumber, second.componentNumber));
    return {
      standardRows,
      componentRows,
      completed: assessments.filter((assessment) => assessment.scoreId).length,
      evidenceComplete: visibleChecks.filter((check) => check.isChecked).length,
      evidenceTotal: visibleChecks.length,
      overallScore: (() => { const scored = assessments.filter((assessment) => assessment.scoreValue != null); return scored.length ? percent(scored.reduce((sum, assessment) => sum + assessment.scoreValue, 0), scored.length * MAX_SCORE_VALUE) : null; })(),
      findings: standardRows.flatMap((standard) => standard.details.filter((detail) => isPriorityScore(detail.scoreValue) && isPriorityRisk(detail.riskValue)).map((detail) => ({ ...detail, standard }))),
    };
  }, [assessments, checks, criteria, compliances, standards, components, internalReferences]);

  const explorerComponents = useMemo(() => result.componentRows
    .filter((component) => !componentFilter || String(component.componentId) === componentFilter)
    .map((component) => ({
      ...component,
      standards: component.standards.map((standard) => {
        if (standardFilter && String(standard.standardId) !== standardFilter) return false;
        if (surveyorFilter && !standard.surveyors.includes(surveyorFilter)) return false;
        const matchingDetails = standard.details.filter((detail) => {
          const isFinding = isPriorityScore(detail.scoreValue) || Boolean(detail.riskRatingId);
          return (viewMode !== "findings" || isFinding)
            && (statusFilter === "all" || detail.statusKey === statusFilter);
        });
        const visibleDetails = viewMode === "overview" && statusFilter === "all" ? standard.details : matchingDetails;
        return visibleDetails.length ? { ...standard, visibleDetails } : false;
      }).filter(Boolean),
    }))
    .filter((component) => component.standards.length), [result.componentRows, componentFilter, standardFilter, surveyorFilter, statusFilter, viewMode]);

  const allSurveyors = useMemo(() => [...new Set(result.standardRows.flatMap((standard) => standard.surveyors))].sort(), [result.standardRows]);
  const toggleStandard = (standardId) => setExpandedStandards((current) => current.includes(standardId) ? current.filter((id) => id !== standardId) : [...current, standardId]);

  if (error) return <main className="mx-auto max-w-6xl px-4 py-8 sm:px-6"><Link to={`/surveys/${surveyId}`} className="text-sm font-semibold text-[#16803a]">← Back to survey</Link><p className="mt-5 rounded-xl border border-red-100 bg-red-50 p-5 text-sm text-red-800">{error}</p></main>;
  if (!survey) return <main className="mx-auto max-w-6xl px-4 py-8 sm:px-6"><div className="h-56 animate-pulse rounded-2xl bg-slate-100" /></main>;

  return <><main className="print:hidden mx-auto max-w-6xl px-4 py-6 sm:px-6 lg:py-8">
    <div className="print:hidden"><Link to={`/surveys/${surveyId}`} className="text-sm font-semibold text-[#16803a] hover:underline">← Back to survey</Link></div>
    <header className="mt-5 rounded-2xl border border-[#c9dded] bg-[linear-gradient(125deg,#eaf3fb_0%,#f8fafc_65%,#fdf7ea_100%)] p-6 sm:p-8">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between"><div><p className={`text-xs font-bold uppercase tracking-[.16em] ${survey.surveyTypeName === "External" ? "text-violet-700" : "text-sky-800"}`}>{canViewFullResults ? "Survey results summary" : "My assigned standards results"}</p><h1 className="mt-2 text-3xl font-bold text-[#092a5a]">{survey.facilityName}</h1><p className="mt-2 text-sm text-[#4b5f7a]">{survey.startDate} — {survey.endDate}</p><SurveyTypeBadge surveyTypeName={survey.surveyTypeName} /></div><button onClick={() => window.print()} className="print:hidden rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#0d6531]">{viewMode !== "overview" || componentFilter || standardFilter || surveyorFilter || statusFilter !== "all" ? "Print / Save filtered PDF" : "Print / Save PDF"}</button></div>
    </header>
    <section className="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-4"><Metric label="Requirements scored" value={`${result.completed} / ${assessments.length}`} /><Metric label="Overall score" value={result.overallScore == null ? "N/A" : `${result.overallScore}%`} /><Metric label="Evidence complete" value={`${result.evidenceComplete} / ${result.evidenceTotal}`} /><Metric label="Priority findings" value={result.findings.length} /></section>
    <section className="mt-6 rounded-xl border border-[#dbe5ef] bg-white p-5 shadow-sm sm:p-6"><div className="flex flex-col gap-1 sm:flex-row sm:items-end sm:justify-between"><div><h2 className="text-lg font-bold text-[#092a5a]">Component results</h2><p className="mt-1 text-sm text-[#68778c]">Performance and risk-rating distribution across each component.</p></div></div><div className="mt-5 grid gap-5 lg:grid-cols-2">{result.componentRows.map((component) => <article key={component.componentId} className="rounded-xl border border-[#e1ebf4] bg-[#f8fafc] p-4"><p className="font-semibold text-[#092a5a]">{component.componentNumber} · {component.componentName}</p><div className="mt-4 grid gap-5 sm:grid-cols-[minmax(0,1fr)_12rem]"><div><div className="mb-2 flex justify-between gap-4 text-sm"><span className="font-semibold text-[#4b5f7a]">Average score</span><span className="font-bold text-[#16803a]">{component.score == null ? "N/A" : `${component.score}%`}</span></div><Bar value={component.score || 0} /></div><div><p className="mb-2 text-xs font-bold uppercase tracking-wider text-[#68778c]">Risk findings</p><RiskPieChart breakdown={component.riskBreakdown} compact /></div></div></article>)}</div></section>
    <FindingsQueue findings={result.findings} onSelect={(standard) => { const component = result.componentRows.find((item) => item.componentNumber === standard.componentNumber); setComponentFilter(component ? String(component.componentId) : ""); setStandardFilter(String(standard.standardId)); setViewMode("findings"); setExpandedStandards((current) => current.includes(standard.standardId) ? current : [...current, standard.standardId]); document.getElementById("results-workspace")?.scrollIntoView({ behavior: "smooth", block: "start" }); }} />
    <div id="results-workspace"><ResultExplorer controls={{ viewMode, setViewMode, componentFilter, setComponentFilter, standardFilter, setStandardFilter, surveyorFilter, setSurveyorFilter, statusFilter, setStatusFilter }} components={explorerComponents} allComponents={result.componentRows} allStandards={result.standardRows} allSurveyors={allSurveyors} canViewFullResults={canViewFullResults} isExternal={survey.surveyTypeName === "External"} expandedStandards={expandedStandards} onToggleStandard={toggleStandard} /></div>
  </main><PrintSurveyReport survey={survey} result={result} assessments={assessments} filteredComponents={explorerComponents} isFiltered={viewMode !== "overview" || Boolean(componentFilter || standardFilter || surveyorFilter || statusFilter !== "all")} canViewFullResults={canViewFullResults} generatedBy={[profile?.firstName, profile?.lastName].filter(Boolean).join(" ") || auth?.username || "System user"} /></>;
}

function CriterionSummarySheet({ standard, isExternal }) {
  const columns = isExternal
    ? ["Criterion", "Internal score", "Internal risk", "Internal comments", "External score", "External risk", "External comments"]
    : ["No.", "Criteria for compliance & annotation", "Score", "Risk rating", "Summary of recommendations / comments"];
  return <section className={`survey-summary-sheet survey-summary-sheet--${isExternal ? "external" : "internal"} mb-5 overflow-hidden rounded-md border border-[#8fa9c4] bg-white shadow-sm`}>
    <div className="grid border-b border-[#8fa9c4] sm:grid-cols-[10rem_minmax(0,1fr)]"><div className="bg-[#092a5a] px-4 py-4 text-white"><p className="text-xs font-bold uppercase tracking-[0.16em]">Summary sheet</p><p className="mt-2 text-xs leading-5 text-[#dbeafe]">Standard results and surveyor findings</p></div><div className="bg-[#edf5fc] px-4 py-4"><p className="text-xs font-bold uppercase tracking-[0.12em] text-[#16803a]">National Health Service Standards</p><h4 className="mt-1 font-bold leading-6 text-[#092a5a]">Standard {standard.standardNumber}: {standard.standardTitle}</h4><p className="mt-1 text-xs leading-5 text-[#4b5f7a]">Criterion score, risk rating, and summary recommendations/comments.</p></div></div>
    <div className="hidden overflow-x-auto md:block"><table className="w-full min-w-[760px] border-collapse text-left text-sm"><thead className="bg-[#315c88] text-xs uppercase tracking-wider text-white"><tr>{columns.map((column) => <th key={column} className="border border-[#8fa9c4] px-3 py-3 align-bottom">{column}</th>)}</tr></thead><tbody>{standard.criteriaSummary.map(({ criterion, current, internal }) => <tr key={criterion.criterionId} className="align-top even:bg-[#f8fafc]"><td className="border border-[#c9d8e6] px-3 py-3 font-bold text-[#092a5a]">{criterion.criterionNumber}</td>{isExternal ? <><td className="border border-[#c9d8e6] px-3 py-3 font-semibold text-sky-800">{internal?.score || "Not recorded"}</td><td className="border border-[#c9d8e6] px-3 py-3 text-[#4b5f7a]">{internal?.risk || "Not recorded"}</td><td className="max-w-56 border border-[#c9d8e6] px-3 py-3 text-justify leading-5 text-[#4b5f7a]">{internal?.comments || "No internal assessment recorded."}</td><td className="border border-[#c9d8e6] px-3 py-3 font-semibold text-[#16803a]">{current.score}</td><td className="border border-[#c9d8e6] px-3 py-3 text-[#4b5f7a]">{current.risk}</td><td className="max-w-56 border border-[#c9d8e6] px-3 py-3 text-justify leading-5 text-[#4b5f7a]">{current.comments}</td></> : <><td className="min-w-72 border border-[#c9d8e6] px-3 py-3"><p className="text-justify font-semibold leading-5 text-[#092a5a]">{criterion.criterionTitle}</p></td><td className="border border-[#c9d8e6] px-3 py-3 font-semibold text-[#16803a]">{current.score}</td><td className="border border-[#c9d8e6] px-3 py-3 text-[#4b5f7a]">{current.risk}</td><td className="max-w-72 border border-[#c9d8e6] px-3 py-3 text-justify leading-5 text-[#4b5f7a]">{current.comments}</td></>}</tr>)}<tr className="bg-[#eaf3fb]"><td colSpan={isExternal ? 4 : 2} className="border border-[#8fa9c4] px-3 py-3 text-xs font-bold uppercase tracking-wider text-[#092a5a]">Totals</td><td colSpan={isExternal ? 3 : 3} className="border border-[#8fa9c4] px-3 py-3 font-bold text-[#16803a]">{standard.score == null ? (standard.status === "Not started" ? "Not scored" : "N/A") : `${standard.score}%`}</td></tr></tbody></table></div>
    <div className="divide-y divide-[#e7edf4] md:hidden">{standard.criteriaSummary.map(({ criterion, current, internal }) => <article key={criterion.criterionId} className="p-4"><p className="text-xs font-bold uppercase tracking-wider text-[#16803a]">Criterion {criterion.criterionNumber}</p><h5 className="mt-1 font-semibold leading-6 text-[#092a5a]">{criterion.criterionTitle}</h5>{isExternal && <div className="mt-3 rounded-md bg-sky-50 p-3 text-sm"><p className="font-bold text-sky-800">Internal self-assessment</p><p className="mt-1 text-[#385273]">Score: {internal?.score || "Not recorded"} · Risk: {internal?.risk || "Not recorded"}</p><p className="mt-1 leading-5 text-[#385273]">{internal?.comments || "No internal assessment recorded."}</p></div>}<div className="mt-3 text-sm"><p className="font-semibold text-[#16803a]">{isExternal ? "External survey" : "Score"}: {current.score}</p><p className="mt-1 text-[#4b5f7a]">Risk: {current.risk}</p><p className="mt-1 leading-5 text-[#4b5f7a]">{current.comments}</p></div></article>)}<p className="bg-[#f6f9fc] px-4 py-3 text-sm font-bold text-[#092a5a]">Standard total: <span className="text-[#16803a]">{standard.score == null ? (standard.status === "Not started" ? "Not scored" : "N/A") : `${standard.score}%`}</span></p></div>
  </section>;
}

function ResultExplorer({ controls, components, allComponents, allStandards, allSurveyors, canViewFullResults, isExternal, expandedStandards, onToggleStandard }) {
  const { viewMode, setViewMode, componentFilter, setComponentFilter, standardFilter, setStandardFilter, surveyorFilter, setSurveyorFilter, statusFilter, setStatusFilter } = controls;
  const modeLabel = { overview: "Overview", findings: "Findings", full: "Full detail" };
  const statusLabel = { unscored: "Not scored", na: "N/A", 1: "Poor achievement", 2: "Fair achievement", 3: "Good achievement", 4: "Full achievement" };
  const availableStandards = componentFilter
    ? allComponents.find((component) => String(component.componentId) === componentFilter)?.standards || []
    : allStandards;
  return <section className="mt-6 overflow-hidden rounded-xl border border-[#dbe5ef] bg-white shadow-sm">
    <div className="border-b border-[#dbe5ef] bg-[#f6f9fc] px-5 py-5 sm:px-6"><p className="text-xs font-bold uppercase tracking-[.16em] text-[#16803a]">Explore results</p><h2 className="mt-1 text-xl font-bold text-[#092a5a]">Break down the survey findings</h2><p className="mt-1 text-sm text-[#68778c]">Filter the results, then expand a standard to review its criteria, compliance findings, evidence, and comments.</p><div className="mt-4 flex flex-wrap gap-2">{Object.keys(modeLabel).map((mode) => <button key={mode} onClick={() => setViewMode(mode)} className={`rounded-lg px-3.5 py-2 text-sm font-semibold transition ${viewMode === mode ? "bg-[#092a5a] text-white" : "border border-[#c5d5e8] bg-white text-[#4b5f7a] hover:bg-[#edf8f0]"}`}>{modeLabel[mode]}</button>)}</div></div>
    <div className="grid gap-3 border-b border-[#e7edf4] p-5 sm:grid-cols-2 lg:grid-cols-4 sm:p-6"><label className="text-sm font-semibold text-[#4b5f7a]">Component<select value={componentFilter} onChange={(event) => { setComponentFilter(event.target.value); setStandardFilter(""); }} className="mt-1.5 w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm text-[#092a5a]"><option value="">All components</option>{allComponents.map((component) => <option key={component.componentId} value={component.componentId}>{component.componentNumber} · {component.componentName}</option>)}</select></label><label className="text-sm font-semibold text-[#4b5f7a]">Standard<select value={standardFilter} onChange={(event) => setStandardFilter(event.target.value)} className="mt-1.5 w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm text-[#092a5a]"><option value="">All standards</option>{availableStandards.map((standard) => <option key={standard.standardId} value={standard.standardId}>{standard.standardNumber} · {standard.standardTitle}</option>)}</select></label>{canViewFullResults && <label className="text-sm font-semibold text-[#4b5f7a]">Surveyor<select value={surveyorFilter} onChange={(event) => setSurveyorFilter(event.target.value)} className="mt-1.5 w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm text-[#092a5a]"><option value="">All surveyors</option>{allSurveyors.map((name) => <option key={name} value={name}>{name}</option>)}</select></label>}<label className="text-sm font-semibold text-[#4b5f7a]">Score status<select value={statusFilter} onChange={(event) => setStatusFilter(event.target.value)} className="mt-1.5 w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm text-[#092a5a]"><option value="all">All statuses</option>{Object.entries(statusLabel).map(([value, label]) => <option key={value} value={value}>{label}</option>)}</select></label></div>
    <div className="divide-y divide-[#e7edf4]">{components.length === 0 ? <p className="px-6 py-12 text-center text-sm text-[#68778c]">No results match these filters.</p> : components.map((component) => <section key={component.componentId}><header className="bg-[#0f6b3c] px-5 py-4 text-white"><p className="text-xs font-bold uppercase tracking-wider">Component {component.componentNumber}</p><h3 className="mt-1 font-semibold">{component.componentName}</h3></header><div className="divide-y divide-[#e7edf4]">{component.standards.map((standard) => { const expanded = expandedStandards.includes(standard.standardId); const showSurveyor = standard.surveyors.length > 1; return <article key={standard.standardId}><button onClick={() => onToggleStandard(standard.standardId)} aria-expanded={expanded} className="flex w-full items-start justify-between gap-4 p-5 text-left transition hover:bg-[#f8fafc]"><span><span className="block font-bold text-[#092a5a]">Standard {standard.standardNumber} · {standard.standardTitle}</span><span className="mt-1 block text-sm text-[#68778c]">{standard.visibleDetails.length} matching requirement{standard.visibleDetails.length === 1 ? "" : "s"} · {standard.score == null ? "No numeric score" : `${standard.score}%`}</span></span><span className="shrink-0 rounded-full bg-[#edf8f0] px-2.5 py-1 text-xs font-bold text-[#16803a]">{expanded ? "Hide" : "Review"}</span></button>{expanded && <div className="border-t border-[#e7edf4] bg-[#f8fafc] p-4 sm:p-5"><CriterionSummarySheet standard={standard} isExternal={isExternal} /><div className="space-y-3">{standard.visibleDetails.map((detail) => <div key={detail.complianceAssessmentId} className="rounded-lg border border-[#dbe5ef] bg-white p-4"><div><p className="text-xs font-bold uppercase tracking-wider text-[#16803a]">{detail.criterion?.criterionNumber || "Criterion"} · {detail.compliance?.complianceNumber}</p><p className="mt-1 text-justify text-sm font-semibold leading-6 text-[#092a5a]">{detail.compliance?.complianceSummary}</p><p className="mt-1 text-justify text-sm leading-6 text-[#4b5f7a]">{detail.criterion?.criterionTitle}</p></div><dl className={`mt-4 grid gap-3 text-sm ${showSurveyor ? "sm:grid-cols-5" : "sm:grid-cols-4"}`}><div><dt className="text-xs font-bold uppercase tracking-wider text-[#68778c]">Score</dt><dd className="mt-1 font-medium text-[#092a5a]">{detail.scoreValue == null ? (detail.scoreId ? "N/A" : "Not scored") : detail.scoreValue}</dd></div><div><dt className="text-xs font-bold uppercase tracking-wider text-[#68778c]">Outcome</dt><dd className="mt-1"><OutcomeValue assessment={detail} /></dd></div><div><dt className="text-xs font-bold uppercase tracking-wider text-[#68778c]">Risk</dt><dd className="mt-1 font-medium text-[#092a5a]">{detail.riskValue || "Not rated"}</dd></div><div><dt className="text-xs font-bold uppercase tracking-wider text-[#68778c]">Evidence</dt><dd className="mt-1 font-medium text-[#092a5a]">{detail.evidence.filter((item) => item.isChecked).length} / {detail.evidence.length} checked</dd></div>{showSurveyor && <div><dt className="text-xs font-bold uppercase tracking-wider text-[#68778c]">Surveyor</dt><dd className="mt-1 font-medium text-[#092a5a]">{detail.surveyorName || "—"}</dd></div>}</dl>{detail.complianceComments && <p className="mt-4 border-l-2 border-[#16803a] pl-3 text-justify text-sm leading-6 text-[#4b5f7a]">{detail.complianceComments}</p>}</div>)}</div></div>}</article>; })}</div></section>)}</div>
  </section>;
}

function PrintSurveyReport({ survey, result, assessments, filteredComponents, isFiltered, canViewFullResults, generatedBy }) {
  const scoreText = (score, status) => score == null ? (status === "Not started" ? "Not scored" : "N/A") : `${score}%`;
  const scope = isFiltered ? "Filtered survey results" : canViewFullResults ? "Complete survey results" : "Assigned standards results";
  return <section className={`survey-print-report survey-print-${survey.surveyTypeName?.toLowerCase() || "internal"} hidden print:block`}>
    <header className="survey-print-heading">
      <p>National Health Service Standards</p>
      <h1>Survey Results Summary</h1>
      <p className="survey-print-scope">{scope}</p>
    </header>
    <table className="survey-print-metadata"><tbody>
      <tr><th>Health facility</th><td>{survey.facilityName}</td><th>Survey type</th><td>{survey.surveyTypeName}</td></tr>
      <tr><th>Assessment period</th><td>{survey.startDate} — {survey.endDate}</td><th>Team lead</th><td>{survey.surveyorName}</td></tr>
      <tr><th>Generated by</th><td>{generatedBy}</td><th>Report date</th><td>{new Date().toLocaleDateString()}</td></tr>
    </tbody></table>
    <section className="survey-print-section">
      <h2>Completion summary</h2>
      <table className="survey-print-table survey-print-metrics"><thead><tr><th>Requirements scored</th><th>Evidence checks completed</th><th>Standards covered</th></tr></thead><tbody><tr><td>{result.completed} / {assessments.length}</td><td>{result.evidenceComplete} / {result.evidenceTotal}</td><td>{result.standardRows.length}</td></tr></tbody></table>
    </section>
    <section className="survey-print-section">
      <h2>Component summary</h2>
      <table className="survey-print-table"><thead><tr><th>Component</th><th>Standards assessed</th><th>Average score</th></tr></thead><tbody>{result.componentRows.map((component) => <tr key={component.componentId}><td>{component.componentNumber}. {component.componentName}</td><td>{component.standards.length}</td><td>{component.score == null ? "N/A" : `${component.score}%`}</td></tr>)}</tbody></table>
    </section>
    <section className="survey-print-section">
      <h2>Component performance graph</h2>
      <PrintBarChart components={filteredComponents} />
    </section>
    {filteredComponents.map((component) => <section key={component.componentId} className="survey-print-section survey-print-component">
      <h2>Component {component.componentNumber}: {component.componentName}</h2>
      <table className="survey-print-table"><thead><tr><th>Standard</th>{canViewFullResults && <th>Assigned surveyor</th>}<th>Score</th><th>Requirements</th><th>Evidence</th><th>Risk findings</th><th>Status</th></tr></thead><tbody>{component.standards.map((standard) => <tr key={standard.standardId}><td><strong>{standard.standardNumber}</strong> — {standard.standardTitle}</td>{canViewFullResults && <td>{standard.surveyors.join(", ") || "—"}</td>}<td>{scoreText(standard.score, standard.status)}</td><td>{standard.completed} / {standard.rows.length}</td><td>{standard.evidenceComplete} / {standard.evidenceTotal}</td><td>{standard.risks || "None"}</td><td>{standard.status}</td></tr>)}</tbody></table>
      {component.standards.map((standard) => <PrintStandardSummary key={standard.standardId} standard={standard} isExternal={survey.surveyTypeName === "External"} />)}
    </section>)}
    <footer className="survey-print-footer"><p>N/A scores are excluded from percentage calculations.</p><p>Generated {new Date().toLocaleDateString()}</p></footer>
  </section>;
}

function PrintStandardSummary({ standard, isExternal }) {
  const total = standard.score == null ? (standard.status === "Not started" ? "Not scored" : "N/A") : `${standard.score}%`;
  return <section className="survey-print-standard-summary">
    <h3>Summary sheet — Standard {standard.standardNumber}: {standard.standardTitle}</h3>
    <table className="survey-print-table"><thead><tr>{isExternal ? <><th>Criterion</th><th>Internal score</th><th>Internal risk</th><th>Internal comments</th><th>External score</th><th>External risk</th><th>External comments</th></> : <><th>No.</th><th>Criteria for compliance & annotation</th><th>Score</th><th>Risk rating</th><th>Summary of recommendations / comments</th></>}</tr></thead><tbody>{standard.criteriaSummary.map(({ criterion, current, internal }) => <tr key={criterion.criterionId}><td><strong>{criterion.criterionNumber}</strong></td>{isExternal ? <><td>{internal?.score || "Not recorded"}</td><td>{internal?.risk || "Not recorded"}</td><td>{internal?.comments || "No internal assessment recorded."}</td><td>{current.score}</td><td>{current.risk}</td><td>{current.comments}</td></> : <><td>{criterion.criterionTitle}</td><td>{current.score}</td><td>{current.risk}</td><td>{current.comments}</td></>}</tr>)}<tr><td colSpan={isExternal ? 4 : 2}><strong>Totals</strong></td><td colSpan={isExternal ? 3 : 3}><strong>{total}</strong></td></tr></tbody></table>
  </section>;
}

function PrintBarChart({ components }) {
  const chartWidth = 720;
  const labelWidth = 310;
  const chartHeight = Math.max(90, components.length * 38 + 36);
  return <svg className="survey-print-chart" viewBox={`0 0 ${chartWidth} ${chartHeight}`} role="img" aria-label="Component performance graph">
    <title>Component performance graph</title><desc>Average percentage score for each component.</desc>
    <text x={labelWidth} y="14" className="survey-print-chart-axis">0%</text><text x={chartWidth - 6} y="14" textAnchor="end" className="survey-print-chart-axis">100%</text>
    {components.map((component, index) => {
      const y = 26 + index * 38;
      const value = component.score || 0;
      return <g key={component.componentId}><text x="0" y={y + 13} className="survey-print-chart-label">{component.componentNumber}. {component.componentName}</text><rect x={labelWidth} y={y} width={chartWidth - labelWidth - 42} height="18" className="survey-print-chart-track" /><rect x={labelWidth} y={y} width={(chartWidth - labelWidth - 42) * value / 100} height="18" className="survey-print-chart-bar" /><text x={chartWidth - 4} y={y + 13} textAnchor="end" className="survey-print-chart-value">{component.score == null ? "N/A" : `${component.score}%`}</text></g>;
    })}
  </svg>;
}

const Metric = ({ label, value }) => <div className="rounded-xl border border-[#dbe5ef] bg-white p-5 shadow-sm"><p className="text-xs font-bold uppercase tracking-wider text-[#68778c]">{label}</p><p className="mt-2 text-2xl font-bold text-[#092a5a]">{value}</p></div>;
export default SurveyResultsPage;
