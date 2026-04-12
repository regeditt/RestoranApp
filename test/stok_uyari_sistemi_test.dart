import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/menu/alan/depolar/menu_deposu.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/depolar/stok_deposu.dart';
import 'package:restoran_app/ozellikler/stok/alan/enumlar/stok_uyari_durumu.dart';
import 'package:restoran_app/ozellikler/stok/alan/enumlar/stok_uyari_filtresi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/stok_alarm_gecmisi_kaydi_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/hammadde_uyarilarini_getir_use_case.dart';
import 'package:restoran_app/ozellikler/stok/uygulama/use_case/stok_ozeti_getir_use_case.dart';

void main() {
  test('HammaddeStokVarligi uyari durumunu dogru hesaplar', () {
    final HammaddeStokVarligi tukendi = HammaddeStokVarligi(
      id: '1',
      ad: 'Un',
      birim: 'kg',
      mevcutMiktar: 0,
      kritikEsik: 4,
      uyariEsigi: 7,
      birimMaliyet: 10,
    );
    final HammaddeStokVarligi kritik = HammaddeStokVarligi(
      id: '2',
      ad: 'Yag',
      birim: 'lt',
      mevcutMiktar: 3,
      kritikEsik: 4,
      uyariEsigi: 7,
      birimMaliyet: 20,
    );
    final HammaddeStokVarligi uyari = HammaddeStokVarligi(
      id: '3',
      ad: 'Tuz',
      birim: 'kg',
      mevcutMiktar: 6,
      kritikEsik: 4,
      uyariEsigi: 7,
      birimMaliyet: 5,
    );

    expect(tukendi.uyariDurumu, StokUyariDurumu.tukendi);
    expect(kritik.uyariDurumu, StokUyariDurumu.kritik);
    expect(uyari.uyariDurumu, StokUyariDurumu.uyari);
  });

  test('StokOzetiGetirUseCase alarm seviyelerini hesaplar', () async {
    final _SahteStokDeposu stokDeposu = _SahteStokDeposu(
      hammaddeler: <HammaddeStokVarligi>[
        HammaddeStokVarligi(
          id: 'ham_1',
          ad: 'Un',
          birim: 'kg',
          mevcutMiktar: 0,
          kritikEsik: 4,
          uyariEsigi: 7,
          birimMaliyet: 10,
        ),
        HammaddeStokVarligi(
          id: 'ham_2',
          ad: 'Yag',
          birim: 'lt',
          mevcutMiktar: 3,
          kritikEsik: 4,
          uyariEsigi: 7,
          birimMaliyet: 20,
        ),
        HammaddeStokVarligi(
          id: 'ham_3',
          ad: 'Tuz',
          birim: 'kg',
          mevcutMiktar: 6,
          kritikEsik: 4,
          uyariEsigi: 7,
          birimMaliyet: 5,
        ),
        HammaddeStokVarligi(
          id: 'ham_4',
          ad: 'Su',
          birim: 'lt',
          mevcutMiktar: 12,
          kritikEsik: 4,
          uyariEsigi: 7,
          birimMaliyet: 2,
        ),
      ],
      receteler: <String, List<ReceteKalemiVarligi>>{
        'urn_1': <ReceteKalemiVarligi>[
          const ReceteKalemiVarligi(hammaddeId: 'ham_1', miktar: 1),
        ],
      },
    );
    final _SahteMenuDeposu menuDeposu = _SahteMenuDeposu(
      urunler: <UrunVarligi>[
        const UrunVarligi(
          id: 'urn_1',
          kategoriId: 'kat_1',
          ad: 'Ekmek',
          aciklama: 'Test',
          fiyat: 50,
        ),
      ],
    );

    final StokOzetiGetirUseCase useCase = StokOzetiGetirUseCase(
      stokDeposu,
      menuDeposu,
    );
    final sonuc = await useCase();

    expect(sonuc.alarmliMalzemeSayisi, 3);
    expect(sonuc.uyariMalzemeSayisi, 1);
    expect(sonuc.kritikMalzemeSayisi, 1);
    expect(sonuc.tukenenMalzemeSayisi, 1);
    expect(sonuc.stokUyariKalemleri.first.durum, StokUyariDurumu.tukendi);
  });

  test('HammaddeleriUyariyaGoreGetirUseCase filtre uygular', () async {
    final _SahteStokDeposu stokDeposu = _SahteStokDeposu(
      hammaddeler: <HammaddeStokVarligi>[
        HammaddeStokVarligi(
          id: 'ham_1',
          ad: 'Un',
          birim: 'kg',
          mevcutMiktar: 0,
          kritikEsik: 4,
          uyariEsigi: 7,
          birimMaliyet: 10,
        ),
        HammaddeStokVarligi(
          id: 'ham_2',
          ad: 'Yag',
          birim: 'lt',
          mevcutMiktar: 3,
          kritikEsik: 4,
          uyariEsigi: 7,
          birimMaliyet: 20,
        ),
        HammaddeStokVarligi(
          id: 'ham_3',
          ad: 'Tuz',
          birim: 'kg',
          mevcutMiktar: 6,
          kritikEsik: 4,
          uyariEsigi: 7,
          birimMaliyet: 5,
        ),
      ],
      receteler: const <String, List<ReceteKalemiVarligi>>{},
    );
    final HammaddeleriUyariyaGoreGetirUseCase useCase =
        HammaddeleriUyariyaGoreGetirUseCase(stokDeposu);

    final kritikler = await useCase(filtre: StokUyariFiltresi.kritik);
    final uyarilar = await useCase(filtre: StokUyariFiltresi.uyari);
    final tukenenler = await useCase(filtre: StokUyariFiltresi.tukendi);

    expect(kritikler.length, 1);
    expect(uyarilar.length, 1);
    expect(tukenenler.length, 1);
  });
}

