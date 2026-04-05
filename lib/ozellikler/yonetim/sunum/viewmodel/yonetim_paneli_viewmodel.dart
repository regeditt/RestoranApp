import 'package:flutter/foundation.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/kategorileri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/use_case/urunleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparisleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/stok_ozeti_varligi.dart';
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
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/salon_bolumlerini_getir_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/sistem_yazicilarini_getir_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/yazici_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/yazici_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/yazici_sil_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/yazicilari_getir_use_case.dart';

enum PanelFiltre { tumu, aktif, gelAl, paketServis, restorandaYe }

enum ZamanFiltresi { bugun, sonIkiSaat, tumu }

enum SiparisSirasi { enYeni, tutarYuksek, durumOncelikli }

class YonetimPaneliIslemSonucu {
  const YonetimPaneliIslemSonucu.basarili([this.mesaj = '']) : basarili = true;

  const YonetimPaneliIslemSonucu.hata(this.mesaj) : basarili = false;

  final bool basarili;
  final String mesaj;
}

class YonetimPaneliViewModel extends ChangeNotifier {
  YonetimPaneliViewModel({
    required SiparisleriGetirUseCase siparisleriGetirUseCase,
    required PersonelleriGetirUseCase personelleriGetirUseCase,
    required SistemYazicilariniGetirUseCase sistemYazicilariniGetirUseCase,
    required YazicilariGetirUseCase yazicilariGetirUseCase,
    required SalonBolumleriniGetirUseCase salonBolumleriniGetirUseCase,
    required KategorileriGetirUseCase kategorileriGetirUseCase,
    required UrunleriGetirUseCase urunleriGetirUseCase,
    required StokOzetiGetirUseCase stokOzetiGetirUseCase,
    required YaziciEkleUseCase yaziciEkleUseCase,
    required YaziciGuncelleUseCase yaziciGuncelleUseCase,
    required YaziciSilUseCase yaziciSilUseCase,
  }) : _siparisleriGetirUseCase = siparisleriGetirUseCase,
       _personelleriGetirUseCase = personelleriGetirUseCase,
       _sistemYazicilariniGetirUseCase = sistemYazicilariniGetirUseCase,
       _yazicilariGetirUseCase = yazicilariGetirUseCase,
       _salonBolumleriniGetirUseCase = salonBolumleriniGetirUseCase,
       _kategorileriGetirUseCase = kategorileriGetirUseCase,
       _urunleriGetirUseCase = urunleriGetirUseCase,
       _stokOzetiGetirUseCase = stokOzetiGetirUseCase,
       _yaziciEkleUseCase = yaziciEkleUseCase,
       _yaziciGuncelleUseCase = yaziciGuncelleUseCase,
       _yaziciSilUseCase = yaziciSilUseCase;

  factory YonetimPaneliViewModel.servisKaydindan(ServisKaydi servisKaydi) {
    return YonetimPaneliViewModel(
      siparisleriGetirUseCase: servisKaydi.siparisleriGetirUseCase,
      personelleriGetirUseCase: servisKaydi.personelleriGetirUseCase,
      sistemYazicilariniGetirUseCase:
          servisKaydi.sistemYazicilariniGetirUseCase,
      yazicilariGetirUseCase: servisKaydi.yazicilariGetirUseCase,
      salonBolumleriniGetirUseCase: servisKaydi.salonBolumleriniGetirUseCase,
      kategorileriGetirUseCase: servisKaydi.kategorileriGetirUseCase,
      urunleriGetirUseCase: servisKaydi.urunleriGetirUseCase,
      stokOzetiGetirUseCase: servisKaydi.stokOzetiGetirUseCase,
      yaziciEkleUseCase: servisKaydi.yaziciEkleUseCase,
      yaziciGuncelleUseCase: servisKaydi.yaziciGuncelleUseCase,
      yaziciSilUseCase: servisKaydi.yaziciSilUseCase,
    );
  }

  final SiparisleriGetirUseCase _siparisleriGetirUseCase;
  final PersonelleriGetirUseCase _personelleriGetirUseCase;
  final SistemYazicilariniGetirUseCase _sistemYazicilariniGetirUseCase;
  final YazicilariGetirUseCase _yazicilariGetirUseCase;
  final SalonBolumleriniGetirUseCase _salonBolumleriniGetirUseCase;
  final KategorileriGetirUseCase _kategorileriGetirUseCase;
  final UrunleriGetirUseCase _urunleriGetirUseCase;
  final StokOzetiGetirUseCase _stokOzetiGetirUseCase;
  final YaziciEkleUseCase _yaziciEkleUseCase;
  final YaziciGuncelleUseCase _yaziciGuncelleUseCase;
  final YaziciSilUseCase _yaziciSilUseCase;

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
      return const YonetimPaneliIslemSonucu.basarili();
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
      return const YonetimPaneliIslemSonucu.basarili();
    } catch (_) {
      return const YonetimPaneliIslemSonucu.hata(
        'Yonetim verileri yenilenemedi',
      );
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
}
