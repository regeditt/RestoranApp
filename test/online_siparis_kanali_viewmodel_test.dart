import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/viewmodel/online_siparis_kanali_viewmodel.dart';

void main() {
  test(
    'OnlineSiparisKanaliViewModel normal yukte yogunluk onerisi gostermez',
    () async {
      final OnlineSiparisKanaliViewModel viewModel =
          OnlineSiparisKanaliViewModel.servisKaydindan(ServisKaydi.mock());

      final OnlineSiparisKanaliIslemSonucu sonuc = await viewModel.yukle();

      expect(sonuc.basarili, isTrue);
      expect(viewModel.yogunlukModuOnerisiVar, isFalse);
      expect(viewModel.yogunlukMesaji, isEmpty);
    },
  );

  test(
    'OnlineSiparisKanaliViewModel online siparis yogunlugunda pause onerisi verir',
    () async {
      final ServisKaydi servisKaydi = ServisKaydi.mock();
      for (int i = 0; i < 6; i++) {
        await servisKaydi.siparisOlusturUseCase(
          _onlineSiparisOlustur(index: i),
        );
      }

      final OnlineSiparisKanaliViewModel viewModel =
          OnlineSiparisKanaliViewModel.servisKaydindan(servisKaydi);
      final OnlineSiparisKanaliIslemSonucu sonuc = await viewModel.yukle();

      expect(sonuc.basarili, isTrue);
      expect(viewModel.aktifOnlineSiparisSayisi, greaterThanOrEqualTo(8));
      expect(viewModel.yogunlukModuOnerisiVar, isTrue);
      expect(viewModel.yogunlukMesaji, contains('hazirlama suresini arttir'));
      expect(viewModel.yogunlukMesaji, contains('pausela'));
    },
  );
}

SiparisVarligi _onlineSiparisOlustur({required int index}) {
  return SiparisVarligi(
    id: 'online_test_$index',
    siparisNo: 'R-ON$index',
    sahip: SiparisSahibiVarligi.misafir(
      MisafirBilgisiVarligi(
        adSoyad: 'Online Musteri $index',
        telefon: '55500000${index.toString().padLeft(2, '0')}',
      ),
    ),
    teslimatTipi: TeslimatTipi.gelAl,
    durum: SiparisDurumu.alindi,
    kalemler: const <SiparisKalemiVarligi>[
      SiparisKalemiVarligi(
        id: 'kal_online',
        urunId: 'urn_001',
        urunAdi: 'Klasik Burger',
        birimFiyat: 100,
        adet: 1,
      ),
    ],
    olusturmaTarihi: DateTime(2026, 4, 11, 14, 0).add(Duration(minutes: index)),
    kaynak: 'Getir',
  );
}
