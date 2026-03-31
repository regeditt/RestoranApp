import 'package:restoran_app/ozellikler/yonetim/alan/depolar/yazici_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';

class YaziciDeposuMock implements YaziciDeposu {
  final List<YaziciDurumuVarligi> _yazicilar = <YaziciDurumuVarligi>[
    YaziciDurumuVarligi(
      id: 'yzc_001',
      ad: 'Mutfak Yazicisi',
      rolEtiketi: 'Mutfak',
      baglantiNoktasi: 'USB-01',
      aciklama: 'Hamburger, pizza ve sicak servis fisleri buraya yonlenir.',
      durum: YaziciBaglantiDurumu.bagli,
    ),
    YaziciDurumuVarligi(
      id: 'yzc_002',
      ad: 'Bar Yazicisi',
      rolEtiketi: 'Icecek',
      baglantiNoktasi: 'LAN 192.168.1.33',
      aciklama: 'Soguk icecek ve bar siparisleri icin ayrik kuyruk aktif.',
      durum: YaziciBaglantiDurumu.dikkat,
    ),
    YaziciDurumuVarligi(
      id: 'yzc_003',
      ad: 'Brother DCP-T520W',
      rolEtiketi: 'Kasa',
      baglantiNoktasi: 'USB002',
      aciklama:
          'Bu cihazdaki Brother yazici demo ciktilari icin kasa yazicisi olarak kullanilir.',
      durum: YaziciBaglantiDurumu.bagli,
    ),
  ];

  @override
  Future<List<YaziciDurumuVarligi>> yazicilariGetir() async {
    return List<YaziciDurumuVarligi>.from(_yazicilar);
  }

  @override
  Future<YaziciDurumuVarligi> yaziciEkle(YaziciDurumuVarligi yazici) async {
    _yazicilar.add(yazici);
    return yazici;
  }

  @override
  Future<YaziciDurumuVarligi> yaziciGuncelle(YaziciDurumuVarligi yazici) async {
    final int index = _yazicilar.indexWhere((mevcut) => mevcut.id == yazici.id);
    if (index >= 0) {
      _yazicilar[index] = yazici;
    }
    return yazici;
  }

  @override
  Future<void> yaziciSil(String yaziciId) async {
    _yazicilar.removeWhere((yazici) => yazici.id == yaziciId);
  }
}
