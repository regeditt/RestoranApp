import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/veri/depolar/kimlik_deposu_gercek.dart';
import 'package:restoran_app/ozellikler/kimlik/veri/depolar/kimlik_deposu_mock.dart';
import 'package:restoran_app/ozellikler/kimlik/veri/depolar/kimlik_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/lisans/alan/depolar/lisans_deposu.dart';
import 'package:restoran_app/ozellikler/lisans/veri/depolar/lisans_deposu_gercek.dart';
import 'package:restoran_app/ozellikler/lisans/veri/depolar/lisans_deposu_mock.dart';
import 'package:restoran_app/ozellikler/lisans/veri/depolar/lisans_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/veri/depolar/menu_deposu_gercek.dart';
import 'package:restoran_app/ozellikler/menu/veri/depolar/menu_deposu_mock.dart';
import 'package:restoran_app/ozellikler/menu/veri/depolar/menu_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/alan/depolar/odeme_kasa_deposu.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/veri/depolar/odeme_kasa_deposu_gercek.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/veri/depolar/odeme_kasa_deposu_mock.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/veri/depolar/odeme_kasa_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/rezervasyon/alan/depolar/rezervasyon_deposu.dart';
import 'package:restoran_app/ozellikler/rezervasyon/veri/depolar/rezervasyon_deposu_gercek.dart';
import 'package:restoran_app/ozellikler/rezervasyon/veri/depolar/rezervasyon_deposu_mock.dart';
import 'package:restoran_app/ozellikler/rezervasyon/veri/depolar/rezervasyon_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/veri/depolar/sepet_deposu_gercek.dart';
import 'package:restoran_app/ozellikler/sepet/veri/depolar/sepet_deposu_mock.dart';
import 'package:restoran_app/ozellikler/sepet/veri/depolar/sepet_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_entegrasyon_yonetim_servisi.dart';
import 'package:restoran_app/ozellikler/siparis/veri/depolar/kurye_entegrasyon_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/siparis/veri/depolar/siparis_deposu_gercek.dart';
import 'package:restoran_app/ozellikler/siparis/veri/depolar/siparis_deposu_mock.dart';
import 'package:restoran_app/ozellikler/siparis/veri/depolar/siparis_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/veri/depolar/stok_deposu_gercek.dart';
import 'package:restoran_app/ozellikler/stok/veri/depolar/stok_deposu_mock.dart';
import 'package:restoran_app/ozellikler/stok/veri/depolar/stok_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/depolar/personel_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/depolar/yazici_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/personel_deposu_gercek.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/personel_deposu_mock.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/personel_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/salon_plani_deposu_gercek.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/salon_plani_deposu_mock.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/salon_plani_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/yazici_deposu_gercek.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/yazici_deposu_mock.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/yazici_deposu_sqlite.dart';
import 'package:restoran_app/ortak/veri/veri_kaynagi_tipi.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';

class ServisBagimlilikleri {
  const ServisBagimlilikleri({
    required this.lisansDeposu,
    required this.kimlikDeposu,
    required this.menuDeposu,
    required this.sepetDeposu,
    required this.siparisDeposu,
    required this.yaziciDeposu,
    required this.personelDeposu,
    required this.salonPlaniDeposu,
    required this.stokDeposu,
    required this.odemeKasaDeposu,
    required this.rezervasyonDeposu,
    required this.kuryeEntegrasyonYonetimServisi,
    required this.veritabani,
  });

  final LisansDeposu lisansDeposu;
  final KimlikDeposu kimlikDeposu;
  final MenuDeposu menuDeposu;
  final SepetDeposu sepetDeposu;
  final SiparisDeposu siparisDeposu;
  final YaziciDeposu yaziciDeposu;
  final PersonelDeposu personelDeposu;
  final SalonPlaniDeposu salonPlaniDeposu;
  final StokDeposu stokDeposu;
  final OdemeKasaDeposu odemeKasaDeposu;
  final RezervasyonDeposu rezervasyonDeposu;
  final KuryeEntegrasyonYonetimServisi kuryeEntegrasyonYonetimServisi;
  final UygulamaVeritabani? veritabani;

  static final UygulamaVeritabani _sqliteVeritabani = UygulamaVeritabani();

