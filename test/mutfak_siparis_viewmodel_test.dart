import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/platform/konum_platformu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/kurye_takip_entegrasyon_varliklari.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/viewmodel/mutfak_siparis_viewmodel.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_entegrasyon_yonetim_servisi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_konum_takip_servisi.dart';

void main() {
  test(
    'MutfakSiparisViewModel yukle ile siparis ve yazici verilerini doldurur',
    () async {
      final MutfakSiparisViewModel viewModel =
          MutfakSiparisViewModel.servisKaydindan(ServisKaydi.mock());

      final MutfakSiparisIslemSonucu sonuc = await viewModel.yukle();

      expect(sonuc.basarili, isTrue);
      expect(viewModel.siparisler, isNotEmpty);
      expect(viewModel.yazicilar, isNotEmpty);
    },
  );

  test(
    'MutfakSiparisViewModel durum ilerletme sonraki duruma gecirir',
    () async {
      final MutfakSiparisViewModel viewModel =
          MutfakSiparisViewModel.servisKaydindan(ServisKaydi.mock());
      await viewModel.yukle();
      final siparis = viewModel.siparisler.firstWhere(
        (siparis) => siparis.durum == SiparisDurumu.alindi,
      );

      final MutfakSiparisIslemSonucu sonuc = await viewModel.durumIlerle(
        siparis,
      );
      final guncelSiparis = viewModel.siparisler.firstWhere(
        (deger) => deger.id == siparis.id,
      );

      expect(sonuc.basarili, isTrue);
      expect(guncelSiparis.durum, SiparisDurumu.hazirlaniyor);
    },
  );

  test(
    'MutfakSiparisViewModel hazir paket siparisinde secilen kuryeyi atar',
    () async {
      final MutfakSiparisViewModel viewModel =
          MutfakSiparisViewModel.servisKaydindan(ServisKaydi.mock());
      await viewModel.yukle();
      final siparis = viewModel.siparisler.firstWhere(
        (siparis) =>
            siparis.teslimatTipi == TeslimatTipi.paketServis &&
            siparis.durum == SiparisDurumu.hazir,
      );

      final MutfakSiparisIslemSonucu sonuc = await viewModel.durumIlerle(
        siparis,
        kuryeAdi: 'Zeynep Kurye',
      );
      final guncelSiparis = viewModel.siparisler.firstWhere(
        (deger) => deger.id == siparis.id,
      );

      expect(sonuc.basarili, isTrue);
      expect(guncelSiparis.durum, SiparisDurumu.yolda);
      expect(guncelSiparis.kuryeAdi, 'Zeynep Kurye');
    },
  );

  test(
    'MutfakSiparisViewModel garson rolunde siparisi iptal etmeye izin vermez',
    () async {
      final ServisKaydi servisKaydi = ServisKaydi.mock();
      await servisKaydi.girisYapUseCase(
        telefon: 'garson_test',
        sifre: '1234',
        rol: KullaniciRolu.garson,
        adSoyad: 'Garson Test',
      );
      final MutfakSiparisViewModel viewModel =
          MutfakSiparisViewModel.servisKaydindan(servisKaydi);
      await viewModel.yukle();
      final siparis = viewModel.siparisler.firstWhere(
        (siparis) => siparis.durum == SiparisDurumu.alindi,
      );

      final MutfakSiparisIslemSonucu sonuc = await viewModel.siparisiIptalEt(
        siparis,
      );

      expect(sonuc.basarili, isFalse);
      expect(sonuc.mesaj, contains('yetkin'));
    },
  );

  test(
    'MutfakSiparisViewModel yukle sonrasi yolda paket siparisini otomatik takip eder',
    () async {
      final ServisKaydi servisKaydi = ServisKaydi.mock();
      final KuryeKonumTakipServisi kuryeTakipServisi = KuryeKonumTakipServisi(
        konumSaglayici: const _SahteKonumPlatformu(),
      );
      final MutfakSiparisViewModel viewModel = MutfakSiparisViewModel(
        siparisleriGetirUseCase: servisKaydi.siparisleriGetirUseCase,
        yazicilariGetirUseCase: servisKaydi.yazicilariGetirUseCase,
        siparisDurumuGuncelleUseCase: servisKaydi.siparisDurumuGuncelleUseCase,
        kuryeTakipServisi: kuryeTakipServisi,
      );

      final MutfakSiparisIslemSonucu sonuc = await viewModel.yukle();
      final yoldaPaketSiparisi = viewModel.siparisler.firstWhere(
        (siparis) =>
            siparis.teslimatTipi == TeslimatTipi.paketServis &&
            siparis.durum == SiparisDurumu.yolda,
      );

      expect(sonuc.basarili, isTrue);
      expect(kuryeTakipServisi.siparisTakipteMi(yoldaPaketSiparisi.id), isTrue);
      expect(
        kuryeTakipServisi.siparisKonumuGetir(yoldaPaketSiparisi.id),
        isNotNull,
      );
    },
  );

  test(
    'MutfakSiparisViewModel yukle stale kurye takip kayitlarini temizler',
    () async {
      final ServisKaydi servisKaydi = ServisKaydi.mock();
      final KuryeKonumTakipServisi kuryeTakipServisi = KuryeKonumTakipServisi(
        konumSaglayici: const _SahteKonumPlatformu(),
      );
      final MutfakSiparisViewModel viewModel = MutfakSiparisViewModel(
        siparisleriGetirUseCase: servisKaydi.siparisleriGetirUseCase,
        yazicilariGetirUseCase: servisKaydi.yazicilariGetirUseCase,
        siparisDurumuGuncelleUseCase: servisKaydi.siparisDurumuGuncelleUseCase,
        kuryeTakipServisi: kuryeTakipServisi,
      );

      await kuryeTakipServisi.takipBaslat(
        siparisId: 'eski_siparis',
        kuryeKimligi: 'Eski Kurye',
      );
      expect(kuryeTakipServisi.siparisTakipteMi('eski_siparis'), isTrue);

      final MutfakSiparisIslemSonucu sonuc = await viewModel.yukle();

      expect(sonuc.basarili, isTrue);
      expect(kuryeTakipServisi.siparisTakipteMi('eski_siparis'), isFalse);
    },
  );

  test(
    'MutfakSiparisViewModel yukle aktif kurye eslesmesini takip kimligine uygular',
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
      final MutfakSiparisViewModel viewModel = MutfakSiparisViewModel(
        siparisleriGetirUseCase: servisKaydi.siparisleriGetirUseCase,
        yazicilariGetirUseCase: servisKaydi.yazicilariGetirUseCase,
        siparisDurumuGuncelleUseCase: servisKaydi.siparisDurumuGuncelleUseCase,
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
