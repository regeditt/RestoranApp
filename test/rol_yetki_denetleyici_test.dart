import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/islem_yetkisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/rol_yetki_politikasi_varsayilan.dart';

void main() {
  group('RolYetkiPolitikasiVarsayilan', () {
    const RolYetkiPolitikasiVarsayilan denetleyici =
        RolYetkiPolitikasiVarsayilan();

    test('Garson siparis durumunu ilerletebilir ama siparis iptal edemez', () {
      expect(
        denetleyici.yetkiliMi(
          rol: KullaniciRolu.garson,
          yetki: IslemYetkisi.siparisDurumuIlerle,
        ),
        isTrue,
      );
      expect(
        denetleyici.yetkiliMi(
          rol: KullaniciRolu.garson,
          yetki: IslemYetkisi.siparisIptalEt,
        ),
        isFalse,
      );
    });

    test('Yonetici ve patron tum kritik islem yetkilerine sahiptir', () {
      for (final KullaniciRolu rol in <KullaniciRolu>[
        KullaniciRolu.yonetici,
        KullaniciRolu.patron,
      ]) {
        expect(
          denetleyici.yetkiliMi(rol: rol, yetki: IslemYetkisi.siparisIptalEt),
          isTrue,
        );
        expect(
          denetleyici.yetkiliMi(
            rol: rol,
            yetki: IslemYetkisi.urunFiyatDegistir,
          ),
          isTrue,
        );
      }
    });
  });
}
