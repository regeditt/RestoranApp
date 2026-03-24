import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

class SiparisleriGetirUseCase {
  const SiparisleriGetirUseCase(this._siparisDeposu);

  final SiparisDeposu _siparisDeposu;

  Future<List<SiparisVarligi>> call() {
    return _siparisDeposu.siparisleriGetir();
  }
}
