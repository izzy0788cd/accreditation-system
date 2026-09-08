import { useEffect, useState } from "react";
import { Link, useParams } from "react-router-dom";
import { getAll, getOne } from "../../api/api";
import AccreditationStatusBadge from "../../components/AccreditationStatusBadge";

function FacilityDetailPage() {
  const { facilityId } = useParams();
  const [facility, setFacility] = useState(null);
  const [location, setLocation] = useState("");
  const [error, setError] = useState("");
  useEffect(() => {
    Promise.all([getOne("facilities", facilityId), getAll("districts"), getAll("provinces"), getAll("regions")]).then(([facilityResponse, districtsResponse, provincesResponse, regionsResponse]) => {
      const record = facilityResponse.data; const district = districtsResponse.data.find((item) => item.districtId === record.districtId); const province = provincesResponse.data.find((item) => item.provinceId === district?.provinceId); const region = regionsResponse.data.find((item) => item.regionId === province?.regionId);
      setFacility(record); setLocation([district?.districtName, province?.provinceName, region?.regionName].filter(Boolean).join(", "));
    }).catch((requestError) => { console.error(requestError); setError("We couldn't load this facility."); });
  }, [facilityId]);
  if (error) return <p role="alert" className="rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">{error}</p>;
  if (!facility) return <div className="space-y-3" aria-label="Loading facility"><div className="h-28 animate-pulse rounded-xl bg-slate-100" /><div className="h-40 animate-pulse rounded-xl bg-slate-100" /></div>;
  const fields = [["Location", location || facility.districtName], ["Organisation", facility.organizationName], ["Facility level", facility.levelName], ["Accreditation status", facility.creditationStatus], ["Head of service", facility.headOfService || "Not recorded"]];
  return <section aria-labelledby="facility-detail-title"><Link to="/facilities/directory" className="mb-5 inline-flex text-sm font-semibold text-[#087c77] hover:underline">← Back to facility directory</Link><div className="rounded-2xl border border-[#cde5e0] bg-[linear-gradient(125deg,#e8f5f3_0%,#f8fbfa_70%)] p-6 sm:p-8"><p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">Health facility</p><h2 id="facility-detail-title" className="mt-2 text-3xl font-bold tracking-tight text-[#143c42]">{facility.facilityName}</h2><p className="mt-2 text-sm text-[#527076]">{location || facility.districtName}</p><AccreditationStatusBadge status={facility.creditationStatus} className="mt-5 text-sm" /></div><div className="mt-6 grid gap-4 sm:grid-cols-2">{fields.map(([label, value]) => <div key={label} className="rounded-xl border border-[#e2ecea] bg-white p-5 shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><p className="text-xs font-bold uppercase tracking-wider text-[#668187]">{label}</p><p className="mt-2 font-semibold text-[#143c42]">{value}</p></div>)}</div>{facility.comments && <div className="mt-6 rounded-xl border border-[#e2ecea] bg-white p-5 shadow-[0_8px_24px_rgba(20,60,66,0.06)]"><h3 className="font-bold text-[#143c42]">Notes</h3><p className="mt-2 whitespace-pre-wrap text-sm leading-6 text-[#527076]">{facility.comments}</p></div>}<div className="mt-6 rounded-xl border border-dashed border-[#b9d6d1] bg-[#f5faf9] p-5"><h3 className="font-bold text-[#143c42]">Surveys</h3><p className="mt-1 text-sm text-[#527076]">Survey creation will start here once the assessment workflow is added.</p></div></section>;
}
export default FacilityDetailPage;
