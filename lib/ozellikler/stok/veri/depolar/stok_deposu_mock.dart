import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';

class StokDeposuMock implements StokDeposu {
  final List<HammaddeStokVarligi> _hammaddeler = <HammaddeStokVarligi>[
    HammaddeStokVarligi(
      id: 'ham_001',
      ad: 'Burger ekmegi',
      birim: 'adet',
      mevcutMiktar: 44,
      kritikEsik: 20,
      birimMaliyet: 8,
    ),
    HammaddeStokVarligi(
      id: 'ham_002',
      ad: 'Kofte',
      birim: 'adet',
      mevcutMiktar: 36,
      kritikEsik: 18,
      birimMaliyet: 42,
    ),
    HammaddeStokVarligi(
      id: 'ham_003',
      ad: 'Cheddar',
      birim: 'dilim',
      mevcutMiktar: 22,
      kritikEsik: 18,
      birimMaliyet: 6,
    ),
    HammaddeStokVarligi(
      id: 'ham_004',
      ad: 'Pizza hamuru',
      birim: 'adet',
      mevcutMiktar: 16,
      kritikEsik: 12,
      birimMaliyet: 28,
    ),
    HammaddeStokVarligi(
      id: 'ham_005',
      ad: 'Mozzarella',
      birim: 'porsiyon',
      mevcutMiktar: 10,
      kritikEsik: 12,
      birimMaliyet: 18,
    ),
    HammaddeStokVarligi(
      id: 'ham_006',
      ad: 'Limon surubu',
      birim: 'lt',
      mevcutMiktar: 4,
      kritikEsik: 3,
      birimMaliyet: 65,
    ),
    HammaddeStokVarligi(
      id: 'ham_007',
      ad: 'Cheesecake tabani',
      birim: 'adet',
      mevcutMiktar: 7,
      kritikEsik: 6,
      birimMaliyet: 24,
    ),
  ];

  final Map<String, List<ReceteKalemiVarligi>> _receteler =
      <String, List<ReceteKalemiVarligi>>{
        'urn_001': <ReceteKalemiVarligi>[
          ReceteKalemiVarligi(hammaddeId: 'ham_001', miktar: 1),
          ReceteKalemiVarligi(hammaddeId: 'ham_002', miktar: 1),
          ReceteKalemiVarligi(hammaddeId: 'ham_003', miktar: 2),
        ],
        'urn_002': <ReceteKalemiVarligi>[
          ReceteKalemiVarligi(hammaddeId: 'ham_001', miktar: 1),
          ReceteKalemiVarligi(hammaddeId: 'ham_002', miktar: 1.2),
          ReceteKalemiVarligi(hammaddeId: 'ham_003', miktar: 2),
        ],
        'urn_003': <ReceteKalemiVarligi>[
          ReceteKalemiVarligi(hammaddeId: 'ham_004', miktar: 1),
          ReceteKalemiVarligi(hammaddeId: 'ham_005', miktar: 1.4),
        ],
        'urn_004': <ReceteKalemiVarligi>[
          ReceteKalemiVarligi(hammaddeId: 'ham_006', miktar: 0.35),
        ],
        'urn_005': <ReceteKalemiVarligi>[
          ReceteKalemiVarligi(hammaddeId: 'ham_007', miktar: 1),
        ],
      };

  @override
  Future<List<HammaddeStokVarligi>> hammaddeleriGetir() async => _hammaddeler;

  @override
  Future<List<ReceteKalemiVarligi>> receteyiGetir(String urunId) async {
    return _receteler[urunId] ?? const <ReceteKalemiVarligi>[];
  }

  @override
  Future<void> receteyiKaydet(
    String urunId,
    List<ReceteKalemiVarligi> recete,
  ) async {
    _receteler[urunId] = List<ReceteKalemiVarligi>.from(recete);
  }

  @override
  Future<void> hammaddeEkle(HammaddeStokVarligi hammadde) async {
    _hammaddeler.add(hammadde);
  }

  @override
  Future<void> hammaddeGuncelle(HammaddeStokVarligi hammadde) async {
    final int index = _hammaddeler.indexWhere(
      (HammaddeStokVarligi kayit) => kayit.id == hammadde.id,
    );
    if (index >= 0) {
      _hammaddeler[index] = hammadde;
    }
  }

  @override
  Future<void> stokDus({
    required String hammaddeId,
    required double miktar,
  }) async {
    final int index = _hammaddeler.indexWhere(
      (HammaddeStokVarligi hammadde) => hammadde.id == hammaddeId,
    );
    if (index < 0) {
      return;
    }

    final HammaddeStokVarligi mevcut = _hammaddeler[index];
    final double yeniMiktar = (mevcut.mevcutMiktar - miktar).clamp(
      0,
      double.infinity,
    );
    _hammaddeler[index] = mevcut.copyWith(mevcutMiktar: yeniMiktar);
  }
}
