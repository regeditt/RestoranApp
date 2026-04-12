import 'package:flutter/foundation.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/kampanya/alan/varliklar/kampanya_hesap_sonucu_varligi.dart';
import 'package:restoran_app/ozellikler/kampanya/uygulama/servisler/kampanya_hesaplayici.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/aktif_kullanici_getir_use_case.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/misafir_olustur_use_case.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_baglami_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepet_kupon_kodunu_guncelle_use_case.dart';
import 'package:restoran_app/ozellikler/sepet/uygulama/use_case/sepeti_temizle_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/paket_teslimat_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/yazdirma_sonucu_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparis_olustur_use_case.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparisi_yazdir_use_case.dart';

/// Siparis onay akisinin sonucunu, olusan siparis ve yazdirma bilgisini tasir.
class SiparisOzetiIslemSonucu {
  const SiparisOzetiIslemSonucu.basarili({
    this.mesaj = '',
    this.siparis,
    this.yazdirmaSonucu,
  }) : basarili = true;

  const SiparisOzetiIslemSonucu.hata(this.mesaj)
    : basarili = false,
      siparis = null,
      yazdirmaSonucu = null;

  final bool basarili;
  final String mesaj;
  final SiparisVarligi? siparis;
  final YazdirmaSonucuVarligi? yazdirmaSonucu;
}

/// Siparis ozet ekraninda teslimat secimi, adres/not ve siparis onay akislarini yonetir.
class SiparisOzetiViewModel extends ChangeNotifier {
  SiparisOzetiViewModel({
    required SepetVarligi sepet,
    required AktifKullaniciGetirUseCase aktifKullaniciGetirUseCase,
    required MisafirOlusturUseCase misafirOlusturUseCase,
    required SiparisOlusturUseCase siparisOlusturUseCase,
    required SiparisiYazdirUseCase siparisiYazdirUseCase,
    required SepetiTemizleUseCase sepetiTemizleUseCase,
    required SepetKuponKodunuGuncelleUseCase sepetKuponKodunuGuncelleUseCase,
    QrMenuBaglamiVarligi? qrBaglami,
    KampanyaHesaplayici? kampanyaHesaplayici,
  }) : _sepet = sepet,
       _aktifKullaniciGetirUseCase = aktifKullaniciGetirUseCase,
       _misafirOlusturUseCase = misafirOlusturUseCase,
       _siparisOlusturUseCase = siparisOlusturUseCase,
       _siparisiYazdirUseCase = siparisiYazdirUseCase,
       _sepetiTemizleUseCase = sepetiTemizleUseCase,
       _sepetKuponKodunuGuncelleUseCase = sepetKuponKodunuGuncelleUseCase,
       _qrBaglami = qrBaglami,
       _kampanyaHesaplayici =
           kampanyaHesaplayici ?? const KampanyaHesaplayici(),
       _seciliTeslimatTipi = qrBaglami?.masaNo != null
           ? TeslimatTipi.restorandaYe
           : TeslimatTipi.gelAl {
    _kampanyaSonucu = _kampanyaHesaplayici.hesapla(_sepet);
  }

  factory SiparisOzetiViewModel.servisKaydindan(
    ServisKaydi servisKaydi, {
    required SepetVarligi sepet,
    QrMenuBaglamiVarligi? qrBaglami,
  }) {
    return SiparisOzetiViewModel(
      sepet: sepet,
      qrBaglami: qrBaglami,
      aktifKullaniciGetirUseCase: servisKaydi.aktifKullaniciGetirUseCase,
      misafirOlusturUseCase: servisKaydi.misafirOlusturUseCase,
      siparisOlusturUseCase: servisKaydi.siparisOlusturUseCase,
      siparisiYazdirUseCase: servisKaydi.siparisiYazdirUseCase,
      sepetiTemizleUseCase: servisKaydi.sepetiTemizleUseCase,
      sepetKuponKodunuGuncelleUseCase:
          servisKaydi.sepetKuponKodunuGuncelleUseCase,
    );
  }

  SepetVarligi _sepet;
  final AktifKullaniciGetirUseCase _aktifKullaniciGetirUseCase;
  final MisafirOlusturUseCase _misafirOlusturUseCase;
  final SiparisOlusturUseCase _siparisOlusturUseCase;
  final SiparisiYazdirUseCase _siparisiYazdirUseCase;
  final SepetiTemizleUseCase _sepetiTemizleUseCase;
  final SepetKuponKodunuGuncelleUseCase _sepetKuponKodunuGuncelleUseCase;
  final QrMenuBaglamiVarligi? _qrBaglami;
  final KampanyaHesaplayici _kampanyaHesaplayici;

  bool _kaydediliyor = false;
  bool _kuponIsleniyor = false;
  bool _varsayilanBilgilerYuklendi = false;
  bool _aydinlatmaOnayi = false;
  bool _ticariIletisimOnayi = false;
  String _adresMetni = '';
  String _teslimatNotu = '';
  TeslimatTipi _seciliTeslimatTipi;
  late KampanyaHesapSonucuVarligi _kampanyaSonucu;

