import { useCallback, useEffect, useRef, useState } from "react";
import { useDialogFocus } from "./useDialogFocus";
import useUnsavedChanges from "../hooks/useUnsavedChanges";

const formSnapshot = (form) => [...form.querySelectorAll("input, select, textarea")]
    .filter((field) => !["button", "submit", "reset"].includes(field.type))
    .map((field, index) => `${field.name || field.id || index}:${field.type === "checkbox" ? field.checked : field.value}`)
    .join("|");

function FormModal({ open, onClose, children, successMessage, wide = false }) {
    const closeButtonRef = useRef(null);
    const dialogRef = useRef(null);
    const formRef = useRef(null);
    const initialSnapshotRef = useRef("");
    const [saving, setSaving] = useState(false);
    const [dirty, setDirty] = useState(false);
    const onCloseRef = useRef(onClose);
    const savingRef = useRef(saving);

    useEffect(() => {
        onCloseRef.current = onClose;
        savingRef.current = saving;
    }, [onClose, saving]);

    useEffect(() => {
        const onSaveState = (event) => setSaving(Boolean(event.detail));
        window.addEventListener("api-save-state", onSaveState);
        return () => window.removeEventListener("api-save-state", onSaveState);
    }, []);

    const closeOnEscape = useCallback(() => {
        if (savingRef.current) return;
        if (dirty && !window.confirm("You have unsaved changes. Close this form?")) return;
        onCloseRef.current?.();
    }, [dirty]);

    useDialogFocus(open, dialogRef, closeButtonRef, closeOnEscape);

    useEffect(() => {
        if (!open) { setDirty(false); initialSnapshotRef.current = ""; return undefined; }
        const timer = window.setTimeout(() => {
            if (formRef.current) initialSnapshotRef.current = formSnapshot(formRef.current);
        });
        const trackChange = () => {
            if (formRef.current) setDirty(formSnapshot(formRef.current) !== initialSnapshotRef.current);
        };
        const form = formRef.current;
        form?.addEventListener("input", trackChange);
        form?.addEventListener("change", trackChange);
        return () => { window.clearTimeout(timer); form?.removeEventListener("input", trackChange); form?.removeEventListener("change", trackChange); };
    }, [open]);

    useUnsavedChanges(open && dirty && !saving);

    const requestClose = useCallback(() => {
        if (saving) return;
        if (dirty && !window.confirm("You have unsaved changes. Close this form?")) return;
        onCloseRef.current?.();
    }, [dirty, saving]);

    const guardCancelButton = (event) => {
        const button = event.target.closest?.("button[type='button']");
        if (!button || !/^cancel$/i.test(button.textContent.trim()) || !dirty || saving) return;
        if (!window.confirm("You have unsaved changes. Close this form?")) {
            event.preventDefault();
            event.stopPropagation();
        }
    };

    if (!open) return null;

    return (
        <div onMouseDown={(event) => { if (!saving && event.target === event.currentTarget) requestClose(); }} className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/35 p-4 backdrop-blur-sm">
            <div ref={dialogRef} role="dialog" aria-modal="true" className={`relative max-h-[calc(100vh-2rem)] w-full ${wide ? "max-w-4xl" : "max-w-lg"} overflow-y-auto rounded-2xl bg-white p-6 shadow-2xl shadow-slate-900/20`}>
                <button disabled={saving} ref={closeButtonRef} onClick={requestClose} className="absolute right-4 top-4 flex h-8 w-8 items-center justify-center rounded-full text-xl leading-none text-gray-400 transition hover:bg-slate-100 hover:text-gray-600 disabled:opacity-40" aria-label="Close">
                    &times;
                </button>
                {successMessage && (
                    <p className="text-green-600 text-sm mb-3">{successMessage}</p>
                )}
                <div ref={formRef} onClickCapture={guardCancelButton}>{children}</div>
                {saving && <div className="absolute inset-0 flex items-end justify-center rounded-2xl bg-white/70 pb-6 backdrop-blur-[1px]" role="status"><span className="rounded-full bg-[#092a5a] px-4 py-2 text-sm font-semibold text-white">Saving changes…</span></div>}
            </div>
        </div>
    );
}

export default FormModal;
