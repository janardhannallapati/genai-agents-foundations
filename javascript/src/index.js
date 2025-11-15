import { emi } from "./payments/emi.js";
import { utilScore, segment } from "./risk/score.js";

console.log("EMI:", emi(500000, 9.5, 240).toFixed(2));
const s = utilScore(120, 3);
console.log("Score:", s, "Segment:", segment(s));
