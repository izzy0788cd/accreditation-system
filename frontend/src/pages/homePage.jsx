import { Link } from "react-router-dom";

function HomePage() {
  return (
    <div className="max-w-3xl mx-auto p-6 text-center">
      <h1 className="text-3xl font-bold mb-4">
        Accreditation System
      </h1>
      <p className="text-gray-600">
        Manage Functions, Components, Standards, Criteria, Compliance, and Evidence
        for the National Health Service Standards Volume 2 (Papua New Guinea).
      </p>

      <br />

      <Link to={"/framework"} className="inline-block bg-blue-600 text-white px-6 py-3 rounded hover:bg-blue-700">Go to Framework</Link>

    </div>
  );
}

export default HomePage;