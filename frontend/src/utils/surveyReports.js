import { MAX_SCORE_VALUE, isPriorityScore, scoreOutcomeLabel } from "./scoring.js";
import { canGenerateReports } from "./access.js";

export { canGenerateReports };

export function reportCommentLabel(item) {
  if (item.isApplicable === false || item.scoreId == null || item.scoreValue == null) return "Comments";
  if (item.scoreValue === 1 || item.scoreValue === 2) return "Recommendations";
  return item.scoreValue === 4 ? "Commendations" : "Comments";
}

export function reportReadiness(report, selectedIds, included, mode) {
  const items = report?.items || [];
  const allIds = new Set(items.map(item => item.standardId));
  const issues = [];
  if (report?.workflowVersion !== 2) issues.push("Updated reporting backend is unavailable. Reload after the backend has restarted.");
  if (!items.length) issues.push("The survey has no assessment requirements.");
  if (allIds.size !== new Set(selectedIds).size || selectedIds.some(id => !allIds.has(id))) issues.push("Select every surveyed standard for approval.");
  if (mode !== "full") issues.push("Approval requires a full report, not a findings-only extract.");
  if (["summary", "standards", "findings", "signoff"].some(section => !included.includes(section))) issues.push("Include summary, standards, findings and sign-off.");
  if (report?.survey?.isCancelled) issues.push("A cancelled survey cannot be approved.");
  if (items.some(item => item.isApplicable !== false && item.scoreId == null)) issues.push("Complete all applicable requirement scores.");
  const statuses = report?.summationStatus;
  if (!statuses?.length) issues.push("Summation readiness information is unavailable.");
  else {
    if (statuses.some(status => !status.submitted)) issues.push("Submit all surveyors’ standard summations to the Team Lead.");
    if (statuses.some(status => !status.saved)) issues.push("Save all assigned standard summations.");
  }
  return issues;
}

export function assessmentStatus(item) {
  if (!item.isApplicable || (item.scoreId != null && item.scoreValue == null)) return "Not applicable";
  if (item.scoreId == null) return "Unassessed";
  return item.scoreLabel || scoreOutcomeLabel(item.scoreValue);
}

export function summariseReport(items) {
  const applicable = items.filter((item) => assessmentStatus(item) !== "Not applicable");
  const scored = applicable.filter((item) => item.scoreId != null && item.scoreValue != null);
  return {
    total: items.length,
    unassessed: applicable.length - scored.length,
    notApplicable: items.length - applicable.length,
    scored: scored.length,
    score: scored.length ? Math.round(scored.reduce((sum, item) => sum + item.scoreValue, 0) / (scored.length * MAX_SCORE_VALUE) * 100) : null,
    dummy: items.some((item) => /dummy survey|synthetic data/i.test(item.complianceComments || "")),
  };
}

export function isPriorityFinding(item) {
  return assessmentStatus(item) !== "Not applicable" &&
    (isPriorityScore(item.scoreValue) || isHighRisk(item));
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
    delta: comparable.length ? Math.round(comparable.reduce((sum, { comparison }) => sum + comparison.delta, 0) / (comparable.length * MAX_SCORE_VALUE) * 100) : null,
  };
}
