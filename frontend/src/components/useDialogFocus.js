import { useEffect } from "react";

const focusableSelector = 'button:not([disabled]), [href], input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])';

export function useDialogFocus(open, dialogRef, initialFocusRef, onEscape) {
  useEffect(() => {
    if (!open) return undefined;

    const previouslyFocused = document.activeElement;
    initialFocusRef.current?.focus();

    const handleKeyDown = (event) => {
      if (event.key === "Escape") {
        onEscape?.();
        return;
      }
      if (event.key !== "Tab") return;

      const focusable = [...(dialogRef.current?.querySelectorAll(focusableSelector) || [])];
      if (!focusable.length) {
        event.preventDefault();
        return;
      }
      const first = focusable[0];
      const last = focusable[focusable.length - 1];
      if (event.shiftKey && document.activeElement === first) {
        event.preventDefault();
        last.focus();
      } else if (!event.shiftKey && document.activeElement === last) {
        event.preventDefault();
        first.focus();
      }
    };

    window.addEventListener("keydown", handleKeyDown);
    return () => {
      window.removeEventListener("keydown", handleKeyDown);
      previouslyFocused?.focus?.();
    };
  }, [open, dialogRef, initialFocusRef, onEscape]);
}
