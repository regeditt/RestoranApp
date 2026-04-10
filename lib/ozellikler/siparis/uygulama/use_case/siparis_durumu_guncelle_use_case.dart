import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

/// SiparisDurumuGuncelleUseCase use-case operasyonunu yurutur.
class SiparisDurumuGuncelleUseCase {
  const SiparisDurumuGuncelleUseCase(this._siparisDeposu);

  final SiparisDeposu _siparisDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<SiparisVarligi> call(
    String siparisId,
    SiparisDurumu yeniDurum, {
    String? kuryeAdi,
  }) {
    return _siparisDeposu.siparisDurumuGuncelle(
      siparisId,
      yeniDurum,
      kuryeAdi: kuryeAdi,
    );
  }
}
