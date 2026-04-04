import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ortak/platform/yazici_cikti_platformu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/yazici_hedefleri_belirleyici.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/use_case/siparisi_yazdir_use_case.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/depolar/yazici_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';

class _YaziciDeposuFake implements YaziciDeposu {
  _YaziciDeposuFake(this._yazicilar);

  final List<YaziciDurumuVarligi> _yazicilar;

  @override
  Future<List<YaziciDurumuVarligi>> yazicilariGetir() async => _yazicilar;

  @override
  Future<YaziciDurumuVarligi> yaziciEkle(YaziciDurumuVarligi yazici) {
    throw UnimplementedError();
  }

  @override
  Future<YaziciDurumuVarligi> yaziciGuncelle(YaziciDurumuVarligi yazici) {
    throw UnimplementedError();
  }

  @override
  Future<void> yaziciSil(String yaziciId) {
    throw UnimplementedError();
  }
}

class _YaziciCiktiFake implements YaziciCiktiPlatformu {
  bool sonuc;
  final List<String> gonderilenler = <String>[];

  _YaziciCiktiFake({this.sonuc = true});

  @override
  Future<bool> gonder({
    required String yaziciAdi,
    required String icerik,
  }) async {
    gonderilenler.add(yaziciAdi);
    return sonuc;
  }
}

