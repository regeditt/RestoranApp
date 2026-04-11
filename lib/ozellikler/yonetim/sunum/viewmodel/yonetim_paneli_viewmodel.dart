import 'package:flutter/foundation.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/kategorileri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/urunleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/hesap_olustur_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_entegrasyon_yonetim_servisi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_konum_takip_servisi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_takip_senkronlayici.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparisleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/stok/alan/enumlar/stok_uyari_durumu.dart';
import 'package:restoran_app/ozellikler/stok/alan/enumlar/stok_uyari_filtresi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/stok_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/hammadde_uyarilarini_getir_use_case.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/stok_ozeti_getir_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/saatlik_siparis_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/sistem_yazici_adayi_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yonetim_paneli_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_paneli_yardimcilari.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/servisler/yonetim_raporu_hesaplayici.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/personelleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/personel_sil_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/salon_bolumlerini_getir_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/sistem_yazicilarini_getir_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/yazici_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/yazici_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/yazici_sil_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/yazicilari_getir_use_case.dart';

enum PanelFiltre { tumu, aktif, gelAl, paketServis, restorandaYe }

enum ZamanFiltresi { bugun, sonIkiSaat, tumu }

enum SiparisSirasi { enYeni, tutarYuksek, durumOncelikli }

/// Yonetim panelindeki kullanici aksiyonlarinin sonucunu UI katmanina tasir.
class YonetimPaneliIslemSonucu {
  const YonetimPaneliIslemSonucu.basarili([this.mesaj = '']) : basarili = true;

  const YonetimPaneliIslemSonucu.hata(this.mesaj) : basarili = false;

  final bool basarili;
  final String mesaj;
}

/// Yonetim panelinde siparis, personel, yazici, menu ve stok verilerinin durumunu yonetir.
class YonetimPaneliViewModel extends ChangeNotifier {
  YonetimPaneliViewModel({
    required SiparisleriGetirUseCase siparisleriGetirUseCase,
    required PersonelleriGetirUseCase personelleriGetirUseCase,
    required PersonelSilUseCase personelSilUseCase,
    required SistemYazicilariniGetirUseCase sistemYazicilariniGetirUseCase,
    required YazicilariGetirUseCase yazicilariGetirUseCase,
    required SalonBolumleriniGetirUseCase salonBolumleriniGetirUseCase,
    required KategorileriGetirUseCase kategorileriGetirUseCase,
    required UrunleriGetirUseCase urunleriGetirUseCase,
    required StokOzetiGetirUseCase stokOzetiGetirUseCase,
    HammaddeleriUyariyaGoreGetirUseCase? hammaddeleriUyariyaGoreGetirUseCase,
    required HesapOlusturUseCase hesapOlusturUseCase,
    required YaziciEkleUseCase yaziciEkleUseCase,
    required YaziciGuncelleUseCase yaziciGuncelleUseCase,
    required YaziciSilUseCase yaziciSilUseCase,
    KuryeKonumTakipServisi? kuryeTakipServisi,
    KuryeEntegrasyonYonetimServisi? kuryeEntegrasyonServisi,
  }) : _siparisleriGetirUseCase = siparisleriGetirUseCase,
       _personelleriGetirUseCase = personelleriGetirUseCase,
       _personelSilUseCase = personelSilUseCase,
       _sistemYazicilariniGetirUseCase = sistemYazicilariniGetirUseCase,
       _yazicilariGetirUseCase = yazicilariGetirUseCase,
       _salonBolumleriniGetirUseCase = salonBolumleriniGetirUseCase,
       _kategorileriGetirUseCase = kategorileriGetirUseCase,
       _urunleriGetirUseCase = urunleriGetirUseCase,
       _stokOzetiGetirUseCase = stokOzetiGetirUseCase,
       _hammaddeleriUyariyaGoreGetirUseCase =
           hammaddeleriUyariyaGoreGetirUseCase,
       _hesapOlusturUseCase = hesapOlusturUseCase,
       _yaziciEkleUseCase = yaziciEkleUseCase,
       _yaziciGuncelleUseCase = yaziciGuncelleUseCase,
       _yaziciSilUseCase = yaziciSilUseCase,
       _kuryeKonumTakipServisi = kuryeTakipServisi ?? kuryeKonumTakipServisi,
       _kuryeEntegrasyonServisi =
           kuryeEntegrasyonServisi ?? KuryeEntegrasyonYonetimServisi();

