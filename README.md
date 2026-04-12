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
Modul bazli teknik dokumantasyon icin [docs/modul_dokumantasyonu.md](docs/modul_dokumantasyonu.md) dosyasina bakilmalidir.
Tum proje icin merkez dokuman [docs/proje_dokumantasyonu.md](docs/proje_dokumantasyonu.md) dosyasidir.
Modul detay seti icin [docs/moduller/README.md](docs/moduller/README.md) dosyasina bakilmalidir.
API dokumantasyon stili icin [docs/api_dokumantasyon_standardi.md](docs/api_dokumantasyon_standardi.md) dosyasina bakilmalidir.

## Gelistirme Komutlari

Windows ortaminda `dart/flutter` komutlarinda zaman zaman telemetry/AppData kaynakli izin sorunlari olabildigi icin, proje icinde tek bir stabil giris noktasi bulunur:

```powershell
powershell -ExecutionPolicy Bypass -File .\tool\dev_checks.ps1 -Task format
powershell -ExecutionPolicy Bypass -File .\tool\dev_checks.ps1 -Task solid
powershell -ExecutionPolicy Bypass -File .\tool\dev_checks.ps1 -Task analyze
powershell -ExecutionPolicy Bypass -File .\tool\dev_checks.ps1 -Task test
powershell -ExecutionPolicy Bypass -File .\tool\dev_checks.ps1 -Task all
powershell -ExecutionPolicy Bypass -File .\tool\dev_checks.ps1 -Task winfix
```

JavaDoc benzeri API dokumani uretimi:

```powershell
powershell -ExecutionPolicy Bypass -File .\tool\generate_api_docs.ps1
```

Modul dokumanlari uretimi:

```powershell
powershell -ExecutionPolicy Bypass -File .\tool\generate_module_docs.ps1
```

Script su islemleri yapar:
- `APPDATA` yolunu proje ici izole bir klasore alir.
- `flutter` komutundan Dart SDK yolunu cozer.
- `format`, `solid`, `analyze` ve `test` komutlarini tutarli ayarlarla calistirir.
- `winfix` ile Windows icin `clean + pub get + build windows --debug` zincirini tek adimda calistirir.
