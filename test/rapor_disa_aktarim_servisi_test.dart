import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/raporlar/uygulama/servisler/rapor_disa_aktarim_servisi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

void main() {
  test(
    'RaporDisaAktarimServisi gunluk CSVde indirim ve net kolonlarini yazar',
    () {
      const RaporDisaAktarimServisi servis = RaporDisaAktarimServisi();
      final List<SiparisVarligi> siparisler = <SiparisVarligi>[
        _siparisOlustur(
          id: 's1',
          siparisNo: 'S1',
          tarih: DateTime(2026, 4, 10, 11, 30),
          brut: 100,
          indirim: 10,
          kuponKodu: 'INDIRIM10',
          aydinlatmaOnayi: true,
          ticariIletisimOnayi: false,
        ),
        _siparisOlustur(
          id: 's2',
          siparisNo: 'S2',
          tarih: DateTime(2026, 4, 10, 15, 20),
          brut: 50,
          indirim: 0,
          aydinlatmaOnayi: true,
          ticariIletisimOnayi: true,
        ),
        _siparisOlustur(
          id: 's3',
          siparisNo: 'S3',
          tarih: DateTime(2026, 4, 11, 9, 10),
          brut: 80,
          indirim: 8,
          kuponKodu: 'HOSGELDIN',
          aydinlatmaOnayi: true,
          ticariIletisimOnayi: true,
        ),
      ];

      final String csv = servis.csvMetniOlustur(
        siparisler: siparisler,
        aylik: false,
      );

      expect(
        csv,
        contains(
          'Donem;Siparis adedi;Brut ciro;Kampanya indirimi;Net ciro;Kuponlu siparis;KVKK onayli;Iletisim izinli',
        ),
      );
      expect(csv, contains('2026-04-10;2;150.00;10.00;140.00;1;2;1'));
      expect(csv, contains('2026-04-11;1;80.00;8.00;72.00;1;1;1'));
      expect(csv, contains('Toplam;3;230.00;18.00;212.00;2;3;2'));
    },
  );

  test(
    'RaporDisaAktarimServisi aylik CSVde ay bazli toplamlari birlestirir',
    () {
      const RaporDisaAktarimServisi servis = RaporDisaAktarimServisi();
      final List<SiparisVarligi> siparisler = <SiparisVarligi>[
        _siparisOlustur(
          id: 's1',
          siparisNo: 'S1',
          tarih: DateTime(2026, 4, 10, 11, 30),
          brut: 120,
          indirim: 20,
          kuponKodu: 'VIP20',
          aydinlatmaOnayi: true,
          ticariIletisimOnayi: false,
        ),
        _siparisOlustur(
          id: 's2',
          siparisNo: 'S2',
          tarih: DateTime(2026, 4, 28, 18, 00),
          brut: 80,
          indirim: 0,
          aydinlatmaOnayi: true,
          ticariIletisimOnayi: true,
        ),
        _siparisOlustur(
          id: 's3',
          siparisNo: 'S3',
          tarih: DateTime(2026, 5, 2, 9, 10),
          brut: 60,
          indirim: 6,
          kuponKodu: 'MAYIS10',
          aydinlatmaOnayi: true,
          ticariIletisimOnayi: true,
        ),
      ];

      final String csv = servis.csvMetniOlustur(
        siparisler: siparisler,
        aylik: true,
      );

      expect(csv, contains('2026-04;2;200.00;20.00;180.00;1;2;1'));
      expect(csv, contains('2026-05;1;60.00;6.00;54.00;1;1;1'));
      expect(csv, contains('Toplam;3;260.00;26.00;234.00;2;3;2'));
    },
  );
}

SiparisVarligi _siparisOlustur({
  required String id,
  required String siparisNo,
  required DateTime tarih,
  required double brut,
  required double indirim,
  String? kuponKodu,
  bool aydinlatmaOnayi = false,
  bool ticariIletisimOnayi = false,
}) {
  return SiparisVarligi(
    id: id,
    siparisNo: siparisNo,
    sahip: const SiparisSahibiVarligi.misafir(
      MisafirBilgisiVarligi(adSoyad: 'Test Musteri', telefon: '5550000000'),
    ),
    teslimatTipi: TeslimatTipi.gelAl,
    durum: SiparisDurumu.teslimEdildi,
    kalemler: <SiparisKalemiVarligi>[
      SiparisKalemiVarligi(
        id: 'k_$id',
        urunId: 'u_$id',
        urunAdi: 'Test Urun',
        birimFiyat: brut,
        adet: 1,
      ),
    ],
    olusturmaTarihi: tarih,
    kuponKodu: kuponKodu,
    indirimTutari: indirim,
    aydinlatmaOnayi: aydinlatmaOnayi,
    ticariIletisimOnayi: ticariIletisimOnayi,
  );
}
