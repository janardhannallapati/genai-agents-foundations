#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="genai-agents-foundations"
GITHUB_USER="janardhannallapati"
ROOT="."

# ------------------ .gitignore ------------------
cat > .gitignore <<'EOF'
# Python
.python-version
.venv/
__pycache__/
*.pyc
dist/
build/
*.egg-info

# Java / Maven
target/
*.class

# Node
node_modules/
pnpm-lock.yaml

# OS
.DS_Store
.idea/
.vscode/
*.log

# archives
*.zip
EOF

# ------------------ README.md ------------------
cat > README.md <<'EOF'
# genai-agents-foundations

Tri-language starter (Python + Java + JavaScript) for learning virtual environments, modules, and imports.
Package / module base: **com.jana.bank**

Quick start:
- Python: `cd python && python -m venv .venv && source .venv/bin/activate && pip install -e . && pytest -q`
- Java: `cd java && mvn -q package && java -p target/classes -m com.jana.bank/com.jana.bank.Main`
- JS: `cd javascript && pnpm i && pnpm test && node src/index.js`

See language folders for details.
EOF

# ------------------ datasets/README.md ------------------
mkdir -p datasets
cat > datasets/README.md <<'EOF'
Place CSV/JSON datasets here for RAG/ML exercises:
- creditcard_fraud.csv
- lending_club.csv
- products.csv
EOF

# ------------------ Python project ------------------
mkdir -p python/src/bank/payments python/src/bank/risk python/tests

