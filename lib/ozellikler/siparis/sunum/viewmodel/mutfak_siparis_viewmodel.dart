import 'package:flutter/foundation.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/islem_yetkisi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/servisler/siparis_operasyon_akisi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_entegrasyon_yonetim_servisi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_konum_takip_servisi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_takip_senkronlayici.dart';
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

/// Mutfak ekranindaki siparis aksiyonlarinin sonucunu UI katmanina tasir.
class MutfakSiparisIslemSonucu {
  const MutfakSiparisIslemSonucu.basarili([this.mesaj = '']) : basarili = true;

  const MutfakSiparisIslemSonucu.hata(this.mesaj) : basarili = false;

  final bool basarili;
  final String mesaj;
}

/// Mutfak operasyon ekraninda siparis akisini, filtreleri ve durum ilerletmeyi yonetir.
class MutfakSiparisViewModel extends ChangeNotifier {
  MutfakSiparisViewModel({
    required SiparisleriGetirUseCase siparisleriGetirUseCase,
    required YazicilariGetirUseCase yazicilariGetirUseCase,
    required SiparisDurumuGuncelleUseCase siparisDurumuGuncelleUseCase,
    Future<bool> Function(IslemYetkisi yetki)? islemYetkisiSorgula,
    KuryeKonumTakipServisi? kuryeTakipServisi,
    KuryeEntegrasyonYonetimServisi? kuryeEntegrasyonServisi,
  }) : _siparisleriGetirUseCase = siparisleriGetirUseCase,
       _yazicilariGetirUseCase = yazicilariGetirUseCase,
       _siparisDurumuGuncelleUseCase = siparisDurumuGuncelleUseCase,
       _islemYetkisiSorgula = islemYetkisiSorgula,
       _kuryeKonumTakipServisi = kuryeTakipServisi ?? kuryeKonumTakipServisi,
       _kuryeEntegrasyonServisi =
           kuryeEntegrasyonServisi ?? KuryeEntegrasyonYonetimServisi();

  factory MutfakSiparisViewModel.servisKaydindan(ServisKaydi servisKaydi) {
    return MutfakSiparisViewModel(
      siparisleriGetirUseCase: servisKaydi.siparisleriGetirUseCase,
      yazicilariGetirUseCase: servisKaydi.yazicilariGetirUseCase,
      siparisDurumuGuncelleUseCase: servisKaydi.siparisDurumuGuncelleUseCase,
      islemYetkisiSorgula: servisKaydi.islemYetkisiVarMi,
      kuryeEntegrasyonServisi: servisKaydi.kuryeEntegrasyonYonetimServisi,
    );
  }

  final SiparisleriGetirUseCase _siparisleriGetirUseCase;
  final YazicilariGetirUseCase _yazicilariGetirUseCase;
  final SiparisDurumuGuncelleUseCase _siparisDurumuGuncelleUseCase;
  final Future<bool> Function(IslemYetkisi yetki)? _islemYetkisiSorgula;
  final KuryeKonumTakipServisi _kuryeKonumTakipServisi;
  final KuryeEntegrasyonYonetimServisi _kuryeEntegrasyonServisi;

  bool _yukleniyor = true;
  bool _durumIlerletmeYetkisiVar = true;
  bool _siparisIptalYetkisiVar = true;
  List<SiparisVarligi> _siparisler = const <SiparisVarligi>[];
  List<YaziciDurumuVarligi> _yazicilar = const <YaziciDurumuVarligi>[];
  TeslimatFiltresi _seciliFiltre = TeslimatFiltresi.tumu;

  bool get yukleniyor => _yukleniyor;
  bool get siparisIptalYetkisiVar => _siparisIptalYetkisiVar;
  bool get durumIlerletmeYetkisiVar => _durumIlerletmeYetkisiVar;
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
      final Future<bool> Function(IslemYetkisi yetki)? islemYetkisiSorgula =
          _islemYetkisiSorgula;
      if (islemYetkisiSorgula != null) {
        _durumIlerletmeYetkisiVar = await islemYetkisiSorgula(
          IslemYetkisi.siparisDurumuIlerle,
        );
        _siparisIptalYetkisiVar = await islemYetkisiSorgula(
          IslemYetkisi.siparisIptalEt,
        );
      }
      final List<SiparisVarligi> siparisler = await _siparisleriGetirUseCase();
      final List<YaziciDurumuVarligi> yazicilar =
          await _yazicilariGetirUseCase();
      await KuryeTakipSenkronlayici.siparislerleEsitle(
        takipServisi: _kuryeKonumTakipServisi,
        siparisler: siparisler,
        entegrasyonServisi: _kuryeEntegrasyonServisi,
      );
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

