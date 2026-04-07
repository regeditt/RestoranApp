import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/servisler/sifre_ozetleyici.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class KimlikDeposuSqlite implements KimlikDeposu {
  KimlikDeposuSqlite(
    this._veritabani, {
    SifreOzetleyici sifreOzetleyici = const SifreOzetleyici(),
  }) : _sifreOzetleyici = sifreOzetleyici;

  final UygulamaVeritabani _veritabani;
  final SifreOzetleyici _sifreOzetleyici;

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
    final String temizTelefon = telefon.trim();
    final String temizSifre = sifre.trim();
    if (temizTelefon.isEmpty || temizSifre.isEmpty) {
      throw StateError('Kullanici adi ve sifre bos olamaz.');
    }

    final KullaniciVarligi? mevcutKullanici = await _veritabani
        .kullaniciTelefonaGoreGetir(temizTelefon);
    if (mevcutKullanici == null) {
      throw StateError('Kullanici bulunamadi.');
    }
    if (mevcutKullanici.rol != rol) {
      throw StateError('Bu hesap secilen role uygun degil.');
    }

    final sifreBilgisi = await _veritabani.kullaniciSifreBilgisiGetir(
      temizTelefon,
    );
    if (sifreBilgisi == null) {
      throw StateError('Kullanici sifresi tanimli degil.');
    }
    final bool sifreDogrulandi = _sifreOzetleyici.dogrula(
      sifre: temizSifre,
      hash: sifreBilgisi.sifreHash,
      tuz: sifreBilgisi.sifreTuz,
    );
    if (!sifreDogrulandi) {
      throw StateError('Sifre hatali.');
    }

    await _veritabani.tumKullanicilariPasifYap();
    final KullaniciVarligi aktifKullanici = KullaniciVarligi(
      id: mevcutKullanici.id,
      adSoyad: mevcutKullanici.adSoyad,
      telefon: mevcutKullanici.telefon,
      eposta: mevcutKullanici.eposta,
      rol: mevcutKullanici.rol,
      aktifMi: true,
      adresMetni: mevcutKullanici.adresMetni,
    );
    await _veritabani.kullaniciKaydet(aktifKullanici);
    return aktifKullanici;
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
