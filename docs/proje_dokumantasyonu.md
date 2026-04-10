# Proje Dokumantasyonu

Bu dokuman, RestoranApp projesinin tumunu tek yerden anlamak icin hazirlanmis ana kilavuzdur.

## Kapsam

- Proje mimarisi ve klasor yapisi
- Modul haritasi ve modul bagimliliklari
- Ana is akislarinin ozetleri
- Veri, test ve kalite surecleri
- Dokumantasyonun nasil guncellenecegi

## Mimari Ozeti

- Mimari yaklasim: feature bazli + katmanli yapi
- Temel katmanlar: `sunum`, `uygulama`, `alan`, `veri`
- Ozel esleme: `kurye_takip/core` (kontrat), `kurye_takip/providers` (adaptor)
- Composition root: `lib/bagimlilik_enjeksiyonu`
- Kurallar: `RULES.md` ve `RULES_SOLID.md`

## Klasor Rehberi

- `lib/ortak`: tema, sabitler, platform soyutlamalari, yonlendirme, veri altyapisi
- `lib/uygulama_kabugu`: app bootstrap ve baslangic rota akisi
- `lib/ozellikler`: feature modulleri
- `test`: birim/widget testleri
- `tool`: kontrol ve dokumantasyon scriptleri
- `docs`: teknik dokumanlar ve API referansi

## Modul Haritasi

- [anasayfa](./moduller/anasayfa_modulu.md)
- [kimlik](./moduller/kimlik_modulu.md)
- [kurye_takip](./moduller/kurye_takip_modulu.md)
- [lisans](./moduller/lisans_modulu.md)
- [menu](./moduller/menu_modulu.md)
- [personel](./moduller/personel_modulu.md)
- [rapor](./moduller/rapor_modulu.md)
- [raporlar](./moduller/raporlar_modulu.md)
- [sepet](./moduller/sepet_modulu.md)
- [siparis](./moduller/siparis_modulu.md)
- [stok](./moduller/stok_modulu.md)
- [yazici](./moduller/yazici_modulu.md)
- [yonetim](./moduller/yonetim_modulu.md)

## Ana Is Akislari

### 1) Kimlik ve Oturum

- Giris/hesap olusturma akislari `kimlik` modulu icinde yonetilir.
- Aktif kullanici bilgisi use-case uzerinden cekilir ve ekranlara yansitilir.

### 2) Menu -> Sepet -> Siparis

- `menu` urun/kategori verisini sunar.
- `sepet` kalem duzenleme ve toplam hesaplarini tutar.
- `siparis` sepetten siparis olusturur, yazdirma ve durum gecislerini yonetir.

### 3) Mutfak ve Operasyon

- `siparis/sunum/viewmodel/mutfak_siparis_viewmodel.dart` mutfak akislarini yonetir.
- Durum gecisleri `SiparisDurumuGuncelleUseCase` ile kalici katmana yazilir.

### 4) Kurye Takibi

- Saglayici kontrati: `kurye_takip/core`
- Saglayici adaptorleri: `kurye_takip/providers`
- Yonetim ve eslesme: `siparis/uygulama/servisler/kurye_entegrasyon_yonetim_servisi.dart`
- Canli takip: `siparis/uygulama/servisler/kurye_konum_takip_servisi.dart`

### 5) Yonetim ve Raporlama

- `yonetim` modulu personel, salon, yazici ve panel metriklerini toplar.
- `raporlar` modulu rapor ekraninin sunum katmanini saglar.

## Veri ve Ortam Profilleri

- Mock profil: gelistirme ve hizli test
- Gercek profil: bellek tabanli/servis bazli
- Sqlite profil: kalici veri ve migration odakli calisma

Bagimlilik olusturma ve profil secimi:
- `lib/bagimlilik_enjeksiyonu/servis_bagimlilikleri.dart`
- `lib/bagimlilik_enjeksiyonu/servis_kaydi.dart`

## Test ve Kalite

- Statik analiz: `dart analyze lib test`
- Testler: `flutter test`
- Toplu kontrol: `tool/dev_checks.ps1`
- SOLID sinir kontrolu: `tool/solid_kural_kontrolu.dart`

## Dokumantasyon Uretimi

- Modul dokumanlari:
  - `powershell -ExecutionPolicy Bypass -File .\tool\generate_module_docs.ps1`
- API referansi:
  - `powershell -ExecutionPolicy Bypass -File .\tool\generate_api_docs.ps1`

## Ilgili Dokumanlar

- Modul ozeti: [modul_dokumantasyonu.md](./modul_dokumantasyonu.md)
- Modul detay seti: [moduller/README.md](./moduller/README.md)
- API dokumantasyon standardi: [api_dokumantasyon_standardi.md](./api_dokumantasyon_standardi.md)
- Web mimari plani: [web_mimarisi_plani.md](./web_mimarisi_plani.md)
- Degisiklik kaydi: [changelog.md](./changelog.md)
