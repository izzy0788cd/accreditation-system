import { useEffect, useRef, useState } from "react";
import { getSurveyorReportReview, getSurveyorReports, reopenSurveyorReport, saveMySurveyorReport } from "../api/api";
import ConfirmDialog from "./ConfirmDialog";
import FormModal from "./FormModal";

const emptyReport = { summary: "", priorityFindings: "", recommendations: "", goodPractices: "", notApplicableNotes: "" };

export default function SurveyorReportPanel({ surveyId, complete, teamView = false }) {
  const [reports, setReports] = useState([]);
  const [form, setForm] = useState(emptyReport);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [reopenTarget, setReopenTarget] = useState(null);
  const [reopenReason, setReopenReason] = useState("");
  const [reopening, setReopening] = useState(false);
  const [review, setReview] = useState(null);
  const [error, setError] = useState("");
  const reopenReasonRef = useRef(null);
  const load = async () => {
    try {
      setLoading(true);
      const response = await getSurveyorReports(surveyId);
      setReports(response.data);
      if (!teamView && response.data[0]) setForm({ ...emptyReport, ...response.data[0] });
      setError("");
    } catch (loadError) { console.error(loadError); setError("We couldn't load the surveyor report."); } finally { setLoading(false); }
  };
  useEffect(() => { load(); }, [surveyId, teamView]);
  const save = async (submit) => {
    try {
      setSaving(true);
      const response = await saveMySurveyorReport(surveyId, { ...form, submit });
      setForm({ ...emptyReport, ...response.data });
      setReports([response.data]);
      setError("");
    } catch (saveError) { console.error(saveError); setError(saveError.response?.data || "We couldn't save your report."); } finally { setSaving(false); }
  };
  const reopen = async () => {
    if (!reopenTarget || !reopenReason.trim()) return;
    try {
      setReopening(true);
      await reopenSurveyorReport(reopenTarget.surveyorReportId, reopenReason.trim());
      setReopenTarget(null);
      setReopenReason("");
      await load();
    } catch (reopenError) {
      console.error(reopenError);
      setError(reopenError.response?.data || "We couldn't reopen this surveyor report.");
    } finally { setReopening(false); }
  };
  const viewReport = async (report) => {
    try {
      setReview({ report, findings: null });
      const response = await getSurveyorReportReview(report.surveyorReportId);
      setReview(response.data);
    } catch (reviewError) {
      console.error(reviewError);
      setReview(null);
      setError(reviewError.response?.data || "We couldn't load the submitted surveyor report.");
    }
  };
  if (loading) return <section className="mt-6 h-44 animate-pulse rounded-xl bg-slate-100" />;
  if (teamView) return <><section className="mt-6 overflow-hidden rounded-xl border border-[#dbe5ef] bg-white shadow-sm"><div className="border-b border-[#dbe5ef] px-5 py-4"><p className="text-xs font-bold uppercase tracking-[.14em] text-[#16803a]">Surveyor handover</p><h2 className="mt-1 font-bold text-[#092a5a]">Submitted surveyor reports</h2><p className="mt-1 text-sm text-[#68778c]">Review individual findings before preparing the consolidated report.</p></div>{error && <p className="m-4 rounded-lg bg-red-50 px-3 py-2 text-sm text-red-800">{error}</p>}{reports.length ? <div className="divide-y divide-[#e7edf4]">{reports.map((report) => <article key={report.surveyorReportId} className="p-5"><div className="flex flex-wrap items-center justify-between gap-2"><h3 className="font-semibold text-[#092a5a]">{report.surveyorName}</h3><span className={`rounded-full px-2.5 py-1 text-xs font-semibold ${report.isSubmitted ? "bg-[#edf8f0] text-[#16803a]" : "bg-amber-50 text-amber-800"}`}>{report.isSubmitted ? "Submitted" : "Draft"}</span></div><p className="mt-2 text-sm leading-6 text-[#4b5f7a]">{report.summary || "No overall summary recorded yet."}</p>{report.isSubmitted && <div className="mt-3 flex flex-wrap items-center justify-between gap-3"><p className="text-xs text-[#68778c]">Submitted {new Date(report.submittedAt).toLocaleString()}</p><div className="flex flex-wrap gap-2"><button onClick={() => viewReport(report)} className="rounded-lg border border-[#c5d5e8] bg-white px-3 py-2 text-xs font-semibold text-[#16803a] hover:bg-[#edf8f0]">View report</button><button onClick={() => { setReopenTarget(report); setReopenReason(""); }} className="rounded-lg border border-amber-300 bg-amber-50 px-3 py-2 text-xs font-semibold text-amber-900 hover:bg-amber-100">Reopen handover</button></div></div>}</article>)}</div> : <p className="p-5 text-sm text-[#68778c]">No surveyor reports have been started yet.</p>}</section><SurveyorReportReviewModal review={review} onClose={() => setReview(null)} /><SurveyorHandoverPrint review={review} /><ConfirmDialog open={!!reopenTarget} title="Reopen this surveyor report?" message="This unlocks the surveyor’s assigned scores, risk ratings, comments, and evidence checks. Your reason will be recorded in the handover audit history." confirmLabel={reopening ? "Reopening…" : "Reopen report"} confirmDisabled={reopening || !reopenReason.trim()} onCancel={() => !reopening && setReopenTarget(null)} onConfirm={reopen} initialFocusRef={reopenReasonRef}><label className="mt-4 block text-sm font-semibold text-[#092a5a]">Reason for reopening<textarea ref={reopenReasonRef} required value={reopenReason} onChange={(event) => setReopenReason(event.target.value)} rows="4" className="mt-1.5 w-full resize-none rounded-lg border border-[#c5d4e6] px-3 py-2.5 text-sm font-normal leading-6" placeholder="Describe the correction or review required." /></label></ConfirmDialog></>;
  const submitted = reports[0]?.isSubmitted;
  const set = (key, value) => setForm((current) => ({ ...current, [key]: value }));
  return <section className="mt-6 overflow-hidden rounded-xl border border-[#bfded8] bg-white shadow-sm"><div className="border-b border-[#b8d9d3] bg-[#f3faf8] px-5 py-4"><p className="text-xs font-bold uppercase tracking-[.14em] text-[#16803a]">Surveyor handover</p><h2 className="mt-1 font-bold text-[#092a5a]">My surveyor report</h2><p className="mt-1 text-sm text-[#4b5f7a]">Save observations as a draft while you work. Submit one report after every assigned requirement has been scored.</p></div>{error && <p role="alert" className="m-4 rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-800">{error}</p>}{submitted ? <div className="p-5 text-sm text-[#16803a]"><p className="font-semibold">Your report was submitted.</p><p className="mt-1 text-[#4b5f7a]">The team lead can now use it when compiling the consolidated report.</p></div> : <div className="p-5"><div className="grid gap-4"><Field label="Overall summary" value={form.summary} onChange={(value) => set("summary", value)} required /><Field label="Priority findings" hint="Highlight non-compliant or partially compliant findings with High or Extreme risk." value={form.priorityFindings} onChange={(value) => set("priorityFindings", value)} /><Field label="Recommendations and corrective actions" value={form.recommendations} onChange={(value) => set("recommendations", value)} /><Field label="Good practices observed" value={form.goodPractices} onChange={(value) => set("goodPractices", value)} /><Field label="Not applicable notes" hint="Explain requirements that were not applicable to this facility or service." value={form.notApplicableNotes} onChange={(value) => set("notApplicableNotes", value)} /></div><div className="mt-5 flex flex-wrap items-center justify-end gap-3"><button type="button" disabled={saving} onClick={() => save(false)} className="rounded-lg border border-[#c5d5e8] px-4 py-2.5 text-sm font-semibold text-[#16803a] disabled:opacity-60">Save draft</button><button type="button" disabled={saving || !complete} onClick={() => save(true)} className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white disabled:cursor-not-allowed disabled:opacity-50">{saving ? "Saving…" : "Submit report"}</button></div>{!complete && <p className="mt-3 text-right text-xs text-amber-800">Score all assigned requirements to submit your report.</p>}</div>}</section>;
}

function Field({ label, hint, value, onChange, required }) {
  return <label className="block text-sm font-semibold text-[#092a5a]">{label}{required && <span className="ml-1 text-red-700">*</span>}{hint && <span className="mt-1 block text-xs font-normal leading-5 text-[#68778c]">{hint}</span>}<textarea value={value || ""} onChange={(event) => onChange(event.target.value)} rows="4" className="mt-1.5 h-28 w-full resize-none rounded-lg border border-[#c5d4e6] px-3 py-2.5 text-sm font-normal leading-6 text-[#092a5a] outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]" /></label>;
}

function SurveyorReportReviewModal({ review, onClose }) {
  const report = review?.report;
  return <FormModal open={!!review} onClose={onClose} wide>
    {!review?.findings ? <div className="py-12 text-center text-sm text-[#4b5f7a]">Loading submitted report…</div> : <div>
      <p className="text-xs font-bold uppercase tracking-[.14em] text-[#16803a]">Surveyor handover</p>
      <h2 className="mt-1 text-2xl font-bold text-[#092a5a]">{report.surveyorName}’s submitted report</h2>
      <p className="mt-2 text-sm text-[#68778c]">Submitted {new Date(report.submittedAt).toLocaleString()}</p>
      <ReportSection title="Overall summary" value={report.summary} />
      <ReportSection title="Priority findings summary" value={report.priorityFindings} empty="Priority findings are listed below." />
      <ReportSection title="Good practices observed" value={report.goodPractices} empty="No good practices were recorded." />
      <ReportSection title="Not applicable notes" value={report.notApplicableNotes} empty="No not-applicable notes were recorded." />
      <section className="mt-6">
        <p className="text-xs font-bold uppercase tracking-[.14em] text-[#9a5b13]">Priority findings</p>
        <h3 className="mt-1 text-lg font-bold text-[#092a5a]">Recommendations and corrective actions</h3>
        <div className="mt-4 space-y-3">{review.findings.length ? review.findings.map((finding) => <article key={finding.complianceAssessmentId} className="rounded-lg border border-[#ead7a3] bg-[#fffbf0] p-4"><div className="flex flex-wrap gap-2"><strong className="text-[#092a5a]">{finding.complianceNumber}</strong><span className="rounded-full bg-red-50 px-2 py-0.5 text-xs font-semibold text-red-700">{finding.scoreLabel}</span><span className="rounded-full bg-orange-50 px-2 py-0.5 text-xs font-semibold text-orange-800">{finding.riskLabel} risk</span></div><p className="mt-2 text-sm leading-6 text-[#385273]">{finding.complianceSummary}</p>{finding.comments && <p className="mt-2 border-l-2 border-[#d6aa45] pl-3 text-sm italic leading-6 text-[#4b5f7a]">{finding.comments}</p>}<div className="mt-4 grid gap-3 sm:grid-cols-2"><ReportSection title="Recommendation" value={finding.recommendation} empty="No recommendation recorded." compact /><ReportSection title="Corrective action" value={finding.correctiveAction} empty="No corrective action recorded." compact /></div></article>) : <p className="rounded-lg bg-[#edf8f0] px-4 py-3 text-sm text-[#16803a]">No High- or Extreme-risk priority findings were recorded.</p>}</div>
      </section>
      <div className="mt-6 flex justify-end print:hidden"><button type="button" onClick={() => window.print()} className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#0d6531]">Print / Save PDF</button></div>
    </div>}
  </FormModal>;
}

function SurveyorHandoverPrint({ review }) {
  if (!review?.findings) return null;
  const { report, findings } = review;
  return <article className="surveyor-handover-print hidden print:block">
    <header><p>PNG National Health Service Standards</p><h1>Surveyor Handover Report</h1><p className="surveyor-handover-print-subtitle">Submitted by {report.surveyorName} on {new Date(report.submittedAt).toLocaleString()}</p></header>
    <PrintSection title="Overall summary" value={report.summary} />
    <PrintSection title="Priority findings summary" value={report.priorityFindings} empty="Priority findings are detailed below." />
    <PrintSection title="Good practices observed" value={report.goodPractices} empty="No good practices were recorded." />
    <PrintSection title="Not applicable notes" value={report.notApplicableNotes} empty="No not-applicable notes were recorded." />
    <section><h2>Priority findings, recommendations and corrective actions</h2>{findings.length ? <table><thead><tr><th>Requirement</th><th>Finding</th><th>Outcome / risk</th><th>Recommendation</th><th>Corrective action</th></tr></thead><tbody>{findings.map((finding) => <tr key={finding.complianceAssessmentId}><td>{finding.complianceNumber}</td><td><strong>{finding.complianceSummary}</strong>{finding.comments && <p>{finding.comments}</p>}</td><td>{finding.scoreLabel}<br />{finding.riskLabel} risk</td><td>{finding.recommendation || "Not recorded."}</td><td>{finding.correctiveAction || "Not recorded."}</td></tr>)}</tbody></table> : <p>No High- or Extreme-risk priority findings were recorded.</p>}</section>
    <footer>Generated from the accreditation survey toolkit on {new Date().toLocaleDateString()}.</footer>
  </article>;
}

function PrintSection({ title, value, empty = "Not recorded." }) {
  return <section><h2>{title}</h2><p>{value || empty}</p></section>;
}

function ReportSection({ title, value, empty = "Not recorded.", compact = false }) {
  return <section className={compact ? "rounded-lg border border-[#dbe5ef] bg-white p-3" : "mt-6 rounded-xl border border-[#dbe5ef] bg-[#f8fafc] p-4"}><h3 className="text-sm font-bold text-[#092a5a]">{title}</h3><p className="mt-2 whitespace-pre-wrap text-sm leading-6 text-[#4b5f7a]">{value || empty}</p></section>;
}
