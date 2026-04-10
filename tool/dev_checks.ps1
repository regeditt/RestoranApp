param(
  [ValidateSet('format', 'analyze', 'test', 'solid', 'all', 'winfix')]
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

function Invoke-Solid {
  & $dartExe run tool/solid_kural_kontrolu.dart
}

function Invoke-Tests {
  & $flutterCommand.Source test --reporter compact
}

function Invoke-WinFix {
  $onWindows = ($env:OS -eq 'Windows_NT')
  if (-not $onWindows) {
    throw 'winfix gorevi sadece Windows icin tasarlanmistir.'
  }

  $runnerExePattern = [IO.Path]::Combine($projectRoot, 'build', 'windows', 'x64', 'runner', 'Debug', 'restoran_app.exe')
  Get-Process -Name 'restoran_app' -ErrorAction SilentlyContinue |
    ForEach-Object {
      try {
        if ($_.Path -and $_.Path -like "$runnerExePattern*") {
          Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
        }
      }
      catch {
        # Yol okunamazsa sessizce gec.
      }
    }

  & $flutterCommand.Source clean
  & $flutterCommand.Source pub get
  & $flutterCommand.Source build windows --debug
}

switch ($Task) {
  'format' { Invoke-Format }
  'analyze' { Invoke-Analyze }
  'test' { Invoke-Tests }
  'solid' { Invoke-Solid }
  'winfix' { Invoke-WinFix }
  'all' {
    Invoke-Format
    Invoke-Solid
    Invoke-Analyze
    Invoke-Tests
  }
}
