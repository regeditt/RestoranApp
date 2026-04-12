import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_entegrasyon_yonetim_servisi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_konum_takip_servisi.dart';

/// Yolda olan paket siparisleri ile aktif kurye takip kayitlarini senkron tutar.
class KuryeTakipSenkronlayici {
  const KuryeTakipSenkronlayici._();

  static Future<void> siparislerleEsitle({
    required KuryeKonumTakipServisi takipServisi,
    required List<SiparisVarligi> siparisler,
    required KuryeEntegrasyonYonetimServisi entegrasyonServisi,
  }) async {
    final Map<String, String> takipteOlmasiGerekenler = <String, String>{
      for (final SiparisVarligi siparis in siparisler)
        if (siparis.teslimatTipi == TeslimatTipi.paketServis &&
            siparis.durum == SiparisDurumu.yolda)
          siparis.id: await _kuryeKimliginiBelirle(siparis, entegrasyonServisi),
    };

    final Set<String> takiptenCikarilacaklar = takipServisi
        .takiptekiSiparisIdleri
        .difference(takipteOlmasiGerekenler.keys.toSet());
    for (final String siparisId in takiptenCikarilacaklar) {
      await takipServisi.takipDurdur(siparisId);
    }

    for (final MapEntry<String, String> kayit
        in takipteOlmasiGerekenler.entries) {
      await takipServisi.takipBaslat(
        siparisId: kayit.key,
        kuryeKimligi: kayit.value,
      );
    }
  }

  static Future<String> _kuryeKimliginiBelirle(
    SiparisVarligi siparis,
    KuryeEntegrasyonYonetimServisi entegrasyonServisi,
  ) async {
    final String temiz = (siparis.kuryeAdi ?? '').trim();
    if (temiz.isNotEmpty) {
      final String? takipKimligi = await entegrasyonServisi
          .kuryeTakipKimligiGetir(temiz);
      if (takipKimligi != null && takipKimligi.trim().isNotEmpty) {
        return takipKimligi;
      }
      return temiz;
    }
    return 'Moto Kurye';
  }
}
