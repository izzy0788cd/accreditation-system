import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { getAll } from "../api/api";

const entities = [
  { resource: "functions", label: "Functions", path: "/framework/functions", hasApplicability: false },
  { resource: "components", label: "Components", path: "/framework/components", hasApplicability: false },
  { resource: "standards", label: "Standards", path: "/framework/standards", hasApplicability: false },
  { resource: "criteria", label: "Criteria", path: "/framework/criteria", hasApplicability: true },
  { resource: "compliances", label: "Compliance", path: "/framework/compliance", hasApplicability: true },
  { resource: "evidence", label: "Evidence", path: "/framework/evidence", hasApplicability: true },
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
          const total = data.length;
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

        const breakdownResult = standards.map((s) => {
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

        breakdownResult.sort((a, b) =>
          a.standardNumber.localeCompare(b.standardNumber, undefined, { numeric: true })
        );

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
              {e.hasApplicability && !loading && stat && (
                <p className="text-xs text-gray-500 mt-1">
                  <span className="text-green-600 font-medium">{stat.applicable}</span> applicable,{" "}
                  <span className="text-gray-500 font-medium">
                    {stat.total - stat.applicable}
                  </span>{" "}
                  not applicable
                </p>
              )}
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

      <h2 className="text-xl font-semibold mb-4">Breakdown by Standard</h2>

      {loading ? (
        <p>Loading...</p>
      ) : (
        <table className="w-full border-collapse">
          <thead>
            <tr className="border-b text-left">
              <th className="p-2">Standard</th>
              <th className="p-2 text-right">Criteria</th>
              <th className="p-2 text-right">Compliance</th>
              <th className="p-2 text-right">Evidence</th>
            </tr>
          </thead>
          <tbody>
            {breakdown.map((row) => (
              <tr key={row.standardId} className="border-b">
                <td className="p-2">
                  <Link
                    to={`/framework/standards/${row.standardId}`}
                    className="text-blue-600 hover:underline"
                  >
                    {row.standardNumber} — {row.standardTitle}
                  </Link>
                </td>
                <td className="p-2 text-right">{row.criteriaCount}</td>
                <td className="p-2 text-right">{row.complianceCount}</td>
                <td className="p-2 text-right">{row.evidenceCount}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}

export default FrameworkDashboard;