  factory YonetimPaneliViewModel.servisKaydindan(ServisKaydi servisKaydi) {
    return YonetimPaneliViewModel(
      siparisleriGetirUseCase: servisKaydi.siparisleriGetirUseCase,
      personelleriGetirUseCase: servisKaydi.personelleriGetirUseCase,
      personelSilUseCase: servisKaydi.personelSilUseCase,
      sistemYazicilariniGetirUseCase:
          servisKaydi.sistemYazicilariniGetirUseCase,
      yazicilariGetirUseCase: servisKaydi.yazicilariGetirUseCase,
      salonBolumleriniGetirUseCase: servisKaydi.salonBolumleriniGetirUseCase,
      kategorileriGetirUseCase: servisKaydi.kategorileriGetirUseCase,
      urunleriGetirUseCase: servisKaydi.urunleriGetirUseCase,
      stokOzetiGetirUseCase: servisKaydi.stokOzetiGetirUseCase,
      hammaddeleriUyariyaGoreGetirUseCase:
          servisKaydi.hammaddeleriUyariyaGoreGetirUseCase,
      hesapOlusturUseCase: servisKaydi.hesapOlusturUseCase,
      yaziciEkleUseCase: servisKaydi.yaziciEkleUseCase,
      yaziciGuncelleUseCase: servisKaydi.yaziciGuncelleUseCase,
      yaziciSilUseCase: servisKaydi.yaziciSilUseCase,
      kuryeEntegrasyonServisi: servisKaydi.kuryeEntegrasyonYonetimServisi,
    );
  }

  final SiparisleriGetirUseCase _siparisleriGetirUseCase;
  final PersonelleriGetirUseCase _personelleriGetirUseCase;
  final PersonelSilUseCase _personelSilUseCase;
  final SistemYazicilariniGetirUseCase _sistemYazicilariniGetirUseCase;
  final YazicilariGetirUseCase _yazicilariGetirUseCase;
  final SalonBolumleriniGetirUseCase _salonBolumleriniGetirUseCase;
  final KategorileriGetirUseCase _kategorileriGetirUseCase;
  final UrunleriGetirUseCase _urunleriGetirUseCase;
  final StokOzetiGetirUseCase _stokOzetiGetirUseCase;
  final HammaddeleriUyariyaGoreGetirUseCase?
  _hammaddeleriUyariyaGoreGetirUseCase;
  final HesapOlusturUseCase _hesapOlusturUseCase;
  final YaziciEkleUseCase _yaziciEkleUseCase;
  final YaziciGuncelleUseCase _yaziciGuncelleUseCase;
  final YaziciSilUseCase _yaziciSilUseCase;
  final KuryeKonumTakipServisi _kuryeKonumTakipServisi;
  final KuryeEntegrasyonYonetimServisi _kuryeEntegrasyonServisi;

  bool _yukleniyor = true;
  List<SiparisVarligi> _siparisler = const <SiparisVarligi>[];
  List<YaziciDurumuVarligi> _yazicilar = const <YaziciDurumuVarligi>[];
  List<SistemYaziciAdayiVarligi> _sistemYazicilari =
      const <SistemYaziciAdayiVarligi>[];
  List<PersonelDurumuVarligi> _personeller = const <PersonelDurumuVarligi>[];
  List<SalonBolumuVarligi> _salonBolumleri = const <SalonBolumuVarligi>[];
  List<KategoriVarligi> _menuKategorileri = const <KategoriVarligi>[];
  List<UrunVarligi> _menuUrunleri = const <UrunVarligi>[];
  StokOzetiVarligi? _stokOzeti;
  PanelFiltre _seciliFiltre = PanelFiltre.tumu;
  ZamanFiltresi _seciliZamanFiltresi = ZamanFiltresi.bugun;
  SiparisSirasi _seciliSiralama = SiparisSirasi.enYeni;
  String _aramaMetni = '';
  bool _stokAlarmDurumlariIlkEslemeYapildi = false;
  Map<String, StokUyariDurumu> _oncekiStokAlarmDurumlari =
      <String, StokUyariDurumu>{};
  final Map<String, DateTime> _sonBildirimZamanlari = <String, DateTime>{};
  static const Duration _stokAlarmBildirimThrottleSuresi = Duration(
    minutes: 15,
  );

