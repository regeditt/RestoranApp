import 'package:flutter/foundation.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/islem_yetkisi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/servisler/siparis_operasyon_akisi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparis_durumu_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparisleri_getir_use_case.dart';

enum OnlineSiparisDurumFiltresi {
  tumu('Tumu'),
  yeni('Yeni'),
  hazirlaniyor('Hazirlaniyor'),
  hazir('Hazir'),
  yolda('Yolda'),
  tamamlanan('Tamamlanan');

  const OnlineSiparisDurumFiltresi(this.etiket);

  final String etiket;
}

class OnlineKanalOzetiVarligi {
  const OnlineKanalOzetiVarligi({
    required this.kanal,
    required this.adet,
    required this.aktifAdet,
    required this.toplamTutar,
  });

  final String kanal;
  final int adet;
  final int aktifAdet;
  final double toplamTutar;
}

class OnlineSiparisKanaliIslemSonucu {
  const OnlineSiparisKanaliIslemSonucu.basarili([this.mesaj = ''])
    : basarili = true;

  const OnlineSiparisKanaliIslemSonucu.hata(this.mesaj) : basarili = false;

  final bool basarili;
  final String mesaj;
}

class OnlineSiparisKanaliViewModel extends ChangeNotifier {
  static const int _aktifOnlineYogunlukEsigi = 8;
  static const int _aktifPaketYogunlukEsigi = 5;

  OnlineSiparisKanaliViewModel({
    required SiparisleriGetirUseCase siparisleriGetirUseCase,
    required SiparisDurumuGuncelleUseCase siparisDurumuGuncelleUseCase,
    Future<bool> Function(IslemYetkisi yetki)? islemYetkisiSorgula,
  }) : _siparisleriGetirUseCase = siparisleriGetirUseCase,
       _siparisDurumuGuncelleUseCase = siparisDurumuGuncelleUseCase,
       _islemYetkisiSorgula = islemYetkisiSorgula;

  factory OnlineSiparisKanaliViewModel.servisKaydindan(
    ServisKaydi servisKaydi,
  ) {
    return OnlineSiparisKanaliViewModel(
      siparisleriGetirUseCase: servisKaydi.siparisleriGetirUseCase,
      siparisDurumuGuncelleUseCase: servisKaydi.siparisDurumuGuncelleUseCase,
      islemYetkisiSorgula: servisKaydi.islemYetkisiVarMi,
    );
  }

  final SiparisleriGetirUseCase _siparisleriGetirUseCase;
  final SiparisDurumuGuncelleUseCase _siparisDurumuGuncelleUseCase;
  final Future<bool> Function(IslemYetkisi yetki)? _islemYetkisiSorgula;

  bool _yukleniyor = true;
  bool _durumIlerletmeYetkisiVar = true;
  String _seciliKanal = 'Tumu';
  OnlineSiparisDurumFiltresi _seciliDurumFiltresi =
      OnlineSiparisDurumFiltresi.tumu;
  List<SiparisVarligi> _tumOnlineSiparisler = const <SiparisVarligi>[];

  bool get yukleniyor => _yukleniyor;
  bool get durumIlerletmeYetkisiVar => _durumIlerletmeYetkisiVar;
  String get seciliKanal => _seciliKanal;
  OnlineSiparisDurumFiltresi get seciliDurumFiltresi => _seciliDurumFiltresi;

  List<String> get kanalFiltreleri {
    final Set<String> kanallar = <String>{'Tumu'};
    for (final SiparisVarligi siparis in _tumOnlineSiparisler) {
      kanallar.add(kanalEtiketi(siparis));
    }
    final List<String> sonuc = kanallar.toList()..sort();
    sonuc.remove('Tumu');
    return <String>['Tumu', ...sonuc];
  }

  List<SiparisVarligi> get filtrelenmisSiparisler {
    final List<SiparisVarligi> sonuc = _tumOnlineSiparisler.where((
      SiparisVarligi siparis,
    ) {
      if (_seciliKanal != 'Tumu' && kanalEtiketi(siparis) != _seciliKanal) {
        return false;
      }
      return _durumFiltresineUygunMu(siparis);
    }).toList();
    sonuc.sort((a, b) => b.olusturmaTarihi.compareTo(a.olusturmaTarihi));
    return sonuc;
  }

  int get toplamOnlineSiparisSayisi => _tumOnlineSiparisler.length;

  int get aktifOnlineSiparisSayisi =>
      _tumOnlineSiparisler.where((SiparisVarligi siparis) {
        return siparis.durum != SiparisDurumu.teslimEdildi &&
            siparis.durum != SiparisDurumu.iptalEdildi;
      }).length;

