import { useEffect, useMemo, useState } from "react";
import { Link, useParams, useSearchParams } from "react-router-dom";
import {
  getAll,
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

function ProgressBar({ label, value }) {
  return (
    <div>
      <div className="mb-1.5 flex justify-between gap-3 text-xs font-bold text-[#527076]">
        <span>{label}</span><span className="shrink-0 text-[#143c42]">{value}%</span>
      </div>
      <div className="h-2 overflow-hidden rounded-full bg-[#dce9e7]">
        <div className="h-full rounded-full bg-[#087c77] transition-all duration-500" style={{ width: `${value}%` }} />
      </div>
    </div>
  );
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
  const [selectedStandard, setSelectedStandard] = useState("");
  const [checks, setChecks] = useState({});
  const [resetOpen, setResetOpen] = useState(false);
  const [resetting, setResetting] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const isSurveyor = auth?.roleName === "Surveyor";
  const isAdmin = auth?.roleName === "Admin";
  const isExternal = survey?.surveyTypeName === "External";
  const isOverview = searchParams.get("view") === "overview";

  const load = async () => {
    try {
      setLoading(true);
      const [surveyRes, assessmentRes, progressRes, scoreRes, riskRes, criterionRes, complianceRes, surveyorRes, evidenceRes] = await Promise.all([
        getOne("surveys", surveyId), isOverview ? getSurveyAssessmentOverview(surveyId) : getSurveyAssessments(surveyId), getSurveyProgress(surveyId),
        getAll("scores"), getAll("riskRating"), getAll("criteria"), getAll("compliances"), getAll("surveyors"), getSurveyEvidenceChecks(surveyId),
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
      setError("");
    } catch (loadError) {
      console.error(loadError);
      setError("We couldn't load this assessment. Please confirm the survey exists and has generated its checklist.");
    } finally { setLoading(false); }
  };

  useEffect(() => { load(); }, [surveyId, isOverview]);

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
  const canAssess = (assessment) => !isOverview && (isAdmin || (isSurveyor && assessment.surveyorId === currentSurveyorId));

  const standards = useMemo(() => [...new Map(enriched.filter((item) => item.standardId).map((item) => [item.standardId, {
    id: String(item.standardId), label: `${item.standardNumber} — ${item.standardTitle}`,
    total: enriched.filter((candidate) => candidate.standardId === item.standardId).length,
    scored: enriched.filter((candidate) => candidate.standardId === item.standardId && candidate.scoreId).length,
  }])).values()], [enriched]);

  const grouped = useMemo(() => {
    const visible = enriched.filter((item) => !selectedStandard || String(item.standardId) === selectedStandard);
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
    try { await updateAssessment(assessmentId, data); await load(); } catch (saveError) { console.error(saveError); }
  };
  const toggleEvidence = async (check) => {
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
  if (error) return <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6"><Link to="/surveys" className="text-sm font-semibold text-[#087c77]">← Back to surveys</Link><p className="mt-5 rounded-xl border border-red-100 bg-red-50 p-5 text-sm text-red-800">{error}</p></main>;

  const responseLabel = isExternal ? "Surveyor finding" : "Self-rating";
  const commentsLabel = isExternal ? "Surveyor comments" : "Comments";
  const isTeamLead = isSurveyor && survey?.surveyorId === currentSurveyorId;

  return (
    <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:py-8">
      <Link to="/surveys" className="text-sm font-semibold text-[#087c77] hover:underline">← Back to surveys</Link>
      <header className="mt-5 overflow-hidden rounded-2xl border border-[#bfded8] bg-white shadow-[0_12px_30px_rgba(20,60,66,0.08)]">
        <div className="border-b border-[#b8d9d3] bg-[#0b6f6b] px-5 py-3 text-xs font-bold uppercase tracking-[0.17em] text-white sm:px-7">National Health Service Standards assessment toolkit</div>
        <div className="grid gap-6 bg-[linear-gradient(120deg,#f3faf8_0%,#ffffff_68%,#fcf7ed_100%)] p-5 sm:p-7 lg:grid-cols-[1fr_auto] lg:items-start">
          <div>
            <p className="text-xs font-bold uppercase tracking-[0.16em] text-teal-700">{survey.surveyTypeName} survey</p>
            <h1 className="mt-2 text-3xl font-bold tracking-tight text-[#143c42]">{survey.facilityName}</h1>
            <dl className="mt-4 grid gap-x-8 gap-y-2 text-sm text-[#527076] sm:grid-cols-2">
              <div><dt className="inline font-semibold text-[#143c42]">Team lead:</dt> <dd className="inline">{survey.surveyorName}</dd></div>
              <div><dt className="inline font-semibold text-[#143c42]">Assessment period:</dt> <dd className="inline">{survey.startDate} — {survey.endDate}</dd></div>
            </dl>
          </div>
          <div className="flex flex-col gap-2 sm:flex-row">{isTeamLead && <Link to={isOverview ? `/surveys/${surveyId}` : `/surveys/${surveyId}?view=overview`} className="rounded-lg border border-[#b9d6d1] bg-white px-4 py-2.5 text-center text-sm font-semibold text-[#087c77] shadow-sm hover:bg-teal-50">{isOverview ? "My assigned standards" : "View all scores"}</Link>}{isAdmin && <button onClick={() => setResetOpen(true)} className="w-full rounded-lg border border-red-200 bg-white px-4 py-2.5 text-sm font-semibold text-red-700 shadow-sm transition hover:bg-red-50 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 lg:w-auto">Reset survey</button>}</div>
        </div>
        <div className="grid gap-5 border-t border-[#dce9e7] px-5 py-5 sm:grid-cols-2 sm:px-7">
          <ProgressBar label={`${progress.scoredCount} of ${progress.totalCompliances} requirements scored`} value={completion} />
          <ProgressBar label={`${progress.checkedEvidenceCount} of ${progress.totalEvidenceChecks} evidence checks completed`} value={evidenceCompletion} />
        </div>
      </header>

      {!isAdmin && <p className="mt-5 rounded-lg border border-sky-100 bg-sky-50 px-4 py-3 text-sm text-sky-800">{isOverview ? "This is the team-lead overview of all standards. It is read-only." : "This is your worklist: only standards assigned to you are displayed and can be scored."}</p>}
      <div className="mt-6 grid gap-6 lg:grid-cols-[17rem_minmax(0,1fr)]">
        <aside className="h-fit rounded-xl border border-[#dce9e7] bg-white p-3 shadow-sm lg:sticky lg:top-5">
          <p className="px-2 pb-2 text-xs font-bold uppercase tracking-wider text-[#527076]">Completion tracker</p>
          <button onClick={() => setSelectedStandard("")} className={`mb-1 w-full rounded-lg px-3 py-2.5 text-left text-sm font-semibold ${!selectedStandard ? "bg-teal-50 text-[#087c77]" : "text-[#527076] hover:bg-slate-50"}`}>All standards <span className="float-right text-xs">{assessments.length}</span></button>
          {standards.map((standard) => {
            const standardCompletion = percentage(standard.scored, standard.total);
            return <button key={standard.id} onClick={() => setSelectedStandard(standard.id)} className={`mb-1 w-full rounded-lg px-3 py-2.5 text-left transition ${selectedStandard === standard.id ? "bg-teal-50 text-[#087c77]" : "text-[#527076] hover:bg-slate-50"}`}>
              <span className="block truncate text-sm font-semibold">{standard.label}</span>
              <span className="mt-1.5 flex items-center gap-2 text-xs"><span className="h-1.5 flex-1 overflow-hidden rounded-full bg-[#dce9e7]"><span className="block h-full rounded-full bg-[#087c77]" style={{ width: `${standardCompletion}%` }} /></span>{standardCompletion}%</span>
            </button>;
          })}
        </aside>
        <section className="overflow-hidden rounded-xl border border-[#cfe2df] bg-white shadow-[0_8px_24px_rgba(20,60,66,0.05)]">
          <div className="border-b border-[#bcd9d4] bg-[#eaf5f3] px-5 py-3 text-[11px] font-bold uppercase tracking-wider text-[#315e61]">Compliance requirements and assessment record</div>
          {grouped.map((standard) => <div key={standard.standardId}>
            <div className="border-y border-[#0b6f6b] bg-[#0b6f6b] px-5 py-3 text-white"><p className="text-xs font-bold uppercase tracking-[0.14em]">Standard {standard.standardNumber}</p><h2 className="mt-1 font-semibold">{standard.standardTitle}</h2></div>
            {standard.criteria.map((criterion) => <div key={criterion.criterionId} className="border-b border-[#cfe2df] last:border-b-0">
              <div className="border-l-4 border-[#d6aa45] bg-[#f5faf9] px-5 py-3 text-sm text-[#315e61]"><p className="text-xs font-bold uppercase tracking-[0.12em] text-[#876318]">Criterion {criterion.criterionNumber}</p><h3 className="mt-1 font-semibold leading-6 text-[#143c42]">{criterion.criterionTitle || "Criterion title not available"}</h3></div>
              {criterion.assessments.map((assessment) => <article key={assessment.complianceAssessmentId} className="border-t border-[#e1edeb] px-5 py-5 first:border-t-0">
                <div className="flex gap-4"><div className="shrink-0"><p className="font-bold text-[#0b6f6b]">{assessment.complianceNumber}</p><span className={`mt-2 inline-block rounded-full px-2 py-0.5 text-[11px] font-bold ${assessment.scoreId ? "bg-teal-50 text-teal-700" : "bg-amber-50 text-amber-700"}`}>{assessment.scoreId ? "Scored" : "To score"}</span></div><h3 className="min-w-0 flex-1 text-justify font-semibold leading-6 text-[#143c42]">{assessment.complianceSummary}</h3></div>
                <div className="mt-5 rounded-lg border border-[#eadfbd] bg-[#fffbf0] px-4 py-3"><p className="mb-2 text-xs font-bold uppercase tracking-[0.14em] text-[#876318]">Evidence of compliance</p><div className="divide-y divide-[#eadfbd]">{checks[assessment.complianceAssessmentId]?.length ? checks[assessment.complianceAssessmentId].slice().sort((first, second) => String(first.evidenceNumber).localeCompare(String(second.evidenceNumber), undefined, { numeric: true })).map((check) => <label key={check.complianceEvidenceCheckId} className="flex cursor-pointer gap-3 py-3 text-sm leading-6 text-[#527076]"><input type="checkbox" disabled={!canAssess(assessment)} checked={check.isChecked} onChange={() => toggleEvidence(check)} className="mt-1 h-4 w-4 shrink-0 accent-[#087c77]" /><span className="text-justify"><strong className="text-[#143c42]">{check.evidenceNumber}.</strong> {check.evidenceSummary}</span></label>) : <p className="py-2 text-sm text-[#527076]">No evidence items are linked to this requirement.</p>}</div></div>
                <div className={`mt-4 grid gap-4 rounded-lg border border-[#dce9e7] bg-[#f8fbfa] p-4 ${isExternal ? "md:grid-cols-[minmax(10rem,.7fr)_minmax(10rem,.7fr)_minmax(0,1.6fr)]" : "md:grid-cols-[minmax(11rem,.7fr)_minmax(0,1.6fr)]"}`}>
                  <label className="text-sm font-semibold text-[#143c42]"><span>{responseLabel} score</span><select disabled={!canAssess(assessment)} value={assessment.scoreId || ""} onChange={(event) => saveAssessment(assessment.complianceAssessmentId, { scoreId: Number(event.target.value) })} className="mt-1.5 w-full rounded-lg border border-[#c9ddd9] bg-white px-3 py-2.5 text-sm font-medium text-[#143c42] disabled:bg-slate-50"><option value="">Select score</option>{scores.map((score) => <option key={score.scoreId} value={score.scoreId}>{score.scoreValue == null ? "N/A" : score.scoreLabel}</option>)}</select></label>
                  {isExternal && <label className="text-sm font-semibold text-[#143c42]"><span>Risk rating</span><select disabled={!canAssess(assessment)} value={assessment.riskRatingId || ""} onChange={(event) => saveAssessment(assessment.complianceAssessmentId, { riskId: Number(event.target.value) })} className="mt-1.5 w-full rounded-lg border border-[#c9ddd9] bg-white px-3 py-2.5 text-sm font-medium text-[#143c42] disabled:bg-slate-50"><option value="">Select risk</option>{risks.map((risk) => <option key={risk.riskId} value={risk.riskId}>{risk.riskLabel}</option>)}</select></label>}
                  <label className="text-sm font-semibold text-[#143c42]"><span>{commentsLabel}</span><textarea key={`${assessment.complianceAssessmentId}-${assessment.complianceComments || ""}`} disabled={!canAssess(assessment)} defaultValue={assessment.complianceComments || ""} onBlur={(event) => { if (event.target.value !== (assessment.complianceComments || "")) saveAssessment(assessment.complianceAssessmentId, { complianceComments: event.target.value }); }} rows="3" className="mt-1.5 w-full resize-y rounded-lg border border-[#c9ddd9] bg-white px-3 py-2.5 text-sm font-normal text-[#143c42] disabled:bg-slate-50" placeholder="Record findings or follow-up actions." /></label>
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
