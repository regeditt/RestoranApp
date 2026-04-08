import 'package:flutter/material.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/bagimlilik/servis_saglayici.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ozellikler/anasayfa/sunum/sayfalar/ana_sayfa.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/sayfalar/giris_secim_sayfasi.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/sayfalar/hesabim_sayfasi.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/viewmodel/giris_secim_viewmodel.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/viewmodel/hesabim_viewmodel.dart';
import 'package:restoran_app/ozellikler/menu/sunum/sayfalar/musteri_menu_sayfasi.dart';
import 'package:restoran_app/ozellikler/menu/sunum/sayfalar/qr_menu_sayfasi.dart';
import 'package:restoran_app/ozellikler/menu/sunum/viewmodel/musteri_menu_viewmodel.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';
import 'package:restoran_app/ozellikler/raporlar/sunum/sayfalar/raporlar_sayfasi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_ozeti_girdisi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/sayfalar/mutfak_siparis_sayfasi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/sayfalar/siparis_ozeti_sayfasi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/viewmodel/mutfak_siparis_viewmodel.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/viewmodel/siparis_ozeti_viewmodel.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/sayfalar/yonetim_paneli_sayfasi.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/viewmodel/yonetim_paneli_viewmodel.dart';

class RotaYapisi {
  const RotaYapisi._();

  static const String anaSayfa = '/';
  static const String personelGiris = '/personel-giris';
  static const String vitrin = '/ana-sayfa';
  static const String hesabim = '/hesabim';
  static const String musteriMenusu = '/musteri-menusu';
  static const String qrMenu = '/qr-menu';
  static const String pos = '/pos';
  static const String mutfak = '/mutfak';
  static const String raporlar = '/raporlar';
  static const String siparisOzeti = '/siparis-ozeti';
  static const String yonetimPaneli = '/yonetim-paneli';

  static const Map<String, _PersonelErisimKurali>
  _personelErisimKurallari = <String, _PersonelErisimKurali>{
    pos: _PersonelErisimKurali(
      izinliRoller: <KullaniciRolu>[
        KullaniciRolu.garson,
        KullaniciRolu.yonetici,
        KullaniciRolu.patron,
      ],
      baslik: 'POS erisimi icin personel girisi gerekli',
      aciklama:
          'Musteri akisi dogrudan QR menu ile acilir. POS yalnizca garson ve yonetici operasyonu icindir.',
    ),
    mutfak: _PersonelErisimKurali(
      izinliRoller: <KullaniciRolu>[
        KullaniciRolu.garson,
        KullaniciRolu.yonetici,
        KullaniciRolu.patron,
      ],
      baslik: 'Mutfak ekrani personel icindir',
      aciklama:
          'Bu operasyon ekrani mutfak ve servis ekipleri icin ayrildi. Musteri yolculugu QR menu uzerinden ilerler.',
    ),
    yonetimPaneli: _PersonelErisimKurali(
      izinliRoller: <KullaniciRolu>[
        KullaniciRolu.yonetici,
        KullaniciRolu.patron,
      ],
      baslik: 'Yonetim paneli yalnizca yonetim icindir',
      aciklama:
          'Garson operasyonu POS uzerinden ilerler. Yonetim paneli icin yonetici rolu ile oturum acman gerekir.',
    ),
    raporlar: _PersonelErisimKurali(
      izinliRoller: <KullaniciRolu>[
        KullaniciRolu.yonetici,
        KullaniciRolu.patron,
      ],
      izinliKullaniciKimlikleri:
          UygulamaSabitleri.raporErisimIzinliKullaniciKimlikleri,
      izinliTelefonlar: UygulamaSabitleri.raporErisimIzinliTelefonlar,
      izinliEpostalar: UygulamaSabitleri.raporErisimIzinliEpostalar,
      baslik: 'Raporlar yalnizca yetkili kullanicilara acik',
      aciklama:
          'Rapor merkezi admin kullanicilar icindir. Izinli kullanici listesine ekli degilsen personel girisi ile devam etmelisin.',
    ),
  };

  static List<KullaniciRolu>? izinliRolleriGetir(String rota) {
    final _PersonelErisimKurali? kural = _personelErisimKurallari[rota];
    if (kural == null) {
      return null;
    }
    return List<KullaniciRolu>.unmodifiable(kural.izinliRoller);
  }

