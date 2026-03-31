import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/servisler/stok_durumlu_urun_hazirlayici.dart';

class KategoriyeGoreUrunleriGetirUseCase {
  const KategoriyeGoreUrunleriGetirUseCase(this._menuDeposu, this._stokDeposu);

  final MenuDeposu _menuDeposu;
  final StokDeposu _stokDeposu;

  Future<List<UrunVarligi>> call(String kategoriId) async {
    final List<UrunVarligi> urunler = await _menuDeposu
        .kategoriyeGoreUrunleriGetir(kategoriId);
    return StokDurumluUrunHazirlayici.hazirla(
      urunler: urunler,
      stokDeposu: _stokDeposu,
    );
  }
}
