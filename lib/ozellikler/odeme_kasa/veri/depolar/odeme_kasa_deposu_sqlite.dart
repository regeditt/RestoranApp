import 'package:restoran_app/ozellikler/odeme_kasa/veri/depolar/odeme_kasa_deposu_mock.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

/// SQLite tablo modellemesi hazir olana kadar mock davranisini kullanir.
class OdemeKasaDeposuSqlite extends OdemeKasaDeposuMock {
  OdemeKasaDeposuSqlite(this._veritabani);

  final UygulamaVeritabani _veritabani;

  UygulamaVeritabani get veritabani => _veritabani;
}
