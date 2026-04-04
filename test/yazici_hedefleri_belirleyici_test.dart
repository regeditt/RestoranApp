import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/yazici_hedefleri_belirleyici.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';

void main() {
  test('Varsayilan hedef belirleyici icecekleri ayirir', () {
    final VarsayilanYaziciHedefleriBelirleyici belirleyici =
        const VarsayilanYaziciHedefleriBelirleyici();

    final SiparisVarligi siparis = SiparisVarligi(
      id: 'sip_1',
      siparisNo: 'R-1',
      sahip: SiparisSahibiVarligi.misafir(
        const MisafirBilgisiVarligi(adSoyad: 'Ayse Kaya', telefon: '555111'),
      ),
      teslimatTipi: TeslimatTipi.gelAl,
      durum: SiparisDurumu.alindi,
      kalemler: const <SiparisKalemiVarligi>[
        SiparisKalemiVarligi(
          id: 'kal_1',
          urunId: 'u_1',
          urunAdi: 'Kola',
          birimFiyat: 30,
          adet: 1,
        ),
      ],
      olusturmaTarihi: DateTime(2026, 4, 4),
    );

    final Set<String> roller = belirleyici.hedefRolleri(siparis);

    expect(roller.contains('Kasa'), isTrue);
    expect(roller.contains('Icecek'), isTrue);
    expect(roller.contains('Mutfak'), isFalse);
  });

  test('Paket serviste icecek rolu eklenir', () {
    final VarsayilanYaziciHedefleriBelirleyici belirleyici =
        const VarsayilanYaziciHedefleriBelirleyici();

    final SiparisVarligi siparis = SiparisVarligi(
      id: 'sip_2',
      siparisNo: 'R-2',
      sahip: SiparisSahibiVarligi.misafir(
        const MisafirBilgisiVarligi(adSoyad: 'Mert Can', telefon: '555222'),
      ),
      teslimatTipi: TeslimatTipi.paketServis,
      durum: SiparisDurumu.alindi,
      kalemler: const <SiparisKalemiVarligi>[
        SiparisKalemiVarligi(
          id: 'kal_2',
          urunId: 'u_2',
          urunAdi: 'Burger',
          birimFiyat: 120,
          adet: 1,
        ),
      ],
      olusturmaTarihi: DateTime(2026, 4, 4),
    );

    final Set<String> roller = belirleyici.hedefRolleri(siparis);

    expect(roller.contains('Kasa'), isTrue);
    expect(roller.contains('Mutfak'), isTrue);
    expect(roller.contains('Icecek'), isTrue);
  });
}
