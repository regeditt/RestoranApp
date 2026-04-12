import 'package:restoran_app/ozellikler/raporlar/alan/varliklar/kurye_performans_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

class KuryePerformansHesaplayici {
  static const String _atanmadiEtiketi = 'Atanmadi';
  static const String _adresBelirsizEtiketi = 'Adres belirsiz';

  static KuryePerformansOzetiVarligi ozetHesapla({
    required List<SiparisVarligi> siparisler,
    DateTime? simdi,
  }) {
    final DateTime anlikZaman = simdi ?? DateTime.now();
    final List<SiparisVarligi> paketSiparisleri = siparisler
        .where(
          (SiparisVarligi siparis) =>
              siparis.teslimatTipi == TeslimatTipi.paketServis,
        )
        .toList();

    final List<SiparisVarligi> aktifSiparisler = paketSiparisleri
        .where((SiparisVarligi siparis) => _aktifDurumMu(siparis.durum))
        .toList();
    final List<SiparisVarligi> teslimEdilenSiparisler = paketSiparisleri
        .where(
          (SiparisVarligi siparis) =>
              siparis.durum == SiparisDurumu.teslimEdildi,
        )
        .toList();
    final List<SiparisVarligi> iptalEdilenSiparisler = paketSiparisleri
        .where(
          (SiparisVarligi siparis) =>
              siparis.durum == SiparisDurumu.iptalEdildi,
        )
        .toList();
    final List<SiparisVarligi> yoldaSiparisler = paketSiparisleri
        .where((SiparisVarligi siparis) => siparis.durum == SiparisDurumu.yolda)
        .toList();
    final int kuryeBekleyenSiparisSayisi =
        aktifSiparisler.length - yoldaSiparisler.length;

    final _KuryeToplamlariSonucu kuryeToplamlari = _kuryeToplamlariniHesapla(
      siparisler: paketSiparisleri,
      anlikZaman: anlikZaman,
    );
    final List<KuryePerformansSatiriVarligi> kuryeSiralamasi =
        kuryeToplamlari.siralanmisKuryePerformansi;

    final Set<String> aktifKuryeAdlari = <String>{};
    for (final SiparisVarligi siparis in aktifSiparisler) {
      final String? kuryeAdi = _kuryeAdiTemizle(siparis.kuryeAdi);
      if (kuryeAdi != null) {
        aktifKuryeAdlari.add(kuryeAdi);
      }
    }

    final List<KuryeBolgeYogunlukVarligi> bolgeYogunlukleri =
        _bolgeYogunlugunuHesapla(aktifSiparisler);
    final int tamamlananDegerlendirilenSiparisSayisi =
        teslimEdilenSiparisler.length + iptalEdilenSiparisler.length;
    final double teslimatBasariOrani =
        tamamlananDegerlendirilenSiparisSayisi == 0
        ? 0
        : teslimEdilenSiparisler.length /
              tamamlananDegerlendirilenSiparisSayisi;
    final Duration ortalamaTeslimatSuresi = _ortalamaTeslimatSuresiHesapla(
      teslimEdilenSiparisler: teslimEdilenSiparisler,
      anlikZaman: anlikZaman,
    );

    final int aktifAtananKuryeSayisi = aktifKuryeAdlari.length;
    final int siralamadakiKuryeSayisi = kuryeSiralamasi
        .where(
          (KuryePerformansSatiriVarligi satir) =>
              satir.kuryeAdi != _atanmadiEtiketi,
        )
        .length;
    final int ortalamaIcinKuryeSayisi = siralamadakiKuryeSayisi == 0
        ? 1
        : siralamadakiKuryeSayisi;
    final double kuryeBasinaTamamlananSiparis =
        teslimEdilenSiparisler.length / ortalamaIcinKuryeSayisi;

    return KuryePerformansOzetiVarligi(
      toplamPaketSiparisi: paketSiparisleri.length,
      aktifPaketSiparisi: aktifSiparisler.length,
      teslimEdilenSiparisSayisi: teslimEdilenSiparisler.length,
      iptalEdilenSiparisSayisi: iptalEdilenSiparisler.length,
      yoldaSiparisSayisi: yoldaSiparisler.length,
      kuryeBekleyenSiparisSayisi: kuryeBekleyenSiparisSayisi < 0
          ? 0
          : kuryeBekleyenSiparisSayisi,
      aktifKuryeSayisi: aktifAtananKuryeSayisi,
      teslimatBasariOrani: teslimatBasariOrani,
      ortalamaTeslimatSuresi: ortalamaTeslimatSuresi,
      kuryeBasinaTamamlananSiparis: kuryeBasinaTamamlananSiparis,
      bolgeYogunlukleri: bolgeYogunlukleri,
      kuryeSiralamasi: kuryeSiralamasi,
    );
  }

