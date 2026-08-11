import { BrowserRouter, Routes, Route } from "react-router-dom";
import Navbar from "./components/Navbar";
import HomePage from "./pages/HomePage";
import FrameworkPage from "./pages/FrameworkPage";
import FrameworkDashboard from "./pages/FrameworkDashboard";
import ComponentsPage from "./pages/framework/ComponentsPage";
import FunctionsPage from "./pages/framework/FunctionsPage";
import "./App.css";
import StandardsPage from "./pages/framework/StandardsPage";
import CriteriaPage from "./pages/framework/CriteriaPage";
import StandardDetailPage from "./pages/framework/StandardDetailPage";

function App() {
  return (
    <BrowserRouter>
      <Navbar />
      <Routes>
        <Route path="/" element={<HomePage />} />

        <Route path="/framework" element={<FrameworkPage />}>
          <Route index element={<FrameworkDashboard />} />
          <Route path="functions" element={<FunctionsPage />} />
          <Route path="components" element={<ComponentsPage />} />
          <Route path="standards" element={<StandardsPage />} />
          <Route path="standards/:standardId" element={<StandardDetailPage />} />
          <Route path="criteria" element={<CriteriaPage />} />
          {/* add as built: standards, criteria, compliance, evidence */}
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;