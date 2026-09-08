import { NavLink, Outlet } from "react-router-dom";

const locationLinks = [
  { to: "/location/regions", label: "Regions" },
  { to: "/location/provinces", label: "Provinces" },
  { to: "/location/districts", label: "Districts" },
];

function LocationPage() {
  return (
    <div className="max-w-6xl mx-auto p-6">
      <h1 className="text-2xl font-bold mb-4">Location</h1>

      <nav className="flex gap-4 border-b mb-6 pb-2">
        {locationLinks.map((link) => (
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

export default LocationPage;