  Future<MutfakSiparisIslemSonucu> durumIlerle(
    SiparisVarligi siparis, {
    String? kuryeAdi,
  }) async {
    if (!_durumIlerletmeYetkisiVar) {
      return const MutfakSiparisIslemSonucu.hata(
        'Siparis durumunu ilerletme yetkin bulunmuyor.',
      );
    }

    final SiparisDurumu? sonrakiDurum = SiparisOperasyonAkisi.sonrakiDurum(
      siparis,
    );
    if (sonrakiDurum == null) {
      return const MutfakSiparisIslemSonucu.hata(
        'Bu siparisin durumu ilerletilemez',
      );
    }

    try {
      await _siparisDurumuGuncelleUseCase(
        siparis.id,
        sonrakiDurum,
        kuryeAdi: kuryeAdi,
      );
      final String takipMesaji = await _kuryeTakibiniDurumaGoreYonet(
        siparisId: siparis.id,
        kuryeKimligi: await _kuryeKimliginiBelirle(siparis, kuryeAdi: kuryeAdi),
        yeniDurum: sonrakiDurum,
      );
      final MutfakSiparisIslemSonucu yenileSonucu = await yukle();
      if (!yenileSonucu.basarili) {
        return yenileSonucu;
      }
      final String durumMesaji =
          '${_durumYaziciMesaji(siparis, sonrakiDurum)}${takipMesaji.isEmpty ? '' : ' $takipMesaji'}';
      return MutfakSiparisIslemSonucu.basarili(
        '${siparis.siparisNo} ${_durumEtiketi(sonrakiDurum).toLowerCase()} durumuna alindi. $durumMesaji',
      );
    } catch (hata) {
      return MutfakSiparisIslemSonucu.hata(
        _hataMesajiniCoz(hata, varsayilan: 'Siparis durumu guncellenemedi'),
      );
    }
  }

  Future<MutfakSiparisIslemSonucu> siparisiIptalEt(
    SiparisVarligi siparis,
  ) async {
    if (!_siparisIptalYetkisiVar) {
      return const MutfakSiparisIslemSonucu.hata(
        'Siparis iptal etme yetkin bulunmuyor.',
      );
    }

    try {
      await _siparisDurumuGuncelleUseCase(
        siparis.id,
        SiparisDurumu.iptalEdildi,
      );
      await _kuryeKonumTakipServisi.takipDurdur(siparis.id);
      final MutfakSiparisIslemSonucu yenileSonucu = await yukle();
      if (!yenileSonucu.basarili) {
        return yenileSonucu;
      }
      return MutfakSiparisIslemSonucu.basarili(
        '${siparis.siparisNo} iptal edildi ve operasyon listesinden dusuruldu.',
      );
    } catch (hata) {
      return MutfakSiparisIslemSonucu.hata(
        _hataMesajiniCoz(hata, varsayilan: 'Siparis iptal edilemedi'),
      );
    }
  }

  Future<String> _kuryeTakibiniDurumaGoreYonet({
    required String siparisId,
    required String kuryeKimligi,
    required SiparisDurumu yeniDurum,
  }) async {
    switch (yeniDurum) {
      case SiparisDurumu.yolda:
        final KuryeKonumTakipSonucu sonuc = await _kuryeKonumTakipServisi
            .takipBaslat(siparisId: siparisId, kuryeKimligi: kuryeKimligi);
        if (sonuc.basarili) {
          return sonuc.mesaj;
        }
        if (sonuc.mesaj.isEmpty) {
          return 'Konum takibi baslatilamadi.';
        }
        return sonuc.mesaj;
      case SiparisDurumu.teslimEdildi:
      case SiparisDurumu.iptalEdildi:
        await _kuryeKonumTakipServisi.takipDurdur(siparisId);
        return 'Canli konum takibi durduruldu.';
      case SiparisDurumu.alindi:
      case SiparisDurumu.hazirlaniyor:
      case SiparisDurumu.hazir:
        return '';
    }
  }

  Future<String> _kuryeKimliginiBelirle(
    SiparisVarligi siparis, {
    String? kuryeAdi,
  }) async {
    final String ham = kuryeAdi ?? siparis.kuryeAdi ?? '';
    final String temiz = ham.trim();
    if (temiz.isNotEmpty) {
      final String? takipKimligi = await _kuryeEntegrasyonServisi
          .kuryeTakipKimligiGetir(temiz);
      if (takipKimligi != null && takipKimligi.trim().isNotEmpty) {
        return takipKimligi;
      }
      return temiz;
    }
    return 'Moto Kurye';
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
