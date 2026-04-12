# Modul Dokumantasyonu

Bu dokuman, `lib/ozellikler` altindaki tum modullerin sorumluluklarini, katman durumunu ve ana giris dosyalarini ozetler.

Detayli modul dosya envanteri ve bagimlilik listeleri icin:
- `docs/moduller/README.md`
- `docs/proje_dokumantasyonu.md`

## Mimari Ozeti

- Mimari tipi: `feature bazli + katmanli`
- Temel katmanlar: `sunum`, `uygulama`, `alan`, `veri`
- Ek katman eslemeleri:
  - `kurye_takip/core` -> `alan`
  - `kurye_takip/providers` -> `veri`
- Composition root: `lib/bagimlilik_enjeksiyonu`
- Modul erisim kurallari: `RULES_SOLID.md`

## Modul Envanteri

| Modul | Katmanlar | Durum | Not |
| --- | --- | --- | --- |
| `anasayfa` | sunum | aktif | Vitrin/landing girisi |
| `kimlik` | alan, sunum, uygulama, veri | aktif | Giris, hesap, misafir akisi |
| `kurye_takip` | core, providers, uygulama | aktif | Saglayici adaptor kontratlari |
| `lisans` | alan, sunum, uygulama, veri | aktif | Aktivasyon ve lisans dogrulama |
| `menu` | alan, sunum, uygulama, veri | aktif | QR/POS menu akisi |
| `personel` | placeholder | planli | Ayrik modul icin ayrilmis alan |
| `rapor` | placeholder | planli | Ayrik modul icin ayrilmis alan |
| `raporlar` | sunum | aktif | Rapor ekrani ve kurye harita karti |
| `sepet` | alan, uygulama, veri | aktif | Sepet domain ve use-case |
| `siparis` | alan, sunum, uygulama, veri | aktif | Siparis, mutfak, kurye takip yonetimi |
| `stok` | alan, uygulama, veri | aktif | Hammadde/recete/stok dusumu |
| `yazici` | placeholder | planli | Ayrik modul icin ayrilmis alan |
| `yonetim` | alan, sunum, uygulama, veri | aktif | Admin panel, personel, yazici, salon |

## Modul Detaylari

### anasayfa

- Sorumluluk: uygulamanin vitrin girisini sunmak.
- Katman durumu: yalnizca `sunum` dosyalari var.
- Ana dosya:
  - `lib/ozellikler/anasayfa/sunum/sayfalar/ana_sayfa.dart`

### kimlik

- Sorumluluk: personel/musteri girisi, hesap olusturma, misafir bilgisi ve aktif kullanici yonetimi.
- Katman durumu: tam (`alan+sunum+uygulama+veri`).
- Ana dosyalar:
  - `lib/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart`
  - `lib/ozellikler/kimlik/sunum/viewmodel/giris_secim_viewmodel.dart`
  - `lib/ozellikler/kimlik/sunum/viewmodel/hesabim_viewmodel.dart`
  - `lib/ozellikler/kimlik/veri/depolar/kimlik_deposu_sqlite.dart`

### kurye_takip

- Sorumluluk: kurye takip saglayicilarini (dahili/harici) tek kontrat uzerinden yonetmek.
- Katman durumu: `core+providers+uygulama` (SOLID extension modeli).
- Ana dosyalar:
  - `lib/ozellikler/kurye_takip/core/soylesmeler/kurye_takip_saglayicisi.dart`
  - `lib/ozellikler/kurye_takip/providers/saglayicilar/kurye_takip_saglayici_adaptorleri.dart`
  - `lib/ozellikler/kurye_takip/uygulama/servisler/kurye_takip_saglayici_kayit_defteri.dart`

### lisans

- Sorumluluk: lisans anahtari dogrulama, aktivasyon ve lisans durumunun ekrana yansitilmasi.
- Katman durumu: tam (`alan+sunum+uygulama+veri`).
- Ana dosyalar:
  - `lib/ozellikler/lisans/uygulama/servisler/lisans_anahtari_dogrulayici.dart`
  - `lib/ozellikler/lisans/sunum/viewmodel/lisans_aktivasyon_viewmodel.dart`
  - `lib/ozellikler/lisans/veri/depolar/lisans_deposu_sqlite.dart`

### menu

- Sorumluluk: kategori/urun CRUD, musteri menusu, QR baglami ve POS urun listesi.
- Katman durumu: tam (`alan+sunum+uygulama+veri`).
- Ana dosyalar:
  - `lib/ozellikler/menu/alan/depolar/menu_deposu.dart`
  - `lib/ozellikler/menu/sunum/viewmodel/musteri_menu_viewmodel.dart`
  - `lib/ozellikler/menu/uygulama/servisler/qr_menu_baglami_cozumleyici.dart`
  - `lib/ozellikler/menu/veri/depolar/menu_deposu_sqlite.dart`

