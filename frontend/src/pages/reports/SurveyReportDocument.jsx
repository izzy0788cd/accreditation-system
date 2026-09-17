import { ExecutiveSummary, Recommendations, ReportContents } from "./ReportSections";
import ReportDetails from "./ReportDetails";
import { assessmentStatus, summariseReport, compareScope, detailItems } from "../../utils/surveyReports";
const percentage = (value) => value == null ? "Not scored" : `${value}%`;
function Summary({ items }) {
  const stats = summariseReport(items);
  const categories = [
    ["Full achievement", "#16803a"], ["Good achievement", "#0079b8"],
    ["Fair achievement", "#bc861e"], ["Poor achievement", "#b34b44"],
    ["Unassessed", "#87979d"], ["Not applicable", "#d5dfdf"],
  ].map(([label, color]) => ({ label, color, count: items.filter((item) => assessmentStatus(item) === label).length }));
  let offset = 0;
  const segments = categories.map((category) => {
    const length = items.length ? category.count / items.length * 100 : 0;
    const segment = { ...category, length, offset };
    offset += length;
    return segment;
  });
  return <><div className="report-metrics">{[["Requirements", stats.total], ["Scored", stats.scored], ["Unassessed", stats.unassessed], ["Not applicable", stats.notApplicable], ["Score", percentage(stats.score)]].map(([label, value]) => <div key={label}><span>{label}</span><strong>{value}</strong></div>)}</div>
    <div className="report-chart-summary"><figure className="report-donut"><svg viewBox="0 0 140 140" role="img" aria-label={`Assessment distribution: ${categories.map((c) => `${c.label} ${c.count}`).join(", ")}`}><circle cx="70" cy="70" r="52" fill="none" stroke="#edf1f0" strokeWidth="17" />{segments.filter((c) => c.count).map((c) => <circle key={c.label} cx="70" cy="70" r="52" fill="none" stroke={c.color} strokeWidth="17" pathLength="100" strokeDasharray={`${c.length} ${100-c.length}`} strokeDashoffset={-c.offset} transform="rotate(-90 70 70)" />)}<text x="70" y="69" textAnchor="middle" className="report-chart-total">{stats.total}</text><text x="70" y="86" textAnchor="middle" className="report-chart-caption">requirements</text></svg><figcaption>Assessment distribution</figcaption></figure><div className="report-chart-legend">{categories.map((c) => <div key={c.label}><span className="report-chart-swatch" style={{ backgroundColor: c.color }} /><span>{c.label}</span><strong>{c.count}</strong><span>{items.length ? Math.round(c.count / items.length * 100) : 0}%</span></div>)}<p>Distribution covers all selected requirements. Score excludes unassessed and not-applicable items.</p></div></div></>;

}

