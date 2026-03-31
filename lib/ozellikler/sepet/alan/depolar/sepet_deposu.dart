import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';

abstract class SepetDeposu {
  Future<SepetVarligi> sepetiGetir();

  Future<SepetVarligi> urunEkle({
    required String urunId,
    required int adet,
    String? secenekId,
    String? notMetni,
  });

  Future<SepetVarligi> kalemGuncelle({
    required String kalemId,
    required int adet,
  });

  Future<SepetVarligi> kalemSil(String kalemId);

  Future<void> sepetiTemizle();
}
