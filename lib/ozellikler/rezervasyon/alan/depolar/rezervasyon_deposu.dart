import 'package:restoran_app/ozellikler/rezervasyon/alan/enumlar/rezervasyon_durumu.dart';
import 'package:restoran_app/ozellikler/rezervasyon/alan/varliklar/rezervasyon_varligi.dart';

abstract class RezervasyonDeposu {
  Future<List<RezervasyonVarligi>> rezervasyonlariGetir({DateTime? gun});

  Future<void> rezervasyonKaydet(RezervasyonVarligi rezervasyon);

  Future<void> rezervasyonDurumuGuncelle({
    required String rezervasyonId,
    required RezervasyonDurumu durum,
  });

  Future<void> rezervasyonSil(String rezervasyonId);
}
