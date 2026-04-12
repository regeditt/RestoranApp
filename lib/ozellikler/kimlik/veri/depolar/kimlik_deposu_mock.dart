import 'package:restoran_app/ozellikler/kimlik/alan/depolar/kimlik_deposu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';

class KimlikDeposuMock implements KimlikDeposu {
  KullaniciVarligi? _aktifKullanici;
  final Map<String, ({KullaniciVarligi kullanici, String sifre})> _hesaplar =
      <String, ({KullaniciVarligi kullanici, String sifre})>{};
  void Function(KullaniciVarligi kullanici)? _hesapOlusturmaDinleyicisi;

  @override
  Future<KullaniciVarligi> hesapOlustur({
    required String telefon,
    required String sifre,
    required String adSoyad,
    KullaniciRolu rol = KullaniciRolu.musteri,
    String? adresMetni,
    bool aktifYap = true,
  }) async {
    final String temizTelefon = telefon.trim();
    if (_hesaplar.containsKey(temizTelefon)) {
      throw StateError('Bu kullanici adi zaten kayitli.');
    }

    final KullaniciVarligi kullanici = KullaniciVarligi(
      id: 'kul_${_hesaplar.length + 1}',
      adSoyad: adSoyad.trim(),
      telefon: temizTelefon,
      eposta: 'deneme@restoranapp.com',
      adresMetni: adresMetni,
      rol: rol,
      aktifMi: aktifYap,
    );
    _hesaplar[temizTelefon] = (kullanici: kullanici, sifre: sifre.trim());
    _hesapOlusturmaDinleyicisi?.call(kullanici);
    if (aktifYap) {
      _aktifKullanici = kullanici;
    }
    return kullanici;
  }

  void hesapOlusturmaDinleyicisiAta(
    void Function(KullaniciVarligi kullanici) dinleyici,
  ) {
    _hesapOlusturmaDinleyicisi = dinleyici;
  }

  Future<void> hesapSil(String kimlik) async {
    if (_aktifKullanici?.id == kimlik &&
        _aktifKullanici?.rol == KullaniciRolu.yonetici) {
      throw StateError('Aktif yonetici hesabi silinemez.');
    }

    String? silinecekTelefon;
    for (final MapEntry<String, ({KullaniciVarligi kullanici, String sifre})>
        kayit
        in _hesaplar.entries) {
      if (kayit.value.kullanici.id == kimlik) {
        silinecekTelefon = kayit.key;
        break;
      }
    }

    if (silinecekTelefon == null) {
      return;
    }

    _hesaplar.remove(silinecekTelefon);
    if (_aktifKullanici?.id == kimlik) {
      _aktifKullanici = null;
    }
  }

  @override
  Future<KullaniciVarligi?> aktifKullaniciGetir() async {
    return _aktifKullanici;
  }

  @override
  Future<void> cikisYap() async {
    _aktifKullanici = null;
  }

  @override
  Future<KullaniciVarligi> girisYap({
    required String telefon,
    required String sifre,
    KullaniciRolu rol = KullaniciRolu.musteri,
    String? adSoyad,
    String? adresMetni,
  }) async {
    final String temizTelefon = telefon.trim();
    final String temizSifre = sifre.trim();
    final ({KullaniciVarligi kullanici, String sifre})? hesap =
        _hesaplar[temizTelefon];
    if (hesap != null) {
      if (hesap.sifre != temizSifre) {
        throw StateError('Sifre hatali.');
      }
      if (hesap.kullanici.rol != rol) {
        throw StateError('Bu hesap secilen role uygun degil.');
      }
      _aktifKullanici = KullaniciVarligi(
        id: hesap.kullanici.id,
        adSoyad: hesap.kullanici.adSoyad,
        telefon: hesap.kullanici.telefon,
        eposta: hesap.kullanici.eposta,
        adresMetni: hesap.kullanici.adresMetni,
        rol: hesap.kullanici.rol,
        aktifMi: true,
      );
      return _aktifKullanici!;
    }

    _aktifKullanici = KullaniciVarligi(
      id: 'kul_001',
      adSoyad: adSoyad ?? 'Deneme Kullanici',
      telefon: temizTelefon,
      eposta: 'deneme@restoranapp.com',
      adresMetni: adresMetni,
      rol: rol,
    );
    return _aktifKullanici!;
  }

  @override
  Future<MisafirBilgisiVarligi> misafirOlustur({
    required String adSoyad,
    required String telefon,
    String? eposta,
    String? adres,
  }) async {
    return MisafirBilgisiVarligi(
      adSoyad: adSoyad,
      telefon: telefon,
      eposta: eposta,
      adres: adres,
    );
  }
}
