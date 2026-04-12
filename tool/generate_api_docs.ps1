param(
  [string]$Output = 'docs/api_reference'
)

$ErrorActionPreference = 'Stop'

Write-Host "API dokumani uretiliyor -> $Output"
dart doc --output $Output
Write-Host 'Tamamlandi.'
