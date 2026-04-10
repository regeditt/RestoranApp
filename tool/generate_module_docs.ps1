param(
  [string]$OutputRoot = "docs/moduller"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$featuresRoot = Join-Path $repoRoot "lib/ozellikler"
$outputDir = Join-Path $repoRoot $OutputRoot

if (-not (Test-Path -LiteralPath $featuresRoot)) {
  throw "Modul klasoru bulunamadi: $featuresRoot"
}

New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

$moduleDescriptions = @{
  "anasayfa" = "Uygulamanin acilis ve vitrin ekranini sunar."
  "kimlik" = "Kullanici girisi, hesap olusturma ve aktif oturum akislarini yonetir."
  "kurye_takip" = "Kurye takip saglayicisi kontratlarini ve adaptor kayitlarini barindirir."
  "lisans" = "Lisans dogrulama, aktivasyon ve lisans durum yonetimini ustlenir."
  "menu" = "Kategori/urun yonetimi, POS menu akisi ve QR menu baglamini saglar."
  "personel" = "Gelecekte ayrik personel modulu icin ayrilan placeholder alandir."
  "rapor" = "Gelecekte ayrik rapor modulu icin ayrilan placeholder alandir."
  "raporlar" = "Rapor ekranlari ve kurye takip haritasi gibi gorsel rapor bilesenlerini barindirir."
  "sepet" = "Sepet kalemleri, urun ekleme ve sepet durumunu yonetir."
  "siparis" = "Siparis olusturma, durum gecisleri, yazdirma ve kurye entegrasyonunu yonetir."
  "stok" = "Hammadde, recete ve stok dusum operasyonlarini yonetir."
  "yazici" = "Gelecekte ayrik yazici modulu icin ayrilan placeholder alandir."
  "yonetim" = "Yonetim paneli, personel, salon, yazici ve operasyon ozetlerini yonetir."
}

function Convert-ToRepoRelativePath {
  param(
    [string]$Path,
    [string]$BasePath
  )

  $relative = $Path.Substring($BasePath.Length).TrimStart('\', '/')
  return $relative -replace '\\', '/'
}

$modules = Get-ChildItem -Path $featuresRoot -Directory | Sort-Object Name

$indexLines = New-Object System.Collections.Generic.List[string]
$indexLines.Add("# Modul Dokuman Seti")
$indexLines.Add("")
$indexLines.Add("Bu klasor, lib/ozellikler altindaki tum moduller icin ayrik teknik dokuman dosyalarini icerir.")
$indexLines.Add("")
$indexLines.Add("## Moduller")
$indexLines.Add("")

foreach ($module in $modules) {
  $moduleName = $module.Name
  $moduleDocFile = "${moduleName}_modulu.md"
  $moduleDocPath = Join-Path $outputDir $moduleDocFile
  $files = @(Get-ChildItem -Path $module.FullName -Recurse -File -Filter *.dart | Sort-Object FullName)

  $layers = @()
  if ($files.Count -gt 0) {
    $layers = @($files |
      ForEach-Object { Convert-ToRepoRelativePath -Path $_.FullName -BasePath $module.FullName } |
      ForEach-Object { $_.Split('/')[0] } |
      Group-Object |
      Sort-Object Name |
      ForEach-Object { $_.Name })
  }

  $dependencySet = [System.Collections.Generic.HashSet[string]]::new()
  foreach ($file in $files) {
    $matches = Select-String -Path $file.FullName -Pattern "package:restoran_app/ozellikler/([a-z_]+)/" -AllMatches
    foreach ($line in $matches) {
      foreach ($match in $line.Matches) {
        $dep = $match.Groups[1].Value
        if ($dep -and $dep -ne $moduleName) {
          [void]$dependencySet.Add($dep)
        }
      }
    }
  }
  $dependencies = @($dependencySet | Sort-Object)

  $keyPatterns = @(
    "*/sunum/viewmodel/*.dart",
    "*/sunum/sayfalar/*.dart",
    "*/uygulama/servisler/*.dart",
    "*/uygulama/use_case/*.dart",
    "*/alan/depolar/*.dart",
    "*/veri/depolar/*.dart"
  )

  $keySet = [System.Collections.Generic.HashSet[string]]::new()
  foreach ($pattern in $keyPatterns) {
    $matched = $files |
      Where-Object {
        (Convert-ToRepoRelativePath -Path $_.FullName -BasePath $repoRoot) -like ($pattern -replace '\\', '/')
      } |
      Select-Object -First 6
    foreach ($m in $matched) {
      [void]$keySet.Add((Convert-ToRepoRelativePath -Path $m.FullName -BasePath $repoRoot))
    }
  }
  $keyFiles = @($keySet | Sort-Object)

  $allFiles = @(
    $files | ForEach-Object { Convert-ToRepoRelativePath -Path $_.FullName -BasePath $repoRoot }
  )

  $description = $moduleDescriptions[$moduleName]
  if ([string]::IsNullOrWhiteSpace($description)) {
    $description = "Bu modul icin aciklama tanimi bulunmuyor."
  }

  $lines = New-Object System.Collections.Generic.List[string]
  $lines.Add("# $moduleName Modulu")
  $lines.Add("")
  $lines.Add("## Amac")
  $lines.Add("")
  $lines.Add("- $description")
  $lines.Add("")
  $lines.Add("## Katman Ozeti")
  $lines.Add("")
  if ($layers.Count -eq 0) {
    $lines.Add("- Katman: placeholder (Dart dosyasi bulunamadi).")
  } else {
    $lines.Add("- Katmanlar: " + ($layers -join ", "))
    $lines.Add("- Dart dosya sayisi: " + $files.Count)
  }
  $lines.Add("")
  $lines.Add("## Modul Bagimliliklari")
  $lines.Add("")
  if ($dependencies.Count -eq 0) {
    $lines.Add("- Diger modullere dogrudan import bagimliligi bulunmadi.")
  } else {
    foreach ($dependency in $dependencies) {
      $lines.Add("- " + $dependency)
    }
  }
  $lines.Add("")
  $lines.Add("## Onemli Giris Noktalari")
  $lines.Add("")
  if ($keyFiles.Count -eq 0) {
    $lines.Add("- Onemli giris noktasi siniflandirmasina giren dosya bulunmadi.")
  } else {
    foreach ($keyFile in $keyFiles) {
      $lines.Add("- " + $keyFile)
    }
  }
  $lines.Add("")
  $lines.Add("## Tum Dosyalar")
  $lines.Add("")
  if ($allFiles.Count -eq 0) {
    $lines.Add("- (Bu modulde Dart dosyasi yok.)")
  } else {
    foreach ($filePath in $allFiles) {
      $lines.Add("- " + $filePath)
    }
  }
  $lines.Add("")
  $lines.Add("> Bu dokuman otomatik uretilmistir: tool/generate_module_docs.ps1")

  Set-Content -LiteralPath $moduleDocPath -Value $lines -Encoding UTF8

  $indexLines.Add("- [$moduleName](./$moduleDocFile)")
}

$indexLines.Add("")
$indexLines.Add("> Guncelleme komutu: powershell -ExecutionPolicy Bypass -File .\\tool\\generate_module_docs.ps1")

Set-Content -LiteralPath (Join-Path $outputDir "README.md") -Value $indexLines -Encoding UTF8
Write-Host "Modul dokumanlari uretildi -> $OutputRoot"
