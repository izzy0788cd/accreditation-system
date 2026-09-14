import { useEffect, useMemo, useState } from "react";
import { Link, useParams } from "react-router-dom";
import { getAll, getOne, getSurveyAssessmentOverview, getSurveyEvidenceChecks, getSurveyProgress } from "../../api/api";
import { useAuth } from "../../context/AuthContext";

const numberSort = (first, second) => String(first ?? "").localeCompare(String(second ?? ""), undefined, { numeric: true });
const percentage = (complete, total) => total ? Math.round((complete / total) * 100) : 0;

function ProgressRow({ label, value, detail, tone = "bg-[#16803a]" }) {
  return <div><div className="mb-1.5 flex justify-between gap-4 text-sm"><span className="font-medium text-[#092a5a]">{label}</span><span className="shrink-0 font-bold text-[#16803a]">{detail || `${value}%`}</span></div><div className="h-2.5 overflow-hidden rounded-full bg-[#dbe5ef]"><div className={`h-full rounded-full ${tone}`} style={{ width: `${value}%` }} /></div></div>;
}

function StandardPerformanceChart({ standards }) {
  const tone = (standard) => standard.score == null ? "bg-slate-300" : standard.score < 50 ? "bg-red-500" : standard.score < 70 ? "bg-[#d6aa45]" : "bg-[#16803a]";
  const status = (standard) => standard.score == null ? "Not scored / N/A" : standard.score < 50 ? "Needs attention" : standard.score < 70 ? "Developing" : "On track";
  return <section className="mt-6 overflow-hidden rounded-xl border border-[#dbe5ef] bg-white shadow-sm"><div className="flex flex-col gap-3 border-b border-[#dbe5ef] px-5 py-4 sm:flex-row sm:items-end sm:justify-between"><div><p className="text-xs font-bold uppercase tracking-[0.15em] text-[#16803a]">Performance overview</p><h2 className="mt-1 font-bold text-[#092a5a]">Standard performance</h2><p className="mt-1 text-sm text-[#68778c]">Numeric scores only; N/A is excluded from each percentage.</p></div><div className="flex flex-wrap gap-x-3 gap-y-1 text-xs font-semibold text-[#68778c]"><span><i className="mr-1 inline-block h-2.5 w-2.5 rounded-full bg-[#16803a]" />70–100%</span><span><i className="mr-1 inline-block h-2.5 w-2.5 rounded-full bg-[#d6aa45]" />50–69%</span><span><i className="mr-1 inline-block h-2.5 w-2.5 rounded-full bg-red-500" />Below 50%</span></div></div><div className="max-h-[34rem] space-y-4 overflow-y-auto p-5 sm:p-6">{standards.map((standard) => <div key={standard.standardId} className="group"><div className="mb-1.5 flex items-baseline justify-between gap-4"><div className="min-w-0"><p className="truncate text-sm font-semibold text-[#092a5a]">{standard.standardNumber} · {standard.standardTitle}</p><p className="mt-0.5 text-xs text-[#68778c]">{standard.scored} / {standard.entries.length} requirements scored · {status(standard)}</p></div><strong className="shrink-0 text-sm text-[#092a5a]">{standard.score == null ? "—" : `${standard.score}%`}</strong></div><div className="h-3 overflow-hidden rounded-full bg-[#e8eef5]" title={`${standard.standardTitle}: ${standard.score == null ? "not scored or N/A" : `${standard.score}%`}`}><div className={`h-full rounded-full transition-all duration-700 ${tone(standard)}`} style={{ width: `${standard.score || 0}%` }} /></div></div>)}</div></section>;
}

