import { NavLink, useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { Link } from "react-router-dom";

const links = [
  { to: "/", label: "Home", end: true },
  { to: "/framework", label: "Framework" },
];

function Navbar() {
  const { auth, logout, isAuthenticated } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  return (
    <nav className="bg-white border-b px-6 py-3 flex gap-6 items-center">
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

      <div className="ml-auto flex items-center gap-4">
        {isAuthenticated ? (
          <>
            <Link to="/profile" className="text-sm text-gray-600 hover:text-blue-600">
              {auth.username}
            </Link>
            <button
              onClick={handleLogout}
              className="text-sm font-medium text-gray-600 hover:text-blue-600"
            >
              Log out
            </button>
          </>
        ) : (
          <NavLink
            to="/login"
            className={({ isActive }) =>
              `text-sm font-medium ${
                isActive ? "text-blue-600" : "text-gray-600 hover:text-blue-600"
              }`
            }
          >
            Login
          </NavLink>
        )}
      </div>
    </nav>
  );
}

export default Navbar;