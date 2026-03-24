import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';

class SiparisSahibiVarligi {
  const SiparisSahibiVarligi._({this.kullanici, this.misafirBilgisi});

  const SiparisSahibiVarligi.kullanici(KullaniciVarligi kullanici)
    : this._(kullanici: kullanici);

  const SiparisSahibiVarligi.misafir(MisafirBilgisiVarligi misafirBilgisi)
    : this._(misafirBilgisi: misafirBilgisi);

  final KullaniciVarligi? kullanici;
  final MisafirBilgisiVarligi? misafirBilgisi;

  bool get misafirMi => misafirBilgisi != null;
}