  bool get yukleniyor => _yukleniyor;
  List<SiparisVarligi> get siparisler => _siparisler;
  List<YaziciDurumuVarligi> get yazicilar => _yazicilar;
  List<SistemYaziciAdayiVarligi> get sistemYazicilari => _sistemYazicilari;
  List<PersonelDurumuVarligi> get personeller => _personeller;
  List<SalonBolumuVarligi> get salonBolumleri => _salonBolumleri;
  List<KategoriVarligi> get menuKategorileri => _menuKategorileri;
  List<UrunVarligi> get menuUrunleri => _menuUrunleri;
  StokOzetiVarligi? get stokOzeti => _stokOzeti;
  PanelFiltre get seciliFiltre => _seciliFiltre;
  ZamanFiltresi get seciliZamanFiltresi => _seciliZamanFiltresi;
  SiparisSirasi get seciliSiralama => _seciliSiralama;
  String get aramaMetni => _aramaMetni;

  List<SiparisVarligi> get filtreliSiparisler {
    final List<SiparisVarligi> zamanFiltreli = _zamanFiltresiUygula(
      _siparisler,
    );
    final List<SiparisVarligi> kanalFiltreli;
    switch (_seciliFiltre) {
      case PanelFiltre.tumu:
        kanalFiltreli = zamanFiltreli;
      case PanelFiltre.aktif:
        kanalFiltreli = zamanFiltreli
            .where(
              (siparis) =>
                  siparis.durum == SiparisDurumu.alindi ||
                  siparis.durum == SiparisDurumu.hazirlaniyor ||
                  siparis.durum == SiparisDurumu.hazir ||
                  siparis.durum == SiparisDurumu.yolda,
            )
            .toList();
      case PanelFiltre.gelAl:
        kanalFiltreli = zamanFiltreli
            .where((siparis) => siparis.teslimatTipi == TeslimatTipi.gelAl)
            .toList();
      case PanelFiltre.paketServis:
        kanalFiltreli = zamanFiltreli
            .where(
              (siparis) => siparis.teslimatTipi == TeslimatTipi.paketServis,
            )
            .toList();
      case PanelFiltre.restorandaYe:
        kanalFiltreli = zamanFiltreli
            .where(
              (siparis) => siparis.teslimatTipi == TeslimatTipi.restorandaYe,
            )
            .toList();
    }

    return _sirala(_aramaUygula(kanalFiltreli));
  }

  YonetimPaneliOzetiVarligi get panelOzeti =>
      YonetimRaporuHesaplayici.panelOzetiniHesapla(filtreliSiparisler);

  List<SaatlikSiparisOzetiVarligi> get saatlikVeriler =>
      YonetimRaporuHesaplayici.saatlikVeriUret(filtreliSiparisler);

  void filtreSec(PanelFiltre filtre) {
    if (_seciliFiltre == filtre) {
      return;
    }
    _seciliFiltre = filtre;
    notifyListeners();
  }

  void zamanFiltresiSec(ZamanFiltresi filtre) {
    if (_seciliZamanFiltresi == filtre) {
      return;
    }
    _seciliZamanFiltresi = filtre;
    notifyListeners();
  }

  void siralamaSec(SiparisSirasi siralama) {
    if (_seciliSiralama == siralama) {
      return;
    }
    _seciliSiralama = siralama;
    notifyListeners();
  }

  void aramaMetniDegisti(String deger) {
    if (_aramaMetni == deger) {
      return;
    }
    _aramaMetni = deger;
    notifyListeners();
  }

