import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/platform/konum_platformu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/kurye_takip_entegrasyon_varliklari.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_entegrasyon_yonetim_servisi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_konum_takip_servisi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/viewmodel/yonetim_paneli_viewmodel.dart';

void main() {
  test(
    'YonetimPaneliViewModel yukle ile temel panel verilerini doldurur',
    () async {
      final YonetimPaneliViewModel viewModel =
          YonetimPaneliViewModel.servisKaydindan(ServisKaydi.mock());

      final YonetimPaneliIslemSonucu sonuc = await viewModel.yukle();

      expect(sonuc.basarili, isTrue);
      expect(viewModel.siparisler, isNotEmpty);
      expect(viewModel.yazicilar, isNotEmpty);
      expect(viewModel.menuKategorileri, isNotEmpty);
    },
  );

  test(
    'YonetimPaneliViewModel yazici ekleme sonrasi listeyi gunceller',
    () async {
      final YonetimPaneliViewModel viewModel =
          YonetimPaneliViewModel.servisKaydindan(ServisKaydi.mock());
      await viewModel.yukle();
      const YaziciDurumuVarligi yeniYazici = YaziciDurumuVarligi(
        id: 'yzc_test',
        ad: 'Test Yazici',
        rolEtiketi: 'Kasa',
        baglantiNoktasi: 'USB-99',
        aciklama: 'Birim test yazicisi',
        durum: YaziciBaglantiDurumu.bagli,
      );

      final YonetimPaneliIslemSonucu sonuc = await viewModel.yaziciEkle(
        yeniYazici,
      );

      expect(sonuc.basarili, isTrue);
      expect(
        viewModel.yazicilar.any((yazici) => yazici.id == yeniYazici.id),
        isTrue,
      );
    },
  );

  test(
    'YonetimPaneliViewModel personel silme sonrasi listeyi gunceller',
    () async {
      final YonetimPaneliViewModel viewModel =
          YonetimPaneliViewModel.servisKaydindan(ServisKaydi.mock());
      await viewModel.yukle();
      final silinecek = viewModel.personeller.first;

      final YonetimPaneliIslemSonucu sonuc = await viewModel.personelSil(
        silinecek,
      );

      expect(sonuc.basarili, isTrue);
      expect(
        viewModel.personeller.any(
          (personel) => personel.kimlik == silinecek.kimlik,
        ),
        isFalse,
      );
    },
  );

  test(
    'YonetimPaneliViewModel garson hesabi olusturup personel listesine ekler',
    () async {
      final YonetimPaneliViewModel viewModel =
          YonetimPaneliViewModel.servisKaydindan(ServisKaydi.mock());
      await viewModel.yukle();
      final int oncekiSayi = viewModel.personeller.length;

      final YonetimPaneliIslemSonucu sonuc = await viewModel
          .garsonHesabiOlustur(
            adSoyad: 'Yeni Garson',
            kullaniciAdi: 'garson_yeni',
            sifre: '123456',
          );

      expect(sonuc.basarili, isTrue);
      expect(viewModel.personeller.length, oncekiSayi + 1);
      expect(
        viewModel.personeller.any(
          (personel) =>
              personel.adSoyad == 'Yeni Garson' &&
              personel.rolEtiketi == 'Garson',
        ),
        isTrue,
      );
    },
  );

  test(
    'YonetimPaneliViewModel yukle sonrasi yolda paket siparislerini otomatik takip eder',
    () async {
      final ServisKaydi servisKaydi = ServisKaydi.mock();
      final KuryeKonumTakipServisi kuryeTakipServisi = KuryeKonumTakipServisi(
        konumSaglayici: const _SahteKonumPlatformu(),
      );
      final YonetimPaneliViewModel viewModel = YonetimPaneliViewModel(
        siparisleriGetirUseCase: servisKaydi.siparisleriGetirUseCase,
        personelleriGetirUseCase: servisKaydi.personelleriGetirUseCase,
        personelSilUseCase: servisKaydi.personelSilUseCase,
        sistemYazicilariniGetirUseCase:
            servisKaydi.sistemYazicilariniGetirUseCase,
        yazicilariGetirUseCase: servisKaydi.yazicilariGetirUseCase,
        salonBolumleriniGetirUseCase: servisKaydi.salonBolumleriniGetirUseCase,
        kategorileriGetirUseCase: servisKaydi.kategorileriGetirUseCase,
        urunleriGetirUseCase: servisKaydi.urunleriGetirUseCase,
        stokOzetiGetirUseCase: servisKaydi.stokOzetiGetirUseCase,
        hesapOlusturUseCase: servisKaydi.hesapOlusturUseCase,
        yaziciEkleUseCase: servisKaydi.yaziciEkleUseCase,
        yaziciGuncelleUseCase: servisKaydi.yaziciGuncelleUseCase,
        yaziciSilUseCase: servisKaydi.yaziciSilUseCase,
        kuryeTakipServisi: kuryeTakipServisi,
      );

      final YonetimPaneliIslemSonucu sonuc = await viewModel.yukle();
      final yoldaPaketSiparisleri = viewModel.siparisler.where(
        (siparis) =>
            siparis.teslimatTipi == TeslimatTipi.paketServis &&
            siparis.durum == SiparisDurumu.yolda,
      );

      expect(sonuc.basarili, isTrue);
      for (final siparis in yoldaPaketSiparisleri) {
        expect(kuryeTakipServisi.siparisTakipteMi(siparis.id), isTrue);
      }
    },
  );

  test(
    'YonetimPaneliViewModel yukle stale kurye takip kaydini temizler',
    () async {
      final ServisKaydi servisKaydi = ServisKaydi.mock();
      final KuryeKonumTakipServisi kuryeTakipServisi = KuryeKonumTakipServisi(
        konumSaglayici: const _SahteKonumPlatformu(),
      );
      final YonetimPaneliViewModel viewModel = YonetimPaneliViewModel(
        siparisleriGetirUseCase: servisKaydi.siparisleriGetirUseCase,
        personelleriGetirUseCase: servisKaydi.personelleriGetirUseCase,
        personelSilUseCase: servisKaydi.personelSilUseCase,
        sistemYazicilariniGetirUseCase:
            servisKaydi.sistemYazicilariniGetirUseCase,
        yazicilariGetirUseCase: servisKaydi.yazicilariGetirUseCase,
        salonBolumleriniGetirUseCase: servisKaydi.salonBolumleriniGetirUseCase,
        kategorileriGetirUseCase: servisKaydi.kategorileriGetirUseCase,
        urunleriGetirUseCase: servisKaydi.urunleriGetirUseCase,
        stokOzetiGetirUseCase: servisKaydi.stokOzetiGetirUseCase,
        hesapOlusturUseCase: servisKaydi.hesapOlusturUseCase,
        yaziciEkleUseCase: servisKaydi.yaziciEkleUseCase,
        yaziciGuncelleUseCase: servisKaydi.yaziciGuncelleUseCase,
        yaziciSilUseCase: servisKaydi.yaziciSilUseCase,
        kuryeTakipServisi: kuryeTakipServisi,
      );

      await kuryeTakipServisi.takipBaslat(
        siparisId: 'eski_rapor_siparisi',
        kuryeKimligi: 'Eski Kurye',
      );
      expect(kuryeTakipServisi.siparisTakipteMi('eski_rapor_siparisi'), isTrue);

      final YonetimPaneliIslemSonucu sonuc = await viewModel.yukle();

      expect(sonuc.basarili, isTrue);
      expect(
        kuryeTakipServisi.siparisTakipteMi('eski_rapor_siparisi'),
        isFalse,
      );
    },
  );

  test(
    'YonetimPaneliViewModel yukle aktif kurye eslesmesini takip kimligine uygular',
    () async {
      final ServisKaydi servisKaydi = ServisKaydi.mock();
      final KuryeKonumTakipServisi kuryeTakipServisi = KuryeKonumTakipServisi(
        konumSaglayici: const _SahteKonumPlatformu(),
      );
      final KuryeEntegrasyonYonetimServisi kuryeEntegrasyonServisi =
          KuryeEntegrasyonYonetimServisi(
            baslangicSaglayicilar: const <KuryeTakipSaglayiciVarligi>[
              KuryeTakipSaglayiciVarligi(
                id: 'sgl_traccar',
                ad: 'Traccar',
                tur: KuryeTakipSaglayiciTuru.traccar,
                apiTabanUrl: 'https://traccar.example.com',
                apiAnahtari: 'anahtar',
                aktifMi: true,
                oncelik: 1,
                aciklama: 'Test',
              ),
            ],
            baslangicEslesmeler: const <KuryeCihazEslesmesiVarligi>[
              KuryeCihazEslesmesiVarligi(
                kuryeAdi: 'Emre Kurye',
                saglayiciId: 'sgl_traccar',
                cihazKimligi: 'IMEI-500',
                aktifMi: true,
              ),
            ],
          );
      final YonetimPaneliViewModel viewModel = YonetimPaneliViewModel(
        siparisleriGetirUseCase: servisKaydi.siparisleriGetirUseCase,
        personelleriGetirUseCase: servisKaydi.personelleriGetirUseCase,
        personelSilUseCase: servisKaydi.personelSilUseCase,
        sistemYazicilariniGetirUseCase:
            servisKaydi.sistemYazicilariniGetirUseCase,
        yazicilariGetirUseCase: servisKaydi.yazicilariGetirUseCase,
        salonBolumleriniGetirUseCase: servisKaydi.salonBolumleriniGetirUseCase,
        kategorileriGetirUseCase: servisKaydi.kategorileriGetirUseCase,
        urunleriGetirUseCase: servisKaydi.urunleriGetirUseCase,
        stokOzetiGetirUseCase: servisKaydi.stokOzetiGetirUseCase,
        hesapOlusturUseCase: servisKaydi.hesapOlusturUseCase,
        yaziciEkleUseCase: servisKaydi.yaziciEkleUseCase,
        yaziciGuncelleUseCase: servisKaydi.yaziciGuncelleUseCase,
        yaziciSilUseCase: servisKaydi.yaziciSilUseCase,
        kuryeTakipServisi: kuryeTakipServisi,
        kuryeEntegrasyonServisi: kuryeEntegrasyonServisi,
      );

      await viewModel.yukle();
      final yoldaPaketSiparisi = viewModel.siparisler.firstWhere(
        (siparis) =>
            siparis.teslimatTipi == TeslimatTipi.paketServis &&
            siparis.durum == SiparisDurumu.yolda,
      );
      final konum = kuryeTakipServisi.siparisKonumuGetir(yoldaPaketSiparisi.id);

      expect(konum, isNotNull);
      expect(konum!.kuryeKimligi, 'sgl_traccar:IMEI-500');
    },
  );
}

class _SahteKonumPlatformu implements KonumPlatformu {
  const _SahteKonumPlatformu();

  @override
  Future<KonumHazirlamaSonucu> hazirla() async {
    return const KonumHazirlamaSonucu.basarili();
  }

  @override
  Future<KonumNoktasi?> anlikKonumGetir() async {
    return KonumNoktasi(
      enlem: 41.015,
      boylam: 28.979,
      olusturmaTarihi: DateTime(2026, 4, 9, 12, 0),
    );
  }

  @override
  Stream<KonumNoktasi> konumAkisi() {
    return const Stream<KonumNoktasi>.empty();
  }
}
