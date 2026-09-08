import { getAccreditationStatusClass } from "../utils/accreditationStatus";

function AccreditationStatusBadge({ status, className = "" }) {
  const style = getAccreditationStatusClass(status);
  return <span className={`inline-flex rounded-full px-2.5 py-1 text-xs font-semibold ${style} ${className}`}>{status || "Not recorded"}</span>;
}

export default AccreditationStatusBadge;
