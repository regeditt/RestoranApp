import 'package:restoran_app/ozellikler/odeme_kasa/alan/depolar/odeme_kasa_deposu.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/alan/varliklar/kasa_hareketi_varligi.dart';

class KasaHareketiEkleUseCase {
  const KasaHareketiEkleUseCase(this._odemeKasaDeposu);

  final OdemeKasaDeposu _odemeKasaDeposu;

  Future<void> call(KasaHareketiVarligi hareket) {
    if (hareket.baslik.trim().isEmpty) {
      throw StateError('Hareket basligi bos olamaz.');
    }
    if (hareket.detay.trim().isEmpty) {
      throw StateError('Hareket detayi bos olamaz.');
    }
    if (hareket.tutar <= 0) {
      throw StateError('Tutar sifirdan buyuk olmalidir.');
    }
    return _odemeKasaDeposu.kasaHareketiEkle(hareket);
  }
}
