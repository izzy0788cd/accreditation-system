import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

function LoginPage() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setIsSubmitting(true);
    try {
      const hasProfile = await login(username, password);
      navigate(hasProfile ? "/" : "/complete-profile");
    } catch {
      setError("Incorrect username or password.");
    } finally {
      setIsSubmitting(false);
    }
};

  return (
    <main className="flex min-h-[calc(100vh-57px)] items-center justify-center bg-[linear-gradient(135deg,#e8f5f3_0%,#f8fbfa_55%,#fdf7ea_100%)] px-4 py-10">
      <div className="w-full max-w-sm">
        <div className="rounded-2xl border border-[#cde5e0] bg-white p-8 shadow-[0_20px_50px_rgba(20,60,66,0.12)]"><div className="mb-6 flex h-11 w-11 items-center justify-center rounded-xl bg-[#087c77] text-lg font-bold text-white">A</div>
          <p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Accreditation system</p><h1 className="mt-2 text-2xl font-bold tracking-tight text-[#143c42]">Sign in</h1><p className="mt-2 text-sm text-[#668187]">Use your account to continue managing the accreditation workspace.</p>

          {error && (
            <div className="mt-4 rounded-md bg-red-50 px-3 py-2 text-sm text-red-700">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="mt-6 space-y-4">
            <div>
              <label
                htmlFor="username"
                className="block text-sm font-medium text-gray-700"
              >
                Username
              </label>
              <input
                id="username"
                type="text"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                required
                autoFocus
                className="mt-1.5 w-full rounded-lg border border-[#b9d6d1] px-3 py-2.5 text-sm text-[#143c42] outline-none focus:border-[#087c77] focus:ring-2 focus:ring-teal-100"
              />
            </div>

            <div>
              <label
                htmlFor="password"
                className="block text-sm font-medium text-gray-700"
              >
                Password
              </label>
              <input
                id="password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                className="mt-1.5 w-full rounded-lg border border-[#b9d6d1] px-3 py-2.5 text-sm text-[#143c42] outline-none focus:border-[#087c77] focus:ring-2 focus:ring-teal-100"
              />
            </div>

            <button
              type="submit"
              disabled={isSubmitting}
              className="w-full rounded-lg bg-[#087c77] px-3 py-2.5 text-sm font-semibold text-white transition hover:bg-[#05635f] disabled:cursor-not-allowed disabled:opacity-60"
            >
              {isSubmitting ? "Signing in…" : "Sign in"}
            </button>
          </form>
        </div>
      </div>
    </main>
  );
}

export default LoginPage;
