import { Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { canGenerateReports } from "../utils/surveyReports";

export default function ReportsRoute({ children }) {
  const { auth, isInitializing } = useAuth();
  if (isInitializing) return <p className="p-8">Restoring your session…</p>;
  return canGenerateReports(auth?.roleName) ? children : <Navigate to="/" replace />;
}
