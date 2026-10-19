// Shared by surveyor handovers, team review, and their print/PDF documents.
export default function StandardSummationContent({ summary }) {
  const section = (title, value) => value?.trim() ? <section className="mt-3"><h4 className="font-semibold text-[#092a5a]">{title}</h4><p className="mt-1 whitespace-pre-wrap text-sm leading-6 text-[#4b5f7a]">{value}</p></section> : null;
  return <div className="standard-summation-content">
    {section("Services / areas assessed", summary.summary)}
    {section("Commendations", summary.goodPractices)}
    {section("Areas of concern", summary.areasOfConcern)}
    {section("Opportunities for improvement and recommendations", summary.recommendations)}
    {(summary.serviceAreas || []).map((area, index) => <section key={index} className="mt-5">
      <h3 className="font-bold text-[#092a5a]">{area.name}</h3>
      {section("Service / area overview", area.overview)}
      {section("Commendations", area.commendations)}
      {section("Areas of concern", area.areasOfConcern)}
      {section("Opportunities for improvement and recommendations", area.recommendations)}
    </section>)}
    {section("Not applicable / scope notes", summary.notApplicableNotes)}
  </div>;
}
