import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { getAll } from "../api/api";
import { useAuth } from "../context/AuthContext";
import Reveal from "../components/Reveal";
import MetricCard from "../components/MetricCard";

const summaryCards = [
  { resource: "surveys", marker: "01", label: "Surveys", description: "Assessment workspaces created for health facilities.", path: "/surveys", tone: "bg-teal-50 text-teal-700", accent: "border-t-teal-500", detail: "Open assessment workspace", footer: "Open surveys" },
  { resource: "facilities", marker: "02", label: "Health facilities", description: "Facilities ready for accreditation surveys.", path: "/facilities/directory", tone: "bg-rose-50 text-rose-700", accent: "border-t-rose-500", detail: "Accreditation starting point", footer: "Open directory" },
  { resource: "standards", marker: "03", label: "NHSS standards", description: "Reference standards used for every survey.", path: "/framework/standards", tone: "bg-amber-50 text-amber-700", accent: "border-t-amber-500", detail: "Framework reference data", footer: "Open framework" },
  { resource: "districts", marker: "04", label: "Districts", description: "PNG districts ready to organise health facilities.", path: "/location/districts", tone: "bg-cyan-50 text-cyan-700", accent: "border-t-cyan-500", detail: "PNG geographic structure", footer: "Open locations" },
];

