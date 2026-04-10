# yonetim Modulu

## Amac

- Yonetim paneli, personel, salon, yazici ve operasyon ozetlerini yonetir.

## Katman Ozeti

- Katmanlar: alan, sunum, uygulama, veri
- Dart dosya sayisi: 50

## Modul Bagimliliklari

- kimlik
- menu
- siparis
- stok

## Onemli Giris Noktalari

- lib/ozellikler/yonetim/alan/depolar/personel_deposu.dart
- lib/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart
- lib/ozellikler/yonetim/alan/depolar/yazici_deposu.dart
- lib/ozellikler/yonetim/sunum/sayfalar/yonetim_paneli_sayfasi.dart
- lib/ozellikler/yonetim/sunum/viewmodel/yonetim_paneli_viewmodel.dart
- lib/ozellikler/yonetim/uygulama/servisler/yazici_is_kuyrugu_hesaplayici.dart
- lib/ozellikler/yonetim/uygulama/servisler/yonetim_raporu_hesaplayici.dart
- lib/ozellikler/yonetim/uygulama/use_case/masa_ekle_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/masa_guncelle_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/masa_sil_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/personel_sil_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/personelleri_getir_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/salon_bolumlerini_getir_use_case.dart
- lib/ozellikler/yonetim/veri/depolar/personel_deposu_gercek.dart
- lib/ozellikler/yonetim/veri/depolar/personel_deposu_mock.dart
- lib/ozellikler/yonetim/veri/depolar/personel_deposu_sqlite.dart
- lib/ozellikler/yonetim/veri/depolar/salon_plani_deposu_gercek.dart
- lib/ozellikler/yonetim/veri/depolar/salon_plani_deposu_mock.dart
- lib/ozellikler/yonetim/veri/depolar/salon_plani_deposu_sqlite.dart

## Tum Dosyalar

- lib/ozellikler/yonetim/alan/depolar/personel_deposu.dart
- lib/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart
- lib/ozellikler/yonetim/alan/depolar/yazici_deposu.dart
- lib/ozellikler/yonetim/alan/varliklar/patron_raporu_ozeti_varligi.dart
- lib/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart
- lib/ozellikler/yonetim/alan/varliklar/saatlik_siparis_ozeti_varligi.dart
- lib/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart
- lib/ozellikler/yonetim/alan/varliklar/sistem_yazici_adayi_varligi.dart
- lib/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart
- lib/ozellikler/yonetim/alan/varliklar/yazici_is_kuyrugu_varligi.dart
- lib/ozellikler/yonetim/alan/varliklar/yonetim_paneli_ozeti_varligi.dart
- lib/ozellikler/yonetim/sunum/bilesenler/masa_plani_karti.dart
- lib/ozellikler/yonetim/sunum/bilesenler/paket_servis_operasyon_karti.dart
- lib/ozellikler/yonetim/sunum/bilesenler/personel_yonetimi_karti.dart
- lib/ozellikler/yonetim/sunum/bilesenler/yazici_form_dialogu.dart
- lib/ozellikler/yonetim/sunum/bilesenler/yazici_yonetimi_karti.dart
- lib/ozellikler/yonetim/sunum/bilesenler/yonetim_analiz_kartlari.dart
- lib/ozellikler/yonetim/sunum/bilesenler/yonetim_ayarlari_dialogu.dart
- lib/ozellikler/yonetim/sunum/bilesenler/yonetim_ayarlari_formlari.dart
- lib/ozellikler/yonetim/sunum/bilesenler/yonetim_ayarlari_kartlari.dart
- lib/ozellikler/yonetim/sunum/bilesenler/yonetim_paneli_dialoglari.dart
- lib/ozellikler/yonetim/sunum/bilesenler/yonetim_paneli_yardimcilari.dart
- lib/ozellikler/yonetim/sunum/bilesenler/yonetim_rapor_kartlari.dart
- lib/ozellikler/yonetim/sunum/sayfalar/yonetim_paneli_sayfasi.dart
- lib/ozellikler/yonetim/sunum/viewmodel/yonetim_paneli_viewmodel.dart
- lib/ozellikler/yonetim/uygulama/servisler/yazici_is_kuyrugu_hesaplayici.dart
- lib/ozellikler/yonetim/uygulama/servisler/yonetim_raporu_hesaplayici.dart
- lib/ozellikler/yonetim/uygulama/use_case/masa_ekle_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/masa_guncelle_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/masa_sil_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/personel_sil_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/personelleri_getir_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/salon_bolumlerini_getir_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/salon_bolumu_ekle_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/salon_bolumu_guncelle_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/salon_bolumu_sil_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/sistem_yazicilarini_getir_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/yazici_ekle_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/yazici_guncelle_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/yazici_sil_use_case.dart
- lib/ozellikler/yonetim/uygulama/use_case/yazicilari_getir_use_case.dart
- lib/ozellikler/yonetim/veri/depolar/personel_deposu_gercek.dart
- lib/ozellikler/yonetim/veri/depolar/personel_deposu_mock.dart
- lib/ozellikler/yonetim/veri/depolar/personel_deposu_sqlite.dart
- lib/ozellikler/yonetim/veri/depolar/salon_plani_deposu_gercek.dart
- lib/ozellikler/yonetim/veri/depolar/salon_plani_deposu_mock.dart
- lib/ozellikler/yonetim/veri/depolar/salon_plani_deposu_sqlite.dart
- lib/ozellikler/yonetim/veri/depolar/yazici_deposu_gercek.dart
- lib/ozellikler/yonetim/veri/depolar/yazici_deposu_mock.dart
- lib/ozellikler/yonetim/veri/depolar/yazici_deposu_sqlite.dart

> Bu dokuman otomatik uretilmistir: tool/generate_module_docs.ps1
