import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';

/// SepeteUrunEkleUseCase use-case operasyonunu yurutur.
class SepeteUrunEkleUseCase {
  const SepeteUrunEkleUseCase(this._sepetDeposu);

  final SepetDeposu _sepetDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<SepetVarligi> call({
    required String urunId,
    int adet = 1,
    String? secenekId,
    String? notMetni,
  }) {
    return _sepetDeposu.urunEkle(
      urunId: urunId,
      adet: adet,
      secenekId: secenekId,
      notMetni: notMetni,
    );
  }
}
