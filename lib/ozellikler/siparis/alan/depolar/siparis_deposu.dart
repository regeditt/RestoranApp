import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

abstract class SiparisDeposu {
  Future<SiparisVarligi> siparisOlustur(SiparisVarligi siparis);

  Future<SiparisVarligi> siparisDurumuGuncelle(
    String siparisId,
    SiparisDurumu yeniDurum,
  );

  Future<List<SiparisVarligi>> siparisleriGetir();

  Future<SiparisVarligi?> siparisGetir(String siparisId);
}
