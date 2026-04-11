import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bilesenler/ana_sayfaya_donus.dart';
import 'package:restoran_app/ortak/tema/restoran_tema_uzantilari.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/raporlar/uygulama/servisler/rapor_disa_aktarim_servisi.dart';
import 'package:restoran_app/ozellikler/raporlar/sunum/bilesenler/kurye_performans_paneli_karti.dart';
import 'package:restoran_app/ozellikler/raporlar/sunum/bilesenler/kurye_takip_haritasi_karti.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/stok_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/saatlik_siparis_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yonetim_paneli_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/paket_servis_operasyon_karti.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_analiz_kartlari.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_rapor_kartlari.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/viewmodel/yonetim_paneli_viewmodel.dart';

class RaporlarSayfasi extends StatefulWidget {
  const RaporlarSayfasi({super.key, required this.viewModel});

  final YonetimPaneliViewModel viewModel;

  @override
  State<RaporlarSayfasi> createState() => _RaporlarSayfasiState();
}

class _RaporlarSayfasiState extends State<RaporlarSayfasi> {
  final RaporDisaAktarimServisi _raporDisaAktarimServisi =
      const RaporDisaAktarimServisi();
  bool _disaAktarimSuruyor = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _yukle();
    });
  }

  @override
  void didUpdateWidget(covariant RaporlarSayfasi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel == widget.viewModel) {
      return;
    }
    oldWidget.viewModel.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _yukle();
    });
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  Future<void> _yukle() async {
    final YonetimPaneliIslemSonucu sonuc = await widget.viewModel.yukle();
    if (!mounted || sonuc.basarili) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  Future<void> _gunlukCsvDisaAktar() async {
    await _csvDisaAktar(aylik: false);
  }

  Future<void> _aylikCsvDisaAktar() async {
    await _csvDisaAktar(aylik: true);
  }

  Future<void> _gunlukPdfYazdir() async {
    await _pdfYazdir(aylik: false);
  }

  Future<void> _aylikPdfYazdir() async {
    await _pdfYazdir(aylik: true);
  }

  Future<void> _csvDisaAktar({required bool aylik}) async {
    final List<SiparisVarligi> siparisler = widget.viewModel.filtreliSiparisler;
    if (siparisler.isEmpty) {
      _durumMesajiGoster('Disa aktarim icin siparis bulunamadi.');
      return;
    }

    setState(() {
      _disaAktarimSuruyor = true;
    });

    try {
      final String? kayitYolu = aylik
          ? await _raporDisaAktarimServisi.aylikCsvDisaAktar(siparisler)
          : await _raporDisaAktarimServisi.gunlukCsvDisaAktar(siparisler);
      if (!mounted) {
        return;
      }
      if (kayitYolu == null) {
        _durumMesajiGoster('CSV disa aktarim islemi baslatildi.');
        return;
      }
      _durumMesajiGoster('CSV raporu kaydedildi: $kayitYolu');
    } catch (hata) {
      _durumMesajiGoster(
        aylik
            ? 'Aylik CSV disa aktarim basarisiz: $hata'
            : 'Gunluk CSV disa aktarim basarisiz: $hata',
      );
    } finally {
      if (mounted) {
        setState(() {
          _disaAktarimSuruyor = false;
        });
      }
    }
  }

  Future<void> _pdfYazdir({required bool aylik}) async {
    final List<SiparisVarligi> siparisler = widget.viewModel.filtreliSiparisler;
    if (siparisler.isEmpty) {
      _durumMesajiGoster('Yazdirma icin siparis bulunamadi.');
      return;
    }

    setState(() {
      _disaAktarimSuruyor = true;
    });

    try {
      if (aylik) {
        await _raporDisaAktarimServisi.aylikPdfYazdir(siparisler);
      } else {
        await _raporDisaAktarimServisi.gunlukPdfYazdir(siparisler);
      }
      if (!mounted) {
        return;
      }
      _durumMesajiGoster('PDF yazdirma penceresi acildi.');
    } catch (hata) {
      _durumMesajiGoster(
        aylik
            ? 'Aylik PDF yazdirma basarisiz: $hata'
            : 'Gunluk PDF yazdirma basarisiz: $hata',
      );
    } finally {
      if (mounted) {
        setState(() {
          _disaAktarimSuruyor = false;
        });
      }
    }
  }

  void _durumMesajiGoster(String mesaj) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mesaj)));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (BuildContext context, Widget? child) {
        final RestoranTemaRenkleri tema = context.restoranTema;
        final YonetimPaneliViewModel viewModel = widget.viewModel;
        final YonetimPaneliOzetiVarligi ozet = viewModel.panelOzeti;
        final List<SaatlikSiparisOzetiVarligi> saatlikVeriler =
            viewModel.saatlikVeriler;
        final StokOzetiVarligi? stokOzeti = viewModel.stokOzeti;
        final List<Widget> raporKartlari = <Widget>[
          KanalDagilimiKarti(ozet: ozet),
          SaatlikTrendKarti(veriler: saatlikVeriler),
          PaketServisOperasyonKarti(siparisler: viewModel.filtreliSiparisler),
          KuryePerformansPaneliKarti(siparisler: viewModel.filtreliSiparisler),
          KuryeTakipHaritasiKarti(siparisler: viewModel.siparisler),
          if (stokOzeti != null) StokVeMaliyetKarti(ozet: stokOzeti),
          PatronRaporuKarti(
            siparisler: viewModel.filtreliSiparisler,
            saatlikVeriler: saatlikVeriler,
          ),
        ];

        return Scaffold(
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color.lerp(tema.anaArkaPlan, tema.anaArkaPlanIkincil, 0.20)!,
                  Color.lerp(
                    tema.anaArkaPlanIkincil,
                    tema.anaArkaPlanUcuncul,
                    0.55,
                  )!,
                  tema.anaArkaPlanUcuncul,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1520),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _UstAlan(
                          tema: tema,
                          disaAktarimSuruyor: _disaAktarimSuruyor,
                          gunlukCsvDisaAktar: _gunlukCsvDisaAktar,
                          aylikCsvDisaAktar: _aylikCsvDisaAktar,
                          gunlukPdfYazdir: _gunlukPdfYazdir,
                          aylikPdfYazdir: _aylikPdfYazdir,
                        ),
                        const SizedBox(height: 14),
                        _FiltreSeridi(viewModel: viewModel),
                        const SizedBox(height: 16),
                        Expanded(
                          child: viewModel.yukleniyor
                              ? const Center(child: CircularProgressIndicator())
                              : _RaporIzgarasi(kartlar: raporKartlari),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UstAlan extends StatelessWidget {
  const _UstAlan({
    required this.tema,
    required this.disaAktarimSuruyor,
    required this.gunlukCsvDisaAktar,
    required this.aylikCsvDisaAktar,
    required this.gunlukPdfYazdir,
    required this.aylikPdfYazdir,
  });

  final RestoranTemaRenkleri tema;
  final bool disaAktarimSuruyor;
  final Future<void> Function() gunlukCsvDisaAktar;
  final Future<void> Function() aylikCsvDisaAktar;
  final Future<void> Function() gunlukPdfYazdir;
  final Future<void> Function() aylikPdfYazdir;

  @override
  Widget build(BuildContext context) {
    final ThemeData temaVerisi = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: tema.anaArkaPlan.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: tema.metinIkincilAcik.withValues(alpha: 0.12),
        ),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          FilledButton.icon(
            onPressed: () => anaSayfayaDon(context),
            icon: const Icon(Icons.home_rounded),
            label: const Text('Ana sayfaya don'),
          ),
          FilledButton.tonalIcon(
            onPressed: () => Navigator.of(
              context,
            ).pushReplacementNamed(RotaYapisi.yonetimPaneli),
            icon: const Icon(Icons.dashboard_customize_rounded),
            label: const Text('Yonetim paneline don'),
          ),
          FilledButton.tonalIcon(
            onPressed: disaAktarimSuruyor ? null : gunlukCsvDisaAktar,
            icon: const Icon(Icons.table_view_rounded),
            label: const Text('Gunluk CSV'),
          ),
          FilledButton.tonalIcon(
            onPressed: disaAktarimSuruyor ? null : aylikCsvDisaAktar,
            icon: const Icon(Icons.date_range_rounded),
            label: const Text('Aylik CSV'),
          ),
          FilledButton.tonalIcon(
            onPressed: disaAktarimSuruyor ? null : gunlukPdfYazdir,
            icon: const Icon(Icons.picture_as_pdf_rounded),
            label: const Text('Gunluk PDF'),
          ),
          FilledButton.tonalIcon(
            onPressed: disaAktarimSuruyor ? null : aylikPdfYazdir,
            icon: const Icon(Icons.print_rounded),
            label: const Text('Aylik PDF'),
          ),
          Text(
            'Rapor Merkezi',
            style: temaVerisi.textTheme.headlineMedium?.copyWith(
              color: tema.metinBirincilAcik,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            'Yonetim raporlarini tek ekranda, yatay ve dengeli yerlesimle izle.',
            style: temaVerisi.textTheme.bodyLarge?.copyWith(
              color: tema.metinIkincilAcik.withValues(alpha: 0.90),
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltreSeridi extends StatelessWidget {
  const _FiltreSeridi({required this.viewModel});

  final YonetimPaneliViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: <Widget>[
        _SecimKutusu<ZamanFiltresi>(
          baslik: 'Zaman',
          seciliDeger: viewModel.seciliZamanFiltresi,
          secenekler: const <(ZamanFiltresi, String)>[
            (ZamanFiltresi.bugun, 'Bugun'),
            (ZamanFiltresi.sonIkiSaat, 'Son 2 saat'),
            (ZamanFiltresi.tumu, 'Tum zaman'),
          ],
          degisti: viewModel.zamanFiltresiSec,
        ),
        _SecimKutusu<SiparisSirasi>(
          baslik: 'Sirala',
          seciliDeger: viewModel.seciliSiralama,
          secenekler: const <(SiparisSirasi, String)>[
            (SiparisSirasi.enYeni, 'En yeni'),
            (SiparisSirasi.tutarYuksek, 'Tutar'),
            (SiparisSirasi.durumOncelikli, 'Durum'),
          ],
          degisti: viewModel.siralamaSec,
        ),
        ...PanelFiltre.values.map(
          (PanelFiltre filtre) => ChoiceChip(
            selected: viewModel.seciliFiltre == filtre,
            label: Text(_filtreEtiketi(filtre)),
            onSelected: (_) => viewModel.filtreSec(filtre),
          ),
        ),
      ],
    );
  }

  String _filtreEtiketi(PanelFiltre filtre) {
    return switch (filtre) {
      PanelFiltre.tumu => 'Tumu',
      PanelFiltre.aktif => 'Aktif',
      PanelFiltre.gelAl => 'Gel al',
      PanelFiltre.paketServis => 'Paket',
      PanelFiltre.restorandaYe => 'Salon',
    };
  }
}

class _SecimKutusu<T> extends StatelessWidget {
  const _SecimKutusu({
    required this.baslik,
    required this.seciliDeger,
    required this.secenekler,
    required this.degisti,
  });

  final String baslik;
  final T seciliDeger;
  final List<(T, String)> secenekler;
  final ValueChanged<T> degisti;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$baslik: ',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: seciliDeger,
              dropdownColor: const Color(0xFF2B1D3A),
              borderRadius: BorderRadius.circular(14),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              iconEnabledColor: Colors.white,
              items: secenekler
                  .map(
                    ((T, String) secenek) => DropdownMenuItem<T>(
                      value: secenek.$1,
                      child: Text(secenek.$2),
                    ),
                  )
                  .toList(),
              onChanged: (T? deger) {
                if (deger != null) {
                  degisti(deger);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RaporIzgarasi extends StatelessWidget {
  const _RaporIzgarasi({required this.kartlar});

  final List<Widget> kartlar;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double genislik = constraints.maxWidth;
        final int kolonSayisi = switch (genislik) {
          >= 1420 => 3,
          >= 980 => 2,
          _ => 1,
        };
        final double bosluk = 14;
        final double kartGenisligi =
            (genislik - ((kolonSayisi - 1) * bosluk)) / kolonSayisi;

        return SingleChildScrollView(
          child: Wrap(
            spacing: bosluk,
            runSpacing: bosluk,
            children: kartlar
                .map(
                  (Widget kart) => SizedBox(width: kartGenisligi, child: kart),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
