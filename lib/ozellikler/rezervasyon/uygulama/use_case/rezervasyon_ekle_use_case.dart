import 'package:restoran_app/ozellikler/rezervasyon/alan/depolar/rezervasyon_deposu.dart';
import 'package:restoran_app/ozellikler/rezervasyon/alan/varliklar/rezervasyon_varligi.dart';

class RezervasyonEkleUseCase {
  const RezervasyonEkleUseCase(this._depo);

  final RezervasyonDeposu _depo;

  Future<void> call(RezervasyonVarligi rezervasyon) {
    _dogrula(rezervasyon);
    return _depo.rezervasyonKaydet(rezervasyon);
  }

  void _dogrula(RezervasyonVarligi rezervasyon) {
    if (rezervasyon.musteriAdi.trim().isEmpty) {
      throw StateError('Musteri adi bos olamaz.');
    }
    if (rezervasyon.telefon.trim().isEmpty) {
      throw StateError('Telefon bos olamaz.');
    }
    if (rezervasyon.kisiSayisi <= 0) {
      throw StateError('Kisi sayisi 1 ve uzeri olmalidir.');
    }
    if (!rezervasyon.bitisZamani.isAfter(rezervasyon.baslangicZamani)) {
      throw StateError('Bitis zamani, baslangic zamanindan sonra olmalidir.');
    }
  }
}
