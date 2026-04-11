import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/mutfak_operasyon_hesaplayici.dart';

void main() {
  test('MutfakOperasyonHesaplayici gecikme uyarisi ve tahminleri hesaplar', () {
    final DateTime simdi = DateTime(2026, 4, 11, 12, 0);
    final List<SiparisVarligi> siparisler = <SiparisVarligi>[
      _siparis(
        id: 's1',
        siparisNo: 'S-1',
        durum: SiparisDurumu.alindi,
        urunAdlari: <String>['Pizza Karisik', 'Salata'],
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 28)),
        teslimatTipi: TeslimatTipi.paketServis,
      ),
      _siparis(
        id: 's2',
        siparisNo: 'S-2',
        durum: SiparisDurumu.hazirlaniyor,
        urunAdlari: <String>['Izgara Tavuk'],
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 7)),
        teslimatTipi: TeslimatTipi.restorandaYe,
      ),
      _siparis(
        id: 's3',
        siparisNo: 'S-3',
        durum: SiparisDurumu.hazir,
        urunAdlari: <String>['Makarna'],
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 3)),
        teslimatTipi: TeslimatTipi.gelAl,
      ),
      _siparis(
        id: 's4',
        siparisNo: 'S-4',
        durum: SiparisDurumu.teslimEdildi,
        urunAdlari: <String>['Corba'],
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 45)),
        teslimatTipi: TeslimatTipi.paketServis,
      ),
    ];

    final sonuc = MutfakOperasyonHesaplayici.ozetHesapla(
      siparisler: siparisler,
      simdi: simdi,
    );

    expect(sonuc.siparisTahminleri.length, 3);
    expect(sonuc.gecikenSiparisSayisi, 1);
    expect(sonuc.gecikmeUyarilari.first.siparisNo, 'S-1');
    expect(sonuc.toplamKalanDakika, greaterThan(0));
    expect(sonuc.ortalamaKalanDakika, greaterThan(0));
    expect(
      sonuc.istasyonYukleri.any((istasyon) => istasyon.istasyonAdi == 'Firin'),
      isTrue,
    );
    expect(
      sonuc.istasyonYukleri.any((istasyon) => istasyon.istasyonAdi == 'Izgara'),
      isTrue,
    );
  });
}

SiparisVarligi _siparis({
  required String id,
  required String siparisNo,
  required SiparisDurumu durum,
  required List<String> urunAdlari,
  required DateTime olusturmaTarihi,
  required TeslimatTipi teslimatTipi,
}) {
  return SiparisVarligi(
    id: id,
    siparisNo: siparisNo,
    sahip: const SiparisSahibiVarligi.misafir(
      MisafirBilgisiVarligi(adSoyad: 'Test', telefon: '5550000000'),
    ),
    teslimatTipi: teslimatTipi,
    durum: durum,
    kalemler: urunAdlari
        .asMap()
        .entries
        .map(
          (kayit) => SiparisKalemiVarligi(
            id: 'kalem_${kayit.key}',
            urunId: 'urun_${kayit.key}',
            urunAdi: kayit.value,
            birimFiyat: 100,
            adet: 1,
          ),
        )
        .toList(),
    olusturmaTarihi: olusturmaTarihi,
  );
}
