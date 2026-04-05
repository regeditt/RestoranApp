import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class KimlikDeposuSqlite implements KimlikDeposu {
  KimlikDeposuSqlite(this._veritabani);

  final UygulamaVeritabani _veritabani;

  @override
  Future<KullaniciVarligi?> aktifKullaniciGetir() {
    return _veritabani.aktifKullaniciGetir();
  }

  @override
  Future<KullaniciVarligi> girisYap({
    required String telefon,
    required String sifre,
    KullaniciRolu rol = KullaniciRolu.musteri,
    String? adSoyad,
    String? eposta,
    String? adresMetni,
  }) async {
    final String kullaniciId = await _veritabani.sonrakiNumerikKimlikGetir(
      tabloAdi: 'kullanici_kayitlari',
    );
    final KullaniciVarligi kullanici = KullaniciVarligi(
      id: kullaniciId,
      adSoyad: adSoyad ?? telefon,
      telefon: telefon,
      eposta: eposta,
      rol: rol,
      aktifMi: true,
      adresMetni: adresMetni,
    );
    await _veritabani.kullaniciKaydet(kullanici);
    return kullanici;
  }

  @override
  Future<void> cikisYap() async {
    final KullaniciVarligi? aktif = await _veritabani.aktifKullaniciGetir();
    if (aktif == null) {
      return;
    }
    await _veritabani.kullaniciKaydet(
      KullaniciVarligi(
        id: aktif.id,
        adSoyad: aktif.adSoyad,
        telefon: aktif.telefon,
        rol: aktif.rol,
        eposta: aktif.eposta,
        adresMetni: aktif.adresMetni,
        aktifMi: false,
      ),
    );
  }

  @override
  Future<MisafirBilgisiVarligi> misafirOlustur({
    required String adSoyad,
    required String telefon,
    String? eposta,
    String? adres,
  }) async {
    final MisafirBilgisiVarligi misafir = MisafirBilgisiVarligi(
      adSoyad: adSoyad,
      telefon: telefon,
      eposta: eposta,
      adres: adres,
    );
    return _veritabani.misafirKaydet(misafir);
  }
}
