import 'package:flutter/foundation.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparis_durumu_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparisleri_getir_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_is_kuyrugu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/servisler/yazici_is_kuyrugu_hesaplayici.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/use_case/yazicilari_getir_use_case.dart';

enum TeslimatFiltresi {
  tumu('Tum', null),
  salon('Salon', TeslimatTipi.restorandaYe),
  gelAl('Gel al', TeslimatTipi.gelAl),
  paket('Paket', TeslimatTipi.paketServis);

  const TeslimatFiltresi(this.etiket, this.teslimatTipi);

  final String etiket;
  final TeslimatTipi? teslimatTipi;
}

class MutfakSiparisIslemSonucu {
  const MutfakSiparisIslemSonucu.basarili([this.mesaj = '']) : basarili = true;

  const MutfakSiparisIslemSonucu.hata(this.mesaj) : basarili = false;

  final bool basarili;
  final String mesaj;
}

class MutfakSiparisViewModel extends ChangeNotifier {
  MutfakSiparisViewModel({
    required SiparisleriGetirUseCase siparisleriGetirUseCase,
    required YazicilariGetirUseCase yazicilariGetirUseCase,
    required SiparisDurumuGuncelleUseCase siparisDurumuGuncelleUseCase,
  }) : _siparisleriGetirUseCase = siparisleriGetirUseCase,
       _yazicilariGetirUseCase = yazicilariGetirUseCase,
       _siparisDurumuGuncelleUseCase = siparisDurumuGuncelleUseCase;

  factory MutfakSiparisViewModel.servisKaydindan(ServisKaydi servisKaydi) {
    return MutfakSiparisViewModel(
      siparisleriGetirUseCase: servisKaydi.siparisleriGetirUseCase,
      yazicilariGetirUseCase: servisKaydi.yazicilariGetirUseCase,
      siparisDurumuGuncelleUseCase: servisKaydi.siparisDurumuGuncelleUseCase,
    );
  }

  final SiparisleriGetirUseCase _siparisleriGetirUseCase;
  final YazicilariGetirUseCase _yazicilariGetirUseCase;
  final SiparisDurumuGuncelleUseCase _siparisDurumuGuncelleUseCase;

  bool _yukleniyor = true;
  List<SiparisVarligi> _siparisler = const <SiparisVarligi>[];
  List<YaziciDurumuVarligi> _yazicilar = const <YaziciDurumuVarligi>[];
  TeslimatFiltresi _seciliFiltre = TeslimatFiltresi.tumu;

  bool get yukleniyor => _yukleniyor;
  List<SiparisVarligi> get siparisler => _siparisler;
  List<YaziciDurumuVarligi> get yazicilar => _yazicilar;
  TeslimatFiltresi get seciliFiltre => _seciliFiltre;

  List<SiparisVarligi> get filtrelenmisSiparisler {
    if (_seciliFiltre == TeslimatFiltresi.tumu) {
      return _siparisler;
    }

    return _siparisler
        .where(
          (SiparisVarligi siparis) =>
              siparis.teslimatTipi == _seciliFiltre.teslimatTipi,
        )
        .toList();
  }

  List<SiparisVarligi> get yeniSiparisler => _grupSiparisleri(
    filtrelenmisSiparisler,
    const <SiparisDurumu>[SiparisDurumu.alindi],
  );

  List<SiparisVarligi> get hazirlananlar => _grupSiparisleri(
    filtrelenmisSiparisler,
    const <SiparisDurumu>[SiparisDurumu.hazirlaniyor],
  );

  List<SiparisVarligi> get hazirlar => _grupSiparisleri(
    filtrelenmisSiparisler,
    const <SiparisDurumu>[SiparisDurumu.hazir],
  );

  List<SiparisVarligi> get kapanisAkisi => _grupSiparisleri(
    filtrelenmisSiparisler,
    const <SiparisDurumu>[SiparisDurumu.yolda, SiparisDurumu.teslimEdildi],
  );

  List<SiparisVarligi> get aktifSiparisler => filtrelenmisSiparisler
      .where(
        (SiparisVarligi siparis) =>
            siparis.durum != SiparisDurumu.teslimEdildi &&
            siparis.durum != SiparisDurumu.iptalEdildi,
      )
      .toList();

  List<YaziciIsKuyruguVarligi> get yaziciKuyrugu =>
      YaziciIsKuyruguHesaplayici.kuyruguHazirla(_siparisler);

  void filtreSec(TeslimatFiltresi filtre) {
    if (_seciliFiltre == filtre) {
      return;
    }
    _seciliFiltre = filtre;
    notifyListeners();
  }

