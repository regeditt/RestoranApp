import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

/// SiparisleriGetirUseCase use-case operasyonunu yurutur.
class SiparisleriGetirUseCase {
  const SiparisleriGetirUseCase(this._siparisDeposu);

  final SiparisDeposu _siparisDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<List<SiparisVarligi>> call() {
    return _siparisDeposu.siparisleriGetir();
  }
}
