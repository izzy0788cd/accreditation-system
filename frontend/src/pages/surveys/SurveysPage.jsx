import { useEffect, useState } from "react";
import { Link, useSearchParams } from "react-router-dom";
import { create, getAll, getMySurveys, getSubmittedSurveyorReports } from "../../api/api";
import FormModal from "../../components/FormModal";
import { useAuth } from "../../context/AuthContext";
import { ComplianceTree } from "./ToolkitBuilderPage";

const blankForm = { facilityId: "", surveyTypeId: "", surveyorId: "", startDate: "", endDate: "", scopeType: "Full", toolkitTemplateIds: [], selectedComplianceIds: [], customisationReason: "" };
const dateValue = (value) => value?.slice?.(0, 10) || value || "";
const sortNumber = (a, b) => String(a.standardNumber).localeCompare(String(b.standardNumber), undefined, { numeric: true });

export default function SurveysPage() {
  const { auth, profile } = useAuth();
  const [searchParams] = useSearchParams();
  const [surveys, setSurveys] = useState([]);
  const [facilities, setFacilities] = useState([]);
  const [types, setTypes] = useState([]);
  const [surveyors, setSurveyors] = useState([]);
  const [standards, setStandards] = useState([]);
  const [criteria, setCriteria] = useState([]);
  const [compliances, setCompliances] = useState([]);
  const [templates, setTemplates] = useState([]);
  const [submittedReports, setSubmittedReports] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [formOpen, setFormOpen] = useState(false);
  const [form, setForm] = useState(blankForm);
  const isAdmin = auth?.roleName === "Admin";
  const isSurveyor = auth?.roleName === "Surveyor";
  const isTeamLead = auth?.roleName === "Team Lead";
  const hasSurveyorProfile = surveyors.some((surveyor) => surveyor.userId === profile?.userId);
  const surveyorMode = isAdmin && hasSurveyorProfile && searchParams.get("mode") === "surveyor";
  const fieldworkMode = surveyorMode || isSurveyor;

  const load = async () => {
    try {
      setLoading(true);
      const [surveyRes, facilityRes, typeRes, surveyorRes, standardRes, templateRes, criterionRes, complianceRes, submittedReportRes] = await Promise.all([
        fieldworkMode || isTeamLead ? getMySurveys() : getAll("surveys"), getAll("facilities"), getAll("surveyTypes"), getAll("surveyors"), getAll("standards"), getAll("survey-toolkit-templates"), getAll("criteria"), getAll("compliances"), getSubmittedSurveyorReports(),
      ]);
      setSurveys(surveyRes.data); setFacilities(facilityRes.data); setTypes(typeRes.data); setSurveyors(surveyorRes.data);
      setStandards([...standardRes.data].sort(sortNumber)); setTemplates(templateRes.data); setCriteria(criterionRes.data); setCompliances(complianceRes.data); setSubmittedReports(submittedReportRes.data); setError("");
    } catch (err) { console.error(err); setError("We couldn't load the survey workspace."); } finally { setLoading(false); }
  };
  useEffect(() => { load(); }, [fieldworkMode, isTeamLead]);

  const submit = async (event) => {
    event.preventDefault();
    try {
      await create("surveys", { facilityId: Number(form.facilityId), surveyTypeId: Number(form.surveyTypeId), surveyorId: Number(form.surveyorId), startDate: form.startDate, endDate: form.endDate, scopeType: form.scopeType, toolkitTemplateIds: form.scopeType === "Template" ? form.toolkitTemplateIds : null, selectedComplianceIds: form.scopeType === "Custom" ? form.selectedComplianceIds : null, customisationReason: form.scopeType === "Custom" ? form.customisationReason : null });
      setFormOpen(false); setForm(blankForm); await load();
    } catch (err) { console.error(err); setError(err.response?.data || "We couldn't create the survey."); }
  };
  const resumeLink = (surveyId) => { try { const saved = JSON.parse(localStorage.getItem(`survey-resume-${profile?.userId || "anonymous"}-${surveyId}`) || "null"); return saved?.assessmentId ? `/surveys/${surveyId}?resume=${saved.assessmentId}` : null; } catch { return null; } };
  const sortedSurveys = [...surveys].sort((a, b) => String(b.startDate).localeCompare(String(a.startDate)));

  return <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:py-8">
    <header className="mb-6 rounded-2xl border border-[#c9dded] bg-[linear-gradient(125deg,#eaf3fb_0%,#f8fafc_60%,#fdf7ea_100%)] p-6 sm:p-8"><p className="text-xs font-bold uppercase tracking-[.16em] text-[#16803a]">{fieldworkMode ? "Surveyor work mode" : isTeamLead ? "Team lead workspace" : "Assessment workspace"}</p><div className="mt-2 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between"><div><h1 className="text-3xl font-bold tracking-tight text-[#092a5a]">{fieldworkMode ? "My survey work" : isTeamLead ? "My team surveys" : "Surveys"}</h1><p className="mt-2 max-w-2xl text-sm leading-6 text-[#4b5f7a]">{fieldworkMode ? "Your current assignments and survey participation record. Submitted handovers remain available to view and print." : isTeamLead ? "Surveys that you lead or contribute to. Open a survey to review team progress, handovers, and results." : "Create a full NHSS survey or a level-appropriate toolkit, then record compliance scores and evidence checks."}</p></div>{isAdmin && <div className="grid gap-2 sm:flex">{hasSurveyorProfile && (surveyorMode ? <Link to="/surveys" className="rounded-lg border border-[#c5d5e8] bg-white px-4 py-3 text-center text-sm font-semibold text-[#092a5a] hover:bg-[#edf5fc]">Switch to Administrator mode</Link> : <Link to="/surveys?mode=surveyor" className="rounded-lg border border-[#b8d9d3] bg-[#edf8f0] px-4 py-3 text-center text-sm font-semibold text-[#16803a] hover:bg-[#ddf3e4]">Work as surveyor</Link>)}{!surveyorMode && <><Link to="/surveys/setup" className="rounded-lg border border-[#c5d5e8] bg-white px-4 py-3 text-center text-sm font-semibold text-[#16803a] hover:bg-[#edf8f0]">Survey setup</Link><Link to="/surveys/toolkits" className="rounded-lg border border-[#c5d5e8] bg-white px-4 py-3 text-center text-sm font-semibold text-[#16803a] hover:bg-[#edf8f0]">Toolkit builder</Link><button onClick={() => setFormOpen(true)} className="rounded-lg bg-[#16803a] px-4 py-3 text-sm font-semibold text-white hover:bg-[#0d6531]">+ Create survey</button></>}</div>}</div></header>
    {!loading && <SurveyOperationsDashboard surveys={sortedSurveys} submittedReports={submittedReports} fieldworkMode={fieldworkMode} isTeamLead={isTeamLead} isAdmin={isAdmin && !surveyorMode} resumeLink={resumeLink} />}
    {fieldworkMode && <p className="mb-5 rounded-lg border border-sky-100 bg-sky-50 px-4 py-3 text-sm text-sky-800">You can work only on standards assigned to you. Team-wide results, other surveyors’ work, and survey administration are not available in this view.</p>}
    {error && <p role="alert" className="mb-4 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">{error}</p>}
    <section className="overflow-hidden rounded-xl border border-[#dfe7f0] bg-white shadow-sm">{loading ? <div className="space-y-3 p-6">{[1, 2, 3].map((item) => <div key={item} className="h-14 animate-pulse rounded bg-slate-100" />)}</div> : sortedSurveys.length === 0 ? <div className="px-6 py-16 text-center"><h2 className="font-semibold text-[#092a5a]">{fieldworkMode ? "No assigned surveys" : "No surveys yet"}</h2><p className="mt-1 text-sm text-[#68778c]">{fieldworkMode ? "When an Administrator assigns you a standard, its survey will appear here." : "Create a survey to generate its assessment checklist."}</p></div> : <SurveyList surveys={sortedSurveys} isAdmin={isAdmin && !surveyorMode} resumeLink={resumeLink} surveyorMode={fieldworkMode} />}</section>
    <FormModal open={formOpen} onClose={() => setFormOpen(false)} wide><SurveyCreateForm form={form} setForm={setForm} facilities={facilities} types={types} surveyors={surveyors} templates={templates} standards={standards} criteria={criteria} compliances={compliances} onCancel={() => setFormOpen(false)} onSubmit={submit} /></FormModal>
  </main>;
}

