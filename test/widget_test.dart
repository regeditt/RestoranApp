import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/bagimlilik/servis_saglayici.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/sayfalar/giris_secim_sayfasi.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/viewmodel/giris_secim_viewmodel.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/menu/sunum/sayfalar/musteri_menu_sayfasi.dart';
import 'package:restoran_app/ozellikler/menu/sunum/viewmodel/musteri_menu_viewmodel.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/sayfalar/mutfak_siparis_sayfasi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/sayfalar/siparis_ozeti_sayfasi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/viewmodel/mutfak_siparis_viewmodel.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/viewmodel/siparis_ozeti_viewmodel.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/saatlik_siparis_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yonetim_paneli_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/masa_plani_karti.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/paket_servis_operasyon_karti.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/personel_yonetimi_karti.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_analiz_kartlari.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ortak/veri/veri_kaynagi_tipi.dart';
import 'package:restoran_app/uygulama_kabugu/uygulama_kabugu.dart';
import 'test_destegi.dart';

void main() {
  testWidgets('RestoranApp acilista ana sayfayi gosterir', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const UygulamaKabugu(veriKaynagi: VeriKaynagiTipi.mock),
    );
    await tester.pumpAndSettle();

    expect(find.text('GUNCEL KURLAR'), findsOneWidget);
    expect(find.text('Urunler'), findsOneWidget);
    expect(find.text('Ayarlar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Ana sayfada POS kutucuklari gorunur', (
    WidgetTester tester,
  ) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(const Size(1400, 1900));
    await tester.pumpWidget(
      const UygulamaKabugu(veriKaynagi: VeriKaynagiTipi.mock),
    );
    await tester.pumpAndSettle();

    expect(find.text('Urunler'), findsOneWidget);
    expect(find.text('Hizli Satis'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('Windows acilis rotasi ana sayfa olur', () {
    expect(
      baslangicRotasiBelirle(webMu: false, platform: TargetPlatform.windows),
      RotaYapisi.anaSayfa,
    );
  });

  testWidgets('Personel girisi ekrani ayri olarak gosterilir', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      testUygulamasi(
        child: GirisSecimSayfasi(
          viewModel: GirisSecimViewModel.servisKaydindan(ServisKaydi.mock()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Personel girisi'), findsOneWidget);
    expect(find.text('Garson girisi'), findsWidgets);
    expect(find.text('Yonetici girisi'), findsWidgets);
    expect(find.text('QR menuye don'), findsOneWidget);
    expect(find.text('Ana sayfaya don'), findsOneWidget);
    expect(find.text('Giris yap'), findsNothing);
    expect(find.text('Hesap olustur'), findsNothing);
  });

  testWidgets('Ileri ekrandan ana sayfaya donus navigasyonu calisir', (
    WidgetTester tester,
  ) async {
    final ServisKaydi servisKaydi = ServisKaydi.mock();
    await tester.pumpWidget(
      ServisSaglayici(
        servis: servisKaydi,
        child: MaterialApp(
          initialRoute: RotaYapisi.personelGiris,
          onGenerateRoute: RotaYapisi.rotaOlustur,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Personel girisi'), findsOneWidget);
    expect(find.text('Ana sayfaya don'), findsOneWidget);

    await tester.tap(find.text('Ana sayfaya don'));
    await tester.pumpAndSettle();

    expect(find.text('GUNCEL KURLAR'), findsOneWidget);
    expect(find.text('Urunler'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Personel girisinde hesap olustur modu ayni formda acilir', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      testUygulamasi(
        child: GirisSecimSayfasi(
          viewModel: GirisSecimViewModel.servisKaydindan(ServisKaydi.mock()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Yonetici girisi').first);
    await tester.pumpAndSettle();

    expect(find.text('Giris yap'), findsNothing);
    expect(find.text('Hesap olustur'), findsOneWidget);

    await tester.tap(find.text('Hesap olustur'));
    await tester.pumpAndSettle();

    expect(find.text('Girise don'), findsOneWidget);
    expect(find.text('Ad soyad'), findsOneWidget);
    expect(find.text('Kullanici adi / telefon'), findsOneWidget);
    expect(find.textContaining('hesabi olustur'), findsOneWidget);
  });

  testWidgets('Acilista ayarlar aksiyonu gorunur', (WidgetTester tester) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(
      const UygulamaKabugu(veriKaynagi: VeriKaynagiTipi.mock),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ayarlar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Acilis ana sayfada temel kutucuklari gosterir', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const UygulamaKabugu(veriKaynagi: VeriKaynagiTipi.mock),
    );
    await tester.pumpAndSettle();

    expect(find.text('Musteri Hizmetleri'), findsOneWidget);
    expect(find.text('Siparisler'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Raporlar rotasi yetkisiz kullaniciyi engeller', (
    WidgetTester tester,
  ) async {
    final ServisKaydi servisKaydi = ServisKaydi.mock();
    await tester.pumpWidget(
      ServisSaglayici(
        servis: servisKaydi,
        child: MaterialApp(
          initialRoute: RotaYapisi.raporlar,
          onGenerateRoute: RotaYapisi.rotaOlustur,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(
      find.text('Raporlar yalnizca yetkili kullanicilara acik'),
      findsOneWidget,
    );
    expect(find.text('Personel girisine git'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Yonetici oturumu ile raporlar rotasi acilir', (
    WidgetTester tester,
  ) async {
    final ServisKaydi servisKaydi = ServisKaydi.mock();
    await servisKaydi.girisYapUseCase(
      telefon: '5551201200',
      sifre: '123456',
      rol: KullaniciRolu.yonetici,
      adSoyad: 'Admin Kullanici',
    );

    await tester.pumpWidget(
      ServisSaglayici(
        servis: servisKaydi,
        child: MaterialApp(
          initialRoute: RotaYapisi.raporlar,
          onGenerateRoute: RotaYapisi.rotaOlustur,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Rapor Merkezi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Izinli kullanici raporlar rotasina erisebilir', (
    WidgetTester tester,
  ) async {
    final ServisKaydi servisKaydi = ServisKaydi.mock();
    await servisKaydi.girisYapUseCase(
      telefon: '5550000000',
      sifre: '123456',
      rol: KullaniciRolu.musteri,
      adSoyad: 'Izinli Kullanici',
    );

    await tester.pumpWidget(
      ServisSaglayici(
        servis: servisKaydi,
        child: MaterialApp(
          initialRoute: RotaYapisi.raporlar,
          onGenerateRoute: RotaYapisi.rotaOlustur,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Rapor Merkezi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('RestoranApp ana sayfasi dar genislikte de gosterir', (
    WidgetTester tester,
  ) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(const Size(700, 1180));
    await tester.pumpWidget(
      const UygulamaKabugu(veriKaynagi: VeriKaynagiTipi.mock),
    );
    await tester.pumpAndSettle();

    expect(find.text('GUNCEL KURLAR'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Mutfak ekrani filtre ve kolonlari gosterir', (
    WidgetTester tester,
  ) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(const Size(1400, 900));
    await tester.pumpWidget(
      testUygulamasi(
        child: MutfakSiparisSayfasi(
          viewModel: MutfakSiparisViewModel.servisKaydindan(ServisKaydi.mock()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mutfak Siparis Yonetimi'), findsOneWidget);
    expect(find.text('Yonetim paneli'), findsOneWidget);
    expect(find.text('Personel girisine don'), findsOneWidget);
    expect(find.text('Yazici senkronu'), findsOneWidget);
    expect(find.text('Aktif is'), findsOneWidget);
    expect(find.text('Yeni'), findsOneWidget);
    expect(find.text('Salon'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('POS rotasi yetkisiz musteriyi personel girisine yonlendirir', (
    WidgetTester tester,
  ) async {
    final ServisKaydi servisKaydi = ServisKaydi.mock();

    await tester.pumpWidget(
      ServisSaglayici(
        servis: servisKaydi,
        child: MaterialApp(
          initialRoute: RotaYapisi.pos,
          onGenerateRoute: RotaYapisi.rotaOlustur,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('POS erisimi icin personel girisi gerekli'),
      findsOneWidget,
    );
    expect(find.text('Personel girisine git'), findsOneWidget);
    expect(find.text('QR menuye don'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Garson oturumu ile POS rotasi acilir', (
    WidgetTester tester,
  ) async {
    final ServisKaydi servisKaydi = ServisKaydi.mock();
    await servisKaydi.girisYapUseCase(
      telefon: '5550000000',
      sifre: '123456',
      rol: KullaniciRolu.garson,
      adSoyad: 'Deneme Garson',
    );

    await tester.pumpWidget(
      ServisSaglayici(
        servis: servisKaydi,
        child: MaterialApp(
          initialRoute: RotaYapisi.pos,
          onGenerateRoute: RotaYapisi.rotaOlustur,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Salon ve Masa Secimi'), findsOneWidget);
    expect(find.text('POS OPERASYON'), findsOneWidget);
    expect(find.textContaining('Ana sayfa'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('POS ekrani salon masa ve urun baglamini gosterir', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      testUygulamasi(
        child: MusteriMenuSayfasi(
          viewModel: MusteriMenuViewModel.servisKaydindan(ServisKaydi.mock()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Salon ve Masa Secimi'), findsOneWidget);
    expect(find.text('Salon / Masa 1'), findsOneWidget);
    expect(find.text('Salon varligi: Salon'), findsOneWidget);
    expect(find.text('Masa varligi: Masa 1 · 4 kisilik'), findsOneWidget);
    expect(find.textContaining('Urun varliklari:'), findsOneWidget);
    expect(find.textContaining('Tum urunler kategorisinde'), findsOneWidget);
    expect(find.text('Salon'), findsWidgets);
    expect(find.text('Masa 1'), findsWidgets);
    expect(find.text('5 urun'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('POS ekrani 1280x720 boyutunda kompakt yerlesime duser', (
    WidgetTester tester,
  ) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(const Size(1280, 720));
    await tester.pumpWidget(
      testUygulamasi(
        child: MusteriMenuSayfasi(
          viewModel: MusteriMenuViewModel.servisKaydindan(ServisKaydi.mock()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Salon ve Masa Secimi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('POS ekrani 1920x1080 boyutunda gorunur kalir', (
    WidgetTester tester,
  ) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    await tester.pumpWidget(
      testUygulamasi(
        child: MusteriMenuSayfasi(
          viewModel: MusteriMenuViewModel.servisKaydindan(ServisKaydi.mock()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('POS OPERASYON'), findsOneWidget);
    expect(find.text('Tum urunler Secimleri'), findsOneWidget);
    expect(find.text('Yeni'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Siparis ozeti paket servis secimini gosterir', (
    WidgetTester tester,
  ) async {
    final SepetVarligi sepet = SepetVarligi(
      id: 'sepet_test',
      kalemler: const [
        SepetKalemiVarligi(
          id: 'kalem_test',
          urun: UrunVarligi(
            id: 'urun_test',
            kategoriId: 'kat_test',
            ad: 'Burger',
            aciklama: 'Deneme urunu',
            fiyat: 210,
          ),
          birimFiyat: 210,
          adet: 1,
        ),
      ],
    );

    await tester.pumpWidget(
      testUygulamasi(
        child: SiparisOzetiSayfasi(
          viewModel: SiparisOzetiViewModel.servisKaydindan(
            ServisKaydi.mock(),
            sepet: sepet,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Gel al'), findsWidgets);
    expect(find.text('Paket servis'), findsWidgets);
    expect(find.text('Siparis Ozeti'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Paket servis operasyon karti detay diyalogunu acar', (
    WidgetTester tester,
  ) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(const Size(1100, 1000));

    final DateTime simdi = DateTime(2026, 4, 3, 15, 0);
    final List<SiparisVarligi> siparisler = <SiparisVarligi>[
      SiparisVarligi(
        id: 'sip_1',
        siparisNo: 'R-5001',
        sahip: SiparisSahibiVarligi.misafir(
          const MisafirBilgisiVarligi(
            adSoyad: 'Ayse Kaya',
            telefon: '5551112233',
          ),
        ),
        teslimatTipi: TeslimatTipi.paketServis,
        durum: SiparisDurumu.hazir,
        kalemler: const <SiparisKalemiVarligi>[
          SiparisKalemiVarligi(
            id: 'kal_1',
            urunId: 'urun_1',
            urunAdi: 'Pizza',
            birimFiyat: 320,
            adet: 1,
          ),
        ],
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 18)),
        adresMetni: 'Ataturk Mah. 10. Sok. No:3',
        teslimatNotu: 'Zile basmadan ara',
      ),
      SiparisVarligi(
        id: 'sip_2',
        siparisNo: 'R-5002',
        sahip: SiparisSahibiVarligi.misafir(
          const MisafirBilgisiVarligi(
            adSoyad: 'Mert Can',
            telefon: '5554448899',
          ),
        ),
        teslimatTipi: TeslimatTipi.paketServis,
        durum: SiparisDurumu.yolda,
        kalemler: const <SiparisKalemiVarligi>[
          SiparisKalemiVarligi(
            id: 'kal_2',
            urunId: 'urun_2',
            urunAdi: 'Burger',
            birimFiyat: 240,
            adet: 2,
          ),
        ],
        olusturmaTarihi: simdi.subtract(const Duration(minutes: 9)),
        adresMetni: 'Cumhuriyet Cad. No:24',
        kuryeAdi: 'Emre Kurye',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: PaketServisOperasyonKarti(siparisler: siparisler)),
      ),
    );
    await tester.pump();

    expect(find.text('Paket servis operasyonu'), findsOneWidget);
    expect(find.text('Aktif paket'), findsOneWidget);
    expect(find.text('Kurye bekleyen'), findsOneWidget);
    expect(find.textContaining('R-5001'), findsWidgets);

    await tester.tap(find.text('Detayi ac'));
    await tester.pumpAndSettle();

    expect(find.text('Paket hat detayi'), findsOneWidget);
    expect(find.text('Ataturk Mah. 10. Sok. No:3'), findsOneWidget);
    expect(find.text('Zile basmadan ara'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Kanal dagilimi karti kanal metriklerini gosterir', (
    WidgetTester tester,
  ) async {
    const YonetimPaneliOzetiVarligi ozet = YonetimPaneliOzetiVarligi(
      toplamSiparis: 42,
      toplamCiro: 12850,
      hazirlananSiparis: 8,
      hazirSiparis: 5,
      yoldaSiparis: 3,
      restorandaYeSayisi: 19,
      gelAlSayisi: 11,
      paketServisSayisi: 12,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: KanalDagilimiKarti(ozet: ozet)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kanal dagilimi'), findsOneWidget);
    expect(find.text('Restoranda ye'), findsWidgets);
    expect(find.text('Gel al'), findsWidgets);
    expect(find.text('Paket servis'), findsWidgets);
    expect(find.text('19'), findsOneWidget);
    expect(find.text('11'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Saatlik trend karti saat etiketlerini gosterir', (
    WidgetTester tester,
  ) async {
    const List<SaatlikSiparisOzetiVarligi> veriler =
        <SaatlikSiparisOzetiVarligi>[
          SaatlikSiparisOzetiVarligi(etiket: '12:00', adet: 3),
          SaatlikSiparisOzetiVarligi(etiket: '13:00', adet: 5),
          SaatlikSiparisOzetiVarligi(etiket: '14:00', adet: 4),
        ];

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SaatlikTrendKarti(veriler: veriler)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Saatlik siparis trendi'), findsOneWidget);
    expect(find.text('12:00'), findsWidgets);
    expect(find.text('13:00'), findsWidgets);
    expect(find.text('14:00'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Personel yonetimi karti personel durumlarini gosterir', (
    WidgetTester tester,
  ) async {
    const List<PersonelDurumuVarligi> personeller = <PersonelDurumuVarligi>[
      PersonelDurumuVarligi(
        kimlik: 'per_1',
        adSoyad: 'Zeynep Demir',
        rolEtiketi: 'Garson',
        bolge: 'Salon',
        aciklama: 'Masalar arasi servis akisini yonetiyor.',
        durum: PersonelDurumu.aktif,
      ),
      PersonelDurumuVarligi(
        kimlik: 'per_2',
        adSoyad: 'Ali Can',
        rolEtiketi: 'Komi',
        bolge: 'Teras',
        aciklama: 'Icecek destegi veriyor.',
        durum: PersonelDurumu.mola,
      ),
    ];

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PersonelYonetimiKarti(personeller: personeller)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Garson ve personel'), findsOneWidget);
    expect(find.textContaining('1 / 2 kisi vardiyada'), findsOneWidget);
    expect(find.text('Zeynep Demir'), findsOneWidget);
    expect(find.text('Ali Can'), findsOneWidget);
    expect(find.text('Aktif'), findsOneWidget);
    expect(find.text('Molada'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Personel yonetimi karti sil aksiyonunu gosterir', (
    WidgetTester tester,
  ) async {
    PersonelDurumuVarligi? silinen;
    const PersonelDurumuVarligi personel = PersonelDurumuVarligi(
      kimlik: 'per_9',
      adSoyad: 'Mehmet Kaya',
      rolEtiketi: 'Garson',
      bolge: 'Salon',
      aciklama: 'Aksam servisi',
      durum: PersonelDurumu.aktif,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PersonelYonetimiKarti(
            personeller: const <PersonelDurumuVarligi>[personel],
            personelSil: (PersonelDurumuVarligi secilen) {
              silinen = secilen;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sil'), findsOneWidget);
    await tester.tap(find.text('Sil'));
    await tester.pumpAndSettle();

    expect(silinen?.kimlik, 'per_9');
  });

  testWidgets('Personel yonetimi karti garson ekle aksiyonunu gosterir', (
    WidgetTester tester,
  ) async {
    bool eklendi = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PersonelYonetimiKarti(
            personeller: const <PersonelDurumuVarligi>[],
            personelEkle: () {
              eklendi = true;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Garson ekle'), findsOneWidget);
    await tester.tap(find.text('Garson ekle'));
    await tester.pumpAndSettle();

    expect(eklendi, isTrue);
  });

  testWidgets('Masa plani karti dolu ve bos masalari gosterir', (
    WidgetTester tester,
  ) async {
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.binding.setSurfaceSize(const Size(1400, 1100));

    final DateTime simdi = DateTime(2026, 4, 4, 13, 30);
    final List<SiparisVarligi> siparisler = <SiparisVarligi>[
      SiparisVarligi(
        id: 'sip_masa_1',
        siparisNo: 'R-7001',
        sahip: SiparisSahibiVarligi.misafir(
          const MisafirBilgisiVarligi(
            adSoyad: 'Selin Aras',
            telefon: '5553332211',
          ),
        ),
        teslimatTipi: TeslimatTipi.restorandaYe,
        durum: SiparisDurumu.hazir,
        kalemler: const <SiparisKalemiVarligi>[
          SiparisKalemiVarligi(
            id: 'masa_kalem_1',
            urunId: 'urun_7',
            urunAdi: 'Makarna',
            birimFiyat: 180,
            adet: 2,
          ),
        ],
        olusturmaTarihi: simdi,
        bolumAdi: 'Salon',
        masaNo: 'A1',
      ),
    ];

    const List<SalonBolumuVarligi> salonBolumleri = <SalonBolumuVarligi>[
      SalonBolumuVarligi(
        id: 'bolum_1',
        ad: 'Salon',
        aciklama: 'Ana servis alani',
        masalar: <MasaTanimiVarligi>[
          MasaTanimiVarligi(id: 'masa_1', ad: 'A1', kapasite: 4),
          MasaTanimiVarligi(id: 'masa_2', ad: 'A2', kapasite: 2),
        ],
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MasaPlaniKarti(
            siparisler: siparisler,
            salonBolumleri: salonBolumleri,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('RESTORANAPP Pos'), findsOneWidget);
    expect(find.text('Katlar  >  Salon'), findsOneWidget);
    expect(find.text('1 dolu masa'), findsOneWidget);
    expect(find.text('Salon A1'), findsWidgets);
    expect(find.text('Salon A2'), findsOneWidget);
    expect(find.text('Selin Aras - 360 TL'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
