import StandardSummationReports from "../../components/StandardSummationReports";
import { componentStandardIds } from "../../utils/reportScope.js";
import SurveyReportDocument from "./SurveyReportDocument";
import ReportSignOffEditor from "./ReportSignOffEditor";
import { Link, useSearchParams } from "react-router-dom";
import { useEffect, useState } from "react";
import { getReportSurveys, getSurveyReport, getReportVersions, getReportVersion, saveReportVersion } from "../../api/api";
import "./surveyReports.css";
import "./reportWorkflow.css";
import useUnsavedChanges from "../../hooks/useUnsavedChanges";
import { reportReadiness } from "../../utils/surveyReports";
import { SummationReadiness } from "./ReportWorkflowSections";
import { compareReferenceNumber } from "../../utils/numberSort";

const sections = { summary: "Survey summary", standards: "Scores by standard", findings: "Findings, risks and comments", evidence: "Evidence checklist", signoff: "Sign-off" };
const sortNumber = compareReferenceNumber;
const surveyTypeClass = (type) => String(type).toLowerCase() === "external"
  ? "report-survey-type report-survey-type-external"
  : "report-survey-type report-survey-type-internal";

export default function SurveyReportsPage() {
  const [searchParams, setSearchParams] = useSearchParams();
  const [surveys, setSurveys] = useState([]);
  const [type, setType] = useState(() => searchParams.get("type") || localStorage.getItem("report-survey-type") || "");
  const [surveyId, setSurveyId] = useState(() => searchParams.get("survey") || "");
  const [data, setData] = useState(null);
  const [selected, setSelected] = useState([]);
  const [component, setComponent] = useState(() => searchParams.get("component") || "");
  const [included, setIncluded] = useState(["summary", "standards", "findings", "signoff"]);
  const [preview, setPreview] = useState(null);
  const [loading, setLoading] = useState(true);
  const [mode, setMode] = useState("full");
  const [reviewerName, setReviewerName] = useState("");
  const [reviewNotes, setReviewNotes] = useState("");
  const [versions, setVersions] = useState([]);
  const [busy, setBusy] = useState(false);
  const [notice, setNotice] = useState("");
  const [error, setError] = useState("");
  const [dirty, setDirty] = useState(false);
  useUnsavedChanges(dirty);
  const confirmDiscard = () => !dirty || window.confirm("You have unsaved report notes. Discard them?");
  useEffect(() => {
    let active = true;
    getReportSurveys().then(({ data: rows }) => { if (active) setSurveys(rows); })
      .catch(() => { if (active) setError("Could not load surveys. Check your connection and reporting access."); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, []);
  useEffect(() => { localStorage.setItem("report-survey-type", type); }, [type]);
  useEffect(() => {
    const next = new URLSearchParams();
    if (type) next.set("type", type);
    if (surveyId) next.set("survey", surveyId);
    if (component) next.set("component", component);
    setSearchParams(next, { replace: true });
  }, [type, surveyId, component, setSearchParams]);
  useEffect(() => {
    if (!surveyId) return;
    let active = true;
    Promise.all([getSurveyReport(surveyId), getReportVersions(surveyId)]).then(([{ data: report }, { data: saved }]) => {
      if (!active) return;
      setData(report);
      setVersions(saved);
      setSelected(componentStandardIds(report.items, component));
    }).catch(() => { if (active) setError("Could not load this survey report. Please select the survey again to retry."); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, [surveyId]);
  const standards = [...new Map((data?.items || []).map((item) => [item.standardId, { id: item.standardId, number: item.standardNumber, title: item.standardTitle }])).values()].sort((a, b) => sortNumber(a.number, b.number));
  const visibleStandards = standards.filter(s => componentStandardIds(data?.items || [], component).includes(s.id));
  const chooseComponent = value => { setComponent(value); setSelected(componentStandardIds(data?.items || [], value)); setPreview(null); };
  const availableSurveys = surveys.filter((survey) => !type || survey.surveyType === type);
  const selectedSurvey = surveys.find((survey) => String(survey.surveyId) === String(surveyId));
  const selectSurvey = (id) => { if (!confirmDiscard()) return false; setSurveyId(id); setData(null); setPreview(null); setSelected([]); setVersions([]); setReviewerName(""); setReviewNotes(""); setDirty(false); setNotice(""); setError(""); setLoading(Boolean(id)); return true; };
  const readiness = data ? reportReadiness(data, selected, included, mode) : [];
  const refresh = async () => {
    setBusy(true); setError("");
    try {
      const { data: latest } = await getSurveyReport(surveyId);
      setData(latest); setPreview(null);
      setSelected(ids => ids.filter(id => latest.items.some(item => item.standardId === id)));
      setNotice("Survey data refreshed. Your report notes were kept. Generate and review a new preview.");
    } catch { setError("Could not refresh survey data. Your notes have been kept."); }
    finally { setBusy(false); }
  };
  const toggle = (set, current, value) => { set(current.includes(value) ? current.filter((item) => item !== value) : [...current, value]); setPreview(null); };
  const generate = () => {
    const items = data.items.filter((item) => selected.includes(item.standardId)).sort((a, b) => sortNumber(a.complianceNumber, b.complianceNumber));
    setPreview({ ...data, items, included: [...included], mode, reviewerName, reviewNotes, summationStatus: data.summationStatus?.filter(s => selected.includes(s.standardId)), standards: standards.filter((s) => selected.includes(s.id)) });
  };
  const save = async (approve = false) => {
    if (data?.workflowVersion !== 2) { setError("Reload after the updated reporting backend has restarted. Your notes have not been sent."); return; }
    if (approve && !window.confirm("Approve this full report for issue? This records your signed-in identity and time in a new read-only version. It is not an accreditation decision.")) return;
    setBusy(true); setError(""); setNotice("");
    try {
      const { data: saved } = await saveReportVersion(surveyId, {
        standardIds: preview.standards.map((s) => s.id), included: preview.included,
        mode: preview.mode, reviewerName: preview.reviewerName, reviewNotes: preview.reviewNotes,
        approve, sourceRevision: preview.sourceRevision,
      });
      setPreview(saved);
      setDirty(false);
      setNotice(approve && saved.approval ? "Report approved and saved as a new read-only version." : "Draft version saved. Source results were refreshed at save time. This is not an approval.");
      try { const { data: list } = await getReportVersions(surveyId); setVersions(list); }
      catch { setError("The report was saved, but the version list could not refresh. Do not save again just to refresh the list."); }
    } catch (failure) { setError(typeof failure.response?.data === "string" ? failure.response.data : "Report version could not be saved. Please retry."); }
    finally { setBusy(false); }
  };
  const openVersion = async (versionId) => {
    if (!confirmDiscard()) return;
    setBusy(true); setError(""); setNotice("");
    try {
      const { data: saved } = await getReportVersion(surveyId, versionId);
      saved.standards.sort((a,b) => sortNumber(a.number,b.number));
      saved.items.sort((a,b) => sortNumber(a.complianceNumber,b.complianceNumber));
      setReviewerName(saved.reviewerName || ""); setReviewNotes(saved.reviewNotes || ""); setDirty(false);
      setComponent("");
      setSelected(saved.standards.map(s => s.id)); setIncluded(saved.included); setMode(saved.mode);
      setPreview(saved);
    } catch { setError("Saved report could not be loaded. Please retry."); }
    finally { setBusy(false); }
  };
  return <main className="reports-page">
    <fieldset className="report-controls report-control-fieldset" disabled={busy}>
      <header><p className="report-eyebrow">Reports centre</p><div className="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between"><div><h1>Build a survey report</h1><p>Choose a survey, select standards and decide what to include.</p></div><Link to="/reports" className="print:hidden shrink-0 rounded-lg border border-[#c5d5e8] bg-white px-4 py-2.5 text-center text-sm font-semibold text-[#16803a] hover:bg-[#edf8f0]">Reports Centre</Link></div></header>
      {error && <p role="alert" className="report-warning">{error}</p>}{notice && <p role="status" className="report-notice">{notice}</p>}
      <div className="report-settings">
        <section className="report-card"><h2>1. Choose a survey</h2>
          <label>Survey type<select value={type} onChange={(event) => { if (selectSurvey("")) setType(event.target.value); }}><option value="">All types</option>{[...new Set(surveys.map((s) => s.surveyType))].map((name) => <option key={name}>{name}</option>)}</select></label>
          <label>Survey<select value={surveyId} onChange={(event) => selectSurvey(event.target.value)}><option value="">Select a survey</option>{availableSurveys.map((s) => <option key={s.surveyId} value={s.surveyId}>{String(s.surveyType).toUpperCase()} · {s.facilityName} · {s.startDate} · #{s.surveyId}{s.isCancelled ? " (cancelled)" : ""}</option>)}</select></label>
          {selectedSurvey && <div className="report-scope-summary" aria-label="Selected report scope"><span className={surveyTypeClass(selectedSurvey.surveyType)}>{selectedSurvey.surveyType}</span><div><strong>{selectedSurvey.facilityName}</strong><span>Survey #{selectedSurvey.surveyId} · {selectedSurvey.startDate}{selectedSurvey.endDate ? ` — ${selectedSurvey.endDate}` : ""}</span></div></div>}
          {!selectedSurvey && availableSurveys.length > 0 && <div className="report-available-surveys" aria-label="Available surveys"><p>Available surveys</p><div>{availableSurveys.map((survey) => <button type="button" key={survey.surveyId} onClick={() => selectSurvey(String(survey.surveyId))}><span className={surveyTypeClass(survey.surveyType)}>{survey.surveyType}</span><span>{survey.facilityName} · #{survey.surveyId}</span></button>)}</div></div>}
          {loading && <p role="status">Loading…</p>}
          {!loading && !surveys.length && !error && <p>No surveys are available yet.</p>}
          {data && !data.items.length && <p>This survey has no assessment items.</p>}
        </section>
        <section className="report-card"><label>Report detail<select value={mode} onChange={(e) => { setMode(e.target.value); setPreview(null); }}><option value="full">Full report</option><option value="findings">Findings only — gaps and high/extreme risks</option></select></label><h2>2. Select report sections</h2>{Object.entries(sections).map(([key, label]) => <label className="report-option" key={key}><input type="checkbox" checked={included.includes(key)} onChange={() => toggle(setIncluded, included, key)} />{label}</label>)}</section>
      </div>
      {data && standards.length > 0 && <section className="report-card"><h2>3. Select standards <small>({selected.length} of {standards.length})</small></h2><label>Component<select value={component} onChange={e => chooseComponent(e.target.value)}><option value="">All components</option>{[[1, "Leadership and Governance"], [2, "Human Resource"], [3, "Information Technology (IT)"], [4, "Environment"], [5, "Public Health"], [6, "Essential Clinical Care"]].map(([number, name]) => <option key={number} value={String(number)}>{number} — {name}</option>)}</select></label><p>Changing component selects only its standards for this report. Component extracts can be saved as drafts; approval still requires the full survey.</p><div className="report-actions"><button onClick={() => { setSelected(visibleStandards.map((s) => s.id)); setPreview(null); }}>Select all</button><button onClick={() => { setSelected([]); setPreview(null); }}>Clear selection</button></div><div className="report-standard-picker">{visibleStandards.map((s) => <label className="report-option" key={s.id}><input type="checkbox" checked={selected.includes(s.id)} onChange={() => toggle(setSelected, selected, s.id)} /><span><b>{s.number}</b> · {s.title}</span></label>)}</div></section>}
      {data && <><section className="report-card"><h2>Report readiness</h2><p>Drafts can be previewed and saved while work is incomplete. Approval requires complete assessment scores and saved summations for every assigned standard.</p><button type="button" onClick={refresh}>Refresh survey data</button>{readiness.length ? <ul className="report-readiness-issues">{readiness.map(issue => <li key={issue}>{issue}</li>)}</ul> : <p>Ready for review and explicit approval.</p>}<SummationReadiness statuses={data.summationStatus} /></section></>}
      {data && <details className="report-card print:hidden"><summary>View standard summation reports separately</summary><p>Summations for the selected standards. These are not included in the main report printout.</p><StandardSummationReports summaries={(preview || data).standardSummaries?.filter(s => (preview ? preview.standards.map(x => x.id) : selected).includes(s.standardId)) || []} /></details>}
      {data && included.includes("signoff") && <ReportSignOffEditor reviewerName={reviewerName} onReviewer={(value) => { setReviewerName(value); setDirty(true); setPreview(null); }} reviewNotes={reviewNotes} onNotes={(value) => { setReviewNotes(value); setDirty(true); setPreview(null); }} />}
      {versions.length > 0 && <section className="report-card"><h2>Saved versions</h2><p>Saved content is read-only. Generate a new preview to prepare another version.</p><div className="report-version-list">{versions.map((version) => <button key={version.reportVersionId} onClick={() => openVersion(version.reportVersionId)}>Version {version.versionNumber} · {new Date(version.createdAt).toLocaleString()} · {version.createdBy}</button>)}</div></section>}
      <div className="report-actions"><button className="report-primary" disabled={loading || !data || !selected.length || !included.length} onClick={generate}>Generate preview</button>{preview && <><button onClick={() => window.print()}>Print / Save as PDF</button><button disabled={Boolean(preview.savedVersion) || data?.workflowVersion !== 2} onClick={() => save(false)}>{preview.savedVersion ? `Saved version ${preview.savedVersion.versionNumber}` : "Save draft version"}</button>{!preview.savedVersion && <button disabled={readiness.length > 0} onClick={() => save(true)}>Approve and save version</button>}</>}</div>
    </fieldset>
    {preview && <SurveyReportDocument report={preview} />}
  </main>;
}
