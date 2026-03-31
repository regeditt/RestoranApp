import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

class SiparisDurumuGuncelleUseCase {
  const SiparisDurumuGuncelleUseCase(this._siparisDeposu);

  final SiparisDeposu _siparisDeposu;

  Future<SiparisVarligi> call(String siparisId, SiparisDurumu yeniDurum) {
    return _siparisDeposu.siparisDurumuGuncelle(siparisId, yeniDurum);
  }
}
