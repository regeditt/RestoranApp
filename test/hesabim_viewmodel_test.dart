import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/viewmodel/hesabim_viewmodel.dart';

void main() {
  test(
    'HesabimViewModel giris ve cikis akisinda aktif kullaniciyi gunceller',
    () async {
      final HesabimViewModel viewModel = HesabimViewModel.servisKaydindan(
        ServisKaydi.mock(),
      );

      await viewModel.kullaniciYukle();
      expect(viewModel.aktifKullanici, isNull);

      final girisSonucu = await viewModel.girisYap(
        telefon: '5550000000',
        sifre: '1234',
      );
      expect(girisSonucu.basarili, isTrue);
      expect(viewModel.aktifKullanici, isNotNull);

      final cikisSonucu = await viewModel.cikisYap();
      expect(cikisSonucu.basarili, isTrue);
      expect(viewModel.aktifKullanici, isNull);
    },
  );

  test('HesabimViewModel adres ekleme ve silme yapar', () {
    final HesabimViewModel viewModel = HesabimViewModel.servisKaydindan(
      ServisKaydi.mock(),
    );

    final eklemeSonucu = viewModel.adresEkle(
      baslik: 'Depo',
      adresMetni: 'Merkez Mah. No:10',
    );
    expect(eklemeSonucu.basarili, isTrue);
    expect(viewModel.adresler.any((adres) => adres.baslik == 'Depo'), isTrue);

    final AdresVerisi eklenecekAdres = viewModel.adresler.last;
    final silmeSonucu = viewModel.adresSil(eklenecekAdres);
    expect(silmeSonucu.basarili, isTrue);
    expect(
      viewModel.adresler.any((adres) => identical(adres, eklenecekAdres)),
      isFalse,
    );
  });
}
