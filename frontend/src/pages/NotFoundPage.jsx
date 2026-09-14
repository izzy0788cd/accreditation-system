import { Link } from "react-router-dom";

function NotFoundPage() {
  return <main className="mx-auto flex min-h-[60vh] max-w-2xl items-center px-4 py-10 sm:px-6"><section className="w-full rounded-2xl border border-[#c9dded] bg-[linear-gradient(125deg,#eaf3fb_0%,#f8fafc_70%)] p-8 text-center sm:p-12"><p className="text-xs font-bold uppercase tracking-[0.18em] text-[#16803a]">404</p><h1 className="mt-3 text-3xl font-bold tracking-tight text-[#092a5a]">That page is not available</h1><p className="mx-auto mt-3 max-w-md text-sm leading-6 text-[#4b5f7a]">The address may be incorrect, or the record you were viewing may have been removed.</p><Link to="/" className="mt-7 inline-flex rounded-lg bg-[#16803a] px-5 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-[#0d6531]">Return home</Link></section></main>;
}

export default NotFoundPage;
