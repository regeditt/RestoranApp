import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/patron_raporu_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/saatlik_siparis_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yonetim_paneli_ozeti_varligi.dart';

/// Siparis verilerinden panel ozetleri, saatlik dagilim ve patron metriklerini hesaplar.
class YonetimRaporuHesaplayici {
  const YonetimRaporuHesaplayici._();

  /// Siparis listesinden yonetim paneli icin temel operasyon metriklerini uretir.
  static YonetimPaneliOzetiVarligi panelOzetiniHesapla(
    List<SiparisVarligi> siparisler,
  ) {
    int hazirlanan = 0;
    int hazir = 0;
    int yolda = 0;
    int restorandaYe = 0;
    int gelAl = 0;
    int paketServis = 0;
    double toplamCiro = 0;
    double toplamIndirim = 0;

    for (final SiparisVarligi siparis in siparisler) {
      toplamCiro += siparis.toplamTutar;
      toplamIndirim += siparis.indirimTutari;

      switch (siparis.durum) {
        case SiparisDurumu.hazirlaniyor:
          hazirlanan++;
        case SiparisDurumu.hazir:
          hazir++;
        case SiparisDurumu.yolda:
          yolda++;
        default:
          break;
      }

      switch (siparis.teslimatTipi) {
        case TeslimatTipi.restorandaYe:
          restorandaYe++;
        case TeslimatTipi.gelAl:
          gelAl++;
        case TeslimatTipi.paketServis:
          paketServis++;
      }
    }

    return YonetimPaneliOzetiVarligi(
      toplamSiparis: siparisler.length,
      toplamCiro: toplamCiro,
      toplamIndirim: toplamIndirim,
      hazirlananSiparis: hazirlanan,
      hazirSiparis: hazir,
      yoldaSiparis: yolda,
      restorandaYeSayisi: restorandaYe,
      gelAlSayisi: gelAl,
      paketServisSayisi: paketServis,
    );
  }

  /// Siparisleri olusturma saatine gore gruplandirip saatlik adet dagilimi cikarir.
  static List<SaatlikSiparisOzetiVarligi> saatlikVeriUret(
    List<SiparisVarligi> siparisler,
  ) {
    if (siparisler.isEmpty) {
      return const <SaatlikSiparisOzetiVarligi>[
        SaatlikSiparisOzetiVarligi(etiket: '00:00', adet: 0),
        SaatlikSiparisOzetiVarligi(etiket: '01:00', adet: 0),
        SaatlikSiparisOzetiVarligi(etiket: '02:00', adet: 0),
      ];
    }

    final List<int> saatler =
        siparisler.map((siparis) => siparis.olusturmaTarihi.hour).toList()
          ..sort();

    final int ilkSaat = saatler.first;
    final int sonSaat = saatler.last;
    final Map<int, int> sayac = <int, int>{};

    for (final SiparisVarligi siparis in siparisler) {
      sayac.update(
        siparis.olusturmaTarihi.hour,
        (deger) => deger + 1,
        ifAbsent: () => 1,
      );
    }

    final List<SaatlikSiparisOzetiVarligi> sonuc =
        <SaatlikSiparisOzetiVarligi>[];
    for (int saat = ilkSaat; saat <= sonSaat; saat++) {
      sonuc.add(
        SaatlikSiparisOzetiVarligi(
          etiket: '${saat.toString().padLeft(2, '0')}:00',
          adet: sayac[saat] ?? 0,
        ),
      );
    }
    return sonuc;
  }

  /// Panel verilerinden patron gorunumu icin ozet KPI metriklerini hesaplar.
  static PatronRaporuOzetiVarligi patronRaporunuHesapla({
    required List<SiparisVarligi> siparisler,
    required List<SaatlikSiparisOzetiVarligi> saatlikVeriler,
  }) {
    if (siparisler.isEmpty) {
      return const PatronRaporuOzetiVarligi(
        ortalamaAdisyon: 0,
        tahminiGunSonuCiro: 0,
        enGucluKanalEtiketi: 'Veri yok',
        enGucluKanalAdedi: 0,
        zirveSaatEtiketi: '--:--',
        zirveSaatAdedi: 0,
        enYuksekSiparisNo: '-',
        enYuksekSiparisTutari: 0,
      );
    }

    final SiparisVarligi enYuksekSiparis = siparisler.reduce(
      (onceki, mevcut) =>
          onceki.toplamTutar >= mevcut.toplamTutar ? onceki : mevcut,
    );

    final SaatlikSiparisOzetiVarligi zirveSaat = saatlikVeriler.isEmpty
        ? const SaatlikSiparisOzetiVarligi(etiket: '--:--', adet: 0)
        : saatlikVeriler.reduce(
            (onceki, mevcut) => onceki.adet >= mevcut.adet ? onceki : mevcut,
          );

    final List<({String etiket, int adet})> kanallar =
        <({String etiket, int adet})>[
          (etiket: 'Restoranda ye', adet: 0),
          (etiket: 'Gel al', adet: 0),
          (etiket: 'Paket servis', adet: 0),
        ];

    for (final SiparisVarligi siparis in siparisler) {
      switch (siparis.teslimatTipi) {
        case TeslimatTipi.restorandaYe:
          kanallar[0] = (
            etiket: kanallar[0].etiket,
            adet: kanallar[0].adet + 1,
          );
        case TeslimatTipi.gelAl:
          kanallar[1] = (
            etiket: kanallar[1].etiket,
            adet: kanallar[1].adet + 1,
          );
        case TeslimatTipi.paketServis:
          kanallar[2] = (
            etiket: kanallar[2].etiket,
            adet: kanallar[2].adet + 1,
          );
      }
    }

    final ({String etiket, int adet}) enGucluKanal = kanallar.reduce(
      (onceki, mevcut) => onceki.adet >= mevcut.adet ? onceki : mevcut,
    );

    final double toplamCiro = siparisler.fold<double>(
      0,
      (double onceki, SiparisVarligi siparis) => onceki + siparis.toplamTutar,
    );
    final double ortalamaAdisyon = toplamCiro / siparisler.length;
    final int aktifSaatSayisi = saatlikVeriler
        .where((veri) => veri.adet > 0)
        .length;
    final double saatlikOrtalama =
        toplamCiro / (aktifSaatSayisi == 0 ? 1 : aktifSaatSayisi);
    final double tahminiGunSonuCiro = saatlikOrtalama * 12;

    return PatronRaporuOzetiVarligi(
      ortalamaAdisyon: ortalamaAdisyon,
      tahminiGunSonuCiro: tahminiGunSonuCiro,
      enGucluKanalEtiketi: enGucluKanal.etiket,
      enGucluKanalAdedi: enGucluKanal.adet,
      zirveSaatEtiketi: zirveSaat.etiket,
      zirveSaatAdedi: zirveSaat.adet,
      enYuksekSiparisNo: enYuksekSiparis.siparisNo,
      enYuksekSiparisTutari: enYuksekSiparis.toplamTutar,
    );
  }
}
