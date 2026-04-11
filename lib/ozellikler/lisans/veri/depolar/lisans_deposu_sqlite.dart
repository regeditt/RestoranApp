import 'package:restoran_app/ozellikler/lisans/alan/depolar/lisans_deposu.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class LisansDeposuSqlite implements LisansDeposu {
  LisansDeposuSqlite(this._veritabani);

  static const String _lisansAnahtariAyarAnahtari =
      'uygulama_lisans_anahtari_v1';
  static const String _denemeBaslangicTarihiAyarAnahtari =
      'uygulama_deneme_baslangic_tarihi_v1';

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
  Future<DateTime?> denemeBaslangicTarihiGetir() async {
    final String? metin = await _veritabani.ayarOku(
      _denemeBaslangicTarihiAyarAnahtari,
    );
    if (metin == null || metin.trim().isEmpty) {
      return null;
    }
    final DateTime? tarih = DateTime.tryParse(metin.trim());
    if (tarih == null) {
      return null;
    }
    return DateTime(tarih.year, tarih.month, tarih.day);
  }

  @override
  Future<void> denemeBaslangicTarihiKaydet(DateTime baslangicTarihi) {
    final DateTime sadeTarih = DateTime(
      baslangicTarihi.year,
      baslangicTarihi.month,
      baslangicTarihi.day,
    );
    return _veritabani.ayarYaz(
      _denemeBaslangicTarihiAyarAnahtari,
      sadeTarih.toIso8601String(),
    );
  }

  @override
  Future<void> lisansTemizle() {
    return _veritabani.ayarYaz(_lisansAnahtariAyarAnahtari, '');
  }
}
