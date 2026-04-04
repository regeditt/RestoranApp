import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/veri/depolar/kimlik_deposu_gercek.dart';
import 'package:restoran_app/ozellikler/kimlik/veri/depolar/kimlik_deposu_mock.dart';
import 'package:restoran_app/ozellikler/kimlik/veri/depolar/kimlik_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/veri/depolar/menu_deposu_gercek.dart';
import 'package:restoran_app/ozellikler/menu/veri/depolar/menu_deposu_mock.dart';
import 'package:restoran_app/ozellikler/menu/veri/depolar/menu_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/veri/depolar/sepet_deposu_gercek.dart';
import 'package:restoran_app/ozellikler/sepet/veri/depolar/sepet_deposu_mock.dart';
import 'package:restoran_app/ozellikler/sepet/veri/depolar/sepet_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
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

class ServisBagimlilikleri {
  const ServisBagimlilikleri({
    required this.kimlikDeposu,
    required this.menuDeposu,
    required this.sepetDeposu,
    required this.siparisDeposu,
    required this.yaziciDeposu,
    required this.personelDeposu,
    required this.salonPlaniDeposu,
    required this.stokDeposu,
  });

  final KimlikDeposu kimlikDeposu;
  final MenuDeposu menuDeposu;
  final SepetDeposu sepetDeposu;
  final SiparisDeposu siparisDeposu;
  final YaziciDeposu yaziciDeposu;
  final PersonelDeposu personelDeposu;
  final SalonPlaniDeposu salonPlaniDeposu;
  final StokDeposu stokDeposu;

  static final UygulamaVeritabani _sqliteVeritabani = UygulamaVeritabani();

  factory ServisBagimlilikleri.mock() {
    final MenuDeposu menuDeposu = MenuDeposuMock();
    return ServisBagimlilikleri(
      kimlikDeposu: KimlikDeposuMock(),
      menuDeposu: menuDeposu,
      sepetDeposu: SepetDeposuMock(menuDeposu),
      siparisDeposu: SiparisDeposuMock(),
      yaziciDeposu: YaziciDeposuMock(),
      personelDeposu: PersonelDeposuMock(),
      salonPlaniDeposu: SalonPlaniDeposuMock(),
      stokDeposu: StokDeposuMock(),
    );
  }

  factory ServisBagimlilikleri.gercek() {
    final MenuDeposu menuDeposu = MenuDeposuGercek();
    return ServisBagimlilikleri(
      kimlikDeposu: KimlikDeposuGercek(),
      menuDeposu: menuDeposu,
      sepetDeposu: SepetDeposuGercek(menuDeposu),
      siparisDeposu: SiparisDeposuGercek(),
      yaziciDeposu: YaziciDeposuGercek(),
      personelDeposu: PersonelDeposuGercek(),
      salonPlaniDeposu: SalonPlaniDeposuGercek(),
      stokDeposu: StokDeposuGercek(),
    );
  }

  factory ServisBagimlilikleri.sqlite() {
    final MenuDeposu menuDeposu = MenuDeposuSqlite(_sqliteVeritabani);
    return ServisBagimlilikleri(
      kimlikDeposu: KimlikDeposuSqlite(_sqliteVeritabani),
      menuDeposu: menuDeposu,
      sepetDeposu: SepetDeposuSqlite(_sqliteVeritabani, menuDeposu),
      siparisDeposu: SiparisDeposuSqlite(_sqliteVeritabani),
      yaziciDeposu: YaziciDeposuSqlite(_sqliteVeritabani),
      personelDeposu: PersonelDeposuSqlite(_sqliteVeritabani),
      salonPlaniDeposu: SalonPlaniDeposuSqlite(_sqliteVeritabani),
      stokDeposu: StokDeposuSqlite(_sqliteVeritabani),
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