function SurveyOperationsDashboard({ surveys, submittedReports, fieldworkMode, isTeamLead, isAdmin, resumeLink }) {
  const active = surveys.filter((survey) => !survey.isCancelled);
  const activeIds = new Set(active.map((survey) => survey.surveyId));
  const teamSubmittedReports = submittedReports.filter((report) => activeIds.has(report.surveyId));
  const submitted = fieldworkMode ? active.filter((survey) => survey.hasSubmittedReport) : teamSubmittedReports;
  const surveysWithHandover = new Set(teamSubmittedReports.map((report) => report.surveyId));
  const inProgress = fieldworkMode ? active.filter((survey) => !survey.hasSubmittedReport) : active.filter((survey) => !surveysWithHandover.has(survey.surveyId));
  const cancelled = surveys.filter((survey) => survey.isCancelled);
  const continueSurvey = inProgress.find((survey) => resumeLink(survey.surveyId));
  const context = fieldworkMode ? "My survey work" : isTeamLead ? "Team survey control" : "Survey operations";
  const summary = fieldworkMode
    ? "Your assigned survey work and submitted handovers."
    : isTeamLead
      ? "Quick oversight of surveys currently assigned to your team."
      : "A concise operational view before opening the survey register.";
  return <section aria-label={context} className="mb-6 overflow-hidden rounded-xl border border-[#c9dded] bg-white shadow-sm"><div className="flex flex-col gap-3 border-b border-[#dbe5ef] bg-[#f6f9fc] px-5 py-4 sm:flex-row sm:items-center sm:justify-between"><div><p className="text-xs font-bold uppercase tracking-[.14em] text-[#16803a]">{context}</p><p className="mt-1 text-sm text-[#4b5f7a]">{summary}</p></div>{continueSurvey && <Link to={`${resumeLink(continueSurvey.surveyId)}${fieldworkMode ? "&mode=surveyor" : ""}`} className="shrink-0 rounded-lg bg-[#d6aa45] px-3.5 py-2 text-center text-sm font-semibold text-[#092a5a] hover:bg-[#c99d38]">Continue where I left off →</Link>}</div><div className="grid divide-y divide-[#e7edf4] sm:grid-cols-2 sm:divide-x sm:divide-y-0 xl:grid-cols-4">{[["Active surveys", active.length, "text-[#092a5a]"], [fieldworkMode ? "Still in progress" : "Awaiting handover", inProgress.length, "text-amber-700"], [fieldworkMode ? "My reports submitted" : "Reports submitted", submitted.length, "text-[#16803a]"], ["Cancelled", cancelled.length, "text-red-700"]].map(([label, value, tone]) => <div key={label} className="px-5 py-4"><p className="text-xs font-bold uppercase tracking-[.12em] text-[#68778c]">{label}</p><p className={`mt-1 text-3xl font-bold ${tone}`}>{value}</p></div>)}</div>{isAdmin && <div className="border-t border-[#dbe5ef] px-5 py-3 text-sm text-[#4b5f7a]">Administrators can create surveys, assign teams, and open the survey administration workspace from the register below.</div>}</section>;
}

