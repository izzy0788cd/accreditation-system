export function groupBy(items, getKey) {
  return Object.values(items.reduce((groups, item) => {
    const key = getKey(item);
    (groups[key] ||= []).push(item);
    return groups;
  }, {}));
}
