import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/rezervasyon/alan/enumlar/rezervasyon_durumu.dart';
import 'package:restoran_app/ozellikler/rezervasyon/sunum/viewmodel/rezervasyon_viewmodel.dart';

void main() {
  test(
    'RezervasyonViewModel gecmis aktif rezervasyonu otomatik no-show yapar',
    () async {
      final ServisKaydi servisKaydi = ServisKaydi.mock();
      final RezervasyonViewModel viewModel =
          RezervasyonViewModel.servisKaydindan(servisKaydi);

      final DateTime simdi = DateTime.now();
      final DateTime gecmisBaslangic = simdi.subtract(const Duration(hours: 2));
      final RezervasyonOlusturmaGirdisi girdi = RezervasyonOlusturmaGirdisi(
        musteriAdi: 'No Show Test',
        telefon: '05320000000',
        kisiSayisi: 2,
        baslangicZamani: gecmisBaslangic,
        sureDakika: 60,
        notMetni: '',
        aydinlatmaOnayi: true,
        ticariIletisimOnayi: false,
      );
      final RezervasyonIslemSonucu olusturmaSonucu = await viewModel
          .rezervasyonOlustur(girdi);
      expect(olusturmaSonucu.basarili, isTrue);

      final RezervasyonIslemSonucu yuklemeSonucu = await viewModel.yukle(
        gun: gecmisBaslangic,
      );

      final bool noShowaDonustu = viewModel.filtrelenmisRezervasyonlar.any((
        rezervasyon,
      ) {
        return rezervasyon.musteriAdi == 'No Show Test' &&
            rezervasyon.durum == RezervasyonDurumu.noShow;
      });

      expect(yuklemeSonucu.basarili, isTrue);
      expect(noShowaDonustu, isTrue);
    },
  );
}
