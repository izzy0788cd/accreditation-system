import { NavLink } from "react-router-dom";

const links = [
  { to: "/", label: "Home", end: true },
  { to: "/framework", label: "Framework" },
];

function Navbar() {
  return (
    <nav className="bg-white border-b px-6 py-3 flex gap-6">
      {links.map((link) => (
        <NavLink
          key={link.to}
          to={link.to}
          end={link.end}
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
  );
}

export default Navbar;