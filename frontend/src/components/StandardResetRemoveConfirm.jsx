import { useEffect, useRef } from "react";
import { canResetAndRemoveStandard } from "../utils/standardRemoval";

export default function StandardResetRemoveConfirm({ standard, reason, confirmed, busy, onReason, onConfirmed, onCancel, onConfirm }) {
  const reasonRef = useRef(null);
  useEffect(() => { reasonRef.current?.focus(); }, [standard.standardId]);
  return <fieldset disabled={busy} className="mt-4 rounded-lg border-2 border-red-300 p-4" aria-label="Reset and remove standard confirmation">
    <legend className="px-2 font-bold">Reset and remove Standard {standard.standardNumber}</legend>
    <p className="text-sm"><strong>{standard.standardTitle}</strong></p>
    <p className="mt-2 text-sm">This permanently deletes this standard’s scores, risk ratings, comments, evidence checks, summations and assignment from this survey. It cannot be undone here. Affected submitted handovers will be reopened for review; saved report versions are preserved.</p>
    <p className="mt-2 text-sm">Other standards, the framework and historical saved report versions are not changed. Adding this standard again creates a blank checklist.</p>
    <label className="mt-3 block text-sm font-semibold">Reason for reset and removal
      <textarea ref={reasonRef} value={reason} maxLength={2000} rows={3} onChange={event => onReason(event.target.value)} className="mt-1 block w-full rounded-lg border border-[#c5d4e6] px-3 py-2 font-normal" />
    </label>
    <label className="mt-3 flex items-start gap-2 text-sm"><input type="checkbox" checked={confirmed} onChange={event => onConfirmed(event.target.checked)} className="mt-1" />I understand that the recorded work for Standard {standard.standardNumber} will be permanently deleted from this survey.</label>
    <div className="mt-3 flex flex-wrap gap-3"><button type="button" disabled={!canResetAndRemoveStandard(reason, confirmed, busy)} onClick={onConfirm} className="rounded-lg bg-red-700 px-3 py-2 text-sm font-semibold text-white disabled:opacity-50">{busy ? "Removing…" : "Permanently reset and remove"}</button><button type="button" onClick={onCancel} className="rounded-lg border px-3 py-2 text-sm">Keep standard</button></div>
  </fieldset>;
}