  static _KuryeToplamlariSonucu _kuryeToplamlariniHesapla({
    required List<SiparisVarligi> siparisler,
    required DateTime anlikZaman,
  }) {
    final Map<String, _KuryeToplamlari> harita = <String, _KuryeToplamlari>{};

    for (final SiparisVarligi siparis in siparisler) {
      final String kuryeAdi =
          _kuryeAdiTemizle(siparis.kuryeAdi) ?? _atanmadiEtiketi;
      final _KuryeToplamlari toplamlar = harita.putIfAbsent(
        kuryeAdi,
        () => _KuryeToplamlari(),
      );
      if (_aktifDurumMu(siparis.durum)) {
        toplamlar.aktifSiparisSayisi++;
      }
      if (siparis.durum == SiparisDurumu.teslimEdildi) {
        toplamlar.tamamlananSiparisSayisi++;
        toplamlar.toplamTeslimatDakikasi += _siparisYasiDakika(
          siparis: siparis,
          anlikZaman: anlikZaman,
        );
      }
      if (siparis.durum == SiparisDurumu.iptalEdildi) {
        toplamlar.iptalSiparisSayisi++;
      }
    }

    final List<KuryePerformansSatiriVarligi> satirlar =
        harita.entries.map((MapEntry<String, _KuryeToplamlari> kayit) {
          final _KuryeToplamlari toplamlar = kayit.value;
          final int degerlendirilenSiparisSayisi =
              toplamlar.tamamlananSiparisSayisi + toplamlar.iptalSiparisSayisi;
          final double basariOrani = degerlendirilenSiparisSayisi == 0
              ? 0
              : toplamlar.tamamlananSiparisSayisi /
                    degerlendirilenSiparisSayisi;
          final Duration ortalamaTeslimatSuresi =
              toplamlar.tamamlananSiparisSayisi == 0
              ? Duration.zero
              : Duration(
                  minutes:
                      (toplamlar.toplamTeslimatDakikasi /
                              toplamlar.tamamlananSiparisSayisi)
                          .round(),
                );

          return KuryePerformansSatiriVarligi(
            kuryeAdi: kayit.key,
            aktifSiparisSayisi: toplamlar.aktifSiparisSayisi,
            tamamlananSiparisSayisi: toplamlar.tamamlananSiparisSayisi,
            iptalSiparisSayisi: toplamlar.iptalSiparisSayisi,
            basariOrani: basariOrani,
            ortalamaTeslimatSuresi: ortalamaTeslimatSuresi,
          );
        }).toList()..sort((a, b) {
          final int tamamlanan = b.tamamlananSiparisSayisi.compareTo(
            a.tamamlananSiparisSayisi,
          );
          if (tamamlanan != 0) {
            return tamamlanan;
          }
          final int basari = b.basariOrani.compareTo(a.basariOrani);
          if (basari != 0) {
            return basari;
          }
          final int aktif = b.aktifSiparisSayisi.compareTo(
            a.aktifSiparisSayisi,
          );
          if (aktif != 0) {
            return aktif;
          }
          return a.kuryeAdi.toLowerCase().compareTo(b.kuryeAdi.toLowerCase());
        });

    return _KuryeToplamlariSonucu(siralanmisKuryePerformansi: satirlar);
  }

