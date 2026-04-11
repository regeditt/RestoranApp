import 'package:restoran_app/ozellikler/odeme_kasa/alan/depolar/odeme_kasa_deposu.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/alan/enumlar/odeme_yontemi.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/alan/varliklar/kasa_hareketi_varligi.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/alan/varliklar/kasa_ozeti_varligi.dart';

class OdemeKasaDeposuMock implements OdemeKasaDeposu {
  OdemeKasaDeposuMock()
    : _hareketler = <KasaHareketiVarligi>[
        KasaHareketiVarligi(
          id: 'ksh_001',
          zaman: DateTime.now().subtract(const Duration(minutes: 6)),
          baslik: 'Salon odemesi',
          detay: 'Masa 4 / S-2401',
          tutar: 1245,
          odemeYontemi: OdemeYontemi.kart,
          tahsilatMi: true,
        ),
        KasaHareketiVarligi(
          id: 'ksh_002',
          zaman: DateTime.now().subtract(const Duration(minutes: 11)),
          baslik: 'Nakit tahsilat',
          detay: 'Masa 1 / S-2398',
          tutar: 820,
          odemeYontemi: OdemeYontemi.nakit,
          tahsilatMi: true,
        ),
        KasaHareketiVarligi(
          id: 'ksh_003',
          zaman: DateTime.now().subtract(const Duration(minutes: 22)),
          baslik: 'Iade islemi',
          detay: 'Paket siparis / S-2396',
          tutar: 180,
          odemeYontemi: OdemeYontemi.online,
          tahsilatMi: false,
        ),
        KasaHareketiVarligi(
          id: 'ksh_004',
          zaman: DateTime.now().subtract(const Duration(minutes: 34)),
          baslik: 'Temassiz odeme',
          detay: 'Masa 6 / S-2395',
          tutar: 560,
          odemeYontemi: OdemeYontemi.temassiz,
          tahsilatMi: true,
        ),
        KasaHareketiVarligi(
          id: 'ksh_005',
          zaman: DateTime.now().subtract(const Duration(hours: 1, minutes: 8)),
          baslik: 'Paket teslim odemesi',
          detay: 'Adres teslim / S-2391',
          tutar: 730,
          odemeYontemi: OdemeYontemi.online,
          tahsilatMi: true,
        ),
      ];

  final List<KasaHareketiVarligi> _hareketler;

  @override
  Future<void> kasaHareketiEkle(KasaHareketiVarligi hareket) async {
    _hareketler.add(hareket);
  }

  @override
  Future<KasaOzetiVarligi> kasaOzetiniGetir({
    DateTime? baslangicTarihi,
    DateTime? bitisTarihi,
  }) async {
    final DateTime? baslangic = baslangicTarihi;
    final DateTime? bitis = bitisTarihi;

    final List<KasaHareketiVarligi> filtreli = _hareketler.where((
      KasaHareketiVarligi hareket,
    ) {
      if (baslangic != null && hareket.zaman.isBefore(baslangic)) {
        return false;
      }
      if (bitis != null && hareket.zaman.isAfter(bitis)) {
        return false;
      }
      return true;
    }).toList()..sort((a, b) => b.zaman.compareTo(a.zaman));

    double nakit = 0;
    double kart = 0;
    double temassiz = 0;
    double online = 0;
    double toplamTahsilat = 0;
    double toplamIade = 0;

    for (final KasaHareketiVarligi hareket in filtreli) {
      if (hareket.tahsilatMi) {
        toplamTahsilat += hareket.tutar;
        switch (hareket.odemeYontemi) {
          case OdemeYontemi.nakit:
            nakit += hareket.tutar;
          case OdemeYontemi.kart:
            kart += hareket.tutar;
          case OdemeYontemi.temassiz:
            temassiz += hareket.tutar;
          case OdemeYontemi.online:
            online += hareket.tutar;
        }
      } else {
        toplamIade += hareket.tutar;
      }
    }

    return KasaOzetiVarligi(
      nakitToplam: nakit,
      kartToplam: kart,
      temassizToplam: temassiz,
      onlineToplam: online,
      toplamTahsilat: toplamTahsilat,
      toplamIade: toplamIade,
      kasaBakiye: toplamTahsilat - toplamIade,
      sonHareketler: filtreli.take(12).toList(),
    );
  }
}