  Future<YonetimPaneliIslemSonucu> yukle() async {
    _yukleniyor = true;
    notifyListeners();
    try {
      final List<SiparisVarligi> siparisler = await _siparisleriGetirUseCase();
      final List<PersonelDurumuVarligi> personeller =
          await _personelleriGetirUseCase();
      final List<SistemYaziciAdayiVarligi> sistemYazicilari =
          await _sistemYazicilariniGetirUseCase();
      final List<YaziciDurumuVarligi> yazicilar =
          await _yazicilariGetirUseCase();
      final List<SalonBolumuVarligi> salonBolumleri =
          await _salonBolumleriniGetirUseCase();
      final List<KategoriVarligi> menuKategorileri =
          await _kategorileriGetirUseCase();
      final List<UrunVarligi> menuUrunleri = await _urunleriGetirUseCase();
      final StokOzetiVarligi stokOzeti = await _stokOzetiGetirUseCase();
      await KuryeTakipSenkronlayici.siparislerleEsitle(
        takipServisi: _kuryeKonumTakipServisi,
        siparisler: siparisler,
        entegrasyonServisi: _kuryeEntegrasyonServisi,
      );

      _siparisler = siparisler;
      _yazicilar = yazicilar;
      _sistemYazicilari = sistemYazicilari;
      _personeller = personeller;
      _salonBolumleri = salonBolumleri;
      _menuKategorileri = menuKategorileri;
      _menuUrunleri = menuUrunleri;
      _stokOzeti = stokOzeti;
      _yukleniyor = false;
      notifyListeners();
      final String? stokBildirimMesaji =
          await _stokAlarmBildirimMesajiOlustur();
      return YonetimPaneliIslemSonucu.basarili(stokBildirimMesaji ?? '');
    } catch (_) {
      _yukleniyor = false;
      notifyListeners();
      return const YonetimPaneliIslemSonucu.hata(
        'Yonetim verileri yuklenemedi',
      );
    }
  }

  Future<YonetimPaneliIslemSonucu> yaziciEkle(
    YaziciDurumuVarligi yazici,
  ) async {
    try {
      await _yaziciEkleUseCase(yazici);
      await _yazicilariYenile();
      return YonetimPaneliIslemSonucu.basarili('${yazici.ad} eklendi');
    } catch (_) {
      return const YonetimPaneliIslemSonucu.hata('Yazici eklenemedi');
    }
  }

  Future<YonetimPaneliIslemSonucu> yaziciSil(YaziciDurumuVarligi yazici) async {
    try {
      await _yaziciSilUseCase(yazici.id);
      await _yazicilariYenile();
      return YonetimPaneliIslemSonucu.basarili('${yazici.ad} kaldirildi');
    } catch (_) {
      return const YonetimPaneliIslemSonucu.hata('Yazici kaldirilamadi');
    }
  }

  Future<YonetimPaneliIslemSonucu> yaziciGuncelle(
    YaziciDurumuVarligi yazici, {
    String? rolEtiketi,
    YaziciBaglantiDurumu? durum,
  }) async {
    try {
      await _yaziciGuncelleUseCase(
        yazici.copyWith(rolEtiketi: rolEtiketi, durum: durum),
      );
      await _yazicilariYenile();
      return const YonetimPaneliIslemSonucu.basarili();
    } catch (_) {
      return const YonetimPaneliIslemSonucu.hata('Yazici guncellenemedi');
    }
  }

  Future<YonetimPaneliIslemSonucu> yonetimVerileriniYenile() async {
    try {
      final List<SalonBolumuVarligi> salonBolumleri =
          await _salonBolumleriniGetirUseCase();
      final List<KategoriVarligi> menuKategorileri =
          await _kategorileriGetirUseCase();
      final List<UrunVarligi> menuUrunleri = await _urunleriGetirUseCase();
      final StokOzetiVarligi stokOzeti = await _stokOzetiGetirUseCase();

      _salonBolumleri = salonBolumleri;
      _menuKategorileri = menuKategorileri;
      _menuUrunleri = menuUrunleri;
      _stokOzeti = stokOzeti;
      notifyListeners();
      final String? stokBildirimMesaji =
          await _stokAlarmBildirimMesajiOlustur();
      return YonetimPaneliIslemSonucu.basarili(stokBildirimMesaji ?? '');
    } catch (_) {
      return const YonetimPaneliIslemSonucu.hata(
        'Yonetim verileri yenilenemedi',
      );
    }
  }

