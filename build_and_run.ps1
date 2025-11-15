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