export default function SurveyReportDocument({ report: source }) {
  const numericSort = (a,b) => String(a).localeCompare(String(b), undefined, { numeric: true });
  const report = { ...source, standards: [...source.standards].sort((a,b) => numericSort(a.number,b.number)), items: [...source.items].sort((a,b) => numericSort(a.complianceNumber,b.complianceNumber)) };
  const shownItems = detailItems(report);
  const detailStandards = report.standards.filter((standard) => shownItems.some((item) => item.standardId === standard.id));
  const runningTitle = `${report.survey.facilityName} · ${report.survey.surveyType} survey #${report.survey.surveyId}`;
  const cssString = (text) => JSON.stringify(text).replace(/</g, "\\3c ");

    return <article className="survey-report" aria-label="Generated survey report">
      <style>{`@media print { @page { margin: 20mm 16mm; @top-left { content: ${cssString(runningTitle)}; font-size: 8pt; color: #526a6b; } @bottom-left { content: ${cssString(report.savedVersion ? `Saved version ${report.savedVersion.versionNumber}` : "Draft report")}; font-size: 8pt; } @bottom-right { content: "Page " counter(page) " of " counter(pages); font-size: 8pt; } } }`}</style>
      <header className="report-cover"><div className="report-masthead"><span>Health facility accreditation</span><span>Survey #{report.survey.surveyId}</span></div><p className="report-eyebrow">{report.survey.surveyType} assessment report</p><h1>{report.survey.facilityName}</h1><p className="report-subtitle">{report.mode === "findings" ? "Findings-only report" : "Survey findings and evidence review"}</p><p className="report-version-status">{report.savedVersion ? `Saved version ${report.savedVersion.versionNumber} · ${new Date(report.savedVersion.createdAt).toLocaleString()} · ${report.savedVersion.createdBy}` : "Draft preview — not saved"}</p><dl className="report-metadata"><div><dt>Assessment period</dt><dd>{report.survey.startDate} — {report.survey.endDate}</dd></div><div><dt>Surveyors</dt><dd>{[...new Set(report.items.filter((item) => item.scoreId != null || item.complianceComments).map((item) => item.surveyorName))].join(", ") || "No assessments recorded"}</dd></div><div><dt>Team lead</dt><dd>{report.survey.teamLead}</dd></div><div><dt>Report scope</dt><dd>Standards {report.standards.map((standard) => standard.number).join(", ")}</dd></div><div><dt>Generated</dt><dd>{new Date(report.generatedAt).toLocaleString()}</dd></div></dl></header>
      {summariseReport([...report.items, ...(report.internalItems || []).filter((item) => report.items.some((current) => current.complianceId === item.complianceId))]).dummy && <p className="report-warning"><strong>DUMMY SURVEY — not actual findings.</strong> This report contains synthetic test results.</p>}
      {report.survey.isCancelled && <p className="report-warning">Cancelled survey: {report.survey.cancellationReason || "No reason recorded"}</p>}
      {report.survey.surveyType === "External" && <p className="report-method">{report.internalSurvey ? `Internal comparison: survey #${report.internalSurvey.surveyId}, ${report.internalSurvey.startDate} to ${report.internalSurvey.endDate}. Surveyors: ${[...new Set((report.internalItems || []).filter((item) => report.items.some((current) => current.complianceId === item.complianceId) && (item.scoreId != null || item.complianceComments)).map((item) => item.surveyorName))].join(", ") || "No assessments recorded"}. Latest non-cancelled internal survey starting on or before this external survey.` : "No eligible internal survey is available for comparison."}</p>}
      <p className="report-method">Scores use assessed, applicable requirements only (maximum 4 points each). Unassessed and not-applicable items are excluded from the score; incomplete results are provisional. This report is not an accreditation decision. Evidence checks represent recorded selections, not independent verification. Framework wording and applicability reflect records at generation time; saved versions preserve that content.</p>
      {report.included.includes("summary") && <><ExecutiveSummary report={report} /><section><h2>Assessment distribution</h2><Summary items={report.items} /></section></>}
      <ReportContents report={report} standards={detailStandards} />
      {report.mode === "findings" && <p className="report-notice">Findings-only detail: {shownItems.length} of {report.items.length} requirements. Summaries and scores cover the full selected scope. Only poor-achievement, fair-achievement, and high/extreme-risk requirements appear below.</p>}
      {report.included.includes("standards") && <section id="report-standard-scores"><h2>Scores by standard</h2><table><thead><tr><th>Standard</th><th>Scored</th><th>Unassessed</th><th>N/A</th><th>Score</th>{report.survey.surveyType === "External" && <th>External − internal</th>}</tr></thead><tbody>{report.standards.map((s) => { const stats = summariseReport(report.items.filter((item) => item.standardId === s.id)); const comparison = compareScope(report.items.filter((item) => item.standardId === s.id), report.internalItems || []); return <tr key={s.id}><td>{s.number} · {s.title}</td><td>{stats.scored}</td><td>{stats.unassessed}</td><td>{stats.notApplicable}</td><td>{percentage(stats.score)}</td>{report.survey.surveyType === "External" && <td>{comparison.delta == null ? "Not comparable" : `${comparison.delta > 0 ? "+" : ""}${comparison.delta} pp (${comparison.compared} matched)`}</td>}</tr>; })}</tbody></table></section>}
      {(report.included.includes("findings") || report.included.includes("evidence")) && <ReportDetails report={{ ...report, items: shownItems, standards: detailStandards }} />}
      {report.mode === "findings" && !shownItems.length && <p>No findings match this report filter.</p>}
      {report.included.includes("actions") && <Recommendations report={report} />}
      <footer className="report-footer"><span>{report.survey.facilityName} · {report.survey.surveyType} survey</span><span>End of selected report · #{report.survey.surveyId}</span></footer>
    </article>;
}
