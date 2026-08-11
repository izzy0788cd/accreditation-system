function FormModal({ open, onClose, children, successMessage }) {
    if (!open) return null;

    return (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
            <div className="bg-white rounded-lg shadow-lg p-6 w-full max-w-4xl relative">
                <button onClick={onClose} className="absolute top-3 right-3 text-gray-400 hover:text-gray-600 text-xl leading-none" aria-label="Close">
                    &times;
                </button>
                {successMessage && (
                    <p className="text-green-600 text-sm mb-3">{successMessage}</p>
                )}
                {children}
            </div>
        </div>
    );
}

export default FormModal;