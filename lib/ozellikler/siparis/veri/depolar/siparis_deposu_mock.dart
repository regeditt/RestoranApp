import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/paket_teslimat_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/veri/depolar/siparis_durumu_yardimcisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';

class SiparisDeposuMock implements SiparisDeposu {
  late final List<SiparisVarligi> _siparisler = _baslangicSiparisleriOlustur();

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
      teslimatNotu: siparis.teslimatNotu,
      kuryeAdi: siparis.kuryeAdi,
      paketTeslimatDurumu: siparis.paketTeslimatDurumu,
      masaNo: siparis.masaNo,
      bolumAdi: siparis.bolumAdi,
      kaynak: siparis.kaynak,
    );

    _siparisler.add(kaydedilenSiparis);
    return kaydedilenSiparis;
  }

  @override
  Future<SiparisVarligi> siparisDurumuGuncelle(
    String siparisId,
    SiparisDurumu yeniDurum, {
    String? kuryeAdi,
  }) async {
    final int index = _siparisler.indexWhere(
      (SiparisVarligi siparis) => siparis.id == siparisId,
    );
    if (index < 0) {
      throw StateError('Siparis bulunamadi');
    }
    final PaketServisDurumGuncellemesi durumGuncellemesi =
        paketServisDurumGuncellemesiniHesapla(
          _siparisler[index],
          yeniDurum,
          kuryeAdi: kuryeAdi,
        );

    final SiparisVarligi guncelSiparis = _siparisler[index].copyWith(
      durum: yeniDurum,
      paketTeslimatDurumu: durumGuncellemesi.paketTeslimatDurumu,
      kuryeAdi: durumGuncellemesi.kuryeAdi,
    );
    _siparisler[index] = guncelSiparis;
    return guncelSiparis;
  }

  @override
  Future<List<SiparisVarligi>> siparisleriGetir() async {
    return _siparisler;
  }

  List<SiparisVarligi> _baslangicSiparisleriOlustur() {
    final DateTime simdi = DateTime.now();
    return <SiparisVarligi>[
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
        durum: SiparisDurumu.alindi,
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
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 8)),
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
        durum: SiparisDurumu.hazirlaniyor,
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
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 16)),
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
        durum: SiparisDurumu.hazir,
        kalemler: const [
          SiparisKalemiVarligi(
            id: 'kal_005',
            urunId: 'urn_002',
            urunAdi: 'Dumanli Burger',
            birimFiyat: 285,
            adet: 2,
          ),
        ],
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 22)),
        adresMetni: 'Ataturk Mah. 14. Sok. No:7',
        teslimatNotu: 'Site girisinde guvenlige bilgi ver',
        paketTeslimatDurumu: PaketTeslimatDurumu.kuryeBekliyor,
      ),
      SiparisVarligi(
        id: 'sip_mock_004',
        siparisNo: 'R-4824',
        sahip: SiparisSahibiVarligi.misafir(
          const MisafirBilgisiVarligi(
            adSoyad: 'Deniz Arslan',
            telefon: '5557721144',
          ),
        ),
        teslimatTipi: TeslimatTipi.restorandaYe,
        durum: SiparisDurumu.hazir,
        masaNo: '12',
        bolumAdi: 'Teras',
        kalemler: const [
          SiparisKalemiVarligi(
            id: 'kal_006',
            urunId: 'urn_006',
            urunAdi: 'Tavuklu Makarna',
            birimFiyat: 255,
            adet: 1,
          ),
          SiparisKalemiVarligi(
            id: 'kal_007',
            urunId: 'urn_007',
            urunAdi: 'Ayran',
            birimFiyat: 55,
            adet: 2,
          ),
        ],
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 11)),
      ),
      SiparisVarligi(
        id: 'sip_mock_005',
        siparisNo: 'R-4825',
        sahip: SiparisSahibiVarligi.misafir(
          const MisafirBilgisiVarligi(
            adSoyad: 'Zeynep Koc',
            telefon: '5556304182',
          ),
        ),
        teslimatTipi: TeslimatTipi.paketServis,
        durum: SiparisDurumu.yolda,
        kalemler: const [
          SiparisKalemiVarligi(
            id: 'kal_008',
            urunId: 'urn_008',
            urunAdi: 'Karisik Pizza',
            birimFiyat: 340,
            adet: 1,
          ),
        ],
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 28)),
        adresMetni: 'Cumhuriyet Cad. No:52 D:4',
        teslimatNotu: 'Kapi ziline basmadan telefon et',
        kuryeAdi: 'Emre Kurye',
        paketTeslimatDurumu: PaketTeslimatDurumu.kuryeYolda,
      ),
    ];
  }
}
