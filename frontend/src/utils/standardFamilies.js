export const STANDARD_23_FAMILY = {
  number: "23",
  title: "Provision of and Continuity of Care (Mandatory Standard)",
  summary: "The Healthcare Organisation ensures patients are provided with safe, high-quality inpatient and outpatient care throughout the care delivery process. They should do this from the time that the patient enters the healthcare organisation or service through to when the patient is discharged or transferred to another health facility-service; and during any ongoing care they provide after discharge.\n\nThe Healthcare Organization should implement evidence-based practice and have a process for assessing the appropriateness and effectiveness of care and services, and the settings they are delivered in.",
};

export function isStandard23Child(standardNumber) {
  return /^23[a-z]$/i.test(String(standardNumber || "").trim());
}

export function dashboardStandardKey(standard) {
  return isStandard23Child(standard?.standardNumber)
    ? "standard-family-23"
    : `standard-${standard?.standardId}`;
}

export function countDashboardStandards(standards) {
  return new Set((standards || []).map(dashboardStandardKey)).size;
}

// Dashboard-only aggregation: the detailed framework, assessment, and report
// records retain their individual 23a, 23b, 23c … identities.
export function aggregateDashboardStandards(standards, maxScore = 4) {
  const regular = standards.filter((standard) => !isStandard23Child(standard.standardNumber));
  const specialtyStandards = standards.filter((standard) => isStandard23Child(standard.standardNumber));

  if (!specialtyStandards.length) return regular;

  const assessmentRows = specialtyStandards.flatMap((standard) => standard.rows || standard.entries || []);
  const numericRows = assessmentRows.filter((row) => row.scoreValue != null);
  const completedRows = assessmentRows.filter((row) => row.scoreId);
  const score = numericRows.length
    ? Math.round((numericRows.reduce((sum, row) => sum + row.scoreValue, 0) / (numericRows.length * maxScore)) * 100)
    : null;

  return [...regular, {
    ...specialtyStandards[0],
    standardId: "standard-family-23",
    standardNumber: STANDARD_23_FAMILY.number,
    standardTitle: STANDARD_23_FAMILY.title,
    isStandardFamily: true,
    childStandards: specialtyStandards,
    rows: assessmentRows,
    entries: assessmentRows,
    completed: completedRows.length,
    scored: completedRows.length,
    score,
    status: completedRows.length === 0
      ? "Not started"
      : completedRows.length < assessmentRows.length
        ? "In progress"
        : score == null
          ? "N/A"
          : "Completed",
    evidenceComplete: specialtyStandards.reduce((sum, standard) => sum + (standard.evidenceComplete || 0), 0),
    evidenceTotal: specialtyStandards.reduce((sum, standard) => sum + (standard.evidenceTotal || 0), 0),
    risks: assessmentRows.filter((row) => row.riskRatingId).length,
    surveyors: [...new Set(specialtyStandards.flatMap((standard) => standard.surveyors || []))],
  }];
}
