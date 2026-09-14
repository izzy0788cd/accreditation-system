import { useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import logo from "../assets/pictures/logo/accreditation-system-logo3.png";

function LoginPage() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const requestedPath = new URLSearchParams(location.search).get("returnTo");
  const returnTo = requestedPath?.startsWith("/") && !requestedPath.startsWith("//") ? requestedPath : "/";

const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setIsSubmitting(true);
    try {
      const hasProfile = await login(username, password);
      navigate(hasProfile ? returnTo : "/complete-profile", { replace: true });
    } catch {
      setError("Incorrect username or password.");
    } finally {
      setIsSubmitting(false);
    }
};

  return (
    <main className="relative flex min-h-screen items-center justify-center overflow-hidden bg-[linear-gradient(135deg,#eaf3fb_0%,#f8fafc_52%,#fdf7ea_100%)] px-4 py-10">
      <div className="pointer-events-none absolute -left-24 -top-24 h-72 w-72 rounded-full bg-[#bbf7d0]/30 blur-3xl" />
      <div className="pointer-events-none absolute -bottom-28 -right-16 h-80 w-80 rounded-full bg-amber-200/35 blur-3xl" />
      <div className="relative grid w-full max-w-4xl overflow-hidden rounded-[1.75rem] border border-white/80 bg-white/90 shadow-[0_24px_70px_rgba(20,60,66,0.16)] backdrop-blur sm:grid-cols-[.9fr_1.1fr]">
        <section className="flex flex-col items-center justify-center bg-[#092a5a] px-8 py-10 text-center text-white sm:px-10">
          <img src={logo} alt="National Health Care Accreditation Programme" className="h-44 w-44 rounded-full bg-white object-contain p-1 shadow-[0_12px_30px_rgba(0,0,0,0.22)]" />
          <p className="mt-6 text-xs font-bold uppercase tracking-[0.2em] text-[#bbf7d0]">Papua New Guinea</p>
          <h1 className="mt-2 text-2xl font-bold tracking-tight">National Health Care Accreditation Programme</h1>
          <p className="mt-3 max-w-xs text-sm leading-6 text-slate-200">A single workspace for accreditation surveys, evidence, standards, and improvement.</p>
        </section>
        <section className="p-7 sm:p-10">
          <p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Secure access</p>
          <h2 className="mt-2 text-2xl font-bold tracking-tight text-[#092a5a]">Sign in</h2>
          <p className="mt-2 text-sm leading-6 text-[#68778c]">Use your account to continue to the accreditation workspace.</p>

          {error && (
            <div className="mt-4 rounded-md bg-red-50 px-3 py-2 text-sm text-red-700">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="mt-7 space-y-4">
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
                className="mt-1.5 w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm text-[#092a5a] outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]"
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
                className="mt-1.5 w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm text-[#092a5a] outline-none focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]"
              />
            </div>

            <button
              type="submit"
              disabled={isSubmitting}
              className="w-full rounded-lg bg-[#16803a] px-3 py-2.5 text-sm font-semibold text-white transition hover:bg-[#0d6531] disabled:cursor-not-allowed disabled:opacity-60"
            >
              {isSubmitting ? "Signing in…" : "Sign in"}
            </button>
          </form>
        </section>
      </div>
    </main>
  );
}

export default LoginPage;
