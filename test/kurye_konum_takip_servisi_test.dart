import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ortak/platform/konum_platformu.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_konum_takip_servisi.dart';

void main() {
  test(
    'KuryeKonumTakipServisi ayni anda birden fazla siparisi izler',
    () async {
      final _SahteKonumPlatformu platform = _SahteKonumPlatformu(
        anlik: KonumNoktasi(
          enlem: 41.015,
          boylam: 28.979,
          olusturmaTarihi: DateTime(2026, 4, 9, 12, 0),
        ),
      );
      final KuryeKonumTakipServisi servis = KuryeKonumTakipServisi(
        konumSaglayici: platform,
      );

      final KuryeKonumTakipSonucu ilk = await servis.takipBaslat(
        siparisId: 'sip_1',
        kuryeKimligi: 'Emre Kurye',
      );
      final KuryeKonumTakipSonucu ikinci = await servis.takipBaslat(
        siparisId: 'sip_2',
        kuryeKimligi: 'Mert Kurye',
      );

      expect(ilk.basarili, isTrue);
      expect(ikinci.basarili, isTrue);
      expect(servis.aktifTakipSayisi, 2);

      platform.konumYayinla(
        KonumNoktasi(
          enlem: 41.016,
          boylam: 28.980,
          olusturmaTarihi: DateTime(2026, 4, 9, 12, 1),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      final KuryeCanliKonumVarligi? birinci = servis.siparisKonumuGetir(
        'sip_1',
      );
      final KuryeCanliKonumVarligi? ikinciKonum = servis.siparisKonumuGetir(
        'sip_2',
      );
      expect(birinci, isNotNull);
      expect(ikinciKonum, isNotNull);
      expect(birinci!.kuryeKimligi, 'Emre Kurye');
      expect(ikinciKonum!.kuryeKimligi, 'Mert Kurye');
      expect(
        birinci.enlem != ikinciKonum.enlem ||
            birinci.boylam != ikinciKonum.boylam,
        isTrue,
      );
    },
  );

  test(
    'KuryeKonumTakipServisi bir siparis durunca digeri takipte kalir',
    () async {
      final _SahteKonumPlatformu platform = _SahteKonumPlatformu(
        anlik: KonumNoktasi(
          enlem: 41.01,
          boylam: 28.97,
          olusturmaTarihi: DateTime(2026, 4, 9, 12, 0),
        ),
      );
      final KuryeKonumTakipServisi servis = KuryeKonumTakipServisi(
        konumSaglayici: platform,
      );

      await servis.takipBaslat(siparisId: 'sip_1', kuryeKimligi: 'Kurye A');
      await servis.takipBaslat(siparisId: 'sip_2', kuryeKimligi: 'Kurye B');

      await servis.takipDurdur('sip_1');

      expect(servis.siparisKonumuGetir('sip_1'), isNull);
      expect(servis.siparisTakipteMi('sip_1'), isFalse);
      expect(servis.siparisTakipteMi('sip_2'), isTrue);
      expect(servis.aktifTakipSayisi, 1);
    },
  );
}

class _SahteKonumPlatformu implements KonumPlatformu {
  _SahteKonumPlatformu({required KonumNoktasi anlik}) : _anlik = anlik;

  final StreamController<KonumNoktasi> _controller =
      StreamController<KonumNoktasi>.broadcast();
  KonumNoktasi _anlik;

  @override
  Future<KonumHazirlamaSonucu> hazirla() async {
    return const KonumHazirlamaSonucu.basarili();
  }

  @override
  Future<KonumNoktasi?> anlikKonumGetir() async {
    return _anlik;
  }

  @override
  Stream<KonumNoktasi> konumAkisi() {
    return _controller.stream;
  }

  void konumYayinla(KonumNoktasi konum) {
    _anlik = konum;
    _controller.add(konum);
  }
}
