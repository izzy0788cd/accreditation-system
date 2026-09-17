export default function Pagination({ page, pageSize = 10, total, onPageChange }) {
  const pages = Math.max(1, Math.ceil(total / pageSize));
  if (total <= pageSize) return null;
  return <nav aria-label="Pagination" className="flex items-center justify-between gap-3 border-t border-[#e7edf4] px-5 py-3 text-sm"><span className="text-[#68778c]">Page {page} of {pages}</span><div className="flex gap-2"><button type="button" disabled={page <= 1} onClick={() => onPageChange(page - 1)} className="rounded-lg border border-[#c5d5e8] bg-white px-3 py-1.5 font-semibold text-[#16803a] disabled:cursor-not-allowed disabled:opacity-40">Previous</button><button type="button" disabled={page >= pages} onClick={() => onPageChange(page + 1)} className="rounded-lg border border-[#c5d5e8] bg-white px-3 py-1.5 font-semibold text-[#16803a] disabled:cursor-not-allowed disabled:opacity-40">Next</button></div></nav>;
}
