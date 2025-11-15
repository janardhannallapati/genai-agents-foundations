import { emi } from "../src/payments/emi.js";

test("emi basic", () => {
  const m = emi(500000, 9.5, 240);
  expect(m).toBeGreaterThan(0);
});

test("zero rate", () => {
  expect(emi(1200, 0, 12)).toBe(100);
});
