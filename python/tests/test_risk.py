from bank.risk import util_score, segment

def test_util_score_and_segment():
    s = util_score(txn_count=120, late_days=3)
    assert 0 <= s <= 100
    seg = segment(s)
    assert seg in {"LOW", "MEDIUM", "HIGH"}
