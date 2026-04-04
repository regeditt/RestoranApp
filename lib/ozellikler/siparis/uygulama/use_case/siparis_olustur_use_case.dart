import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/siparise_gore_stok_dus_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

class SiparisOlusturUseCase {
  const SiparisOlusturUseCase(
    this._siparisDeposu, {
    SipariseGoreStokDusUseCase? stokDusUseCase,
  }) : _stokDusUseCase = stokDusUseCase;

  final SiparisDeposu _siparisDeposu;
  final SipariseGoreStokDusUseCase? _stokDusUseCase;

  Future<SiparisVarligi> call(SiparisVarligi siparis) async {
    final SiparisVarligi sonuc = await _siparisDeposu.siparisOlustur(siparis);
    await _stokDusUseCase?.call(sonuc);
    return sonuc;
  }
}
