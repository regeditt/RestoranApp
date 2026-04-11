import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/servisler/siparis_operasyon_akisi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

void main() {
  test(
    'SiparisOperasyonAkisi paket hazir sipariste yolda adimini kullanir',
    () {
      final SiparisVarligi siparis = _siparisOlustur(
        durum: SiparisDurumu.hazir,
        teslimatTipi: TeslimatTipi.paketServis,
      );

      final SiparisDurumu? sonraki = SiparisOperasyonAkisi.sonrakiDurum(
        siparis,
      );
      final SiparisDurumDogrulamaSonucu sonuc =
          SiparisOperasyonAkisi.gecisDogrula(
            siparis: siparis,
            hedefDurum: SiparisDurumu.yolda,
          );

      expect(sonraki, SiparisDurumu.yolda);
      expect(sonuc.basarili, isTrue);
    },
  );

  test(
    'SiparisOperasyonAkisi salon hazir sipariste yolda gecisini engeller',
    () {
      final SiparisVarligi siparis = _siparisOlustur(
        durum: SiparisDurumu.hazir,
        teslimatTipi: TeslimatTipi.restorandaYe,
      );

      final SiparisDurumDogrulamaSonucu sonuc =
          SiparisOperasyonAkisi.gecisDogrula(
            siparis: siparis,
            hedefDurum: SiparisDurumu.yolda,
          );

      expect(sonuc.basarili, isFalse);
      expect(sonuc.mesaj, contains('Yolda durumu'));
    },
  );

  test(
    'SiparisOperasyonAkisi kapanmis sipariste durum degisimi engellenir',
    () {
      final SiparisVarligi siparis = _siparisOlustur(
        durum: SiparisDurumu.teslimEdildi,
        teslimatTipi: TeslimatTipi.gelAl,
      );

      final SiparisDurumDogrulamaSonucu sonuc =
          SiparisOperasyonAkisi.gecisDogrula(
            siparis: siparis,
            hedefDurum: SiparisDurumu.hazirlaniyor,
          );

      expect(sonuc.basarili, isFalse);
      expect(sonuc.mesaj, contains('Kapanmis siparis'));
    },
  );

  test('SiparisOperasyonAkisi adim atlayan gecisi engeller', () {
    final SiparisVarligi siparis = _siparisOlustur(
      durum: SiparisDurumu.alindi,
      teslimatTipi: TeslimatTipi.gelAl,
    );

    final SiparisDurumDogrulamaSonucu sonuc =
        SiparisOperasyonAkisi.gecisDogrula(
          siparis: siparis,
          hedefDurum: SiparisDurumu.hazir,
        );

    expect(sonuc.basarili, isFalse);
    expect(sonuc.mesaj, contains('Durum gecisi gecersiz'));
  });
}

SiparisVarligi _siparisOlustur({
  required SiparisDurumu durum,
  required TeslimatTipi teslimatTipi,
}) {
  return SiparisVarligi(
    id: 'sip_test',
    siparisNo: 'R-0001',
    sahip: const SiparisSahibiVarligi.misafir(
      MisafirBilgisiVarligi(adSoyad: 'Test Musteri', telefon: '5550000000'),
    ),
    teslimatTipi: teslimatTipi,
    durum: durum,
    kalemler: const <SiparisKalemiVarligi>[
      SiparisKalemiVarligi(
        id: 'kalem_1',
        urunId: 'urun_1',
        urunAdi: 'Test Urun',
        birimFiyat: 100,
        adet: 1,
      ),
    ],
    olusturmaTarihi: DateTime(2026, 4, 11, 12, 0),
  );
}
