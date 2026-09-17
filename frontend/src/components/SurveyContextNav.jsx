import { Link, useLocation } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { isAdmin, isTeamLead } from "../utils/access";

export default function SurveyContextNav({ surveyId, className = "" }) {
  const { auth } = useAuth();
  const location = useLocation();
  const role = auth?.roleName;
  const links = [
    { to: `/surveys/${surveyId}`, label: "Assessment" },
    { to: `/surveys/${surveyId}/results`, label: role === "Surveyor" ? "My results" : "Results" },
    { to: `/surveys/${surveyId}/report`, label: "Surveyor report" },
    ...(isTeamLead(role) || isAdmin(role) ? [{ to: `/surveys/${surveyId}/team-dashboard`, label: "Team dashboard" }] : []),
    ...(isAdmin(role) ? [{ to: `/surveys/${surveyId}/admin`, label: "Survey administration" }] : []),
  ];
  return <nav aria-label="Survey workspace" className={`print:hidden mt-4 flex gap-2 overflow-x-auto border-b border-[#dbe5ef] pb-3 ${className}`}>
    {links.map((link) => <Link key={link.to} to={link.to} className={`shrink-0 rounded-lg px-3 py-2 text-sm font-semibold transition ${location.pathname === link.to ? "bg-[#edf8f0] text-[#16803a]" : "border border-[#c5d5e8] bg-white text-[#4b5f7a] hover:bg-[#f3faf8] hover:text-[#16803a]"}`}>{link.label}</Link>)}
  </nav>;
}
