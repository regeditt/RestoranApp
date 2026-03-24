import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/aktif_kullanici_getir_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/misafir_olustur_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/veri/depolar/kimlik_deposu_mock.dart';
import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/kategoriye_gore_urunleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/kategorileri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/urunleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/menu/veri/depolar/menu_deposu_mock.dart';
import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepete_urun_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepeti_getir_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/veri/depolar/sepet_deposu_mock.dart';
import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparis_olustur_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparisleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/veri/depolar/siparis_deposu_mock.dart';

class ServisKaydi {
  ServisKaydi._() {
    _menuDeposu = MenuDeposuMock();
    _kimlikDeposu = KimlikDeposuMock();
    _sepetDeposu = SepetDeposuMock(_menuDeposu);
    _siparisDeposu = SiparisDeposuMock();

    aktifKullaniciGetirUseCase = AktifKullaniciGetirUseCase(_kimlikDeposu);
    misafirOlusturUseCase = MisafirOlusturUseCase(_kimlikDeposu);
    kategorileriGetirUseCase = KategorileriGetirUseCase(_menuDeposu);
    kategoriyeGoreUrunleriGetirUseCase = KategoriyeGoreUrunleriGetirUseCase(
      _menuDeposu,
    );
    urunleriGetirUseCase = UrunleriGetirUseCase(_menuDeposu);
    sepetiGetirUseCase = SepetiGetirUseCase(_sepetDeposu);
    sepeteUrunEkleUseCase = SepeteUrunEkleUseCase(_sepetDeposu);
    siparisOlusturUseCase = SiparisOlusturUseCase(_siparisDeposu);
    siparisleriGetirUseCase = SiparisleriGetirUseCase(_siparisDeposu);
  }

  static final ServisKaydi ortak = ServisKaydi._();

  late final KimlikDeposu _kimlikDeposu;
  late final MenuDeposu _menuDeposu;
  late final SepetDeposu _sepetDeposu;
  late final SiparisDeposu _siparisDeposu;

  late final AktifKullaniciGetirUseCase aktifKullaniciGetirUseCase;
  late final MisafirOlusturUseCase misafirOlusturUseCase;
  late final KategorileriGetirUseCase kategorileriGetirUseCase;
  late final KategoriyeGoreUrunleriGetirUseCase
  kategoriyeGoreUrunleriGetirUseCase;
  late final UrunleriGetirUseCase urunleriGetirUseCase;
  late final SepetiGetirUseCase sepetiGetirUseCase;
  late final SepeteUrunEkleUseCase sepeteUrunEkleUseCase;
  late final SiparisOlusturUseCase siparisOlusturUseCase;
  late final SiparisleriGetirUseCase siparisleriGetirUseCase;
}
