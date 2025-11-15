package com.jana.bank.payments;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

class EmiTest {
  @Test
  void calculatesEmi() {
    double m = Emi.calculate(500_000, 9.5, 240);
    assertTrue(m > 0);
  }
  @Test
  void zeroRate() {
    assertEquals(100.0, Emi.calculate(1200, 0, 12));
  }
}
