# RestoranApp

Bu proje, Flutter ile gelistirilen cok platformlu restoran yonetim ve siparis uygulamasidir.

## Ilk Kurulum

- Teknik paket adi: `restoran_app`
- Gorunen uygulama adi: `RestoranApp`
- Hedef platformlar: `desktop`, `mobil`, `web`
- Mimari: `SOLID` ve `N katmanli`
- Isimlendirme: Turkce anlamli, ASCII karakterli

## Baslangic Iskeleti

- `lib/ortak`: ortak tema, responsive, sabitler ve yonlendirme
- `lib/uygulama_kabugu`: uygulama giris kabugu
- `lib/ozellikler`: feature bazli moduller

Kurallar ve mevcut gelistirme plani icin [RULES.md](RULES.md) dosyasina bakilmalidir.

## Gelistirme Komutlari

Windows ortaminda `dart/flutter` komutlarinda zaman zaman telemetry/AppData kaynakli izin sorunlari olabildigi icin, proje icinde tek bir stabil giris noktasi bulunur:

```powershell
powershell -ExecutionPolicy Bypass -File .\tool\dev_checks.ps1 -Task format
powershell -ExecutionPolicy Bypass -File .\tool\dev_checks.ps1 -Task analyze
powershell -ExecutionPolicy Bypass -File .\tool\dev_checks.ps1 -Task test
powershell -ExecutionPolicy Bypass -File .\tool\dev_checks.ps1 -Task all
```

Script su islemleri yapar:
- `APPDATA` yolunu proje ici izole bir klasore alir.
- `flutter` komutundan Dart SDK yolunu cozer.
- `format`, `analyze` ve `test` komutlarini tutarli ayarlarla calistirir.
