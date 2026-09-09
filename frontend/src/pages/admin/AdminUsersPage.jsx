import { useEffect, useMemo, useState } from "react";
import { create, getAll, update } from "../../api/api";
import FormModal from "../../components/FormModal";

const inputClass = "w-full rounded-lg border border-[#b9d6d1] bg-white px-3 py-2.5 text-sm outline-none focus:border-[#087c77] focus:ring-2 focus:ring-teal-100";

function AdminUsersPage() {
  const [accounts, setAccounts] = useState([]);
  const [users, setUsers] = useState([]);
  const [roles, setRoles] = useState([]);
  const [organizations, setOrganizations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [query, setQuery] = useState("");
  const [status, setStatus] = useState("all");
  const [creating, setCreating] = useState(false);
  const [editing, setEditing] = useState(null);

  const load = async () => {
    try {
      setLoading(true);
      const [accountResponse, userResponse, roleResponse, organisationResponse] = await Promise.all([
        getAll("userAccounts"), getAll("users"), getAll("roles"), getAll("organizations"),
      ]);
      setAccounts(accountResponse.data);
      setUsers(userResponse.data);
      setRoles(roleResponse.data);
      setOrganizations(organisationResponse.data);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { load(); }, []);

  const records = useMemo(() => accounts.map((account) => {
    const user = users.find((item) => item.userAccountId === account.userAccountId);
    return { ...account, user, displayName: user ? `${user.firstName} ${user.lastName}`.trim() : "Profile pending" };
  }), [accounts, users]);

  const visibleRecords = records.filter((record) => {
    const haystack = `${record.displayName} ${record.username} ${record.roleName} ${record.user?.organizationName || ""}`.toLowerCase();
    return (status === "all" || (status === "active" ? record.isActive : !record.isActive)) && haystack.includes(query.toLowerCase());
  });

  const saveNewUser = async (form) => {
    const accountResponse = await create("userAccounts", {
      username: form.username.trim(), temporaryPassword: form.temporaryPassword, roleId: Number(form.roleId),
    });
    await create("users/admin-create", {
      userAccountId: accountResponse.data.userAccountId,
      firstName: form.firstName.trim(), lastName: form.lastName.trim(), organizationId: Number(form.organizationId),
      position: form.position.trim(), email: form.email.trim(), phone: form.phone.trim(), mobile: form.mobile.trim(), comments: form.comments.trim(),
    });
    setCreating(false);
    await load();
  };

  const saveUser = async (form) => {
    await update("userAccounts", editing.userAccountId, { roleId: Number(form.roleId), isActive: form.isActive });
    if (editing.user) {
      await update("users", editing.user.userId, {
        firstName: form.firstName.trim(), lastName: form.lastName.trim(), organizationId: Number(form.organizationId),
        position: form.position.trim(), email: form.email.trim(), phone: form.phone.trim(), mobile: form.mobile.trim(), comments: form.comments.trim(),
      });
    } else {
      await create("users/admin-create", {
        userAccountId: editing.userAccountId,
        firstName: form.firstName.trim(), lastName: form.lastName.trim(), organizationId: Number(form.organizationId),
        position: form.position.trim(), email: form.email.trim(), phone: form.phone.trim(), mobile: form.mobile.trim(), comments: form.comments.trim(),
      });
    }
    setEditing(null);
    await load();
  };

  const activeCount = records.filter((record) => record.isActive).length;
  const pendingCount = records.filter((record) => !record.user).length;

  return <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6"><section aria-labelledby="admin-users-title"><div className="rounded-2xl border border-[#cde5e0] bg-[linear-gradient(125deg,#e8f5f3_0%,#f8fbfa_70%)] p-6 sm:p-8"><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Administration</p><div className="mt-2 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between"><div><h1 id="admin-users-title" className="text-3xl font-bold tracking-tight text-[#143c42]">User management</h1><p className="mt-2 max-w-2xl text-sm leading-6 text-[#527076]">Create accounts, maintain user profiles, assign roles, and control access to the accreditation system.</p></div><button onClick={() => setCreating(true)} className="inline-flex shrink-0 justify-center rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-[#05635f]">+ Add user</button></div></div><div className="mt-6 grid gap-4 sm:grid-cols-3"><Metric label="User accounts" value={records.length} tone="text-teal-700" /><Metric label="Active access" value={activeCount} tone="text-emerald-700" /><Metric label="Profiles pending" value={pendingCount} tone="text-amber-700" /></div><div className="mt-6 overflow-hidden rounded-xl border border-[#e2ecea] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><div className="flex flex-col gap-3 border-b border-[#e1ecea] p-5 lg:flex-row lg:items-center lg:justify-between"><div><h2 className="font-bold text-[#143c42]">Accounts and access</h2><p className="mt-1 text-sm text-[#668187]">Only Administrators can manage users and roles.</p></div><div className="flex flex-col gap-2 sm:flex-row"><input value={query} onChange={(event) => setQuery(event.target.value)} placeholder="Search users" className={`${inputClass} sm:w-56`} /><select value={status} onChange={(event) => setStatus(event.target.value)} className={inputClass}><option value="all">All statuses</option><option value="active">Active</option><option value="inactive">Inactive</option></select></div></div>{loading ? <div className="space-y-3 p-6">{[1, 2, 3].map((item) => <div key={item} className="h-14 animate-pulse rounded bg-slate-100" />)}</div> : visibleRecords.length === 0 ? <p className="p-10 text-center text-sm text-[#668187]">No user accounts match these filters.</p> : <div className="overflow-x-auto"><table className="w-full min-w-[850px] text-left text-sm"><thead className="border-b border-[#dce9e7] bg-[#f5faf9] text-xs uppercase tracking-wider text-[#527076]"><tr><th className="px-6 py-3.5">User</th><th className="px-6 py-3.5">Organisation</th><th className="px-6 py-3.5">Role</th><th className="px-6 py-3.5">Access</th><th className="px-6 py-3.5">Created</th><th className="px-6 py-3.5 text-right">Actions</th></tr></thead><tbody className="divide-y divide-[#e7efed]">{visibleRecords.map((record) => <tr key={record.userAccountId} className="hover:bg-[#f5fbfa]"><td className="px-6 py-4"><p className="font-semibold text-[#143c42]">{record.displayName}</p><p className="mt-0.5 text-xs text-[#668187]">@{record.username}{record.user?.email ? ` · ${record.user.email}` : ""}</p></td><td className="px-6 py-4 text-[#527076]">{record.user?.organizationName || "—"}</td><td className="px-6 py-4"><span className="rounded-full bg-teal-50 px-2.5 py-1 text-xs font-bold text-teal-700">{record.roleName}</span></td><td className="px-6 py-4"><StatusBadge active={record.isActive} /></td><td className="px-6 py-4 text-[#527076]">{new Date(record.dateCreated).toLocaleDateString()}</td><td className="px-6 py-4 text-right"><button onClick={() => setEditing(record)} className="rounded-md border border-[#b9d6d1] px-3 py-1.5 text-xs font-semibold text-[#087c77] transition hover:bg-teal-50">Manage</button></td></tr>)}</tbody></table></div>}</div></section><FormModal open={creating} onClose={() => setCreating(false)}><UserForm roles={roles} organizations={organizations} onSubmit={saveNewUser} onCancel={() => setCreating(false)} /></FormModal><FormModal open={!!editing} onClose={() => setEditing(null)}><UserForm editing={editing} roles={roles} organizations={organizations} onSubmit={saveUser} onCancel={() => setEditing(null)} /></FormModal></main>;
}

function Metric({ label, value, tone }) { return <div className="rounded-xl border border-[#e2ecea] bg-white p-5 shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><p className="text-xs font-bold uppercase tracking-wider text-[#668187]">{label}</p><p className={`mt-2 text-3xl font-bold ${tone}`}>{value}</p></div>; }
function StatusBadge({ active }) { return <span className={`rounded-full px-2.5 py-1 text-xs font-bold ${active ? "bg-emerald-50 text-emerald-700" : "bg-slate-100 text-slate-600"}`}>{active ? "Active" : "Inactive"}</span>; }

function UserForm({ editing, roles, organizations, onSubmit, onCancel }) {
  const account = editing || {};
  const [form, setForm] = useState({ username: account.username || "", temporaryPassword: "", roleId: roles.find((role) => role.roleName === account.roleName)?.roleId || "", isActive: account.isActive ?? true, firstName: account.user?.firstName || "", lastName: account.user?.lastName || "", organizationId: account.user?.organizationId || "", position: account.user?.position || "", email: account.user?.email || "", phone: account.user?.phone || "", mobile: account.user?.mobile || "", comments: account.user?.comments || "" });
  const change = (event) => setForm((current) => ({ ...current, [event.target.name]: event.target.type === "checkbox" ? event.target.checked : event.target.value }));
  const submit = (event) => { event.preventDefault(); onSubmit(form); };
  const profilePending = editing && !editing.user;
  return <form onSubmit={submit} className="space-y-4"><div><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Administration</p><h2 className="mt-1 text-xl font-bold text-[#143c42]">{editing ? "Manage user" : "Add user"}</h2><p className="mt-1 text-sm text-[#668187]">{profilePending ? "Complete this account's profile and control its access." : "Account access and profile information."}</p></div>{!editing && <><label className="block"><span className="mb-1.5 block text-sm font-semibold text-[#284e53]">Username</span><input required name="username" value={form.username} onChange={change} className={inputClass} /></label><label className="block"><span className="mb-1.5 block text-sm font-semibold text-[#284e53]">Temporary password</span><input required minLength="8" type="password" name="temporaryPassword" value={form.temporaryPassword} onChange={change} className={inputClass} /></label></>}<div className="grid gap-4 sm:grid-cols-2"><label className="block"><span className="mb-1.5 block text-sm font-semibold text-[#284e53]">Role</span><select required name="roleId" value={form.roleId} onChange={change} className={inputClass}><option value="" disabled>Select role</option>{roles.map((role) => <option key={role.roleId} value={role.roleId}>{role.roleName}</option>)}</select></label>{editing && <label className="mt-7 flex items-center gap-2 text-sm font-semibold text-[#284e53]"><input type="checkbox" name="isActive" checked={form.isActive} onChange={change} className="h-4 w-4 accent-[#087c77]" /> Account is active</label>}</div><div className="grid gap-4 sm:grid-cols-2"><label className="block"><span className="mb-1.5 block text-sm font-semibold text-[#284e53]">First name</span><input required name="firstName" value={form.firstName} onChange={change} className={inputClass} /></label><label className="block"><span className="mb-1.5 block text-sm font-semibold text-[#284e53]">Last name</span><input required name="lastName" value={form.lastName} onChange={change} className={inputClass} /></label></div><label className="block"><span className="mb-1.5 block text-sm font-semibold text-[#284e53]">Organisation</span><select required name="organizationId" value={form.organizationId} onChange={change} className={inputClass}><option value="" disabled>Select organisation</option>{organizations.map((organization) => <option key={organization.organizationId} value={organization.organizationId}>{organization.organizationName}</option>)}</select></label><label className="block"><span className="mb-1.5 block text-sm font-semibold text-[#284e53]">Position</span><input name="position" value={form.position} onChange={change} className={inputClass} /></label><div className="grid gap-4 sm:grid-cols-2"><label className="block"><span className="mb-1.5 block text-sm font-semibold text-[#284e53]">Email</span><input required type="email" name="email" value={form.email} onChange={change} className={inputClass} /></label><label className="block"><span className="mb-1.5 block text-sm font-semibold text-[#284e53]">Phone</span><input required name="phone" value={form.phone} onChange={change} className={inputClass} /></label></div><label className="block"><span className="mb-1.5 block text-sm font-semibold text-[#284e53]">Mobile</span><input name="mobile" value={form.mobile} onChange={change} className={inputClass} /></label><div className="flex justify-end gap-2 pt-2"><button type="button" onClick={onCancel} className="rounded-lg px-4 py-2.5 text-sm font-semibold text-[#527076] hover:bg-slate-100">Cancel</button><button type="submit" className="rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-[#05635f]">{editing ? "Save changes" : "Create user"}</button></div></form>;
}

export default AdminUsersPage;
