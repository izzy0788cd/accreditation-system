import ProvinceForm from "../../components/forms/ProvinceForm";
import LocationListPage from "./LocationListPage";

function ProvincesPage() {
  return <LocationListPage resource="provinces" singular="Province" plural="Provinces" idField="provinceId" nameField="provinceName" parentLabel="Region" parentField="regionName" Form={ProvinceForm} />;
}

export default ProvincesPage;
