import { useEffect, useRef } from "react";

function ConfirmDialog({ open, title, message, onConfirm, onCancel, confirmLabel = "Delete", confirmDisabled = false }) {
  const cancelButtonRef = useRef(null);

  useEffect(() => {
    if (!open) return undefined;
    cancelButtonRef.current?.focus();
    const handleKeyDown = (event) => {
      if (event.key === "Escape") onCancel();
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [open, onCancel]);

  if (!open) return null;

  return (
    <div onMouseDown={(event) => { if (event.target === event.currentTarget) onCancel(); }} className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/35 p-4 backdrop-blur-sm">
      <div role="alertdialog" aria-modal="true" aria-labelledby="confirm-dialog-title" className="w-full max-w-md rounded-2xl border border-red-100 bg-white p-6 shadow-2xl shadow-slate-900/20">
        <div className="mb-4 flex h-10 w-10 items-center justify-center rounded-full bg-red-50 text-lg font-bold text-red-700" aria-hidden="true">!</div>
        <h2 id="confirm-dialog-title" className="text-xl font-bold text-[#143c42]">{title}</h2>
        <p className="mt-2 text-sm leading-6 text-[#527076]">{message}</p>
        <div className="mt-6 flex justify-end gap-3">
          <button
            ref={cancelButtonRef}
            onClick={onCancel}
            className="rounded-lg border border-[#b9d6d1] px-4 py-2.5 text-sm font-semibold text-[#527076] transition hover:bg-slate-50"
          >
            Cancel
          </button>
          <button
            onClick={onConfirm}
            disabled={confirmDisabled}
            className="rounded-lg bg-red-700 px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-red-800 focus:outline-none focus:ring-2 focus:ring-red-600 focus:ring-offset-2"
          >
            {confirmLabel}
          </button>
        </div>
      </div>
    </div>
  );
}

export default ConfirmDialog;
