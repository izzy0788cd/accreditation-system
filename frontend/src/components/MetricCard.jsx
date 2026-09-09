import { Link } from "react-router-dom";
import AnimatedNumber from "./AnimatedNumber";

function MetricCard({ to, path, marker, label, count, loading, description, tone, accent, footer = "Open directory", detail }) {
  const destination = to ?? path;

  return <Link to={destination} className={`group flex min-h-[224px] flex-col rounded-xl border border-[#e2ecea] border-t-4 ${accent} bg-white p-5 shadow-[0_8px_24px_rgba(20,60,66,0.06)] transition duration-200 hover:-translate-y-0.5 hover:border-[#8bc8be] hover:shadow-[0_14px_28px_rgba(8,124,119,0.12)]`}>
    <div className="flex items-start justify-between gap-3"><div className={`flex h-10 min-w-10 items-center justify-center rounded-lg text-xs font-bold ${tone}`}>{marker}</div><span className="rounded-full bg-[#f5faf9] px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-[#668187]">{marker}</span></div>
    <p className="mt-5 text-sm font-semibold text-[#527076]">{label}</p>
    <p className="mt-1 text-4xl font-bold tracking-tight text-[#143c42]"><AnimatedNumber loading={loading} value={count ?? 0} /></p>
    <p className="mt-2 text-xs leading-5 text-[#668187]">{description}</p>
    <div className="mt-auto border-t border-[#e7efed] pt-3">{detail ? <p className="text-xs font-medium text-[#527076]">{detail}</p> : <p className="text-xs font-medium text-[#668187]">Live directory data</p>}<p className="mt-2 text-xs font-semibold text-[#087c77] group-hover:text-[#05635f]">{footer} <span aria-hidden="true">→</span></p></div>
  </Link>;
}

export default MetricCard;
