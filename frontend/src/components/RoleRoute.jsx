import { Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

function RoleRoute({ allowedRoles, children }) {
  const { auth, isInitializing } = useAuth();

  if (isInitializing) {
    return <div className="flex min-h-[calc(100vh-57px)] items-center justify-center bg-[#f7f9fc] text-sm font-medium text-[#4b5f7a]">Restoring your session…</div>;
  }

  if (!allowedRoles.includes(auth?.roleName)) {
    return <Navigate to="/" replace />;
  }

  return children;
}

export default RoleRoute;
