package com.jana.bank.risk;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

class RiskScoreTest {
  @Test
  void utilScoreWithinRange() {
    double s = RiskScore.utilScore(120, 3);
    assertTrue(s >= 0 && s <= 100);
  }
  @Test
  void segments() {
    assertEquals("LOW", RiskScore.segment(85));
    assertEquals("MEDIUM", RiskScore.segment(60));
    assertEquals("HIGH", RiskScore.segment(40));
  }
}
