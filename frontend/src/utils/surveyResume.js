export function readSurveyResume(userId, surveyId) {
  try {
    const saved = JSON.parse(localStorage.getItem(`survey-resume-${userId || "anonymous"}-${surveyId}`) || "null");
    const base = `/surveys/${surveyId}`;
    if (saved?.step === "handover") return `${base}/report?resumeStep=summations`;
    if (saved?.step === "summation" && Number(saved.standardId) > 0) return `${base}/standards/${Number(saved.standardId)}/summary?resumeStep=summation${Number(saved.nextStandardId) > 0 ? `&next=${Number(saved.nextStandardId)}` : ""}`;
    if (Number(saved?.assessmentId) > 0) return `${base}?resume=${Number(saved.assessmentId)}`;
    if (Number(saved?.standardId) > 0) return `${base}?standard=${Number(saved.standardId)}`;
  } catch { /* Resume is optional when storage is unavailable. */ }
  return null;
}

export function rememberSurveyResume(userId, surveyId, position) {
  try { localStorage.setItem(`survey-resume-${userId || "anonymous"}-${surveyId}`, JSON.stringify({ ...position, savedAt: new Date().toISOString() })); } catch { /* Do not interrupt survey work. */ }
}
