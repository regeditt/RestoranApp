import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/servisler/stok_durumlu_urun_hazirlayici.dart';

/// UrunleriGetirUseCase use-case operasyonunu yurutur.
class UrunleriGetirUseCase {
  const UrunleriGetirUseCase(this._menuDeposu, this._stokDeposu);

  final MenuDeposu _menuDeposu;
  final StokDeposu _stokDeposu;

  /// Use-case operasyonunu calistirir ve sonucu dondurur.
  Future<List<UrunVarligi>> call() async {
    final List<UrunVarligi> urunler = await _menuDeposu.urunleriGetir();
    return StokDurumluUrunHazirlayici.hazirla(
      urunler: urunler,
      stokDeposu: _stokDeposu,
    );
  }
}
