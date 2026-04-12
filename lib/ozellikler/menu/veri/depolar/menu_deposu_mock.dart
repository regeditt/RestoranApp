import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_secenegi_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';

class MenuDeposuMock implements MenuDeposu {
  final List<KategoriVarligi> _kategoriler = <KategoriVarligi>[
    KategoriVarligi(id: 'kat_001', ad: 'Burger', sira: 1),
    KategoriVarligi(id: 'kat_002', ad: 'Pizza', sira: 2),
    KategoriVarligi(id: 'kat_003', ad: 'Icecek', sira: 3),
    KategoriVarligi(id: 'kat_004', ad: 'Tatli', sira: 4),
    KategoriVarligi(id: 'kat_005', ad: 'Turk Mutfagi', sira: 5),
    KategoriVarligi(id: 'kat_006', ad: 'Corbalar', sira: 6),
  ];

  final List<UrunVarligi> _urunler = <UrunVarligi>[
    UrunVarligi(
      id: 'urn_001',
      kategoriId: 'kat_001',
      ad: 'Klasik Burger',
      aciklama: 'Ozel sos, cheddar ve karamelize sogan ile servis edilir.',
      fiyat: 245,
      oneCikanMi: true,
      secenekler: <UrunSecenegiVarligi>[
        UrunSecenegiVarligi(
          id: 'urn_001_sec_001',
          ad: 'Klasik servis',
          varsayilanMi: true,
        ),
        UrunSecenegiVarligi(
          id: 'urn_001_sec_002',
          ad: 'Menu yap',
          fiyatFarki: 55,
        ),
        UrunSecenegiVarligi(
          id: 'urn_001_sec_003',
          ad: 'Cift kofte',
          fiyatFarki: 90,
        ),
      ],
    ),
    UrunVarligi(
      id: 'urn_002',
      kategoriId: 'kat_001',
      ad: 'Dumanli Burger',
      aciklama: 'Fume et dokunuslu ozel burger secenegi.',
      fiyat: 285,
      secenekler: <UrunSecenegiVarligi>[
        UrunSecenegiVarligi(
          id: 'urn_002_sec_001',
          ad: 'Klasik servis',
          varsayilanMi: true,
        ),
        UrunSecenegiVarligi(
          id: 'urn_002_sec_002',
          ad: 'Menu yap',
          fiyatFarki: 55,
        ),
        UrunSecenegiVarligi(
          id: 'urn_002_sec_003',
          ad: 'Acili sos',
          fiyatFarki: 15,
        ),
      ],
    ),
    UrunVarligi(
      id: 'urn_003',
      kategoriId: 'kat_002',
      ad: 'Margarita Pizza',
      aciklama: 'Ince hamur ve taze feslegen ile hazirlanir.',
      fiyat: 310,
      oneCikanMi: true,
      secenekler: <UrunSecenegiVarligi>[
        UrunSecenegiVarligi(
          id: 'urn_003_sec_001',
          ad: 'Standart hamur',
          varsayilanMi: true,
        ),
        UrunSecenegiVarligi(
          id: 'urn_003_sec_002',
          ad: 'Ince hamur',
          fiyatFarki: 20,
        ),
        UrunSecenegiVarligi(
          id: 'urn_003_sec_003',
          ad: 'Ekstra mozzarella',
          fiyatFarki: 35,
        ),
      ],
    ),
    UrunVarligi(
      id: 'urn_004',
      kategoriId: 'kat_003',
      ad: 'Limonata',
      aciklama: 'Ev yapimi ferah limonata.',
      fiyat: 95,
      secenekler: <UrunSecenegiVarligi>[
        UrunSecenegiVarligi(
          id: 'urn_004_sec_001',
          ad: 'Normal buz',
          varsayilanMi: true,
        ),
        UrunSecenegiVarligi(id: 'urn_004_sec_002', ad: 'Az buz'),
        UrunSecenegiVarligi(id: 'urn_004_sec_003', ad: 'Sekersiz'),
      ],
    ),
    UrunVarligi(
      id: 'urn_005',
      kategoriId: 'kat_004',
      ad: 'San Sebastian',
      aciklama: 'Gunluk hazirlanan ozel tatli.',
      fiyat: 175,
      secenekler: <UrunSecenegiVarligi>[
        UrunSecenegiVarligi(
          id: 'urn_005_sec_001',
          ad: 'Standart servis',
          varsayilanMi: true,
        ),
        UrunSecenegiVarligi(
          id: 'urn_005_sec_002',
          ad: 'Ekstra sos',
          fiyatFarki: 20,
        ),
        UrunSecenegiVarligi(
          id: 'urn_005_sec_003',
          ad: 'Paylasim tabagi',
          fiyatFarki: 45,
        ),
      ],
    ),
    UrunVarligi(
      id: 'urn_006',
      kategoriId: 'kat_005',
      ad: 'Adana Kebap',
      aciklama: 'Kozlenmis biber ve lavas ile servis edilir.',
      fiyat: 395,
      oneCikanMi: true,
      secenekler: <UrunSecenegiVarligi>[
        UrunSecenegiVarligi(
          id: 'urn_006_sec_001',
          ad: 'Standart porsiyon',
          varsayilanMi: true,
        ),
        UrunSecenegiVarligi(
          id: 'urn_006_sec_002',
          ad: 'Duble porsiyon',
          fiyatFarki: 170,
        ),
        UrunSecenegiVarligi(id: 'urn_006_sec_003', ad: 'Acisiz'),
      ],
    ),
    UrunVarligi(
      id: 'urn_007',
      kategoriId: 'kat_005',
      ad: 'Lahmacun',
      aciklama: 'Ince hamur, bol maydanoz ve limon ile.',
      fiyat: 135,
      secenekler: <UrunSecenegiVarligi>[
        UrunSecenegiVarligi(
          id: 'urn_007_sec_001',
          ad: 'Klasik servis',
          varsayilanMi: true,
        ),
        UrunSecenegiVarligi(
          id: 'urn_007_sec_002',
          ad: 'Cift adet',
          fiyatFarki: 120,
        ),
        UrunSecenegiVarligi(id: 'urn_007_sec_003', ad: 'Bol aci'),
      ],
    ),
    UrunVarligi(
      id: 'urn_008',
      kategoriId: 'kat_005',
      ad: 'Etli Kuru Fasulye',
      aciklama: 'Pilav ve tursu ile ev usulu servis edilir.',
      fiyat: 275,
      secenekler: <UrunSecenegiVarligi>[
        UrunSecenegiVarligi(
          id: 'urn_008_sec_001',
          ad: 'Pilavli servis',
          varsayilanMi: true,
        ),
        UrunSecenegiVarligi(id: 'urn_008_sec_002', ad: 'Pilavsiz'),
      ],
    ),
    UrunVarligi(
      id: 'urn_009',
      kategoriId: 'kat_006',
      ad: 'Mercimek Corbasi',
      aciklama: 'Limon ve kruton ile sicak servis edilir.',
      fiyat: 115,
      oneCikanMi: true,
      secenekler: <UrunSecenegiVarligi>[
        UrunSecenegiVarligi(
          id: 'urn_009_sec_001',
          ad: 'Klasik servis',
          varsayilanMi: true,
        ),
        UrunSecenegiVarligi(
          id: 'urn_009_sec_002',
          ad: 'Tereyagli sos',
          fiyatFarki: 20,
        ),
      ],
    ),
    UrunVarligi(
      id: 'urn_010',
      kategoriId: 'kat_006',
      ad: 'Ezogelin Corbasi',
      aciklama: 'Baharatli geleneksel tarif.',
      fiyat: 125,
      secenekler: <UrunSecenegiVarligi>[
        UrunSecenegiVarligi(
          id: 'urn_010_sec_001',
          ad: 'Klasik servis',
          varsayilanMi: true,
        ),
        UrunSecenegiVarligi(id: 'urn_010_sec_002', ad: 'Acili'),
      ],
    ),
    UrunVarligi(
      id: 'urn_011',
      kategoriId: 'kat_003',
      ad: 'Ayran',
      aciklama: 'Yayik usulu soguk ayran.',
      fiyat: 70,
      secenekler: <UrunSecenegiVarligi>[
        UrunSecenegiVarligi(
          id: 'urn_011_sec_001',
          ad: 'Kucuk boy',
          varsayilanMi: true,
        ),
        UrunSecenegiVarligi(
          id: 'urn_011_sec_002',
          ad: 'Buyuk boy',
          fiyatFarki: 20,
        ),
      ],
    ),
    UrunVarligi(
      id: 'urn_012',
      kategoriId: 'kat_004',
      ad: 'Firinda Sutlac',
      aciklama: 'Gunluk sutten hazirlanan geleneksel tatli.',
      fiyat: 145,
      secenekler: <UrunSecenegiVarligi>[
        UrunSecenegiVarligi(
          id: 'urn_012_sec_001',
          ad: 'Standart servis',
          varsayilanMi: true,
        ),
        UrunSecenegiVarligi(id: 'urn_012_sec_002', ad: 'Bol tarcin'),
      ],
    ),
  ];

  @override
  Future<List<KategoriVarligi>> kategorileriGetir() async {
    return _kategoriler;
  }

  @override
  Future<void> kategoriEkle(KategoriVarligi kategori) async {
    _kategoriler.add(kategori);
  }

  @override
  Future<void> kategoriGuncelle(KategoriVarligi kategori) async {
    final int index = _kategoriler.indexWhere(
      (kayit) => kayit.id == kategori.id,
    );
    if (index >= 0) {
      _kategoriler[index] = kategori;
    }
  }

  @override
  Future<void> kategoriSil(String kategoriId) async {
    _kategoriler.removeWhere((kategori) => kategori.id == kategoriId);
    _urunler.removeWhere((urun) => urun.kategoriId == kategoriId);
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

  @override
  Future<void> urunEkle(UrunVarligi urun) async {
    _urunler.add(urun);
  }

  @override
  Future<void> urunGuncelle(UrunVarligi urun) async {
    final int index = _urunler.indexWhere((kayit) => kayit.id == urun.id);
    if (index < 0) {
      return;
    }
    _urunler[index] = urun;
  }

  @override
  Future<void> urunSil(String urunId) async {
    _urunler.removeWhere((urun) => urun.id == urunId);
  }
}
