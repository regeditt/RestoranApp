import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';

class SiparisFisiOlusturucu {
  const SiparisFisiOlusturucu._();

  static String olustur({
    required SiparisVarligi siparis,
    required YaziciDurumuVarligi yazici,
  }) {
    final StringBuffer tampon = StringBuffer();

    tampon.writeln(_ortala('RESTORANAPP'));
    tampon.writeln(_ortala('SIPARIS FISI'));
    tampon.writeln(_cizgi());
    tampon.writeln(_satir('Siparis No', siparis.siparisNo));
    tampon.writeln(_satir('Tarih', _tarihYaz(siparis.olusturmaTarihi)));
    tampon.writeln(_satir('Yazici', yazici.rolEtiketi));
    tampon.writeln(_satir('Servis', _teslimatEtiketi(siparis.teslimatTipi)));

    if (siparis.masaNo != null && siparis.masaNo!.isNotEmpty) {
      tampon.writeln(_satir('Masa', siparis.masaNo!));
    }
    if (siparis.bolumAdi != null && siparis.bolumAdi!.isNotEmpty) {
      tampon.writeln(_satir('Bolum', siparis.bolumAdi!));
    }
    if (siparis.sahip.misafirBilgisi?.adSoyad != null) {
      tampon.writeln(_satir('Musteri', siparis.sahip.misafirBilgisi!.adSoyad));
    }

    tampon.writeln(_cizgi());
    tampon.writeln('URUNLER');
    tampon.writeln(_cizgi());

    for (final kalem in siparis.kalemler) {
      tampon.writeln(_urunSatiri(kalem.adet, kalem.urunAdi, kalem.araToplam));
      if (kalem.secenekAdi != null && kalem.secenekAdi!.isNotEmpty) {
        tampon.writeln('  + ${kalem.secenekAdi}');
      }
      if (kalem.notMetni != null && kalem.notMetni!.isNotEmpty) {
        tampon.writeln('  Not: ${kalem.notMetni}');
      }
      tampon.writeln(_satir('  Birim', _paraYaz(kalem.birimFiyat)));
    }

    tampon.writeln(_cizgi());
    tampon.writeln(_satir('Kalem', '${siparis.kalemler.length}'));
    tampon.writeln(_satir('Toplam', _paraYaz(siparis.toplamTutar)));
    tampon.writeln(_cizgi());
    tampon.writeln(_ortala('Afiyet olsun'));
    tampon.writeln(_ortala('www.restoranapp.local'));

    return tampon.toString();
  }

  static String _urunSatiri(int adet, String urunAdi, double toplam) {
    final String sol = '$adet x $urunAdi';
    final String sag = _paraYaz(toplam);
    return _ikiKolon(sol, sag);
  }

  static String _satir(String etiket, String deger) {
    return _ikiKolon(etiket, deger);
  }

  static String _ikiKolon(String sol, String sag) {
    const int toplamGenislik = 40;
    final String temizSol = sol.trim();
    final String temizSag = sag.trim();
    final int bosluk = toplamGenislik - temizSol.length - temizSag.length;

    if (bosluk >= 1) {
      return '$temizSol${' ' * bosluk}$temizSag';
    }

    return '$temizSol\n${' ' * (toplamGenislik - temizSag.length)}$temizSag';
  }

  static String _ortala(String metin) {
    const int genislik = 40;
    final String temiz = metin.trim();
    if (temiz.length >= genislik) {
      return temiz;
    }
    final int bosluk = ((genislik - temiz.length) / 2).floor();
    return '${' ' * bosluk}$temiz';
  }

  static String _cizgi() => '----------------------------------------';

  static String _paraYaz(double tutar) {
    return '${tutar.toStringAsFixed(2).replaceAll('.', ',')} TL';
  }

  static String _teslimatEtiketi(TeslimatTipi teslimatTipi) {
    switch (teslimatTipi) {
      case TeslimatTipi.restorandaYe:
        return 'Restoranda ye';
      case TeslimatTipi.gelAl:
        return 'Gel al';
      case TeslimatTipi.paketServis:
        return 'Paket servis';
    }
  }

  static String _tarihYaz(DateTime tarih) {
    final String gun = tarih.day.toString().padLeft(2, '0');
    final String ay = tarih.month.toString().padLeft(2, '0');
    final String yil = tarih.year.toString();
    final String saat = tarih.hour.toString().padLeft(2, '0');
    final String dakika = tarih.minute.toString().padLeft(2, '0');
    return '$gun.$ay.$yil $saat:$dakika';
  }
}
