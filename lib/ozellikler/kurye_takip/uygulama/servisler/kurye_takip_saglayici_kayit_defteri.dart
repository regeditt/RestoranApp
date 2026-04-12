import 'package:restoran_app/ozellikler/kurye_takip/core/soylesmeler/kurye_takip_saglayicisi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/kurye_takip_entegrasyon_varliklari.dart';

/// Kurye takip saglayici adaptorlerini tur bazinda kaydedip erisim saglar.
class KuryeTakipSaglayiciKayitDefteri {
  KuryeTakipSaglayiciKayitDefteri({
    required List<KuryeTakipSaglayicisi> saglayicilar,
  }) : _saglayicilar = <KuryeTakipSaglayiciTuru, KuryeTakipSaglayicisi>{
         for (final KuryeTakipSaglayicisi saglayici in saglayicilar)
           saglayici.tur: saglayici,
       };

  final Map<KuryeTakipSaglayiciTuru, KuryeTakipSaglayicisi> _saglayicilar;

  KuryeTakipSaglayicisi? getir(KuryeTakipSaglayiciTuru tur) {
    return _saglayicilar[tur];
  }
}
