import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/menu/sunum/viewmodel/musteri_menu_viewmodel.dart';

void main() {
  test(
    'MusteriMenuViewModel verileri yukleyip varsayilan kategoriyi secer',
    () async {
      final MusteriMenuViewModel viewModel =
          MusteriMenuViewModel.servisKaydindan(ServisKaydi.mock());

      final MusteriMenuIslemSonucu sonuc = await viewModel.verileriYukle();

      expect(sonuc.basarili, isTrue);
      expect(viewModel.kategoriler, isNotEmpty);
      expect(viewModel.urunler, isNotEmpty);
      expect(viewModel.seciliKategoriId, isNotNull);
    },
  );

  test('MusteriMenuViewModel urunu sepete ekler', () async {
    final MusteriMenuViewModel viewModel = MusteriMenuViewModel.servisKaydindan(
      ServisKaydi.mock(),
    );
    await viewModel.verileriYukle();
    final urun = viewModel.urunler.first;

    final MusteriMenuIslemSonucu sonuc = await viewModel.sepeteEkle(
      urun,
      adet: 2,
    );

    expect(sonuc.basarili, isTrue);
    expect(viewModel.sepet.kalemler, isNotEmpty);
  });
}