class _SahteStokDeposu implements StokDeposu {
  _SahteStokDeposu({
    required List<HammaddeStokVarligi> hammaddeler,
    required Map<String, List<ReceteKalemiVarligi>> receteler,
  }) : _hammaddeler = hammaddeler,
       _receteler = receteler;

  final List<HammaddeStokVarligi> _hammaddeler;
  final Map<String, List<ReceteKalemiVarligi>> _receteler;

  @override
  Future<List<HammaddeStokVarligi>> hammaddeleriGetir() async => _hammaddeler;

  @override
  Future<void> hammaddeEkle(HammaddeStokVarligi hammadde) async {}

  @override
  Future<void> hammaddeGuncelle(HammaddeStokVarligi hammadde) async {}

  @override
  Future<List<ReceteKalemiVarligi>> receteyiGetir(String urunId) async {
    return _receteler[urunId] ?? const <ReceteKalemiVarligi>[];
  }

  @override
  Future<void> receteyiKaydet(
    String urunId,
    List<ReceteKalemiVarligi> recete,
  ) async {}

  @override
  Future<void> stokDus({
    required String hammaddeId,
    required double miktar,
  }) async {}

  @override
  Future<List<StokAlarmGecmisiKaydiVarligi>> stokAlarmGecmisiGetir({
    DateTime? baslangicTarihi,
    DateTime? bitisTarihi,
    int limit = 500,
  }) async {
    return const <StokAlarmGecmisiKaydiVarligi>[];
  }
}

class _SahteMenuDeposu implements MenuDeposu {
  _SahteMenuDeposu({required this.urunler});

  final List<UrunVarligi> urunler;

  @override
  Future<List<UrunVarligi>> urunleriGetir() async => urunler;

  @override
  Future<void> kategoriEkle(KategoriVarligi kategori) async {}

  @override
  Future<void> kategoriGuncelle(KategoriVarligi kategori) async {}

  @override
  Future<void> kategoriSil(String kategoriId) async {}

  @override
  Future<List<KategoriVarligi>> kategorileriGetir() async {
    return const <KategoriVarligi>[];
  }

  @override
  Future<void> urunEkle(UrunVarligi urun) async {}

  @override
  Future<void> urunGuncelle(UrunVarligi urun) async {}

  @override
  Future<void> urunSil(String urunId) async {}

  @override
  Future<List<UrunVarligi>> kategoriyeGoreUrunleriGetir(
    String kategoriId,
  ) async {
    return const <UrunVarligi>[];
  }

  @override
  Future<UrunVarligi?> urunGetir(String urunId) async {
    for (final UrunVarligi urun in urunler) {
      if (urun.id == urunId) {
        return urun;
      }
    }
    return null;
  }
}
