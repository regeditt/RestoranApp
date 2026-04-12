import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

/// Siparis kayit ve durum yonetimi operasyonlari icin depo kontrati.
abstract class SiparisDeposu {
  /// Yeni siparis kaydi olusturur.
  Future<SiparisVarligi> siparisOlustur(SiparisVarligi siparis);

  /// Siparis durumunu [yeniDurum] degerine gunceller.
  ///
  /// Paket servis akislarinda [kuryeAdi] opsiyonel olarak verilebilir.
  Future<SiparisVarligi> siparisDurumuGuncelle(
    String siparisId,
    SiparisDurumu yeniDurum, {
    String? kuryeAdi,
  });

  /// Tum siparis kayitlarini getirir.
  Future<List<SiparisVarligi>> siparisleriGetir();

  /// [siparisId] ile siparisi getirir.
  ///
  /// Kayit bulunamazsa `null` dondurur.
  Future<SiparisVarligi?> siparisGetir(String siparisId);
}
