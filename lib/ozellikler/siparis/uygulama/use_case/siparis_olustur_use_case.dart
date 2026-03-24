import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

class SiparisOlusturUseCase {
  const SiparisOlusturUseCase(this._siparisDeposu);

  final SiparisDeposu _siparisDeposu;

  Future<SiparisVarligi> call(SiparisVarligi siparis) {
    return _siparisDeposu.siparisOlustur(siparis);
  }
}