  Future<YonetimPaneliIslemSonucu> garsonHesabiOlustur({
    required String adSoyad,
    required String kullaniciAdi,
    required String sifre,
  }) async {
    try {
      await _hesapOlusturUseCase(
        telefon: kullaniciAdi.trim(),
        sifre: sifre.trim(),
        adSoyad: adSoyad.trim(),
        rol: KullaniciRolu.garson,
        aktifYap: false,
      );
      final List<PersonelDurumuVarligi> personeller =
          await _personelleriGetirUseCase();
      _personeller = personeller;
      notifyListeners();
      return YonetimPaneliIslemSonucu.basarili('${adSoyad.trim()} eklendi');
    } on StateError catch (hata) {
      return YonetimPaneliIslemSonucu.hata(hata.message.toString());
    } catch (_) {
      return const YonetimPaneliIslemSonucu.hata(
        'Garson hesabi olusturulamadi',
      );
    }
  }

  Future<YonetimPaneliIslemSonucu> personelSil(
    PersonelDurumuVarligi personel,
  ) async {
    try {
      await _personelSilUseCase(personel.kimlik);
      final List<PersonelDurumuVarligi> personeller =
          await _personelleriGetirUseCase();
      _personeller = personeller;
      notifyListeners();
      return YonetimPaneliIslemSonucu.basarili('${personel.adSoyad} silindi');
    } on StateError catch (hata) {
      return YonetimPaneliIslemSonucu.hata(hata.message.toString());
    } catch (_) {
      return const YonetimPaneliIslemSonucu.hata('Personel silinemedi');
    }
  }

  Future<void> _yazicilariYenile() async {
    final List<YaziciDurumuVarligi> yazicilar = await _yazicilariGetirUseCase();
    final List<SistemYaziciAdayiVarligi> sistemYazicilari =
        await _sistemYazicilariniGetirUseCase();
    _yazicilar = yazicilar;
    _sistemYazicilari = sistemYazicilari;
    notifyListeners();
  }

  List<SiparisVarligi> _aramaUygula(List<SiparisVarligi> kaynak) {
    final String sorgu = _aramaMetni.trim().toLowerCase();
    if (sorgu.isEmpty) {
      return kaynak;
    }

    return kaynak.where((SiparisVarligi siparis) {
      final String adSoyad =
          siparis.sahip.misafirBilgisi?.adSoyad.toLowerCase() ?? '';
      final String siparisNo = siparis.siparisNo.toLowerCase();
      return adSoyad.contains(sorgu) || siparisNo.contains(sorgu);
    }).toList();
  }

  List<SiparisVarligi> _zamanFiltresiUygula(List<SiparisVarligi> kaynak) {
    if (kaynak.isEmpty || _seciliZamanFiltresi == ZamanFiltresi.tumu) {
      return kaynak;
    }

    final DateTime enYeniTarih = kaynak
        .map((siparis) => siparis.olusturmaTarihi)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    switch (_seciliZamanFiltresi) {
      case ZamanFiltresi.bugun:
        return kaynak
            .where(
              (siparis) =>
                  siparis.olusturmaTarihi.year == enYeniTarih.year &&
                  siparis.olusturmaTarihi.month == enYeniTarih.month &&
                  siparis.olusturmaTarihi.day == enYeniTarih.day,
            )
            .toList();
      case ZamanFiltresi.sonIkiSaat:
        final DateTime esik = enYeniTarih.subtract(const Duration(hours: 2));
        return kaynak
            .where(
              (siparis) =>
                  !siparis.olusturmaTarihi.isBefore(esik) &&
                  !siparis.olusturmaTarihi.isAfter(enYeniTarih),
            )
            .toList();
      case ZamanFiltresi.tumu:
        return kaynak;
    }
  }

  List<SiparisVarligi> _sirala(List<SiparisVarligi> kaynak) {
    final List<SiparisVarligi> sirali = List<SiparisVarligi>.from(kaynak);

    switch (_seciliSiralama) {
      case SiparisSirasi.enYeni:
        sirali.sort((a, b) => b.olusturmaTarihi.compareTo(a.olusturmaTarihi));
      case SiparisSirasi.tutarYuksek:
        sirali.sort((a, b) => b.toplamTutar.compareTo(a.toplamTutar));
      case SiparisSirasi.durumOncelikli:
        sirali.sort((a, b) {
          final int durumKarsilastirma = durumOnceligi(
            a.durum,
          ).compareTo(durumOnceligi(b.durum));
          if (durumKarsilastirma != 0) {
            return durumKarsilastirma;
          }
          return b.olusturmaTarihi.compareTo(a.olusturmaTarihi);
        });
    }

    return sirali;
  }

