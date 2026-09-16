import { useEffect, useState } from "react";
import { getSurveyorReports, reopenSurveyorReport, saveMySurveyorReport } from "../api/api";
import ConfirmDialog from "./ConfirmDialog";

const emptyReport = { summary: "", priorityFindings: "", recommendations: "", goodPractices: "", notApplicableNotes: "" };

export default function SurveyorReportPanel({ surveyId, complete, teamView = false }) {
  const [reports, setReports] = useState([]);
  const [form, setForm] = useState(emptyReport);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [reopenTarget, setReopenTarget] = useState(null);
  const [reopenReason, setReopenReason] = useState("");
  const [reopening, setReopening] = useState(false);
  const [error, setError] = useState("");
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
  if (loading) return <section className="mt-6 h-44 animate-pulse rounded-xl bg-slate-100" />;
  if (teamView) return <><section className="mt-6 overflow-hidden rounded-xl border border-[#dbe5ef] bg-white shadow-sm"><div className="border-b border-[#dbe5ef] px-5 py-4"><p className="text-xs font-bold uppercase tracking-[.14em] text-[#16803a]">Surveyor handover</p><h2 className="mt-1 font-bold text-[#092a5a]">Submitted surveyor reports</h2><p className="mt-1 text-sm text-[#68778c]">Review individual findings before preparing the consolidated report.</p></div>{error && <p className="m-4 rounded-lg bg-red-50 px-3 py-2 text-sm text-red-800">{error}</p>}{reports.length ? <div className="divide-y divide-[#e7edf4]">{reports.map((report) => <article key={report.surveyorReportId} className="p-5"><div className="flex flex-wrap items-center justify-between gap-2"><h3 className="font-semibold text-[#092a5a]">{report.surveyorName}</h3><span className={`rounded-full px-2.5 py-1 text-xs font-semibold ${report.isSubmitted ? "bg-[#edf8f0] text-[#16803a]" : "bg-amber-50 text-amber-800"}`}>{report.isSubmitted ? "Submitted" : "Draft"}</span></div><p className="mt-2 text-sm leading-6 text-[#4b5f7a]">{report.summary || "No overall summary recorded yet."}</p>{report.isSubmitted && <div className="mt-3 flex flex-wrap items-center justify-between gap-3"><p className="text-xs text-[#68778c]">Submitted {new Date(report.submittedAt).toLocaleString()}</p><button onClick={() => { setReopenTarget(report); setReopenReason(""); }} className="rounded-lg border border-amber-300 bg-amber-50 px-3 py-2 text-xs font-semibold text-amber-900 hover:bg-amber-100">Reopen handover</button></div>}</article>)}</div> : <p className="p-5 text-sm text-[#68778c]">No surveyor reports have been started yet.</p>}</section><ConfirmDialog open={!!reopenTarget} title="Reopen this surveyor report?" message="This unlocks the surveyor’s assigned scores, risk ratings, comments, and evidence checks. Your reason will be recorded in the handover audit history." confirmLabel={reopening ? "Reopening…" : "Reopen report"} confirmDisabled={reopening || !reopenReason.trim()} onCancel={() => !reopening && setReopenTarget(null)} onConfirm={reopen}><label className="mt-4 block text-sm font-semibold text-[#092a5a]">Reason for reopening<textarea autoFocus required value={reopenReason} onChange={(event) => setReopenReason(event.target.value)} rows="4" className="mt-1.5 w-full resize-none rounded-lg border border-[#c5d4e6] px-3 py-2.5 text-sm font-normal leading-6" placeholder="Describe the correction or review required." /></label></ConfirmDialog></>;
  const submitted = reports[0]?.isSubmitted;
  const set = (key, value) => setForm((current) => ({ ...current, [key]: value }));
  return <section className="mt-6 overflow-hidden rounded-xl border border-[#bfded8] bg-white shadow-sm"><div className="border-b border-[#b8d9d3] bg-[#f3faf8] px-5 py-4"><p className="text-xs font-bold uppercase tracking-[.14em] text-[#16803a]">Surveyor handover</p><h2 className="mt-1 font-bold text-[#092a5a]">My surveyor report</h2><p className="mt-1 text-sm text-[#4b5f7a]">Save observations as a draft while you work. Submit one report after every assigned requirement has been scored.</p></div>{error && <p role="alert" className="m-4 rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-800">{error}</p>}{submitted ? <div className="p-5 text-sm text-[#16803a]"><p className="font-semibold">Your report was submitted.</p><p className="mt-1 text-[#4b5f7a]">The team lead can now use it when compiling the consolidated report.</p></div> : <div className="p-5"><div className="grid gap-4"><Field label="Overall summary" value={form.summary} onChange={(value) => set("summary", value)} required /><Field label="Priority findings" hint="Highlight non-compliant or partially compliant findings with High or Extreme risk." value={form.priorityFindings} onChange={(value) => set("priorityFindings", value)} /><Field label="Recommendations and corrective actions" value={form.recommendations} onChange={(value) => set("recommendations", value)} /><Field label="Good practices observed" value={form.goodPractices} onChange={(value) => set("goodPractices", value)} /><Field label="Not applicable notes" hint="Explain requirements that were not applicable to this facility or service." value={form.notApplicableNotes} onChange={(value) => set("notApplicableNotes", value)} /></div><div className="mt-5 flex flex-wrap items-center justify-end gap-3"><button type="button" disabled={saving} onClick={() => save(false)} className="rounded-lg border border-[#c5d5e8] px-4 py-2.5 text-sm font-semibold text-[#16803a] disabled:opacity-60">Save draft</button><button type="button" disabled={saving || !complete} onClick={() => save(true)} className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white disabled:cursor-not-allowed disabled:opacity-50">{saving ? "Saving…" : "Submit report"}</button></div>{!complete && <p className="mt-3 text-right text-xs text-amber-800">Score all assigned requirements to submit your report.</p>}</div>}</section>;
}

function Field({ label, hint, value, onChange, required }) {
  return <label className="block text-sm font-semibold text-[#092a5a]">{label}{required && <span className="ml-1 text-red-700">*</span>}{hint && <span className="mt-1 block text-xs font-normal leading-5 text-[#68778c]">{hint}</span>}<textarea value={value || ""} onChange={(event) => onChange(event.target.value)} rows="4" className="mt-1.5 h-28 w-full resize-none rounded-lg border border-[#c5d4e6] px-3 py-2.5 text-sm font-normal leading-6 text-[#092a5a] outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]" /></label>;
}
