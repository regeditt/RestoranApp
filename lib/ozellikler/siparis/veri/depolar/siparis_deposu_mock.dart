import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';

class SiparisDeposuMock implements SiparisDeposu {
  final List<SiparisVarligi> _siparisler = <SiparisVarligi>[
    SiparisVarligi(
      id: 'sip_mock_001',
      siparisNo: 'R-4821',
      sahip: SiparisSahibiVarligi.misafir(
        const MisafirBilgisiVarligi(
          adSoyad: 'Asli Demir',
          telefon: '5551112233',
        ),
      ),
      teslimatTipi: TeslimatTipi.restorandaYe,
      durum: SiparisDurumu.hazirlaniyor,
      masaNo: '3',
      bolumAdi: 'Salon',
      kalemler: const [
        SiparisKalemiVarligi(
          id: 'kal_001',
          urunId: 'urn_001',
          urunAdi: 'Klasik Burger',
          birimFiyat: 245,
          adet: 2,
        ),
        SiparisKalemiVarligi(
          id: 'kal_002',
          urunId: 'urn_004',
          urunAdi: 'Limonata',
          birimFiyat: 95,
          adet: 2,
        ),
      ],
      olusturmaTarihi: DateTime(2026, 3, 25, 13, 5),
    ),
    SiparisVarligi(
      id: 'sip_mock_002',
      siparisNo: 'R-4822',
      sahip: SiparisSahibiVarligi.misafir(
        const MisafirBilgisiVarligi(
          adSoyad: 'Mert Kaya',
          telefon: '5554448899',
        ),
      ),
      teslimatTipi: TeslimatTipi.gelAl,
      durum: SiparisDurumu.hazir,
      kalemler: const [
        SiparisKalemiVarligi(
          id: 'kal_003',
          urunId: 'urn_003',
          urunAdi: 'Margarita Pizza',
          birimFiyat: 310,
          adet: 1,
        ),
        SiparisKalemiVarligi(
          id: 'kal_004',
          urunId: 'urn_005',
          urunAdi: 'San Sebastian',
          birimFiyat: 175,
          adet: 1,
        ),
      ],
      olusturmaTarihi: DateTime(2026, 3, 25, 13, 12),
    ),
    SiparisVarligi(
      id: 'sip_mock_003',
      siparisNo: 'R-4823',
      sahip: SiparisSahibiVarligi.misafir(
        const MisafirBilgisiVarligi(
          adSoyad: 'Cansu Yildiz',
          telefon: '5559981122',
        ),
      ),
      teslimatTipi: TeslimatTipi.paketServis,
      durum: SiparisDurumu.yolda,
      kalemler: const [
        SiparisKalemiVarligi(
          id: 'kal_005',
          urunId: 'urn_002',
          urunAdi: 'Dumanli Burger',
          birimFiyat: 285,
          adet: 2,
        ),
      ],
      olusturmaTarihi: DateTime(2026, 3, 25, 13, 18),
      adresMetni: 'Ataturk Mah. 14. Sok. No:7',
    ),
  ];

  @override
  Future<SiparisVarligi?> siparisGetir(String siparisId) async {
    try {
      return _siparisler.firstWhere((siparis) => siparis.id == siparisId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SiparisVarligi> siparisOlustur(SiparisVarligi siparis) async {
    final SiparisVarligi kaydedilenSiparis = SiparisVarligi(
      id: siparis.id,
      siparisNo: siparis.siparisNo,
      sahip: siparis.sahip,
      teslimatTipi: siparis.teslimatTipi,
      durum: SiparisDurumu.alindi,
      kalemler: siparis.kalemler,
      olusturmaTarihi: siparis.olusturmaTarihi,
      adresMetni: siparis.adresMetni,
      masaNo: siparis.masaNo,
      bolumAdi: siparis.bolumAdi,
      kaynak: siparis.kaynak,
    );

    _siparisler.add(kaydedilenSiparis);
    return kaydedilenSiparis;
  }

  @override
  Future<List<SiparisVarligi>> siparisleriGetir() async {
    return _siparisler;
  }
}
