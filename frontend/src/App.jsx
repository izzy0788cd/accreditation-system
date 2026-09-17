import ReportsRoute from "./components/ReportsRoute";
import { lazy, Suspense, useEffect, useState } from "react";
import { BrowserRouter, Routes, Route, useLocation } from "react-router-dom";
import ErrorDialog from "./components/ErrorDialog";
import { AuthProvider } from "./context/AuthContext";
import ProtectedRoute from "./components/ProtectedRoute";
import AdminRoute from "./components/AdminRoute";
import RoleRoute from "./components/RoleRoute";
import LoginPage from "./pages/loginPage";
import Navbar from "./components/navbar";
import HomePage from "./pages/homePage";
import FrameworkPage from "./pages/frameworkPage";
import FrameworkDashboard from "./pages/FrameworkDashboard";
import ComponentsPage from "./pages/framework/ComponentsPage";
import FunctionsPage from "./pages/framework/FunctionsPage";
import "./App.css";
import StandardsPage from "./pages/framework/StandardsPage";
import CriteriaPage from "./pages/framework/CriteriaPage";
import CompliancePage from "./pages/framework/CompliancePage";
import StandardDetailPage from "./pages/framework/StandardDetailPage";
import CriterionDetailPage from "./pages/framework/CriterionDetailPage";
import EvidencePage from "./pages/framework/EvidencePage";
import ComplianceDetailPage from "./pages/framework/ComplianceDetail";
import CompleteProfilePage from "./pages/CompleteProfilePage";
import ProfilePage from "./pages/profilePage";
import LocationPage from "./pages/location/LocationPage";
import RegionsPage from "./pages/location/RegionsPage";
import ProvincesPage from "./pages/location/ProvincesPage";
import DistrictsPage from "./pages/location/DistrictsPage";
import LocationDashboard from "./pages/location/LocationDashboard";
import FacilityPage from "./pages/facilities/FacilityPage";
import FacilityDashboard from "./pages/facilities/FacilityDashboard";
import FacilitiesPage from "./pages/facilities/FacilitiesPage";
import FacilityDetailPage from "./pages/facilities/FacilityDetailPage";
import ReferenceDataPage from "./pages/facilities/ReferenceDataPage";
import NotFoundPage from "./pages/NotFoundPage";
import { roleGroups } from "./utils/access";

const SurveyReportsPage = lazy(() => import("./pages/reports/SurveyReportsPage"));
const ReportsCentrePage = lazy(() => import("./pages/reports/ReportsCentrePage"));
const SurveyActionPlanPage = lazy(() => import("./pages/reports/SurveyActionPlanPage"));
const AdminUsersPage = lazy(() => import("./pages/admin/AdminUsersPage"));
const SurveysPage = lazy(() => import("./pages/surveys/SurveysPage"));
const SurveyAssessmentPage = lazy(() => import("./pages/surveys/SurveyAssessmentPage"));
const SurveySetupPage = lazy(() => import("./pages/surveys/SurveySetupPage"));
const ToolkitBuilderPage = lazy(() => import("./pages/surveys/ToolkitBuilderPage"));
const SurveyAdminPage = lazy(() => import("./pages/surveys/SurveyAdminPage"));
const SurveyResultsPage = lazy(() => import("./pages/surveys/SurveyResultsPage"));
const SurveyTeamLeadDashboardPage = lazy(() => import("./pages/surveys/SurveyTeamLeadDashboardPage"));
const SurveyorReportPage = lazy(() => import("./pages/surveys/SurveyorReportPage"));

const RouteLoading = () => <div className="flex min-h-[calc(100vh-57px)] items-center justify-center bg-[#f7f9fc] text-sm font-medium text-[#4b5f7a]">Loading workspace…</div>;

const pageTitles = [
  ["/login", "Sign in"],
  ["/surveys/setup", "Survey setup"],
  ["/surveys/toolkits", "Toolkit builder"],
  ["/surveys", "Surveys"],
  ["/framework", "Standards framework"],
  ["/location", "Location directory"],
  ["/facilities", "Facility directory"],
  ["/admin", "User administration"],
  ["/profile", "My profile"],
];

function PageTitle() {
  const { pathname } = useLocation();
  useEffect(() => {
    const match = pageTitles.find(([path]) => pathname === path || pathname.startsWith(`${path}/`));
    const label = match?.[1] || "Accreditation dashboard";
    document.title = `${label} | NHCA Programme`;
  }, [pathname]);
  return null;
}