  Future<String?> _stokAlarmBildirimMesajiOlustur() async {
    final HammaddeleriUyariyaGoreGetirUseCase? hammaddeleriGetir =
        _hammaddeleriUyariyaGoreGetirUseCase;
    if (hammaddeleriGetir == null) {
      return null;
    }
    final List<_StokAlarmAdayi> alarmAdaylari = <_StokAlarmAdayi>[];
    final Map<String, StokUyariDurumu> yeniAlarmDurumlari =
        <String, StokUyariDurumu>{};

    final List<({StokUyariFiltresi filtre, StokUyariDurumu durum})>
    alarmKaynaklari = <({StokUyariFiltresi filtre, StokUyariDurumu durum})>[
      (filtre: StokUyariFiltresi.tukendi, durum: StokUyariDurumu.tukendi),
      (filtre: StokUyariFiltresi.kritik, durum: StokUyariDurumu.kritik),
    ];

    for (final kaynak in alarmKaynaklari) {
      final List<HammaddeStokVarligi> hammaddeler = await hammaddeleriGetir(
        filtre: kaynak.filtre,
      );
      for (final HammaddeStokVarligi hammadde in hammaddeler) {
        yeniAlarmDurumlari[hammadde.id] = kaynak.durum;
        alarmAdaylari.add(
          _StokAlarmAdayi(
            id: hammadde.id,
            ad: hammadde.ad,
            durum: kaynak.durum,
          ),
        );
      }
    }

    if (!_stokAlarmDurumlariIlkEslemeYapildi) {
      _stokAlarmDurumlariIlkEslemeYapildi = true;
      _oncekiStokAlarmDurumlari = yeniAlarmDurumlari;
      return null;
    }

    final DateTime simdi = DateTime.now();
    final Map<String, _StokAlarmAdayi> adayHaritasi = <String, _StokAlarmAdayi>{
      for (final _StokAlarmAdayi aday in alarmAdaylari) aday.id: aday,
    };
    final List<_StokAlarmAdayi> bildirilecekler = <_StokAlarmAdayi>[];

    for (final _StokAlarmAdayi aday in alarmAdaylari) {
      final StokUyariDurumu oncekiDurum =
          _oncekiStokAlarmDurumlari[aday.id] ?? StokUyariDurumu.normal;
      final bool alarmGecisi =
          oncekiDurum != StokUyariDurumu.kritik &&
          oncekiDurum != StokUyariDurumu.tukendi;
      if (!alarmGecisi) {
        continue;
      }
      final DateTime? sonBildirim = _sonBildirimZamanlari[aday.id];
      final bool throttleda =
          sonBildirim != null &&
          simdi.difference(sonBildirim) < _stokAlarmBildirimThrottleSuresi;
      if (throttleda) {
        continue;
      }
      bildirilecekler.add(aday);
      _sonBildirimZamanlari[aday.id] = simdi;
    }

    _oncekiStokAlarmDurumlari = <String, StokUyariDurumu>{
      for (final MapEntry<String, _StokAlarmAdayi> giris
          in adayHaritasi.entries)
        giris.key: giris.value.durum,
    };

    if (bildirilecekler.isEmpty) {
      return null;
    }
    final int tukendiSayisi = bildirilecekler
        .where((aday) => aday.durum == StokUyariDurumu.tukendi)
        .length;
    final int kritikSayisi = bildirilecekler.length - tukendiSayisi;
    final String adlar = bildirilecekler
        .take(3)
        .map((aday) => aday.ad)
        .join(', ');
    final String adetMetni = bildirilecekler.length > 3
        ? '$adlar ve ${bildirilecekler.length - 3} kalem'
        : adlar;
    return 'Stok alarmi: $adetMetni. '
        'Kritik: $kritikSayisi, Tukendi: $tukendiSayisi.';
  }
}

class _StokAlarmAdayi {
  const _StokAlarmAdayi({
    required this.id,
    required this.ad,
    required this.durum,
  });

  final String id;
  final String ad;
  final StokUyariDurumu durum;
}
