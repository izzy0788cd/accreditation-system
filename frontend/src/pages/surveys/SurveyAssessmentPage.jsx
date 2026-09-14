import { useEffect, useMemo, useState } from "react";
import { Link, useParams, useSearchParams } from "react-router-dom";
import {
  getAll,
  getInternalAssessmentReferences,
  getOne,
  getSurveyAssessments,
  getSurveyAssessmentOverview,
  getSurveyEvidenceChecks,
  getSurveyProgress,
  patchEvidenceCheck,
  resetSurvey,
  updateAssessment,
} from "../../api/api";
import ConfirmDialog from "../../components/ConfirmDialog";
import { useAuth } from "../../context/AuthContext";

const percentage = (complete, total) => (total ? Math.round((complete / total) * 100) : 0);
const compareNumber = (first, second) => String(first ?? "").localeCompare(
  String(second ?? ""),
  undefined,
  { numeric: true, sensitivity: "base" },
);

function ProgressBar({ label, value }) {
  return (
    <div>
      <div className="mb-1.5 flex justify-between gap-3 text-xs font-bold text-[#4b5f7a]">
        <span>{label}</span><span className="shrink-0 text-[#092a5a]">{value}%</span>
      </div>
      <div className="h-2 overflow-hidden rounded-full bg-[#dbe5ef]">
        <div className="h-full rounded-full bg-[#16803a] transition-all duration-500" style={{ width: `${value}%` }} />
      </div>
    </div>
  );
}

function InternalReference({ reference }) {
  return <div className="mt-4 rounded-lg border border-sky-100 bg-sky-50 px-4 py-3">
    <p className="text-xs font-bold uppercase tracking-[0.14em] text-sky-800">Most recent Internal self-assessment</p>
    {!reference ? <p className="mt-2 text-sm text-sky-800">No Internal assessment has been recorded for this requirement.</p> : <dl className="mt-3 grid gap-3 text-sm sm:grid-cols-3"><div><dt className="text-xs font-bold uppercase tracking-wider text-sky-700">Score</dt><dd className="mt-1 font-semibold text-[#092a5a]">{reference.scoreValue == null ? (reference.scoreId ? "N/A" : "Not recorded") : reference.scoreValue}</dd></div><div><dt className="text-xs font-bold uppercase tracking-wider text-sky-700">Risk rating</dt><dd className="mt-1 font-semibold text-[#092a5a]">{reference.riskValue || "Not recorded"}</dd></div><div className="sm:col-span-1"><dt className="text-xs font-bold uppercase tracking-wider text-sky-700">Comments</dt><dd className="mt-1 leading-6 text-[#385273]">{reference.complianceComments || "No comments recorded."}</dd></div></dl>}
  </div>;
}

