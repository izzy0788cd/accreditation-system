import { useEffect, useRef, useState } from "react";
import { useDialogFocus } from "./useDialogFocus";

function FormModal({ open, onClose, children, successMessage, wide = false }) {
    const closeButtonRef = useRef(null);
    const dialogRef = useRef(null);
    const [saving, setSaving] = useState(false);

    useEffect(() => {
        const onSaveState = (event) => setSaving(Boolean(event.detail));
        window.addEventListener("api-save-state", onSaveState);
        return () => window.removeEventListener("api-save-state", onSaveState);
    }, []);

    useDialogFocus(open, dialogRef, closeButtonRef, () => { if (!saving) onClose(); });

    if (!open) return null;

    return (
        <div onMouseDown={(event) => { if (!saving && event.target === event.currentTarget) onClose(); }} className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/35 p-4 backdrop-blur-sm">
            <div ref={dialogRef} role="dialog" aria-modal="true" className={`relative max-h-[calc(100vh-2rem)] w-full ${wide ? "max-w-4xl" : "max-w-lg"} overflow-y-auto rounded-2xl bg-white p-6 shadow-2xl shadow-slate-900/20`}>
                <button disabled={saving} ref={closeButtonRef} onClick={onClose} className="absolute right-4 top-4 flex h-8 w-8 items-center justify-center rounded-full text-xl leading-none text-gray-400 transition hover:bg-slate-100 hover:text-gray-600 disabled:opacity-40" aria-label="Close">
                    &times;
                </button>
                {successMessage && (
                    <p className="text-green-600 text-sm mb-3">{successMessage}</p>
                )}
                {children}
                {saving && <div className="absolute inset-0 flex items-end justify-center rounded-2xl bg-white/70 pb-6 backdrop-blur-[1px]" role="status"><span className="rounded-full bg-[#092a5a] px-4 py-2 text-sm font-semibold text-white">Saving changes…</span></div>}
            </div>
        </div>
    );
}

export default FormModal;
