import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
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

  test('GirisSecimViewModel hesap olusturma modunda ad soyad ister', () async {
    final GirisSecimViewModel viewModel = GirisSecimViewModel.servisKaydindan(
      ServisKaydi.mock(),
    );
    viewModel.modSec(PersonelGirisModu.yonetici);
    viewModel.ekranModuSec(KimlikEkranModu.hesapOlustur);

    final GirisSecimIslemSonucu sonuc = await viewModel.devamEt(
      kullaniciAdi: 'yeni_garson',
      sifre: '123456',
      adSoyad: '',
    );

    expect(sonuc.basarili, isFalse);
    expect(sonuc.mesaj, contains('Ad soyad'));
  });

  test(
    'GirisSecimViewModel her modda giris ve hesap olustur secenegi sunar',
    () {
      final GirisSecimViewModel viewModel = GirisSecimViewModel.servisKaydindan(
        ServisKaydi.mock(),
      );

      expect(viewModel.kullanilabilirEkranModlari, KimlikEkranModu.values);

      viewModel.ekranModuSec(KimlikEkranModu.hesapOlustur);

      expect(viewModel.ekranModu, KimlikEkranModu.hesapOlustur);
    },
  );

  test(
    'GirisSecimViewModel yonetici hesabi olusturup yonetim hedefine gider',
    () async {
      final GirisSecimViewModel viewModel = GirisSecimViewModel.servisKaydindan(
        ServisKaydi.mock(),
      );
      viewModel.modSec(PersonelGirisModu.yonetici);
      viewModel.ekranModuSec(KimlikEkranModu.hesapOlustur);

      final GirisSecimIslemSonucu sonuc = await viewModel.devamEt(
        kullaniciAdi: 'yonetici_yeni',
        sifre: '123456',
        adSoyad: 'Yeni Yonetici',
      );

      expect(sonuc.basarili, isTrue);
      expect(sonuc.hedef, GirisHedefi.yonetim);
    },
  );

  test(
    'GirisSecimViewModel hesap olusturmada secilen role gore hedef belirler',
    () async {
      final GirisSecimViewModel viewModel = GirisSecimViewModel.servisKaydindan(
        ServisKaydi.mock(),
      );
      viewModel.modSec(PersonelGirisModu.yonetici);
      viewModel.ekranModuSec(KimlikEkranModu.hesapOlustur);
      viewModel.hesapOlusturmaRoluSec(KullaniciRolu.garson);

      final GirisSecimIslemSonucu sonuc = await viewModel.devamEt(
        kullaniciAdi: 'garson_yeni',
        sifre: '123456',
        adSoyad: 'Yeni Garson',
      );

      expect(sonuc.basarili, isTrue);
      expect(sonuc.hedef, GirisHedefi.pos);
    },
  );
}
