import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_bagimlilikleri.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/aktif_kullanici_getir_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/cikis_yap_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/giris_yap_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/hesap_olustur_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/misafir_olustur_use_case.dart';
import 'package:restoran_app/ozellikler/lisans/alan/depolar/lisans_deposu.dart';
import 'package:restoran_app/ozellikler/lisans/uygulama/servisler/lisans_anahtari_dogrulayici.dart';
import 'package:restoran_app/ozellikler/lisans/uygulama/use_case/lisans_aktif_et_use_case.dart';
import 'package:restoran_app/ozellikler/lisans/uygulama/use_case/lisans_durumu_getir_use_case.dart';
import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/kategori_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/kategori_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/kategori_sil_use_case.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/kategoriye_gore_urunleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/kategorileri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/urun_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/urun_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/urun_sil_use_case.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/urunleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepete_urun_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepet_kalemi_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepet_kalemi_sil_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepeti_getir_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepeti_temizle_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparis_olustur_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparis_durumu_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparisi_yazdir_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparisleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/yazici_hedefleri_belirleyici.dart';
import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/hammadde_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/hammadde_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/hammaddeleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/receteyi_getir_use_case.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/receteyi_kaydet_use_case.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/siparise_gore_stok_dus_use_case.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/stok_ozeti_getir_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/depolar/personel_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/depolar/yazici_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/masa_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/masa_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/masa_sil_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/personelleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/personel_sil_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/salon_bolumu_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/salon_bolumu_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/salon_bolumu_sil_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/salon_bolumlerini_getir_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/sistem_yazicilarini_getir_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/yazici_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/yazici_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/yazici_sil_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/yazicilari_getir_use_case.dart';
import 'package:restoran_app/ortak/platform/yazici_cikti_platformu.dart';
import 'package:restoran_app/ortak/veri/veri_kaynagi_tipi.dart';

