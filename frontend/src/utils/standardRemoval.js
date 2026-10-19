export function canResetAndRemoveStandard(reason, confirmed, busy = false) {
  return !busy && confirmed === true && typeof reason === "string" && reason.trim().length > 0 && reason.trim().length <= 2000;
}
