export default function ReportSignOffEditor({ reviewerName, onReviewer, reviewNotes, onNotes }) {
  return <section className="report-card report-signoff-editor"><h2>Sign-off</h2><p>Record the reviewer details for this report. This prepares the signature section only; it does not record approval.</p><label>Reviewer name<input maxLength={200} value={reviewerName} onChange={(event) => onReviewer(event.target.value)} /></label><label>Review notes<textarea maxLength={10000} value={reviewNotes} onChange={(event) => onNotes(event.target.value)} /></label></section>;
}