### personel

- Sorumluluk: gelecekte ayrik personel modulu.
- Katman durumu: placeholder (kod yok, `.keep` yapisi).
- Not: su an personel operasyonlari `yonetim` modulu icinde.

### rapor

- Sorumluluk: gelecekte ayrik rapor domain modulu.
- Katman durumu: placeholder (kod yok, `.keep` yapisi).
- Not: mevcut rapor ekranlari `raporlar` ve `yonetim` tarafinda.

### raporlar

- Sorumluluk: rapor merkezi ekrani ve kurye takip harita karti.
- Katman durumu: su an yalnizca `sunum`.
- Ana dosyalar:
  - `lib/ozellikler/raporlar/sunum/sayfalar/raporlar_sayfasi.dart`
  - `lib/ozellikler/raporlar/sunum/bilesenler/kurye_takip_haritasi_karti.dart`

### sepet

- Sorumluluk: sepet kalemi yonetimi, urun ekleme/guncelleme/silme, temizleme.
- Katman durumu: `alan+uygulama+veri` (sunum menu/siparis tarafinda).
- Ana dosyalar:
  - `lib/ozellikler/sepet/alan/depolar/sepet_deposu.dart`
  - `lib/ozellikler/sepet/uygulama/use_case/sepete_urun_ekle_use_case.dart`
  - `lib/ozellikler/sepet/veri/depolar/sepet_deposu_sqlite.dart`

### siparis

- Sorumluluk: siparis olusturma, durum gecisleri, mutfak operasyonu, yazdirma, kurye entegrasyonu ve canli takip.
- Katman durumu: tam (`alan+sunum+uygulama+veri`).
- Ana dosyalar:
  - `lib/ozellikler/siparis/alan/depolar/siparis_deposu.dart`
  - `lib/ozellikler/siparis/sunum/viewmodel/mutfak_siparis_viewmodel.dart`
  - `lib/ozellikler/siparis/uygulama/servisler/kurye_entegrasyon_yonetim_servisi.dart`
  - `lib/ozellikler/siparis/uygulama/servisler/kurye_konum_takip_servisi.dart`
  - `lib/ozellikler/siparis/veri/depolar/siparis_deposu_sqlite.dart`

### stok

- Sorumluluk: hammadde, recete, stok dusumu ve stok ozeti hesaplari.
- Katman durumu: `alan+uygulama+veri` (sunum yonetim panelinde).
- Ana dosyalar:
  - `lib/ozellikler/stok/alan/depolar/stok_deposu.dart`
  - `lib/ozellikler/stok/uygulama/use_case/siparise_gore_stok_dus_use_case.dart`
  - `lib/ozellikler/stok/veri/depolar/stok_deposu_sqlite.dart`

### yazici

- Sorumluluk: gelecekte ayrik yazici modulu.
- Katman durumu: placeholder (kod yok, `.keep` yapisi).
- Not: aktif yazici yonetimi su an `yonetim` ve `siparis` modullerinde.

### yonetim

- Sorumluluk: yonetim paneli, personel/salon/yazici CRUD, rapor kartlari, operasyon ozetleri.
- Katman durumu: tam (`alan+sunum+uygulama+veri`).
- Ana dosyalar:
  - `lib/ozellikler/yonetim/sunum/viewmodel/yonetim_paneli_viewmodel.dart`
  - `lib/ozellikler/yonetim/sunum/sayfalar/yonetim_paneli_sayfasi.dart`
  - `lib/ozellikler/yonetim/uygulama/servisler/yonetim_raporu_hesaplayici.dart`
  - `lib/ozellikler/yonetim/veri/depolar/personel_deposu_sqlite.dart`
  - `lib/ozellikler/yonetim/veri/depolar/salon_plani_deposu_sqlite.dart`
  - `lib/ozellikler/yonetim/veri/depolar/yazici_deposu_sqlite.dart`

## Moduller Arasi Baglanti Ozeti

- `menu` -> `sepet` -> `siparis` ana operasyon zinciri.
- `siparis` -> `stok` stok dusumu ve maliyet baglantisi.
- `yonetim` -> `siparis` panel ve operasyon ozetleri.
- `siparis` + `kurye_takip` kurye entegrasyon ve konum takibi.
- `raporlar` su an `yonetim` viewmodelinden beslenir.

## Yonetim ve Bakim Notlari

- Placeholder moduller (`personel`, `rapor`, `yazici`) ileride ayriklasma icin ayrilmis durumda.
- Yeni kodda modul sinirlari `RULES_SOLID.md` ve `tool/solid_kural_kontrolu.dart` ile kontrol edilmelidir.
- Guncele alirken once bu dokuman, sonra `docs/changelog.md` guncellenmelidir.