cat > python/pyproject.toml <<'EOF'
[build-system]
requires = ["setuptools>=66", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "bank"
version = "0.1.0"
description = "Banking utilities for learning modules/imports"
requires-python = ">=3.10"
dependencies = [
  "numpy>=1.26",
  "pandas>=2.0"
]

[tool.setuptools.packages.find]
where = ["src"]

[tool.pytest.ini_options]
addopts = "-q"
pythonpath = ["src"]
EOF

cat > python/README.md <<'EOF'
Python stack:
create virtualenv:
  python -m venv .venv
  source .venv/bin/activate
  pip install -e .
  pytest -q
EOF

cat > python/src/bank/__init__.py <<'EOF'
__all__ = ["payments", "risk"]
EOF

cat > python/src/bank/payments/__init__.py <<'EOF'
from .emi import emi
from .fx import convert
__all__ = ["emi", "convert"]
EOF

cat > python/src/bank/payments/emi.py <<'EOF'
from __future__ import annotations

def emi(principal: float, annual_rate_pct: float, months: int) -> float:
    if months <= 0 or principal < 0:
        raise ValueError("Invalid inputs")
    r = annual_rate_pct / 12.0 / 100.0
    return (principal * r) / (1 - (1 + r) ** (-months)) if r != 0 else principal / months
EOF

cat > python/src/bank/payments/fx.py <<'EOF'
from __future__ import annotations
from typing import Mapping

def convert(amount: float, from_ccy: str, to_ccy: str, table: Mapping[str, float]) -> float:
    f = table.get(from_ccy)
    t = table.get(to_ccy)
    if f is None or t is None:
        raise KeyError("Unknown currency")
    return amount * (t / f)
EOF

cat > python/src/bank/risk/__init__.py <<'EOF'
from .score import util_score, segment
__all__ = ["util_score", "segment"]
EOF

cat > python/src/bank/risk/score.py <<'EOF'
def util_score(txn_count: int, late_days: int) -> float:
    return max(0.0, 100.0 - (late_days * 1.5) - (txn_count * 0.2))

def segment(score: float) -> str:
    if score >= 80: return "LOW"
    if score >= 50: return "MEDIUM"
    return "HIGH"
EOF

cat > python/tests/test_emi.py <<'EOF'
import math
from bank.payments.emi import emi

def test_emi_basic():
    monthly = emi(500_000, 9.5, 240)
    assert monthly > 0

def test_emi_zero_rate():
    assert emi(1200, 0, 12) == 100
EOF

cat > python/tests/test_risk.py <<'EOF'
from bank.risk import util_score, segment

def test_util_score_and_segment():
    s = util_score(txn_count=120, late_days=3)
    assert 0 <= s <= 100
    seg = segment(s)
    assert seg in {"LOW", "MEDIUM", "HIGH"}
EOF

# ------------------ Java (Maven + JPMS) ------------------
mkdir -p java/src/main/java/com/jana/bank/payments java/src/main/java/com/jana/bank/risk java/src/main/java/com/jana/bank java/src/test/java/com/jana/bank/payments java/src/test/java/com/jana/bank/risk

cat > java/pom.xml <<'EOF'
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.jana</groupId>
  <artifactId>bank</artifactId>
  <version>0.1.0</version>
  <name>com.jana.bank</name>
  <properties>
    <maven.compiler.source>21</maven.compiler.source>
    <maven.compiler.target>21</maven.compiler.target>
    <junit.jupiter.version>5.10.2</junit.jupiter.version>
    <mockito.version>5.11.0</mockito.version>
  </properties>
  <dependencies>
    <dependency>
      <groupId>org.junit.jupiter</groupId>
      <artifactId>junit-jupiter</artifactId>
      <version>${junit.jupiter.version}</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.mockito</groupId>
      <artifactId>mockito-core</artifactId>
      <version>${mockito.version}</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
  <build>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-surefire-plugin</artifactId>
        <version>3.2.5</version>
        <configuration>
          <useModulePath>true</useModulePath>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
EOF

cat > java/src/main/java/module-info.java <<'EOF'
module com.jana.bank {
  exports com.jana.bank.payments;
  exports com.jana.bank.risk;
}
EOF

cat > java/src/main/java/com/jana/bank/payments/Emi.java <<'EOF'
package com.jana.bank.payments;

public final class Emi {
  private Emi() {}
  public static double calculate(double principal, double annualRatePct, int months) {
    if (months <= 0 || principal < 0) throw new IllegalArgumentException("Invalid inputs");
    double r = annualRatePct / 12.0 / 100.0;
    return r != 0 ? (principal * r) / (1 - Math.pow(1 + r, -months)) : principal / months;
  }
}
EOF

cat > java/src/main/java/com/jana/bank/risk/RiskScore.java <<'EOF'
package com.jana.bank.risk;

public final class RiskScore {
  private RiskScore() {}
  public static double utilScore(int txnCount, int lateDays) {
    double s = 100.0 - (lateDays * 1.5) - (txnCount * 1.0 * 0.2);
    return Math.max(0.0, s);
  }
  public static String segment(double score) {
    if (score >= 80) return "LOW";
    if (score >= 50) return "MEDIUM";
    return "HIGH";
  }
}
EOF

cat > java/src/main/java/com/jana/bank/Main.java <<'EOF'
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
EOF

cat > java/src/test/java/com/jana/bank/payments/EmiTest.java <<'EOF'
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
EOF

cat > java/src/test/java/com/jana/bank/risk/RiskScoreTest.java <<'EOF'
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
EOF

# ------------------ JavaScript (pnpm + ESM + Jest + Playwright) ------------------
mkdir -p javascript/src/payments javascript/src/risk javascript/test javascript/playwright

cat > javascript/package.json <<'EOF'
{
  "name": "banking-lab",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "test": "node --experimental-vm-modules ./node_modules/jest/bin/jest.js --runInBand",
    "e2e": "playwright test"
  },
  "devDependencies": {
    "@playwright/test": "^1.47.0",
    "jest": "^29.7.0"
  }
}
EOF

cat > javascript/src/payments/emi.js <<'EOF'
export function emi(principal, annualRatePct, months) {
  if (months <= 0 || principal < 0) throw new Error("Invalid inputs");
  const r = annualRatePct / 12 / 100;
  return r !== 0 ? (principal * r) / (1 - (1 + r) ** (-months)) : principal / months;
}
EOF

cat > javascript/src/payments/fx.js <<'EOF'
export function convert(amount, fromCcy, toCcy, table) {
  const f = table[fromCcy];
  const t = table[toCcy];
  if (f == null || t == null) throw new Error("Unknown currency");
  return amount * (t / f);
}
EOF

