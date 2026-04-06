import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_baglami_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

class PosMasaUrunBaglamiVarligi {
  const PosMasaUrunBaglamiVarligi({
    required this.salonBolumu,
    required this.masa,
    required this.urunler,
    this.seciliKategori,
  });

  final SalonBolumuVarligi salonBolumu;
  final MasaTanimiVarligi masa;
  final List<UrunVarligi> urunler;
  final KategoriVarligi? seciliKategori;

  QrMenuBaglamiVarligi get qrBaglami {
    return QrMenuBaglamiVarligi(
      masaNo: masa.ad,
      bolumAdi: salonBolumu.ad,
      kaynak: 'POS',
    );
  }

  int get toplamUrunSayisi => urunler.length;

  int get stoktakiUrunSayisi =>
      urunler.where((UrunVarligi urun) => urun.stoktaMi).length;

  String get baslik => '${salonBolumu.ad} / Masa ${masa.ad}';

  String get kategoriEtiketi => seciliKategori?.ad ?? 'Tum urunler';

  String get ozetMetni {
    return '$kategoriEtiketi kategorisinde $toplamUrunSayisi urun, '
        '$stoktakiUrunSayisi tanesi servise hazir.';
  }
}
