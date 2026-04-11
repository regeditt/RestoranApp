import 'package:flutter/foundation.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/rezervasyon/alan/enumlar/rezervasyon_durumu.dart';
import 'package:restoran_app/ozellikler/rezervasyon/alan/varliklar/rezervasyon_varligi.dart';
import 'package:restoran_app/ozellikler/rezervasyon/uygulama/servisler/rezervasyon_masa_atama_servisi.dart';
import 'package:restoran_app/ozellikler/rezervasyon/uygulama/use_case/rezervasyon_durumu_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/rezervasyon/uygulama/use_case/rezervasyon_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/rezervasyon/uygulama/use_case/rezervasyon_sil_use_case.dart';
import 'package:restoran_app/ozellikler/rezervasyon/uygulama/use_case/rezervasyonlari_getir_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/salon_bolumlerini_getir_use_case.dart';

enum RezervasyonDurumFiltresi {
  tumu('Tumu'),
  aktif('Aktif'),
  noShow('No-show'),
  tamamlandi('Tamamlandi'),
  iptalEdildi('Iptal');

  const RezervasyonDurumFiltresi(this.etiket);

  final String etiket;
}

class RezervasyonOlusturmaGirdisi {
  const RezervasyonOlusturmaGirdisi({
    required this.musteriAdi,
    required this.telefon,
    required this.kisiSayisi,
    required this.baslangicZamani,
    required this.sureDakika,
    required this.notMetni,
    this.tercihBolumId,
  });

  final String musteriAdi;
  final String telefon;
  final int kisiSayisi;
  final DateTime baslangicZamani;
  final int sureDakika;
  final String notMetni;
  final String? tercihBolumId;
}

class RezervasyonIslemSonucu {
  const RezervasyonIslemSonucu.basarili([this.mesaj = '']) : basarili = true;

  const RezervasyonIslemSonucu.hata(this.mesaj) : basarili = false;

  final bool basarili;
  final String mesaj;
}

class RezervasyonViewModel extends ChangeNotifier {
  RezervasyonViewModel({
    required RezervasyonlariGetirUseCase rezervasyonlariGetirUseCase,
    required RezervasyonEkleUseCase rezervasyonEkleUseCase,
    required RezervasyonDurumuGuncelleUseCase rezervasyonDurumuGuncelleUseCase,
    required RezervasyonSilUseCase rezervasyonSilUseCase,
    required SalonBolumleriniGetirUseCase salonBolumleriniGetirUseCase,
    RezervasyonMasaAtamaServisi? masaAtamaServisi,
  }) : _rezervasyonlariGetirUseCase = rezervasyonlariGetirUseCase,
       _rezervasyonEkleUseCase = rezervasyonEkleUseCase,
       _rezervasyonDurumuGuncelleUseCase = rezervasyonDurumuGuncelleUseCase,
       _rezervasyonSilUseCase = rezervasyonSilUseCase,
       _salonBolumleriniGetirUseCase = salonBolumleriniGetirUseCase,
       _masaAtamaServisi =
           masaAtamaServisi ?? const RezervasyonMasaAtamaServisi();

  factory RezervasyonViewModel.servisKaydindan(ServisKaydi servisKaydi) {
    return RezervasyonViewModel(
      rezervasyonlariGetirUseCase: servisKaydi.rezervasyonlariGetirUseCase,
      rezervasyonEkleUseCase: servisKaydi.rezervasyonEkleUseCase,
      rezervasyonDurumuGuncelleUseCase:
          servisKaydi.rezervasyonDurumuGuncelleUseCase,
      rezervasyonSilUseCase: servisKaydi.rezervasyonSilUseCase,
      salonBolumleriniGetirUseCase: servisKaydi.salonBolumleriniGetirUseCase,
    );
  }

  final RezervasyonlariGetirUseCase _rezervasyonlariGetirUseCase;
  final RezervasyonEkleUseCase _rezervasyonEkleUseCase;
  final RezervasyonDurumuGuncelleUseCase _rezervasyonDurumuGuncelleUseCase;
  final RezervasyonSilUseCase _rezervasyonSilUseCase;
  final SalonBolumleriniGetirUseCase _salonBolumleriniGetirUseCase;
  final RezervasyonMasaAtamaServisi _masaAtamaServisi;

