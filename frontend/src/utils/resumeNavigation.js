// Data refreshes are not navigation. Consume a resume scroll only after its
// element exists, so initial loading and effect cleanup cannot lose the request.
export function createResumeNavigation() {
  let currentKey;
  let completed = false;
  return {
    visit(key) {
      if (currentKey !== key) {
        currentKey = key;
        completed = false;
      }
    },
    isPending(key) { return currentKey === key && !completed; },
    complete(key) { if (currentKey === key) completed = true; },
  };
}
