export function emi(principal, annualRatePct, months) {
  if (months <= 0 || principal < 0) throw new Error("Invalid inputs");
  const r = annualRatePct / 12 / 100;
  return r !== 0 ? (principal * r) / (1 - (1 + r) ** (-months)) : principal / months;
}
