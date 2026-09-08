import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import ProtectedRoute from "./components/ProtectedRoute";
import LoginPage from "./pages/loginPage";
import Navbar from "./components/Navbar";
import HomePage from "./pages/HomePage";
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

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Navbar />
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route path="/" element={<ProtectedRoute><HomePage /></ProtectedRoute>} />
          <Route path="/complete-profile" element={<ProtectedRoute><CompleteProfilePage /></ProtectedRoute>} />
          <Route path="/profile" element={<ProtectedRoute><ProfilePage /></ProtectedRoute>} />

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
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}

export default App;