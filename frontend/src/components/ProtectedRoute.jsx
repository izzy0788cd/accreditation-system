import { Navigate, useLocation } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

function ProtectedRoute({ children }) {
  const { isAuthenticated, hasProfile, isInitializing } = useAuth();
  const location = useLocation();

  if (isInitializing) return <div className="flex min-h-[calc(100vh-57px)] items-center justify-center bg-[#f7fbfa] text-sm font-medium text-[#527076]">Restoring your session…</div>;

  if (!isAuthenticated) return <Navigate to="/login" replace />;

  if (!hasProfile && location.pathname !== "/complete-profile") {
    return <Navigate to="/complete-profile" replace />;
  }

  return children;
}

export default ProtectedRoute;
