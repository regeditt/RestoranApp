import 'package:restoran_app/ozellikler/kimlik/alan/roller/islem_yetkisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';

abstract class RolYetkiPolitikasi {
  bool yetkiliMi({required KullaniciRolu rol, required IslemYetkisi yetki});

  Set<IslemYetkisi> rolYetkileriniGetir(KullaniciRolu rol);
}
