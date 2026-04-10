import 'package:restoran_app/ozellikler/kimlik/alan/roller/islem_yetkisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/rol_yetki_politikasi.dart';

class RolYetkiPolitikasiVarsayilan implements RolYetkiPolitikasi {
  const RolYetkiPolitikasiVarsayilan();

  static const Map<KullaniciRolu, Set<IslemYetkisi>> _rolYetkiMatrisi =
      <KullaniciRolu, Set<IslemYetkisi>>{
        KullaniciRolu.misafir: <IslemYetkisi>{},
        KullaniciRolu.musteri: <IslemYetkisi>{},
        KullaniciRolu.garson: <IslemYetkisi>{
          IslemYetkisi.siparisDurumuIlerle,
          IslemYetkisi.masaTasima,
        },
        KullaniciRolu.yonetici: <IslemYetkisi>{
          IslemYetkisi.siparisDurumuIlerle,
          IslemYetkisi.siparisIptalEt,
          IslemYetkisi.ikramUygula,
          IslemYetkisi.urunFiyatDegistir,
          IslemYetkisi.masaTasima,
        },
        KullaniciRolu.patron: <IslemYetkisi>{
          IslemYetkisi.siparisDurumuIlerle,
          IslemYetkisi.siparisIptalEt,
          IslemYetkisi.ikramUygula,
          IslemYetkisi.urunFiyatDegistir,
          IslemYetkisi.masaTasima,
        },
      };

  @override
  bool yetkiliMi({required KullaniciRolu rol, required IslemYetkisi yetki}) {
    return _rolYetkiMatrisi[rol]?.contains(yetki) ?? false;
  }

  @override
  Set<IslemYetkisi> rolYetkileriniGetir(KullaniciRolu rol) {
    final Set<IslemYetkisi>? yetkiler = _rolYetkiMatrisi[rol];
    if (yetkiler == null) {
      return const <IslemYetkisi>{};
    }
    return Set<IslemYetkisi>.unmodifiable(yetkiler);
  }
}