  factory ServisBagimlilikleri.mock() {
    final MenuDeposu menuDeposu = MenuDeposuMock();
    final KimlikDeposuMock kimlikDeposu = KimlikDeposuMock();
    final PersonelDeposuMock personelDeposu = PersonelDeposuMock();
    kimlikDeposu.hesapOlusturmaDinleyicisiAta((kullanici) {
      final (String rolEtiketi, String bolge, String aciklama)?
      personelBilgisi = switch (kullanici.rol) {
        KullaniciRolu.garson => (
          'Garson',
          'Salon',
          'Yeni olusturulan garson hesabi vardiyaya hazir.',
        ),
        KullaniciRolu.yonetici => (
          'Yonetici',
          'Yonetim',
          'Panel ve operasyon akislarini yonetmek icin eklendi.',
        ),
        _ => null,
      };
      if (personelBilgisi == null) {
        return;
      }
      personelDeposu.personelEkle(
        PersonelDurumuVarligi(
          kimlik: kullanici.id,
          adSoyad: kullanici.adSoyad,
          rolEtiketi: personelBilgisi.$1,
          bolge: personelBilgisi.$2,
          aciklama: personelBilgisi.$3,
          durum: PersonelDurumu.aktif,
        ),
      );
    });
    personelDeposu.kimlikSiliciAta(kimlikDeposu.hesapSil);
    return ServisBagimlilikleri(
      lisansDeposu: LisansDeposuMock(),
      kimlikDeposu: kimlikDeposu,
      menuDeposu: menuDeposu,
      sepetDeposu: SepetDeposuMock(menuDeposu),
      siparisDeposu: SiparisDeposuMock(),
      yaziciDeposu: YaziciDeposuMock(),
      personelDeposu: personelDeposu,
      salonPlaniDeposu: SalonPlaniDeposuMock(),
      stokDeposu: StokDeposuMock(),
      odemeKasaDeposu: OdemeKasaDeposuMock(),
      rezervasyonDeposu: RezervasyonDeposuMock(),
      kuryeEntegrasyonYonetimServisi: KuryeEntegrasyonYonetimServisi(),
      veritabani: null,
    );
  }

  factory ServisBagimlilikleri.gercek() {
    final MenuDeposu menuDeposu = MenuDeposuGercek();
    return ServisBagimlilikleri(
      lisansDeposu: LisansDeposuGercek(),
      kimlikDeposu: KimlikDeposuGercek(),
      menuDeposu: menuDeposu,
      sepetDeposu: SepetDeposuGercek(menuDeposu),
      siparisDeposu: SiparisDeposuGercek(),
      yaziciDeposu: YaziciDeposuGercek(),
      personelDeposu: PersonelDeposuGercek(),
      salonPlaniDeposu: SalonPlaniDeposuGercek(),
      stokDeposu: StokDeposuGercek(),
      odemeKasaDeposu: OdemeKasaDeposuGercek(),
      rezervasyonDeposu: RezervasyonDeposuGercek(),
      kuryeEntegrasyonYonetimServisi: KuryeEntegrasyonYonetimServisi(),
      veritabani: null,
    );
  }

  factory ServisBagimlilikleri.sqlite() {
    final MenuDeposu menuDeposu = MenuDeposuSqlite(_sqliteVeritabani);
    return ServisBagimlilikleri(
      lisansDeposu: LisansDeposuSqlite(_sqliteVeritabani),
      kimlikDeposu: KimlikDeposuSqlite(_sqliteVeritabani),
      menuDeposu: menuDeposu,
      sepetDeposu: SepetDeposuSqlite(_sqliteVeritabani, menuDeposu),
      siparisDeposu: SiparisDeposuSqlite(_sqliteVeritabani),
      yaziciDeposu: YaziciDeposuSqlite(_sqliteVeritabani),
      personelDeposu: PersonelDeposuSqlite(_sqliteVeritabani),
      salonPlaniDeposu: SalonPlaniDeposuSqlite(_sqliteVeritabani),
      stokDeposu: StokDeposuSqlite(_sqliteVeritabani),
      odemeKasaDeposu: OdemeKasaDeposuSqlite(_sqliteVeritabani),
      rezervasyonDeposu: RezervasyonDeposuSqlite(_sqliteVeritabani),
      kuryeEntegrasyonYonetimServisi: KuryeEntegrasyonYonetimServisi(
        depo: KuryeEntegrasyonDeposuSqlite(_sqliteVeritabani),
      ),
      veritabani: _sqliteVeritabani,
    );
  }

  factory ServisBagimlilikleri.api() {
    // API depolari eklenene kadar gercek depolar kullanilir.
    return ServisBagimlilikleri.gercek();
  }

  factory ServisBagimlilikleri.olustur(VeriKaynagiTipi tip) {
    switch (tip) {
      case VeriKaynagiTipi.mock:
        return ServisBagimlilikleri.mock();
      case VeriKaynagiTipi.sqlite:
        return ServisBagimlilikleri.sqlite();
      case VeriKaynagiTipi.api:
        return ServisBagimlilikleri.api();
    }
  }
}
