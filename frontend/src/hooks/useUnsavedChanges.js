import { useEffect } from "react";

// Protects both browser closing/refresh and ordinary in-app link navigation.
// The API remains the source of truth; this simply prevents accidental loss of
// narrative form work before it has been saved.
export default function useUnsavedChanges(dirty, message = "You have unsaved changes. Leave this page?") {
  useEffect(() => {
    if (!dirty) return undefined;
    const onBeforeUnload = (event) => { event.preventDefault(); event.returnValue = message; return message; };
    const onDocumentClick = (event) => {
      if (event.defaultPrevented || event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
      const link = event.target.closest?.("a[href]");
      if (!link || link.target === "_blank" || link.hasAttribute("download")) return;
      const destination = new URL(link.href, window.location.href);
      const current = new URL(window.location.href);
      if (destination.href === current.href || !window.confirm(message)) event.preventDefault();
    };
    window.addEventListener("beforeunload", onBeforeUnload);
    document.addEventListener("click", onDocumentClick, true);
    return () => {
      window.removeEventListener("beforeunload", onBeforeUnload);
      document.removeEventListener("click", onDocumentClick, true);
    };
  }, [dirty, message]);
}