class ServisKaydi {
  ServisKaydi._(ServisBagimlilikleri bagimlilikler) {
    _lisansDeposu = bagimlilikler.lisansDeposu;
    _menuDeposu = bagimlilikler.menuDeposu;
    _kimlikDeposu = bagimlilikler.kimlikDeposu;
    _sepetDeposu = bagimlilikler.sepetDeposu;
    _siparisDeposu = bagimlilikler.siparisDeposu;
    _yaziciDeposu = bagimlilikler.yaziciDeposu;
    _personelDeposu = bagimlilikler.personelDeposu;
    _salonPlaniDeposu = bagimlilikler.salonPlaniDeposu;
    _stokDeposu = bagimlilikler.stokDeposu;

    const LisansAnahtariDogrulayici lisansDogrulayici =
        LisansAnahtariDogrulayici();
    lisansDurumuGetirUseCase = LisansDurumuGetirUseCase(
      _lisansDeposu,
      lisansDogrulayici,
    );
    lisansAktifEtUseCase = LisansAktifEtUseCase(
      _lisansDeposu,
      lisansDogrulayici,
    );
    aktifKullaniciGetirUseCase = AktifKullaniciGetirUseCase(_kimlikDeposu);
    girisYapUseCase = GirisYapUseCase(_kimlikDeposu);
    hesapOlusturUseCase = HesapOlusturUseCase(_kimlikDeposu);
    cikisYapUseCase = CikisYapUseCase(_kimlikDeposu);
    misafirOlusturUseCase = MisafirOlusturUseCase(_kimlikDeposu);
    kategorileriGetirUseCase = KategorileriGetirUseCase(_menuDeposu);
    kategoriEkleUseCase = KategoriEkleUseCase(_menuDeposu);
    kategoriGuncelleUseCase = KategoriGuncelleUseCase(_menuDeposu);
    kategoriSilUseCase = KategoriSilUseCase(_menuDeposu);
    kategoriyeGoreUrunleriGetirUseCase = KategoriyeGoreUrunleriGetirUseCase(
      _menuDeposu,
      _stokDeposu,
    );
    urunleriGetirUseCase = UrunleriGetirUseCase(_menuDeposu, _stokDeposu);
    urunEkleUseCase = UrunEkleUseCase(_menuDeposu);
    urunGuncelleUseCase = UrunGuncelleUseCase(_menuDeposu);
    urunSilUseCase = UrunSilUseCase(_menuDeposu);
    sepetiGetirUseCase = SepetiGetirUseCase(_sepetDeposu);
    sepeteUrunEkleUseCase = SepeteUrunEkleUseCase(_sepetDeposu);
    sepetKalemiGuncelleUseCase = SepetKalemiGuncelleUseCase(_sepetDeposu);
    sepetKalemiSilUseCase = SepetKalemiSilUseCase(_sepetDeposu);
    sepetiTemizleUseCase = SepetiTemizleUseCase(_sepetDeposu);
    siparisOlusturUseCase = SiparisOlusturUseCase(
      _siparisDeposu,
      stokDusUseCase: SipariseGoreStokDusUseCase(_stokDeposu),
    );
    siparisDurumuGuncelleUseCase = SiparisDurumuGuncelleUseCase(_siparisDeposu);
    siparisiYazdirUseCase = SiparisiYazdirUseCase(
      _yaziciDeposu,
      yaziciCiktiPlatformu,
      const VarsayilanYaziciHedefleriBelirleyici(),
    );
    siparisleriGetirUseCase = SiparisleriGetirUseCase(_siparisDeposu);
    yazicilariGetirUseCase = YazicilariGetirUseCase(_yaziciDeposu);
    yaziciEkleUseCase = YaziciEkleUseCase(_yaziciDeposu);
    yaziciGuncelleUseCase = YaziciGuncelleUseCase(_yaziciDeposu);
    yaziciSilUseCase = YaziciSilUseCase(_yaziciDeposu);
    sistemYazicilariniGetirUseCase = const SistemYazicilariniGetirUseCase();
    personelleriGetirUseCase = PersonelleriGetirUseCase(_personelDeposu);
    personelSilUseCase = PersonelSilUseCase(_personelDeposu);
    salonBolumleriniGetirUseCase = SalonBolumleriniGetirUseCase(
      _salonPlaniDeposu,
    );
    salonBolumuEkleUseCase = SalonBolumuEkleUseCase(_salonPlaniDeposu);
    salonBolumuGuncelleUseCase = SalonBolumuGuncelleUseCase(_salonPlaniDeposu);
    salonBolumuSilUseCase = SalonBolumuSilUseCase(_salonPlaniDeposu);
    masaEkleUseCase = MasaEkleUseCase(_salonPlaniDeposu);
    masaGuncelleUseCase = MasaGuncelleUseCase(_salonPlaniDeposu);
    masaSilUseCase = MasaSilUseCase(_salonPlaniDeposu);
    hammaddeleriGetirUseCase = HammaddeleriGetirUseCase(_stokDeposu);
    hammaddeEkleUseCase = HammaddeEkleUseCase(_stokDeposu);
    hammaddeGuncelleUseCase = HammaddeGuncelleUseCase(_stokDeposu);
    receteyiGetirUseCase = ReceteyiGetirUseCase(_stokDeposu);
    receteyiKaydetUseCase = ReceteyiKaydetUseCase(_stokDeposu);
    stokOzetiGetirUseCase = StokOzetiGetirUseCase(_stokDeposu, _menuDeposu);
    sipariseGoreStokDusUseCase = SipariseGoreStokDusUseCase(_stokDeposu);
  }

  static final ServisKaydi ortak = ServisKaydi._(ServisBagimlilikleri.gercek());

  factory ServisKaydi.mock() {
    return ServisKaydi._(ServisBagimlilikleri.mock());
  }

  factory ServisKaydi.gercek() {
    return ortak;
  }

  factory ServisKaydi.sqlite() {
    return ServisKaydi._(ServisBagimlilikleri.sqlite());
  }

  factory ServisKaydi.api() {
    return ServisKaydi._(ServisBagimlilikleri.api());
  }

