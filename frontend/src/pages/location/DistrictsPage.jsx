import DistrictForm from "../../components/forms/DistrictForm";
import LocationListPage from "./LocationListPage";

function DistrictsPage() {
  return <LocationListPage resource="districts" singular="District" plural="Districts" idField="districtId" nameField="districtName" parentLabel="Province" parentField="provinceName" Form={DistrictForm} />;
}

export default DistrictsPage;
