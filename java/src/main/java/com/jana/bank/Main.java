package com.jana.bank;

import com.jana.bank.payments.Emi;
import com.jana.bank.risk.RiskScore;

public class Main {
  public static void main(String[] args) {
    System.out.printf("EMI: %.2f%n", Emi.calculate(500_000, 9.5, 240));
    double s = RiskScore.utilScore(120, 3);
    System.out.println("Score: " + s + ", Segment: " + RiskScore.segment(s));
  }
}
