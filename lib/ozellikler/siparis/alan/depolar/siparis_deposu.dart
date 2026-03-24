import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

abstract class SiparisDeposu {
  Future<SiparisVarligi> siparisOlustur(SiparisVarligi siparis);

  Future<List<SiparisVarligi>> siparisleriGetir();

  Future<SiparisVarligi?> siparisGetir(String siparisId);
}
