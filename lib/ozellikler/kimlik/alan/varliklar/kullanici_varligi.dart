import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';

class KullaniciVarligi {
  const KullaniciVarligi({
    required this.id,
    required this.adSoyad,
    required this.telefon,
    required this.rol,
    this.eposta,
    this.adresMetni,
    this.aktifMi = true,
  });

  final String id;
  final String adSoyad;
  final String telefon;
  final String? eposta;
  final String? adresMetni;
  final KullaniciRolu rol;
  final bool aktifMi;
}
