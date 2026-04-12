import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/viewmodel/siparis_ozeti_viewmodel.dart';

Future<SepetVarligi> _testSepetiOlustur(ServisKaydi servisKaydi) async {
  await servisKaydi.sepeteUrunEkleUseCase(urunId: 'urn_001', adet: 1);
  return servisKaydi.sepetiGetirUseCase();
}

void main() {
  test(
    'SiparisOzetiViewModel paket serviste adres zorunlulugunu uygular',
    () async {
      final ServisKaydi servisKaydi = ServisKaydi.mock();
      final SepetVarligi sepet = await _testSepetiOlustur(servisKaydi);
      final SiparisOzetiViewModel viewModel =
          SiparisOzetiViewModel.servisKaydindan(servisKaydi, sepet: sepet);
      viewModel.teslimatTipiSec(TeslimatTipi.paketServis);
      viewModel.adresDegisti('');

      final SiparisOzetiIslemSonucu sonuc = await viewModel.siparisiOnayla();

      expect(sonuc.basarili, isFalse);
      expect(sonuc.mesaj, contains('teslimat adresi'));
    },
  );

  test(
    'SiparisOzetiViewModel siparis olusturup yazdirma sonucu dondurur',
    () async {
      final ServisKaydi servisKaydi = ServisKaydi.mock();
      final SepetVarligi sepet = await _testSepetiOlustur(servisKaydi);
      final SiparisOzetiViewModel viewModel =
          SiparisOzetiViewModel.servisKaydindan(servisKaydi, sepet: sepet);
      await viewModel.varsayilanBilgileriYukle();
      viewModel.adresDegisti('Ataturk Mah. No:1');
      viewModel.aydinlatmaOnayiDegisti(true);

      final SiparisOzetiIslemSonucu sonuc = await viewModel.siparisiOnayla();

      expect(sonuc.basarili, isTrue);
      expect(sonuc.siparis, isNotNull);
      expect(sonuc.yazdirmaSonucu, isNotNull);
      expect(sonuc.siparis!.aydinlatmaOnayi, isTrue);
      expect(sonuc.siparis!.ticariIletisimOnayi, isFalse);
      expect(sonuc.siparis!.teslimatNotu, contains('Onaylar: KVKK onayli'));
      expect(sonuc.siparis!.teslimatNotu, contains('Ticari iletisim onaysiz'));
    },
  );

  test(
    'SiparisOzetiViewModel kupon indirimini siparise kalici yazar',
    () async {
      final ServisKaydi servisKaydi = ServisKaydi.mock();
      await servisKaydi.sepeteUrunEkleUseCase(urunId: 'urn_001', adet: 3);
      final SepetVarligi sepet = await servisKaydi.sepetiGetirUseCase();
      final SiparisOzetiViewModel viewModel =
          SiparisOzetiViewModel.servisKaydindan(servisKaydi, sepet: sepet);

      final SiparisOzetiIslemSonucu kuponSonucu = await viewModel.kuponUygula(
        'IKIALBIR',
      );
      expect(kuponSonucu.basarili, isTrue);
      viewModel.aydinlatmaOnayiDegisti(true);

      final SiparisOzetiIslemSonucu sonuc = await viewModel.siparisiOnayla();

      expect(sonuc.basarili, isTrue);
      expect(sonuc.siparis, isNotNull);
      expect(sonuc.siparis!.kuponKodu, 'IKIALBIR');
      expect(sonuc.siparis!.indirimTutari, greaterThan(0));
      expect(sonuc.siparis!.toplamTutar, lessThan(sonuc.siparis!.araToplam));
      expect(sonuc.siparis!.aydinlatmaOnayi, isTrue);
      expect(sonuc.siparis!.teslimatNotu, contains('Kampanya: IKIALBIR'));
      expect(sonuc.siparis!.teslimatNotu, contains('Onaylar: KVKK onayli'));
    },
  );

  test(
    'SiparisOzetiViewModel aydinlatma onayi olmadan siparisi tamamlamaz',
    () async {
      final ServisKaydi servisKaydi = ServisKaydi.mock();
      final SepetVarligi sepet = await _testSepetiOlustur(servisKaydi);
      final SiparisOzetiViewModel viewModel =
          SiparisOzetiViewModel.servisKaydindan(servisKaydi, sepet: sepet);

      final SiparisOzetiIslemSonucu sonuc = await viewModel.siparisiOnayla();

      expect(sonuc.basarili, isFalse);
      expect(sonuc.mesaj, contains('KVKK aydinlatma onayi'));
    },
  );
}
