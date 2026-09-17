import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { getAll } from "../api/api";
import AnimatedNumber from "../components/AnimatedNumber";
import Reveal from "../components/Reveal";
import { STANDARD_23_FAMILY, countDashboardStandards, isStandard23Child } from "../utils/standardFamilies";
import { compareReferenceNumber } from "../utils/numberSort";

const entities = [
  { resource: "functions", label: "Functions", path: "/framework/functions", hasApplicability: false, marker: "01", description: "Highest-level responsibilities", tone: "bg-[#edf8f0] text-[#16803a]", accent: "border-t-[#16803a]" },
  { resource: "components", label: "Components", path: "/framework/components", hasApplicability: false, marker: "02", description: "Operational building blocks", tone: "bg-cyan-50 text-cyan-700", accent: "border-t-cyan-500" },
  { resource: "standards", label: "Standards", path: "/framework/standards", hasApplicability: false, marker: "03", description: "NHSS reference standards", tone: "bg-amber-50 text-amber-700", accent: "border-t-amber-500" },
  { resource: "criteria", label: "Criteria", path: "/framework/criteria", hasApplicability: true, marker: "04", description: "Measurable standard requirements", tone: "bg-lime-50 text-lime-700", accent: "border-t-lime-500" },
  { resource: "compliances", label: "Compliance", path: "/framework/compliance", hasApplicability: true, marker: "05", description: "Expected compliance outcomes", tone: "bg-sky-50 text-sky-700", accent: "border-t-sky-500" },
  { resource: "evidence", label: "Evidence", path: "/framework/evidence", hasApplicability: true, marker: "06", description: "Evidence used for assessment", tone: "bg-orange-50 text-orange-700", accent: "border-t-orange-500" },
];

