import StandardSummationContent from "./StandardSummationContent";
import { Link } from "react-router-dom";

// Keep the surveyor's handover, team review and printed copies in the same order.
export default function StandardSummationReports({ summaries = [], print = false, summaryPath }) {
  const ordered = [...summaries].sort((a, b) => String(a.standardNumber).localeCompare(String(b.standardNumber), undefined, { numeric: true }));
  return <section className={print ? undefined : "mt-6 rounded-xl border border-[#bfded8] bg-[#f3faf8] p-5 shadow-sm"}>
    <h2 className={print ? undefined : "text-lg font-bold text-[#092a5a]"}>Standard summation reports</h2>
    <p className={print ? undefined : "mt-2 text-sm leading-6 text-[#4b5f7a]"}>Included from the saved standard reports: services assessed, commendations, areas of concern, opportunities for improvement and recommendations, service-area details and scope notes.</p>
    {!ordered.length && <p className="mt-3 text-sm">No standard summation reports have been saved yet.</p>}
    <div className={print ? undefined : "mt-4 space-y-4"}>{ordered.map((summary) => <div key={summary.surveyorStandardSummaryId} className={print ? undefined : "rounded-lg border border-[#cde4dc] bg-white p-4"}>
      <h3 className={print ? undefined : "font-semibold text-[#092a5a]"}>Standard {summary.standardNumber}: {summary.standardTitle}</h3>
      {summary.surveyorName && <p className="mt-1 text-sm">Surveyor: {summary.surveyorName}</p>}
      {!print && summaryPath && <Link to={summaryPath(summary.standardId)} aria-label={`Open standard ${summary.standardNumber} summation`} className="mt-3 inline-flex rounded-lg border border-[#bfded8] px-3 py-2 text-sm font-semibold text-[#16803a] hover:underline focus-visible:outline-2 focus-visible:outline-offset-2 print:hidden">Open standard summation →</Link>}
      <StandardSummationContent summary={summary} />
    </div>)}</div>
  </section>;
}