  static List<KuryeBolgeYogunlukVarligi> _bolgeYogunlugunuHesapla(
    List<SiparisVarligi> aktifSiparisler,
  ) {
    final Map<String, int> bolgeHaritasi = <String, int>{};
    for (final SiparisVarligi siparis in aktifSiparisler) {
      final String bolgeEtiketi = _bolgeEtiketiBul(siparis.adresMetni);
      bolgeHaritasi.update(
        bolgeEtiketi,
        (int mevcut) => mevcut + 1,
        ifAbsent: () => 1,
      );
    }
    if (aktifSiparisler.isEmpty) {
      return const <KuryeBolgeYogunlukVarligi>[];
    }

    final List<KuryeBolgeYogunlukVarligi> sonuc =
        bolgeHaritasi.entries
            .map(
              (MapEntry<String, int> kayit) => KuryeBolgeYogunlukVarligi(
                bolgeEtiketi: kayit.key,
                siparisSayisi: kayit.value,
                yogunlukOrani: kayit.value / aktifSiparisler.length,
              ),
            )
            .toList()
          ..sort((a, b) {
            final int sayiKarsilastirma = b.siparisSayisi.compareTo(
              a.siparisSayisi,
            );
            if (sayiKarsilastirma != 0) {
              return sayiKarsilastirma;
            }
            return a.bolgeEtiketi.toLowerCase().compareTo(
              b.bolgeEtiketi.toLowerCase(),
            );
          });

    return sonuc.take(5).toList();
  }

  static Duration _ortalamaTeslimatSuresiHesapla({
    required List<SiparisVarligi> teslimEdilenSiparisler,
    required DateTime anlikZaman,
  }) {
    if (teslimEdilenSiparisler.isEmpty) {
      return Duration.zero;
    }
    int toplamDakika = 0;
    for (final SiparisVarligi siparis in teslimEdilenSiparisler) {
      toplamDakika += _siparisYasiDakika(
        siparis: siparis,
        anlikZaman: anlikZaman,
      );
    }
    return Duration(
      minutes: (toplamDakika / teslimEdilenSiparisler.length).round(),
    );
  }

  static int _siparisYasiDakika({
    required SiparisVarligi siparis,
    required DateTime anlikZaman,
  }) {
    final int fark = anlikZaman.difference(siparis.olusturmaTarihi).inMinutes;
    return fark < 1 ? 1 : fark;
  }

  static bool _aktifDurumMu(SiparisDurumu durum) {
    return durum == SiparisDurumu.alindi ||
        durum == SiparisDurumu.hazirlaniyor ||
        durum == SiparisDurumu.hazir ||
        durum == SiparisDurumu.yolda;
  }

  static String? _kuryeAdiTemizle(String? hamKuryeAdi) {
    final String? deger = hamKuryeAdi?.trim();
    if (deger == null || deger.isEmpty) {
      return null;
    }
    return deger;
  }

  static String _bolgeEtiketiBul(String? hamAdres) {
    final String? adres = hamAdres?.trim();
    if (adres == null || adres.isEmpty) {
      return _adresBelirsizEtiketi;
    }

    final List<String> parcalar = adres
        .split(',')
        .map((String parca) => parca.trim())
        .where((String parca) => parca.isNotEmpty)
        .toList();
    if (parcalar.isEmpty) {
      return _adresBelirsizEtiketi;
    }

    String aday = parcalar.last;
    if (aday.contains('/')) {
      aday = aday.split('/').first.trim();
    }
    if (aday.isEmpty) {
      aday = parcalar.first;
    }
    if (aday.length > 24) {
      return '${aday.substring(0, 24)}...';
    }
    return aday;
  }
}

class _KuryeToplamlariSonucu {
  const _KuryeToplamlariSonucu({required this.siralanmisKuryePerformansi});

  final List<KuryePerformansSatiriVarligi> siralanmisKuryePerformansi;
}

class _KuryeToplamlari {
  int aktifSiparisSayisi = 0;
  int tamamlananSiparisSayisi = 0;
  int iptalSiparisSayisi = 0;
  int toplamTeslimatDakikasi = 0;
}
