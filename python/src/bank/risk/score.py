def util_score(txn_count: int, late_days: int) -> float:
    return max(0.0, 100.0 - (late_days * 1.5) - (txn_count * 0.2))

def segment(score: float) -> str:
    if score >= 80: return "LOW"
    if score >= 50: return "MEDIUM"
    return "HIGH"
