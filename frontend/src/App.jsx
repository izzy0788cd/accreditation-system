import ReportsRoute from "./components/ReportsRoute";
import SurveyReportsPage from "./pages/reports/SurveyReportsPage";
import { useEffect, useState } from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import ErrorDialog from "./components/ErrorDialog";
import { AuthProvider } from "./context/AuthContext";
import ProtectedRoute from "./components/ProtectedRoute";
import AdminRoute from "./components/AdminRoute";
import LoginPage from "./pages/loginPage";
import Navbar from "./components/Navbar";
import HomePage from "./pages/homePage";
import FrameworkPage from "./pages/FrameworkPage";
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
import AdminUsersPage from "./pages/admin/AdminUsersPage";
import SurveysPage from "./pages/surveys/SurveysPage";
import SurveyAssessmentPage from "./pages/surveys/SurveyAssessmentPage";
import SurveySetupPage from "./pages/surveys/SurveySetupPage";
import SurveyAdminPage from "./pages/surveys/SurveyAdminPage";
import SurveyResultsPage from "./pages/surveys/SurveyResultsPage";
import SurveyTeamLeadDashboardPage from "./pages/surveys/SurveyTeamLeadDashboardPage";

function App() {
  const [saveError, setSaveError] = useState("");
  useEffect(() => { const showError = (event) => setSaveError(event.detail); window.addEventListener("api-save-error", showError); return () => window.removeEventListener("api-save-error", showError); }, []);
  return (
    <AuthProvider>
      <BrowserRouter>
        <Navbar />
        <ErrorDialog message={saveError} onClose={() => setSaveError("")} />
        <Routes>
          <Route path="/reports" element={<ProtectedRoute><ReportsRoute><SurveyReportsPage /></ReportsRoute></ProtectedRoute>} />
          <Route path="/login" element={<LoginPage />} />
          <Route path="/" element={<ProtectedRoute><HomePage /></ProtectedRoute>} />
          <Route path="/complete-profile" element={<ProtectedRoute><CompleteProfilePage /></ProtectedRoute>} />
          <Route path="/profile" element={<ProtectedRoute><ProfilePage /></ProtectedRoute>} />
          <Route path="/admin/users" element={<ProtectedRoute><AdminRoute><AdminUsersPage /></AdminRoute></ProtectedRoute>} />
          <Route path="/surveys" element={<ProtectedRoute><SurveysPage /></ProtectedRoute>} />
          <Route path="/surveys/setup" element={<ProtectedRoute><AdminRoute><SurveySetupPage /></AdminRoute></ProtectedRoute>} />
          <Route path="/surveys/:surveyId/admin" element={<ProtectedRoute><AdminRoute><SurveyAdminPage /></AdminRoute></ProtectedRoute>} />
          <Route path="/surveys/:surveyId/team-dashboard" element={<ProtectedRoute><SurveyTeamLeadDashboardPage /></ProtectedRoute>} />
          <Route path="/surveys/:surveyId/results" element={<ProtectedRoute><SurveyResultsPage /></ProtectedRoute>} />
          <Route path="/surveys/:surveyId" element={<ProtectedRoute><SurveyAssessmentPage /></ProtectedRoute>} />

          <Route path="/framework" element={<ProtectedRoute><FrameworkPage /></ProtectedRoute>}>
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

          <Route path="/location" element={<ProtectedRoute><LocationPage /></ProtectedRoute>}>
            <Route index element={<LocationDashboard />} />
            <Route path="regions" element={<RegionsPage />} />
            <Route path="provinces" element={<ProvincesPage />} />
            <Route path="districts" element={<DistrictsPage />} />
          </Route>
          <Route path="/facilities" element={<ProtectedRoute><FacilityPage /></ProtectedRoute>}>
            <Route index element={<FacilityDashboard />} />
            <Route path="directory" element={<FacilitiesPage />} />
            <Route path="directory/:facilityId" element={<FacilityDetailPage />} />
            <Route path="reference-data" element={<ReferenceDataPage />} />
          </Route>
          <Route path="*" element={<ProtectedRoute><NotFoundPage /></ProtectedRoute>} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}

export default App;
