import { useEffect, useState } from "react";
import { Link, useParams, useSearchParams } from "react-router-dom";
import { getMySurveyorReportWorkspace, getOne, saveMySurveyorReport } from "../../api/api";
import ConfirmDialog from "../../components/ConfirmDialog";

const empty = { summary: "", goodPractices: "", notApplicableNotes: "", findingActions: [] };

export default function SurveyorReportPage() {
  const { surveyId } = useParams();
  const [searchParams] = useSearchParams();
  const surveyorMode = searchParams.get("mode") === "surveyor";
  const assessmentPath = `/surveys/${surveyId}${surveyorMode ? "?mode=surveyor" : ""}`;
  const [survey, setSurvey] = useState(null);
  const [workspace, setWorkspace] = useState(null);
  const [form, setForm] = useState(empty);
  const [saving, setSaving] = useState(false);
  const [submitOpen, setSubmitOpen] = useState(false);
  const [error, setError] = useState("");
  const load = async () => {
    try {
      const [surveyRes, workspaceRes] = await Promise.all([getOne("surveys", surveyId), getMySurveyorReportWorkspace(surveyId)]);
      const data = workspaceRes.data;
      setSurvey(surveyRes.data); setWorkspace(data);
      setForm({ summary: data.report?.summary || "", goodPractices: data.report?.goodPractices || "", notApplicableNotes: data.report?.notApplicableNotes || "", findingActions: data.findings.map((finding) => ({ complianceAssessmentId: finding.complianceAssessmentId, recommendation: finding.recommendation || "", correctiveAction: finding.correctiveAction || "" })) });
      setError("");
    } catch (loadError) { console.error(loadError); setError("We couldn't load your surveyor report. Confirm that you are assigned to this survey."); }
  };
  useEffect(() => { load(); }, [surveyId]);
  const complete = workspace && workspace.assignedRequirements === workspace.scoredRequirements;
  const setAction = (assessmentId, key, value) => setForm((current) => ({ ...current, findingActions: current.findingActions.map((action) => action.complianceAssessmentId === assessmentId ? { ...action, [key]: value } : action) }));
  const save = async (submit) => { try { setSaving(true); await saveMySurveyorReport(surveyId, { ...form, submit }); await load(); } catch (saveError) { console.error(saveError); setError(saveError.response?.data || "We couldn't save your report."); } finally { setSaving(false); } };
  if (error && !workspace) return <main className="mx-auto max-w-5xl px-4 py-8"><Link to={assessmentPath} className="text-sm font-semibold text-[#16803a]">← Back to survey</Link><p className="mt-5 rounded-xl border border-red-200 bg-red-50 p-5 text-sm text-red-800">{error}</p></main>;
  if (!survey || !workspace) return <main className="mx-auto max-w-5xl px-4 py-8"><div className="h-64 animate-pulse rounded-2xl bg-slate-100" /></main>;
  const submitted = workspace.report?.isSubmitted;
  return <main className="mx-auto max-w-5xl px-4 py-6 sm:px-6 lg:py-8">
    <Link to={assessmentPath} className="text-sm font-semibold text-[#16803a] hover:underline">← Back to survey</Link>
    <header className="mt-5 rounded-2xl border border-[#bfded8] bg-[linear-gradient(120deg,#f3faf8_0%,#fff_70%,#fcf7ed_100%)] p-6 sm:p-8"><p className="text-xs font-bold uppercase tracking-[.16em] text-[#16803a]">Surveyor handover</p><h1 className="mt-2 text-3xl font-bold text-[#092a5a]">Surveyor report</h1><p className="mt-2 text-sm text-[#4b5f7a]">{survey.facilityName} · {workspace.scoredRequirements} of {workspace.assignedRequirements} assigned requirements scored</p></header>
    {error && <p className="mt-5 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">{error}</p>}
    {submitted ? <section className="mt-6 rounded-xl border border-[#b8d9d3] bg-[#edf8f0] p-5"><p className="font-bold text-[#16803a]">Your report has been submitted.</p><p className="mt-1 text-sm text-[#4b5f7a]">It is now available to the team lead for the consolidated report.</p></section> : <>
      <section className="mt-6 rounded-xl border border-[#dbe5ef] bg-white p-5 shadow-sm"><p className="text-xs font-bold uppercase tracking-[.14em] text-[#16803a]">Priority findings</p><h2 className="mt-1 text-xl font-bold text-[#092a5a]">Recommendations and corrective actions</h2><p className="mt-2 text-sm leading-6 text-[#4b5f7a]">These findings are generated from your non-compliant or partially compliant requirements with High or Extreme risk. Add a recommendation and corrective action beside each one.</p><div className="mt-5 space-y-4">{workspace.findings.length ? workspace.findings.map((finding) => <article key={finding.complianceAssessmentId} className="rounded-lg border border-[#ead7a3] bg-[#fffbf0] p-4"><div className="flex flex-wrap gap-2"><span className="font-bold text-[#092a5a]">{finding.complianceNumber}</span><span className="rounded-full bg-red-50 px-2 py-0.5 text-xs font-semibold text-red-700">{finding.scoreLabel}</span><span className="rounded-full bg-orange-50 px-2 py-0.5 text-xs font-semibold text-orange-800">{finding.riskLabel} risk</span></div><p className="mt-2 text-sm leading-6 text-[#385273]">{finding.complianceSummary}</p>{finding.comments && <p className="mt-2 border-l-2 border-[#d6aa45] pl-3 text-sm italic leading-6 text-[#4b5f7a]">{finding.comments}</p>}<div className="mt-4 grid gap-4 md:grid-cols-2"><TextArea label="Recommendation" value={form.findingActions.find((action) => action.complianceAssessmentId === finding.complianceAssessmentId)?.recommendation} onChange={(value) => setAction(finding.complianceAssessmentId, "recommendation", value)} /><TextArea label="Corrective action" value={form.findingActions.find((action) => action.complianceAssessmentId === finding.complianceAssessmentId)?.correctiveAction} onChange={(value) => setAction(finding.complianceAssessmentId, "correctiveAction", value)} /></div></article>) : <p className="rounded-lg bg-[#edf8f0] px-4 py-3 text-sm text-[#16803a]">No non-compliant or partially compliant High/Extreme-risk findings are assigned to you.</p>}</div></section>
      <section className="mt-6 rounded-xl border border-[#dbe5ef] bg-white p-5 shadow-sm"><p className="text-xs font-bold uppercase tracking-[.14em] text-[#16803a]">Narrative report</p><div className="mt-4 grid gap-5"><TextArea label="Overall summary" required value={form.summary} onChange={(value) => setForm((current) => ({ ...current, summary: value }))} /><TextArea label="Good practices observed" value={form.goodPractices} onChange={(value) => setForm((current) => ({ ...current, goodPractices: value }))} /><TextArea label="Not applicable notes" hint="Explain requirements that were not applicable to this facility or service." value={form.notApplicableNotes} onChange={(value) => setForm((current) => ({ ...current, notApplicableNotes: value }))} /></div><div className="mt-6 flex flex-wrap justify-end gap-3"><button disabled={saving} onClick={() => save(false)} className="rounded-lg border border-[#c5d5e8] px-4 py-2.5 text-sm font-semibold text-[#16803a] disabled:opacity-60">Save draft</button><button disabled={saving || !complete} onClick={() => setSubmitOpen(true)} className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white disabled:cursor-not-allowed disabled:opacity-50">Submit report</button></div>{!complete && <p className="mt-3 text-right text-xs text-amber-800">Return to the survey and score every assigned requirement before submitting.</p>}</section>
    </>}
    <ConfirmDialog open={submitOpen} title="Submit your surveyor report?" message="Submitting hands your findings to the Team Lead and locks your assigned scores, risk ratings, comments, and evidence checks. Changes can only be made after a Team Lead or Administrator reopens the report with a recorded reason." confirmLabel={saving ? "Submitting…" : "Submit and lock"} confirmDisabled={saving} onCancel={() => !saving && setSubmitOpen(false)} onConfirm={async () => { await save(true); setSubmitOpen(false); }} />
  </main>;
}

function TextArea({ label, hint, required, value, onChange }) { return <label className="block text-sm font-semibold text-[#092a5a]">{label}{required && <span className="ml-1 text-red-700">*</span>}{hint && <span className="mt-1 block text-xs font-normal leading-5 text-[#68778c]">{hint}</span>}<textarea value={value || ""} onChange={(event) => onChange(event.target.value)} rows="4" className="mt-1.5 h-28 w-full resize-none rounded-lg border border-[#c5d4e6] px-3 py-2.5 text-sm font-normal leading-6 text-[#092a5a] outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]" /></label>; }
