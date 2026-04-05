param(
  [ValidateSet('format', 'analyze', 'test', 'all')]
  [string]$Task = 'all'
)

$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$localAppData = Join-Path $projectRoot '.tooling\appdata'
New-Item -ItemType Directory -Force -Path $localAppData | Out-Null
$env:APPDATA = $localAppData

$flutterCommand = (Get-Command flutter -ErrorAction SilentlyContinue)
if ($null -eq $flutterCommand) {
  throw 'flutter komutu PATH uzerinde bulunamadi.'
}

$flutterBinDir = Split-Path -Parent $flutterCommand.Source
$flutterRoot = Split-Path -Parent $flutterBinDir
$dartExe = Join-Path $flutterRoot 'bin\cache\dart-sdk\bin\dart.exe'

if (-not (Test-Path $dartExe)) {
  throw "Dart SDK bulunamadi: $dartExe"
}

function Invoke-Format {
  & $dartExe format lib test
}

function Invoke-Analyze {
  & $dartExe analyze lib test
}

function Invoke-Tests {
  & $flutterCommand.Source test --reporter compact
}

switch ($Task) {
  'format' { Invoke-Format }
  'analyze' { Invoke-Analyze }
  'test' { Invoke-Tests }
  'all' {
    Invoke-Format
    Invoke-Analyze
    Invoke-Tests
  }
}
