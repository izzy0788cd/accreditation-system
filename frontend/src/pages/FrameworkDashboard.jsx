import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { getAll } from "../api/api";

const entities = [
    { resource: "functions", label: "Functions", path: "/framework/functions" },
    { resource: "components", label: "Components", path: "/framework/components" },
    { resource: "standards", label: "Standards", path: "/framework/standards" },
    { resource: "criteria", label: "Criteria", path: "/framework/criteria" },
    { resource: "compliances", label: "Compliance", path: "/framework/compliance" },
    { resource: "evidence", label: "Evidence", path: "/framework/evidence" },
];

function FrameworkDashboard() {
  const [counts, setCounts] = useState({});
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadCounts = async () => {
      const results = await Promise.all(
        entities.map(async (e) => {
          try {
            const res = await getAll(e.resource);
            return [e.resource, res.data.length];
          } catch (err) {
            console.error(`Failed to load ${e.resource}`, err);
            return [e.resource, null];
          }
        })
      );
      setCounts(Object.fromEntries(results));
      setLoading(false);
    };

    loadCounts();
  }, []);

  return (
    <div>
      <h2 className="text-xl font-semibold mb-4">Overview</h2>
      <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
        {entities.map((e) => (
          <Link
            key={e.resource}
            to={e.path}
            className="border rounded-lg p-4 hover:shadow-md transition"
          >
            <p className="text-sm text-gray-500">{e.label}</p>
            <p className="text-2xl font-bold">
              {loading ? "…" : counts[e.resource] ?? "—"}
            </p>
          </Link>
        ))}
      </div>
    </div>
  );
}

export default FrameworkDashboard;