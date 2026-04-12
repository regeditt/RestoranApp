import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/veri/depolar/siparis_deposu_mock.dart';

class SiparisDeposuGercek implements SiparisDeposu {
  SiparisDeposuGercek([SiparisDeposu? icDepo])
    : _icDepo = icDepo ?? SiparisDeposuMock();

  final SiparisDeposu _icDepo;

  @override
  Future<SiparisVarligi?> siparisGetir(String siparisId) {
    return _icDepo.siparisGetir(siparisId);
  }

  @override
  Future<SiparisVarligi> siparisOlustur(SiparisVarligi siparis) {
    return _icDepo.siparisOlustur(siparis);
  }

  @override
  Future<SiparisVarligi> siparisDurumuGuncelle(
    String siparisId,
    SiparisDurumu yeniDurum, {
    String? kuryeAdi,
  }) {
    return _icDepo.siparisDurumuGuncelle(
      siparisId,
      yeniDurum,
      kuryeAdi: kuryeAdi,
    );
  }

  @override
  Future<List<SiparisVarligi>> siparisleriGetir() {
    return _icDepo.siparisleriGetir();
  }
}
