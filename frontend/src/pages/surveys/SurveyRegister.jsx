import { useSearchParams } from "react-router-dom";

const filterKeys = ["q", "facility", "type", "lead", "status", "group", "sort"];
const compare = (a, b) => String(a || "").localeCompare(String(b || ""), undefined, { numeric: true, sensitivity: "base" });
const optionsFor = (surveys, key, label) => [...new Map(surveys.map(s => [String(s[key]), s[label] || "Not specified"])).entries()].sort((a, b) => compare(a[1], b[1]));

function filterSurveyRegister(surveys, params) {
  const query = (params.get("q") || "").trim().toLowerCase();
  return surveys.filter(survey => {
    const status = params.get("status") || "all";
    return (!query || [survey.facilityName, survey.surveyTypeName, survey.surveyorName, survey.surveyId, survey.toolkitSummary].some(value => String(value || "").toLowerCase().includes(query)))
      && (!params.get("facility") || String(survey.facilityId) === params.get("facility"))
      && (!params.get("type") || String(survey.surveyTypeId) === params.get("type"))
      && (!params.get("lead") || String(survey.surveyorId) === params.get("lead"))
      && (status === "all" || (status === "cancelled" ? survey.isCancelled : status === "active" ? !survey.isCancelled : true));
  }).sort((a, b) => {
    switch (params.get("sort")) {
      case "oldest": return compare(a.startDate, b.startDate) || a.surveyId - b.surveyId;
      case "facility": return compare(a.facilityName, b.facilityName) || b.surveyId - a.surveyId;
      case "id": return b.surveyId - a.surveyId;
      default: return compare(b.startDate, a.startDate) || b.surveyId - a.surveyId;
    }
  });
}

export default function SurveyRegister({ surveys, fieldworkMode, renderList }) {
  const [params, setParams] = useSearchParams();
  const change = (key, value) => setParams(current => {
    const next = new URLSearchParams(current);
    if (value) next.set(key, value); else next.delete(key);
    return next;
  }, { replace: true, preventScrollReset: true });
  const clear = () => setParams(current => {
    const next = new URLSearchParams(current);
    filterKeys.forEach(key => next.delete(key));
    return next;
  }, { replace: true, preventScrollReset: true });
  const filtered = filterSurveyRegister(surveys, params);
  const group = params.get("group") || "facility";
  const groups = new Map();
  filtered.forEach(survey => {
    const key = group === "type" ? survey.surveyTypeId : group === "none" ? "all" : survey.facilityId;
    if (!groups.has(key)) groups.set(key, { label: group === "type" ? survey.surveyTypeName : group === "none" ? "All matching surveys" : survey.facilityName, surveys: [] });
    groups.get(key).surveys.push(survey);
  });
  const input = "mt-1.5 w-full min-w-0 rounded-lg border border-[#c5d4e6] bg-white px-3 py-2.5 text-sm text-[#092a5a] focus:outline-none focus:ring-2 focus:ring-[#16803a]";
  const select = (label, key, options, fallback = "") => <label className="min-w-0 text-sm font-semibold text-[#092a5a]">{label}<select className={input} value={params.get(key) || fallback} onChange={event => change(key, event.target.value)}>{options.map(([value, name]) => <option key={value} value={value}>{name}</option>)}</select></label>;
  return <section aria-labelledby="survey-register-heading" className="space-y-4">
    <div className="rounded-xl border border-[#dfe7f0] bg-white p-5 sm:p-6">
      <div className="flex flex-wrap items-center justify-between gap-3"><h2 id="survey-register-heading" className="text-xl font-bold text-[#092a5a]">{fieldworkMode ? "My survey register" : "Survey register"}</h2><button type="button" onClick={clear} className="rounded px-2 py-1 text-sm font-semibold text-[#16803a] underline underline-offset-4">Reset view</button></div>
      <div className="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <label className="min-w-0 text-sm font-semibold text-[#092a5a]">Search surveys<input type="search" value={params.get("q") || ""} onChange={event => change("q", event.target.value)} placeholder="Facility, team lead, survey ID…" className={input} /></label>
        {select("Facility", "facility", [["", "All facilities"], ...optionsFor(surveys, "facilityId", "facilityName")])}
        {select("Survey type", "type", [["", "All types"], ...optionsFor(surveys, "surveyTypeId", "surveyTypeName")])}
        {select("Team lead", "lead", [["", "All team leads"], ...optionsFor(surveys, "surveyorId", "surveyorName")])}
        {select("Status", "status", [["all", "All surveys"], ["active", "Active (not cancelled)"], ["cancelled", "Cancelled"]], "all")}
        {select("Group by", "group", [["facility", "Facility"], ["type", "Survey type"], ["none", "No grouping"]], "facility")}
        {select("Sort surveys", "sort", [["newest", "Start date: newest first"], ["oldest", "Start date: oldest first"], ["facility", "Facility name"], ["id", "Survey ID: highest first"]], "newest")}
      </div>
      <p role="status" className="mt-4 text-sm text-[#4b5f7a]">Showing {filtered.length} of {surveys.length} surveys. Filters apply automatically.{group !== "none" && " Groups follow the first matching survey in the selected sort order."}</p>
    </div>
    {filtered.length === 0 ? <div className="rounded-xl border border-[#dfe7f0] bg-white p-8 text-center"><h3 className="font-bold text-[#092a5a]">No surveys match this view</h3><p className="mt-2 text-sm text-[#4b5f7a]">Change your search or reset the filters to see all available surveys.</p></div> : [...groups.entries()].map(([key, entry]) => <section key={key} aria-label={entry.label} className="overflow-hidden rounded-xl border border-[#dfe7f0] bg-white shadow-sm"><div className="flex items-center justify-between gap-3 border-b border-[#dfe7f0] bg-[#f6f9fc] px-5 py-3"><h3 className="font-bold text-[#092a5a]">{entry.label}</h3><span className="shrink-0 text-sm text-[#4b5f7a]">{entry.surveys.length} survey{entry.surveys.length === 1 ? "" : "s"}</span></div>{renderList(entry.surveys)}</section>)}
  </section>;
}
