import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/viewmodel/mutfak_siparis_viewmodel.dart';

void main() {
  test(
    'MutfakSiparisViewModel yukle ile siparis ve yazici verilerini doldurur',
    () async {
      final MutfakSiparisViewModel viewModel =
          MutfakSiparisViewModel.servisKaydindan(ServisKaydi.mock());

      final MutfakSiparisIslemSonucu sonuc = await viewModel.yukle();

      expect(sonuc.basarili, isTrue);
      expect(viewModel.siparisler, isNotEmpty);
      expect(viewModel.yazicilar, isNotEmpty);
    },
  );

  test(
    'MutfakSiparisViewModel durum ilerletme sonraki duruma gecirir',
    () async {
      final MutfakSiparisViewModel viewModel =
          MutfakSiparisViewModel.servisKaydindan(ServisKaydi.mock());
      await viewModel.yukle();
      final siparis = viewModel.siparisler.firstWhere(
        (siparis) => siparis.durum == SiparisDurumu.alindi,
      );

      final MutfakSiparisIslemSonucu sonuc = await viewModel.durumIlerle(
        siparis,
      );
      final guncelSiparis = viewModel.siparisler.firstWhere(
        (deger) => deger.id == siparis.id,
      );

      expect(sonuc.basarili, isTrue);
      expect(guncelSiparis.durum, SiparisDurumu.hazirlaniyor);
    },
  );
}