function FrameworkDashboard() {
  const [stats, setStats] = useState({});
  const [breakdown, setBreakdown] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadDashboard = async () => {
      try {
        setLoading(true);

        const [
          functionsRes,
          componentsRes,
          standardsRes,
          criteriaRes,
          compliancesRes,
          evidenceRes,
        ] = await Promise.all([
          getAll("functions"),
          getAll("components"),
          getAll("standards"),
          getAll("criteria"),
          getAll("compliances"),
          getAll("evidence"),
        ]);

        const dataByResource = {
          functions: functionsRes.data,
          components: componentsRes.data,
          standards: standardsRes.data,
          criteria: criteriaRes.data,
          compliances: compliancesRes.data,
          evidence: evidenceRes.data,
        };

        // Entity stats (totals + applicability breakdown)
        const statsResult = {};
        entities.forEach((e) => {
          const data = dataByResource[e.resource];
          const total = e.resource === "standards" ? countDashboardStandards(data) : data.length;
          const applicable = e.hasApplicability
            ? data.filter((item) => item.isApplicable).length
            : null;
          statsResult[e.resource] = { total, applicable };
        });
        setStats(statsResult);

        // Standard-level breakdown
        const standards = dataByResource.standards;
        const criteria = dataByResource.criteria;
        const compliances = dataByResource.compliances;
        const evidence = dataByResource.evidence;

        const detailedBreakdown = standards.map((s) => {
          const criteriaUnderStandard = criteria.filter((c) => c.standardId === s.standardId);
          const criterionIds = criteriaUnderStandard.map((c) => c.criterionId);

          const complianceUnderStandard = compliances.filter((co) =>
            criterionIds.includes(co.criterionId)
          );
          const complianceIds = complianceUnderStandard.map((co) => co.complianceId);

          const evidenceUnderStandard = evidence.filter((ev) =>
            complianceIds.includes(ev.complianceId)
          );

          return {
            standardId: s.standardId,
            standardNumber: s.standardNumber,
            standardTitle: s.standardTitle,
            criteriaCount: criteriaUnderStandard.length,
            complianceCount: complianceUnderStandard.length,
            evidenceCount: evidenceUnderStandard.length,
          };
        });

        const specialtyRows = detailedBreakdown.filter((row) => isStandard23Child(row.standardNumber));
        const breakdownResult = [
          ...detailedBreakdown.filter((row) => !isStandard23Child(row.standardNumber)),
          ...(specialtyRows.length ? [{
            standardId: "standard-family-23",
            standardNumber: STANDARD_23_FAMILY.number,
            standardTitle: STANDARD_23_FAMILY.title,
            criteriaCount: specialtyRows.reduce((sum, row) => sum + row.criteriaCount, 0),
            complianceCount: specialtyRows.reduce((sum, row) => sum + row.complianceCount, 0),
            evidenceCount: specialtyRows.reduce((sum, row) => sum + row.evidenceCount, 0),
            childStandards: specialtyRows,
          }] : []),
        ];

        breakdownResult.sort((a, b) => compareReferenceNumber(a.standardNumber, b.standardNumber));

        setBreakdown(breakdownResult);
      } catch (err) {
        console.error("Failed to load dashboard", err);
      } finally {
        setLoading(false);
      }
    };

    loadDashboard();
  }, []);

  const maxCount = Math.max(1, ...entities.map((e) => stats[e.resource]?.total ?? 0));

  return (
    <section aria-labelledby="framework-overview-title">
      <div className="mb-6 flex flex-col gap-1 sm:flex-row sm:items-end sm:justify-between"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">At a glance</p><h2 id="framework-overview-title" className="mt-1 text-2xl font-bold tracking-tight text-[#092a5a]">Framework coverage</h2></div><p className="text-sm text-[#68778c]">A live view of the accreditation reference framework.</p></div>
      <div className="mb-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {entities.map((e, index) => {
          const stat = stats[e.resource];
          return (
            <Reveal key={e.resource} delay={index * 55}>
            <Link
              to={e.path}
              className={`group flex min-h-[224px] flex-col rounded-xl border border-[#dfe7f0] border-t-4 ${e.accent} bg-white p-5 shadow-[0_8px_24px_rgba(20,60,66,0.06)] transition duration-200 hover:-translate-y-0.5 hover:border-[#8bb7dd] hover:shadow-[0_14px_28px_rgba(8,124,119,0.12)]`}
            >
              <div className="flex items-start justify-between gap-3"><div className={`flex h-10 min-w-10 items-center justify-center rounded-lg text-xs font-bold ${e.tone}`}>{e.marker}</div><span className="rounded-full bg-[#f6f9fc] px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-[#68778c]">Layer {e.marker}</span></div>
              <p className="mt-5 text-sm font-semibold text-[#4b5f7a]">{e.label}</p>
              <p className="mt-1 text-4xl font-bold tracking-tight text-[#092a5a]"><AnimatedNumber loading={loading} value={stat?.total ?? 0} /></p>
              <p className="mt-2 text-xs leading-5 text-[#68778c]">{e.description}</p>
              <div className="mt-auto border-t border-[#e7edf4] pt-3">{e.hasApplicability && !loading && stat ? <p className="text-xs text-[#4b5f7a]"><span className="font-bold text-emerald-700">{stat.applicable}</span> applicable <span className="mx-1 text-[#c5d5e8]">•</span><span className="font-semibold">{stat.total - stat.applicable}</span> excluded</p> : <p className="text-xs font-medium text-[#68778c]">Reference layer</p>}<p className="mt-2 text-xs font-semibold text-[#16803a]">Manage records <span aria-hidden="true">→</span></p></div>
            </Link></Reveal>
          );
        })}
      </div>

      <div className="mb-8 rounded-xl border border-[#dfe7f0] bg-white p-5 shadow-[0_8px_24px_rgba(20,60,66,0.06)] sm:p-6"><div className="mb-5"><h2 className="text-lg font-bold text-[#092a5a]">Framework composition</h2><p className="mt-1 text-sm text-[#68778c]">The number of records at each layer of the framework.</p></div><div className="space-y-4">
        {entities.map((e) => {
          const stat = stats[e.resource];
          const total = stat?.total ?? 0;
          const widthPercent = loading ? 0 : (total / maxCount) * 100;

          return (
            <div key={e.resource} className="flex items-center gap-3">
              <span className="w-24 shrink-0 text-sm font-medium text-[#4b5f7a]">{e.label}</span>
              <div className="relative h-2 flex-1 overflow-hidden rounded-full bg-[#e6f0ee]">
                <div
                  className="h-full rounded-full bg-[#16803a] transition-all duration-500"
                  style={{ width: `${widthPercent}%` }}
                />
              </div>
              <span className="w-10 shrink-0 text-right text-sm font-bold text-[#092a5a]">
                {loading ? "…" : total}
              </span>
            </div>
          );
        })}
      </div></div>
      <div className="overflow-hidden rounded-xl border border-[#dfe7f0] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><div className="border-b border-[#e3eaf2] px-5 py-5 sm:px-6"><h2 className="text-lg font-bold text-[#092a5a]">Standards breakdown</h2><p className="mt-1 text-sm text-[#68778c]">Criteria, compliance requirements, and evidence grouped by standard. Lettered specialty sections are combined under Standard 23.</p></div>
      {loading ? <div className="space-y-3 p-6">{[1, 2, 3].map((row) => <div key={row} className="h-10 animate-pulse rounded bg-slate-100" />)}</div> : <div className="overflow-x-auto"><table className="w-full min-w-[680px] text-sm">
          <thead>
            <tr className="border-b border-[#dbe5ef] bg-[#f6f9fc] text-left text-xs uppercase tracking-wider text-[#4b5f7a]">
              <th className="px-6 py-3.5 font-semibold">Standard</th><th className="px-6 py-3.5 text-right font-semibold">Criteria</th><th className="px-6 py-3.5 text-right font-semibold">Compliance</th><th className="px-6 py-3.5 text-right font-semibold">Evidence</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-[#e7edf4]">
            {breakdown.map((row) => (
              <tr key={row.standardId} className="hover:bg-[#f5f9fd]">
                <td className="px-6 py-4 font-semibold">
                  {row.childStandards ? <><span className="text-[#092a5a]">{row.standardNumber} — {row.standardTitle}</span><span className="mt-1 block text-xs font-normal text-[#68778c]">{row.childStandards.length} lettered specialty sections</span></> : <Link to={`/framework/standards/${row.standardId}`} className="text-[#16803a] hover:underline">{row.standardNumber} — {row.standardTitle}</Link>}
                </td>
                <td className="px-6 py-4 text-right font-medium text-[#4b5f7a]">{row.criteriaCount}</td><td className="px-6 py-4 text-right font-medium text-[#4b5f7a]">{row.complianceCount}</td><td className="px-6 py-4 text-right font-medium text-[#4b5f7a]">{row.evidenceCount}</td>
              </tr>
            ))}
          </tbody>
        </table></div>}</div>
    </section>
  );
}

export default FrameworkDashboard;
