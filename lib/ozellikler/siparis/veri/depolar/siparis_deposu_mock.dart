import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

class SiparisDeposuMock implements SiparisDeposu {
  final List<SiparisVarligi> _siparisler = <SiparisVarligi>[];

  @override
  Future<SiparisVarligi?> siparisGetir(String siparisId) async {
    try {
      return _siparisler.firstWhere((siparis) => siparis.id == siparisId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SiparisVarligi> siparisOlustur(SiparisVarligi siparis) async {
    final SiparisVarligi kaydedilenSiparis = SiparisVarligi(
      id: siparis.id,
      siparisNo: siparis.siparisNo,
      sahip: siparis.sahip,
      teslimatTipi: siparis.teslimatTipi,
      durum: SiparisDurumu.alindi,
      kalemler: siparis.kalemler,
      olusturmaTarihi: siparis.olusturmaTarihi,
      adresMetni: siparis.adresMetni,
    );

    _siparisler.add(kaydedilenSiparis);
    return kaydedilenSiparis;
  }

  @override
  Future<List<SiparisVarligi>> siparisleriGetir() async {
    return _siparisler;
  }
}
