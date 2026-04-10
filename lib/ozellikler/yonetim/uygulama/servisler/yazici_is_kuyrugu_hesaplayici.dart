import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_is_kuyrugu_varligi.dart';

/// Aktif siparislerden yazici bazli ozet is kuyrugu gorunumunu uretir.
class YaziciIsKuyruguHesaplayici {
  const YaziciIsKuyruguHesaplayici._();

  /// Aktif siparisleri yazici odakli ozet kuyruk satirlarina donusturur.
  static List<YaziciIsKuyruguVarligi> kuyruguHazirla(
    List<SiparisVarligi> siparisler,
  ) {
    final List<SiparisVarligi> adaylar = siparisler
        .where(
          (siparis) =>
              siparis.durum != SiparisDurumu.teslimEdildi &&
              siparis.durum != SiparisDurumu.iptalEdildi,
        )
        .take(4)
        .toList();

    return adaylar.map((siparis) {
      final String yaziciRolu = _yaziciRolu(siparis);
      final String konum = siparis.masaNo != null && siparis.masaNo!.isNotEmpty
          ? 'Masa ${siparis.masaNo}'
          : _teslimatEtiketi(siparis.teslimatTipi);

      return YaziciIsKuyruguVarligi(
        siparisNo: siparis.siparisNo,
        yaziciRolu: yaziciRolu,
        durumEtiketi: _durumEtiketi(siparis.durum),
        kisaAciklama: '$konum - ${siparis.kalemler.length} kalem',
      );
    }).toList();
  }

  static String _yaziciRolu(SiparisVarligi siparis) {
    switch (siparis.teslimatTipi) {
      case TeslimatTipi.restorandaYe:
        return 'Mutfak';
      case TeslimatTipi.gelAl:
        return 'Kasa';
      case TeslimatTipi.paketServis:
        return 'Icecek';
    }
  }

  static String _durumEtiketi(SiparisDurumu durum) {
    switch (durum) {
      case SiparisDurumu.alindi:
        return 'Yeni';
      case SiparisDurumu.hazirlaniyor:
        return 'Hazirlaniyor';
      case SiparisDurumu.hazir:
        return 'Hazir';
      case SiparisDurumu.yolda:
        return 'Yolda';
      case SiparisDurumu.teslimEdildi:
        return 'Teslim';
      case SiparisDurumu.iptalEdildi:
        return 'Iptal';
    }
  }

  static String _teslimatEtiketi(TeslimatTipi teslimatTipi) {
    switch (teslimatTipi) {
      case TeslimatTipi.restorandaYe:
        return 'Salon';
      case TeslimatTipi.gelAl:
        return 'Gel al';
      case TeslimatTipi.paketServis:
        return 'Paket';
    }
  }
}
