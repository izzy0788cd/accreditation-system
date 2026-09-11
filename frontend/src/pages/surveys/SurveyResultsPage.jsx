import { useEffect, useMemo, useState } from "react";
import { Link, useParams } from "react-router-dom";
import { getAll, getOne, getSurveyAssessments, getSurveyAssessmentOverview, getSurveyEvidenceChecks } from "../../api/api";
import { useAuth } from "../../context/AuthContext";

const numberSort = (first, second) => String(first ?? "").localeCompare(String(second ?? ""), undefined, { numeric: true });
const percent = (value, total) => total ? Math.round((value / total) * 100) : 0;

function Bar({ value, tone = "bg-[#087c77]" }) {
  return <div className="h-2.5 overflow-hidden rounded-full bg-[#dce9e7]"><div className={`h-full rounded-full ${tone}`} style={{ width: `${value}%` }} /></div>;
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
  const [canViewFullResults, setCanViewFullResults] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    const load = async () => {
      try {
        setError("");
        const [surveyRes, surveyorRes] = await Promise.all([getOne("surveys", surveyId), getAll("surveyors")]);
        const currentSurveyor = surveyorRes.data.find((item) => item.userId === profile?.userId);
        const isAdmin = auth?.roleName === "Admin";
        const isTeamLead = auth?.roleName === "Team Lead" && surveyRes.data.surveyorId === currentSurveyor?.surveyorId;
        const showFullResults = isAdmin || isTeamLead;
        const [assessmentRes, checkRes, criterionRes, complianceRes, standardRes, componentRes] = await Promise.all([
          showFullResults ? getSurveyAssessmentOverview(surveyId) : getSurveyAssessments(surveyId),
          getSurveyEvidenceChecks(surveyId),
          getAll("criteria"),
          getAll("compliances"),
          getAll("standards"),
          getAll("components"),
        ]);
        setSurvey(surveyRes.data);
        setAssessments(assessmentRes.data);
        setChecks(checkRes.data);
        setCriteria(criterionRes.data);
        setCompliances(complianceRes.data);
        setStandards(standardRes.data);
        setComponents(componentRes.data);
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
      const completed = rows.filter((row) => row.scoreId);
      const scored = completed.filter((row) => row.scoreValue != null);
      const score = scored.length ? percent(scored.reduce((sum, row) => sum + row.scoreValue, 0), scored.length * 2) : null;
      const evidence = visibleChecks.filter((check) => rows.some((row) => row.complianceAssessmentId === check.complianceAssessmentId));
      const status = completed.length === 0 ? "Not started" : completed.length < rows.length ? "In progress" : score == null ? "N/A" : "Completed";
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
      };
    }).sort((first, second) => numberSort(first.standardNumber, second.standardNumber));
    const componentRows = components.map((component) => {
      const componentStandards = standardRows.filter((standard) => standard.componentNumber === component.componentNumber);
      const scoreValues = componentStandards.map((standard) => standard.score).filter((score) => score != null);
      return { ...component, standards: componentStandards, score: scoreValues.length ? Math.round(scoreValues.reduce((sum, score) => sum + score, 0) / scoreValues.length) : null };
    }).filter((component) => component.standards.length).sort((first, second) => numberSort(first.componentNumber, second.componentNumber));
    return {
      standardRows,
      componentRows,
      completed: assessments.filter((assessment) => assessment.scoreId).length,
      evidenceComplete: visibleChecks.filter((check) => check.isChecked).length,
      evidenceTotal: visibleChecks.length,
    };
  }, [assessments, checks, criteria, compliances, standards, components]);

  if (error) return <main className="mx-auto max-w-6xl px-4 py-8 sm:px-6"><Link to={`/surveys/${surveyId}`} className="text-sm font-semibold text-[#087c77]">← Back to survey</Link><p className="mt-5 rounded-xl border border-red-100 bg-red-50 p-5 text-sm text-red-800">{error}</p></main>;
  if (!survey) return <main className="mx-auto max-w-6xl px-4 py-8 sm:px-6"><div className="h-56 animate-pulse rounded-2xl bg-slate-100" /></main>;

  return <><main className="print:hidden mx-auto max-w-6xl px-4 py-6 sm:px-6 lg:py-8">
    <div className="print:hidden"><Link to={`/surveys/${surveyId}`} className="text-sm font-semibold text-[#087c77] hover:underline">← Back to survey</Link></div>
    <header className="mt-5 rounded-2xl border border-[#cde5e0] bg-[linear-gradient(125deg,#e8f5f3_0%,#f8fbfa_65%,#fdf7ea_100%)] p-6 sm:p-8">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between"><div><p className="text-xs font-bold uppercase tracking-[.16em] text-teal-700">{canViewFullResults ? "Survey results summary" : "My assigned standards results"}</p><h1 className="mt-2 text-3xl font-bold text-[#143c42]">{survey.facilityName}</h1><p className="mt-2 text-sm text-[#527076]">{survey.surveyTypeName} survey · {survey.startDate} — {survey.endDate}</p></div><button onClick={() => window.print()} className="print:hidden rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#05635f]">Print / Save PDF</button></div>
    </header>
    <section className="mt-6 grid gap-4 sm:grid-cols-3"><Metric label="Requirements scored" value={`${result.completed} / ${assessments.length}`} /><Metric label="Evidence complete" value={`${result.evidenceComplete} / ${result.evidenceTotal}`} /><Metric label="Standards" value={result.standardRows.length} /></section>
    <section className="mt-6 rounded-xl border border-[#dce9e7] bg-white p-5 shadow-sm sm:p-6"><h2 className="text-lg font-bold text-[#143c42]">Component results</h2><div className="mt-5 space-y-5">{result.componentRows.map((component) => <div key={component.componentId}><div className="mb-2 flex justify-between gap-4 text-sm"><span className="font-semibold text-[#143c42]">{component.componentNumber} · {component.componentName}</span><span className="font-bold text-[#087c77]">{component.score == null ? "N/A" : `${component.score}%`}</span></div><Bar value={component.score || 0} /></div>)}</div></section>
    <section className="mt-6 space-y-6">{result.componentRows.map((component) => <div key={component.componentId} className="overflow-hidden rounded-xl border border-[#dce9e7] bg-white shadow-sm"><div className="bg-[#0b6f6b] px-5 py-4 text-white"><p className="text-xs font-bold uppercase tracking-wider">Component {component.componentNumber}</p><h2 className="mt-1 font-semibold">{component.componentName}</h2></div><div className="divide-y divide-[#e7efed]">{component.standards.map((standard) => <div key={standard.standardId} className="grid gap-4 p-5 lg:grid-cols-[minmax(0,1fr)_12rem_11rem_10rem]"><div><p className="font-bold text-[#143c42]">Standard {standard.standardNumber} · {standard.standardTitle}</p>{canViewFullResults && <p className="mt-1 text-xs text-[#668187]">Assigned: {standard.surveyors.join(", ")}</p>}{standard.comments.length > 0 && <p className="mt-2 text-sm leading-6 text-[#527076]">{standard.comments.join(" · ")}</p>}</div><div><p className="mb-1 text-xs font-bold uppercase tracking-wider text-[#668187]">Score</p><p className="font-bold text-[#087c77]">{standard.score == null ? (standard.status === "Not started" ? "—" : "N/A") : `${standard.score}%`}</p><Bar value={standard.score || 0} /><p className="mt-1 text-xs text-[#668187]">{standard.status}</p></div><div><p className="text-xs font-bold uppercase tracking-wider text-[#668187]">Evidence</p><p className="mt-1 text-sm text-[#143c42]">{standard.evidenceComplete} / {standard.evidenceTotal} complete</p></div><div><p className="text-xs font-bold uppercase tracking-wider text-[#668187]">Risk findings</p><p className="mt-1 text-sm font-semibold text-[#143c42]">{standard.risks || "None"}</p><Link to={`/surveys/${surveyId}`} className="mt-2 inline-block text-xs font-semibold text-[#087c77] print:hidden">Open scores →</Link></div></div>)}</div></div>)}</section>
  </main><PrintSurveyReport survey={survey} result={result} assessments={assessments} canViewFullResults={canViewFullResults} generatedBy={[profile?.firstName, profile?.lastName].filter(Boolean).join(" ") || auth?.username || "System user"} /></>;
}

