import 'package:restoran_app/ozellikler/kimlik/alan/servisler/ayar_asistani_yanitlayici.dart';

class KuralliAyarAsistaniYanitlayici implements AyarAsistaniYanitlayici {
  const KuralliAyarAsistaniYanitlayici();

  @override
  String get acilisMesaji =>
      'Merhaba, ben Ayar Asistani. Giris, lisans, menu ve operasyon ayarlari konusunda yardimci olabilirim.';

  @override
  List<String> get hizliSoruEtiketleri => const <String>[
    'Kullanici bulunamadi',
    'Lisans',
    'Menu ayarlari',
  ];

  @override
  Future<String> yanitUret(String soru) async {
    final String metin = soru.toLowerCase();

    if (metin.contains('kullanici bulunamadi') ||
        metin.contains('giris') ||
        metin.contains('hesap')) {
      return 'Bu cihazda kullanici kaydi yoksa giris yaparken hata alirsin. Yonetici rolu ile Hesap olustur modunu acip once hesap olusturabilirsin.';
    }
    if (metin.contains('lisans') || metin.contains('anahtar')) {
      return 'Lisans anahtari formati VP-YYYYMMDD-CCCCCC-XXXXXX. Cihaz kodunu lisans olustururken kullanip anahtari girerek aktivasyon yapabilirsin.';
    }
    if (metin.contains('sifre')) {
      return 'Sifreyi dogru role (garson/yonetici) ile dene. Rol farkliysa sistem girise izin vermez.';
    }
    if (metin.contains('menu') || metin.contains('urun')) {
      return 'Menu ve urun ayarlari icin Yonetim paneli > Admin ayarlari > Menu sekmesini kullanabilirsin.';
    }
    if (metin.contains('stok')) {
      return 'Stok islemleri Yonetim paneli > Admin ayarlari > Stok sekmesinde yonetilir.';
    }
    if (metin.contains('yazici') || metin.contains('kurye')) {
      return 'Yazici ve kurye entegrasyonlari Admin ayarlari ekranindaki Entegrasyon sekmesinden yonetilir.';
    }
    if (metin.contains('rol') || metin.contains('yetki')) {
      return 'Rol secimi giriste kritik. Garson ve yonetici yetkileri farkli oldugu icin dogru rol ile oturum acman gerekir.';
    }
    return 'Bunu da birlikte cozeriz. Sorunu daha net yazarsan adim adim ne yapman gerektigini cikarabilirim.';
  }
}
