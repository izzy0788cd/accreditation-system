import { assessmentStatus, compareAssessment } from "../../utils/surveyReports";

const numericSort = (a, b) => String(a).localeCompare(String(b), undefined, { numeric: true });

function Result({ item, title }) {

  if (!item) return <div className="report-result"><h4>{title}</h4><p>No matching internal assessment.</p></div>;

  const status = assessmentStatus(item);

  return <div className="report-result"><h4>{title}</h4><div className="report-result-scores"><span><b>Score</b> {status === "Not applicable" ? "N/A" : item.scoreId == null ? "—" : item.scoreValue}</span><span className="report-status" data-status={status}>{status}</span><span><b>Risk</b> {item.riskLabel || "Not rated"}</span></div><div className="report-observation"><h4>Comments</h4><p className="report-text">{item.complianceComments || "No comments recorded."}</p></div></div>;

}

function EvidenceCheck({ evidence, assessment, title }) {

  if (!evidence || !assessment) return <span aria-label={`${title}: no record`}>—</span>;

  if (!evidence.isApplicable || assessmentStatus(assessment) === "Not applicable") return <span className="report-evidence-na">N/A</span>;

  return <span className="report-evidence-checkbox" role="checkbox" aria-checked={evidence.isChecked} aria-readonly="true" aria-label={`${title} evidence ${evidence.evidenceNumber}`}>{evidence.isChecked ? "✓" : ""}</span>;

}

function EvidenceText({ text }) {

  const lines = (text || "").split(/\r?\n/);

  const blocks = [];

  for (const line of lines) {

    const bullet = line.match(/^\s*[•\uF0D8]\s*(.*)$/);

    if (bullet) {

      if (blocks.at(-1)?.type !== "list") blocks.push({ type: "list", lines: [] });

      blocks.at(-1).lines.push(bullet[1]);

    } else {

      if (blocks.at(-1)?.type !== "text") blocks.push({ type: "text", lines: [] });

      blocks.at(-1).lines.push(line);

    }

  }

  return blocks.map((block, index) => block.type === "list"

    ? <ul className="report-evidence-bullets" key={index}>{block.lines.map((line, i) => <li key={i}>{line}</li>)}</ul>

    : <div className="report-text" key={index}>{block.lines.join("\n")}</div>);

}

function Evidence({ item, internal, external }) {

  const current = new Map(item.evidence.map((e) => [e.evidenceId, e]));

  const previous = new Map((internal?.evidence || []).map((e) => [e.evidenceId, e]));

  const rows = [...new Map([...previous, ...current]).values()].sort((a,b) => numericSort(a.evidenceNumber,b.evidenceNumber));

  return <div className="report-evidence">{rows.length ? <table><thead><tr><th className="evidence-number-column">No.</th><th className="evidence-summary-column">Evidence of compliance</th>{external && <th>Internal</th>}<th>{external ? "External" : <span className="sr-only">Evidence check</span>}</th></tr></thead><tbody>{rows.map((e) => <tr key={e.evidenceId}><td className="evidence-number-column">{e.evidenceNumber}</td><td className="evidence-summary-column"><EvidenceText text={e.evidenceSummary} /></td>{external && <td><EvidenceCheck evidence={previous.get(e.evidenceId)} assessment={internal} title="Internal" /></td>}<td><EvidenceCheck evidence={current.get(e.evidenceId)} assessment={item} title={external ? "External" : "Internal"} /></td></tr>)}</tbody></table> : <p>No evidence checks recorded.</p>}</div>;

}

export default function ReportDetails({ report }) {

  const external = report.survey.surveyType === "External";

  const internalByCompliance = new Map((report.internalItems || []).map((item) => [item.complianceId, item]));

  return report.standards.map((standard) => {

    const items = report.items.filter((item) => item.standardId === standard.id);

    const criteria = [...new Map(items.map((item) => [item.criterionNumber, item.criterionTitle]))].sort(([a],[b]) => numericSort(a,b));

    return <section className="report-standard-section" id={`report-standard-${standard.id}`} key={standard.id}><div className="report-section-heading"><span className="report-section-number">{standard.number}</span><div><p className="report-eyebrow">Standard</p><h2>{standard.title}</h2></div></div>{criteria.map(([number, title]) => <div className="report-criterion" key={number}><header className="report-criterion-heading"><p className="report-eyebrow">Criterion {number}</p><h3>{title}</h3></header>{items.filter((item) => item.criterionNumber === number).map((item) => {

      const internal = internalByCompliance.get(item.complianceId);
      const comparison = compareAssessment(item, internal);

      return <div className="report-finding" key={item.complianceAssessmentId}><h4>Compliance {item.complianceNumber}</h4><p className="report-text">{item.complianceSummary}</p>{report.included.includes("evidence") && <Evidence item={item} internal={internal} external={external} />}{external && report.included.includes("findings") && <p className={`report-comparison ${comparison.delta != null && comparison.delta !== 0 ? "report-comparison-different" : ""}`}>{comparison.label}</p>}{report.included.includes("findings") && <div className={`report-results ${external ? "report-results-comparison" : ""}`}>{external && <Result item={internal} title="Internal assessment" />}<Result item={item} title={external ? "External assessment" : "Internal assessment"} /></div>}</div>;

    })}</div>)}</section>;

  });

}

