import { useEffect, useMemo, useState } from "react";
import { Link, useParams } from "react-router-dom";
import { getAll, getOne, getSurveyAssessmentOverview, getSurveyEvidenceChecks, getSurveyProgress } from "../../api/api";
import { useAuth } from "../../context/AuthContext";

const numberSort = (first, second) => String(first ?? "").localeCompare(String(second ?? ""), undefined, { numeric: true });
const percentage = (complete, total) => total ? Math.round((complete / total) * 100) : 0;

function ProgressRow({ label, value, detail, tone = "bg-[#087c77]" }) {
  return <div><div className="mb-1.5 flex justify-between gap-4 text-sm"><span className="font-medium text-[#143c42]">{label}</span><span className="shrink-0 font-bold text-[#087c77]">{detail || `${value}%`}</span></div><div className="h-2.5 overflow-hidden rounded-full bg-[#dce9e7]"><div className={`h-full rounded-full ${tone}`} style={{ width: `${value}%` }} /></div></div>;
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

  if (error) return <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6"><Link to={`/surveys/${surveyId}`} className="text-sm font-semibold text-[#087c77]">← Back to survey</Link><p className="mt-5 rounded-xl border border-red-100 bg-red-50 p-5 text-sm text-red-800">{error}</p></main>;
  if (!survey || !progress) return <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6"><div className="h-56 animate-pulse rounded-2xl bg-slate-100" /></main>;
  const scoreCompletion = percentage(progress.scoredCount, progress.totalCompliances);
  const evidenceCompletion = percentage(progress.checkedEvidenceCount, progress.totalEvidenceChecks);

  return <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:py-8">
    <Link to={`/surveys/${surveyId}`} className="text-sm font-semibold text-[#087c77] hover:underline">← Back to survey</Link>
    <header className="mt-5 rounded-2xl border border-[#cde5e0] bg-[linear-gradient(125deg,#e8f5f3_0%,#f8fbfa_65%,#fdf7ea_100%)] p-6 sm:p-8"><div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between"><div><p className="text-xs font-bold uppercase tracking-[.16em] text-teal-700">Team lead dashboard</p><h1 className="mt-2 text-3xl font-bold text-[#143c42]">{survey.facilityName}</h1><p className="mt-2 text-sm text-[#527076]">{survey.surveyTypeName} survey · {survey.startDate} — {survey.endDate}</p></div><div className="flex flex-wrap gap-2"><Link to={`/surveys/${surveyId}?view=overview`} className="rounded-lg border border-[#b9d6d1] bg-white px-4 py-2.5 text-sm font-semibold text-[#087c77] hover:bg-teal-50">View all scores</Link><Link to={`/surveys/${surveyId}/results`} className="rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#05635f]">Results & report</Link></div></div></header>
    <section className="mt-6 grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><Stat label="Requirements scored" value={`${progress.scoredCount} / ${progress.totalCompliances}`} note={`${scoreCompletion}% complete`} /><Stat label="Evidence completed" value={`${progress.checkedEvidenceCount} / ${progress.totalEvidenceChecks}`} note={`${evidenceCompletion}% complete`} /><Stat label="Outstanding requirements" value={dashboard.unscored} note="Awaiting a score" tone="text-amber-700" /><Stat label="Risk findings" value={dashboard.risks} note="Recorded across the survey" tone="text-red-700" /></section>
    <section className="mt-6 grid gap-6 xl:grid-cols-[minmax(0,1.15fr)_minmax(22rem,.85fr)]"><div className="rounded-xl border border-[#dce9e7] bg-white p-5 shadow-sm sm:p-6"><div className="flex items-baseline justify-between gap-4"><h2 className="text-lg font-bold text-[#143c42]">Component progress</h2><span className="text-xs text-[#668187]">Completion and average score</span></div><div className="mt-5 space-y-5">{dashboard.componentRows.map((component) => <div key={component.componentId}><div className="mb-2 flex justify-between gap-4 text-sm"><span className="font-semibold text-[#143c42]">{component.componentNumber} · {component.componentName}</span><span className="shrink-0 font-bold text-[#087c77]">{component.score == null ? "N/A" : `${component.score}%`}</span></div><div className="h-3 overflow-hidden rounded-full bg-[#dce9e7]"><div className="h-full rounded-full bg-[#087c77] transition-all duration-500" style={{ width: `${component.score || 0}%` }} /></div></div>)}</div></div><div className="rounded-xl border border-[#dce9e7] bg-white p-5 shadow-sm sm:p-6"><h2 className="text-lg font-bold text-[#143c42]">Survey completion</h2><div className="mt-5 space-y-6"><ProgressRow label="Scores recorded" value={scoreCompletion} detail={`${progress.scoredCount} of ${progress.totalCompliances}`} /><ProgressRow label="Evidence checked" value={evidenceCompletion} detail={`${progress.checkedEvidenceCount} of ${progress.totalEvidenceChecks}`} tone="bg-[#d6aa45]" /><div className="rounded-lg bg-amber-50 p-4 text-sm text-amber-900"><span className="font-bold">Needs attention:</span> {dashboard.unscored} score{dashboard.unscored === 1 ? "" : "s"} and {dashboard.uncheckedEvidence} evidence check{dashboard.uncheckedEvidence === 1 ? "" : "s"} remain.</div></div></div></section>
    <section className="mt-6 overflow-hidden rounded-xl border border-[#dce9e7] bg-white shadow-sm"><div className="flex flex-col gap-2 border-b border-[#dce9e7] px-5 py-4 sm:flex-row sm:items-center sm:justify-between"><div><h2 className="font-bold text-[#143c42]">Team workload</h2><p className="mt-1 text-sm text-[#668187]">Progress for each surveyor’s assigned requirements.</p></div><span className="text-sm font-semibold text-[#087c77]">{dashboard.team.length} team member{dashboard.team.length === 1 ? "" : "s"}</span></div><div className="overflow-x-auto"><table className="w-full min-w-[700px] text-left text-sm"><thead className="bg-[#f5faf9] text-xs uppercase tracking-wider text-[#527076]"><tr><th className="px-5 py-3">Surveyor</th><th className="px-5 py-3">Requirements scored</th><th className="px-5 py-3">Evidence complete</th><th className="px-5 py-3">Risk findings</th></tr></thead><tbody className="divide-y divide-[#e7efed]">{dashboard.team.map((member) => <tr key={member.surveyorId}><td className="px-5 py-4 font-semibold text-[#143c42]">{member.name}</td><td className="px-5 py-4 text-[#527076]">{member.scored} / {member.requirements}</td><td className="px-5 py-4 text-[#527076]">{member.evidenceComplete} / {member.evidenceTotal}</td><td className="px-5 py-4 font-semibold text-[#143c42]">{member.risks || "None"}</td></tr>)}</tbody></table></div></section>
    <section className="mt-6 overflow-hidden rounded-xl border border-[#dce9e7] bg-white shadow-sm"><div className="border-b border-[#dce9e7] px-5 py-4"><h2 className="font-bold text-[#143c42]">Standard status</h2><p className="mt-1 text-sm text-[#668187]">A concise view of completion, evidence, score, and responsible surveyor.</p></div><div className="overflow-x-auto"><table className="w-full min-w-[900px] text-left text-sm"><thead className="bg-[#f5faf9] text-xs uppercase tracking-wider text-[#527076]"><tr><th className="px-5 py-3">Standard</th><th className="px-5 py-3">Surveyor</th><th className="px-5 py-3">Score</th><th className="px-5 py-3">Requirements</th><th className="px-5 py-3">Evidence</th><th className="px-5 py-3">Risks</th></tr></thead><tbody className="divide-y divide-[#e7efed]">{dashboard.standardRows.map((standard) => <tr key={standard.standardId}><td className="px-5 py-4 font-semibold text-[#143c42]">{standard.standardNumber} · {standard.standardTitle}</td><td className="px-5 py-4 text-[#527076]">{standard.surveyors.join(", ")}</td><td className="px-5 py-4 font-semibold text-[#087c77]">{standard.score == null ? "—" : `${standard.score}%`}</td><td className="px-5 py-4 text-[#527076]">{standard.scored} / {standard.entries.length}</td><td className="px-5 py-4 text-[#527076]">{standard.evidenceComplete} / {standard.evidenceTotal}</td><td className="px-5 py-4 text-[#143c42]">{standard.risks || "None"}</td></tr>)}</tbody></table></div></section>
  </main>;
}

const Stat = ({ label, value, note, tone = "text-[#143c42]" }) => <div className="rounded-xl border border-[#dce9e7] bg-white p-5 shadow-sm"><p className="text-xs font-bold uppercase tracking-wider text-[#668187]">{label}</p><p className={`mt-2 text-2xl font-bold ${tone}`}>{value}</p><p className="mt-1 text-sm text-[#668187]">{note}</p></div>;
export default SurveyTeamLeadDashboardPage;
