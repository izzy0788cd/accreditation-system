export const MAX_SCORE_VALUE = 4;

export const scoreScale = [
  { value: 4, label: "Full achievement" },
  { value: 3, label: "Good achievement" },
  { value: 2, label: "Fair achievement" },
  { value: 1, label: "Poor achievement" },
];

export function scoreOutcomeLabel(scoreValue) {
  return scoreScale.find((score) => score.value === Number(scoreValue))?.label || "Unknown score";
}

export function isPriorityScore(scoreValue) {
  return [1, 2].includes(Number(scoreValue));
}

export function scoreTone(scoreValue) {
  return ({
    1: "bg-red-50 text-red-700 ring-red-200",
    2: "bg-amber-50 text-amber-800 ring-amber-200",
    3: "bg-sky-50 text-sky-800 ring-sky-200",
    4: "bg-[#edf8f0] text-[#16803a] ring-[#bbf7d0]",
  })[Number(scoreValue)] || "bg-slate-100 text-slate-600 ring-slate-200";
}
