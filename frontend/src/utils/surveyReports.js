// Extend this permission alongside the API's GenerateSurveyReports policy when Preceptor is introduced.
export const canGenerateReports = (roleName) => roleName === "Admin";

export function assessmentStatus(item) {
  if (!item.isApplicable || (item.scoreId != null && item.scoreValue == null)) return "Not applicable";
  if (item.scoreId == null) return "Unassessed";
  return ({ 0: "Non-compliant", 1: "Partially compliant", 2: "Compliant" })[item.scoreValue] ?? "Unknown score";
}

export function summariseReport(items) {
  const applicable = items.filter((item) => assessmentStatus(item) !== "Not applicable");
  const scored = applicable.filter((item) => item.scoreId != null && item.scoreValue != null);
  return {
    total: items.length,
    unassessed: applicable.length - scored.length,
    notApplicable: items.length - applicable.length,
    scored: scored.length,
    score: scored.length ? Math.round(scored.reduce((sum, item) => sum + item.scoreValue, 0) / (scored.length * 2) * 100) : null,
    dummy: items.some((item) => /dummy survey|synthetic data/i.test(item.complianceComments || "")),
  };
}

export function isPriorityFinding(item) {
  return assessmentStatus(item) !== "Not applicable" &&
    (["Non-compliant", "Partially compliant"].includes(assessmentStatus(item)) || isHighRisk(item));
}

export function isHighRisk(item) {
  return assessmentStatus(item) !== "Not applicable" &&
    (item.riskSeverity >= 3 || /^(high|extreme)$/i.test(item.riskLabel || ""));
}

export function detailItems(report) {
  return report.mode === "findings" ? report.items.filter(isPriorityFinding) : report.items;
}

export function compareAssessment(current, previous) {
  if (!previous) return { label: "No internal assessment", delta: null };
  const currentStatus = assessmentStatus(current), previousStatus = assessmentStatus(previous);
  if (currentStatus === "Unassessed" || previousStatus === "Unassessed") return { label: "Comparison pending assessment", delta: null };
  if (currentStatus === "Not applicable" || previousStatus === "Not applicable") return {
    label: currentStatus === previousStatus ? "Both not applicable" : "Applicability differs", delta: null,
  };
  const delta = current.scoreValue - previous.scoreValue;
  return { label: delta === 0 ? "Scores agree" : `External score ${Math.abs(delta)} point${Math.abs(delta) === 1 ? "" : "s"} ${delta > 0 ? "higher" : "lower"}`, delta };
}

export function compareScope(items, internalItems) {
  const previous = new Map(internalItems.map((item) => [item.complianceId, item]));
  const pairs = items.map((item) => ({ item, comparison: compareAssessment(item, previous.get(item.complianceId)) }));
  const comparable = pairs.filter(({ comparison }) => comparison.delta != null);
  return {
    compared: comparable.length,
    differing: comparable.filter(({ comparison }) => comparison.delta !== 0).length,
    delta: comparable.length ? Math.round(comparable.reduce((sum, { comparison }) => sum + comparison.delta, 0) / (comparable.length * 2) * 100) : null,
  };
}
