import { NavLink, Outlet } from "react-router-dom";

const links = [
  { to: "/facilities/directory", label: "Directory" },
  { to: "/facilities/reference-data", label: "Reference data" },
];

function FacilityPage() {
  return (
    <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:py-8">
      <header className="mb-6 rounded-[1.25rem] border border-[#cde5e0] bg-[linear-gradient(125deg,#e8f5f3_0%,#f8fbfa_58%,#fdf7ea_100%)] px-6 py-7 sm:px-8">
        <p className="mb-2 text-xs font-bold uppercase tracking-[0.18em] text-teal-700">Accreditation system</p>
        <h1 className="text-3xl font-bold tracking-tight text-[#143c42]">Facility directory</h1>
        <p className="mt-2 max-w-2xl text-sm leading-6 text-[#527076]">Maintain the health facilities that will be surveyed and accredited across Papua New Guinea.</p>
      </header>
      <nav aria-label="Facility sections" className="mb-7 flex gap-1 overflow-x-auto border-b border-[#d6e5e2]">
        <NavLink end to="/facilities" className={({ isActive }) => `whitespace-nowrap border-b-2 px-4 py-3 text-sm font-semibold transition ${isActive ? "border-[#087c77] text-[#087c77]" : "border-transparent text-[#668187] hover:text-[#087c77]"}`}>Overview</NavLink>
        {links.map((link) => <NavLink key={link.to} to={link.to} className={({ isActive }) => `whitespace-nowrap border-b-2 px-4 py-3 text-sm font-semibold transition ${isActive ? "border-[#087c77] text-[#087c77]" : "border-transparent text-[#668187] hover:text-[#087c77]"}`}>{link.label}</NavLink>)}
      </nav>
      <Outlet />
    </main>
  );
}

export default FacilityPage;
