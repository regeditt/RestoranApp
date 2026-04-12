import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:restoran_app/ortak/platform/konum_platformu.dart';

/// Takipteki bir siparis icin son kurye konumunu ve guncelleme zamanini tasir.
class KuryeCanliKonumVarligi {
  const KuryeCanliKonumVarligi({
    required this.enlem,
    required this.boylam,
    required this.guncellenmeTarihi,
    required this.kuryeKimligi,
  });

  final double enlem;
  final double boylam;
  final DateTime guncellenmeTarihi;
  final String kuryeKimligi;
}

/// Kurye konum takibi baslatma/durdurma islemlerinin sonucunu tasir.
class KuryeKonumTakipSonucu {
  const KuryeKonumTakipSonucu.basarili([this.mesaj = '']) : basarili = true;

  const KuryeKonumTakipSonucu.hata(this.mesaj) : basarili = false;

  final bool basarili;
  final String mesaj;
}

/// Siparis bazli canli kurye konum takibini baslatir, surdurur ve sonlandirir.
class KuryeKonumTakipServisi extends ChangeNotifier {
  KuryeKonumTakipServisi({KonumPlatformu? konumSaglayici})
    : _konumSaglayici = konumSaglayici ?? konumPlatformu;

  final KonumPlatformu _konumSaglayici;
  final Map<String, KuryeCanliKonumVarligi> _siparisKonumlari =
      <String, KuryeCanliKonumVarligi>{};
  final Map<String, String> _siparisKuryeHaritasi = <String, String>{};

  StreamSubscription<KonumNoktasi>? _konumAboneligi;

  int get aktifTakipSayisi => _siparisKuryeHaritasi.length;
  Set<String> get takiptekiSiparisIdleri => _siparisKuryeHaritasi.keys.toSet();

  KuryeCanliKonumVarligi? siparisKonumuGetir(String siparisId) {
    return _siparisKonumlari[siparisId];
  }

  bool siparisTakipteMi(String siparisId) {
    return _siparisKuryeHaritasi.containsKey(siparisId);
  }

  Future<KuryeKonumTakipSonucu> takipBaslat({
    required String siparisId,
    required String kuryeKimligi,
  }) async {
    final String temizKuryeKimligi = _kuryeKimligiNormalize(kuryeKimligi);
    if (temizKuryeKimligi.isEmpty) {
      return const KuryeKonumTakipSonucu.hata(
        'Kurye kimligi bos oldugu icin takip baslatilamadi.',
      );
    }

    final bool ilkTakipBaslatma = _siparisKuryeHaritasi.isEmpty;
    final bool ayniEslesme =
        _siparisKuryeHaritasi[siparisId] == temizKuryeKimligi;
    _siparisKuryeHaritasi[siparisId] = temizKuryeKimligi;

    if (ayniEslesme && _konumAboneligi != null) {
      return KuryeKonumTakipSonucu.basarili(
        'Canli takip aktif. Toplam $aktifTakipSayisi siparis izleniyor.',
      );
    }

    if (ilkTakipBaslatma) {
      final KonumHazirlamaSonucu hazirlamaSonucu = await _konumSaglayici
          .hazirla();
      if (!hazirlamaSonucu.basarili) {
        _siparisKuryeHaritasi.remove(siparisId);
        return KuryeKonumTakipSonucu.hata(hazirlamaSonucu.mesaj);
      }
    }

    final KonumNoktasi? anlikKonum = await _konumSaglayici.anlikKonumGetir();
    if (anlikKonum != null) {
      _tumTakipleriKonumlaGuncelle(anlikKonum);
    }

    await _abonelikVarmisGibiBaslat();
    return KuryeKonumTakipSonucu.basarili(
      'Canli takip baslatildi. Toplam $aktifTakipSayisi siparis izleniyor.',
    );
  }

  Future<void> takipDurdur(String siparisId) async {
    _siparisKuryeHaritasi.remove(siparisId);
    final bool konumSilindi = _siparisKonumlari.remove(siparisId) != null;
    if (_siparisKuryeHaritasi.isEmpty) {
      await _konumAboneliginiKapat();
    }
    if (konumSilindi) {
      notifyListeners();
    }
  }

  Future<void> _abonelikVarmisGibiBaslat() async {
    if (_konumAboneligi != null) {
      return;
    }

    _konumAboneligi = _konumSaglayici.konumAkisi().listen((KonumNoktasi konum) {
      _tumTakipleriKonumlaGuncelle(konum);
    }, onError: (_) {});
  }

  Future<void> _konumAboneliginiKapat() async {
    await _konumAboneligi?.cancel();
    _konumAboneligi = null;
  }

  void _tumTakipleriKonumlaGuncelle(KonumNoktasi merkezKonum) {
    if (_siparisKuryeHaritasi.isEmpty) {
      return;
    }

    final Map<String, KuryeCanliKonumVarligi> yeniKonumlar =
        <String, KuryeCanliKonumVarligi>{};
    for (final MapEntry<String, String> kayit
        in _siparisKuryeHaritasi.entries) {
      final _EnlemBoylam ofsetli = _kuryeyeGoreOfsetliKonum(
        merkezEnlem: merkezKonum.enlem,
        merkezBoylam: merkezKonum.boylam,
        kuryeKimligi: kayit.value,
      );
      yeniKonumlar[kayit.key] = KuryeCanliKonumVarligi(
        enlem: ofsetli.enlem,
        boylam: ofsetli.boylam,
        guncellenmeTarihi: merkezKonum.olusturmaTarihi,
        kuryeKimligi: kayit.value,
      );
    }

    _siparisKonumlari
      ..clear()
      ..addAll(yeniKonumlar);
    notifyListeners();
  }

  _EnlemBoylam _kuryeyeGoreOfsetliKonum({
    required double merkezEnlem,
    required double merkezBoylam,
    required String kuryeKimligi,
  }) {
    int hash = 0;
    for (final int rune in kuryeKimligi.runes) {
      hash = (hash * 31) + rune;
    }
    final int normalize = hash.abs();
    final double aci = (normalize % 360) * math.pi / 180;
    final double uzaklikMetre = 25 + (normalize % 140);

    final double enlemOfset = (uzaklikMetre / 111320) * math.cos(aci);
    final double enlemRadyan = merkezEnlem * math.pi / 180;
    final double boylamPayda = math.max(0.2, math.cos(enlemRadyan).abs());
    final double boylamOfset =
        (uzaklikMetre / (111320 * boylamPayda)) * math.sin(aci);

    return _EnlemBoylam(
      enlem: merkezEnlem + enlemOfset,
      boylam: merkezBoylam + boylamOfset,
    );
  }

  String _kuryeKimligiNormalize(String kuryeKimligi) {
    return kuryeKimligi.trim();
  }
}

/// Enlem-boylam ciftini dahili hesaplamalarda tasiyan yardimci veri yapisi.
class _EnlemBoylam {
  const _EnlemBoylam({required this.enlem, required this.boylam});

  final double enlem;
  final double boylam;
}

final KuryeKonumTakipServisi kuryeKonumTakipServisi = KuryeKonumTakipServisi();
