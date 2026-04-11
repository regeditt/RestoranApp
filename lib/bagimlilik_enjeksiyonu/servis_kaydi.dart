import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_bagimlilikleri.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/depolar/asistan_backend_ayar_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/islem_yetkisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/api_destekli_ayar_asistani_yanitlayici.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/asistan_api_istemcisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/ayar_asistani_yanitlayici.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/kuralli_ayar_asistani_yanitlayici.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/rol_yetki_politikasi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/rol_yetki_politikasi_varsayilan.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/aktif_kullanici_getir_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/asistan_backend_ayarini_getir_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/asistan_backend_ayarini_kaydet_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/asistan_backend_baglanti_test_et_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/ayar_asistani_yanit_uret_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/cikis_yap_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/giris_yap_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/hesap_olustur_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/islem_yetkisi_kontrol_et_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/misafir_olustur_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/veri/depolar/asistan_backend_ayar_deposu_sqlite.dart';
import 'package:restoran_app/ozellikler/kimlik/veri/servisler/http_asistan_api_istemcisi.dart';
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
import 'package:restoran_app/ozellikler/odeme_kasa/alan/depolar/odeme_kasa_deposu.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/uygulama/use_case/kasa_hareketi_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/uygulama/use_case/kasa_ozeti_getir_use_case.dart';
import 'package:restoran_app/ozellikler/rezervasyon/alan/depolar/rezervasyon_deposu.dart';
import 'package:restoran_app/ozellikler/rezervasyon/uygulama/use_case/rezervasyon_durumu_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/rezervasyon/uygulama/use_case/rezervasyon_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/rezervasyon/uygulama/use_case/rezervasyon_sil_use_case.dart';
import 'package:restoran_app/ozellikler/rezervasyon/uygulama/use_case/rezervasyonlari_getir_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepete_urun_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepet_kupon_kodunu_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepet_kalemi_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepet_kalemi_sil_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepeti_getir_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepeti_temizle_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_entegrasyon_yonetim_servisi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparis_olustur_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparis_durumu_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparisi_yazdir_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparisleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/yazici_hedefleri_belirleyici.dart';
import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/hammadde_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/hammadde_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/hammadde_uyarilarini_getir_use_case.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/hammaddeleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/receteyi_getir_use_case.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/receteyi_kaydet_use_case.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/siparise_gore_stok_dus_use_case.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/stok_alarm_gecmisini_getir_use_case.dart';
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
import 'package:restoran_app/ortak/platform/cihaz_kimligi_saglayici.dart';
import 'package:restoran_app/ortak/platform/yazici_cikti_platformu.dart';
import 'package:restoran_app/ortak/veri/veri_kaynagi_tipi.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

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
    _odemeKasaDeposu = bagimlilikler.odemeKasaDeposu;
    _rezervasyonDeposu = bagimlilikler.rezervasyonDeposu;
    kuryeEntegrasyonYonetimServisi =
        bagimlilikler.kuryeEntegrasyonYonetimServisi;
    veritabani = bagimlilikler.veritabani;
    _rolYetkiPolitikasi = const RolYetkiPolitikasiVarsayilan();
    final AyarAsistaniYanitlayici yedekYanitlayici =
        const KuralliAyarAsistaniYanitlayici();
    _asistanBackendAyarDeposu = veritabani == null
        ? AsistanBackendAyarDeposuBellek()
        : AsistanBackendAyarDeposuSqlite(veritabani!);
    _asistanApiIstemcisi = HttpAsistanApiIstemcisi();
    _ayarAsistaniYanitlayici = ApiDestekliAyarAsistaniYanitlayici(
      backendAyarDeposu: _asistanBackendAyarDeposu,
      apiIstemcisi: _asistanApiIstemcisi,
      yedekYanitlayici: yedekYanitlayici,
    );

    const LisansAnahtariDogrulayici lisansDogrulayici =
        LisansAnahtariDogrulayici();
    lisansDurumuGetirUseCase = LisansDurumuGetirUseCase(
      _lisansDeposu,
      lisansDogrulayici,
      cihazKimligiSaglayici,
    );
    lisansAktifEtUseCase = LisansAktifEtUseCase(
      _lisansDeposu,
      lisansDogrulayici,
      cihazKimligiSaglayici,
    );
    aktifKullaniciGetirUseCase = AktifKullaniciGetirUseCase(_kimlikDeposu);
    girisYapUseCase = GirisYapUseCase(_kimlikDeposu);
    hesapOlusturUseCase = HesapOlusturUseCase(_kimlikDeposu);
    cikisYapUseCase = CikisYapUseCase(_kimlikDeposu);
    misafirOlusturUseCase = MisafirOlusturUseCase(_kimlikDeposu);
    islemYetkisiKontrolEtUseCase = IslemYetkisiKontrolEtUseCase(
      _kimlikDeposu,
      _rolYetkiPolitikasi,
    );
    asistanBackendAyariniGetirUseCase = AsistanBackendAyariniGetirUseCase(
      _asistanBackendAyarDeposu,
    );
    asistanBackendAyariniKaydetUseCase = AsistanBackendAyariniKaydetUseCase(
      _asistanBackendAyarDeposu,
    );
    asistanBackendBaglantiTestEtUseCase = AsistanBackendBaglantiTestEtUseCase(
      _asistanApiIstemcisi,
    );
    ayarAsistaniYanitUretUseCase = AyarAsistaniYanitUretUseCase(
      _ayarAsistaniYanitlayici,
    );
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
    sepetKuponKodunuGuncelleUseCase = SepetKuponKodunuGuncelleUseCase(
      _sepetDeposu,
    );
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
    hammaddeleriUyariyaGoreGetirUseCase = HammaddeleriUyariyaGoreGetirUseCase(
      _stokDeposu,
    );
    hammaddeEkleUseCase = HammaddeEkleUseCase(_stokDeposu);
    hammaddeGuncelleUseCase = HammaddeGuncelleUseCase(_stokDeposu);
    stokAlarmGecmisiniGetirUseCase = StokAlarmGecmisiniGetirUseCase(
      _stokDeposu,
    );
    receteyiGetirUseCase = ReceteyiGetirUseCase(_stokDeposu);
    receteyiKaydetUseCase = ReceteyiKaydetUseCase(_stokDeposu);
    stokOzetiGetirUseCase = StokOzetiGetirUseCase(_stokDeposu, _menuDeposu);
    sipariseGoreStokDusUseCase = SipariseGoreStokDusUseCase(_stokDeposu);
    kasaOzetiGetirUseCase = KasaOzetiGetirUseCase(_odemeKasaDeposu);
    kasaHareketiEkleUseCase = KasaHareketiEkleUseCase(_odemeKasaDeposu);
    rezervasyonlariGetirUseCase = RezervasyonlariGetirUseCase(
      _rezervasyonDeposu,
    );
    rezervasyonEkleUseCase = RezervasyonEkleUseCase(_rezervasyonDeposu);
    rezervasyonDurumuGuncelleUseCase = RezervasyonDurumuGuncelleUseCase(
      _rezervasyonDeposu,
    );
    rezervasyonSilUseCase = RezervasyonSilUseCase(_rezervasyonDeposu);
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
  late final OdemeKasaDeposu _odemeKasaDeposu;
  late final RezervasyonDeposu _rezervasyonDeposu;
  late final RolYetkiPolitikasi _rolYetkiPolitikasi;
  late final AsistanBackendAyarDeposu _asistanBackendAyarDeposu;
  late final AsistanApiIstemcisi _asistanApiIstemcisi;
  late final AyarAsistaniYanitlayici _ayarAsistaniYanitlayici;
  late final KuryeEntegrasyonYonetimServisi kuryeEntegrasyonYonetimServisi;
  late final UygulamaVeritabani? veritabani;

  late final LisansDurumuGetirUseCase lisansDurumuGetirUseCase;
  late final LisansAktifEtUseCase lisansAktifEtUseCase;
  late final AktifKullaniciGetirUseCase aktifKullaniciGetirUseCase;
  late final GirisYapUseCase girisYapUseCase;
  late final HesapOlusturUseCase hesapOlusturUseCase;
  late final CikisYapUseCase cikisYapUseCase;
  late final MisafirOlusturUseCase misafirOlusturUseCase;
  late final IslemYetkisiKontrolEtUseCase islemYetkisiKontrolEtUseCase;
  late final AsistanBackendAyariniGetirUseCase
  asistanBackendAyariniGetirUseCase;
  late final AsistanBackendAyariniKaydetUseCase
  asistanBackendAyariniKaydetUseCase;
  late final AsistanBackendBaglantiTestEtUseCase
  asistanBackendBaglantiTestEtUseCase;
  late final AyarAsistaniYanitUretUseCase ayarAsistaniYanitUretUseCase;
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
  late final SepetKuponKodunuGuncelleUseCase sepetKuponKodunuGuncelleUseCase;
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
  late final HammaddeleriUyariyaGoreGetirUseCase
  hammaddeleriUyariyaGoreGetirUseCase;
  late final HammaddeEkleUseCase hammaddeEkleUseCase;
  late final HammaddeGuncelleUseCase hammaddeGuncelleUseCase;
  late final StokAlarmGecmisiniGetirUseCase stokAlarmGecmisiniGetirUseCase;
  late final ReceteyiGetirUseCase receteyiGetirUseCase;
  late final ReceteyiKaydetUseCase receteyiKaydetUseCase;
  late final StokOzetiGetirUseCase stokOzetiGetirUseCase;
  late final SipariseGoreStokDusUseCase sipariseGoreStokDusUseCase;
  late final KasaOzetiGetirUseCase kasaOzetiGetirUseCase;
  late final KasaHareketiEkleUseCase kasaHareketiEkleUseCase;
  late final RezervasyonlariGetirUseCase rezervasyonlariGetirUseCase;
  late final RezervasyonEkleUseCase rezervasyonEkleUseCase;
  late final RezervasyonDurumuGuncelleUseCase rezervasyonDurumuGuncelleUseCase;
  late final RezervasyonSilUseCase rezervasyonSilUseCase;

  Future<bool> islemYetkisiVarMi(IslemYetkisi yetki) {
    return islemYetkisiKontrolEtUseCase(yetki);
  }
}