  bool _yukleniyor = true;
  DateTime _seciliGun = _gunBaslangici(DateTime.now());
  RezervasyonDurumFiltresi _seciliDurumFiltresi = RezervasyonDurumFiltresi.tumu;
  List<RezervasyonVarligi> _rezervasyonlar = const <RezervasyonVarligi>[];
  List<SalonBolumuVarligi> _salonBolumleri = const <SalonBolumuVarligi>[];

  bool get yukleniyor => _yukleniyor;
  DateTime get seciliGun => _seciliGun;
  RezervasyonDurumFiltresi get seciliDurumFiltresi => _seciliDurumFiltresi;
  List<SalonBolumuVarligi> get salonBolumleri =>
      List<SalonBolumuVarligi>.unmodifiable(_salonBolumleri);

  int get toplamRezervasyonSayisi => _rezervasyonlar.length;
  int get aktifRezervasyonSayisi =>
      _rezervasyonlar.where((rezervasyon) => rezervasyon.durum.aktifMi).length;
  int get noShowSayisi => _rezervasyonlar
      .where((rezervasyon) => rezervasyon.durum == RezervasyonDurumu.noShow)
      .length;

  List<RezervasyonVarligi> get filtrelenmisRezervasyonlar {
    final Iterable<RezervasyonVarligi> filtreli = _rezervasyonlar.where((
      kayit,
    ) {
      switch (_seciliDurumFiltresi) {
        case RezervasyonDurumFiltresi.tumu:
          return true;
        case RezervasyonDurumFiltresi.aktif:
          return kayit.durum.aktifMi;
        case RezervasyonDurumFiltresi.noShow:
          return kayit.durum == RezervasyonDurumu.noShow;
        case RezervasyonDurumFiltresi.tamamlandi:
          return kayit.durum == RezervasyonDurumu.tamamlandi;
        case RezervasyonDurumFiltresi.iptalEdildi:
          return kayit.durum == RezervasyonDurumu.iptalEdildi;
      }
    });
    final List<RezervasyonVarligi> sirali = filtreli.toList()
      ..sort((a, b) => a.baslangicZamani.compareTo(b.baslangicZamani));
    return sirali;
  }

  Future<RezervasyonIslemSonucu> yukle({DateTime? gun}) async {
    _yukleniyor = true;
    if (gun != null) {
      _seciliGun = _gunBaslangici(gun);
    }
    notifyListeners();
    try {
      final List<RezervasyonVarligi> rezervasyonlar =
          await _rezervasyonlariGetirUseCase(gun: _seciliGun);
      final List<SalonBolumuVarligi> bolumler =
          await _salonBolumleriniGetirUseCase();
      _rezervasyonlar = rezervasyonlar;
      _salonBolumleri = bolumler;
      _yukleniyor = false;
      notifyListeners();
      return const RezervasyonIslemSonucu.basarili();
    } catch (_) {
      _yukleniyor = false;
      notifyListeners();
      return const RezervasyonIslemSonucu.hata(
        'Rezervasyon verileri yuklenemedi.',
      );
    }
  }