  static Route<dynamic> rotaOlustur(RouteSettings ayarlar) {
    switch (ayarlar.name) {
      case anaSayfa:
        return MaterialPageRoute<void>(
          builder: (_) => const AnaSayfa(),
          settings: ayarlar,
        );
      case personelGiris:
        return MaterialPageRoute<void>(
          builder: (context) {
            final servisKaydi = ServisSaglayici.of(context);
            return GirisSecimSayfasi(
              viewModel: GirisSecimViewModel.servisKaydindan(servisKaydi),
            );
          },
          settings: ayarlar,
        );
      case vitrin:
        return MaterialPageRoute<void>(
          builder: (_) => const AnaSayfa(),
          settings: ayarlar,
        );
      case musteriMenusu:
        return MaterialPageRoute<void>(
          builder: (_) => const QrMenuSayfasi(),
          settings: ayarlar,
        );
      case qrMenu:
        return MaterialPageRoute<void>(
          builder: (_) => const QrMenuSayfasi(),
          settings: ayarlar,
        );
      case pos:
        return MaterialPageRoute<void>(
          builder: (context) {
            final servisKaydi = ServisSaglayici.of(context);
            return _personelYetkiKorumaIle(
              rota: pos,
              servisKaydi: servisKaydi,
              yetkiliSayfaOlustur: () => MusteriMenuSayfasi(
                viewModel: MusteriMenuViewModel.servisKaydindan(servisKaydi),
              ),
            );
          },
          settings: ayarlar,
        );
      case mutfak:
        return MaterialPageRoute<void>(
          builder: (context) {
            final servisKaydi = ServisSaglayici.of(context);
            return _personelYetkiKorumaIle(
              rota: mutfak,
              servisKaydi: servisKaydi,
              yetkiliSayfaOlustur: () => MutfakSiparisSayfasi(
                viewModel: MutfakSiparisViewModel.servisKaydindan(servisKaydi),
              ),
            );
          },
          settings: ayarlar,
        );
      case raporlar:
        return MaterialPageRoute<void>(
          builder: (context) {
            final servisKaydi = ServisSaglayici.of(context);
            return _personelYetkiKorumaIle(
              rota: raporlar,
              servisKaydi: servisKaydi,
              yetkiliSayfaOlustur: () => RaporlarSayfasi(
                viewModel: YonetimPaneliViewModel.servisKaydindan(servisKaydi),
              ),
            );
          },
          settings: ayarlar,
        );
      case hesabim:
        return MaterialPageRoute<void>(
          builder: (context) {
            final servisKaydi = ServisSaglayici.of(context);
            return HesabimSayfasi(
              viewModel: HesabimViewModel.servisKaydindan(servisKaydi),
            );
          },
          settings: ayarlar,
        );
      case siparisOzeti:
        final Object? arguman = ayarlar.arguments;
        final SiparisOzetiGirdisiVarligi? girdi = switch (arguman) {
          SiparisOzetiGirdisiVarligi() => arguman,
          SepetVarligi() => SiparisOzetiGirdisiVarligi(sepet: arguman),
          _ => null,
        };
        if (girdi == null) {
          return MaterialPageRoute<void>(
            builder: (_) => const QrMenuSayfasi(),
            settings: ayarlar,
          );
        }
        return MaterialPageRoute<bool>(
          builder: (context) {
            final servisKaydi = ServisSaglayici.of(context);
            return SiparisOzetiSayfasi(
              viewModel: SiparisOzetiViewModel.servisKaydindan(
                servisKaydi,
                sepet: girdi.sepet,
                qrBaglami: girdi.qrBaglami,
              ),
            );
          },
          settings: ayarlar,
        );
      case yonetimPaneli:
        return MaterialPageRoute<void>(
          builder: (context) {
            final servisKaydi = ServisSaglayici.of(context);
            return _personelYetkiKorumaIle(
              rota: yonetimPaneli,
              servisKaydi: servisKaydi,
              yetkiliSayfaOlustur: () => YonetimPaneliSayfasi(
                viewModel: YonetimPaneliViewModel.servisKaydindan(servisKaydi),
                servisKaydi: servisKaydi,
              ),
            );
          },
          settings: ayarlar,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const QrMenuSayfasi(),
          settings: ayarlar,
        );
    }
  }

  static Widget _personelYetkiKorumaIle({
    required String rota,
    required ServisKaydi servisKaydi,
    required Widget Function() yetkiliSayfaOlustur,
  }) {
    final _PersonelErisimKurali? kural = _personelErisimKurallari[rota];
    if (kural == null) {
      return const QrMenuSayfasi();
    }

    return _PersonelYetkiKapisi(
      servisKaydi: servisKaydi,
      izinliRoller: kural.izinliRoller,
      izinliKullaniciKimlikleri: kural.izinliKullaniciKimlikleri,
      izinliTelefonlar: kural.izinliTelefonlar,
      izinliEpostalar: kural.izinliEpostalar,
      baslik: kural.baslik,
      aciklama: kural.aciklama,
      yetkiliSayfaOlustur: yetkiliSayfaOlustur,
    );
  }
}

class _PersonelErisimKurali {
  const _PersonelErisimKurali({
    required this.izinliRoller,
    required this.baslik,
    required this.aciklama,
    this.izinliKullaniciKimlikleri = const <String>{},
    this.izinliTelefonlar = const <String>{},
    this.izinliEpostalar = const <String>{},
  });

  final List<KullaniciRolu> izinliRoller;
  final Set<String> izinliKullaniciKimlikleri;
  final Set<String> izinliTelefonlar;
  final Set<String> izinliEpostalar;
  final String baslik;
  final String aciklama;
}

