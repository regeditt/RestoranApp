import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/servisler/yonetim_raporu_hesaplayici.dart';

void main() {
  test(
    'YonetimRaporuHesaplayici panel ozetinde KVKK ve iletisim izin metriklerini uretir',
    () {
      final List<SiparisVarligi> siparisler = <SiparisVarligi>[
        _siparisOlustur(
          id: 's1',
          teslimatTipi: TeslimatTipi.paketServis,
          durum: SiparisDurumu.hazirlaniyor,
          brut: 100,
          indirim: 10,
          aydinlatmaOnayi: true,
          ticariIletisimOnayi: true,
        ),
        _siparisOlustur(
          id: 's2',
          teslimatTipi: TeslimatTipi.gelAl,
          durum: SiparisDurumu.hazir,
          brut: 80,
          indirim: 0,
          aydinlatmaOnayi: true,
          ticariIletisimOnayi: false,
        ),
        _siparisOlustur(
          id: 's3',
          teslimatTipi: TeslimatTipi.restorandaYe,
          durum: SiparisDurumu.teslimEdildi,
          brut: 60,
          indirim: 0,
          aydinlatmaOnayi: false,
          ticariIletisimOnayi: false,
        ),
      ];

      final ozet = YonetimRaporuHesaplayici.panelOzetiniHesapla(siparisler);

      expect(ozet.toplamSiparis, 3);
      expect(ozet.toplamCiro, 230);
      expect(ozet.toplamIndirim, 10);
      expect(ozet.aydinlatmaOnayliSiparis, 2);
      expect(ozet.ticariIletisimOnayliSiparis, 1);
      expect(ozet.hazirlananSiparis, 1);
      expect(ozet.hazirSiparis, 1);
      expect(ozet.yoldaSiparis, 0);
      expect(ozet.paketServisSayisi, 1);
      expect(ozet.gelAlSayisi, 1);
      expect(ozet.restorandaYeSayisi, 1);
    },
  );
}

SiparisVarligi _siparisOlustur({
  required String id,
  required TeslimatTipi teslimatTipi,
  required SiparisDurumu durum,
  required double brut,
  required double indirim,
  required bool aydinlatmaOnayi,
  required bool ticariIletisimOnayi,
}) {
  return SiparisVarligi(
    id: id,
    siparisNo: 'R-$id',
    sahip: const SiparisSahibiVarligi.misafir(
      MisafirBilgisiVarligi(adSoyad: 'Test', telefon: '5550000000'),
    ),
    teslimatTipi: teslimatTipi,
    durum: durum,
    kalemler: <SiparisKalemiVarligi>[
      SiparisKalemiVarligi(
        id: 'k_$id',
        urunId: 'u_$id',
        urunAdi: 'Urun',
        birimFiyat: brut,
        adet: 1,
      ),
    ],
    olusturmaTarihi: DateTime(2026, 4, 11, 12, 0),
    indirimTutari: indirim,
    aydinlatmaOnayi: aydinlatmaOnayi,
    ticariIletisimOnayi: ticariIletisimOnayi,
  );
}