  Future<RezervasyonIslemSonucu> rezervasyonOlustur(
    RezervasyonOlusturmaGirdisi girdi,
  ) async {
    try {
      final DateTime baslangic = girdi.baslangicZamani;
      final DateTime bitis = baslangic.add(Duration(minutes: girdi.sureDakika));
      final List<RezervasyonVarligi> ayniGunRezervasyonlari =
          await _rezervasyonlariGetirUseCase(gun: baslangic);
      final RezervasyonMasaAtamaSonucu? atama = _masaAtamaServisi.uygunMasaBul(
        kisiSayisi: girdi.kisiSayisi,
        baslangicZamani: baslangic,
        bitisZamani: bitis,
        salonBolumleri: _salonBolumleri,
        mevcutRezervasyonlar: ayniGunRezervasyonlari,
        tercihBolumId: girdi.tercihBolumId,
      );
      final RezervasyonVarligi rezervasyon = RezervasyonVarligi(
        id: 'rez_${DateTime.now().microsecondsSinceEpoch}',
        musteriAdi: girdi.musteriAdi.trim(),
        telefon: girdi.telefon.trim(),
        kisiSayisi: girdi.kisiSayisi,
        baslangicZamani: baslangic,
        bitisZamani: bitis,
        durum: atama == null
            ? RezervasyonDurumu.beklemede
            : RezervasyonDurumu.onaylandi,
        olusturmaZamani: DateTime.now(),
        bolumId: atama?.bolumId,
        bolumAdi: atama?.bolumAdi,
        masaId: atama?.masaId,
        masaAdi: atama?.masaAdi,
        notMetni: girdi.notMetni.trim(),
      );
      await _rezervasyonEkleUseCase(rezervasyon);
      await yukle(gun: baslangic);
      return RezervasyonIslemSonucu.basarili(
        atama == null
            ? 'Rezervasyon eklendi. Uygun masa bulunamadigi icin beklemeye alindi.'
            : 'Rezervasyon eklendi ve ${atama.bolumAdi} / Masa ${atama.masaAdi} atandi.',
      );
    } catch (_) {
      return const RezervasyonIslemSonucu.hata(
        'Rezervasyon kaydedilemedi. Alanlari kontrol edip tekrar dene.',
      );
    }
  }

  Future<RezervasyonIslemSonucu> durumIlerle(
    RezervasyonVarligi rezervasyon,
  ) async {
    final RezervasyonDurumu? sonrakiDurum = _sonrakiDurum(rezervasyon.durum);
    if (sonrakiDurum == null) {
      return const RezervasyonIslemSonucu.hata(
        'Bu rezervasyon icin ileri durum bulunmuyor.',
      );
    }
    return durumDegistir(rezervasyon: rezervasyon, yeniDurum: sonrakiDurum);
  }

  Future<RezervasyonIslemSonucu> durumDegistir({
    required RezervasyonVarligi rezervasyon,
    required RezervasyonDurumu yeniDurum,
  }) async {
    try {
      await _rezervasyonDurumuGuncelleUseCase(
        rezervasyonId: rezervasyon.id,
        durum: yeniDurum,
      );
      await yukle(gun: _seciliGun);
      return RezervasyonIslemSonucu.basarili(
        'Durum ${yeniDurum.etiket.toLowerCase()} olarak guncellendi.',
      );
    } catch (_) {
      return const RezervasyonIslemSonucu.hata('Durum guncellenemedi.');
    }
  }

  Future<RezervasyonIslemSonucu> rezervasyonSil(
    RezervasyonVarligi rezervasyon,
  ) async {
    try {
      await _rezervasyonSilUseCase(rezervasyon.id);
      await yukle(gun: _seciliGun);
      return const RezervasyonIslemSonucu.basarili('Rezervasyon silindi.');
    } catch (_) {
      return const RezervasyonIslemSonucu.hata('Rezervasyon silinemedi.');
    }
  }

  Future<void> sonrakiGuneGit() async {
    await yukle(gun: _seciliGun.add(const Duration(days: 1)));
  }

  Future<void> oncekiGuneGit() async {
    await yukle(gun: _seciliGun.subtract(const Duration(days: 1)));
  }

  void durumFiltresiSec(RezervasyonDurumFiltresi filtre) {
    if (_seciliDurumFiltresi == filtre) {
      return;
    }
    _seciliDurumFiltresi = filtre;
    notifyListeners();
  }

  RezervasyonDurumu? _sonrakiDurum(RezervasyonDurumu durum) {
    switch (durum) {
      case RezervasyonDurumu.beklemede:
        return RezervasyonDurumu.onaylandi;
      case RezervasyonDurumu.onaylandi:
        return RezervasyonDurumu.geldi;
      case RezervasyonDurumu.geldi:
        return RezervasyonDurumu.tamamlandi;
      case RezervasyonDurumu.tamamlandi:
      case RezervasyonDurumu.noShow:
      case RezervasyonDurumu.iptalEdildi:
        return null;
    }
  }

  static DateTime _gunBaslangici(DateTime tarih) {
    return DateTime(tarih.year, tarih.month, tarih.day);
  }
}