class _PersonelYetkiKapisi extends StatelessWidget {
  const _PersonelYetkiKapisi({
    required this.servisKaydi,
    required this.izinliRoller,
    required this.izinliKullaniciKimlikleri,
    required this.izinliTelefonlar,
    required this.izinliEpostalar,
    required this.baslik,
    required this.aciklama,
    required this.yetkiliSayfaOlustur,
  });

  final ServisKaydi servisKaydi;
  final List<KullaniciRolu> izinliRoller;
  final Set<String> izinliKullaniciKimlikleri;
  final Set<String> izinliTelefonlar;
  final Set<String> izinliEpostalar;
  final String baslik;
  final String aciklama;
  final Widget Function() yetkiliSayfaOlustur;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<KullaniciVarligi?>(
      future: servisKaydi.aktifKullaniciGetirUseCase(),
      builder:
          (BuildContext context, AsyncSnapshot<KullaniciVarligi?> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final KullaniciVarligi? kullanici = snapshot.data;
            final bool yetkili = _kullaniciYetkiliMi(kullanici);
            if (yetkili) {
              return yetkiliSayfaOlustur();
            }

            return _YetkisizErisimSayfasi(
              baslik: baslik,
              aciklama: aciklama,
              rolEtiketi: _rolEtiketi(kullanici?.rol),
            );
          },
    );
  }

  bool _kullaniciYetkiliMi(KullaniciVarligi? kullanici) {
    if (kullanici == null || !kullanici.aktifMi) {
      return false;
    }

    final bool roldenYetkili = izinliRoller.contains(kullanici.rol);
    if (roldenYetkili) {
      return true;
    }

    return _izinliListedenYetkili(kullanici);
  }

  bool _izinliListedenYetkili(KullaniciVarligi kullanici) {
    final bool kimlikEslesmesi = _degerListedeVarMi(
      kaynak: izinliKullaniciKimlikleri,
      hedef: kullanici.id,
    );
    if (kimlikEslesmesi) {
      return true;
    }

    final bool telefonEslesmesi = _degerListedeVarMi(
      kaynak: izinliTelefonlar,
      hedef: kullanici.telefon,
    );
    if (telefonEslesmesi) {
      return true;
    }

    final String? eposta = kullanici.eposta;
    if (eposta == null) {
      return false;
    }

    return _degerListedeVarMi(
      kaynak: izinliEpostalar,
      hedef: eposta,
      buyukKucukHarfDuyarsiz: true,
    );
  }

  bool _degerListedeVarMi({
    required Set<String> kaynak,
    required String hedef,
    bool buyukKucukHarfDuyarsiz = false,
  }) {
    String normalizasyon(String deger) {
      final String temiz = deger.trim();
      if (buyukKucukHarfDuyarsiz) {
        return temiz.toLowerCase();
      }
      return temiz;
    }

    final String hedefNormalize = normalizasyon(hedef);
    if (hedefNormalize.isEmpty) {
      return false;
    }

    for (final String deger in kaynak) {
      if (normalizasyon(deger) == hedefNormalize) {
        return true;
      }
    }
    return false;
  }

  String? _rolEtiketi(KullaniciRolu? rol) {
    switch (rol) {
      case null:
        return null;
      case KullaniciRolu.misafir:
        return 'Misafir';
      case KullaniciRolu.musteri:
        return 'Musteri';
      case KullaniciRolu.garson:
        return 'Garson';
      case KullaniciRolu.yonetici:
        return 'Yonetici';
      case KullaniciRolu.patron:
        return 'Patron';
    }
  }
}

class _YetkisizErisimSayfasi extends StatelessWidget {
  const _YetkisizErisimSayfasi({
    required this.baslik,
    required this.aciklama,
    this.rolEtiketi,
  });

  final String baslik;
  final String aciklama;
  final String? rolEtiketi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F4),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.lock_person_rounded,
                      size: 36,
                      color: Color(0xFFE53D6F),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    baslik,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    aciklama,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF6D6079),
                      fontSize: 16,
                    ),
                  ),
                  if (rolEtiketi != null) ...<Widget>[
                    const SizedBox(height: 14),
                    Chip(label: Text('Aktif rol: $rolEtiketi')),
                  ],
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: () => Navigator.of(
                          context,
                        ).pushReplacementNamed(RotaYapisi.personelGiris),
                        icon: const Icon(Icons.badge_rounded),
                        label: const Text('Personel girisine git'),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () =>
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              RotaYapisi.anaSayfa,
                              (Route<dynamic> route) => false,
                            ),
                        icon: const Icon(Icons.home_rounded),
                        label: const Text('Ana sayfaya don'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(
                          context,
                        ).pushReplacementNamed(RotaYapisi.qrMenu),
                        icon: const Icon(Icons.qr_code_2_rounded),
                        label: const Text('QR menuye don'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
