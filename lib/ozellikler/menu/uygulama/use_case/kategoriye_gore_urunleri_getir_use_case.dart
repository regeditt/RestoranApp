import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';

class KategoriyeGoreUrunleriGetirUseCase {
  const KategoriyeGoreUrunleriGetirUseCase(this._menuDeposu);

  final MenuDeposu _menuDeposu;

  Future<List<UrunVarligi>> call(String kategoriId) {
    return _menuDeposu.kategoriyeGoreUrunleriGetir(kategoriId);
  }
}
