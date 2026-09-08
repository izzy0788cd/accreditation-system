import { useEffect, useState } from "react";

function AnimatedNumber({ value, loading = false }) {
  const [displayValue, setDisplayValue] = useState(0);

  useEffect(() => {
    if (loading || !Number.isFinite(value)) return undefined;
    const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    if (reducedMotion) { setDisplayValue(value); return undefined; }
    const start = performance.now();
    const duration = 550;
    let frameId;
    const tick = (now) => {
      const progress = Math.min((now - start) / duration, 1);
      setDisplayValue(Math.round(value * (1 - (1 - progress) ** 3)));
      if (progress < 1) frameId = requestAnimationFrame(tick);
    };
    frameId = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(frameId);
  }, [value, loading]);

  return loading ? "…" : displayValue.toLocaleString();
}

export default AnimatedNumber;
