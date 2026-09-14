import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { getAll, create } from "../api/api";
import { useAuth } from "../context/AuthContext";

function CompleteProfilePage() {
    const { checkProfile } = useAuth();
    const [organizations, setOrganizations] = useState([]);
    const [form, setForm] = useState({
        firstName: "",
        lastName: "",
        organizationId: "",
        position: "",
        email: "",
        phone: "",
        mobile: "",
        comments: "",
    });
    const [error, setError] = useState("");
    const [isSubmitting, setIsSubmitting] = useState(false);
    const navigate = useNavigate();

    useEffect(() => {
        getAll("organizations")
        .then((res) => setOrganizations(res.data))
        .catch(() => setError("Could not load organizations."));
    }, []);

    const handleChange = (e) => {
        setForm({ ...form, [e.target.name]: e.target.value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError("");
        setIsSubmitting(true);
        try {
            await create("users", {
                ...form,
                organizationId: Number(form.organizationId),
            });
            await checkProfile();
            navigate("/");
        } catch {
            setError("Could not save profile. Check the required fields and try again.");
        } finally {
            setIsSubmitting(false);
        }
    };

  return (
    <main className="flex min-h-[calc(100vh-57px)] items-center justify-center bg-[linear-gradient(135deg,#eaf3fb_0%,#f8fafc_55%,#fdf7ea_100%)] px-4 py-8">
      <div className="w-full max-w-md">
        <div className="rounded-2xl border border-[#c9dded] bg-white p-8 shadow-[0_20px_50px_rgba(20,60,66,0.12)]"><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">One final step</p><h1 className="mt-2 text-2xl font-bold tracking-tight text-[#092a5a]">Complete your profile</h1><p className="mt-2 text-sm text-[#68778c]">This information identifies you when you work with accreditation data.</p>

          {error && (
            <div className="mt-4 rounded-md bg-red-50 px-3 py-2 text-sm text-red-700">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="mt-6 space-y-4 [&_input]:rounded-lg [&_input]:border-[#c5d5e8] [&_input:focus]:border-[#16803a] [&_input:focus]:ring-teal-100 [&_select]:rounded-lg [&_select]:border-[#c5d5e8] [&_select:focus]:border-[#16803a] [&_select:focus]:ring-teal-100 [&_textarea]:rounded-lg [&_textarea]:border-[#c5d5e8] [&_textarea:focus]:border-[#16803a] [&_textarea:focus]:ring-teal-100">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700">
                  First name
                </label>
                <input
                  name="firstName"
                  value={form.firstName}
                  onChange={handleChange}
                  required
                  className="mt-1 w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-blue-600"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">
                  Last name
                </label>
                <input
                  name="lastName"
                  value={form.lastName}
                  onChange={handleChange}
                  required
                  className="mt-1 w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-blue-600"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700">
                Organization
              </label>
              <select
                name="organizationId"
                value={form.organizationId}
                onChange={handleChange}
                required
                className="mt-1 w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-blue-600"
              >
                <option value="" disabled>
                  Select an organization
                </option>
                {organizations.map((org) => (
                  <option key={org.organizationId} value={org.organizationId}>
                    {org.organizationName}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700">
                Position
              </label>
              <input
                name="position"
                value={form.position}
                onChange={handleChange}
                className="mt-1 w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-blue-600"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700">
                Email
              </label>
              <input
                name="email"
                type="email"
                value={form.email}
                onChange={handleChange}
                required
                className="mt-1 w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-blue-600"
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700">
                  Phone
                </label>
                <input
                  name="phone"
                  value={form.phone}
                  onChange={handleChange}
                  required
                  className="mt-1 w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-blue-600"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">
                  Mobile
                </label>
                <input
                  name="mobile"
                  value={form.mobile}
                  onChange={handleChange}
                  className="mt-1 w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-blue-600"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700">
                Comments
              </label>
              <textarea
                name="comments"
                value={form.comments}
                onChange={handleChange}
                rows={2}
                className="mt-1 w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-blue-600"
              />
            </div>

            <button
              type="submit"
              disabled={isSubmitting}
              className="w-full rounded-lg bg-[#16803a] px-3 py-2.5 text-sm font-semibold text-white hover:bg-[#0d6531] disabled:cursor-not-allowed disabled:opacity-60"
            >
              {isSubmitting ? "Saving…" : "Save and continue"}
            </button>
          </form>
        </div>
      </div>
    </main>
  );
}

export default CompleteProfilePage;
