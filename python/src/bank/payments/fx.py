from __future__ import annotations
from typing import Mapping

def convert(amount: float, from_ccy: str, to_ccy: str, table: Mapping[str, float]) -> float:
    f = table.get(from_ccy)
    t = table.get(to_ccy)
    if f is None or t is None:
        raise KeyError("Unknown currency")
    return amount * (t / f)