  SepetVarligi get sepet => _sepet;
  QrMenuBaglamiVarligi? get qrBaglami => _qrBaglami;
  bool get kaydediliyor => _kaydediliyor;
  bool get kuponIsleniyor => _kuponIsleniyor;
  bool get aydinlatmaOnayi => _aydinlatmaOnayi;
  bool get ticariIletisimOnayi => _ticariIletisimOnayi;
  String get adresMetni => _adresMetni;
  String get teslimatNotu => _teslimatNotu;
  TeslimatTipi get seciliTeslimatTipi => _seciliTeslimatTipi;
  bool get paketServisSeciliMi =>
      _seciliTeslimatTipi == TeslimatTipi.paketServis;
  String get aktifKuponKodu => _sepet.kuponKodu ?? '';
  bool get kuponUygulandiMi => _kampanyaSonucu.uygulandiMi;
  bool get kuponHataliMi =>
      _sepet.kuponKodu != null &&
      _sepet.kuponKodu!.trim().isNotEmpty &&
      !_kampanyaSonucu.uygulandiMi;
  String? get kuponMesaji => kuponHataliMi
      ? _kampanyaSonucu.hataMesaji
      : (kuponUygulandiMi ? _kampanyaSonucu.aciklama : null);
  double get indirimTutari => _kampanyaSonucu.indirimTutari;
  double get genelToplam =>
      (_sepet.araToplam - indirimTutari).clamp(0, double.infinity).toDouble();

  Future<SiparisOzetiIslemSonucu> kuponUygula(String kuponKodu) async {
    if (_kuponIsleniyor) {
      return const SiparisOzetiIslemSonucu.hata('Kupon islemi devam ediyor');
    }

    _kuponIsleniyor = true;
    notifyListeners();
    try {
      final String temizKupon = kuponKodu.trim().toUpperCase();
      if (temizKupon.isEmpty) {
        _sepet = await _sepetKuponKodunuGuncelleUseCase(null);
        _kampanyaSonucu = KampanyaHesapSonucuVarligi.bos;
        return const SiparisOzetiIslemSonucu.basarili(
          mesaj: 'Kupon temizlendi',
        );
      }

      _sepet = await _sepetKuponKodunuGuncelleUseCase(temizKupon);
      _kampanyaSonucu = _kampanyaHesaplayici.hesapla(_sepet);
      if (_kampanyaSonucu.uygulandiMi) {
        return SiparisOzetiIslemSonucu.basarili(
          mesaj: _kampanyaSonucu.aciklama,
        );
      }
      return SiparisOzetiIslemSonucu.hata(
        _kampanyaSonucu.hataMesaji ?? 'Kupon uygulanamadi',
      );
    } catch (_) {
      return const SiparisOzetiIslemSonucu.hata('Kupon kodu kaydedilemedi');
    } finally {
      _kuponIsleniyor = false;
      notifyListeners();
    }
  }

  Future<SiparisOzetiIslemSonucu> kuponTemizle() async {
    return kuponUygula('');
  }

  void teslimatTipiSec(TeslimatTipi teslimatTipi) {
    if (_seciliTeslimatTipi == teslimatTipi) {
      return;
    }
    _seciliTeslimatTipi = teslimatTipi;
    notifyListeners();
  }

  void adresDegisti(String adresMetni) {
    if (_adresMetni == adresMetni) {
      return;
    }
    _adresMetni = adresMetni;
    notifyListeners();
  }

  void teslimatNotuDegisti(String teslimatNotu) {
    if (_teslimatNotu == teslimatNotu) {
      return;
    }
    _teslimatNotu = teslimatNotu;
    notifyListeners();
  }

  void aydinlatmaOnayiDegisti(bool deger) {
    if (_aydinlatmaOnayi == deger) {
      return;
    }
    _aydinlatmaOnayi = deger;
    notifyListeners();
  }

  void ticariIletisimOnayiDegisti(bool deger) {
    if (_ticariIletisimOnayi == deger) {
      return;
    }
    _ticariIletisimOnayi = deger;
    notifyListeners();
  }

  Future<SiparisOzetiIslemSonucu> varsayilanBilgileriYukle() async {
    if (_varsayilanBilgilerYuklendi) {
      return const SiparisOzetiIslemSonucu.basarili();
    }

    try {
      final KullaniciVarligi? aktifKullanici =
          await _aktifKullaniciGetirUseCase();
      if (_adresMetni.trim().isEmpty) {
        _adresMetni = aktifKullanici?.adresMetni ?? '';
      }
      _varsayilanBilgilerYuklendi = true;
      notifyListeners();
      return const SiparisOzetiIslemSonucu.basarili();
    } catch (_) {
      return const SiparisOzetiIslemSonucu.hata(
        'Varsayilan bilgiler yuklenemedi',
      );
    }
  }