  Future<MutfakSiparisIslemSonucu> yukle() async {
    _yukleniyor = true;
    notifyListeners();
    try {
      final List<SiparisVarligi> siparisler = await _siparisleriGetirUseCase();
      final List<YaziciDurumuVarligi> yazicilar =
          await _yazicilariGetirUseCase();
      _siparisler = siparisler;
      _yazicilar = yazicilar;
      _yukleniyor = false;
      notifyListeners();
      return const MutfakSiparisIslemSonucu.basarili();
    } catch (_) {
      _yukleniyor = false;
      notifyListeners();
      return const MutfakSiparisIslemSonucu.hata(
        'Mutfak siparis verileri yuklenemedi',
      );
    }
  }

  Future<MutfakSiparisIslemSonucu> durumIlerle(SiparisVarligi siparis) async {
    final SiparisDurumu? sonrakiDurum = _sonrakiDurum(siparis);
    if (sonrakiDurum == null) {
      return const MutfakSiparisIslemSonucu.hata(
        'Bu siparisin durumu ilerletilemez',
      );
    }

    try {
      await _siparisDurumuGuncelleUseCase(siparis.id, sonrakiDurum);
      final MutfakSiparisIslemSonucu yenileSonucu = await yukle();
      if (!yenileSonucu.basarili) {
        return yenileSonucu;
      }
      return MutfakSiparisIslemSonucu.basarili(
        '${siparis.siparisNo} ${_durumEtiketi(sonrakiDurum).toLowerCase()} durumuna alindi. '
        '${_durumYaziciMesaji(siparis, sonrakiDurum)}',
      );
    } catch (_) {
      return const MutfakSiparisIslemSonucu.hata(
        'Siparis durumu guncellenemedi',
      );
    }
  }

  Future<MutfakSiparisIslemSonucu> siparisiIptalEt(
    SiparisVarligi siparis,
  ) async {
    try {
      await _siparisDurumuGuncelleUseCase(
        siparis.id,
        SiparisDurumu.iptalEdildi,
      );
      final MutfakSiparisIslemSonucu yenileSonucu = await yukle();
      if (!yenileSonucu.basarili) {
        return yenileSonucu;
      }
      return MutfakSiparisIslemSonucu.basarili(
        '${siparis.siparisNo} iptal edildi ve operasyon listesinden dusuruldu.',
      );
    } catch (_) {
      return const MutfakSiparisIslemSonucu.hata('Siparis iptal edilemedi');
    }
  }

  List<SiparisVarligi> _grupSiparisleri(
    List<SiparisVarligi> kaynak,
    List<SiparisDurumu> durumlar,
  ) {
    return kaynak
        .where((SiparisVarligi siparis) => durumlar.contains(siparis.durum))
        .toList()
      ..sort(
        (SiparisVarligi a, SiparisVarligi b) =>
            a.olusturmaTarihi.compareTo(b.olusturmaTarihi),
      );
  }

  SiparisDurumu? _sonrakiDurum(SiparisVarligi siparis) {
    switch (siparis.durum) {
      case SiparisDurumu.alindi:
        return SiparisDurumu.hazirlaniyor;
      case SiparisDurumu.hazirlaniyor:
        return SiparisDurumu.hazir;
      case SiparisDurumu.hazir:
        return siparis.teslimatTipi == TeslimatTipi.paketServis
            ? SiparisDurumu.yolda
            : SiparisDurumu.teslimEdildi;
      case SiparisDurumu.yolda:
        return SiparisDurumu.teslimEdildi;
      case SiparisDurumu.teslimEdildi:
      case SiparisDurumu.iptalEdildi:
        return null;
    }
  }

  String _durumYaziciMesaji(
    SiparisVarligi siparis,
    SiparisDurumu sonrakiDurum,
  ) {
    final String hat = _yaziciHattiEtiketi(siparis);
    switch (sonrakiDurum) {
      case SiparisDurumu.hazirlaniyor:
        return '$hat hatti aktif kuyrukta guncellendi';
      case SiparisDurumu.hazir:
        return '$hat hattina hazir bildirimi yansidi';
      case SiparisDurumu.yolda:
        return 'Kasa ve paket hattina teslim cikisi aktarildi';
      case SiparisDurumu.teslimEdildi:
        return 'Yazici kuyrugunda siparis kapanisa alindi';
      case SiparisDurumu.alindi:
      case SiparisDurumu.iptalEdildi:
        return '$hat hatti ile senkron tamamlandi';
    }
  }
}

String _durumEtiketi(SiparisDurumu durum) {
  switch (durum) {
    case SiparisDurumu.alindi:
      return 'Alindi';
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

String _yaziciHattiEtiketi(SiparisVarligi siparis) {
  switch (siparis.teslimatTipi) {
    case TeslimatTipi.restorandaYe:
      return 'Mutfak';
    case TeslimatTipi.gelAl:
      return 'Kasa';
    case TeslimatTipi.paketServis:
      return 'Icecek';
  }
}
