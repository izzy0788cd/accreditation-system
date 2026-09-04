import { useState, useEffect } from "react";
import { getOwnProfile, updateOwnProfile, getAll } from "../api/api";

function getInitials(firstName, lastName) {
  return `${firstName?.[0] || ""}${lastName?.[0] || ""}`.toUpperCase();
}

function ProfilePage() {
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
      loadProfile();
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
    <div className="min-h-[calc(100vh-57px)] bg-gray-50 px-4 py-10">
      <div className="mx-auto w-full max-w-2xl">
        <div className="bg-white border border-gray-200 rounded-lg shadow-sm overflow-hidden">
          {/* Identity header */}
          <div className="px-8 pt-8 pb-6 border-b border-gray-100 flex items-center gap-4">
            <div className="h-14 w-14 shrink-0 rounded-full bg-blue-600 text-white flex items-center justify-center text-lg font-semibold">
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
                className="ml-auto shrink-0 text-sm font-medium text-blue-600 hover:text-blue-700"
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
              <form onSubmit={handleSubmit} className="space-y-4">
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
                    className="flex-1 rounded-md bg-blue-600 px-3 py-2 text-sm font-medium text-white hover:bg-blue-700 disabled:opacity-60 disabled:cursor-not-allowed"
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
                    className="flex-1 rounded-md border border-gray-300 px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
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
    </div>
  );
}

export default ProfilePage;