function SurveyTeamLeadDashboardPage() {
  const { surveyId } = useParams();
  const { auth, profile } = useAuth();
  const [survey, setSurvey] = useState(null);
  const [assessments, setAssessments] = useState([]);
  const [checks, setChecks] = useState([]);
  const [criteria, setCriteria] = useState([]);
  const [compliances, setCompliances] = useState([]);
  const [standards, setStandards] = useState([]);
  const [components, setComponents] = useState([]);
  const [progress, setProgress] = useState(null);
  const [error, setError] = useState("");

  useEffect(() => {
    const load = async () => {
      try {
        const [surveyRes, assessmentRes, evidenceRes, criterionRes, complianceRes, standardRes, componentRes, progressRes] = await Promise.all([
          getOne("surveys", surveyId), getSurveyAssessmentOverview(surveyId), getSurveyEvidenceChecks(surveyId), getAll("criteria"), getAll("compliances"), getAll("standards"), getAll("components"), getSurveyProgress(surveyId),
        ]);
        setSurvey(surveyRes.data); setAssessments(assessmentRes.data); setChecks(evidenceRes.data); setCriteria(criterionRes.data); setCompliances(complianceRes.data); setStandards(standardRes.data); setComponents(componentRes.data); setProgress(progressRes.data); setError("");
      } catch (loadError) {
        console.error(loadError);
        setError("This dashboard is available only to the survey team lead or an Administrator.");
      }
    };
    if (auth && profile) load();
  }, [surveyId, auth?.roleName, profile?.userId]);

  const dashboard = useMemo(() => {
    const complianceById = new Map(compliances.map((item) => [item.complianceId, item]));
    const criterionById = new Map(criteria.map((item) => [item.criterionId, item]));
    const standardById = new Map(standards.map((item) => [item.standardId, item]));
    const assessmentById = new Map(assessments.map((item) => [item.complianceAssessmentId, item]));
    const rows = assessments.map((assessment) => {
      const compliance = complianceById.get(assessment.complianceId);
      const criterion = criterionById.get(compliance?.criterionId);
      return { ...assessment, standard: standardById.get(criterion?.standardId) };
    });
    const standardRows = [...new Map(rows.map((row) => [row.standard?.standardId, row.standard])).values()].filter(Boolean).map((standard) => {
      const entries = rows.filter((row) => row.standard?.standardId === standard.standardId);
      const evidence = checks.filter((check) => entries.some((row) => row.complianceAssessmentId === check.complianceAssessmentId));
      const scored = entries.filter((row) => row.scoreId && row.scoreValue != null);
      return { ...standard, entries, score: scored.length ? percentage(scored.reduce((sum, row) => sum + row.scoreValue, 0), scored.length * 2) : null, scored: entries.filter((row) => row.scoreId).length, evidenceComplete: evidence.filter((check) => check.isChecked).length, evidenceTotal: evidence.length, risks: entries.filter((row) => row.riskRatingId).length, surveyors: [...new Set(entries.map((row) => row.surveyorName).filter(Boolean))] };
    }).sort((first, second) => numberSort(first.standardNumber, second.standardNumber));
    const componentRows = components.map((component) => {
      const componentStandards = standardRows.filter((standard) => standard.componentNumber === component.componentNumber);
      const scores = componentStandards.map((standard) => standard.score).filter((score) => score != null);
      return { ...component, standards: componentStandards, score: scores.length ? Math.round(scores.reduce((sum, score) => sum + score, 0) / scores.length) : null };
    }).filter((component) => component.standards.length).sort((first, second) => numberSort(first.componentNumber, second.componentNumber));
    const team = [...new Map(rows.map((row) => [row.surveyorId, { surveyorId: row.surveyorId, name: row.surveyorName }])).values()].map((member) => {
      const memberRows = rows.filter((row) => row.surveyorId === member.surveyorId);
      const memberIds = new Set(memberRows.map((row) => row.complianceAssessmentId));
      const memberChecks = checks.filter((check) => memberIds.has(check.complianceAssessmentId));
      return { ...member, requirements: memberRows.length, scored: memberRows.filter((row) => row.scoreId).length, evidenceComplete: memberChecks.filter((check) => check.isChecked).length, evidenceTotal: memberChecks.length, risks: memberRows.filter((row) => row.riskRatingId).length };
    }).sort((first, second) => first.name.localeCompare(second.name));
    return { standardRows, componentRows, team, risks: rows.filter((row) => row.riskRatingId).length, unscored: rows.filter((row) => !row.scoreId).length, uncheckedEvidence: checks.filter((check) => !check.isChecked).length, assessmentById };
  }, [assessments, checks, criteria, compliances, standards, components]);

  if (error) return <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6"><Link to={`/surveys/${surveyId}`} className="text-sm font-semibold text-[#16803a]">← Back to survey</Link><p className="mt-5 rounded-xl border border-red-100 bg-red-50 p-5 text-sm text-red-800">{error}</p></main>;
  if (!survey || !progress) return <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6"><div className="h-56 animate-pulse rounded-2xl bg-slate-100" /></main>;
  const scoreCompletion = percentage(progress.scoredCount, progress.totalCompliances);
  const evidenceCompletion = percentage(progress.checkedEvidenceCount, progress.totalEvidenceChecks);

  return <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:py-8">
    <Link to={`/surveys/${surveyId}`} className="text-sm font-semibold text-[#16803a] hover:underline">← Back to survey</Link>
    <header className="mt-5 rounded-2xl border border-[#c9dded] bg-[linear-gradient(125deg,#eaf3fb_0%,#f8fafc_65%,#fdf7ea_100%)] p-6 sm:p-8"><div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between"><div><p className="text-xs font-bold uppercase tracking-[.16em] text-[#16803a]">Team lead dashboard</p><h1 className="mt-2 text-3xl font-bold text-[#092a5a]">{survey.facilityName}</h1><p className="mt-2 text-sm text-[#4b5f7a]">{survey.surveyTypeName} survey · {survey.startDate} — {survey.endDate}</p></div><div className="flex flex-wrap gap-2"><Link to={`/surveys/${surveyId}?view=overview`} className="rounded-lg border border-[#c5d5e8] bg-white px-4 py-2.5 text-sm font-semibold text-[#16803a] hover:bg-[#edf8f0]">View all scores</Link><Link to={`/surveys/${surveyId}/results`} className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#0d6531]">Results & report</Link></div></div></header>
    <section className="mt-6 grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><Stat label="Requirements scored" value={`${progress.scoredCount} / ${progress.totalCompliances}`} note={`${scoreCompletion}% complete`} /><Stat label="Evidence completed" value={`${progress.checkedEvidenceCount} / ${progress.totalEvidenceChecks}`} note={`${evidenceCompletion}% complete`} /><Stat label="Outstanding requirements" value={dashboard.unscored} note="Awaiting a score" tone="text-amber-700" /><Stat label="Risk findings" value={dashboard.risks} note="Recorded across the survey" tone="text-red-700" /></section>
    <section className="mt-6 grid gap-6 xl:grid-cols-[minmax(0,1.15fr)_minmax(22rem,.85fr)]"><div className="rounded-xl border border-[#dbe5ef] bg-white p-5 shadow-sm sm:p-6"><div className="flex items-baseline justify-between gap-4"><h2 className="text-lg font-bold text-[#092a5a]">Component progress</h2><span className="text-xs text-[#68778c]">Completion and average score</span></div><div className="mt-5 space-y-5">{dashboard.componentRows.map((component) => <div key={component.componentId}><div className="mb-2 flex justify-between gap-4 text-sm"><span className="font-semibold text-[#092a5a]">{component.componentNumber} · {component.componentName}</span><span className="shrink-0 font-bold text-[#16803a]">{component.score == null ? "N/A" : `${component.score}%`}</span></div><div className="h-3 overflow-hidden rounded-full bg-[#dbe5ef]"><div className="h-full rounded-full bg-[#16803a] transition-all duration-500" style={{ width: `${component.score || 0}%` }} /></div></div>)}</div></div><div className="rounded-xl border border-[#dbe5ef] bg-white p-5 shadow-sm sm:p-6"><h2 className="text-lg font-bold text-[#092a5a]">Survey completion</h2><div className="mt-5 space-y-6"><ProgressRow label="Scores recorded" value={scoreCompletion} detail={`${progress.scoredCount} of ${progress.totalCompliances}`} /><ProgressRow label="Evidence checked" value={evidenceCompletion} detail={`${progress.checkedEvidenceCount} of ${progress.totalEvidenceChecks}`} tone="bg-[#d6aa45]" /><div className="rounded-lg bg-amber-50 p-4 text-sm text-amber-900"><span className="font-bold">Needs attention:</span> {dashboard.unscored} score{dashboard.unscored === 1 ? "" : "s"} and {dashboard.uncheckedEvidence} evidence check{dashboard.uncheckedEvidence === 1 ? "" : "s"} remain.</div></div></div></section>
    <section className="mt-6 overflow-hidden rounded-xl border border-[#dbe5ef] bg-white shadow-sm"><div className="flex flex-col gap-2 border-b border-[#dbe5ef] px-5 py-4 sm:flex-row sm:items-center sm:justify-between"><div><h2 className="font-bold text-[#092a5a]">Team workload</h2><p className="mt-1 text-sm text-[#68778c]">Progress for each surveyor’s assigned requirements.</p></div><span className="text-sm font-semibold text-[#16803a]">{dashboard.team.length} team member{dashboard.team.length === 1 ? "" : "s"}</span></div><div className="divide-y divide-[#e7edf4] sm:hidden">{dashboard.team.map((member) => <article key={member.surveyorId} className="p-4"><p className="font-semibold text-[#092a5a]">{member.name}</p><dl className="mt-3 grid grid-cols-2 gap-3 text-sm"><div><dt className="text-xs font-bold uppercase tracking-wider text-[#68778c]">Requirements</dt><dd className="mt-1 text-[#4b5f7a]">{member.scored} / {member.requirements}</dd></div><div><dt className="text-xs font-bold uppercase tracking-wider text-[#68778c]">Evidence</dt><dd className="mt-1 text-[#4b5f7a]">{member.evidenceComplete} / {member.evidenceTotal}</dd></div><div className="col-span-2"><dt className="text-xs font-bold uppercase tracking-wider text-[#68778c]">Risk findings</dt><dd className="mt-1 font-semibold text-[#092a5a]">{member.risks || "None"}</dd></div></dl></article>)}</div><div className="hidden overflow-x-auto sm:block"><table className="w-full min-w-[700px] text-left text-sm"><thead className="bg-[#f6f9fc] text-xs uppercase tracking-wider text-[#4b5f7a]"><tr><th className="px-5 py-3">Surveyor</th><th className="px-5 py-3">Requirements scored</th><th className="px-5 py-3">Evidence complete</th><th className="px-5 py-3">Risk findings</th></tr></thead><tbody className="divide-y divide-[#e7edf4]">{dashboard.team.map((member) => <tr key={member.surveyorId}><td className="px-5 py-4 font-semibold text-[#092a5a]">{member.name}</td><td className="px-5 py-4 text-[#4b5f7a]">{member.scored} / {member.requirements}</td><td className="px-5 py-4 text-[#4b5f7a]">{member.evidenceComplete} / {member.evidenceTotal}</td><td className="px-5 py-4 font-semibold text-[#092a5a]">{member.risks || "None"}</td></tr>)}</tbody></table></div></section>
    <StandardPerformanceChart standards={dashboard.standardRows} />
    <section className="mt-6 overflow-hidden rounded-xl border border-[#dbe5ef] bg-white shadow-sm"><div className="border-b border-[#dbe5ef] px-5 py-4"><h2 className="font-bold text-[#092a5a]">Standard status</h2><p className="mt-1 text-sm text-[#68778c]">A concise view of completion, evidence, score, and responsible surveyor.</p></div><div className="divide-y divide-[#e7edf4] sm:hidden">{dashboard.standardRows.map((standard) => <article key={standard.standardId} className="p-4"><p className="font-semibold leading-6 text-[#092a5a]">{standard.standardNumber} · {standard.standardTitle}</p><p className="mt-1 text-sm text-[#4b5f7a]">Assigned: {standard.surveyors.join(", ") || "—"}</p><dl className="mt-3 grid grid-cols-2 gap-3 text-sm"><div><dt className="text-xs font-bold uppercase tracking-wider text-[#68778c]">Score</dt><dd className="mt-1 font-semibold text-[#16803a]">{standard.score == null ? "—" : `${standard.score}%`}</dd></div><div><dt className="text-xs font-bold uppercase tracking-wider text-[#68778c]">Risks</dt><dd className="mt-1 font-semibold text-[#092a5a]">{standard.risks || "None"}</dd></div><div><dt className="text-xs font-bold uppercase tracking-wider text-[#68778c]">Requirements</dt><dd className="mt-1 text-[#4b5f7a]">{standard.scored} / {standard.entries.length}</dd></div><div><dt className="text-xs font-bold uppercase tracking-wider text-[#68778c]">Evidence</dt><dd className="mt-1 text-[#4b5f7a]">{standard.evidenceComplete} / {standard.evidenceTotal}</dd></div></dl></article>)}</div><div className="hidden overflow-x-auto sm:block"><table className="w-full min-w-[900px] text-left text-sm"><thead className="bg-[#f6f9fc] text-xs uppercase tracking-wider text-[#4b5f7a]"><tr><th className="px-5 py-3">Standard</th><th className="px-5 py-3">Surveyor</th><th className="px-5 py-3">Score</th><th className="px-5 py-3">Requirements</th><th className="px-5 py-3">Evidence</th><th className="px-5 py-3">Risks</th></tr></thead><tbody className="divide-y divide-[#e7edf4]">{dashboard.standardRows.map((standard) => <tr key={standard.standardId}><td className="px-5 py-4 font-semibold text-[#092a5a]">{standard.standardNumber} · {standard.standardTitle}</td><td className="px-5 py-4 text-[#4b5f7a]">{standard.surveyors.join(", ")}</td><td className="px-5 py-4 font-semibold text-[#16803a]">{standard.score == null ? "—" : `${standard.score}%`}</td><td className="px-5 py-4 text-[#4b5f7a]">{standard.scored} / {standard.entries.length}</td><td className="px-5 py-4 text-[#4b5f7a]">{standard.evidenceComplete} / {standard.evidenceTotal}</td><td className="px-5 py-4 text-[#092a5a]">{standard.risks || "None"}</td></tr>)}</tbody></table></div></section>
  </main>;
}

const Stat = ({ label, value, note, tone = "text-[#092a5a]" }) => <div className="rounded-xl border border-[#dbe5ef] bg-white p-5 shadow-sm"><p className="text-xs font-bold uppercase tracking-wider text-[#68778c]">{label}</p><p className={`mt-2 text-2xl font-bold ${tone}`}>{value}</p><p className="mt-1 text-sm text-[#68778c]">{note}</p></div>;
export default SurveyTeamLeadDashboardPage;
