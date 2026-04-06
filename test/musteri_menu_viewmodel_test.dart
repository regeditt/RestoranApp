import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/menu/sunum/viewmodel/musteri_menu_viewmodel.dart';

void main() {
  test(
    'MusteriMenuViewModel POS icin salon masa ve urun baglamini kurar',
    () async {
      final MusteriMenuViewModel viewModel =
          MusteriMenuViewModel.servisKaydindan(ServisKaydi.mock());

      final MusteriMenuIslemSonucu sonuc = await viewModel.verileriYukle();

      expect(sonuc.basarili, isTrue);
      expect(viewModel.kategoriler, isNotEmpty);
      expect(viewModel.urunler, isNotEmpty);
      expect(viewModel.salonBolumleri, isNotEmpty);
      expect(viewModel.seciliSalonBolumu, isNotNull);
      expect(viewModel.seciliMasa, isNotNull);
      expect(viewModel.posMasaUrunBaglami, isNotNull);
      expect(
        viewModel.posMasaUrunBaglami!.salonBolumu.id,
        viewModel.seciliSalonBolumu!.id,
      );
      expect(viewModel.posMasaUrunBaglami!.masa.id, viewModel.seciliMasa!.id);
      expect(
        viewModel.posMasaUrunBaglami!.toplamUrunSayisi,
        viewModel.urunler.length,
      );
      expect(viewModel.posBaglami?.kaynak, 'POS');
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

  test(
    'MusteriMenuViewModel salon ve masa degisince POS baglamini gunceller',
    () async {
      final MusteriMenuViewModel viewModel =
          MusteriMenuViewModel.servisKaydindan(ServisKaydi.mock());
      await viewModel.verileriYukle();

      final String ikinciBolumId = viewModel.salonBolumleri[1].id;
      final String ikinciBolumIlkMasaId =
          viewModel.salonBolumleri[1].masalar.first.id;

      viewModel.salonBolumuSec(ikinciBolumId);

      expect(viewModel.seciliSalonBolumu?.id, ikinciBolumId);
      expect(viewModel.seciliMasa?.id, ikinciBolumIlkMasaId);
      expect(viewModel.posMasaUrunBaglami?.salonBolumu.id, ikinciBolumId);
      expect(viewModel.posMasaUrunBaglami?.masa.id, ikinciBolumIlkMasaId);
    },
  );
}
