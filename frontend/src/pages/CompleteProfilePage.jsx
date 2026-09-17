import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { create, getAll } from "../api/api";
import { useAuth } from "../context/AuthContext";

const inputClass = "mt-1.5 w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm text-[#092a5a] outline-none transition focus:border-[#16803a] focus:ring-2 focus:ring-[#bbf7d0]";

function CompleteProfilePage() {
  const { checkProfile } = useAuth();
  const [organizations, setOrganizations] = useState([]);
  const [form, setForm] = useState({ firstName: "", lastName: "", organizationId: "", position: "", email: "", phone: "", mobile: "", comments: "" });
  const [error, setError] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    getAll("organizations").then((res) => setOrganizations(res.data)).catch(() => setError("Could not load organizations."));
  }, []);

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError("");
    setIsSubmitting(true);
    try {
      await create("users", { ...form, organizationId: Number(form.organizationId) });
      await checkProfile();
      navigate("/");
    } catch {
      setError("Could not save profile. Check the required fields and try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const change = (event) => setForm((current) => ({ ...current, [event.target.name]: event.target.value }));

  return (
    <main className="min-h-[calc(100vh-57px)] bg-[linear-gradient(135deg,#eaf3fb_0%,#f8fafc_55%,#fdf7ea_100%)] px-4 py-8 sm:py-12">
      <div className="mx-auto w-full max-w-3xl overflow-hidden rounded-2xl border border-[#c9dded] bg-white shadow-[0_20px_50px_rgba(20,60,66,0.12)]">
        <div className="h-2 bg-[#16803a]" />
        <header className="border-b border-[#dce7f1] bg-[#f8fbfe] px-6 py-6 sm:px-8">
          <p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Welcome · one final step</p>
          <h1 className="mt-2 text-2xl font-bold tracking-tight text-[#092a5a] sm:text-3xl">Complete your profile</h1>
          <p className="mt-2 max-w-2xl text-sm leading-6 text-[#68778c]">Your details identify you throughout the accreditation workspace and make survey records easier for teams to follow.</p>
        </header>

        <form onSubmit={handleSubmit} className="space-y-6 p-6 sm:p-8">
          {error && <div role="alert" className="rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">{error}</div>}

          <section className="rounded-xl border border-[#d7e5f0] bg-[#fbfdff] p-4 sm:p-5">
            <h2 className="font-bold text-[#092a5a]">Your identity and workplace</h2>
            <p className="mt-1 text-sm text-[#68778c]">Use your professional contact details.</p>
            <div className="mt-5 grid gap-4 sm:grid-cols-2">
              <Field label="First name"><input required name="firstName" value={form.firstName} onChange={change} autoComplete="given-name" className={inputClass} /></Field>
              <Field label="Last name"><input required name="lastName" value={form.lastName} onChange={change} autoComplete="family-name" className={inputClass} /></Field>
              <Field label="Organisation"><select required name="organizationId" value={form.organizationId} onChange={change} className={inputClass}><option value="" disabled>Select an organisation</option>{organizations.map((org) => <option key={org.organizationId} value={org.organizationId}>{org.organizationName}</option>)}</select></Field>
              <Field label="Position"><input name="position" value={form.position} onChange={change} autoComplete="organization-title" className={inputClass} /></Field>
            </div>
          </section>

          <section className="rounded-xl border border-[#d7e5f0] bg-[#fbfdff] p-4 sm:p-5">
            <h2 className="font-bold text-[#092a5a]">Contact details</h2>
            <p className="mt-1 text-sm text-[#68778c]">These help other authorised team members identify and contact you.</p>
            <div className="mt-5 grid gap-4 sm:grid-cols-2">
              <Field label="Email"><input required name="email" type="email" value={form.email} onChange={change} autoComplete="email" className={inputClass} /></Field>
              <Field label="Phone"><input required name="phone" value={form.phone} onChange={change} autoComplete="tel" className={inputClass} /></Field>
              <Field label="Mobile"><input name="mobile" value={form.mobile} onChange={change} autoComplete="tel" className={inputClass} /></Field>
              <Field label="Comments" hint="Optional information for your profile."><textarea name="comments" value={form.comments} onChange={change} rows="2" className={inputClass + " resize-y"} /></Field>
            </div>
          </section>

          <div className="flex flex-col-reverse gap-3 border-t border-[#dce7f1] pt-5 sm:flex-row sm:items-center sm:justify-between">
            <p className="text-xs leading-5 text-[#68778c]">Required fields must be completed before you continue.</p>
            <button type="submit" disabled={isSubmitting} className="rounded-lg bg-[#16803a] px-5 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-[#0d6531] disabled:cursor-not-allowed disabled:opacity-60">{isSubmitting ? "Saving…" : "Save and continue"}</button>
          </div>
        </form>
      </div>
    </main>
  );
}

const Field = ({ label, hint, children }) => <label className="block text-sm font-semibold text-[#153a70]"><span>{label}</span>{children}{hint && <span className="mt-1.5 block text-xs font-normal leading-5 text-[#68778c]">{hint}</span>}</label>;

export default CompleteProfilePage;
