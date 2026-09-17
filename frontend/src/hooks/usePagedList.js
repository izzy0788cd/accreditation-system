import { useCallback, useEffect, useState } from "react";
import { getPage } from "../api/api";

// Standard state and loading lifecycle for server-paged reference lists.
export default function usePagedList(resource, initial = {}) {
  const [query, setQuery] = useState({ page: 1, pageSize: 25, search: "", sort: "", direction: "asc", ...initial });
  const [result, setResult] = useState({ items: [], total: 0, page: 1, pageSize: 25 });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const reload = useCallback(async () => {
    setLoading(true);
    try {
      const { data } = await getPage(resource, query);
      setResult(data);
      setError("");
    } catch {
      setError("Could not load this list. Please retry.");
    } finally { setLoading(false); }
  }, [resource, query]);

  useEffect(() => { reload(); }, [reload]);
  const updateQuery = (next) => setQuery((current) => ({ ...current, ...next, page: next.page ?? 1 }));
  return { ...result, query, updateQuery, reload, loading, error };
}
