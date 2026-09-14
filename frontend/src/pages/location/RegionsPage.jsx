import RegionForm from "../../components/forms/RegionForm";
import LocationListPage from "./LocationListPage";

function RegionsPage() {
  return <LocationListPage resource="regions" singular="Region" plural="Regions" idField="regionId" nameField="regionName" Form={RegionForm} />;
}

export default RegionsPage;
