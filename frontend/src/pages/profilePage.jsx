import { useState, useEffect } from "react";
import { getOwnProfile, updateOwnProfile, getAll } from "../api/api";
import { useAuth } from "../context/AuthContext";

function getInitials(firstName, lastName) {
  return `${firstName?.[0] || ""}${lastName?.[0] || ""}`.toUpperCase();
}

function ProfilePage() {
  const { setProfile: setAuthProfile } = useAuth();
  const [profile, setProfile] = useState(null);
  const [organizations, setOrganizations] = useState([]);
  const [isEditing, setIsEditing] = useState(false);
  const [form, setForm] = useState(null);
  const [error, setError] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  const loadProfile = () => {
    getOwnProfile()
      .then((res) => {
        setProfile(res.data);
        setForm(res.data);
      })
      .catch(() => setError("Could not load your profile."));
  };

  useEffect(() => {
    loadProfile();
    getAll("organizations").then((res) => setOrganizations(res.data));
  }, []);

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setIsSubmitting(true);
    try {
      await updateOwnProfile({
        ...form,
        organizationId: Number(form.organizationId),
      });
      const updated = await getOwnProfile();
      setAuthProfile(updated.data);
      setForm(updated.data);
      setIsEditing(false);
    } catch {
      setError("Could not save changes. Check the required fields and try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  if (!profile) {
    return (
      <div className="min-h-[calc(100vh-57px)] bg-gray-50 flex items-center justify-center px-4">
        {error ? (
          <p className="text-sm text-red-700">{error}</p>
        ) : (
          <p className="text-sm text-gray-500">Loading…</p>
        )}
      </div>
    );
  }

  return (
    <main className="min-h-[calc(100vh-57px)] bg-[#f7fbfa] px-4 py-10">
      <div className="mx-auto w-full max-w-2xl">
        <div className="overflow-hidden rounded-2xl border border-[#dbe5ef] bg-white shadow-[0_12px_30px_rgba(20,60,66,0.08)]">
          {/* Identity header */}
          <div className="flex items-center gap-4 border-b border-[#e3eaf2] bg-[linear-gradient(125deg,#eaf3fb_0%,#f8fafc_100%)] px-8 pb-6 pt-8">
            <div className="flex h-14 w-14 shrink-0 items-center justify-center rounded-full bg-[#16803a] text-lg font-semibold text-white">
              {getInitials(profile.firstName, profile.lastName)}
            </div>
            <div className="min-w-0">
              <h1 className="text-lg font-semibold text-gray-900 truncate">
                {profile.firstName} {profile.lastName}
              </h1>
              <p className="text-sm text-gray-500 truncate">
                {profile.position ? `${profile.position} · ` : ""}
                {profile.organizationName}
              </p>
            </div>
            {!isEditing && (
              <button
                onClick={() => setIsEditing(true)}
                className="ml-auto shrink-0 rounded-md border border-[#c5d5e8] px-3 py-1.5 text-sm font-semibold text-[#16803a] hover:bg-[#edf8f0]"
              >
                Edit
              </button>
            )}
          </div>

          <div className="px-8 py-6">
            {error && (
              <div className="mb-6 rounded-md bg-red-50 px-3 py-2 text-sm text-red-700">
                {error}
              </div>
            )}

            {isEditing ? (
              <form onSubmit={handleSubmit} className="space-y-4 [&_input]:rounded-lg [&_input]:border-[#c5d5e8] [&_input:focus]:border-[#16803a] [&_input:focus]:ring-teal-100 [&_select]:rounded-lg [&_select]:border-[#c5d5e8] [&_select:focus]:border-[#16803a] [&_select:focus]:ring-teal-100 [&_textarea]:rounded-lg [&_textarea]:border-[#c5d5e8] [&_textarea:focus]:border-[#16803a] [&_textarea:focus]:ring-teal-100">
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
                    value={form.position || ""}
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
                      value={form.mobile || ""}
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
                    value={form.comments || ""}
                    onChange={handleChange}
                    rows={2}
                    className="mt-1 w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-blue-600"
                  />
                </div>

                <div className="flex gap-3 pt-2">
                  <button
                    type="submit"
                    disabled={isSubmitting}
                    className="flex-1 rounded-lg bg-[#16803a] px-3 py-2.5 text-sm font-semibold text-white hover:bg-[#0d6531] disabled:cursor-not-allowed disabled:opacity-60"
                  >
                    {isSubmitting ? "Saving…" : "Save changes"}
                  </button>
                  <button
                    type="button"
                    onClick={() => {
                      setForm(profile);
                      setIsEditing(false);
                      setError("");
                    }}
                    className="flex-1 rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm font-semibold text-[#4b5f7a] hover:bg-slate-50"
                  >
                    Cancel
                  </button>
                </div>
              </form>
            ) : (
              <dl className="grid grid-cols-2 gap-x-8 gap-y-5 text-sm">
                <div>
                  <dt className="text-gray-500">Email</dt>
                  <dd className="mt-0.5 text-gray-900">{profile.email}</dd>
                </div>
                <div>
                  <dt className="text-gray-500">Phone</dt>
                  <dd className="mt-0.5 text-gray-900">{profile.phone}</dd>
                </div>
                <div>
                  <dt className="text-gray-500">Mobile</dt>
                  <dd className="mt-0.5 text-gray-900">{profile.mobile || "—"}</dd>
                </div>
                <div>
                  <dt className="text-gray-500">Organization</dt>
                  <dd className="mt-0.5 text-gray-900">{profile.organizationName}</dd>
                </div>
                <div className="col-span-2">
                  <dt className="text-gray-500">Comments</dt>
                  <dd className="mt-0.5 text-gray-900">{profile.comments || "—"}</dd>
                </div>
              </dl>
            )}
          </div>
        </div>
      </div>
    </main>
  );
}

export default ProfilePage;
