import SurveyReportDocument from "./SurveyReportDocument";
import ReportActionsEditor from "./ReportActionsEditor";
import { Link, useSearchParams } from "react-router-dom";
import { useEffect, useState } from "react";
import { getReportSurveys, getSurveyReport, getReportVersions, getReportVersion, saveReportVersion } from "../../api/api";
import "./surveyReports.css";
import { compareReferenceNumber } from "../../utils/numberSort";

const sections = { summary: "Survey summary", standards: "Scores by standard", findings: "Findings, risks and comments", evidence: "Evidence checklist", actions: "Recommendations and sign-off" };
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
  const [included, setIncluded] = useState(["summary", "standards", "findings", "actions"]);
  const [preview, setPreview] = useState(null);
  const [loading, setLoading] = useState(true);
  const [mode, setMode] = useState("full");
  const [actions, setActions] = useState([]);
  const [reviewerName, setReviewerName] = useState("");
  const [reviewNotes, setReviewNotes] = useState("");
  const [versions, setVersions] = useState([]);
  const [busy, setBusy] = useState(false);
  const [notice, setNotice] = useState("");
  const [error, setError] = useState("");
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
    setSearchParams(next, { replace: true });
  }, [type, surveyId, setSearchParams]);
  useEffect(() => {
    if (!surveyId) return;
    let active = true;
    Promise.all([getSurveyReport(surveyId), getReportVersions(surveyId)]).then(([{ data: report }, { data: saved }]) => {
      if (!active) return;
      setData(report);
      setVersions(saved);
      setSelected([...new Set(report.items.map((item) => item.standardId))]);
    }).catch(() => { if (active) setError("Could not load this survey report. Please select the survey again to retry."); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, [surveyId]);
  const standards = [...new Map((data?.items || []).map((item) => [item.standardId, { id: item.standardId, number: item.standardNumber, title: item.standardTitle }])).values()].sort((a, b) => sortNumber(a.number, b.number));
  const availableSurveys = surveys.filter((survey) => !type || survey.surveyType === type);
  const selectedSurvey = surveys.find((survey) => String(survey.surveyId) === String(surveyId));
  const selectSurvey = (id) => { setSurveyId(id); setData(null); setPreview(null); setSelected([]); setVersions([]); setActions([]); setReviewerName(""); setReviewNotes(""); setNotice(""); setError(""); setLoading(Boolean(id)); };
  const toggle = (set, current, value) => { set(current.includes(value) ? current.filter((item) => item !== value) : [...current, value]); setPreview(null); };
  const generate = () => {
    const items = data.items.filter((item) => selected.includes(item.standardId)).sort((a, b) => sortNumber(a.complianceNumber, b.complianceNumber));
    setPreview({ ...data, items, included: [...included], mode, actions: actions.filter((a) => items.some((item) => item.complianceId === a.complianceId)), reviewerName, reviewNotes, standards: standards.filter((s) => selected.includes(s.id)) });
  };
  const save = async () => {
    setBusy(true); setError(""); setNotice("");
    try {
      const { data: saved } = await saveReportVersion(surveyId, {
        standardIds: preview.standards.map((s) => s.id), included: preview.included,
        mode: preview.mode, actions: preview.actions, reviewerName: preview.reviewerName, reviewNotes: preview.reviewNotes,
      });
      setPreview(saved);
      setNotice(`Version ${saved.savedVersion.versionNumber} saved. Source results were refreshed at save time. The saved content is now read-only.`);
      const { data: list } = await getReportVersions(surveyId); setVersions(list);
    } catch (failure) { setError(typeof failure.response?.data === "string" ? failure.response.data : "Report version could not be saved. Please retry."); }
    finally { setBusy(false); }
  };
  const openVersion = async (versionId) => {
    setBusy(true); setError(""); setNotice("");
    try {
      const { data: saved } = await getReportVersion(surveyId, versionId);
      saved.standards.sort((a,b) => sortNumber(a.number,b.number));
      saved.items.sort((a,b) => sortNumber(a.complianceNumber,b.complianceNumber));
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
          <label>Survey type<select value={type} onChange={(event) => { setType(event.target.value); selectSurvey(""); }}><option value="">All types</option>{[...new Set(surveys.map((s) => s.surveyType))].map((name) => <option key={name}>{name}</option>)}</select></label>
          <label>Survey<select value={surveyId} onChange={(event) => selectSurvey(event.target.value)}><option value="">Select a survey</option>{availableSurveys.map((s) => <option key={s.surveyId} value={s.surveyId}>{String(s.surveyType).toUpperCase()} · {s.facilityName} · {s.startDate} · #{s.surveyId}{s.isCancelled ? " (cancelled)" : ""}</option>)}</select></label>
          {selectedSurvey && <div className="report-scope-summary" aria-label="Selected report scope"><span className={surveyTypeClass(selectedSurvey.surveyType)}>{selectedSurvey.surveyType}</span><div><strong>{selectedSurvey.facilityName}</strong><span>Survey #{selectedSurvey.surveyId} · {selectedSurvey.startDate}{selectedSurvey.endDate ? ` — ${selectedSurvey.endDate}` : ""}</span></div></div>}
          {!selectedSurvey && availableSurveys.length > 0 && <div className="report-available-surveys" aria-label="Available surveys"><p>Available surveys</p><div>{availableSurveys.map((survey) => <button type="button" key={survey.surveyId} onClick={() => selectSurvey(String(survey.surveyId))}><span className={surveyTypeClass(survey.surveyType)}>{survey.surveyType}</span><span>{survey.facilityName} · #{survey.surveyId}</span></button>)}</div></div>}
          {loading && <p role="status">Loading…</p>}
          {!loading && !surveys.length && !error && <p>No surveys are available yet.</p>}
          {data && !data.items.length && <p>This survey has no assessment items.</p>}
        </section>
        <section className="report-card"><label>Report detail<select value={mode} onChange={(e) => { setMode(e.target.value); setPreview(null); }}><option value="full">Full report</option><option value="findings">Findings only — gaps and high/extreme risks</option></select></label><h2>2. Select report sections</h2>{Object.entries(sections).map(([key, label]) => <label className="report-option" key={key}><input type="checkbox" checked={included.includes(key)} onChange={() => toggle(setIncluded, included, key)} />{label}</label>)}</section>
      </div>
      {data && standards.length > 0 && <section className="report-card"><h2>3. Select standards <small>({selected.length} of {standards.length})</small></h2><div className="report-actions"><button onClick={() => { setSelected(standards.map((s) => s.id)); setPreview(null); }}>Select all</button><button onClick={() => { setSelected([]); setPreview(null); }}>Clear selection</button></div><div className="report-standard-picker">{standards.map((s) => <label className="report-option" key={s.id}><input type="checkbox" checked={selected.includes(s.id)} onChange={() => toggle(setSelected, selected, s.id)} /><span><b>{s.number}</b> · {s.title}</span></label>)}</div></section>}
      {data && included.includes("actions") && <ReportActionsEditor items={data.items.filter((item) => selected.includes(item.standardId))} actions={actions} onActions={(value) => { setActions(value); setPreview(null); }} reviewerName={reviewerName} onReviewer={(value) => { setReviewerName(value); setPreview(null); }} reviewNotes={reviewNotes} onNotes={(value) => { setReviewNotes(value); setPreview(null); }} />}
      {versions.length > 0 && <section className="report-card"><h2>Saved versions</h2><p>Saved content is read-only. Generate a new preview to prepare another version.</p><div className="report-version-list">{versions.map((version) => <button key={version.reportVersionId} onClick={() => openVersion(version.reportVersionId)}>Version {version.versionNumber} · {new Date(version.createdAt).toLocaleString()} · {version.createdBy}</button>)}</div></section>}
      <div className="report-actions"><button className="report-primary" disabled={loading || !data || !selected.length || !included.length} onClick={generate}>Generate preview</button>{preview && <><button onClick={() => window.print()}>Print / Save as PDF</button><button disabled={Boolean(preview.savedVersion)} onClick={save}>{preview.savedVersion ? `Saved version ${preview.savedVersion.versionNumber}` : "Save report version"}</button></>}</div>
    </fieldset>
    {preview && <SurveyReportDocument report={preview} />}
  </main>;
}
