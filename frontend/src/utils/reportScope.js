import { MAX_SCORE_VALUE } from "./scoring.js";

export function componentStandardIds(items, component = "") {
  return [...new Set(items.filter(item => !component || String(item.componentNumber) === String(component)).map(item => item.standardId))];
}

export function achievementPoints(entries) {
  const scored = entries.filter(item => item.isApplicable !== false && item.scoreId != null && typeof item.scoreValue === "number");
  return { earned: scored.reduce((sum, item) => sum + item.scoreValue, 0), possible: scored.length * MAX_SCORE_VALUE };
}
