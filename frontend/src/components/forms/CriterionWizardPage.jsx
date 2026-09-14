import { useState, useEffect } from "react";
import { getAll, create } from "../../api/api";

function CriterionWizardForm({ onDone, onCancel, lockedStandardId }) {
  const [standards, setStandards] = useState([]);
  const [criterion, setCriterion] = useState({
    standardId: lockedStandardId ?? "",
    criterionNumber: "",
    criterionTitle: "",
  });
  const [compliances, setCompliances] = useState([]);
  const [error, setError] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [loadingStandards, setLoadingStandards] = useState(!lockedStandardId);

  useEffect(() => {
    if (lockedStandardId) {
      setLoadingStandards(false);
      return;
    }
    getAll("standards")
      .then((res) => setStandards(res.data.sort((first, second) => String(first.standardNumber).localeCompare(String(second.standardNumber), undefined, { numeric: true }))))
      .catch(() => setError("Standards could not be loaded. Close this form and try again."))
      .finally(() => setLoadingStandards(false));
  }, [lockedStandardId]);

  const handleCriterionChange = (e) => {
    setCriterion({ ...criterion, [e.target.name]: e.target.value });
  };

  const addCompliance = () => {
    setCompliances([
      ...compliances,
      { complianceNumber: "", complianceSummary: "", evidenceList: [] },
    ]);
  };

  const removeCompliance = (index) => {
    setCompliances(compliances.filter((_, i) => i !== index));
  };

  const updateCompliance = (index, field, value) => {
    const next = [...compliances];
    next[index] = { ...next[index], [field]: value };
    setCompliances(next);
  };

  const addEvidence = (complianceIndex) => {
    const next = [...compliances];
    next[complianceIndex] = {
      ...next[complianceIndex],
      evidenceList: [
        ...next[complianceIndex].evidenceList,
        { evidenceNumber: "", evidenceSummary: "" },
      ],
    };
    setCompliances(next);
  };

  const removeEvidence = (complianceIndex, evidenceIndex) => {
    const next = [...compliances];
    next[complianceIndex] = {
      ...next[complianceIndex],
      evidenceList: next[complianceIndex].evidenceList.filter((_, i) => i !== evidenceIndex),
    };
    setCompliances(next);
  };

  const updateEvidence = (complianceIndex, evidenceIndex, field, value) => {
    const next = [...compliances];
    const evidenceList = [...next[complianceIndex].evidenceList];
    evidenceList[evidenceIndex] = { ...evidenceList[evidenceIndex], [field]: value };
    next[complianceIndex] = { ...next[complianceIndex], evidenceList };
    setCompliances(next);
  };

  const validate = () => {
    if (!criterion.standardId || !criterion.criterionNumber.trim() || !criterion.criterionTitle.trim()) {
      return "Select a standard and complete the criterion number and title.";
    }
    const complianceNumbers = compliances.map((item) => item.complianceNumber.trim()).filter(Boolean);
    if (new Set(complianceNumbers).size !== complianceNumbers.length) {
      return "Each compliance number must be unique within this criterion.";
    }
    for (const [index, compliance] of compliances.entries()) {
      if (!compliance.complianceNumber.trim() || !compliance.complianceSummary.trim()) {
        return `Complete the number and summary for compliance ${index + 1}.`;
      }
      const evidenceNumbers = compliance.evidenceList.map((item) => item.evidenceNumber.trim()).filter(Boolean);
      if (new Set(evidenceNumbers).size !== evidenceNumbers.length) {
        return `Each evidence number must be unique under compliance ${compliance.complianceNumber}.`;
      }
      if (compliance.evidenceList.some((item) => !item.evidenceNumber.trim() || !item.evidenceSummary.trim())) {
        return `Complete every evidence item under compliance ${compliance.complianceNumber}.`;
      }
    }
    return "";
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    const validationError = validate();
    if (validationError) {
      setError(validationError);
      return;
    }
    setIsSubmitting(true);

    let progress = "creating the criterion";
    try {
      const criterionRes = await create("criteria", {
        ...criterion,
        standardId: Number(criterion.standardId),
      });
      const criterionId = criterionRes.data.criterionId;

      for (let i = 0; i < compliances.length; i++) {
        const c = compliances[i];
        progress = `creating compliance #${i + 1} (${c.complianceNumber || "unnumbered"})`;
        const complianceRes = await create("compliances", {
          criterionId,
          complianceNumber: c.complianceNumber,
          complianceSummary: c.complianceSummary,
        });
        const complianceId = complianceRes.data.complianceId;

        for (let j = 0; j < c.evidenceList.length; j++) {
          const ev = c.evidenceList[j];
          progress = `creating evidence #${j + 1} under compliance #${i + 1}`;
          await create("evidence", {
            complianceId,
            evidenceNumber: ev.evidenceNumber,
            evidenceSummary: ev.evidenceSummary,
          });
        }
      }

      onDone();
    } catch (err) {
      setError(
        `Something went wrong while ${progress}. Everything created before this point was saved — you can finish the rest from the individual pages.`
      );
      console.error(err);
    } finally {
      setIsSubmitting(false);
    }
  };

  const evidenceCount = compliances.reduce((total, compliance) => total + compliance.evidenceList.length, 0);

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <div className="border-b border-[#dbe5ef] pb-5 pr-8"><p className="text-xs font-bold uppercase tracking-[0.16em] text-[#16803a]">Framework builder</p><h2 className="mt-1 text-xl font-bold text-[#092a5a]">Build a criterion and its assessment checklist</h2><p className="mt-2 text-sm leading-6 text-[#68778c]">Create the criterion first, then add the compliance requirements and their evidence in one guided flow.</p><div className="mt-4 grid gap-2 sm:grid-cols-3"><Step label="1. Criterion" detail="Parent standard and title" active /><Step label="2. Compliance" detail={`${compliances.length} added`} active={compliances.length > 0} /><Step label="3. Evidence" detail={`${evidenceCount} added`} active={evidenceCount > 0} /></div></div>

      {error && <div role="alert" className="rounded-lg border border-red-100 bg-red-50 px-4 py-3 text-sm leading-6 text-red-800">{error}</div>}

      {/* Criterion section */}
      <div className="space-y-4 rounded-xl border border-[#c9dded] bg-[#f6f9fc] p-4 sm:p-5">
        <div><p className="text-xs font-bold uppercase tracking-[.14em] text-[#16803a]">Step 1</p><h3 className="mt-1 text-base font-bold text-[#092a5a]">Criterion details</h3></div>
        {!lockedStandardId && (
          <div>
            <label className="mb-1 block text-sm font-semibold text-[#092a5a]">Parent standard</label>
            <select
              name="standardId"
              value={criterion.standardId}
              onChange={handleCriterionChange}
              required
              disabled={loadingStandards}
              className="w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm focus:border-[#16803a] focus:outline-none focus:ring-2 focus:ring-[#bbf7d0] disabled:bg-slate-50"
            >
              <option value="">{loadingStandards ? "Loading standards…" : "Select a standard"}</option>
              {standards.map((s) => (
                <option key={s.standardId} value={s.standardId}>
                  {s.standardNumber} — {s.standardTitle}
                </option>
              ))}
            </select><p className="mt-1.5 text-xs text-[#68778c]">The criterion will be grouped under this NHSS standard.</p>
          </div>
        )}
        <div className="grid gap-4 sm:grid-cols-[10rem_minmax(0,1fr)]"><div>
          <label className="mb-1 block text-sm font-semibold text-[#092a5a]">Criterion number</label>
          <input
            type="text"
            name="criterionNumber"
            value={criterion.criterionNumber}
            onChange={handleCriterionChange}
            required
            maxLength={10}
            placeholder="e.g. 3.1"
            className="w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm focus:border-[#16803a] focus:outline-none focus:ring-2 focus:ring-[#bbf7d0]"
          />
        </div><div>
          <label className="mb-1 block text-sm font-semibold text-[#092a5a]">Criterion title</label>
          <input
            type="text"
            name="criterionTitle"
            value={criterion.criterionTitle}
            onChange={handleCriterionChange}
            required
            maxLength={500}
            placeholder="Describe the measurable requirement"
            className="w-full rounded-lg border border-[#c5d5e8] bg-white px-3 py-2.5 text-sm focus:border-[#16803a] focus:outline-none focus:ring-2 focus:ring-[#bbf7d0]"
          />
        </div></div>
      </div>

      {/* Compliances section */}
      <div className="space-y-4">
        <div className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between"><div><p className="text-xs font-bold uppercase tracking-[.14em] text-[#16803a]">Step 2</p><h3 className="mt-1 text-base font-bold text-[#092a5a]">Compliance requirements</h3><p className="mt-1 text-sm text-[#68778c]">Add every requirement that will receive a score in this criterion.</p></div>
          <button
            type="button"
            onClick={addCompliance}
            className="rounded-md border border-[#c5d5e8] px-3 py-1.5 text-xs font-semibold text-[#16803a] hover:bg-[#edf8f0]"
          >
            + Add Compliance
          </button>
        </div>

        {compliances.length === 0 && <div className="rounded-xl border border-dashed border-[#c5d5e8] bg-[#f8fafc] px-5 py-7 text-center"><p className="font-semibold text-[#092a5a]">No compliance requirements added yet</p><p className="mt-1 text-sm text-[#68778c]">You can create the criterion alone, or add its first requirement now.</p><button type="button" onClick={addCompliance} className="mt-4 rounded-lg border border-[#c5d5e8] bg-white px-4 py-2.5 text-sm font-semibold text-[#16803a] hover:bg-[#edf8f0]">Add first compliance</button></div>}

        {compliances.map((c, cIndex) => (
          <div key={cIndex} className="space-y-4 rounded-xl border border-[#dbe5ef] bg-white p-4 shadow-sm sm:p-5">
            <div className="flex items-center justify-between">
              <span className="text-xs font-semibold text-[#4b5f7a]">Compliance #{cIndex + 1}</span>
              <button
                type="button"
                onClick={() => removeCompliance(cIndex)}
                className="text-xs font-semibold text-red-600 hover:underline"
              >
                Remove
              </button>
            </div>
            <div className="grid gap-3 sm:grid-cols-[10rem_minmax(0,1fr)]"><div>
              <label className="mb-1 block text-sm font-semibold text-[#092a5a]">Number</label>
              <input
                type="text"
                value={c.complianceNumber}
                onChange={(e) => updateCompliance(cIndex, "complianceNumber", e.target.value)}
                required
                maxLength={10}
                placeholder="e.g. 3.1.1"
                className="w-full rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm focus:border-[#16803a] focus:outline-none focus:ring-2 focus:ring-[#bbf7d0]"
              />
            </div><div>
              <label className="mb-1 block text-sm font-semibold text-[#092a5a]">Compliance summary</label>
              <textarea
                value={c.complianceSummary}
                onChange={(e) => updateCompliance(cIndex, "complianceSummary", e.target.value)}
                required
                rows={3}
                placeholder="Describe what the facility must demonstrate."
                className="w-full resize-y rounded-lg border border-[#c5d5e8] px-3 py-2.5 text-sm focus:border-[#16803a] focus:outline-none focus:ring-2 focus:ring-[#bbf7d0]"
              />
            </div></div>

            {/* Nested Evidence list */}
            <div className="space-y-3 border-l-2 border-[#d6aa45] pl-4">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold uppercase tracking-[.12em] text-[#876318]">Evidence of compliance</span>
                <button
                  type="button"
                  onClick={() => addEvidence(cIndex)}
                  className="rounded-md border border-[#c5d5e8] px-2.5 py-1 text-xs font-semibold text-[#16803a] hover:bg-[#edf8f0]"
                >
                  + Add Evidence
                </button>
              </div>

              {c.evidenceList.map((ev, eIndex) => (
                <div key={eIndex} className="space-y-3 rounded-lg border border-[#eadfbd] bg-[#fffbf0] p-3">
                  <div className="flex items-center justify-between">
                    <span className="text-xs text-[#4b5f7a]">Evidence #{eIndex + 1}</span>
                    <button
                      type="button"
                      onClick={() => removeEvidence(cIndex, eIndex)}
                      className="text-xs font-semibold text-red-600 hover:underline"
                    >
                      Remove
                    </button>
                  </div>
                  <div className="grid gap-3 sm:grid-cols-[10rem_minmax(0,1fr)]"><input
                    type="text"
                    placeholder="Number, e.g. 1"
                    value={ev.evidenceNumber}
                    onChange={(e) => updateEvidence(cIndex, eIndex, "evidenceNumber", e.target.value)}
                    required
                    maxLength={10}
                    className="w-full rounded-lg border border-[#c5d4e6] bg-white px-3 py-2.5 text-sm focus:border-[#16803a] focus:outline-none focus:ring-2 focus:ring-[#bbf7d0]"
                  />
                  <textarea
                    placeholder="Evidence summary"
                    value={ev.evidenceSummary}
                    onChange={(e) => updateEvidence(cIndex, eIndex, "evidenceSummary", e.target.value)}
                    required
                    rows={2}
                    className="w-full resize-y rounded-lg border border-[#c5d4e6] bg-white px-3 py-2.5 text-sm focus:border-[#16803a] focus:outline-none focus:ring-2 focus:ring-[#bbf7d0]"
                  />
                  </div>
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>

      <div className="sticky bottom-0 flex flex-col gap-2 border-t border-[#dbe5ef] bg-white pt-4 sm:flex-row sm:justify-end">
        <button
          type="submit"
          disabled={isSubmitting}
          className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#0d6531] disabled:opacity-60"
        >
          {isSubmitting ? "Creating checklist…" : `Create criterion${compliances.length ? ` + ${compliances.length} compliance${compliances.length === 1 ? "" : "s"}` : ""}`}
        </button>
        <button
          type="button"
          onClick={onCancel}
          className="rounded-lg px-4 py-2.5 text-sm font-semibold text-[#4b5f7a] hover:bg-slate-100"
        >
          Cancel
        </button>
      </div>
    </form>
  );
}

function Step({ label, detail, active }) {
  return <div className={`rounded-lg border px-3 py-2 ${active ? "border-[#c5d5e8] bg-white text-[#092a5a]" : "border-[#e3eaf2] bg-white/60 text-[#68778c]"}`}><p className="text-xs font-bold">{label}</p><p className="mt-0.5 text-xs">{detail}</p></div>;
}

export default CriterionWizardForm;
