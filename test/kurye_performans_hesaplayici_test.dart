import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/raporlar/uygulama/servisler/kurye_performans_hesaplayici.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

void main() {
  test('KuryePerformansHesaplayici temel metrikleri dogru hesaplar', () {
    final DateTime simdi = DateTime(2026, 4, 10, 12, 0);
    final List<SiparisVarligi> siparisler = <SiparisVarligi>[
      _siparis(
        id: 's1',
        durum: SiparisDurumu.teslimEdildi,
        kuryeAdi: 'Emre Kurye',
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 40)),
      ),
      _siparis(
        id: 's2',
        durum: SiparisDurumu.teslimEdildi,
        kuryeAdi: 'Emre Kurye',
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 60)),
      ),
      _siparis(
        id: 's3',
        durum: SiparisDurumu.iptalEdildi,
        kuryeAdi: 'Emre Kurye',
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 80)),
      ),
      _siparis(
        id: 's4',
        durum: SiparisDurumu.teslimEdildi,
        kuryeAdi: 'Ayse Kurye',
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 30)),
      ),
      _siparis(
        id: 's5',
        durum: SiparisDurumu.yolda,
        kuryeAdi: 'Ayse Kurye',
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 20)),
      ),
      _siparis(
        id: 's6',
        durum: SiparisDurumu.hazir,
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 15)),
      ),
      _siparis(
        id: 's7',
        teslimatTipi: TeslimatTipi.restorandaYe,
        durum: SiparisDurumu.teslimEdildi,
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 20)),
      ),
    ];

    final ozet = KuryePerformansHesaplayici.ozetHesapla(
      siparisler: siparisler,
      simdi: simdi,
    );

    expect(ozet.toplamPaketSiparisi, 6);
    expect(ozet.aktifPaketSiparisi, 2);
    expect(ozet.teslimEdilenSiparisSayisi, 3);
    expect(ozet.iptalEdilenSiparisSayisi, 1);
    expect(ozet.yoldaSiparisSayisi, 1);
    expect(ozet.kuryeBekleyenSiparisSayisi, 1);
    expect(ozet.aktifKuryeSayisi, 1);
    expect(ozet.teslimatBasariOrani, closeTo(0.75, 0.001));
    expect(ozet.ortalamaTeslimatSuresi.inMinutes, 43);
    expect(ozet.kuryeBasinaTamamlananSiparis, closeTo(1.5, 0.001));
    expect(ozet.kuryeSiralamasi.first.kuryeAdi, 'Emre Kurye');
    expect(ozet.kuryeSiralamasi.first.tamamlananSiparisSayisi, 2);
  });

  test(
    'KuryePerformansHesaplayici bolge yogunlugunu aktif siparislere gore verir',
    () {
      final DateTime simdi = DateTime(2026, 4, 10, 12, 0);
      final List<SiparisVarligi> siparisler = <SiparisVarligi>[
        _siparis(
          id: 'b1',
          durum: SiparisDurumu.yolda,
          kuryeAdi: 'Kurye A',
          adresMetni: 'Ataturk Mah. 1, Kadikoy/Istanbul',
          olusturmaTarihi: simdi.subtract(const Duration(minutes: 25)),
        ),
        _siparis(
          id: 'b2',
          durum: SiparisDurumu.hazirlaniyor,
          kuryeAdi: 'Kurye B',
          adresMetni: 'Moda Caddesi 2, Kadikoy/Istanbul',
          olusturmaTarihi: simdi.subtract(const Duration(minutes: 18)),
        ),
        _siparis(
          id: 'b3',
          durum: SiparisDurumu.hazir,
          kuryeAdi: 'Kurye C',
          adresMetni: 'Sinanpasa Mah. 8, Besiktas/Istanbul',
          olusturmaTarihi: simdi.subtract(const Duration(minutes: 12)),
        ),
        _siparis(
          id: 'b4',
          durum: SiparisDurumu.teslimEdildi,
          kuryeAdi: 'Kurye D',
          adresMetni: 'Sahil Yolu, Kartal/Istanbul',
          olusturmaTarihi: simdi.subtract(const Duration(minutes: 50)),
        ),
      ];

      final ozet = KuryePerformansHesaplayici.ozetHesapla(
        siparisler: siparisler,
        simdi: simdi,
      );

      expect(ozet.bolgeYogunlukleri, isNotEmpty);
      expect(ozet.bolgeYogunlukleri.first.bolgeEtiketi, 'Kadikoy');
      expect(ozet.bolgeYogunlukleri.first.siparisSayisi, 2);
      expect(ozet.bolgeYogunlukleri.first.yogunlukOrani, closeTo(2 / 3, 0.001));
    },
  );
}

SiparisVarligi _siparis({
  required String id,
  required SiparisDurumu durum,
  required DateTime olusturmaTarihi,
  TeslimatTipi teslimatTipi = TeslimatTipi.paketServis,
  String? kuryeAdi,
  String? adresMetni,
}) {
  return SiparisVarligi(
    id: id,
    siparisNo: 'S-$id',
    sahip: const SiparisSahibiVarligi.misafir(
      MisafirBilgisiVarligi(adSoyad: 'Misafir', telefon: '5550000000'),
    ),
    teslimatTipi: teslimatTipi,
    durum: durum,
    kalemler: const <SiparisKalemiVarligi>[
      SiparisKalemiVarligi(
        id: 'kalem',
        urunId: 'urun',
        urunAdi: 'Test urunu',
        birimFiyat: 100,
        adet: 1,
      ),
    ],
    olusturmaTarihi: olusturmaTarihi,
    kuryeAdi: kuryeAdi,
    adresMetni: adresMetni,
  );
}
