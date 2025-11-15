Python stack:
create virtualenv:
  python -m venv .venv
  source .venv/bin/activate
  pip install -e .
  pytest -q