function SurveyList({ surveys, isAdmin, resumeLink, surveyorMode }) {
  const surveyPath = (surveyId) => `/surveys/${surveyId}${surveyorMode ? "?mode=surveyor" : ""}`;
  const actions = (survey) => <div className="flex flex-wrap gap-2 sm:justify-end">{!survey.isCancelled && !survey.hasSubmittedReport && resumeLink(survey.surveyId) && <Link to={`${resumeLink(survey.surveyId)}${surveyorMode ? "&mode=surveyor" : ""}`} className="rounded-lg bg-[#d6aa45] px-3 py-2 text-xs font-semibold text-[#092a5a] hover:bg-[#c99d38]">Continue</Link>}<Link to={surveyPath(survey.surveyId)} className={`rounded-lg px-3 py-2 text-xs font-semibold ${survey.hasSubmittedReport ? "bg-[#16803a] text-white hover:bg-[#0d6531]" : "border border-[#c5d5e8] text-[#16803a] hover:bg-[#edf8f0]"}`}>{survey.hasSubmittedReport ? "Open survey workspace" : survey.isCancelled ? "History" : "Open assessment"}</Link>{isAdmin && <><Link to={`/surveys/${survey.surveyId}/team-dashboard`} className="rounded-lg border border-[#b8d9d3] bg-[#edf8f0] px-3 py-2 text-xs font-semibold text-[#16803a] hover:bg-[#ddf3e4]">Survey team</Link><Link to={`/surveys/${survey.surveyId}/admin`} className="rounded-lg bg-[#092a5a] px-3 py-2 text-xs font-semibold text-white hover:bg-[#071f45]">Administer</Link></>}</div>;
  return <div className="divide-y divide-[#e7edf4]">{surveys.map((survey) => <article key={survey.surveyId} className="p-5 sm:px-6"><div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between"><div><div className="flex flex-wrap items-center gap-2"><h2 className="font-bold text-[#092a5a]">{survey.facilityName}</h2><span className="rounded-full bg-[#edf8f0] px-2.5 py-1 text-xs font-semibold text-[#16803a]">{survey.surveyTypeName}</span>{survey.hasSubmittedReport && <span className="rounded-full bg-sky-50 px-2.5 py-1 text-xs font-semibold text-sky-800">Report submitted</span>}{survey.isCancelled && <span className="rounded-full bg-red-50 px-2.5 py-1 text-xs font-semibold text-red-700">Cancelled</span>}</div><p className="mt-1 text-sm text-[#68778c]">Team lead: {survey.surveyorName} · {dateValue(survey.startDate)} — {dateValue(survey.endDate)}</p></div>{actions(survey)}</div></article>)}</div>;
}

function SurveyCreateForm({ form, setForm, facilities, types, surveyors, templates, standards, criteria, compliances, onCancel, onSubmit }) {
  const input = "mt-1.5 w-full rounded-lg border border-[#c5d4e6] px-3 py-2.5 text-sm outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]";
  const selectedFacility = facilities.find((facility) => String(facility.facilityId) === String(form.facilityId));
  const compatibleTemplates = templates.filter((template) => template.isActive && (!template.levelId || template.levelId === selectedFacility?.levelId));
  const set = (key, value) => setForm((current) => ({ ...current, [key]: value }));
  const toggleTemplate = (id) => set("toolkitTemplateIds", form.toolkitTemplateIds.includes(id) ? form.toolkitTemplateIds.filter((item) => item !== id) : [...form.toolkitTemplateIds, id]);
  const selectedTemplateCompliances = compatibleTemplates.filter((template) => form.toolkitTemplateIds.includes(template.surveyToolkitTemplateId)).flatMap((template) => template.complianceIds || []);
  const selectedCount = form.scopeType === "Full" ? compliances.filter((item) => item.isApplicable).length : form.scopeType === "Template" ? new Set(selectedTemplateCompliances).size : form.selectedComplianceIds.length;
  return <form onSubmit={onSubmit}><p className="text-xs font-bold uppercase tracking-[.16em] text-[#16803a]">Assessment setup</p><h2 className="mt-1 text-xl font-bold text-[#092a5a]">Create survey</h2><div className="mt-5 grid gap-4 sm:grid-cols-3">{[["Facility", "facilityId", facilities, "facilityId", "facilityName"], ["Survey type", "surveyTypeId", types, "surveyTypeId", "surveyTypeName"], ["Team lead", "surveyorId", surveyors, "surveyorId", "fullName"]].map(([label, key, options, valueKey, labelKey]) => <label key={key} className="block text-sm font-semibold text-[#092a5a]">{label}<select required value={form[key]} onChange={(event) => key === "facilityId" ? setForm((current) => ({ ...current, facilityId: event.target.value, toolkitTemplateIds: [] })) : set(key, event.target.value)} className={input}><option value="">Select {label.toLowerCase()}</option>{options.map((option) => <option key={option[valueKey]} value={option[valueKey]}>{option[labelKey]}</option>)}</select></label>)}</div><fieldset className="mt-5"><legend className="text-sm font-bold text-[#092a5a]">Survey scope</legend><div className="mt-2 grid gap-2 sm:grid-cols-3">{[["Full", "Full NHSS survey", "Every applicable requirement"], ["Template", "Facility-level toolkit", "Approved templates for this facility level"], ["Custom", "Customised toolkit", "Choose exact requirements and record the reason"]].map(([value, label, note]) => <label key={value} className={`cursor-pointer rounded-lg border p-3 ${form.scopeType === value ? "border-[#16803a] bg-[#edf8f0]" : "border-[#dbe5ef] bg-white"}`}><input type="radio" className="mr-2" checked={form.scopeType === value} onChange={() => set("scopeType", value)} /><span className="font-semibold text-[#092a5a]">{label}</span><span className="mt-1 block text-xs text-[#68778c]">{note}</span></label>)}</div></fieldset>{form.scopeType === "Template" && <section className="mt-4 rounded-lg border border-[#dbe5ef] bg-[#f8fafc] p-4"><p className="font-semibold text-[#092a5a]">Choose approved templates</p><p className="mt-1 text-sm text-[#68778c]">{selectedFacility ? `${selectedFacility.levelName} templates and overlays are available.` : "Select a facility first to see compatible templates."}</p><div className="mt-3 space-y-2">{compatibleTemplates.map((template) => <label key={template.surveyToolkitTemplateId} className="flex items-start gap-3 rounded-md bg-white p-3 text-sm"><input className="mt-1" type="checkbox" checked={form.toolkitTemplateIds.includes(template.surveyToolkitTemplateId)} onChange={() => toggleTemplate(template.surveyToolkitTemplateId)} /><span><strong className="text-[#092a5a]">{template.templateName}</strong><span className="ml-1 text-[#68778c]">v{template.templateVersion} · {template.standardIds.length} standards · {template.complianceIds?.length || 0} requirements</span>{template.description && <span className="mt-1 block text-[#4b5f7a]">{template.description}</span>}</span></label>)}{selectedFacility && compatibleTemplates.length === 0 && <p className="text-sm text-amber-800">No active templates match this facility level. You can still create a Full NHSS or Customised survey.</p>}</div></section>}{form.scopeType === "Custom" && <section className="mt-4 rounded-lg border border-[#dbe5ef] bg-[#f8fafc] p-4"><label className="block text-sm font-semibold text-[#092a5a]">Reason for customised scope<textarea required value={form.customisationReason} onChange={(event) => set("customisationReason", event.target.value)} rows="2" className={`${input} resize-none`} placeholder="Explain why requirements were added or excluded." /></label><div className="mt-3"><ComplianceTree standards={standards} criteria={criteria} compliances={compliances} selectedIds={form.selectedComplianceIds} onChange={(selectedComplianceIds) => set("selectedComplianceIds", selectedComplianceIds)} /></div></section>}<p className="mt-4 rounded-lg bg-[#edf5fc] px-4 py-3 text-sm text-[#385273]"><strong>Scope preview:</strong> {selectedCount} compliance requirement{selectedCount === 1 ? "" : "s"} will be included. Evidence is included automatically for every requirement. A snapshot is saved with the survey and cannot be changed by later template edits.</p><div className="mt-5 grid gap-4 sm:grid-cols-2">{[["Start date", "startDate"], ["End date", "endDate"]].map(([label, key]) => <label key={key} className="block text-sm font-semibold text-[#092a5a]">{label}<input required type="date" value={form[key]} onChange={(event) => set(key, event.target.value)} className={input} /></label>)}</div><div className="mt-6 flex justify-end gap-3"><button type="button" onClick={onCancel} className="px-4 py-2.5 text-sm font-semibold text-[#4b5f7a]">Cancel</button><button type="submit" className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white">Create survey</button></div></form>;
}