function PrintSurveyReport({ survey, result, assessments, canViewFullResults, generatedBy }) {
  const scoreText = (score, status) => score == null ? (status === "Not started" ? "Not scored" : "N/A") : `${score}%`;
  const scope = canViewFullResults ? "Complete survey results" : "Assigned standards results";
  return <section className="survey-print-report hidden print:block">
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
      <PrintBarChart components={result.componentRows} />
    </section>
    {result.componentRows.map((component) => <section key={component.componentId} className="survey-print-section survey-print-component">
      <h2>Component {component.componentNumber}: {component.componentName}</h2>
      <table className="survey-print-table"><thead><tr><th>Standard</th>{canViewFullResults && <th>Assigned surveyor</th>}<th>Score</th><th>Requirements</th><th>Evidence</th><th>Risk findings</th><th>Status</th></tr></thead><tbody>{component.standards.map((standard) => <tr key={standard.standardId}><td><strong>{standard.standardNumber}</strong> — {standard.standardTitle}</td>{canViewFullResults && <td>{standard.surveyors.join(", ") || "—"}</td>}<td>{scoreText(standard.score, standard.status)}</td><td>{standard.completed} / {standard.rows.length}</td><td>{standard.evidenceComplete} / {standard.evidenceTotal}</td><td>{standard.risks || "None"}</td><td>{standard.status}</td></tr>)}</tbody></table>
      {component.standards.some((standard) => standard.comments.length > 0) && <div className="survey-print-findings"><h3>Recorded findings</h3>{component.standards.filter((standard) => standard.comments.length > 0).map((standard) => <p key={standard.standardId}><strong>Standard {standard.standardNumber}:</strong> {standard.comments.join("; ")}</p>)}</div>}
    </section>)}
    <footer className="survey-print-footer"><p>N/A scores are excluded from percentage calculations.</p><p>Generated {new Date().toLocaleDateString()}</p></footer>
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

const Metric = ({ label, value }) => <div className="rounded-xl border border-[#dce9e7] bg-white p-5 shadow-sm"><p className="text-xs font-bold uppercase tracking-wider text-[#668187]">{label}</p><p className="mt-2 text-2xl font-bold text-[#143c42]">{value}</p></div>;
export default SurveyResultsPage;
