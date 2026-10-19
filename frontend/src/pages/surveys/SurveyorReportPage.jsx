import { useEffect, useState } from "react";
import { Link, useParams, useSearchParams } from "react-router-dom";
import { getMySurveyorReportWorkspace, getOne, saveMySurveyorReport } from "../../api/api";
import StandardSummationReports from "../../components/StandardSummationReports";
import SurveyContextNav from "../../components/SurveyContextNav";

export default function SurveyorReportPage() {
  const { surveyId } = useParams();
  const [params] = useSearchParams();
  const mode = params.get("mode") === "surveyor" ? "?mode=surveyor" : "";
  const [data, setData] = useState(null);
  const [error, setError] = useState("");
  const [saving, setSaving] = useState(false);
  useEffect(() => {
    let active = true;
    setData(null); setError("");
    Promise.all([getOne("surveys", surveyId), getMySurveyorReportWorkspace(surveyId)])
      .then(([survey, workspace]) => { if (active) setData({ survey: survey.data, ...workspace.data }); })
      .catch(() => { if (active) setError("We couldn't load your standard summations. Please reload to retry."); });
    return () => { active = false; };
  }, [surveyId]);
  if (error && !data) return <main className="p-6"><p role="alert">{error}</p></main>;
  if (!data) return <main className="p-6">Loading standard summations…</main>;
  const ready = data.assignedRequirements > 0 && data.scoredRequirements === data.assignedRequirements && data.completedStandardSummaryCount === data.assignedStandardCount && !data.survey.isCancelled;
  const submit = async () => {
    if (saving || !ready || data.report?.isSubmitted || !window.confirm("Submit all your standard summations to the Team Lead? Your scores and summations will be locked until reopened.")) return;
    setSaving(true); setError("");
    try {
      await saveMySurveyorReport(surveyId, { submit: true });
      const response = await getMySurveyorReportWorkspace(surveyId);
      setData(current => ({ ...current, ...response.data }));
    } catch (err) { setError(typeof err.response?.data === "string" ? err.response.data : "Submission could not be confirmed. Reload to check its status before retrying."); }
    finally { setSaving(false); }
  };
  return <main className="mx-auto max-w-5xl px-4 py-6">
    <div className="print:hidden">
      <Link to={`/surveys/${surveyId}${mode}`} className="font-semibold underline">← Back to assessment</Link>
      <SurveyContextNav surveyId={surveyId} />
      <h1 className="mt-6 text-2xl font-bold">My standard summations</h1>
      <p className="mt-2">{data.survey.facilityName} · {data.completedStandardSummaryCount} of {data.assignedStandardCount} assigned standard summations saved.</p>
      <p className="mt-2">Complete the scores and save a summation for each assigned standard, then submit them together. No extra overall summary is required.</p>
      {error && <p role="alert" className="mt-3 text-red-700">{error}</p>}
      <ul className="mt-4 space-y-2">{(data.assignedStandards || []).map(item => {
        const saved = data.standardSummaries.some(s => s.standardId === item.standardId);
        return <li key={item.standardId}>Standard {item.standardNumber}: {item.unscored ? <Link className="underline" to={`/surveys/${surveyId}?standard=${item.standardId}${mode ? "&mode=surveyor" : ""}`}>{item.unscored} unscored — go to standard</Link> : "Scores complete"} · {saved ? "Summation saved" : <Link className="underline" to={`/surveys/${surveyId}/standards/${item.standardId}/summary${mode}`}>Summation missing — complete it</Link>}</li>;
      })}</ul>
      {data.report?.isSubmitted ? <p className="mt-4 font-semibold">Submitted to Team Lead. Your assessments and summations are locked until reopened.</p> : <button type="button" disabled={!ready || saving} onClick={submit} className="mt-4 rounded-lg bg-[#16803a] px-4 py-2 font-semibold text-white disabled:opacity-50">{saving ? "Submitting…" : "Submit all standard summations to Team Lead"}</button>}
      <StandardSummationReports summaries={data.standardSummaries} summaryPath={id => `/surveys/${surveyId}/standards/${id}/summary${mode}`} />
      <button type="button" onClick={() => window.print()} className="mt-5 rounded-lg bg-[#16803a] px-4 py-2 font-semibold text-white">Print summations / Save PDF</button>
      {(data.report?.summary || data.report?.goodPractices || data.report?.notApplicableNotes) && <details className="mt-6 rounded-lg border p-4"><summary>Historical handover (read-only)</summary><p>This legacy report is retained for reference and is not a completion requirement.</p>{[["summary","Overall summary"],["goodPractices","Commendations"],["notApplicableNotes","Scope notes"]].map(([key,label]) => <section key={key} className="mt-3"><h2 className="font-semibold">{label}</h2><p className="whitespace-pre-wrap">{data.report[key] || "Not recorded."}</p></section>)}</details>}
    </div>
    <article className="surveyor-handover-print hidden print:block">
      <header><h1>Standard summation reports</h1><p>{data.survey.facilityName} · {data.survey.surveyTypeName} · Survey #{surveyId}</p></header>
      <StandardSummationReports summaries={data.standardSummaries} print />
    </article>
  </main>;
}
