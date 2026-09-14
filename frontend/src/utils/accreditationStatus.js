const statusStyles = [
  { match: /not yet|not assessed|not started/i, className: "bg-slate-100 text-slate-700" },
  { match: /progress|assessment/i, className: "bg-sky-50 text-sky-700" },
  { match: /conditional/i, className: "bg-amber-50 text-amber-800" },
  { match: /expired|not accredited|suspended/i, className: "bg-red-50 text-red-700" },
  { match: /accredited/i, className: "bg-emerald-50 text-emerald-700" },
];

export const getAccreditationStatusClass = (status) =>
  statusStyles.find((item) => item.match.test(status || ""))?.className || "bg-violet-50 text-violet-700";
