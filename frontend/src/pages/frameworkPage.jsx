import { NavLink, Outlet } from "react-router-dom";

const frameworkLinks = [
  { to: "/framework/functions", label: "Functions" },
  { to: "/framework/components", label: "Components" },
  { to: "/framework/standards", label: "Standards" },
  { to: "/framework/criteria", label: "Criteria" },
  { to: "/framework/compliance", label: "Compliance" },
  { to: "/framework/evidence", label: "Evidence" },
];

function FrameworkPage() {
  return (
    <div className="max-w-6xl mx-auto p-6">
      <h1 className="text-2xl font-bold mb-4">Framework</h1>

      <nav className="flex gap-4 border-b mb-6 pb-2">
        {frameworkLinks.map((link) => (
          <NavLink
            key={link.to}
            to={link.to}
            className={({ isActive }) =>
              `text-sm font-medium ${
                isActive ? "text-blue-600" : "text-gray-600 hover:text-blue-600"
              }`
            }
          >
            {link.label}
          </NavLink>
        ))}
      </nav>

      <Outlet />
    </div>
  );
}

export default FrameworkPage;