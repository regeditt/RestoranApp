import 'package:restoran_app/ozellikler/siparis/alan/varliklar/kurye_takip_entegrasyon_varliklari.dart';

/// Kurye entegrasyon ayarlari icin depoya yazilan kayit modelidir.
class KuryeEntegrasyonDepoKaydi {
  const KuryeEntegrasyonDepoKaydi({
    required this.saglayicilar,
    required this.eslesmeler,
  });

  final List<KuryeTakipSaglayiciVarligi> saglayicilar;
  final List<KuryeCihazEslesmesiVarligi> eslesmeler;
}

/// Kurye takip saglayici ve cihaz eslesmelerini saklayan depo kontrati.
abstract class KuryeEntegrasyonDeposu {
  /// Kayitli kurye entegrasyon verisini yukler.
  ///
  /// Kayit yoksa `null` dondurur.
  Future<KuryeEntegrasyonDepoKaydi?> yukle();

  /// Kurye entegrasyon verisini kalici olarak kaydeder.
  Future<void> kaydet(KuryeEntegrasyonDepoKaydi kayit);
}

/// Bellek icinde gecici calisan varsayilan entegrasyon deposu.
class KuryeEntegrasyonDeposuBellek implements KuryeEntegrasyonDeposu {
  const KuryeEntegrasyonDeposuBellek();

  @override
  Future<KuryeEntegrasyonDepoKaydi?> yukle() async {
    return null;
  }

  @override
  Future<void> kaydet(KuryeEntegrasyonDepoKaydi kayit) async {}
}
