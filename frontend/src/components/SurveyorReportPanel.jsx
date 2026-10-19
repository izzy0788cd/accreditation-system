import StandardSummationReports from "./StandardSummationReports";
import { useEffect, useState } from "react";
import { getAll, getSurveyorReportReview, getSurveyorReports, reopenSurveyorReport } from "../api/api";
import FormModal from "./FormModal";

// Team review now uses saved standard summations; legacy handovers are read-only history.
export default function SurveyorReportPanel({ surveyId }) {
  const [summaries, setSummaries] = useState([]);
  const [reports, setReports] = useState([]);
  const [review, setReview] = useState(null);
  const [error, setError] = useState("");
  useEffect(() => {
    let active = true;
    setSummaries([]); setReports([]); setReview(null); setError("");
    Promise.all([getAll(`surveyor-reports/survey/${surveyId}/standard-summaries`), getSurveyorReports(surveyId)])
      .then(([summations, history]) => { if (active) { setSummaries(summations.data); setReports(history.data); } })
      .catch(() => { if (active) setError("We couldn't load the standard summations. Reload to retry."); });
    return () => { active = false; };
  }, [surveyId]);
  const reopen = async report => {
    const reason = window.prompt("Reason for reopening this surveyor’s submitted summations:");
    if (!reason?.trim()) return;
    try { await reopenSurveyorReport(report.surveyorReportId, reason.trim()); const response = await getSurveyorReports(surveyId); setReports(response.data); }
    catch (err) { setError(typeof err.response?.data === "string" ? err.response.data : "Could not reopen the handover."); }
  };
  const viewReport = async report => {
    try { const response = await getSurveyorReportReview(report.surveyorReportId); setReview(response.data); }
    catch { setError("We couldn't load the historical report."); }
  };
  return <>
    {error && <p role="alert">{error}</p>}
    <StandardSummationReports summaries={summaries} />
    {!!reports.length && <details className="mt-6 rounded-lg border p-4"><summary>Surveyor handovers</summary>
      <p className="mt-2">Submitted standard summations are locked. Reopen with a reason if corrections are needed.</p>
      {reports.map(report => <section key={report.surveyorReportId} className="mt-4"><h3 className="font-bold">{report.surveyorName} · {report.isSubmitted ? "Submitted" : "Not submitted / reopened"}</h3>
        <p className="whitespace-pre-wrap">{report.summary || "Standard summations submitted together; no overall summary required."}</p>
        {report.isSubmitted && <div className="flex gap-4"><button type="button" className="underline" onClick={() => viewReport(report)}>View / print</button><button type="button" className="underline" onClick={() => reopen(report)}>Reopen handover</button></div>}
      </section>)}
    </details>}
    <SurveyorReportReviewModal review={review} onClose={() => setReview(null)} />
    <SurveyorHandoverPrint review={review} />
  </>;
}

function SurveyorReportReviewModal({ review, onClose }) {
  const report = review?.report;
  return <FormModal open={!!review} onClose={onClose} wide>
    {!review?.findings ? <div className="py-12 text-center text-sm text-[#4b5f7a]">Loading submitted report…</div> : <div>
      <p className="text-xs font-bold uppercase tracking-[.14em] text-[#16803a]">Surveyor handover</p>
      <h2 className="mt-1 text-2xl font-bold text-[#092a5a]">{report.surveyorName}’s submitted report</h2>
        <p className="mt-2 text-sm text-[#68778c]">Submitted {new Date(report.submittedAt).toLocaleString()}</p>
        <ReportSection title="Overall summary" value={report.summary} />
        <StandardSummarySections summaries={review.standardSummaries} />
        <ReportSection title="Priority findings summary" value={report.priorityFindings} empty="Priority findings are listed below." />
      <ReportSection title="Additional overall commendations" value={report.goodPractices} empty="No additional overall commendations were recorded." />
      <ReportSection title="Overall not applicable / scope notes" value={report.notApplicableNotes} empty="No not-applicable notes were recorded." />
      <section className="mt-6">
        <p className="text-xs font-bold uppercase tracking-[.14em] text-[#9a5b13]">Priority findings</p>
        <h3 className="mt-1 text-lg font-bold text-[#092a5a]">Recommendations</h3>
        <div className="mt-4 space-y-3">{review.findings.length ? review.findings.map((finding) => <article key={finding.complianceAssessmentId} className="rounded-lg border border-[#ead7a3] bg-[#fffbf0] p-4"><div className="flex flex-wrap gap-2"><strong className="text-[#092a5a]">{finding.complianceNumber}</strong><span className="rounded-full bg-red-50 px-2 py-0.5 text-xs font-semibold text-red-700">{finding.scoreLabel}</span><span className="rounded-full bg-orange-50 px-2 py-0.5 text-xs font-semibold text-orange-800">{finding.riskLabel} risk</span></div><p className="mt-2 text-sm leading-6 text-[#385273]">{finding.complianceSummary}</p><ReportSection title="Recommendation(s)" value={finding.comments} empty="No recommendation was recorded while scoring this requirement." compact /></article>) : <p className="rounded-lg bg-[#edf8f0] px-4 py-3 text-sm text-[#16803a]">No High- or Extreme-risk priority findings were recorded.</p>}</div>
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
      <StandardSummaryPrint summaries={review.standardSummaries} />
      <PrintSection title="Additional overall commendations" value={report.goodPractices} empty="No additional overall commendations were recorded." />
    <PrintSection title="Overall not applicable / scope notes" value={report.notApplicableNotes} empty="No not-applicable notes were recorded." />
    <section><h2>Priority findings and recommendations</h2>{findings.length ? <table><thead><tr><th>Requirement</th><th>Finding</th><th>Outcome / risk</th><th>Recommendation(s)</th></tr></thead><tbody>{findings.map((finding) => <tr key={finding.complianceAssessmentId}><td>{finding.complianceNumber}</td><td><strong>{finding.complianceSummary}</strong></td><td>{finding.scoreLabel}<br />{finding.riskLabel} risk</td><td>{finding.comments || "No recommendation recorded."}</td></tr>)}</tbody></table> : <p>No High- or Extreme-risk priority findings were recorded.</p>}</section>
    <footer>Generated from the accreditation survey toolkit on {new Date().toLocaleDateString()}.</footer>
  </article>;
}

function PrintSection({ title, value, empty = "Not recorded." }) {
  return <section><h2>{title}</h2><p>{value || empty}</p></section>;
}

function StandardSummarySections({ summaries = [] }) { return <StandardSummationReports summaries={summaries} />; }

function StandardSummaryPrint({ summaries = [] }) { return <StandardSummationReports summaries={summaries} print />; }

function ReportSection({ title, value, empty = "Not recorded.", compact = false }) {
  return <section className={compact ? "rounded-lg border border-[#dbe5ef] bg-white p-3" : "mt-6 rounded-xl border border-[#dbe5ef] bg-[#f8fafc] p-4"}><h3 className="text-sm font-bold text-[#092a5a]">{title}</h3><p className="mt-2 whitespace-pre-wrap text-sm leading-6 text-[#4b5f7a]">{value || empty}</p></section>;
}
