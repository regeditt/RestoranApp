import 'package:restoran_app/ozellikler/odeme_kasa/alan/varliklar/kasa_hareketi_varligi.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/alan/varliklar/kasa_ozeti_varligi.dart';

abstract class OdemeKasaDeposu {
  Future<KasaOzetiVarligi> kasaOzetiniGetir({
    DateTime? baslangicTarihi,
    DateTime? bitisTarihi,
  });

  Future<void> kasaHareketiEkle(KasaHareketiVarligi hareket);
}
