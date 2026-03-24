import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';

class MenuDeposuMock implements MenuDeposu {
  final List<KategoriVarligi> _kategoriler = const [
    KategoriVarligi(id: 'kat_001', ad: 'Burger', sira: 1),
    KategoriVarligi(id: 'kat_002', ad: 'Pizza', sira: 2),
    KategoriVarligi(id: 'kat_003', ad: 'Icecek', sira: 3),
    KategoriVarligi(id: 'kat_004', ad: 'Tatli', sira: 4),
  ];

  final List<UrunVarligi> _urunler = const [
    UrunVarligi(
      id: 'urn_001',
      kategoriId: 'kat_001',
      ad: 'Klasik Burger',
      aciklama: 'Ozel sos, cheddar ve karamelize sogan ile servis edilir.',
      fiyat: 245,
      oneCikanMi: true,
    ),
    UrunVarligi(
      id: 'urn_002',
      kategoriId: 'kat_001',
      ad: 'Dumanli Burger',
      aciklama: 'Fume et dokunuslu ozel burger secenegi.',
      fiyat: 285,
    ),
    UrunVarligi(
      id: 'urn_003',
      kategoriId: 'kat_002',
      ad: 'Margarita Pizza',
      aciklama: 'Ince hamur ve taze feslegen ile hazirlanir.',
      fiyat: 310,
      oneCikanMi: true,
    ),
    UrunVarligi(
      id: 'urn_004',
      kategoriId: 'kat_003',
      ad: 'Limonata',
      aciklama: 'Ev yapimi ferah limonata.',
      fiyat: 95,
    ),
    UrunVarligi(
      id: 'urn_005',
      kategoriId: 'kat_004',
      ad: 'San Sebastian',
      aciklama: 'Gunluk hazirlanan ozel tatli.',
      fiyat: 175,
    ),
  ];

  @override
  Future<List<KategoriVarligi>> kategorileriGetir() async {
    return _kategoriler;
  }

  @override
  Future<List<UrunVarligi>> kategoriyeGoreUrunleriGetir(
    String kategoriId,
  ) async {
    return _urunler.where((urun) => urun.kategoriId == kategoriId).toList();
  }

  @override
  Future<UrunVarligi?> urunGetir(String urunId) async {
    try {
      return _urunler.firstWhere((urun) => urun.id == urunId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<UrunVarligi>> urunleriGetir() async {
    return _urunler;
  }
}
