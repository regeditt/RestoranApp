import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/stok_alarm_gecmisi_kaydi_varligi.dart';

class StokAlarmGecmisiniGetirUseCase {
  const StokAlarmGecmisiniGetirUseCase(this._stokDeposu);

  final StokDeposu _stokDeposu;

  Future<List<StokAlarmGecmisiKaydiVarligi>> call({
    DateTime? baslangicTarihi,
    DateTime? bitisTarihi,
    int limit = 500,
  }) {
    return _stokDeposu.stokAlarmGecmisiGetir(
      baslangicTarihi: baslangicTarihi,
      bitisTarihi: bitisTarihi,
      limit: limit,
    );
  }
}
