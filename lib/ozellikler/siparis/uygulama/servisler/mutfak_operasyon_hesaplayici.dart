import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/mutfak_operasyon_varliklari.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

class MutfakOperasyonHesaplayici {
  static const String _istasyonGenel = 'Genel';

  static MutfakOperasyonOzetiVarligi ozetHesapla({
    required List<SiparisVarligi> siparisler,
    DateTime? simdi,
  }) {
    final DateTime anlik = simdi ?? DateTime.now();
    final Map<String, MutfakSiparisTahminiVarligi> tahminler =
        <String, MutfakSiparisTahminiVarligi>{};
    final Map<String, _IstasyonToplami> istasyonHaritasi =
        <String, _IstasyonToplami>{};
    final List<MutfakGecikmeUyarisiVarligi> uyarilar =
        <MutfakGecikmeUyarisiVarligi>[];

    int toplamKalanDakika = 0;
    int aktifSiparisSayisi = 0;
    int gecikenSiparisSayisi = 0;

    for (final SiparisVarligi siparis in siparisler) {
      if (!_aktifDurumMu(siparis.durum)) {
        continue;
      }
      aktifSiparisSayisi++;

      final int beklemeDakikasi = _beklemeDakikasi(siparis, anlik);
      final int hedefDakika = _hedefHazirlikDakikasi(siparis);
      final int gecikmeDakikasi = beklemeDakikasi - hedefDakika;
      final bool gecikiyorMu = gecikmeDakikasi > 0;
      final int kalanDakika = gecikiyorMu ? 1 : (hedefDakika - beklemeDakikasi);
      final String istasyonAdi = _istasyonAdiBelirle(siparis);

      tahminler[siparis.id] = MutfakSiparisTahminiVarligi(
        siparisId: siparis.id,
        istasyonAdi: istasyonAdi,
        hedefHazirlikDakikasi: hedefDakika,
        kalanDakika: kalanDakika,
        gecikmeDakikasi: gecikiyorMu ? gecikmeDakikasi : 0,
        gecikiyorMu: gecikiyorMu,
      );

      toplamKalanDakika += kalanDakika;
      final _IstasyonToplami istasyonToplami = istasyonHaritasi.putIfAbsent(
        istasyonAdi,
        () => _IstasyonToplami(),
      );
      istasyonToplami.aktifSiparisSayisi++;
      istasyonToplami.toplamKalanDakika += kalanDakika;

      if (gecikiyorMu) {
        gecikenSiparisSayisi++;
        uyarilar.add(
          MutfakGecikmeUyarisiVarligi(
            siparisId: siparis.id,
            siparisNo: siparis.siparisNo,
            istasyonAdi: istasyonAdi,
            gecikmeDakikasi: gecikmeDakikasi,
          ),
        );
      }
    }

    final List<MutfakIstasyonYukuVarligi> istasyonYukleri =
        istasyonHaritasi.entries
            .map(
              (MapEntry<String, _IstasyonToplami> kayit) =>
                  MutfakIstasyonYukuVarligi(
                    istasyonAdi: kayit.key,
                    aktifSiparisSayisi: kayit.value.aktifSiparisSayisi,
                    toplamKalanDakika: kayit.value.toplamKalanDakika,
                  ),
            )
            .toList()
          ..sort((a, b) {
            final int siparisKarsilastirma = b.aktifSiparisSayisi.compareTo(
              a.aktifSiparisSayisi,
            );
            if (siparisKarsilastirma != 0) {
              return siparisKarsilastirma;
            }
            final int sureKarsilastirma = b.toplamKalanDakika.compareTo(
              a.toplamKalanDakika,
            );
            if (sureKarsilastirma != 0) {
              return sureKarsilastirma;
            }
            return a.istasyonAdi.toLowerCase().compareTo(
              b.istasyonAdi.toLowerCase(),
            );
          });

    uyarilar.sort((a, b) => b.gecikmeDakikasi.compareTo(a.gecikmeDakikasi));

    final int ortalamaKalanDakika = aktifSiparisSayisi == 0
        ? 0
        : (toplamKalanDakika / aktifSiparisSayisi).round();

    return MutfakOperasyonOzetiVarligi(
      toplamKalanDakika: toplamKalanDakika,
      ortalamaKalanDakika: ortalamaKalanDakika,
      gecikenSiparisSayisi: gecikenSiparisSayisi,
      siparisTahminleri: tahminler,
      gecikmeUyarilari: uyarilar,
      istasyonYukleri: istasyonYukleri,
    );
  }

  static bool _aktifDurumMu(SiparisDurumu durum) {
    return switch (durum) {
      SiparisDurumu.alindi => true,
      SiparisDurumu.hazirlaniyor => true,
      SiparisDurumu.hazir => true,
      SiparisDurumu.yolda => false,
      SiparisDurumu.teslimEdildi => false,
      SiparisDurumu.iptalEdildi => false,
    };
  }

  static int _beklemeDakikasi(SiparisVarligi siparis, DateTime simdi) {
    return simdi.difference(siparis.olusturmaTarihi).inMinutes.clamp(0, 180);
  }

  static int _hedefHazirlikDakikasi(SiparisVarligi siparis) {
    final int temelDakika = switch (siparis.durum) {
      SiparisDurumu.alindi => 18,
      SiparisDurumu.hazirlaniyor => 14,
      SiparisDurumu.hazir => 5,
      SiparisDurumu.yolda => 2,
      SiparisDurumu.teslimEdildi => 0,
      SiparisDurumu.iptalEdildi => 0,
    };
    if (temelDakika == 0) {
      return 0;
    }

    int kalemKatsayisi = 0;
    for (final kalem in siparis.kalemler) {
      kalemKatsayisi += kalem.adet.clamp(1, 6);
    }

    final int kanalKatsayisi = switch (siparis.teslimatTipi) {
      TeslimatTipi.restorandaYe => 0,
      TeslimatTipi.gelAl => 2,
      TeslimatTipi.paketServis => 4,
    };

    final int hedef = temelDakika + (kalemKatsayisi * 2) + kanalKatsayisi;
    return hedef.clamp(5, 90);
  }

  static String _istasyonAdiBelirle(SiparisVarligi siparis) {
    final String metin = siparis.kalemler
        .map((kalem) => kalem.urunAdi.toLowerCase())
        .join(' ');
    if (metin.isEmpty) {
      return _istasyonGenel;
    }
    if (_eslesenAnahtarVar(metin, <String>[
      'pizza',
      'firin',
      'pide',
      'lahmacun',
      'ekmek',
    ])) {
      return 'Firin';
    }
    if (_eslesenAnahtarVar(metin, <String>[
      'izgara',
      'kebap',
      'tavuk',
      'et',
      'doner',
      'kasarli',
    ])) {
      return 'Izgara';
    }
    if (_eslesenAnahtarVar(metin, <String>[
      'salata',
      'soguk',
      'meze',
      'sushi',
      'wrap',
    ])) {
      return 'Soguk';
    }
    if (_eslesenAnahtarVar(metin, <String>[
      'corba',
      'makarna',
      'pilav',
      'sote',
      'burger',
      'tost',
    ])) {
      return 'Sicak';
    }
    return _istasyonGenel;
  }

  static bool _eslesenAnahtarVar(String metin, List<String> anahtarlar) {
    for (final String anahtar in anahtarlar) {
      if (metin.contains(anahtar)) {
        return true;
      }
    }
    return false;
  }
}

class _IstasyonToplami {
  int aktifSiparisSayisi = 0;
  int toplamKalanDakika = 0;
}
