function Reveal({ children, delay = 0, className = "" }) {
  return <div className={`reveal motion-reduce:opacity-100 motion-reduce:translate-y-0 ${className}`} style={{ "--reveal-delay": `${delay}ms` }}>{children}</div>;
}

export default Reveal;