  Future<SiparisOzetiIslemSonucu> siparisiOnayla() async {
    _kampanyaSonucu = _kampanyaHesaplayici.hesapla(_sepet);
    if (kuponHataliMi) {
      return SiparisOzetiIslemSonucu.hata(
        _kampanyaSonucu.hataMesaji ?? 'Kupon gecersiz',
      );
    }
    if (paketServisSeciliMi && _adresMetni.trim().isEmpty) {
      return const SiparisOzetiIslemSonucu.hata(
        'Paket sipariste teslimat adresi gerekli',
      );
    }
    if (!_aydinlatmaOnayi) {
      return const SiparisOzetiIslemSonucu.hata(
        'Siparisi tamamlamak icin KVKK aydinlatma onayi zorunludur.',
      );
    }

    _kaydediliyor = true;
    notifyListeners();
    try {
      final KullaniciVarligi? aktifKullanici =
          await _aktifKullaniciGetirUseCase();
      final MisafirBilgisiVarligi misafir = await _misafirOlusturUseCase(
        adSoyad: aktifKullanici?.adSoyad ?? 'Misafir Musteri',
        telefon: aktifKullanici?.telefon ?? '5550000000',
        eposta: aktifKullanici?.eposta,
        adres: aktifKullanici?.adresMetni,
      );

      final DateTime simdi = DateTime.now();
      final SiparisVarligi siparis = SiparisVarligi(
        id: 'sip_${simdi.microsecondsSinceEpoch}',
        siparisNo: 'R-${simdi.millisecondsSinceEpoch.toString().substring(7)}',
        sahip: SiparisSahibiVarligi.misafir(misafir),
        teslimatTipi: _seciliTeslimatTipi,
        durum: SiparisDurumu.alindi,
        kalemler: _sepet.kalemler
            .map(
              (kalem) => SiparisKalemiVarligi(
                id: kalem.id,
                urunId: kalem.urun.id,
                urunAdi: kalem.urun.ad,
                birimFiyat: kalem.birimFiyat,
                adet: kalem.adet,
                secenekAdi: kalem.secenekAdi,
                notMetni: kalem.notMetni,
              ),
            )
            .toList(),
        olusturmaTarihi: simdi,
        adresMetni: paketServisSeciliMi
            ? _adresMetni.trim()
            : aktifKullanici?.adresMetni,
        teslimatNotu: _teslimatNotunuHazirla(),
        paketTeslimatDurumu: paketServisSeciliMi
            ? PaketTeslimatDurumu.adresDogrulandi
            : null,
        masaNo: _qrBaglami?.masaNo,
        bolumAdi: _qrBaglami?.bolumAdi,
        kaynak: _qrBaglami?.kaynak,
        kuponKodu: _kampanyaSonucu.kuponKodu,
        indirimTutari: indirimTutari,
        aydinlatmaOnayi: _aydinlatmaOnayi,
        ticariIletisimOnayi: _ticariIletisimOnayi,
      );

      final SiparisVarligi kaydedilenSiparis = await _siparisOlusturUseCase(
        siparis,
      );
      final YazdirmaSonucuVarligi yazdirmaSonucu = await _siparisiYazdirUseCase(
        kaydedilenSiparis,
      );
      await _sepetiTemizleUseCase();

      return SiparisOzetiIslemSonucu.basarili(
        siparis: kaydedilenSiparis,
        yazdirmaSonucu: yazdirmaSonucu,
      );
    } catch (_) {
      return const SiparisOzetiIslemSonucu.hata('Siparis olusturulamadi');
    } finally {
      _kaydediliyor = false;
      notifyListeners();
    }
  }

  String? _teslimatNotunuHazirla() {
    final String temizNot = _teslimatNotu.trim();
    final List<String> notlar = <String>[if (temizNot.isNotEmpty) temizNot];
    if (kuponUygulandiMi) {
      final String kampanyaNotu =
          'Kampanya: ${_kampanyaSonucu.kuponKodu} (-${indirimTutari.toStringAsFixed(2)} TL)';
      notlar.add(kampanyaNotu);
    }
    final String onayNotu =
        'Onaylar: KVKK ${_aydinlatmaOnayi ? 'onayli' : 'onaysiz'}, Ticari iletisim ${_ticariIletisimOnayi ? 'onayli' : 'onaysiz'}';
    notlar.add(onayNotu);
    return notlar.isEmpty ? null : notlar.join(' | ');
  }

  String get teslimatEtiketi {
    switch (_seciliTeslimatTipi) {
      case TeslimatTipi.restorandaYe:
        return 'Restoranda ye';
      case TeslimatTipi.gelAl:
        return 'Gel al';
      case TeslimatTipi.paketServis:
        return 'Paket servis';
    }
  }

  String siparisBilgisi(SiparisVarligi siparis) {
    if (siparis.masaNo != null && siparis.masaNo!.isNotEmpty) {
      return 'Masa ${siparis.masaNo} icin kaydedildi';
    }
    if (siparis.teslimatTipi == TeslimatTipi.paketServis) {
      return 'Paket siparis ${siparis.adresMetni ?? 'adrese'} yonlendirildi';
    }
    return 'Siparis kaydedildi';
  }

  String get adresKisaOzet {
    final String adres = _adresMetni.trim();
    if (adres.isEmpty) {
      return 'Adres bekleniyor';
    }
    if (adres.length <= 26) {
      return adres;
    }
    return '${adres.substring(0, 26)}...';
  }
}
