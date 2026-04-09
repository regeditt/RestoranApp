import 'package:restoran_app/ozellikler/siparis/alan/enumlar/paket_teslimat_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

class PaketServisDurumGuncellemesi {
  const PaketServisDurumGuncellemesi({
    required this.kuryeAdi,
    required this.paketTeslimatDurumu,
  });

  final String? kuryeAdi;
  final PaketTeslimatDurumu? paketTeslimatDurumu;
}

PaketServisDurumGuncellemesi paketServisDurumGuncellemesiniHesapla(
  SiparisVarligi siparis,
  SiparisDurumu yeniDurum, {
  String? kuryeAdi,
}) {
  if (siparis.teslimatTipi != TeslimatTipi.paketServis) {
    return const PaketServisDurumGuncellemesi(
      kuryeAdi: null,
      paketTeslimatDurumu: null,
    );
  }

  final PaketTeslimatDurumu? paketTeslimatDurumu = switch (yeniDurum) {
    SiparisDurumu.alindi ||
    SiparisDurumu.hazirlaniyor => PaketTeslimatDurumu.adresDogrulandi,
    SiparisDurumu.hazir => PaketTeslimatDurumu.kuryeBekliyor,
    SiparisDurumu.yolda => PaketTeslimatDurumu.kuryeYolda,
    SiparisDurumu.teslimEdildi => PaketTeslimatDurumu.teslimEdildi,
    SiparisDurumu.iptalEdildi => siparis.paketTeslimatDurumu,
  };

  final String? guncelKuryeAdi = switch (yeniDurum) {
    SiparisDurumu.yolda =>
      _kuryeAdiNormalize(kuryeAdi) ?? siparis.kuryeAdi ?? 'Moto Kurye',
    _ => _kuryeAdiNormalize(kuryeAdi) ?? siparis.kuryeAdi,
  };

  return PaketServisDurumGuncellemesi(
    kuryeAdi: guncelKuryeAdi,
    paketTeslimatDurumu: paketTeslimatDurumu,
  );
}

String? _kuryeAdiNormalize(String? kuryeAdi) {
  final String? ham = kuryeAdi;
  if (ham == null) {
    return null;
  }
  final String temiz = ham.trim();
  if (temiz.isEmpty) {
    return null;
  }
  return temiz;
}
