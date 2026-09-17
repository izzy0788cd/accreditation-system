// NHSS numbers are strings because they may be hierarchical (3.2.10) or carry
// a suffix (23a). Numeric collation keeps their human reading order intact.
export const compareReferenceNumber = (first, second) => String(first ?? "").localeCompare(
  String(second ?? ""), undefined, { numeric: true, sensitivity: "base" },
);

export const sortByReferenceNumber = (items, key) => [...items].sort(
  (first, second) => compareReferenceNumber(first?.[key], second?.[key]),
);

export const sortScores = (scores) => [...scores].sort((first, second) => {
  const firstValue = first.scoreValue;
  const secondValue = second.scoreValue;
  if (firstValue == null) return secondValue == null ? compareReferenceNumber(first.scoreLabel, second.scoreLabel) : 1;
  if (secondValue == null) return -1;
  return Number(firstValue) - Number(secondValue) || compareReferenceNumber(first.scoreLabel, second.scoreLabel);
});

const riskRank = (rating) => {
  const configured = Number(rating.severityOrder ?? rating.riskValue);
  if (Number.isFinite(configured)) return configured;
  return ({ low: 1, medium: 2, high: 3, extreme: 4 }[String(rating.riskLabel).toLowerCase()] ?? 999);
};

export const sortRiskRatings = (ratings) => [...ratings].sort((first, second) =>
  riskRank(first) - riskRank(second) || compareReferenceNumber(first.riskLabel, second.riskLabel),
);