void main() {
  test('SiparisiYazdirUseCase hedef yazicilari ayirir', () async {
    final List<YaziciDurumuVarligi> yazicilar = <YaziciDurumuVarligi>[
      const YaziciDurumuVarligi(
        id: 'y1',
        ad: 'Brother HL-2130',
        rolEtiketi: 'Kasa',
        baglantiNoktasi: 'USB',
        aciklama: 'Kasa yazicisi',
        durum: YaziciBaglantiDurumu.bagli,
      ),
      const YaziciDurumuVarligi(
        id: 'y2',
        ad: 'Epson TM',
        rolEtiketi: 'Mutfak',
        baglantiNoktasi: 'LAN',
        aciklama: 'Mutfak yazicisi',
        durum: YaziciBaglantiDurumu.bagli,
      ),
    ];

    final SiparisVarligi siparis = SiparisVarligi(
      id: 'sip_1',
      siparisNo: 'R-100',
      sahip: SiparisSahibiVarligi.misafir(
        const MisafirBilgisiVarligi(adSoyad: 'Zeynep', telefon: '555000'),
      ),
      teslimatTipi: TeslimatTipi.gelAl,
      durum: SiparisDurumu.alindi,
      kalemler: const <SiparisKalemiVarligi>[
        SiparisKalemiVarligi(
          id: 'k1',
          urunId: 'u1',
          urunAdi: 'Pizza',
          birimFiyat: 250,
          adet: 1,
        ),
      ],
      olusturmaTarihi: DateTime(2026, 4, 4),
    );

    final _YaziciDeposuFake depo = _YaziciDeposuFake(yazicilar);
    final _YaziciCiktiFake platform = _YaziciCiktiFake(sonuc: true);

    final SiparisiYazdirUseCase useCase = SiparisiYazdirUseCase(
      depo,
      platform,
      const VarsayilanYaziciHedefleriBelirleyici(),
    );

    final sonuc = await useCase(siparis);

    expect(sonuc.yaziciAdlari, contains('Brother HL-2130'));
    expect(sonuc.yaziciAdlari, contains('Epson TM'));
    expect(sonuc.gercekYaziciAdlari, contains('Brother HL-2130'));
    expect(sonuc.kuyrukYaziciAdlari, contains('Epson TM'));
    expect(platform.gonderilenler, contains('Brother HL-2130'));
  });

  test('SiparisiYazdirUseCase uygun yazici yoksa ozet verir', () async {
    final List<YaziciDurumuVarligi> yazicilar = <YaziciDurumuVarligi>[
      const YaziciDurumuVarligi(
        id: 'y3',
        ad: 'Kasa-Offline',
        rolEtiketi: 'Kasa',
        baglantiNoktasi: 'USB',
        aciklama: 'Kapali',
        durum: YaziciBaglantiDurumu.kapali,
      ),
    ];

    final SiparisVarligi siparis = SiparisVarligi(
      id: 'sip_2',
      siparisNo: 'R-101',
      sahip: SiparisSahibiVarligi.misafir(
        const MisafirBilgisiVarligi(adSoyad: 'Mert', telefon: '555111'),
      ),
      teslimatTipi: TeslimatTipi.gelAl,
      durum: SiparisDurumu.alindi,
      kalemler: const <SiparisKalemiVarligi>[
        SiparisKalemiVarligi(
          id: 'k2',
          urunId: 'u2',
          urunAdi: 'Kola',
          birimFiyat: 30,
          adet: 1,
        ),
      ],
      olusturmaTarihi: DateTime(2026, 4, 4),
    );

    final SiparisiYazdirUseCase useCase = SiparisiYazdirUseCase(
      _YaziciDeposuFake(yazicilar),
      _YaziciCiktiFake(),
      const VarsayilanYaziciHedefleriBelirleyici(),
    );

    final sonuc = await useCase(siparis);

    expect(sonuc.yaziciAdlari, isEmpty);
    expect(sonuc.ozetMetni, 'Uygun yazici bulunamadi');
  });

  test('Brother yazici basarisizsa kuyruga dusurulur', () async {
    final List<YaziciDurumuVarligi> yazicilar = <YaziciDurumuVarligi>[
      const YaziciDurumuVarligi(
        id: 'y1',
        ad: 'Brother HL-2130',
        rolEtiketi: 'Kasa',
        baglantiNoktasi: 'USB',
        aciklama: 'Kasa yazicisi',
        durum: YaziciBaglantiDurumu.bagli,
      ),
    ];

    final SiparisVarligi siparis = SiparisVarligi(
      id: 'sip_3',
      siparisNo: 'R-102',
      sahip: SiparisSahibiVarligi.misafir(
        const MisafirBilgisiVarligi(adSoyad: 'Ece', telefon: '555222'),
      ),
      teslimatTipi: TeslimatTipi.gelAl,
      durum: SiparisDurumu.alindi,
      kalemler: const <SiparisKalemiVarligi>[
        SiparisKalemiVarligi(
          id: 'k3',
          urunId: 'u3',
          urunAdi: 'Pizza',
          birimFiyat: 220,
          adet: 1,
        ),
      ],
      olusturmaTarihi: DateTime(2026, 4, 4),
    );

    final SiparisiYazdirUseCase useCase = SiparisiYazdirUseCase(
      _YaziciDeposuFake(yazicilar),
      _YaziciCiktiFake(sonuc: false),
      const VarsayilanYaziciHedefleriBelirleyici(),
    );

    final sonuc = await useCase(siparis);

    expect(sonuc.gercekYaziciAdlari, isEmpty);
    expect(sonuc.kuyrukYaziciAdlari, contains('Brother HL-2130'));
  });

  test('Dikkat durumundaki yazici kabul edilir, kapali elenir', () async {
    final List<YaziciDurumuVarligi> yazicilar = <YaziciDurumuVarligi>[
      const YaziciDurumuVarligi(
        id: 'y1',
        ad: 'Brother HL-2130',
        rolEtiketi: 'Kasa',
        baglantiNoktasi: 'USB',
        aciklama: 'Dikkat',
        durum: YaziciBaglantiDurumu.dikkat,
      ),
      const YaziciDurumuVarligi(
        id: 'y2',
        ad: 'Kapali Yazici',
        rolEtiketi: 'Kasa',
        baglantiNoktasi: 'USB',
        aciklama: 'Kapali',
        durum: YaziciBaglantiDurumu.kapali,
      ),
    ];

    final SiparisVarligi siparis = SiparisVarligi(
      id: 'sip_4',
      siparisNo: 'R-103',
      sahip: SiparisSahibiVarligi.misafir(
        const MisafirBilgisiVarligi(adSoyad: 'Deniz', telefon: '555333'),
      ),
      teslimatTipi: TeslimatTipi.gelAl,
      durum: SiparisDurumu.alindi,
      kalemler: const <SiparisKalemiVarligi>[
        SiparisKalemiVarligi(
          id: 'k4',
          urunId: 'u4',
          urunAdi: 'Burger',
          birimFiyat: 200,
          adet: 1,
        ),
      ],
      olusturmaTarihi: DateTime(2026, 4, 4),
    );

    final SiparisiYazdirUseCase useCase = SiparisiYazdirUseCase(
      _YaziciDeposuFake(yazicilar),
      _YaziciCiktiFake(sonuc: false),
      const VarsayilanYaziciHedefleriBelirleyici(),
    );

    final sonuc = await useCase(siparis);

    expect(sonuc.yaziciAdlari, contains('Brother HL-2130'));
    expect(sonuc.yaziciAdlari, isNot(contains('Kapali Yazici')));
  });
}
