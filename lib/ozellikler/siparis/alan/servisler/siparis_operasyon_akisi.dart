import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

class SiparisDurumDogrulamaSonucu {
  const SiparisDurumDogrulamaSonucu._({
    required this.basarili,
    required this.mesaj,
  });

  const SiparisDurumDogrulamaSonucu.basarili()
    : this._(basarili: true, mesaj: '');

  const SiparisDurumDogrulamaSonucu.hata(String mesaj)
    : this._(basarili: false, mesaj: mesaj);

  final bool basarili;
  final String mesaj;
}

/// Siparis durum akisinin operasyon kurallarini tek noktadan yonetir.
///
/// Kaynaklanan operasyon prensipleri:
/// - Mutfak sureci sirali ilerler (yeni -> hazirlaniyor -> hazir)
/// - Paket servis "yolda" adimini zorunlu kullanir
/// - Kapanmis siparis yeniden acilmaz
class SiparisOperasyonAkisi {
  const SiparisOperasyonAkisi._();

  static SiparisDurumu? sonrakiDurum(SiparisVarligi siparis) {
    switch (siparis.durum) {
      case SiparisDurumu.alindi:
        return SiparisDurumu.hazirlaniyor;
      case SiparisDurumu.hazirlaniyor:
        return SiparisDurumu.hazir;
      case SiparisDurumu.hazir:
        return siparis.teslimatTipi == TeslimatTipi.paketServis
            ? SiparisDurumu.yolda
            : SiparisDurumu.teslimEdildi;
      case SiparisDurumu.yolda:
        return SiparisDurumu.teslimEdildi;
      case SiparisDurumu.teslimEdildi:
      case SiparisDurumu.iptalEdildi:
        return null;
    }
  }

  static SiparisDurumDogrulamaSonucu gecisDogrula({
    required SiparisVarligi siparis,
    required SiparisDurumu hedefDurum,
  }) {
    if (siparis.durum == hedefDurum) {
      return SiparisDurumDogrulamaSonucu.hata(
        'Siparis zaten ${_durumEtiketi(hedefDurum).toLowerCase()} durumunda.',
      );
    }

    if (siparis.durum == SiparisDurumu.teslimEdildi ||
        siparis.durum == SiparisDurumu.iptalEdildi) {
      return const SiparisDurumDogrulamaSonucu.hata(
        'Kapanmis siparislerde durum degisikligi yapilamaz.',
      );
    }

    if (hedefDurum == SiparisDurumu.yolda &&
        siparis.teslimatTipi != TeslimatTipi.paketServis) {
      return const SiparisDurumDogrulamaSonucu.hata(
        'Yolda durumu sadece paket servis siparislerinde kullanilabilir.',
      );
    }

    final Set<SiparisDurumu> izinliHedefDurumlar = _izinliHedefDurumlar(
      siparis,
    );
    if (!izinliHedefDurumlar.contains(hedefDurum)) {
      return SiparisDurumDogrulamaSonucu.hata(
        'Durum gecisi gecersiz: ${_durumEtiketi(siparis.durum)} -> ${_durumEtiketi(hedefDurum)}.',
      );
    }
    return const SiparisDurumDogrulamaSonucu.basarili();
  }

  static Set<SiparisDurumu> _izinliHedefDurumlar(SiparisVarligi siparis) {
    switch (siparis.durum) {
      case SiparisDurumu.alindi:
        return <SiparisDurumu>{
          SiparisDurumu.hazirlaniyor,
          SiparisDurumu.iptalEdildi,
        };
      case SiparisDurumu.hazirlaniyor:
        return <SiparisDurumu>{SiparisDurumu.hazir, SiparisDurumu.iptalEdildi};
      case SiparisDurumu.hazir:
        return <SiparisDurumu>{
          siparis.teslimatTipi == TeslimatTipi.paketServis
              ? SiparisDurumu.yolda
              : SiparisDurumu.teslimEdildi,
          SiparisDurumu.iptalEdildi,
        };
      case SiparisDurumu.yolda:
        return <SiparisDurumu>{
          SiparisDurumu.teslimEdildi,
          SiparisDurumu.iptalEdildi,
        };
      case SiparisDurumu.teslimEdildi:
      case SiparisDurumu.iptalEdildi:
        return const <SiparisDurumu>{};
    }
  }

  static String _durumEtiketi(SiparisDurumu durum) {
    switch (durum) {
      case SiparisDurumu.alindi:
        return 'Alindi';
      case SiparisDurumu.hazirlaniyor:
        return 'Hazirlaniyor';
      case SiparisDurumu.hazir:
        return 'Hazir';
      case SiparisDurumu.yolda:
        return 'Yolda';
      case SiparisDurumu.teslimEdildi:
        return 'Teslim edildi';
      case SiparisDurumu.iptalEdildi:
        return 'Iptal edildi';
    }
  }
}
