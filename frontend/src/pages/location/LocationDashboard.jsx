import { useEffect, useState } from "react";
import { getAll } from "../../api/api";
import Reveal from "../../components/Reveal";
import MetricCard from "../../components/MetricCard";

const entities = [
  { resource: "regions", marker: "01", label: "Regions", singular: "region", description: "Top-level areas across Papua New Guinea.", path: "/location/regions", tone: "bg-[#edf8f0] text-[#16803a]", accent: "border-t-[#16803a]" },
  { resource: "provinces", marker: "02", label: "Provinces", singular: "province", description: "Province-level divisions within each region.", path: "/location/provinces", tone: "bg-amber-50 text-amber-700", accent: "border-t-amber-500" },
  { resource: "districts", marker: "03", label: "Districts", singular: "district", description: "Local areas used to locate health facilities.", path: "/location/districts", tone: "bg-cyan-50 text-cyan-700", accent: "border-t-cyan-500" },
];

function LocationDashboard() {
  const [stats, setStats] = useState({});
  const [breakdown, setBreakdown] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadDashboard = async () => {
      try {
        setLoading(true);

        const [regionsRes, provincesRes, districtsRes] = await Promise.all([
          getAll("regions"),
          getAll("provinces"),
          getAll("districts"),
        ]);

        const dataByResource = {
          regions: regionsRes.data,
          provinces: provincesRes.data,
          districts: districtsRes.data,
        };

        const statsResult = {};
        entities.forEach((e) => {
          statsResult[e.resource] = { total: dataByResource[e.resource].length };
        });
        setStats(statsResult);

        const regions = dataByResource.regions;
        const provinces = dataByResource.provinces;
        const districts = dataByResource.districts;

        const breakdownResult = regions.map((r) => {
          const provincesUnderRegion = provinces.filter((p) => p.regionId === r.regionId);
          const provinceIds = provincesUnderRegion.map((p) => p.provinceId);

          const districtsUnderRegion = districts.filter((d) =>
            provinceIds.includes(d.provinceId)
          );

          return {
            regionId: r.regionId,
            regionName: r.regionName,
            provinceCount: provincesUnderRegion.length,
            districtCount: districtsUnderRegion.length,
          };
        });

        breakdownResult.sort((a, b) => a.regionName.localeCompare(b.regionName));

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
    <section aria-labelledby="location-overview-title">
      <div className="mb-6 flex flex-col gap-1 sm:flex-row sm:items-end sm:justify-between">
        <div>
          <p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">At a glance</p>
          <h2 id="location-overview-title" className="mt-1 text-2xl font-bold tracking-tight text-[#092a5a]">Geographic Coverage</h2>
        </div>
        <p className="text-sm text-[#68778c]">A live view of your location directory.</p>
      </div>
      <div className="mb-8 grid gap-4 sm:grid-cols-3">
        {entities.map((e, index) => {
          const stat = stats[e.resource];
          return <Reveal key={e.resource} delay={index * 70}><MetricCard {...e} count={stat?.total} loading={loading} footer={`Manage ${e.singular}s`} /></Reveal>;
        })}
      </div>

      <div className="mb-8 rounded-xl border border-[#dfe7f0] bg-white p-5 shadow-[0_8px_24px_rgba(20,60,66,0.06)] sm:p-6">
        <div className="mb-5"><h2 className="text-lg font-bold text-[#092a5a]">Directory Composition</h2><p className="mt-1 text-sm text-[#68778c]">How the location records are distributed across each level.</p></div>
        <div className="space-y-4">
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
        </div>
      </div>
      <div className="overflow-hidden rounded-xl border border-[#dfe7f0] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]">
        <div className="border-b border-[#e3eaf2] px-5 py-5 sm:px-6"><h2 className="text-lg font-bold text-[#092a5a]">Regional Breakdown</h2><p className="mt-1 text-sm text-[#68778c]">Provinces and districts grouped by region.</p></div>
      {loading ? <div className="space-y-3 p-6">{[1, 2, 3].map((row) => <div key={row} className="h-10 animate-pulse rounded bg-slate-100" />)}</div>
      : breakdown.length === 0 ? <p className="px-6 py-12 text-center text-sm text-[#68778c]">Add a region to see its breakdown here.</p>
      : <div className="overflow-x-auto"><table className="w-full min-w-[500px] text-sm">
          <thead>
            <tr className="border-b border-[#dbe5ef] bg-[#f6f9fc] text-left text-xs uppercase tracking-wider text-[#4b5f7a]">
              <th className="px-6 py-3.5 font-semibold">Region</th>
              <th className="px-6 py-3.5 text-right font-semibold">Provinces</th>
              <th className="px-6 py-3.5 text-right font-semibold">Districts</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-[#e7edf4]">
            {breakdown.map((row) => (
              <tr key={row.regionId} className="hover:bg-[#f5f9fd]">
                <td className="px-6 py-4 font-semibold text-[#092a5a]">{row.regionName}</td>
                <td className="px-6 py-4 text-right font-medium text-[#4b5f7a]">{row.provinceCount}</td>
                <td className="px-6 py-4 text-right font-medium text-[#4b5f7a]">{row.districtCount}</td>
              </tr>
            ))}
          </tbody>
        </table></div>}
      </div>
    </section>
  );
}

export default LocationDashboard;
