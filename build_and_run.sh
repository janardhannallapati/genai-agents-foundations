#!/usr/bin/env bash
set -euo pipefail
# ROOT_DIR="$(pwd)"
# ZIP_NAME="genai-agents-foundations.zip"
# WORK_DIR="${HOME}/genai-agents-foundations-run"
# zip -r "$ZIP_NAME" . -x "**/.venv/**" "**/node_modules/**" "**/target/**" || true
# rm -rf "$WORK_DIR"
# mkdir -p "$WORK_DIR"
# unzip -q "$ZIP_NAME" -d "$WORK_DIR"
# cd "$WORK_DIR"
if [ -d "python" ]; then
  cd python
  python -m venv .venv || python3 -m venv .venv
  source .venv/scripts/activate
  python -m pip install --upgrade pip setuptools wheel
  pip install -e . || true
  pytest -q || true
  deactivate
  cd ..
fi
if [ -d "java" ]; then
  cd java
  mvn -q -DskipTests package || true
  if [ -d "target/classes" ]; then
    java -p target/classes -m com.jana.bank/com.jana.bank.Main || true
  fi
  mvn -q test || true
  cd ..
fi
if [ -d "javascript" ]; then
  cd javascript
  if command -v pnpm >/dev/null 2>&1; then
    pnpm i || true
    pnpm test || true
  else
    npm i || true
    npm test || true
  fi
  node src/index.js || true
  cd ..
fi
echo "Done."
