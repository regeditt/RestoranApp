import 'package:flutter/foundation.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/alan/enumlar/odeme_yontemi.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/alan/varliklar/kasa_hareketi_varligi.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/alan/varliklar/kasa_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/alan/varliklar/siparis_ciro_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/uygulama/use_case/kasa_hareketi_ekle_use_case.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/uygulama/use_case/kasa_ozeti_getir_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparisleri_getir_use_case.dart';

class OdemeKasaIslemSonucu {
  const OdemeKasaIslemSonucu.basarili([this.mesaj = '']) : basarili = true;

  const OdemeKasaIslemSonucu.hata(this.mesaj) : basarili = false;

  final bool basarili;
  final String mesaj;
}

class KasaHareketiEkleGirdisi {
  const KasaHareketiEkleGirdisi({
    required this.baslik,
    required this.detay,
    required this.tutar,
    required this.odemeYontemi,
    required this.tahsilatMi,
    required this.parcaSayisi,
  });

  final String baslik;
  final String detay;
  final double tutar;
  final OdemeYontemi odemeYontemi;
  final bool tahsilatMi;
  final int parcaSayisi;
}

class OdemeKasaViewModel extends ChangeNotifier {
  OdemeKasaViewModel({
    required KasaOzetiGetirUseCase kasaOzetiGetirUseCase,
    required KasaHareketiEkleUseCase kasaHareketiEkleUseCase,
    required SiparisleriGetirUseCase siparisleriGetirUseCase,
  }) : _kasaOzetiGetirUseCase = kasaOzetiGetirUseCase,
       _kasaHareketiEkleUseCase = kasaHareketiEkleUseCase,
       _siparisleriGetirUseCase = siparisleriGetirUseCase;

  factory OdemeKasaViewModel.servisKaydindan(ServisKaydi servisKaydi) {
    return OdemeKasaViewModel(
      kasaOzetiGetirUseCase: servisKaydi.kasaOzetiGetirUseCase,
      kasaHareketiEkleUseCase: servisKaydi.kasaHareketiEkleUseCase,
      siparisleriGetirUseCase: servisKaydi.siparisleriGetirUseCase,
    );
  }

  final KasaOzetiGetirUseCase _kasaOzetiGetirUseCase;
  final KasaHareketiEkleUseCase _kasaHareketiEkleUseCase;
  final SiparisleriGetirUseCase _siparisleriGetirUseCase;

  bool _yukleniyor = true;
  KasaOzetiVarligi? _kasaOzeti;
  SiparisCiroOzetiVarligi _siparisCiroOzeti = SiparisCiroOzetiVarligi.bos;
  DateTime _baslangicTarihi = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime _bitisTarihi = DateTime.now();

  bool get yukleniyor => _yukleniyor;
  KasaOzetiVarligi? get kasaOzeti => _kasaOzeti;
  SiparisCiroOzetiVarligi get siparisCiroOzeti => _siparisCiroOzeti;
  DateTime get baslangicTarihi => _baslangicTarihi;
  DateTime get bitisTarihi => _bitisTarihi;

  Future<OdemeKasaIslemSonucu> yukle() async {
    _yukleniyor = true;
    notifyListeners();
    try {
      _kasaOzeti = await _kasaOzetiGetirUseCase(
        baslangicTarihi: _baslangicTarihi,
        bitisTarihi: _bitisTarihi,
      );
      final List<SiparisVarligi> tumSiparisler =
          await _siparisleriGetirUseCase();
      final List<SiparisVarligi> filtreliSiparisler = tumSiparisler.where((
        SiparisVarligi siparis,
      ) {
        if (siparis.olusturmaTarihi.isBefore(_baslangicTarihi)) {
          return false;
        }
        if (siparis.olusturmaTarihi.isAfter(_bitisTarihi)) {
          return false;
        }
        return true;
      }).toList();
      final double brutCiro = filtreliSiparisler.fold<double>(
        0,
        (double toplam, SiparisVarligi siparis) => toplam + siparis.araToplam,
      );
      final double indirimToplami = filtreliSiparisler.fold<double>(
        0,
        (double toplam, SiparisVarligi siparis) =>
            toplam + siparis.indirimTutari,
      );
      final double netCiro = filtreliSiparisler.fold<double>(
        0,
        (double toplam, SiparisVarligi siparis) => toplam + siparis.toplamTutar,
      );
      _siparisCiroOzeti = SiparisCiroOzetiVarligi(
        siparisAdedi: filtreliSiparisler.length,
        brutCiro: brutCiro,
        indirimToplami: indirimToplami,
        netCiro: netCiro,
      );
      _yukleniyor = false;
      notifyListeners();
      return const OdemeKasaIslemSonucu.basarili();
    } catch (_) {
      _siparisCiroOzeti = SiparisCiroOzetiVarligi.bos;
      _yukleniyor = false;
      notifyListeners();
      return const OdemeKasaIslemSonucu.hata(
        'Odeme ve kasa verileri yuklenemedi.',
      );
    }
  }

  Future<OdemeKasaIslemSonucu> bugunFiltrele() {
    final DateTime simdi = DateTime.now();
    _baslangicTarihi = DateTime(simdi.year, simdi.month, simdi.day);
    _bitisTarihi = simdi;
    return yukle();
  }

  Future<OdemeKasaIslemSonucu> sonYediGunFiltrele() {
    final DateTime simdi = DateTime.now();
    _baslangicTarihi = simdi.subtract(const Duration(days: 7));
    _bitisTarihi = simdi;
    return yukle();
  }

  Future<OdemeKasaIslemSonucu> hareketEkle(
    KasaHareketiEkleGirdisi girdi,
  ) async {
    final String baslik = girdi.baslik.trim();
    final String detay = girdi.detay.trim();
    final int parcaSayisi = girdi.parcaSayisi.clamp(1, 10);
    if (baslik.isEmpty || detay.isEmpty || girdi.tutar <= 0) {
      return const OdemeKasaIslemSonucu.hata(
        'Baslik, detay ve tutar alanlarini gecerli doldurmalisin.',
      );
    }
    try {
      final double bolunenTutar = girdi.tutar / parcaSayisi;
      double kalan = girdi.tutar;
      for (int i = 1; i <= parcaSayisi; i++) {
        final bool sonParca = i == parcaSayisi;
        final double parcaTutari = sonParca ? kalan : bolunenTutar;
        kalan -= parcaTutari;
        final String parcaEtiketi = parcaSayisi == 1
            ? ''
            : ' ($i/$parcaSayisi)';
        final KasaHareketiVarligi hareket = KasaHareketiVarligi(
          id: 'ksh_${DateTime.now().microsecondsSinceEpoch}_$i',
          zaman: DateTime.now(),
          baslik: '$baslik$parcaEtiketi',
          detay: detay,
          tutar: double.parse(parcaTutari.toStringAsFixed(2)),
          odemeYontemi: girdi.odemeYontemi,
          tahsilatMi: girdi.tahsilatMi,
        );
        await _kasaHareketiEkleUseCase(hareket);
      }
      await yukle();
      return OdemeKasaIslemSonucu.basarili(
        parcaSayisi == 1
            ? 'Kasa hareketi eklendi.'
            : 'Parcali odeme kaydi $parcaSayisi hareket olarak eklendi.',
      );
    } catch (_) {
      return const OdemeKasaIslemSonucu.hata(
        'Kasa hareketi eklenemedi. Alanlari kontrol edip tekrar dene.',
      );
    }
  }
}
