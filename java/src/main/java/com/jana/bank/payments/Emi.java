package com.jana.bank.payments;

public final class Emi {
  private Emi() {}
  public static double calculate(double principal, double annualRatePct, int months) {
    if (months <= 0 || principal < 0) throw new IllegalArgumentException("Invalid inputs");
    double r = annualRatePct / 12.0 / 100.0;
    return r != 0 ? (principal * r) / (1 - Math.pow(1 + r, -months)) : principal / months;
  }
}