  int get aktifPaketSiparisSayisi =>
      _tumOnlineSiparisler.where((SiparisVarligi siparis) {
        return siparis.teslimatTipi == TeslimatTipi.paketServis &&
            siparis.durum != SiparisDurumu.teslimEdildi &&
            siparis.durum != SiparisDurumu.iptalEdildi;
      }).length;

  bool get yogunlukModuOnerisiVar =>
      aktifOnlineSiparisSayisi >= _aktifOnlineYogunlukEsigi ||
      aktifPaketSiparisSayisi >= _aktifPaketYogunlukEsigi;

  String get yogunlukMesaji {
    if (!yogunlukModuOnerisiVar) {
      return '';
    }
    return 'Aktif siparis yuksek. Yeni siparis kabul hizini azalt, '
        'hazirlama suresini arttir veya gecici olarak kanal pausela.';
  }

  double get toplamOnlineCiro => _tumOnlineSiparisler.fold<double>(
    0,
    (double toplam, SiparisVarligi siparis) => toplam + siparis.toplamTutar,
  );

  List<OnlineKanalOzetiVarligi> get kanalOzetleri {
    final Map<String, List<SiparisVarligi>> gruplar =
        <String, List<SiparisVarligi>>{};
    for (final SiparisVarligi siparis in _tumOnlineSiparisler) {
      final String kanal = kanalEtiketi(siparis);
      gruplar.putIfAbsent(kanal, () => <SiparisVarligi>[]).add(siparis);
    }
    final List<OnlineKanalOzetiVarligi> sonuc = gruplar.entries.map((
      MapEntry<String, List<SiparisVarligi>> kayit,
    ) {
      final List<SiparisVarligi> siparisler = kayit.value;
      final int aktif = siparisler.where((SiparisVarligi siparis) {
        return siparis.durum != SiparisDurumu.teslimEdildi &&
            siparis.durum != SiparisDurumu.iptalEdildi;
      }).length;
      final double toplam = siparisler.fold<double>(
        0,
        (double onceki, SiparisVarligi siparis) => onceki + siparis.toplamTutar,
      );
      return OnlineKanalOzetiVarligi(
        kanal: kayit.key,
        adet: siparisler.length,
        aktifAdet: aktif,
        toplamTutar: toplam,
      );
    }).toList();
    sonuc.sort((a, b) => b.adet.compareTo(a.adet));
    return sonuc;
  }

  Future<OnlineSiparisKanaliIslemSonucu> yukle() async {
    _yukleniyor = true;
    notifyListeners();
    try {
      final Future<bool> Function(IslemYetkisi yetki)? islemYetkisiSorgula =
          _islemYetkisiSorgula;
      if (islemYetkisiSorgula != null) {
        _durumIlerletmeYetkisiVar = await islemYetkisiSorgula(
          IslemYetkisi.siparisDurumuIlerle,
        );
      }
      final List<SiparisVarligi> tumSiparisler =
          await _siparisleriGetirUseCase();
      _tumOnlineSiparisler = tumSiparisler
          .where(_onlineSiparisMi)
          .toList(growable: false);
      _yukleniyor = false;
      notifyListeners();
      return const OnlineSiparisKanaliIslemSonucu.basarili();
    } catch (_) {
      _yukleniyor = false;
      notifyListeners();
      return const OnlineSiparisKanaliIslemSonucu.hata(
        'Online siparis verileri yuklenemedi.',
      );
    }
  }

  Future<OnlineSiparisKanaliIslemSonucu> durumIlerle(
    SiparisVarligi siparis,
  ) async {
    if (!_durumIlerletmeYetkisiVar) {
      return const OnlineSiparisKanaliIslemSonucu.hata(
        'Siparis durumunu ilerletme yetkin bulunmuyor.',
      );
    }
    final SiparisDurumu? sonrakiDurum = SiparisOperasyonAkisi.sonrakiDurum(
      siparis,
    );
    if (sonrakiDurum == null) {
      return const OnlineSiparisKanaliIslemSonucu.hata(
        'Bu siparisin bir sonraki adimi yok.',
      );
    }
    try {
      await _siparisDurumuGuncelleUseCase(siparis.id, sonrakiDurum);
      final OnlineSiparisKanaliIslemSonucu sonuc = await yukle();
      if (!sonuc.basarili) {
        return sonuc;
      }
      return OnlineSiparisKanaliIslemSonucu.basarili(
        '${siparis.siparisNo} ${durumEtiketi(sonrakiDurum).toLowerCase()} durumuna alindi.',
      );
    } catch (hata) {
      return OnlineSiparisKanaliIslemSonucu.hata(
        _hataMesajiniCoz(hata, varsayilan: 'Siparis durumu guncellenemedi.'),
      );
    }
  }

