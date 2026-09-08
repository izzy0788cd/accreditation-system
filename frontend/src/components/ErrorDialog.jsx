function ErrorDialog({ message, onClose }) {
  if (!message) return null;
  return <div className="fixed inset-0 z-[60] flex items-center justify-center bg-slate-950/35 p-4"><div role="alertdialog" aria-modal="true" className="w-full max-w-md rounded-2xl bg-white p-6 shadow-2xl"><div className="mb-4 flex h-10 w-10 items-center justify-center rounded-full bg-red-50 font-bold text-red-700">!</div><h2 className="text-xl font-bold text-[#143c42]">Couldn’t save changes</h2><p className="mt-2 text-sm leading-6 text-[#527076]">{message}</p><div className="mt-6 flex justify-end"><button autoFocus onClick={onClose} className="rounded-lg bg-[#087c77] px-4 py-2.5 text-sm font-semibold text-white hover:bg-[#05635f]">OK</button></div></div></div>;
}
export default ErrorDialog;
