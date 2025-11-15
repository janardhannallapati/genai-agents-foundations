from __future__ import annotations

def emi(principal: float, annual_rate_pct: float, months: int) -> float:
    if months <= 0 or principal < 0:
        raise ValueError("Invalid inputs")
    r = annual_rate_pct / 12.0 / 100.0
    return (principal * r) / (1 - (1 + r) ** (-months)) if r != 0 else principal / months
