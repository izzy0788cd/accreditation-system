import { NavLink, Outlet } from "react-router-dom";

const locationLinks = [
  { to: "/location/regions", label: "Regions" },
  { to: "/location/provinces", label: "Provinces" },
  { to: "/location/districts", label: "Districts" },
];

function LocationPage() {
  return (
    <main className="mx-auto max-w-6xl px-4 py-6 sm:px-6 lg:py-8">
      <header className="mb-6 rounded-[1.25rem] border border-[#c9dded] bg-[linear-gradient(125deg,#eaf3fb_0%,#f8fafc_58%,#fdf7ea_100%)] px-6 py-7 sm:px-8">
        <p className="mb-2 text-xs font-bold uppercase tracking-[0.18em] text-[#16803a]">Accreditation System</p>
        <h1 className="text-3xl font-bold tracking-tight text-[#092a5a]">Location Directory</h1>
        <p className="mt-2 max-w-2xl text-sm leading-6 text-[#4b5f7a]">Build the geographic foundation for Papua New Guinea health service accreditation, from regions through to districts.</p>
      </header>
      <nav aria-label="Location sections" className="mb-7 flex gap-1 overflow-x-auto border-b border-[#d8e4f0]">
        <NavLink end to="/location" className={({ isActive }) => `whitespace-nowrap border-b-2 px-4 py-3 text-sm font-semibold transition ${isActive ? "border-[#16803a] text-[#16803a]" : "border-transparent text-[#68778c] hover:text-[#16803a]"}`}>Overview</NavLink>
        {locationLinks.map((link) => (
          <NavLink
            key={link.to}
            to={link.to}
            className={({ isActive }) => `whitespace-nowrap border-b-2 px-4 py-3 text-sm font-semibold transition ${isActive ? "border-[#16803a] text-[#16803a]" : "border-transparent text-[#68778c] hover:text-[#16803a]"}`}
          >
            {link.label}
          </NavLink>
        ))}
      </nav>

      <Outlet />
    </main>
  );
}

export default LocationPage;
