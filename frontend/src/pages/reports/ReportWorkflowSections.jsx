export const conclusionFields = {
  overview: "Overall conclusion",
  commendations: "Commendations",
  concerns: "Areas of concern",
  recommendations: "Opportunities for improvement / recommendations",
  limitations: "Scope limitations / qualifications",
};

export function ReportConclusion({ conclusion }) {
  if (!conclusion || !Object.values(conclusion).some(value => value?.trim())) return null;
  return <section id="report-conclusion"><h2>Team Lead consolidated narrative</h2>
    {Object.entries(conclusionFields).filter(([key]) => conclusion[key]?.trim()).map(([key, label]) => <div key={key}><h3>{label}</h3><p className="report-text">{conclusion[key]}</p></div>)}
  </section>;
}

export function SummationReadiness({ statuses }) {
  if (!statuses?.length) return <p className="report-warning">Summation readiness is unavailable for this report. No completion claim can be made.</p>;
  const sorted = [...statuses].sort((a, b) => String(a.standardNumber).localeCompare(String(b.standardNumber), undefined, { numeric: true }) || a.surveyorName.localeCompare(b.surveyorName));
  const complete = sorted.filter(status => status.saved && status.submitted).length;
  return <section id="report-readiness" className="report-readiness"><h2>Standard summation readiness</h2>
    <p>{complete} of {sorted.length} assigned standard / surveyor pairs have a saved summation and submitted handover. No extra overall narrative is required.</p>
    <ul>{sorted.map(status => <li key={status.standardId + "-" + status.surveyorId}><strong>Standard {status.standardNumber}</strong> · {status.surveyorName} — {!status.saved ? "Summation missing" : status.submitted ? "Submitted" : "Saved — awaiting submission"}</li>)}</ul>
  </section>;
}
