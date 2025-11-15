export function convert(amount, fromCcy, toCcy, table) {
  const f = table[fromCcy];
  const t = table[toCcy];
  if (f == null || t == null) throw new Error("Unknown currency");
  return amount * (t / f);
}
