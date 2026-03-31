import 'package:restoran_app/ortak/platform/sistem_yazici_tarayici_platformu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/sistem_yazici_adayi_varligi.dart';

class SistemYazicilariniGetirUseCase {
  const SistemYazicilariniGetirUseCase();

  Future<List<SistemYaziciAdayiVarligi>> call() {
    return sistemYaziciTarayiciPlatformu.getir();
  }
}
