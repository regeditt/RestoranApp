import 'package:restoran_app/ozellikler/sepet/alan/depolar/sepet_deposu.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';

class SepeteUrunEkleUseCase {
  const SepeteUrunEkleUseCase(this._sepetDeposu);

  final SepetDeposu _sepetDeposu;

  Future<SepetVarligi> call({
    required String urunId,
    int adet = 1,
    String? notMetni,
  }) {
    return _sepetDeposu.urunEkle(
      urunId: urunId,
      adet: adet,
      notMetni: notMetni,
    );
  }
}
