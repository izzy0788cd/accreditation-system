import { useEffect, useState } from "react";
import { getAll } from "../../api/api";
import Reveal from "../../components/Reveal";
import MetricCard from "../../components/MetricCard";

const cards = [
  { resource: "facilities", marker: "01", label: "Facilities", path: "/facilities/directory", description: "Health facilities ready for accreditation work.", tone: "bg-[#edf8f0] text-[#16803a]", accent: "border-t-[#16803a]" },
  { resource: "organizations", marker: "02", label: "Organisations", path: "/facilities/reference-data", description: "Responsible organisations and service owners.", tone: "bg-amber-50 text-amber-700", accent: "border-t-amber-500" },
  { resource: "levels", marker: "03", label: "Facility levels", path: "/facilities/reference-data", description: "Recognised levels of health service delivery.", tone: "bg-cyan-50 text-cyan-700", accent: "border-t-cyan-500" },
  { resource: "creditationstatuses", marker: "04", label: "Accreditation statuses", path: "/facilities/reference-data", description: "The current accreditation state for facilities.", tone: "bg-rose-50 text-rose-700", accent: "border-t-rose-500" },
];

function FacilityDashboard() {
  const [counts, setCounts] = useState({});
  const [loading, setLoading] = useState(true);
  useEffect(() => {
    Promise.all(cards.map((card) => getAll(card.resource))).then((responses) => {
      setCounts(Object.fromEntries(responses.map((response, index) => [cards[index].resource, response.data.length])));
    }).catch(console.error).finally(() => setLoading(false));
  }, []);
  return <section aria-labelledby="facility-overview-title">
    <div className="mb-6 flex flex-col gap-1 sm:flex-row sm:items-end sm:justify-between"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">At a glance</p><h2 id="facility-overview-title" className="mt-1 text-2xl font-bold tracking-tight text-[#092a5a]">Ready for accreditation work</h2></div><p className="text-sm text-[#68778c]">Start with facility records, then create surveys against them.</p></div>
    <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{cards.map((card, index) => <Reveal key={card.resource} delay={index * 70}><MetricCard {...card} count={counts[card.resource]} loading={loading} detail={card.resource === "facilities" ? "Ready to receive surveys" : "Controlled reference data"} /></Reveal>)}</div>
    <Reveal delay={180} className="mt-8"><div className="rounded-xl border border-rose-100 bg-[linear-gradient(125deg,#fff7f8_0%,#ffffff_62%)] p-6 shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-rose-700">Directory readiness</p><h2 className="mt-1 text-lg font-bold text-[#092a5a]">Your next accreditation starting point</h2></div><p className="rounded-full bg-white px-3 py-1.5 text-sm font-semibold text-[#4b5f7a]">{loading ? "Checking setup…" : `${Object.values(counts).filter(Boolean).length} of 4 directory areas started`}</p></div><div className="mt-5 h-2 overflow-hidden rounded-full bg-rose-100"><div className="h-full rounded-full bg-rose-500 transition-all duration-700" style={{ width: `${loading ? 0 : (Object.values(counts).filter(Boolean).length / cards.length) * 100}%` }} /></div></div></Reveal>
    <Reveal delay={240} className="mt-8"><div className="rounded-xl border border-[#dfe7f0] bg-white p-6 shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><h2 className="text-lg font-bold text-[#092a5a]">Suggested workflow</h2><ol className="mt-4 grid gap-4 text-sm text-[#4b5f7a] sm:grid-cols-3"><li><span className="mb-2 flex h-7 w-7 items-center justify-center rounded-full bg-[#edf8f0] text-xs font-bold text-[#16803a]">1</span>Set up organisations, facility levels, and accreditation statuses.</li><li><span className="mb-2 flex h-7 w-7 items-center justify-center rounded-full bg-[#edf8f0] text-xs font-bold text-[#16803a]">2</span>Add facilities and place each one in its district.</li><li><span className="mb-2 flex h-7 w-7 items-center justify-center rounded-full bg-[#edf8f0] text-xs font-bold text-[#16803a]">3</span>Use a facility record as the starting point for a survey.</li></ol></div></Reveal>
  </section>;
}
export default FacilityDashboard;
