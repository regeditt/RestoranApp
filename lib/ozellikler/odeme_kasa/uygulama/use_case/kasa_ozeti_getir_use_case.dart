import 'package:restoran_app/ozellikler/odeme_kasa/alan/depolar/odeme_kasa_deposu.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/alan/varliklar/kasa_ozeti_varligi.dart';

class KasaOzetiGetirUseCase {
  const KasaOzetiGetirUseCase(this._odemeKasaDeposu);

  final OdemeKasaDeposu _odemeKasaDeposu;

  Future<KasaOzetiVarligi> call({
    DateTime? baslangicTarihi,
    DateTime? bitisTarihi,
  }) {
    return _odemeKasaDeposu.kasaOzetiniGetir(
      baslangicTarihi: baslangicTarihi,
      bitisTarihi: bitisTarihi,
    );
  }
}