function SurveyAssessmentPage() {
  const { surveyId } = useParams();
  const [searchParams] = useSearchParams();
  const { auth, profile } = useAuth();
  const [survey, setSurvey] = useState(null);
  const [assessments, setAssessments] = useState([]);
  const [progress, setProgress] = useState(null);
  const [scores, setScores] = useState([]);
  const [risks, setRisks] = useState([]);
  const [surveyors, setSurveyors] = useState([]);
  const [criteria, setCriteria] = useState([]);
  const [compliances, setCompliances] = useState([]);
  // null is the first-load state; an empty string is the deliberate "All standards" view.
  const [selectedStandard, setSelectedStandard] = useState(null);
  const [checks, setChecks] = useState({});
  const [internalReferences, setInternalReferences] = useState({});
  const [resetOpen, setResetOpen] = useState(false);
  const [resetting, setResetting] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [dataWarning, setDataWarning] = useState("");
  const [resumeAssessmentId, setResumeAssessmentId] = useState(null);
  const isSurveyor = ["Surveyor", "Team Lead"].includes(auth?.roleName);
  const isAdmin = auth?.roleName === "Admin";
  const isExternal = survey?.surveyTypeName === "External";
  const isOverview = searchParams.get("view") === "overview";
  const resumeFromQuery = Number(searchParams.get("resume")) || null;
  const resumeStorageKey = `survey-resume-${profile?.userId || "anonymous"}-${surveyId}`;

  const rememberPosition = (assessmentId) => {
    const position = { assessmentId, savedAt: new Date().toISOString() };
    localStorage.setItem(resumeStorageKey, JSON.stringify(position));
    setResumeAssessmentId(assessmentId);
  };

  const load = async (showLoading = true) => {
    try {
      if (showLoading) setLoading(true);
      const [surveyRes, assessmentRes, progressRes, scoreRes, riskRes, criterionRes, complianceRes, surveyorRes, evidenceRes, internalReferenceRes] = await Promise.all([
        getOne("surveys", surveyId), isOverview ? getSurveyAssessmentOverview(surveyId) : getSurveyAssessments(surveyId), getSurveyProgress(surveyId),
        getAll("scores"), getAll("riskRating"), getAll("criteria"), getAll("compliances"), getAll("surveyors"),
        getSurveyEvidenceChecks(surveyId).catch((checkError) => { console.error("Could not load evidence checks", checkError); return { data: [], unavailable: true }; }),
        getInternalAssessmentReferences(surveyId).catch((referenceError) => { console.error("Could not load internal assessment references", referenceError); return { data: [], unavailable: true }; }),
      ]);
      setSurvey(surveyRes.data);
      setAssessments(assessmentRes.data);
      setProgress(progressRes.data);
      setScores(scoreRes.data);
      setRisks(riskRes.data);
      setCriteria(criterionRes.data);
      setCompliances(complianceRes.data); setSurveyors(surveyorRes.data);
      setChecks(evidenceRes.data.reduce((grouped, check) => ({
        ...grouped,
        [check.complianceAssessmentId]: [...(grouped[check.complianceAssessmentId] || []), check],
      }), {}));
      setInternalReferences(Object.fromEntries(internalReferenceRes.data.map((reference) => [reference.complianceId, reference])));
      setDataWarning([evidenceRes.unavailable && "Evidence checks are temporarily unavailable.", internalReferenceRes.unavailable && "Internal comparison information is temporarily unavailable."].filter(Boolean).join(" "));
      setError("");
    } catch (loadError) {
      console.error(loadError);
      setDataWarning("");
      setError("We couldn't load this assessment. Please confirm the survey exists and has generated its checklist.");
    } finally { if (showLoading) setLoading(false); }
  };

  useEffect(() => { load(); }, [surveyId, isOverview]);

  useEffect(() => {
    try {
      const saved = JSON.parse(localStorage.getItem(resumeStorageKey) || "null");
      setResumeAssessmentId(saved?.assessmentId || null);
    } catch {
      localStorage.removeItem(resumeStorageKey);
    }
  }, [resumeStorageKey]);

  const enriched = useMemo(() => {
    const complianceById = new Map(compliances.map((item) => [item.complianceId, item]));
    const criteriaById = new Map(criteria.map((item) => [item.criterionId, item]));
    return assessments.map((assessment) => {
      const compliance = complianceById.get(assessment.complianceId);
      const criterion = criteriaById.get(compliance?.criterionId);
      return { ...assessment, criterionId: compliance?.criterionId, criterionNumber: compliance?.criterionNumber, criterionTitle: criterion?.criterionTitle, standardId: criterion?.standardId, standardNumber: criterion?.standardNumber, standardTitle: criterion?.standardTitle };
    });
  }, [assessments, compliances, criteria]);

  const currentSurveyorId = useMemo(() => surveyors.find((surveyor) => surveyor.userId === profile?.userId)?.surveyorId, [profile?.userId, surveyors]);
  const canAssess = (assessment) => !survey?.isCancelled && !isOverview && (isAdmin || (isSurveyor && assessment.surveyorId === currentSurveyorId));
  const showAssessment = (assessmentId) => {
    const assessment = enriched.find((item) => item.complianceAssessmentId === assessmentId);
    if (assessment?.standardId) setSelectedStandard(String(assessment.standardId));
  };

  useEffect(() => {
    // Only a deliberate Continue/Go-to link should move the viewport. Saving a
    // score or checking evidence still records the position, but must not pull
    // the surveyor away from the item they are working on.
    const assessmentId = resumeFromQuery;
    if (!assessmentId || !assessments.some((assessment) => assessment.complianceAssessmentId === assessmentId)) return undefined;
    const target = enriched.find((assessment) => assessment.complianceAssessmentId === assessmentId);
    if (target?.standardId) setSelectedStandard(String(target.standardId));
    const timer = window.setTimeout(() => {
      document.getElementById(`assessment-${assessmentId}`)?.scrollIntoView({ behavior: "smooth", block: "center" });
    }, 120);
    return () => window.clearTimeout(timer);
  }, [assessments, enriched, resumeFromQuery]);

  const outstanding = useMemo(() => {
    const ordered = [...enriched].sort((first, second) => (
      compareNumber(first.standardNumber, second.standardNumber)
      || compareNumber(first.criterionNumber, second.criterionNumber)
      || compareNumber(first.complianceNumber, second.complianceNumber)
    ));
    const missingScores = ordered.filter((assessment) => !assessment.scoreId);
    // Evidence can be intentionally left unchecked. It remains in the progress
    // tracker, but it is not used to mark a compliance requirement as overdue.
    const incompleteAssessmentIds = new Set(missingScores.map((assessment) => assessment.complianceAssessmentId));
    return {
      missingScores,
      incompleteAssessmentIds,
      nextAssessmentId: ordered.find((assessment) => incompleteAssessmentIds.has(assessment.complianceAssessmentId))?.complianceAssessmentId,
    };
  }, [enriched, checks]);

  const standards = useMemo(() => [...new Map(enriched.filter((item) => item.standardId).map((item) => {
    const standardAssessments = enriched.filter((candidate) => candidate.standardId === item.standardId);
    const incompleteCount = standardAssessments.filter((candidate) => outstanding.incompleteAssessmentIds.has(candidate.complianceAssessmentId)).length;
    return [item.standardId, {
      id: String(item.standardId), label: `${item.standardNumber} — ${item.standardTitle}`,
      total: standardAssessments.length,
      scored: standardAssessments.filter((candidate) => candidate.scoreId).length,
      incompleteCount,
    }];
  })).values()].sort((first, second) => compareNumber(first.label, second.label)), [enriched, outstanding.incompleteAssessmentIds]);

  // A standard-at-a-time workspace is much easier to work through than a single
  // page containing every requirement. Keep All standards as an explicit option.
  useEffect(() => {
    if (selectedStandard === null && standards.length > 0)
      setSelectedStandard(standards[0].id);
  }, [selectedStandard, standards]);

  const grouped = useMemo(() => {
    const visible = enriched
      .filter((item) => !selectedStandard || String(item.standardId) === selectedStandard)
      .sort((first, second) => (
        compareNumber(first.standardNumber, second.standardNumber)
        || compareNumber(first.criterionNumber, second.criterionNumber)
        || compareNumber(first.complianceNumber, second.complianceNumber)
      ));
    return visible.reduce((standardGroups, item) => {
      let standard = standardGroups.find((group) => group.standardId === item.standardId);
      if (!standard) {
        standard = { standardId: item.standardId, standardNumber: item.standardNumber, standardTitle: item.standardTitle, criteria: [] };
        standardGroups.push(standard);
      }
      let criterion = standard.criteria.find((group) => group.criterionId === item.criterionId);
      if (!criterion) {
        criterion = { criterionId: item.criterionId, criterionNumber: item.criterionNumber, criterionTitle: item.criterionTitle, assessments: [] };
        standard.criteria.push(criterion);
      }
      criterion.assessments.push(item);
      return standardGroups;
    }, []);
  }, [enriched, selectedStandard]);

  const completion = progress ? percentage(progress.scoredCount, progress.totalCompliances) : 0;
  const evidenceCompletion = progress ? percentage(progress.checkedEvidenceCount, progress.totalEvidenceChecks) : 0;

  const saveAssessment = async (assessmentId, data) => {
    rememberPosition(assessmentId);
    try { await updateAssessment(assessmentId, data); await load(false); } catch (saveError) { console.error(saveError); }
  };
  const toggleEvidence = async (check) => {
    rememberPosition(check.complianceAssessmentId);
    try {
      await patchEvidenceCheck(check.complianceEvidenceCheckId, !check.isChecked);
      setChecks((current) => ({ ...current, [check.complianceAssessmentId]: current[check.complianceAssessmentId].map((item) => item.complianceEvidenceCheckId === check.complianceEvidenceCheckId ? { ...item, isChecked: !item.isChecked } : item) }));
      const progressRes = await getSurveyProgress(surveyId);
      setProgress(progressRes.data);
    } catch (saveError) { console.error(saveError); }
  };
  const handleReset = async () => {
    try {
      setResetting(true);
      await resetSurvey(surveyId);
      setChecks({});
      setResetOpen(false);
      await load();
    } catch (resetError) { console.error(resetError); } finally { setResetting(false); }
  };

  if (loading) return <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6"><div className="h-52 animate-pulse rounded-2xl bg-slate-100" /></main>;
  if (error) return <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6"><Link to="/surveys" className="text-sm font-semibold text-[#16803a]">← Back to surveys</Link><p className="mt-5 rounded-xl border border-red-100 bg-red-50 p-5 text-sm text-red-800">{error}</p></main>;

  const responseLabel = isExternal ? "Surveyor finding" : "Self-rating";
  const commentsLabel = isExternal ? "Surveyor comments" : "Comments";
  const isTeamLead = auth?.roleName === "Team Lead" && survey?.surveyorId === currentSurveyorId;

  return (
    <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:py-8">
      <Link to="/surveys" className="text-sm font-semibold text-[#16803a] hover:underline">← Back to surveys</Link>
      <header className="mt-5 overflow-hidden rounded-2xl border border-[#bfded8] bg-white shadow-[0_12px_30px_rgba(20,60,66,0.08)]">
        <div className="border-b border-[#b8d9d3] bg-[#0f6b3c] px-5 py-3 text-[11px] font-bold uppercase tracking-[0.14em] text-white sm:px-7 sm:text-xs sm:tracking-[0.17em]">National Health Service Standards assessment toolkit</div>
        <div className="grid gap-6 bg-[linear-gradient(120deg,#f3faf8_0%,#ffffff_68%,#fcf7ed_100%)] p-5 sm:p-7 lg:grid-cols-[1fr_auto] lg:items-start">
          <div>
            <p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">{survey.surveyTypeName} survey</p>
            <h1 className="mt-2 text-2xl font-bold tracking-tight text-[#092a5a] sm:text-3xl">{survey.facilityName}</h1>
            <dl className="mt-4 grid gap-x-8 gap-y-2 text-sm text-[#4b5f7a] sm:grid-cols-2">
              <div><dt className="inline font-semibold text-[#092a5a]">Team lead:</dt> <dd className="inline">{survey.surveyorName}</dd></div>
              <div><dt className="inline font-semibold text-[#092a5a]">Assessment period:</dt> <dd className="inline">{survey.startDate} — {survey.endDate}</dd></div>
            </dl>
          </div>
          <div className="grid gap-2 sm:flex sm:flex-row">{resumeAssessmentId && <Link onClick={() => showAssessment(resumeAssessmentId)} to={`/surveys/${surveyId}?resume=${resumeAssessmentId}`} className="rounded-lg bg-[#d6aa45] px-4 py-3 text-center text-sm font-semibold text-[#092a5a] shadow-sm hover:bg-[#c99d38]">Continue where I left off</Link>}{isTeamLead && <Link to={`/surveys/${surveyId}/team-dashboard`} className="rounded-lg bg-[#092a5a] px-4 py-3 text-center text-sm font-semibold text-white shadow-sm hover:bg-[#071f45]">Team dashboard</Link>}{(isTeamLead || isAdmin || isSurveyor) && <Link to={`/surveys/${surveyId}/results`} className="rounded-lg border border-[#c5d5e8] bg-white px-4 py-3 text-center text-sm font-semibold text-[#16803a] shadow-sm hover:bg-[#edf8f0]">Results summary</Link>}{isTeamLead && <Link to={isOverview ? `/surveys/${surveyId}` : `/surveys/${surveyId}?view=overview`} className="rounded-lg border border-[#c5d5e8] bg-white px-4 py-3 text-center text-sm font-semibold text-[#16803a] shadow-sm hover:bg-[#edf8f0]">{isOverview ? "My assigned standards" : "View all scores"}</Link>}{isAdmin && !survey.isCancelled && <button onClick={() => setResetOpen(true)} className="rounded-lg border border-red-200 bg-white px-4 py-3 text-sm font-semibold text-red-700 shadow-sm transition hover:bg-red-50 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2">Reset survey</button>}</div>
        </div>
        <div className="grid gap-5 border-t border-[#dbe5ef] px-5 py-5 sm:grid-cols-2 sm:px-7">
          <ProgressBar label={`${progress.scoredCount} of ${progress.totalCompliances} requirements scored`} value={completion} />
          <ProgressBar label={`${progress.checkedEvidenceCount} of ${progress.totalEvidenceChecks} evidence checks completed`} value={evidenceCompletion} />
        </div>
      </header>

      {dataWarning && <p role="status" className="mt-5 rounded-lg border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-900">{dataWarning} You can continue recording scores and retry by refreshing the page.</p>}
      {survey.isCancelled && <section className="mt-5 rounded-xl border border-red-200 bg-red-50 p-5 text-sm text-red-900"><p className="font-bold">This survey was cancelled</p><p className="mt-1 leading-6">{survey.cancellationReason}</p><p className="mt-2 text-xs text-red-700">The recorded assessment remains available for review, but cannot be changed.</p></section>}

      {!isAdmin && <p className="mt-5 rounded-lg border border-sky-100 bg-sky-50 px-4 py-3 text-sm text-sky-800">{isOverview ? "This is the team-lead overview of all standards. It is read-only." : "This is your worklist: only standards assigned to you are displayed and can be scored."}</p>}
      {isSurveyor && !isOverview && outstanding.incompleteAssessmentIds.size > 0 && <section className="mt-5 rounded-xl border border-[#ead7a3] bg-[#fffbf0] p-4 shadow-sm sm:flex sm:items-center sm:justify-between sm:gap-5"><div><p className="text-sm font-bold text-[#624b14]">Scores still to record</p><p className="mt-1 text-sm leading-6 text-[#735b21]">{outstanding.missingScores.length} compliance requirement{outstanding.missingScores.length === 1 ? "" : "s"} in your assigned standards {outstanding.missingScores.length === 1 ? "needs" : "need"} a score.</p></div>{outstanding.nextAssessmentId && <Link onClick={() => showAssessment(outstanding.nextAssessmentId)} to={`/surveys/${surveyId}?resume=${outstanding.nextAssessmentId}`} className="mt-3 inline-block shrink-0 rounded-lg bg-[#d6aa45] px-4 py-2.5 text-sm font-semibold text-[#092a5a] shadow-sm hover:bg-[#c99d38] sm:mt-0">Go to next score</Link>}</section>}
      {isSurveyor && !isOverview && outstanding.incompleteAssessmentIds.size === 0 && <p className="mt-5 rounded-lg border border-teal-100 bg-[#edf8f0] px-4 py-3 text-sm font-medium text-teal-800">All compliance requirements in your assigned standards have a score.</p>}
      {isSurveyor && !isOverview && progress.totalEvidenceChecks > 0 && progress.checkedEvidenceCount === 0 && <p className="mt-3 rounded-lg border border-sky-100 bg-sky-50 px-4 py-3 text-sm text-sky-800">No evidence has been checked yet. Evidence progress is tracked separately and can be completed where it supports your assessment.</p>}
      <div className="mt-6 grid gap-4 lg:grid-cols-[17rem_minmax(0,1fr)] lg:gap-6">
        <aside className="h-fit rounded-xl border border-[#dbe5ef] bg-white p-3 shadow-sm lg:sticky lg:top-5">
          <div className="border-b border-[#e7edf4] px-2 pb-3"><p className="text-xs font-bold uppercase tracking-wider text-[#4b5f7a]">Standards navigator</p><p className="mt-1 text-xs leading-5 text-[#68778c]">Choose one standard to focus on, or use the complete view.</p></div>
          <button onClick={() => setSelectedStandard("")} className={`my-3 w-full rounded-lg px-3 py-2.5 text-left text-sm font-semibold ${selectedStandard === "" ? "bg-[#edf8f0] text-[#16803a]" : "border border-[#dbe5ef] text-[#4b5f7a] hover:bg-slate-50"}`}>All standards <span className="float-right text-xs">{assessments.length}</span></button>
          <div className="max-h-[22rem] space-y-1 overflow-y-auto pr-1 sm:max-h-[26rem]" aria-label="Standards list">
          {standards.map((standard) => {
            const standardCompletion = percentage(standard.scored, standard.total);
            return <button key={standard.id} onClick={() => setSelectedStandard(standard.id)} className={`mb-1 w-full rounded-lg px-3 py-2.5 text-left transition ${selectedStandard === standard.id ? "bg-[#edf8f0] text-[#16803a]" : "text-[#4b5f7a] hover:bg-slate-50"}`}>
              <span className="block truncate text-sm font-semibold">{standard.label}</span>
              <span className="mt-1.5 flex items-center gap-2 text-xs"><span className="h-1.5 flex-1 overflow-hidden rounded-full bg-[#dbe5ef]"><span className="block h-full rounded-full bg-[#16803a]" style={{ width: `${standardCompletion}%` }} /></span>{standardCompletion}%</span>
              {isSurveyor && !isOverview && standard.incompleteCount > 0 && <span className="mt-1 block text-xs font-semibold text-amber-700">{standard.incompleteCount} requirement{standard.incompleteCount === 1 ? "" : "s"} to review</span>}
            </button>;
          })}
          </div>
        </aside>
        <section className={`overflow-hidden rounded-xl border border-[#d3e3f3] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.05)] ${selectedStandard === "" ? "lg:max-h-[calc(100vh-2.5rem)] lg:overflow-y-auto" : ""}`}>
          <div className="sticky top-0 z-10 border-b border-[#bcd9d4] bg-[#edf5fc] px-4 py-3 text-[11px] font-bold uppercase tracking-wider text-[#385273] sm:px-5">{selectedStandard === "" ? "All standards — scroll to review" : "Selected standard — compliance requirements and assessment record"}</div>
          {grouped.map((standard) => <div key={standard.standardId}>
            <div className="border-y border-[#0f6b3c] bg-[#0f6b3c] px-4 py-3 text-white sm:px-5"><p className="text-xs font-bold uppercase tracking-[0.14em]">Standard {standard.standardNumber}</p><h2 className="mt-1 font-semibold">{standard.standardTitle}</h2></div>
            {standard.criteria.map((criterion) => <div key={criterion.criterionId} className="border-b border-[#d3e3f3] last:border-b-0">
              <div className="border-l-4 border-[#d6aa45] bg-[#f6f9fc] px-4 py-3 text-sm text-[#385273] sm:px-5"><p className="text-xs font-bold uppercase tracking-[0.12em] text-[#876318]">Criterion {criterion.criterionNumber}</p><h3 className="mt-1 font-semibold leading-6 text-[#092a5a]">{criterion.criterionTitle || "Criterion title not available"}</h3></div>
              {criterion.assessments.map((assessment) => <article id={`assessment-${assessment.complianceAssessmentId}`} key={assessment.complianceAssessmentId} className="border-t border-[#e1edeb] px-4 py-5 first:border-t-0 sm:px-5">
                <div className="flex gap-3 sm:gap-4"><div className="shrink-0"><p className="font-bold text-[#0f6b3c]">{assessment.complianceNumber}</p><span className={`mt-2 inline-block rounded-full px-2 py-0.5 text-[11px] font-bold ${assessment.scoreId ? "bg-[#edf8f0] text-[#16803a]" : "bg-amber-50 text-amber-700"}`}>{assessment.scoreId ? "Scored" : "To score"}</span></div><h3 className="min-w-0 flex-1 text-left font-semibold leading-6 text-[#092a5a] sm:text-justify">{assessment.complianceSummary}</h3></div>
                <div className="mt-5 rounded-lg border border-[#eadfbd] bg-[#fffbf0] px-4 py-3"><p className="mb-2 text-xs font-bold uppercase tracking-[0.14em] text-[#876318]">Evidence of compliance</p><div className="divide-y divide-[#eadfbd]">{checks[assessment.complianceAssessmentId]?.length ? checks[assessment.complianceAssessmentId].slice().sort((first, second) => String(first.evidenceNumber).localeCompare(String(second.evidenceNumber), undefined, { numeric: true })).map((check) => <label key={check.complianceEvidenceCheckId} className="flex cursor-pointer gap-3 py-3 text-sm leading-6 text-[#4b5f7a]"><input type="checkbox" disabled={!canAssess(assessment)} checked={check.isChecked} onChange={() => toggleEvidence(check)} className="mt-0.5 h-5 w-5 shrink-0 accent-[#16803a]" /><span className="text-left sm:text-justify"><strong className="text-[#092a5a]">{check.evidenceNumber}.</strong> {check.evidenceSummary}</span></label>) : <p className="py-2 text-sm text-[#4b5f7a]">No evidence items are linked to this requirement.</p>}</div></div>
                {isExternal && <InternalReference reference={internalReferences[assessment.complianceId]} />}
                <div className="mt-4 grid gap-4 rounded-lg border border-[#dbe5ef] bg-[#f8fafc] p-4 md:grid-cols-[minmax(10rem,.7fr)_minmax(10rem,.7fr)_minmax(0,1.6fr)]">
                  <label className="text-sm font-semibold text-[#092a5a]"><span>{responseLabel} score</span><select disabled={!canAssess(assessment)} value={assessment.scoreId || ""} onChange={(event) => saveAssessment(assessment.complianceAssessmentId, { scoreId: Number(event.target.value) })} className="mt-1.5 w-full rounded-lg border border-[#c5d4e6] bg-white px-3 py-2.5 text-sm font-medium text-[#092a5a] disabled:bg-slate-50"><option value="">Select score</option>{scores.map((score) => <option key={score.scoreId} value={score.scoreId}>{score.scoreValue == null ? "N/A" : score.scoreLabel}</option>)}</select></label>
                  <label className="text-sm font-semibold text-[#092a5a]"><span>Risk rating</span><select disabled={!canAssess(assessment)} value={assessment.riskRatingId || ""} onChange={(event) => saveAssessment(assessment.complianceAssessmentId, { riskId: Number(event.target.value) })} className="mt-1.5 w-full rounded-lg border border-[#c5d4e6] bg-white px-3 py-2.5 text-sm font-medium text-[#092a5a] disabled:bg-slate-50"><option value="">Select risk</option>{risks.map((risk) => <option key={risk.riskId} value={risk.riskId}>{risk.riskLabel}</option>)}</select></label>
                  <label className="text-sm font-semibold text-[#092a5a]"><span>{commentsLabel}</span><textarea key={`${assessment.complianceAssessmentId}-${assessment.complianceComments || ""}`} disabled={!canAssess(assessment)} defaultValue={assessment.complianceComments || ""} onBlur={(event) => { if (event.target.value !== (assessment.complianceComments || "")) saveAssessment(assessment.complianceAssessmentId, { complianceComments: event.target.value }); }} rows="3" className="mt-1.5 w-full resize-y rounded-lg border border-[#c5d4e6] bg-white px-3 py-2.5 text-sm font-normal text-[#092a5a] disabled:bg-slate-50" placeholder="Record findings or follow-up actions." /></label>
                </div>
              </article>)}
            </div>)}
          </div>)}
        </section>
      </div>
      <ConfirmDialog open={resetOpen} title="Reset this survey?" message="This clears every recorded score, risk rating, comment, and evidence check for this survey. The survey and its checklist will remain in place." confirmLabel={resetting ? "Resetting…" : "Reset survey"} confirmDisabled={resetting} onCancel={() => !resetting && setResetOpen(false)} onConfirm={handleReset} />
    </main>
  );
}

export default SurveyAssessmentPage;
