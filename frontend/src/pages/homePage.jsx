import { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import { getAll, getSurveyProgress } from "../api/api";
import { useAuth } from "../context/AuthContext";
import Reveal from "../components/Reveal";
import MetricCard from "../components/MetricCard";
import logo from "../assets/pictures/logo/accreditation-system-logo3.png";

const summaryCards = [
  { resource: "surveys", marker: "01", label: "Surveys", description: "Assessment workspaces created for health facilities.", path: "/surveys", tone: "bg-[#edf8f0] text-[#16803a]", accent: "border-t-[#16803a]", detail: "Open assessment workspace", footer: "Open surveys" },
  { resource: "facilities", marker: "02", label: "Health facilities", description: "Facilities ready for accreditation surveys.", path: "/facilities/directory", tone: "bg-[#eaf3fb] text-[#0079b8]", accent: "border-t-[#0079b8]", detail: "Accreditation starting point", footer: "Open directory" },
  { resource: "standards", marker: "03", label: "NHSS standards", description: "Reference standards used for every survey.", path: "/framework/standards", tone: "bg-amber-50 text-amber-700", accent: "border-t-amber-500", detail: "Framework reference data", footer: "Open framework" },
  { resource: "districts", marker: "04", label: "Districts", description: "PNG districts ready to organise health facilities.", path: "/location/districts", tone: "bg-[#edf8f0] text-[#16803a]", accent: "border-t-[#16803a]", detail: "PNG geographic structure", footer: "Open locations" },
];

const chartColours = ["#16803a", "#d6aa45", "#e06c75", "#6e92b2"];

function EmptyChart() {
  return <div className="flex h-44 items-center justify-center rounded-lg border border-dashed border-[#c5d4e6] bg-[#f8fafc] px-5 text-center text-sm leading-6 text-[#68778c]">Charts will appear once survey activity is recorded.</div>;
}

function DonutChart({ segments, total }) {
  if (!total) return <EmptyChart />;
  return <div className="flex items-center gap-5"><svg viewBox="0 0 42 42" className="h-36 w-36 shrink-0 -rotate-90" role="img" aria-label="Survey type distribution"><circle cx="21" cy="21" r="15.915" fill="none" stroke="#e8eef5" strokeWidth="6" />{segments.map((segment, index) => {
    const length = (segment.value / total) * 100;
    const offset = segments.slice(0, index).reduce((sum, previous) => sum + (previous.value / total) * 100, 0);
    return <circle key={segment.label} cx="21" cy="21" r="15.915" fill="none" stroke={chartColours[index]} strokeWidth="6" strokeDasharray={`${length} ${100 - length}`} strokeDashoffset={-offset} />;
  })}</svg><div className="min-w-0 space-y-2">{segments.map((segment, index) => <div key={segment.label} className="flex items-center gap-2 text-sm text-[#4b5f7a]"><span className="h-2.5 w-2.5 rounded-full" style={{ backgroundColor: chartColours[index] }} /><span className="truncate">{segment.label}</span><strong className="ml-auto text-[#092a5a]">{segment.value}</strong></div>)}</div></div>;
}

function SurveyProgressChart({ surveys, progressBySurvey }) {
  const activeSurveys = surveys.filter((survey) => !survey.isCancelled).sort((first, second) => String(first.startDate).localeCompare(String(second.startDate))).slice(0, 6);
  if (!activeSurveys.length) return <EmptyChart />;
  return <div className="max-h-56 space-y-4 overflow-y-auto pr-1">{activeSurveys.map((survey) => {
    const progress = progressBySurvey[survey.surveyId];
    const scoreProgress = progress?.totalCompliances ? Math.round((progress.scoredCount / progress.totalCompliances) * 100) : 0;
    const evidenceProgress = progress?.totalEvidenceChecks ? Math.round((progress.checkedEvidenceCount / progress.totalEvidenceChecks) * 100) : 0;
    const tone = scoreProgress >= 70 ? "bg-[#16803a]" : scoreProgress >= 40 ? "bg-[#d6aa45]" : "bg-red-500";
    return <div key={survey.surveyId}><div className="mb-1.5 flex items-center justify-between gap-3"><div className="min-w-0"><p className="truncate text-sm font-semibold text-[#092a5a]">{survey.facilityName}</p><p className="text-xs text-[#68778c]">{progress ? `${progress.scoredCount} of ${progress.totalCompliances} requirements scored` : "Progress not available"}</p></div><strong className="shrink-0 text-sm text-[#092a5a]">{scoreProgress}%</strong></div><div className="h-3 overflow-hidden rounded-full bg-[#e8eef5]"><div className={`h-full rounded-full transition-all duration-700 ${tone}`} style={{ width: `${scoreProgress}%` }} /></div><div className="mt-1.5 flex justify-between text-[11px] font-medium text-[#68778c]"><span>Scoring progress</span><span>Evidence {evidenceProgress}%</span></div></div>;
  })}</div>;
}

function HomePage() {
  const { auth, profile } = useAuth();
  const [counts, setCounts] = useState({});
  const [surveys, setSurveys] = useState([]);
  const [surveyProgress, setSurveyProgress] = useState({});
  const [loading, setLoading] = useState(true);
  const [summaryError, setSummaryError] = useState("");
  const canAccessSurveys = ["Admin", "Surveyor", "Team Lead"].includes(auth?.roleName);

  useEffect(() => {
    const loadSummary = async () => {
      try {
        const accessibleCards = canAccessSurveys ? summaryCards : summaryCards.filter((card) => card.resource !== "surveys");
        const responses = await Promise.all(accessibleCards.map((card) => getAll(card.resource)));
        const loadedCounts = Object.fromEntries(accessibleCards.map((card, index) => [card.resource, responses[index].data.length]));
        const surveyData = canAccessSurveys ? responses[0].data : [];
        setCounts(loadedCounts);
        setSurveys(surveyData);
        if (canAccessSurveys) {
          const progressResponses = await Promise.allSettled(surveyData.map((survey) => getSurveyProgress(survey.surveyId)));
          setSurveyProgress(Object.fromEntries(progressResponses.flatMap((response, index) => response.status === "fulfilled" ? [[surveyData[index].surveyId, response.value.data]] : [])));
        } else setSurveyProgress({});
        setSummaryError("");
      } catch (error) {
        console.error("Failed to load home summary", error);
        setSummaryError("Some dashboard information could not be loaded. You can still use the navigation to continue your work.");
      } finally {
        setLoading(false);
      }
    };
    loadSummary();
  }, [canAccessSurveys]);

  const displayName = [profile?.firstName, profile?.lastName].filter(Boolean).join(" ");
  const isAdmin = auth?.roleName === "Admin";
  const isSurveyor = ["Surveyor", "Team Lead"].includes(auth?.roleName);
  const recentSurveys = [...surveys].sort((first, second) => String(second.startDate).localeCompare(String(first.startDate))).slice(0, 3);
  const dashboard = useMemo(() => {
    const types = surveys.reduce((result, survey) => ({ ...result, [survey.surveyTypeName || "Other"]: (result[survey.surveyTypeName || "Other"] || 0) + 1 }), {});
    return {
      typeSegments: Object.entries(types).map(([label, value]) => ({ label, value })),
      active: surveys.filter((survey) => !survey.isCancelled).length,
      cancelled: surveys.filter((survey) => survey.isCancelled).length,
    };
  }, [surveys]);

  return (
    <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:py-10">
      <section className="reveal overflow-hidden rounded-[1.5rem] border border-[#c9dded] bg-[linear-gradient(125deg,#eaf3fb_0%,#f8fafc_58%,#fdf7ea_100%)] px-6 py-9 sm:px-10 sm:py-12">
        <div className="grid gap-7 lg:grid-cols-[minmax(0,1fr)_18rem] lg:items-end"><div><p className="text-xs font-bold uppercase tracking-[0.18em] text-[#16803a]">National Health Care Accreditation Programme</p><h1 className="mt-3 max-w-3xl text-3xl font-bold tracking-tight text-[#092a5a] sm:text-4xl">Welcome{displayName || auth?.username ? `, ${displayName || auth?.username}` : ""}.</h1><p className="mt-4 max-w-2xl text-base leading-7 text-[#4b5f7a]">{canAccessSurveys ? "Start, continue, and review health-facility accreditation surveys. The framework, facility directory, and location data support the survey work—not the other way around." : "You have read-only access to the accreditation reference data that supports health-facility surveys."}</p><div className="mt-7 flex flex-col gap-3 sm:flex-row">{canAccessSurveys ? <Link to="/surveys" className="inline-flex items-center justify-center rounded-lg bg-[#16803a] px-5 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-[#0d6531]">{isSurveyor ? "Continue survey work" : "Manage surveys"} <span className="ml-2" aria-hidden="true">→</span></Link> : <Link to="/framework" className="inline-flex items-center justify-center rounded-lg bg-[#16803a] px-5 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-[#0d6531]">View framework <span className="ml-2" aria-hidden="true">→</span></Link>}{isAdmin && <Link to="/surveys/setup" className="inline-flex items-center justify-center rounded-lg border border-[#9ec2e4] bg-white/80 px-5 py-3 text-sm font-semibold text-[#0079b8] transition hover:bg-white">Survey setup <span className="ml-2" aria-hidden="true">→</span></Link>}</div></div><aside className="relative overflow-hidden rounded-2xl bg-[#092a5a] p-5 text-white shadow-[0_18px_36px_rgba(9,42,90,0.20)]"><div className="pointer-events-none absolute -right-10 -top-10 h-32 w-32 rounded-full border-[18px] border-[#16803a]/40" /><div className="relative flex items-start justify-between gap-3"><div><p className="text-[11px] font-bold uppercase tracking-[.16em] text-[#bbf7d0]">Papua New Guinea</p><p className="mt-1 text-sm font-semibold leading-5">Quality standards. Safer care.</p></div><img src={logo} alt="National Health Care Accreditation Programme" className="h-14 w-14 rounded-full bg-white object-contain p-0.5 shadow-md" /></div><div className="relative mt-6 border-t border-white/20 pt-4"><p className="text-4xl font-bold tracking-tight">{loading ? "…" : canAccessSurveys ? counts.surveys || 0 : counts.standards || 0}</p><p className="mt-1 text-sm leading-6 text-blue-100">{canAccessSurveys ? "survey workspaces currently available" : "NHSS standards available to review"}</p>{canAccessSurveys && <Link to="/surveys" className="mt-4 inline-block text-sm font-semibold text-[#bbf7d0] hover:text-white hover:underline">Open survey list →</Link>}</div></aside></div>
      </section>
      {summaryError && <p role="alert" className="mt-5 rounded-lg border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-900">{summaryError}</p>}
      {canAccessSurveys && <section className="mt-6 grid gap-4 xl:grid-cols-[1fr_1fr_.72fr]" aria-label="Survey activity dashboard">
        <Reveal><article className="rounded-xl border border-[#d8e4f0] bg-white p-5 shadow-[0_8px_24px_rgba(20,60,66,0.06)] sm:p-6"><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Portfolio mix</p><h2 className="mt-1 text-lg font-bold text-[#092a5a]">Survey type distribution</h2><div className="mt-4">{loading ? <div className="h-36 animate-pulse rounded-lg bg-slate-100" /> : <DonutChart segments={dashboard.typeSegments} total={surveys.length} />}</div></article></Reveal>
        <Reveal delay={80}><article className="rounded-xl border border-[#d8e4f0] bg-white p-5 shadow-[0_8px_24px_rgba(20,60,66,0.06)] sm:p-6"><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Survey progress</p><h2 className="mt-1 text-lg font-bold text-[#092a5a]">Where attention is needed</h2><div className="mt-4">{loading ? <div className="h-36 animate-pulse rounded-lg bg-slate-100" /> : <SurveyProgressChart surveys={surveys} progressBySurvey={surveyProgress} />}</div></article></Reveal>
        <Reveal delay={160}><article className="rounded-xl border border-[#d8e4f0] bg-[#092a5a] p-5 text-white shadow-[0_8px_24px_rgba(20,60,66,0.12)] sm:p-6"><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#bbf7d0]">Survey status</p><h2 className="mt-1 text-lg font-bold">Portfolio snapshot</h2><dl className="mt-6 space-y-4"><div className="flex items-end justify-between border-b border-white/15 pb-3"><dt className="text-sm text-slate-200">Active surveys</dt><dd className="text-3xl font-bold">{loading ? "…" : dashboard.active}</dd></div><div className="flex items-end justify-between border-b border-white/15 pb-3"><dt className="text-sm text-slate-200">Cancelled surveys</dt><dd className="text-3xl font-bold text-[#f4d58d]">{loading ? "…" : dashboard.cancelled}</dd></div></dl><Link to="/surveys" className="mt-5 inline-block text-sm font-semibold text-[#bbf7d0] hover:text-white hover:underline">Open the survey workspace →</Link></article></Reveal>
      </section>}
      {canAccessSurveys && <section className="mt-6 overflow-hidden rounded-xl border border-[#d8e4f0] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]" aria-labelledby="survey-centre-title"><div className="flex flex-col gap-4 border-b border-[#dbe5ef] bg-[#f6f9fc] px-5 py-5 sm:flex-row sm:items-end sm:justify-between sm:px-6"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Your survey control centre</p><h2 id="survey-centre-title" className="mt-1 text-2xl font-bold tracking-tight text-[#092a5a]">Recent survey work</h2><p className="mt-1 text-sm text-[#68778c]">{isAdmin ? "Set up survey teams, monitor activity, and open assessment records." : "Open a survey to continue your assigned standards, evidence, and scores."}</p></div><Link to="/surveys" className="rounded-lg bg-[#16803a] px-4 py-2.5 text-center text-sm font-semibold text-white hover:bg-[#0d6531]">View all surveys</Link></div>{loading ? <div className="space-y-3 p-6">{[1, 2, 3].map((item) => <div key={item} className="h-16 animate-pulse rounded-lg bg-slate-100" />)}</div> : recentSurveys.length === 0 ? <div className="p-8 text-center"><p className="font-semibold text-[#092a5a]">No surveys have been created yet.</p><p className="mt-1 text-sm text-[#68778c]">{isAdmin ? "Create a survey when a facility is ready for assessment." : "An Administrator will assign you to a survey when work is ready."}</p>{isAdmin && <Link to="/surveys" className="mt-4 inline-block text-sm font-semibold text-[#16803a] hover:underline">Create or manage surveys →</Link>}</div> : <div className="divide-y divide-[#e7edf4]">{recentSurveys.map((survey) => <div key={survey.surveyId} className="flex flex-col gap-3 px-5 py-4 transition hover:bg-[#f8fafc] sm:flex-row sm:items-center sm:justify-between sm:px-6"><div><div className="flex flex-wrap items-center gap-2"><p className="font-bold text-[#092a5a]">{survey.facilityName}</p><span className="rounded-full bg-[#edf8f0] px-2.5 py-1 text-xs font-semibold text-[#16803a]">{survey.surveyTypeName}</span></div><p className="mt-1 text-sm text-[#68778c]">Team lead: {survey.surveyorName} <span className="mx-1">·</span> {survey.startDate} — {survey.endDate}</p></div><Link to={`/surveys/${survey.surveyId}`} className="rounded-lg border border-[#c5d5e8] px-3.5 py-2 text-center text-sm font-semibold text-[#16803a] hover:bg-[#edf8f0]">Open survey</Link></div>)}</div>}</section>}
      <section className="mt-10" aria-labelledby="workspace-title">
        <div className="mb-5 flex flex-col gap-1 sm:flex-row sm:items-end sm:justify-between"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Survey support data</p><h2 id="workspace-title" className="mt-1 text-2xl font-bold tracking-tight text-[#092a5a]">Everything supporting your surveys</h2></div><p className="text-sm text-[#68778c]">Facilities, standards, and location records used by the survey toolkit.</p></div>
        <div className="grid gap-4 md:grid-cols-3">
          {summaryCards.slice(1).map((card, index) => <Reveal key={card.resource} delay={index * 70}><MetricCard {...card} count={counts[card.resource]} loading={loading} /></Reveal>)}
        </div>
      </section>
      <section className="mt-8 grid gap-4 lg:grid-cols-3">
        <Reveal delay={80}><Link to="/framework" className="block rounded-xl border border-[#dfe7f0] bg-white p-6 shadow-[0_8px_24px_rgba(20,60,66,0.06)] transition hover:-translate-y-0.5 hover:border-amber-200"><p className="text-xs font-bold uppercase tracking-[0.16em] text-amber-700">Survey reference</p><h2 className="mt-2 text-xl font-bold text-[#092a5a]">Standards framework</h2><p className="mt-2 text-sm leading-6 text-[#68778c]">Maintain the standards, criteria, compliance requirements, and evidence used in every survey.</p><span className="mt-5 inline-block text-sm font-semibold text-[#b76d10]">Go to Framework →</span></Link></Reveal>
        <Reveal delay={150}><Link to="/location" className="block rounded-xl border border-[#dfe7f0] bg-white p-6 shadow-[0_8px_24px_rgba(20,60,66,0.06)] transition hover:-translate-y-0.5 hover:border-[#8bb7dd]"><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Geographic structure</p><h2 className="mt-2 text-xl font-bold text-[#092a5a]">Location directory</h2><p className="mt-2 text-sm leading-6 text-[#68778c]">Organise regions, provinces, and districts before linking health facilities and assessments.</p><span className="mt-5 inline-block text-sm font-semibold text-[#16803a]">Go to Location →</span></Link></Reveal>
        <Reveal delay={220}><Link to="/facilities" className="block rounded-xl border border-[#dfe7f0] bg-white p-6 shadow-[0_8px_24px_rgba(20,60,66,0.06)] transition hover:-translate-y-0.5 hover:border-rose-200"><p className="text-xs font-bold uppercase tracking-[0.16em] text-rose-700">Accreditation starting point</p><h2 className="mt-2 text-xl font-bold text-[#092a5a]">Facility directory</h2><p className="mt-2 text-sm leading-6 text-[#68778c]">Register each health facility, place it in its district, and prepare it for future surveys.</p><span className="mt-5 inline-block text-sm font-semibold text-rose-700">Go to Facilities →</span></Link></Reveal>
      </section>
    </main>
  );
}

export default HomePage;
