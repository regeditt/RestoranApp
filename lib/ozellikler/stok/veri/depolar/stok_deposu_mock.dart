import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/enumlar/stok_uyari_durumu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/stok_alarm_gecmisi_kaydi_varligi.dart';

class StokDeposuMock implements StokDeposu {
  final List<HammaddeStokVarligi> _hammaddeler = <HammaddeStokVarligi>[
    HammaddeStokVarligi(
      id: 'ham_001',
      ad: 'Burger ekmegi',
      birim: 'adet',
      mevcutMiktar: 44,
      uyariEsigi: 28,
      kritikEsik: 20,
      birimMaliyet: 8,
    ),
    HammaddeStokVarligi(
      id: 'ham_002',
      ad: 'Kofte',
      birim: 'adet',
      mevcutMiktar: 36,
      uyariEsigi: 24,
      kritikEsik: 18,
      birimMaliyet: 42,
    ),
    HammaddeStokVarligi(
      id: 'ham_003',
      ad: 'Cheddar',
      birim: 'dilim',
      mevcutMiktar: 22,
      uyariEsigi: 20,
      kritikEsik: 18,
      birimMaliyet: 6,
    ),
    HammaddeStokVarligi(
      id: 'ham_004',
      ad: 'Pizza hamuru',
      birim: 'adet',
      mevcutMiktar: 16,
      uyariEsigi: 14,
      kritikEsik: 12,
      birimMaliyet: 28,
    ),
    HammaddeStokVarligi(
      id: 'ham_005',
      ad: 'Mozzarella',
      birim: 'porsiyon',
      mevcutMiktar: 10,
      uyariEsigi: 15,
      kritikEsik: 12,
      birimMaliyet: 18,
    ),
    HammaddeStokVarligi(
      id: 'ham_006',
      ad: 'Limon surubu',
      birim: 'lt',
      mevcutMiktar: 4,
      uyariEsigi: 4.5,
      kritikEsik: 3,
      birimMaliyet: 65,
    ),
    HammaddeStokVarligi(
      id: 'ham_007',
      ad: 'Cheesecake tabani',
      birim: 'adet',
      mevcutMiktar: 7,
      uyariEsigi: 8,
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

  final List<StokAlarmGecmisiKaydiVarligi> _stokAlarmGecmisi =
      <StokAlarmGecmisiKaydiVarligi>[];

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
    _stokAlarmGecmisiEkle(
      oncekiKayit: null,
      yeniKayit: hammadde,
      tetikleyenIslem: 'hammadde_ekleme',
    );
  }

  @override
  Future<void> hammaddeGuncelle(HammaddeStokVarligi hammadde) async {
    final int index = _hammaddeler.indexWhere(
      (HammaddeStokVarligi kayit) => kayit.id == hammadde.id,
    );
    if (index >= 0) {
      final HammaddeStokVarligi oncekiKayit = _hammaddeler[index];
      _hammaddeler[index] = hammadde;
      _stokAlarmGecmisiEkle(
        oncekiKayit: oncekiKayit,
        yeniKayit: hammadde,
        tetikleyenIslem: 'manuel_guncelleme',
      );
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
    final HammaddeStokVarligi yeniKayit = mevcut.copyWith(
      mevcutMiktar: yeniMiktar,
    );
    _hammaddeler[index] = yeniKayit;
    _stokAlarmGecmisiEkle(
      oncekiKayit: mevcut,
      yeniKayit: yeniKayit,
      tetikleyenIslem: 'siparis_stok_dusumu',
    );
  }

  @override
  Future<List<StokAlarmGecmisiKaydiVarligi>> stokAlarmGecmisiGetir({
    DateTime? baslangicTarihi,
    DateTime? bitisTarihi,
    int limit = 500,
  }) async {
    final Iterable<StokAlarmGecmisiKaydiVarligi> filtreli = _stokAlarmGecmisi
        .where((StokAlarmGecmisiKaydiVarligi kayit) {
          if (baslangicTarihi != null &&
              kayit.zaman.isBefore(baslangicTarihi)) {
            return false;
          }
          if (bitisTarihi != null && kayit.zaman.isAfter(bitisTarihi)) {
            return false;
          }
          return true;
        });
    final List<StokAlarmGecmisiKaydiVarligi> sirali = filtreli.toList()
      ..sort((a, b) => b.zaman.compareTo(a.zaman));
    if (sirali.length <= limit) {
      return sirali;
    }
    return sirali.take(limit).toList();
  }

  void _stokAlarmGecmisiEkle({
    required HammaddeStokVarligi? oncekiKayit,
    required HammaddeStokVarligi yeniKayit,
    required String tetikleyenIslem,
  }) {
    final StokUyariDurumu oncekiDurum =
        oncekiKayit?.uyariDurumu ?? StokUyariDurumu.normal;
    final StokUyariDurumu yeniDurum = yeniKayit.uyariDurumu;
    if (yeniDurum == StokUyariDurumu.normal || oncekiDurum == yeniDurum) {
      return;
    }
    _stokAlarmGecmisi.add(
      StokAlarmGecmisiKaydiVarligi(
        id: 'alm_${DateTime.now().microsecondsSinceEpoch}',
        zaman: DateTime.now(),
        hammaddeId: yeniKayit.id,
        hammaddeAdi: yeniKayit.ad,
        oncekiMiktar: oncekiKayit?.mevcutMiktar ?? yeniKayit.mevcutMiktar,
        yeniMiktar: yeniKayit.mevcutMiktar,
        oncekiDurum: oncekiDurum,
        yeniDurum: yeniDurum,
        tetikleyenIslem: tetikleyenIslem,
      ),
    );
  }
}
