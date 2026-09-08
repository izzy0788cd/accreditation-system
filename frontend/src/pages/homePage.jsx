import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { getAll } from "../api/api";
import { useAuth } from "../context/AuthContext";
import Reveal from "../components/Reveal";
import MetricCard from "../components/MetricCard";

const summaryCards = [
  { resource: "standards", marker: "S", label: "NHSS standards", description: "Reference standards ready for accreditation work.", path: "/framework/standards", tone: "bg-amber-50 text-amber-700", accent: "border-t-amber-500", detail: "Framework reference data" },
  { resource: "regions", marker: "R", label: "Regions", description: "Top-level geographic areas in the directory.", path: "/location/regions", tone: "bg-teal-50 text-teal-700", accent: "border-t-teal-500", detail: "PNG geographic structure" },
  { resource: "districts", marker: "D", label: "Districts", description: "Districts available for organising health services.", path: "/location/districts", tone: "bg-cyan-50 text-cyan-700", accent: "border-t-cyan-500", detail: "Ready for facility placement" },
  { resource: "facilities", marker: "F", label: "Health facilities", description: "Facilities ready to be prepared for accreditation surveys.", path: "/facilities/directory", tone: "bg-rose-50 text-rose-700", accent: "border-t-rose-500", detail: "Accreditation starting point" },
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

  return (
    <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:py-10">
      <section className="reveal overflow-hidden rounded-[1.5rem] border border-[#cde5e0] bg-[linear-gradient(125deg,#e8f5f3_0%,#f8fbfa_58%,#fdf7ea_100%)] px-6 py-9 sm:px-10 sm:py-12">
        <p className="text-xs font-bold uppercase tracking-[0.18em] text-teal-700">Papua New Guinea health services</p>
        <h1 className="mt-3 max-w-3xl text-3xl font-bold tracking-tight text-[#143c42] sm:text-4xl">Welcome{displayName || auth?.username ? `, ${displayName || auth?.username}` : ""}.</h1>
        <p className="mt-4 max-w-2xl text-base leading-7 text-[#527076]">Bring together the National Health Service Standards, Papua New Guinea location directory, and health facilities that will progress through accreditation.</p>
        <div className="mt-7 flex flex-col gap-3 sm:flex-row">
          <Link to="/facilities" className="inline-flex items-center justify-center rounded-lg bg-[#087c77] px-5 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-[#05635f]">Open facility directory <span className="ml-2" aria-hidden="true">→</span></Link>
          <Link to="/framework" className="inline-flex items-center justify-center rounded-lg border border-[#9bc9c1] bg-white/80 px-5 py-3 text-sm font-semibold text-[#087c77] transition hover:bg-white">Open standards framework <span className="ml-2" aria-hidden="true">→</span></Link>
        </div>
      </section>
      <section className="mt-10" aria-labelledby="workspace-title">
        <div className="mb-5 flex flex-col gap-1 sm:flex-row sm:items-end sm:justify-between"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Workspace summary</p><h2 id="workspace-title" className="mt-1 text-2xl font-bold tracking-tight text-[#143c42]">Ready to work</h2></div><p className="text-sm text-[#668187]">A concise overview, with detailed dashboards inside each area.</p></div>
        <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
          {summaryCards.map((card, index) => <Reveal key={card.resource} delay={index * 70}><MetricCard {...card} count={counts[card.resource]} loading={loading} /></Reveal>)}
        </div>
      </section>
      <section className="mt-8 grid gap-4 lg:grid-cols-3">
        <Reveal delay={80}><Link to="/framework" className="block rounded-xl border border-[#e2ecea] bg-white p-6 shadow-[0_8px_24px_rgba(20,60,66,0.06)] transition hover:-translate-y-0.5 hover:border-amber-200"><p className="text-xs font-bold uppercase tracking-[0.16em] text-amber-700">Reference data</p><h2 className="mt-2 text-xl font-bold text-[#143c42]">Standards framework</h2><p className="mt-2 text-sm leading-6 text-[#668187]">Maintain functions, components, standards, criteria, compliance requirements, and evidence.</p><span className="mt-5 inline-block text-sm font-semibold text-[#b76d10]">Go to Framework →</span></Link></Reveal>
        <Reveal delay={150}><Link to="/location" className="block rounded-xl border border-[#e2ecea] bg-white p-6 shadow-[0_8px_24px_rgba(20,60,66,0.06)] transition hover:-translate-y-0.5 hover:border-[#8bc8be]"><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Geographic structure</p><h2 className="mt-2 text-xl font-bold text-[#143c42]">Location directory</h2><p className="mt-2 text-sm leading-6 text-[#668187]">Organise regions, provinces, and districts before linking health facilities and assessments.</p><span className="mt-5 inline-block text-sm font-semibold text-[#087c77]">Go to Location →</span></Link></Reveal>
        <Reveal delay={220}><Link to="/facilities" className="block rounded-xl border border-[#e2ecea] bg-white p-6 shadow-[0_8px_24px_rgba(20,60,66,0.06)] transition hover:-translate-y-0.5 hover:border-rose-200"><p className="text-xs font-bold uppercase tracking-[0.16em] text-rose-700">Accreditation starting point</p><h2 className="mt-2 text-xl font-bold text-[#143c42]">Facility directory</h2><p className="mt-2 text-sm leading-6 text-[#668187]">Register each health facility, place it in its district, and prepare it for future surveys.</p><span className="mt-5 inline-block text-sm font-semibold text-rose-700">Go to Facilities →</span></Link></Reveal>
      </section>
    </main>
  );
}

export default HomePage;