function HomePage() {
  const { auth, profile } = useAuth();
  const [counts, setCounts] = useState({});
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadSummary = async () => {
      try {
        const responses = await Promise.all(summaryCards.map((card) => getAll(card.resource)));
        setCounts(Object.fromEntries(summaryCards.map((card, index) => [card.resource, responses[index].data.length])));
      } catch (error) {
        console.error("Failed to load home summary", error);
      } finally {
        setLoading(false);
      }
    };
    loadSummary();
  }, []);

  const displayName = [profile?.firstName, profile?.lastName].filter(Boolean).join(" ");
  const isAdmin = auth?.roleName === "Admin";
  const isSurveyor = auth?.roleName === "Surveyor";

  return (
    <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:py-10">
      <section className="reveal overflow-hidden rounded-[1.5rem] border border-[#cde5e0] bg-[linear-gradient(125deg,#e8f5f3_0%,#f8fbfa_58%,#fdf7ea_100%)] px-6 py-9 sm:px-10 sm:py-12">
        <p className="text-xs font-bold uppercase tracking-[0.18em] text-teal-700">Papua New Guinea health services</p>
        <h1 className="mt-3 max-w-3xl text-3xl font-bold tracking-tight text-[#143c42] sm:text-4xl">Welcome{displayName || auth?.username ? `, ${displayName || auth?.username}` : ""}.</h1>
        <p className="mt-4 max-w-2xl text-base leading-7 text-[#527076]">Your starting point for survey work, health-facility readiness, the National Health Service Standards, and Papua New Guinea location data.</p>
        <div className="mt-7 flex flex-col gap-3 sm:flex-row">
          <Link to="/surveys" className="inline-flex items-center justify-center rounded-lg bg-[#087c77] px-5 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-[#05635f]">Open survey workspace <span className="ml-2" aria-hidden="true">→</span></Link>
          <Link to="/facilities" className="inline-flex items-center justify-center rounded-lg border border-[#9bc9c1] bg-white/80 px-5 py-3 text-sm font-semibold text-[#087c77] transition hover:bg-white">Open facility directory <span className="ml-2" aria-hidden="true">→</span></Link>
        </div>
      </section>
      <section className="mt-6 grid gap-4 lg:grid-cols-[minmax(0,1fr)_auto]">
        <div className="rounded-xl border border-[#d7e5e2] bg-white p-5 shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Your workspace</p><h2 className="mt-2 text-xl font-bold text-[#143c42]">{isAdmin ? "Administrative overview" : isSurveyor ? "Assigned assessment work" : "Accreditation workspace"}</h2><p className="mt-2 text-sm leading-6 text-[#668187]">{isAdmin ? "Manage reference data, facilities, survey teams, and user access from the areas below." : isSurveyor ? "Open a survey to complete evidence checks, scores, findings, and your assigned standards." : "Use the directories and framework to prepare accreditation work."}</p></div>
        <div className="flex flex-col gap-2 rounded-xl border border-[#d7e5e2] bg-[#f5faf9] p-5 sm:flex-row lg:flex-col"><Link to="/surveys" className="rounded-lg bg-[#143c42] px-4 py-2.5 text-center text-sm font-semibold text-white hover:bg-[#0d2c31]">My surveys</Link>{isAdmin ? <Link to="/admin/users" className="rounded-lg border border-[#b9d6d1] bg-white px-4 py-2.5 text-center text-sm font-semibold text-[#087c77] hover:bg-teal-50">User management</Link> : <Link to="/framework" className="rounded-lg border border-[#b9d6d1] bg-white px-4 py-2.5 text-center text-sm font-semibold text-[#087c77] hover:bg-teal-50">Standards framework</Link>}</div>
      </section>
      <section className="mt-10" aria-labelledby="workspace-title">
        <div className="mb-5 flex flex-col gap-1 sm:flex-row sm:items-end sm:justify-between"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">System overview</p><h2 id="workspace-title" className="mt-1 text-2xl font-bold tracking-tight text-[#143c42]">Accreditation workspace</h2></div><p className="text-sm text-[#668187]">Live totals across the areas currently in use.</p></div>
        <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
          {summaryCards.map((card, index) => <Reveal key={card.resource} delay={index * 70}><MetricCard {...card} count={counts[card.resource]} loading={loading} /></Reveal>)}
        </div>
      </section>
      <section className="mt-8 grid gap-4 lg:grid-cols-3">
        <Reveal delay={80}><Link to="/surveys" className="block rounded-xl border border-[#e2ecea] bg-white p-6 shadow-[0_8px_24px_rgba(20,60,66,0.06)] transition hover:-translate-y-0.5 hover:border-[#8bc8be]"><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Assessments</p><h2 className="mt-2 text-xl font-bold text-[#143c42]">Survey workspace</h2><p className="mt-2 text-sm leading-6 text-[#668187]">Complete evidence checks, scores, comments, findings, and review progress or results.</p><span className="mt-5 inline-block text-sm font-semibold text-[#087c77]">Go to Surveys →</span></Link></Reveal>
        <Reveal delay={150}><Link to="/location" className="block rounded-xl border border-[#e2ecea] bg-white p-6 shadow-[0_8px_24px_rgba(20,60,66,0.06)] transition hover:-translate-y-0.5 hover:border-[#8bc8be]"><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Geographic structure</p><h2 className="mt-2 text-xl font-bold text-[#143c42]">Location directory</h2><p className="mt-2 text-sm leading-6 text-[#668187]">Organise regions, provinces, and districts before linking health facilities and assessments.</p><span className="mt-5 inline-block text-sm font-semibold text-[#087c77]">Go to Location →</span></Link></Reveal>
        <Reveal delay={220}><Link to="/facilities" className="block rounded-xl border border-[#e2ecea] bg-white p-6 shadow-[0_8px_24px_rgba(20,60,66,0.06)] transition hover:-translate-y-0.5 hover:border-rose-200"><p className="text-xs font-bold uppercase tracking-[0.16em] text-rose-700">Accreditation starting point</p><h2 className="mt-2 text-xl font-bold text-[#143c42]">Facility directory</h2><p className="mt-2 text-sm leading-6 text-[#668187]">Register each health facility, place it in its district, and prepare it for future surveys.</p><span className="mt-5 inline-block text-sm font-semibold text-rose-700">Go to Facilities →</span></Link></Reveal>
      </section>
    </main>
  );
}

export default HomePage;
