import 'package:restoran_app/ortak/veri/veritabani.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/depolar/asistan_backend_ayar_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/asistan_backend_ayar_varligi.dart';

class AsistanBackendAyarDeposuSqlite implements AsistanBackendAyarDeposu {
  AsistanBackendAyarDeposuSqlite(this._veritabani);

  static const String _tabanUrlAnahtari = 'asistan_backend_taban_url_v1';
  static const String _apiAnahtariAnahtari = 'asistan_backend_api_anahtari_v1';
  final UygulamaVeritabani _veritabani;

  @override
  Future<void> kaydet(AsistanBackendAyarVarligi ayar) async {
    await _veritabani.ayarYaz(_tabanUrlAnahtari, ayar.tabanUrl.trim());
    await _veritabani.ayarYaz(_apiAnahtariAnahtari, ayar.apiAnahtari.trim());
  }

  @override
  Future<AsistanBackendAyarVarligi?> yukle() async {
    final String? tabanUrl = await _veritabani.ayarOku(_tabanUrlAnahtari);
    final String? apiAnahtari = await _veritabani.ayarOku(_apiAnahtariAnahtari);
    if (tabanUrl == null && apiAnahtari == null) {
      return null;
    }
    return AsistanBackendAyarVarligi(
      tabanUrl: (tabanUrl ?? '').trim(),
      apiAnahtari: (apiAnahtari ?? '').trim(),
    );
  }
}
