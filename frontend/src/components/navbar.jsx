import { canGenerateReports } from "../utils/surveyReports";
import { useEffect, useState } from "react";
import { NavLink, useLocation, useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { Link } from "react-router-dom";
import logo from "../assets/pictures/logo/accreditation-system-logo3.png";

const links = [
  { to: "/", label: "Home", end: true },
  { to: "/framework", label: "Framework" },
  { to: "/location", label: "Location" },
  { to: "/facilities", label: "Facilities" },
  { to: "/surveys", label: "Surveys" },
];

function Navbar() {
  const { auth, profile, logout, isAuthenticated } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const [menuOpen, setMenuOpen] = useState(false);
  const [darkMode, setDarkMode] = useState(() => localStorage.getItem("accreditation-colour-mode") === "dark");
  const displayName = [profile?.firstName, profile?.lastName].filter(Boolean).join(" ");
  const navigationLinks = auth?.roleName === "Admin" ? [...links, { to: "/admin/users", label: "Admin" }] : auth?.roleName === "Viewer" ? links.filter((link) => link.to !== "/surveys") : links;

  useEffect(() => { setMenuOpen(false); }, [location.pathname]);
  useEffect(() => {
    const closeOnEscape = (event) => { if (event.key === "Escape") setMenuOpen(false); };
    window.addEventListener("keydown", closeOnEscape);
    return () => window.removeEventListener("keydown", closeOnEscape);
  }, []);
  useEffect(() => {
    document.documentElement.classList.toggle("dark", darkMode);
    localStorage.setItem("accreditation-colour-mode", darkMode ? "dark" : "light");
  }, [darkMode]);

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  if (location.pathname === "/login") return null;

  return (
    <nav className="print:hidden sticky top-0 z-40 border-b border-[#dbe5ef] bg-white/95 shadow-sm backdrop-blur">
      <div className="mx-auto flex max-w-7xl items-center gap-4 px-4 py-3 sm:px-6">
        <NavLink to="/" end onClick={() => setMenuOpen(false)} className="mr-1 flex shrink-0 items-center gap-2.5" aria-label="National Health Care Accreditation Programme home">
          <img src={logo} alt="National Health Care Accreditation Programme" className="h-10 w-10 rounded-full object-contain shadow-sm" />
          <span className="hidden leading-tight md:block"><span className="block text-xs font-bold uppercase tracking-[0.12em] text-[#16803a]">PNG Health</span><span className="block text-sm font-bold tracking-tight text-[#092a5a]">Accreditation Programme</span></span>
        </NavLink>
        <button onClick={() => setMenuOpen((open) => !open)} className="ml-auto inline-flex h-11 w-11 items-center justify-center rounded-xl border border-[#c5d5e8] bg-white text-[#16803a] shadow-sm transition hover:bg-[#edf8f0] focus:outline-none focus:ring-2 focus:ring-[#16803a] focus:ring-offset-2 sm:hidden" aria-expanded={menuOpen} aria-controls="mobile-navigation" aria-label={menuOpen ? "Close navigation" : "Open navigation"}><span className="sr-only">{menuOpen ? "Close" : "Open"} navigation</span><span className="text-2xl leading-none" aria-hidden="true">{menuOpen ? "×" : "☰"}</span></button>
        {menuOpen && <button aria-label="Close navigation" onClick={() => setMenuOpen(false)} className="fixed inset-0 top-[65px] z-0 bg-[#092a5a]/20 backdrop-blur-[1px] sm:hidden" />}
        <div id="mobile-navigation" className={`${menuOpen ? "flex" : "hidden"} absolute left-3 right-3 top-[calc(100%+0.5rem)] z-10 flex-col gap-1 rounded-2xl border border-[#c5d5e8] bg-white p-3 shadow-[0_18px_36px_rgba(9,42,90,0.18)] sm:static sm:flex sm:min-w-0 sm:flex-row sm:items-center sm:overflow-x-auto sm:rounded-none sm:border-0 sm:bg-transparent sm:p-0 sm:shadow-none`}>
          <p className="px-3 pb-2 pt-1 text-xs font-bold uppercase tracking-[0.14em] text-[#16803a] sm:hidden">Navigation</p>
          {[...navigationLinks, ...(canGenerateReports(auth?.roleName) ? [{ to: "/reports", label: "Reports" }] : [])].map((link) => (
            <NavLink
              key={link.to}
              to={link.to}
              end={link.end}
              onClick={() => setMenuOpen(false)}
              className={({ isActive }) => `whitespace-nowrap rounded-md px-3 py-2 text-sm font-semibold transition ${isActive ? "bg-[#edf8f0] text-[#16803a]" : "text-[#68778c] hover:bg-slate-50 hover:text-[#16803a]"}`}
            >
              {link.label}
            </NavLink>
          ))}
          {isAuthenticated && <div className="mt-2 flex flex-wrap items-center justify-between gap-2 border-t border-[#e3eaf2] pt-3 sm:hidden"><Link to="/profile" onClick={() => setMenuOpen(false)} className="text-sm font-semibold text-[#4b5f7a]">{displayName || auth?.username}</Link><div className="flex items-center gap-2"><button onClick={() => setDarkMode((enabled) => !enabled)} className="rounded-md border border-[#c5d5e8] px-3 py-1.5 text-sm font-semibold text-[#4b5f7a]">{darkMode ? "Light mode" : "Dark mode"}</button><button onClick={() => { setMenuOpen(false); handleLogout(); }} className="rounded-md border border-[#c5d5e8] px-3 py-1.5 text-sm font-semibold text-[#16803a]">Log out</button></div></div>}
        </div>
        <div className="ml-auto hidden shrink-0 items-center gap-2 sm:flex sm:gap-3">
        {isAuthenticated ? (
          <>
            <button onClick={() => setDarkMode((enabled) => !enabled)} className="rounded-md border border-[#c5d5e8] px-3 py-1.5 text-sm font-semibold text-[#4b5f7a] transition hover:bg-slate-50 hover:text-[#16803a]">{darkMode ? "Light mode" : "Dark mode"}</button>
            <Link to="/profile" className="max-w-28 truncate rounded-md px-2 py-2 text-sm font-semibold text-[#4b5f7a] transition hover:bg-slate-50 hover:text-[#16803a] sm:max-w-none">
              {displayName || auth?.username}
            </Link>
            <button
              onClick={handleLogout}
              className="rounded-md border border-[#c5d5e8] px-3 py-1.5 text-sm font-semibold text-[#16803a] transition hover:bg-[#edf8f0]"
            >
              Log out
            </button>
          </>
        ) : (
          <NavLink
            to="/login"
            className={({ isActive }) => `rounded-md px-3 py-1.5 text-sm font-semibold transition ${isActive ? "bg-[#edf8f0] text-[#16803a]" : "text-[#68778c] hover:bg-slate-50 hover:text-[#16803a]"}`}
          >
            Login
          </NavLink>
        )}
        </div>
      </div>
    </nav>
  );
}

export default Navbar;
