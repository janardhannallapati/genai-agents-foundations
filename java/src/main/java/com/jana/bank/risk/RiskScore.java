package com.jana.bank.risk;

public final class RiskScore {
  private RiskScore() {}
  public static double utilScore(int txnCount, int lateDays) {
    double s = 100.0 - (lateDays * 1.5) - (txnCount * 1.0 * 0.2);
    return Math.max(0.0, s);
  }
  public static String segment(double score) {
    if (score >= 80) return "LOW";
    if (score >= 50) return "MEDIUM";
    return "HIGH";
  }
}
