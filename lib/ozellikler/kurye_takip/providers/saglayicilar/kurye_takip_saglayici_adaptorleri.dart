import 'package:restoran_app/ozellikler/kurye_takip/core/soylesmeler/kurye_takip_saglayicisi.dart';
import 'package:restoran_app/ozellikler/kurye_takip/uygulama/servisler/kurye_takip_saglayici_kayit_defteri.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/kurye_takip_entegrasyon_varliklari.dart';

KuryeTakipSaglayiciKayitDefteri varsayilanKuryeTakipSaglayiciKayitDefteri() {
  return KuryeTakipSaglayiciKayitDefteri(
    saglayicilar: const <KuryeTakipSaglayicisi>[
      DahiliGpsKuryeTakipSaglayicisi(),
      TraccarKuryeTakipSaglayicisi(),
      NavixKuryeTakipSaglayicisi(),
      OzelApiKuryeTakipSaglayicisi(),
      ArventoKuryeTakipSaglayicisi(),
      MobilizKuryeTakipSaglayicisi(),
      SeyirMobilKuryeTakipSaglayicisi(),
      TrioMobilKuryeTakipSaglayicisi(),
      TakipOnKuryeTakipSaglayicisi(),
    ],
  );
}

abstract class _TemelKuryeTakipSaglayicisi implements KuryeTakipSaglayicisi {
  const _TemelKuryeTakipSaglayicisi();

  @override
  KuryeSaglayiciTestSonucu baglantiTestEt(
    KuryeTakipSaglayiciVarligi saglayici,
  ) {
    if (!_gecerliUrlMi(saglayici.apiTabanUrl)) {
      return const KuryeSaglayiciTestSonucu.hata(
        'API taban URL gecersiz. http/https adresi girin.',
      );
    }
    if (saglayici.apiAnahtari.trim().isEmpty) {
      return const KuryeSaglayiciTestSonucu.hata(
        'API anahtari bos oldugu icin test basarisiz.',
      );
    }
    return KuryeSaglayiciTestSonucu.basarili(
      '${saglayici.ad} baglanti testi basarili.',
    );
  }

  @override
  String takipKimligiUret({
    required KuryeTakipSaglayiciVarligi saglayici,
    required KuryeCihazEslesmesiVarligi eslesme,
  }) {
    return '${saglayici.id}:${eslesme.cihazKimligi.trim()}';
  }

  bool _gecerliUrlMi(String url) {
    final Uri? uri = Uri.tryParse(url.trim());
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }
}

class DahiliGpsKuryeTakipSaglayicisi extends _TemelKuryeTakipSaglayicisi {
  const DahiliGpsKuryeTakipSaglayicisi();

  @override
  KuryeTakipSaglayiciTuru get tur => KuryeTakipSaglayiciTuru.dahiliGps;
}

class TraccarKuryeTakipSaglayicisi extends _TemelKuryeTakipSaglayicisi {
  const TraccarKuryeTakipSaglayicisi();

  @override
  KuryeTakipSaglayiciTuru get tur => KuryeTakipSaglayiciTuru.traccar;
}

class NavixKuryeTakipSaglayicisi extends _TemelKuryeTakipSaglayicisi {
  const NavixKuryeTakipSaglayicisi();

  @override
  KuryeTakipSaglayiciTuru get tur => KuryeTakipSaglayiciTuru.navixy;
}

class OzelApiKuryeTakipSaglayicisi extends _TemelKuryeTakipSaglayicisi {
  const OzelApiKuryeTakipSaglayicisi();

  @override
  KuryeTakipSaglayiciTuru get tur => KuryeTakipSaglayiciTuru.ozelApi;
}

class ArventoKuryeTakipSaglayicisi extends _TemelKuryeTakipSaglayicisi {
  const ArventoKuryeTakipSaglayicisi();

  @override
  KuryeTakipSaglayiciTuru get tur => KuryeTakipSaglayiciTuru.turkSaglayici1;
}

class MobilizKuryeTakipSaglayicisi extends _TemelKuryeTakipSaglayicisi {
  const MobilizKuryeTakipSaglayicisi();

  @override
  KuryeTakipSaglayiciTuru get tur => KuryeTakipSaglayiciTuru.turkSaglayici2;
}

class SeyirMobilKuryeTakipSaglayicisi extends _TemelKuryeTakipSaglayicisi {
  const SeyirMobilKuryeTakipSaglayicisi();

  @override
  KuryeTakipSaglayiciTuru get tur => KuryeTakipSaglayiciTuru.turkSaglayici3;
}

class TrioMobilKuryeTakipSaglayicisi extends _TemelKuryeTakipSaglayicisi {
  const TrioMobilKuryeTakipSaglayicisi();

  @override
  KuryeTakipSaglayiciTuru get tur => KuryeTakipSaglayiciTuru.turkSaglayici4;
}

class TakipOnKuryeTakipSaglayicisi extends _TemelKuryeTakipSaglayicisi {
  const TakipOnKuryeTakipSaglayicisi();

  @override
  KuryeTakipSaglayiciTuru get tur => KuryeTakipSaglayiciTuru.turkSaglayici5;
}
