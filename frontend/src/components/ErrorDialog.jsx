import { useRef } from "react";
import { useDialogFocus } from "./useDialogFocus";

function ErrorDialog({ message, onClose }) {
  const closeButtonRef = useRef(null);
  const dialogRef = useRef(null);
  useDialogFocus(Boolean(message), dialogRef, closeButtonRef, onClose);
  if (!message) return null;
  return <div onMouseDown={(event) => { if (event.target === event.currentTarget) onClose(); }} className="fixed inset-0 z-[60] flex items-center justify-center bg-slate-950/35 p-4"><div ref={dialogRef} role="alertdialog" aria-modal="true" aria-labelledby="save-error-title" className="w-full max-w-md rounded-2xl bg-white p-6 shadow-2xl"><div className="mb-4 flex h-10 w-10 items-center justify-center rounded-full bg-red-50 font-bold text-red-700">!</div><h2 id="save-error-title" className="text-xl font-bold text-[#092a5a]">Couldn’t save changes</h2><p className="mt-2 text-sm leading-6 text-[#4b5f7a]">{message}</p><div className="mt-6 flex justify-end"><button ref={closeButtonRef} onClick={onClose} className="rounded-lg bg-[#16803a] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#0d6531]">OK</button></div></div></div>;
}
export default ErrorDialog;
