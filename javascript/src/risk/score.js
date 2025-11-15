export function utilScore(txnCount, lateDays) {
  return Math.max(0, 100 - lateDays * 1.5 - txnCount * 0.2);
}

export function segment(score) {
  if (score >= 80) return "LOW";
  if (score >= 50) return "MEDIUM";
  return "HIGH";
}