  void kanalSec(String kanal) {
    if (_seciliKanal == kanal) {
      return;
    }
    _seciliKanal = kanal;
    notifyListeners();
  }

  void durumFiltresiSec(OnlineSiparisDurumFiltresi filtre) {
    if (_seciliDurumFiltresi == filtre) {
      return;
    }
    _seciliDurumFiltresi = filtre;
    notifyListeners();
  }

  String kanalEtiketi(SiparisVarligi siparis) {
    final String hamKaynak = (siparis.kaynak ?? '').trim();
    if (hamKaynak.isEmpty) {
      return siparis.teslimatTipi == TeslimatTipi.paketServis
          ? 'Telefon/Paket'
          : 'Diger';
    }
    final String kucuk = hamKaynak.toLowerCase();
    if (kucuk.contains('yemek')) {
      return 'Yemeksepeti';
    }
    if (kucuk.contains('getir')) {
      return 'Getir';
    }
    if (kucuk.contains('trendyol')) {
      return 'Trendyol';
    }
    if (kucuk.contains('qr')) {
      return 'QR';
    }
    return _kelimeBaslariniBuyut(hamKaynak);
  }

  String durumEtiketi(SiparisDurumu durum) {
    switch (durum) {
      case SiparisDurumu.alindi:
        return 'Yeni';
      case SiparisDurumu.hazirlaniyor:
        return 'Hazirlaniyor';
      case SiparisDurumu.hazir:
        return 'Hazir';
      case SiparisDurumu.yolda:
        return 'Yolda';
      case SiparisDurumu.teslimEdildi:
        return 'Teslim edildi';
      case SiparisDurumu.iptalEdildi:
        return 'Iptal edildi';
    }
  }

  String? aksiyonEtiketi(SiparisVarligi siparis) {
    switch (siparis.durum) {
      case SiparisDurumu.alindi:
        return 'Hazirlamaya al';
      case SiparisDurumu.hazirlaniyor:
        return 'Hazir oldu';
      case SiparisDurumu.hazir:
        return siparis.teslimatTipi == TeslimatTipi.paketServis
            ? 'Yola cikar'
            : 'Teslim edildi';
      case SiparisDurumu.yolda:
        return 'Teslim edildi';
      case SiparisDurumu.teslimEdildi:
      case SiparisDurumu.iptalEdildi:
        return null;
    }
  }

  bool _onlineSiparisMi(SiparisVarligi siparis) {
    final bool kaynakVar = (siparis.kaynak ?? '').trim().isNotEmpty;
    return kaynakVar || siparis.teslimatTipi == TeslimatTipi.paketServis;
  }

  bool _durumFiltresineUygunMu(SiparisVarligi siparis) {
    switch (_seciliDurumFiltresi) {
      case OnlineSiparisDurumFiltresi.tumu:
        return true;
      case OnlineSiparisDurumFiltresi.yeni:
        return siparis.durum == SiparisDurumu.alindi;
      case OnlineSiparisDurumFiltresi.hazirlaniyor:
        return siparis.durum == SiparisDurumu.hazirlaniyor;
      case OnlineSiparisDurumFiltresi.hazir:
        return siparis.durum == SiparisDurumu.hazir;
      case OnlineSiparisDurumFiltresi.yolda:
        return siparis.durum == SiparisDurumu.yolda;
      case OnlineSiparisDurumFiltresi.tamamlanan:
        return siparis.durum == SiparisDurumu.teslimEdildi;
    }
  }

  String _kelimeBaslariniBuyut(String metin) {
    final List<String> parcalar = metin.trim().split(RegExp(r'\s+'));
    return parcalar
        .where((String parca) => parca.isNotEmpty)
        .map((String parca) {
          if (parca.length == 1) {
            return parca.toUpperCase();
          }
          return parca[0].toUpperCase() + parca.substring(1).toLowerCase();
        })
        .join(' ');
  }

  String _hataMesajiniCoz(Object hata, {required String varsayilan}) {
    if (hata is StateError) {
      final String mesaj = hata.message;
      if (mesaj.trim().isNotEmpty) {
        return mesaj;
      }
    }
    return varsayilan;
  }
}
