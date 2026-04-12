// ignore_for_file: avoid_print

import 'package:restoran_app/ozellikler/lisans/uygulama/servisler/lisans_anahtari_dogrulayici.dart';

void main(List<String> argumanlar) {
  final LisansAnahtariDogrulayici dogrulayici =
      const LisansAnahtariDogrulayici();

  if (argumanlar.isEmpty) {
    _kullanimYazdir();
    return;
  }

  final String cihazKodu = dogrulayici.cihazKoduDuzenle(argumanlar.first);
  DateTime gecerlilikTarihi = DateTime.now().add(const Duration(days: 365));

  if (argumanlar.length > 1) {
    final String tarih = argumanlar[1];
    final DateTime? cozumlenen = _tarihCoz(tarih);
    if (cozumlenen == null) {
      print('Gecersiz tarih. Beklenen format: YYYY-MM-DD');
      return;
    }
    gecerlilikTarihi = cozumlenen;
  }

  try {
    final String lisans = dogrulayici.lisansAnahtariOlustur(
      gecerlilikTarihi,
      cihazKodu: cihazKodu,
    );
    print('Cihaz kodu: $cihazKodu');
    print('Lisans anahtari: $lisans');
    print(
      'Gecerlilik tarihi: '
      '${gecerlilikTarihi.year.toString().padLeft(4, '0')}-'
      '${gecerlilikTarihi.month.toString().padLeft(2, '0')}-'
      '${gecerlilikTarihi.day.toString().padLeft(2, '0')}',
    );
  } on ArgumentError catch (hata) {
    print(hata.message);
    _kullanimYazdir();
  }
}

DateTime? _tarihCoz(String metin) {
  final List<String> bolumler = metin.split('-');
  if (bolumler.length != 3) {
    return null;
  }
  final int? yil = int.tryParse(bolumler[0]);
  final int? ay = int.tryParse(bolumler[1]);
  final int? gun = int.tryParse(bolumler[2]);
  if (yil == null || ay == null || gun == null) {
    return null;
  }
  final DateTime tarih = DateTime(yil, ay, gun);
  if (tarih.year != yil || tarih.month != ay || tarih.day != gun) {
    return null;
  }
  return tarih;
}

void _kullanimYazdir() {
  print(
    'Kullanim: dart run tool/lisans_anahtari_uret.dart <CIHAZ_KODU> [YYYY-MM-DD]',
  );
  print('Ornek: dart run tool/lisans_anahtari_uret.dart 1A2B3C 2027-04-11');
}
