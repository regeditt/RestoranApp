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
  SiparisDurumu yeniDurum,
) {
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

  final String? kuryeAdi = switch (yeniDurum) {
    SiparisDurumu.yolda => siparis.kuryeAdi ?? 'Moto Kurye',
    _ => siparis.kuryeAdi,
  };

  return PaketServisDurumGuncellemesi(
    kuryeAdi: kuryeAdi,
    paketTeslimatDurumu: paketTeslimatDurumu,
  );
}
