import { useEffect, useMemo, useState } from "react";
import { Link, useParams } from "react-router-dom";
import { getAll, getOne } from "../../api/api";
import { compareReferenceNumber } from "../../utils/numberSort";

const compare = (left, right) => compareReferenceNumber(left, right);

export default function StandaloneToolkitPrintPage() {
  const { templateId } = useParams();
  const [data, setData] = useState(null);
  const [error, setError] = useState("");

  useEffect(() => {
    let active = true;
    Promise.all([getOne("survey-toolkit-templates", templateId), getAll("standards"), getAll("criteria"), getAll("compliances"), getAll("evidence")])
      .then(([templateRes, standardsRes, criteriaRes, compliancesRes, evidenceRes]) => {
        if (active) setData({ template: templateRes.data, standards: standardsRes.data, criteria: criteriaRes.data, compliances: compliancesRes.data, evidence: evidenceRes.data });
      })
      .catch((loadError) => { console.error(loadError); if (active) setError("We couldn't load this toolkit template for printing."); });
    return () => { active = false; };
  }, [templateId]);

  const standards = useMemo(() => {
    if (!data) return [];
    const selected = new Set(data.template.complianceIds || []);
    return data.standards.map((standard) => {
      const criteria = data.criteria.filter((criterion) => criterion.standardId === standard.standardId).sort((a, b) => compare(a.criterionNumber, b.criterionNumber)).map((criterion) => ({
        ...criterion,
        compliances: data.compliances.filter((compliance) => compliance.criterionId === criterion.criterionId && compliance.isApplicable && selected.has(compliance.complianceId)).sort((a, b) => compare(a.complianceNumber, b.complianceNumber)).map((compliance) => ({
          ...compliance,
          evidence: data.evidence.filter((item) => item.complianceId === compliance.complianceId && item.isApplicable).sort((a, b) => compare(a.evidenceNumber, b.evidenceNumber)),
        })),
      })).filter((criterion) => criterion.compliances.length);
      return { ...standard, criteria };
    }).filter((standard) => standard.criteria.length).sort((a, b) => compare(a.standardNumber, b.standardNumber));
  }, [data]);

  if (error) return <main className="mx-auto max-w-4xl px-4 py-8"><Link to="/surveys/toolkits" className="text-sm font-semibold text-[#16803a]">← Back to toolkit builder</Link><p className="mt-5 rounded-xl border border-red-200 bg-red-50 p-5 text-sm text-red-800">{error}</p></main>;
  if (!data) return <main className="mx-auto max-w-6xl px-4 py-10 text-sm text-[#4b5f7a]">Preparing standalone toolkit…</main>;

  const { template } = data;
  return <main className="standalone-toolkit-print mx-auto max-w-6xl px-4 py-6 sm:px-6 lg:px-8">
    <div className="print:hidden flex flex-wrap items-center justify-between gap-3"><Link to="/surveys/toolkits" className="text-sm font-semibold text-[#16803a] hover:underline">← Back to toolkit builder</Link><button type="button" onClick={() => window.print()} className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-bold text-white hover:bg-[#0d6531]">Print / Save PDF</button></div>
    <article className="mt-5 bg-white p-3 text-[#092a5a] shadow-sm print:mt-0 print:p-0">
      <header className="border-b-2 border-[#0f6b3c] pb-4"><p className="text-xs font-bold uppercase tracking-[.16em] text-[#16803a]">PNG National Health Service Standards</p><h1 className="mt-1 text-2xl font-bold">{template.templateName}</h1><p className="mt-1 text-sm text-[#4b5f7a]">Standalone survey toolkit · Version {template.templateVersion} · {template.levelName || "All facility levels"}</p>{template.description && <p className="mt-3 max-w-4xl text-sm leading-6 text-[#385273]">{template.description}</p>}<dl className="mt-4 grid gap-x-8 gap-y-3 text-sm sm:grid-cols-2"><Entry label="Facility / service" /><Entry label="Surveyor(s)" /><Entry label="Team lead" /><Entry label="Date" /></dl></header>
      <p className="mt-4 border-l-4 border-[#16803a] bg-[#f3faf8] px-3 py-2 text-xs leading-5 text-[#385273]">Use this template independently of a survey record. Check the evidence, record a score and risk rating for each compliance requirement, then add comments or recommendations.</p>
      <div className="mt-5 space-y-5">{standards.map((standard) => <section key={standard.standardId} className="print-standard border border-[#c9d8e6]"><header className="bg-[#0f6b3c] px-4 py-3 text-white"><p className="text-[10px] font-bold uppercase tracking-[.15em] text-[#b9f5d1]">Standard {standard.standardNumber}</p><h2 className="mt-0.5 text-sm font-bold leading-5">{standard.standardTitle}</h2></header><div className="p-3">{standard.criteria.map((criterion) => <section key={criterion.criterionId} className="print-criterion border-b border-[#d8e3ee] py-3 last:border-0"><header><p className="text-[10px] font-bold uppercase tracking-[.13em] text-[#876318]">Criterion {criterion.criterionNumber}</p><h3 className="mt-0.5 text-sm font-semibold leading-5">{criterion.criterionTitle}</h3></header>{criterion.compliances.map((compliance) => <article key={compliance.complianceId} className="print-compliance mt-3 border-t border-[#e0e8f0] pt-3"><p className="text-sm font-semibold leading-5"><span className="mr-2 text-[#16803a]">{compliance.complianceNumber}</span>{compliance.complianceSummary}</p><div className="mt-2 rounded border border-[#ead7a3] bg-[#fffbf0] p-2.5"><p className="text-[10px] font-bold uppercase tracking-[.13em] text-[#876318]">Evidence to check</p>{compliance.evidence.length ? <ol className="mt-1.5 space-y-1 text-xs leading-5">{compliance.evidence.map((item) => <li key={item.evidenceId}>☐ <strong>{item.evidenceNumber}.</strong> {item.evidenceSummary}</li>)}</ol> : <p className="mt-1 text-xs italic">No evidence items are linked to this requirement.</p>}</div><div className="mt-2 grid gap-2 rounded border border-[#c9d8e6] bg-[#f1f7fb] p-2.5 text-xs sm:grid-cols-[7rem_7rem_minmax(0,1fr)]"><WriteBox label="Score" /><WriteBox label="Risk rating" /><div><p className="font-bold uppercase tracking-wide text-[#4b5f7a]">Comments / recommendations</p><div className="mt-2 space-y-2">{[1, 2, 3, 4].map((line) => <div key={line} className="border-b border-[#8fa9c4]" />)}</div></div></div></article>)}</section>)}<SummarySheet standard={standard} /></div></section>)}</div>
      <section className="mt-5 border-2 border-[#315c88] bg-[#edf5fc] p-4 text-sm"><h2 className="font-bold uppercase tracking-[.12em]">Scoring calculation guide</h2><p className="mt-2 leading-6">For each applicable requirement, record 1 (Poor), 2 (Fair), 3 (Good), or 4 (Full achievement). Criterion and standard percentages are: total numeric scores ÷ (number of applicable scored requirements × 4) × 100. Exclude N/A requirements.</p></section>
    </article>
    <style>{`@media print { @page { size: A4; margin: 13mm 14mm; } body { background: #fff !important; } .print\\:hidden { display: none !important; } .standalone-toolkit-print { max-width: none !important; padding: 0 !important; } .print-standard { break-inside: auto; margin-bottom: 10px; } .print-standard > header { padding: 7px 9px !important; } .print-compliance { break-inside: avoid; } .print-standard h2, .print-standard h3 { font-size: 9pt !important; line-height: 1.25 !important; } }`}</style>
  </main>;
}

function Entry({ label }) { return <div><dt className="text-[10px] font-bold uppercase tracking-[.13em] text-[#4b5f7a]">{label}</dt><dd className="mt-3 h-4 border-b border-[#8fa9c4]" /></div>; }
function WriteBox({ label }) { return <div><p className="font-bold uppercase tracking-wide text-[#4b5f7a]">{label}</p><div className="mt-2 h-7 rounded border border-[#8fa9c4] bg-white" /></div>; }
function SummarySheet({ standard }) { return <section className="mt-4 overflow-hidden border border-[#1e293b]"><header className="bg-[#d7ebc7] px-3 py-2 font-serif"><p className="text-sm font-bold uppercase text-black">Summary sheet</p><h3 className="mt-1 text-sm font-bold text-black">Standard {standard.standardNumber}: {standard.standardTitle}</h3></header><table className="w-full table-fixed border-collapse text-left text-xs text-black"><colgroup><col className="w-[7%]" /><col className="w-[47%]" /><col className="w-[10%]" /><col className="w-[12%]" /><col className="w-[24%]" /></colgroup><thead><tr className="bg-[#f7cfac]"><th className="border border-black px-2 py-2">No.</th><th className="border border-black px-2 py-2">Criteria for compliance &amp; annotation</th><th className="border border-black px-2 py-2">Score</th><th className="border border-black px-2 py-2">Risk rating</th><th className="border border-black px-2 py-2">Summary of recommendations / comments</th></tr></thead><tbody>{standard.criteria.map((criterion) => <tr key={criterion.criterionId}><td className="border border-black px-2 py-3 font-semibold">{criterion.criterionNumber}</td><td className="border border-black px-2 py-3 font-semibold">{criterion.criterionTitle}</td><td className="border border-black px-2 py-3" /><td className="border border-black px-2 py-3" /><td className="border border-black px-2 py-3" /></tr>)}<tr className="bg-[#f7cfac]"><td colSpan="2" className="border border-black px-2 py-3 text-right font-bold">TOTALS:</td><td className="border border-black px-2 py-3" /><td className="border border-black px-2 py-3" /><td className="border border-black px-2 py-3" /></tr></tbody></table></section>; }
