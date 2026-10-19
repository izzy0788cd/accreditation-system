import { achievementPoints } from "../utils/reportScope.js";
import { useState } from "react";

function CompletionBar({ label, complete, total }) {
  const percent = total ? Math.round(complete / total * 100) : 0;
  return <div className="mt-3">
    <div className="mb-2 flex flex-wrap justify-between gap-2 text-sm"><span>{label}</span><span className="font-semibold">{complete} / {total} · {total ? `${percent}%` : "No items"}</span></div>
    <div role="progressbar" aria-label={label} aria-valuemin={0} aria-valuemax={100} aria-valuenow={percent} aria-valuetext={`${complete} of ${total}`} className="h-4 overflow-hidden rounded-full bg-[#dbe5ef]">
      <div className="h-full rounded-full bg-[#16803a]" style={{ width: `${percent}%` }} />
    </div>
  </div>;
}

export default function SurveyTeamProgressCharts({ team, standardRows }) {
  const [surveyor, setSurveyor] = useState("");
  const visible = team.filter(member => !surveyor || String(member.surveyorId) === surveyor);
  return <section className="mt-6 rounded-xl border border-[#dbe5ef] bg-white text-[#092a5a] shadow-sm">
    <header className="flex flex-wrap items-end justify-between gap-4 border-b border-[#dbe5ef] p-5">
      <div><h2 className="text-lg font-bold">Surveyor progress</h2><p className="mt-1 text-sm text-[#68778c]">Completion includes N/A. Achievement shows earned points / possible points and percentage.</p></div>
      <label className="text-sm font-semibold">Surveyor<select className="mt-1 block w-full rounded-lg border border-[#c5d5e8] bg-white p-2" value={surveyor} onChange={event => setSurveyor(event.target.value)}><option value="">All surveyors</option>{team.map(member => <option key={member.surveyorId} value={member.surveyorId}>{member.name || "Unassigned"}</option>)}</select></label>
    </header>
    {!visible.length && <p className="p-5">No assigned assessment requirements to display yet.</p>}
    <div className="grid gap-5 p-5 lg:grid-cols-2">
      {visible.map(member => {
        const assigned = standardRows.map(standard => ({ ...standard, entries: standard.entries.filter(entry => entry.surveyorId === member.surveyorId) })).filter(standard => standard.entries.length);
        const points = achievementPoints(assigned.flatMap(s => s.entries));
        return <article key={member.surveyorId} className="min-w-0 rounded-xl border border-[#dbe5ef] p-4 sm:p-5">
          <h3 className="text-lg font-bold">{member.name || "Unassigned"}</h3>
          <p className="mt-1 text-sm text-[#68778c]">{assigned.length} standard{assigned.length === 1 ? "" : "s"} · {member.requirements - member.scored} requirements remaining · {member.risks} risk ratings recorded</p>
          <CompletionBar label="Overall scoring completion" complete={member.scored} total={member.requirements} />
          <CompletionBar label="Achievement score" complete={points.earned} total={points.possible} />
          <div className="mt-6 space-y-5 border-t border-[#dbe5ef] pt-4">
            {assigned.map(standard => <div key={standard.standardId}>
              <h4 className="break-words text-sm font-semibold">{standard.standardNumber} · {standard.standardTitle}</h4>
              <CompletionBar label="Requirements scored" complete={standard.entries.filter(entry => entry.scoreId != null).length} total={standard.entries.length} />
              <CompletionBar label="Achievement score" complete={achievementPoints(standard.entries).earned} total={achievementPoints(standard.entries).possible} />
            </div>)}
          </div>
        </article>;
      })}
    </div>
    <p className="border-t border-[#dbe5ef] px-5 py-3 text-xs text-[#68778c]">Achievement = earned points ÷ possible points × 100 (maximum 4 per scored requirement). N/A and unscored requirements are excluded; scores are provisional while work is incomplete. Completion does not confirm that a summation has been submitted.</p>
  </section>;
}
