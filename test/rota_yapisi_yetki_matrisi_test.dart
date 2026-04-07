import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';

void main() {
  group('RotaYapisi yetki matrisi', () {
    test('POS yalnizca personel rollerine aciktir', () {
      final List<KullaniciRolu>? izinli = RotaYapisi.izinliRolleriGetir(
        RotaYapisi.pos,
      );
      expect(izinli, isNotNull);
      expect(izinli, contains(KullaniciRolu.garson));
      expect(izinli, contains(KullaniciRolu.yonetici));
      expect(izinli, contains(KullaniciRolu.patron));
      expect(izinli, isNot(contains(KullaniciRolu.musteri)));
      expect(izinli, isNot(contains(KullaniciRolu.misafir)));
    });

    test('Mutfak yalnizca personel rollerine aciktir', () {
      final List<KullaniciRolu>? izinli = RotaYapisi.izinliRolleriGetir(
        RotaYapisi.mutfak,
      );
      expect(izinli, isNotNull);
      expect(izinli, contains(KullaniciRolu.garson));
      expect(izinli, contains(KullaniciRolu.yonetici));
      expect(izinli, contains(KullaniciRolu.patron));
      expect(izinli, isNot(contains(KullaniciRolu.musteri)));
      expect(izinli, isNot(contains(KullaniciRolu.misafir)));
    });

    test('Yonetim paneli yalnizca yonetici rollerine aciktir', () {
      final List<KullaniciRolu>? izinli = RotaYapisi.izinliRolleriGetir(
        RotaYapisi.yonetimPaneli,
      );
      expect(izinli, isNotNull);
      expect(izinli, isNot(contains(KullaniciRolu.garson)));
      expect(izinli, contains(KullaniciRolu.yonetici));
      expect(izinli, contains(KullaniciRolu.patron));
      expect(izinli, isNot(contains(KullaniciRolu.musteri)));
      expect(izinli, isNot(contains(KullaniciRolu.misafir)));
    });

    test('QR menu acik rota olarak yetki matrisi disindadir', () {
      final List<KullaniciRolu>? izinli = RotaYapisi.izinliRolleriGetir(
        RotaYapisi.qrMenu,
      );
      expect(izinli, isNull);
    });
  });
}
