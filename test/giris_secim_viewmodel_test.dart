import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/viewmodel/giris_secim_viewmodel.dart';

void main() {
  test('GirisSecimViewModel bos bilgiyle hata dondurur', () async {
    final GirisSecimViewModel viewModel = GirisSecimViewModel.servisKaydindan(
      ServisKaydi.mock(),
    );

    final GirisSecimIslemSonucu sonuc = await viewModel.devamEt(
      kullaniciAdi: '',
      sifre: '',
    );

    expect(sonuc.basarili, isFalse);
    expect(sonuc.mesaj, contains('Kullanici adi'));
  });

  test('GirisSecimViewModel yonetici modunda yonetim hedefine gider', () async {
    final GirisSecimViewModel viewModel = GirisSecimViewModel.servisKaydindan(
      ServisKaydi.mock(),
    );
    viewModel.modSec(PersonelGirisModu.yonetici);

    final GirisSecimIslemSonucu sonuc = await viewModel.devamEt(
      kullaniciAdi: 'yonetici',
      sifre: '123456',
    );

    expect(sonuc.basarili, isTrue);
    expect(sonuc.hedef, GirisHedefi.yonetim);
  });
}
