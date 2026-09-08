import { NavLink, Outlet } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { canManageReferenceData } from "../utils/access";

const frameworkLinks = [
  { to: "/framework/functions", label: "Functions" },
  { to: "/framework/components", label: "Components" },
  { to: "/framework/standards", label: "Standards" },
  { to: "/framework/criteria", label: "Criteria" },
  { to: "/framework/compliance", label: "Compliance" },
  { to: "/framework/evidence", label: "Evidence" },
];

function FrameworkPage() {
  const { auth } = useAuth();
  const canManage = canManageReferenceData(auth?.roleName);
  return (
    <main data-framework-admin={canManage} className="framework-workspace mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:py-8">
      <header className="mb-6 rounded-[1.25rem] border border-[#cde5e0] bg-[linear-gradient(125deg,#e8f5f3_0%,#f8fbfa_58%,#fdf7ea_100%)] px-6 py-7 sm:px-8">
        <p className="mb-2 text-xs font-bold uppercase tracking-[0.18em] text-teal-700">Accreditation system</p>
        <h1 className="text-3xl font-bold tracking-tight text-[#143c42]">Standards framework</h1>
        <p className="mt-2 max-w-3xl text-sm leading-6 text-[#527076]">Maintain the NHSS framework from high-level functions through to the evidence used in accreditation assessments.</p>
      </header>
      {!canManage && <p className="mb-5 rounded-lg border border-sky-100 bg-sky-50 px-4 py-3 text-sm text-sky-800">You have read-only access to the standards framework.</p>}
      <nav aria-label="Framework sections" className="mb-7 flex gap-1 overflow-x-auto border-b border-[#d6e5e2]">
        <NavLink end to="/framework" className={({ isActive }) => `whitespace-nowrap border-b-2 px-4 py-3 text-sm font-semibold transition ${isActive ? "border-[#087c77] text-[#087c77]" : "border-transparent text-[#668187] hover:text-[#087c77]"}`}>Overview</NavLink>
        {frameworkLinks.map((link) => (
          <NavLink
            key={link.to}
            to={link.to}
            className={({ isActive }) => `whitespace-nowrap border-b-2 px-4 py-3 text-sm font-semibold transition ${isActive ? "border-[#087c77] text-[#087c77]" : "border-transparent text-[#668187] hover:text-[#087c77]"}`}
          >
            {link.label}
          </NavLink>
        ))}
      </nav>

      <Outlet />
    </main>
  );
}

export default FrameworkPage;
