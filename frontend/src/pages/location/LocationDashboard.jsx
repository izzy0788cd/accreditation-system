import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { getAll } from "../../api/api";

const entities = [
  { resource: "regions", label: "Regions", path: "/location/regions" },
  { resource: "provinces", label: "Provinces", path: "/location/provinces" },
  { resource: "districts", label: "Districts", path: "/location/districts" },
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
    <div>
      <h2 className="text-xl font-semibold mb-4">Overview</h2>

      <div className="grid grid-cols-2 sm:grid-cols-3 gap-4 mb-8">
        {entities.map((e) => {
          const stat = stats[e.resource];
          return (
            <Link
              key={e.resource}
              to={e.path}
              className="border rounded-lg p-4 hover:shadow-md transition"
            >
              <p className="text-sm text-gray-500">{e.label}</p>
              <p className="text-2xl font-bold">
                {loading ? "…" : stat?.total ?? "—"}
              </p>
            </Link>
          );
        })}
      </div>

      <h2 className="text-xl font-semibold mb-4">Counts by Entity</h2>

      <div className="space-y-3 mb-8">
        {entities.map((e) => {
          const stat = stats[e.resource];
          const total = stat?.total ?? 0;
          const widthPercent = loading ? 0 : (total / maxCount) * 100;

          return (
            <div key={e.resource} className="flex items-center gap-3">
              <span className="w-24 text-sm text-gray-600 shrink-0">{e.label}</span>
              <div className="flex-1 bg-gray-100 rounded h-6 relative overflow-hidden">
                <div
                  className="bg-blue-600 h-full rounded transition-all duration-500"
                  style={{ width: `${widthPercent}%` }}
                />
              </div>
              <span className="w-10 text-sm font-semibold text-right shrink-0">
                {loading ? "…" : total}
              </span>
            </div>
          );
        })}
      </div>

      <h2 className="text-xl font-semibold mb-4">Breakdown by Region</h2>

      {loading ? (
        <p>Loading...</p>
      ) : (
        <table className="w-full border-collapse">
          <thead>
            <tr className="border-b text-left">
              <th className="p-2">Region</th>
              <th className="p-2 text-right">Provinces</th>
              <th className="p-2 text-right">Districts</th>
            </tr>
          </thead>
          <tbody>
            {breakdown.map((row) => (
              <tr key={row.regionId} className="border-b">
                <td className="p-2">{row.regionName}</td>
                <td className="p-2 text-right">{row.provinceCount}</td>
                <td className="p-2 text-right">{row.districtCount}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}

export default LocationDashboard;