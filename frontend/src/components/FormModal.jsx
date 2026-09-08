import { useEffect, useRef, useState } from "react";

function FormModal({ open, onClose, children, successMessage }) {
    const closeButtonRef = useRef(null);
    const [saving, setSaving] = useState(false);

    useEffect(() => {
        const onSaveState = (event) => setSaving(Boolean(event.detail));
        window.addEventListener("api-save-state", onSaveState);
        return () => window.removeEventListener("api-save-state", onSaveState);
    }, []);

    useEffect(() => {
        if (!open) return undefined;
        closeButtonRef.current?.focus();
        const handleKeyDown = (event) => {
            if (event.key === "Escape") onClose();
        };
        window.addEventListener("keydown", handleKeyDown);
        return () => window.removeEventListener("keydown", handleKeyDown);
    }, [open, onClose]);

    if (!open) return null;

    return (
        <div onMouseDown={(event) => { if (!saving && event.target === event.currentTarget) onClose(); }} className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/35 p-4 backdrop-blur-sm">
            <div role="dialog" aria-modal="true" className="relative max-h-[calc(100vh-2rem)] w-full max-w-lg overflow-y-auto rounded-2xl bg-white p-6 shadow-2xl shadow-slate-900/20">
                <button disabled={saving} ref={closeButtonRef} onClick={onClose} className="absolute right-4 top-4 flex h-8 w-8 items-center justify-center rounded-full text-xl leading-none text-gray-400 transition hover:bg-slate-100 hover:text-gray-600 disabled:opacity-40" aria-label="Close">
                    &times;
                </button>
                {successMessage && (
                    <p className="text-green-600 text-sm mb-3">{successMessage}</p>
                )}
                {children}
                {saving && <div className="absolute inset-0 flex items-end justify-center rounded-2xl bg-white/70 pb-6 backdrop-blur-[1px]" role="status"><span className="rounded-full bg-[#143c42] px-4 py-2 text-sm font-semibold text-white">Saving changes…</span></div>}
            </div>
        </div>
    );
}

export default FormModal;