function App() {
  const [saveError, setSaveError] = useState("");
  useEffect(() => { const showError = (event) => setSaveError(event.detail); window.addEventListener("api-save-error", showError); return () => window.removeEventListener("api-save-error", showError); }, []);
  return (
    <AuthProvider>
      <BrowserRouter>
        <PageTitle />
        <a href="#main-content" className="skip-link">Skip to main content</a>
        <Navbar />
        <ErrorDialog message={saveError} onClose={() => setSaveError("")} />
        <Suspense fallback={<RouteLoading />}>
        <div id="main-content" tabIndex="-1">
        <Routes>
          <Route path="/reports" element={<ProtectedRoute><ReportsRoute><ReportsCentrePage /></ReportsRoute></ProtectedRoute>} />
          <Route path="/reports/survey" element={<ProtectedRoute><ReportsRoute><SurveyReportsPage /></ReportsRoute></ProtectedRoute>} />
          <Route path="/reports/actions" element={<ProtectedRoute><ReportsRoute><SurveyActionPlanPage /></ReportsRoute></ProtectedRoute>} />
          <Route path="/login" element={<LoginPage />} />
          <Route path="/" element={<ProtectedRoute><HomePage /></ProtectedRoute>} />
          <Route path="/complete-profile" element={<ProtectedRoute><CompleteProfilePage /></ProtectedRoute>} />
          <Route path="/profile" element={<ProtectedRoute><ProfilePage /></ProtectedRoute>} />
          <Route path="/admin/users" element={<ProtectedRoute><AdminRoute><AdminUsersPage /></AdminRoute></ProtectedRoute>} />
          <Route path="/surveys" element={<ProtectedRoute><RoleRoute allowedRoles={roleGroups.surveyWorkspace}><SurveysPage /></RoleRoute></ProtectedRoute>} />
          <Route path="/surveys/setup" element={<ProtectedRoute><AdminRoute><SurveySetupPage /></AdminRoute></ProtectedRoute>} />
          <Route path="/surveys/toolkits" element={<ProtectedRoute><AdminRoute><ToolkitBuilderPage /></AdminRoute></ProtectedRoute>} />
          <Route path="/surveys/:surveyId/admin" element={<ProtectedRoute><AdminRoute><SurveyAdminPage /></AdminRoute></ProtectedRoute>} />
          <Route path="/surveys/:surveyId/team-dashboard" element={<ProtectedRoute><RoleRoute allowedRoles={roleGroups.surveyReview}><SurveyTeamLeadDashboardPage /></RoleRoute></ProtectedRoute>} />
          <Route path="/surveys/:surveyId/results" element={<ProtectedRoute><RoleRoute allowedRoles={roleGroups.surveyWorkspace}><SurveyResultsPage /></RoleRoute></ProtectedRoute>} />
          <Route path="/surveys/:surveyId/report" element={<ProtectedRoute><RoleRoute allowedRoles={roleGroups.surveyWorkspace}><SurveyorReportPage /></RoleRoute></ProtectedRoute>} />
          <Route path="/surveys/:surveyId" element={<ProtectedRoute><RoleRoute allowedRoles={roleGroups.surveyWorkspace}><SurveyAssessmentPage /></RoleRoute></ProtectedRoute>} />

          <Route path="/framework" element={<ProtectedRoute><RoleRoute allowedRoles={roleGroups.reference}><FrameworkPage /></RoleRoute></ProtectedRoute>}>
            <Route index element={<FrameworkDashboard />} />
            <Route path="functions" element={<FunctionsPage />} />
            <Route path="components" element={<ComponentsPage />} />
            <Route path="standards" element={<StandardsPage />} />
            <Route path="standards/:standardId" element={<StandardDetailPage />} />
            <Route path="criteria" element={<CriteriaPage />} />
            <Route path="criteria/:criterionId" element={<CriterionDetailPage />} />
            <Route path="compliance" element={<CompliancePage />} />
            <Route path="compliance/:complianceId" element={<ComplianceDetailPage />} />
            <Route path="evidence" element={<EvidencePage />} />
          </Route>

          <Route path="/location" element={<ProtectedRoute><RoleRoute allowedRoles={roleGroups.reference}><LocationPage /></RoleRoute></ProtectedRoute>}>
            <Route index element={<LocationDashboard />} />
            <Route path="regions" element={<RegionsPage />} />
            <Route path="provinces" element={<ProvincesPage />} />
            <Route path="districts" element={<DistrictsPage />} />
          </Route>
          <Route path="/facilities" element={<ProtectedRoute><RoleRoute allowedRoles={roleGroups.reference}><FacilityPage /></RoleRoute></ProtectedRoute>}>
            <Route index element={<FacilityDashboard />} />
            <Route path="directory" element={<FacilitiesPage />} />
            <Route path="directory/:facilityId" element={<FacilityDetailPage />} />
            <Route path="reference-data" element={<ReferenceDataPage />} />
          </Route>
          <Route path="*" element={<ProtectedRoute><NotFoundPage /></ProtectedRoute>} />
        </Routes>
        </div>
        </Suspense>
      </BrowserRouter>
    </AuthProvider>
  );
}

export default App;