cat > javascript/src/risk/score.js <<'EOF'
export function utilScore(txnCount, lateDays) {
  return Math.max(0, 100 - lateDays * 1.5 - txnCount * 0.2);
}

export function segment(score) {
  if (score >= 80) return "LOW";
  if (score >= 50) return "MEDIUM";
  return "HIGH";
}
EOF

cat > javascript/src/index.js <<'EOF'
import { emi } from "./payments/emi.js";
import { utilScore, segment } from "./risk/score.js";

console.log("EMI:", emi(500000, 9.5, 240).toFixed(2));
const s = utilScore(120, 3);
console.log("Score:", s, "Segment:", segment(s));
EOF

cat > javascript/test/emi.test.js <<'EOF'
import { emi } from "../src/payments/emi.js";

test("emi basic", () => {
  const m = emi(500000, 9.5, 240);
  expect(m).toBeGreaterThan(0);
});

test("zero rate", () => {
  expect(emi(1200, 0, 12)).toBe(100);
});
EOF

cat > javascript/test/score.test.js <<'EOF'
import { utilScore, segment } from "../src/risk/score.js";

test("score range & segment", () => {
  const s = utilScore(120, 3);
  expect(s).toBeGreaterThanOrEqual(0);
  expect(s).toBeLessThanOrEqual(100);
  expect(["LOW", "MEDIUM", "HIGH"]).toContain(segment(s));
});
EOF

cat > javascript/playwright/playwright.config.js <<'EOF'
import { defineConfig } from "@playwright/test";
export default defineConfig({
  testDir: "./",
});
EOF

cat > javascript/playwright/example.spec.js <<'EOF'
import { test, expect } from "@playwright/test";

test("placeholder e2e", async ({ page }) => {
  await page.goto("https://example.com");
  await expect(page).toHaveTitle(/Example/);
});
EOF

# ------------------ automation scripts ------------------
cat > build_and_run.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(pwd)"
ZIP_NAME="genai-agents-foundations.zip"
WORK_DIR="${HOME}/genai-agents-foundations-run"
zip -r "$ZIP_NAME" . -x "**/.venv/**" "**/node_modules/**" "**/target/**" || true
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
unzip -q "$ZIP_NAME" -d "$WORK_DIR"
cd "$WORK_DIR"
if [ -d "python" ]; then
  cd python
  python -m venv .venv || python3 -m venv .venv
  source .venv/bin/activate
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
echo "Done. Work dir: $WORK_DIR"
EOF
chmod +x build_and_run.sh

cat > build_and_run.ps1 <<'EOF'
Param()
$ErrorActionPreference = "Stop"
$ZipName = "genai-agents-foundations.zip"
$WorkDir = Join-Path $env:USERPROFILE "genai-agents-foundations-run"
if (Test-Path $ZipName) { Remove-Item $ZipName -Force }
Compress-Archive -Path * -DestinationPath $ZipName -Force
if (Test-Path $WorkDir) { Remove-Item -Recurse -Force $WorkDir }
New-Item -ItemType Directory -Path $WorkDir | Out-Null
Expand-Archive -Path $ZipName -DestinationPath $WorkDir -Force
Set-Location $WorkDir
if (Test-Path "python") {
  Set-Location python
  python -m venv .venv
  .\\.venv\\Scripts\\Activate.ps1
  python -m pip install --upgrade pip setuptools wheel
  pip install -e . 2>$null
  try { pytest -q } catch {}
  Deactivate
  Set-Location ..
}
if (Test-Path "java") {
  Set-Location java
  mvn -q -DskipTests package
  if (Test-Path "target/classes") {
    & java -p target/classes -m com.jana.bank/com.jana.bank.Main
  }
  try { mvn -q test } catch {}
  Set-Location ..
}
if (Test-Path "javascript") {
  Set-Location javascript
  if (Get-Command pnpm -ErrorAction SilentlyContinue) {
    pnpm i
    try { pnpm test } catch {}
  } else {
    npm i
    try { npm test } catch {}
  }
  node src/index.js
  Set-Location ..
}
Write-Host "Done. Work dir: $WorkDir"
EOF

