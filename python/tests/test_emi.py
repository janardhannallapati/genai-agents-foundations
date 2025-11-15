import math
from bank.payments.emi import emi

def test_emi_basic():
    monthly = emi(500_000, 9.5, 240)
    assert monthly > 0

def test_emi_zero_rate():
    assert emi(1200, 0, 12) == 100