  factory ServisKaydi.olustur(VeriKaynagiTipi tip) {
    return ServisKaydi._(ServisBagimlilikleri.olustur(tip));
  }

  late final LisansDeposu _lisansDeposu;
  late final KimlikDeposu _kimlikDeposu;
  late final MenuDeposu _menuDeposu;
  late final SepetDeposu _sepetDeposu;
  late final SiparisDeposu _siparisDeposu;
  late final YaziciDeposu _yaziciDeposu;
  late final PersonelDeposu _personelDeposu;
  late final SalonPlaniDeposu _salonPlaniDeposu;
  late final StokDeposu _stokDeposu;

  late final LisansDurumuGetirUseCase lisansDurumuGetirUseCase;
  late final LisansAktifEtUseCase lisansAktifEtUseCase;
  late final AktifKullaniciGetirUseCase aktifKullaniciGetirUseCase;
  late final GirisYapUseCase girisYapUseCase;
  late final HesapOlusturUseCase hesapOlusturUseCase;
  late final CikisYapUseCase cikisYapUseCase;
  late final MisafirOlusturUseCase misafirOlusturUseCase;
  late final KategorileriGetirUseCase kategorileriGetirUseCase;
  late final KategoriEkleUseCase kategoriEkleUseCase;
  late final KategoriGuncelleUseCase kategoriGuncelleUseCase;
  late final KategoriSilUseCase kategoriSilUseCase;
  late final KategoriyeGoreUrunleriGetirUseCase
  kategoriyeGoreUrunleriGetirUseCase;
  late final UrunleriGetirUseCase urunleriGetirUseCase;
  late final UrunEkleUseCase urunEkleUseCase;
  late final UrunGuncelleUseCase urunGuncelleUseCase;
  late final UrunSilUseCase urunSilUseCase;
  late final SepetiGetirUseCase sepetiGetirUseCase;
  late final SepeteUrunEkleUseCase sepeteUrunEkleUseCase;
  late final SepetKalemiGuncelleUseCase sepetKalemiGuncelleUseCase;
  late final SepetKalemiSilUseCase sepetKalemiSilUseCase;
  late final SepetiTemizleUseCase sepetiTemizleUseCase;
  late final SiparisOlusturUseCase siparisOlusturUseCase;
  late final SiparisDurumuGuncelleUseCase siparisDurumuGuncelleUseCase;
  late final SiparisiYazdirUseCase siparisiYazdirUseCase;
  late final SiparisleriGetirUseCase siparisleriGetirUseCase;
  late final YazicilariGetirUseCase yazicilariGetirUseCase;
  late final YaziciEkleUseCase yaziciEkleUseCase;
  late final YaziciGuncelleUseCase yaziciGuncelleUseCase;
  late final YaziciSilUseCase yaziciSilUseCase;
  late final SistemYazicilariniGetirUseCase sistemYazicilariniGetirUseCase;
  late final PersonelleriGetirUseCase personelleriGetirUseCase;
  late final PersonelSilUseCase personelSilUseCase;
  late final SalonBolumleriniGetirUseCase salonBolumleriniGetirUseCase;
  late final SalonBolumuEkleUseCase salonBolumuEkleUseCase;
  late final SalonBolumuGuncelleUseCase salonBolumuGuncelleUseCase;
  late final SalonBolumuSilUseCase salonBolumuSilUseCase;
  late final MasaEkleUseCase masaEkleUseCase;
  late final MasaGuncelleUseCase masaGuncelleUseCase;
  late final MasaSilUseCase masaSilUseCase;
  late final HammaddeleriGetirUseCase hammaddeleriGetirUseCase;
  late final HammaddeEkleUseCase hammaddeEkleUseCase;
  late final HammaddeGuncelleUseCase hammaddeGuncelleUseCase;
  late final ReceteyiGetirUseCase receteyiGetirUseCase;
  late final ReceteyiKaydetUseCase receteyiKaydetUseCase;
  late final StokOzetiGetirUseCase stokOzetiGetirUseCase;
  late final SipariseGoreStokDusUseCase sipariseGoreStokDusUseCase;
}
