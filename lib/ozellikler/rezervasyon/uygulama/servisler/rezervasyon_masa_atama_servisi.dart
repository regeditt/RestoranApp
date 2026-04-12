import 'package:restoran_app/ozellikler/rezervasyon/alan/varliklar/rezervasyon_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

class RezervasyonMasaAtamaSonucu {
  const RezervasyonMasaAtamaSonucu({
    required this.bolumId,
    required this.bolumAdi,
    required this.masaId,
    required this.masaAdi,
  });

  final String bolumId;
  final String bolumAdi;
  final String masaId;
  final String masaAdi;
}

class RezervasyonMasaAtamaServisi {
  const RezervasyonMasaAtamaServisi();

  RezervasyonMasaAtamaSonucu? uygunMasaBul({
    required int kisiSayisi,
    required DateTime baslangicZamani,
    required DateTime bitisZamani,
    required List<SalonBolumuVarligi> salonBolumleri,
    required List<RezervasyonVarligi> mevcutRezervasyonlar,
    String? tercihBolumId,
    String? haricRezervasyonId,
  }) {
    final List<({String bolumId, String bolumAdi, MasaTanimiVarligi masa})>
    adaylar = <({String bolumId, String bolumAdi, MasaTanimiVarligi masa})>[];

    for (final SalonBolumuVarligi bolum in salonBolumleri) {
      for (final MasaTanimiVarligi masa in bolum.masalar) {
        if (masa.kapasite < kisiSayisi) {
          continue;
        }
        adaylar.add((bolumId: bolum.id, bolumAdi: bolum.ad, masa: masa));
      }
    }

    adaylar.sort((sol, sag) {
      final bool solTercihli =
          tercihBolumId != null && sol.bolumId == tercihBolumId;
      final bool sagTercihli =
          tercihBolumId != null && sag.bolumId == tercihBolumId;
      if (solTercihli != sagTercihli) {
        return solTercihli ? -1 : 1;
      }
      final int kapasiteKarsilastirma = sol.masa.kapasite.compareTo(
        sag.masa.kapasite,
      );
      if (kapasiteKarsilastirma != 0) {
        return kapasiteKarsilastirma;
      }
      final int bolumKarsilastirma = sol.bolumAdi.compareTo(sag.bolumAdi);
      if (bolumKarsilastirma != 0) {
        return bolumKarsilastirma;
      }
      return sol.masa.ad.compareTo(sag.masa.ad);
    });

    for (final aday in adaylar) {
      final bool cakismaVar = mevcutRezervasyonlar.any((rezervasyon) {
        if (haricRezervasyonId != null &&
            rezervasyon.id == haricRezervasyonId) {
          return false;
        }
        if (!rezervasyon.durum.aktifMi) {
          return false;
        }
        if (rezervasyon.masaId != aday.masa.id) {
          return false;
        }
        return rezervasyon.zamanAraligiCakisiyor(
          baslangic: baslangicZamani,
          bitis: bitisZamani,
        );
      });
      if (cakismaVar) {
        continue;
      }
      return RezervasyonMasaAtamaSonucu(
        bolumId: aday.bolumId,
        bolumAdi: aday.bolumAdi,
        masaId: aday.masa.id,
        masaAdi: aday.masa.ad,
      );
    }
    return null;
  }
}
