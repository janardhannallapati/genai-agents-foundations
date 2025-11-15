import { utilScore, segment } from "../src/risk/score.js";

test("score range & segment", () => {
  const s = utilScore(120, 3);
  expect(s).toBeGreaterThanOrEqual(0);
  expect(s).toBeLessThanOrEqual(100);
  expect(["LOW", "MEDIUM", "HIGH"]).toContain(segment(s));
});
