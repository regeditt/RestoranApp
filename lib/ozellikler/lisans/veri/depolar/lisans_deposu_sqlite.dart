import 'package:restoran_app/ozellikler/lisans/alan/depolar/lisans_deposu.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class LisansDeposuSqlite implements LisansDeposu {
  LisansDeposuSqlite(this._veritabani);

  static const String _lisansAnahtariAyarAnahtari =
      'uygulama_lisans_anahtari_v1';

  final UygulamaVeritabani _veritabani;

  @override
  Future<String?> kayitliLisansAnahtariGetir() async {
    final String? lisans = await _veritabani.ayarOku(
      _lisansAnahtariAyarAnahtari,
    );
    if (lisans == null || lisans.trim().isEmpty) {
      return null;
    }
    return lisans.trim();
  }

  @override
  Future<void> lisansAnahtariKaydet(String lisansAnahtari) {
    return _veritabani.ayarYaz(
      _lisansAnahtariAyarAnahtari,
      lisansAnahtari.trim(),
    );
  }

  @override
  Future<void> lisansTemizle() {
    return _veritabani.ayarYaz(_lisansAnahtariAyarAnahtari, '');
  }
}
