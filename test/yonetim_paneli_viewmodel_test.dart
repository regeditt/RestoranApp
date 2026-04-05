import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/viewmodel/yonetim_paneli_viewmodel.dart';

void main() {
  test(
    'YonetimPaneliViewModel yukle ile temel panel verilerini doldurur',
    () async {
      final YonetimPaneliViewModel viewModel =
          YonetimPaneliViewModel.servisKaydindan(ServisKaydi.mock());

      final YonetimPaneliIslemSonucu sonuc = await viewModel.yukle();

      expect(sonuc.basarili, isTrue);
      expect(viewModel.siparisler, isNotEmpty);
      expect(viewModel.yazicilar, isNotEmpty);
      expect(viewModel.menuKategorileri, isNotEmpty);
    },
  );

  test(
    'YonetimPaneliViewModel yazici ekleme sonrasi listeyi gunceller',
    () async {
      final YonetimPaneliViewModel viewModel =
          YonetimPaneliViewModel.servisKaydindan(ServisKaydi.mock());
      await viewModel.yukle();
      const YaziciDurumuVarligi yeniYazici = YaziciDurumuVarligi(
        id: 'yzc_test',
        ad: 'Test Yazici',
        rolEtiketi: 'Kasa',
        baglantiNoktasi: 'USB-99',
        aciklama: 'Birim test yazicisi',
        durum: YaziciBaglantiDurumu.bagli,
      );

      final YonetimPaneliIslemSonucu sonuc = await viewModel.yaziciEkle(
        yeniYazici,
      );

      expect(sonuc.basarili, isTrue);
      expect(
        viewModel.yazicilar.any((yazici) => yazici.id == yeniYazici.id),
        isTrue,
      );
    },
  );
}
