import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bilesenler/ana_sayfaya_donus.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/pos_masa_urun_baglami_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_baglami_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_secenegi_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/menu/sunum/bilesenler/musteri_menu_ust_cubugu.dart';
import 'package:restoran_app/ozellikler/menu/sunum/viewmodel/musteri_menu_viewmodel.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_ozeti_girdisi_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

class MusteriMenuSayfasi extends StatefulWidget {
  const MusteriMenuSayfasi({
    super.key,
    required this.viewModel,
    this.qrModu = false,
    this.qrBaglami,
  });

  final MusteriMenuViewModel viewModel;
  final bool qrModu;
  final QrMenuBaglamiVarligi? qrBaglami;

  @override
  State<MusteriMenuSayfasi> createState() => _MusteriMenuSayfasiState();
}

class _MusteriMenuSayfasiState extends State<MusteriMenuSayfasi> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verileriYukle();
    });
  }

  @override
  void didUpdateWidget(covariant MusteriMenuSayfasi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel == widget.viewModel) {
      return;
    }
    oldWidget.viewModel.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verileriYukle();
    });
  }

  Future<void> _verileriYukle() async {
    final MusteriMenuIslemSonucu sonuc = await widget.viewModel.verileriYukle();
    if (!mounted || sonuc.basarili) {
      return;
    }
    _hataBildir(sonuc.mesaj);
  }

  Future<void> _kategoriSec(String kategoriId) async {
    final MusteriMenuIslemSonucu sonuc = await widget.viewModel.kategoriSec(
      kategoriId,
    );
    if (!mounted || sonuc.basarili) {
      return;
    }
    _hataBildir(sonuc.mesaj);
  }

  Future<void> _tumKategorileriGoster() async {
    final MusteriMenuIslemSonucu sonuc = await widget.viewModel
        .tumKategorileriGoster();
    if (!mounted || sonuc.basarili) {
      return;
    }
    _hataBildir(sonuc.mesaj);
  }

  Future<void> _sepeteEkle(
    UrunVarligi urun, {
    int adet = 1,
    String? secenekId,
    String? notMetni,
  }) async {
    final MusteriMenuIslemSonucu sonuc = await widget.viewModel.sepeteEkle(
      urun,
      adet: adet,
      secenekId: secenekId,
      notMetni: notMetni,
    );
    if (!mounted) {
      return;
    }
    if (sonuc.basarili) {
      if (sonuc.mesaj.isNotEmpty) {
        _bilgiBildir(sonuc.mesaj);
      }
      return;
    }
    _hataBildir(sonuc.mesaj);
  }

  Future<void> _kalemAdediniGuncelle({
    required SepetKalemiVarligi kalem,
    required int yeniAdet,
  }) async {
    final MusteriMenuIslemSonucu sonuc = await widget.viewModel
        .kalemAdediniGuncelle(kalem: kalem, yeniAdet: yeniAdet);
    if (!mounted || sonuc.basarili) {
      return;
    }
    _hataBildir(sonuc.mesaj);
  }

  Future<void> _kalemiSil(SepetKalemiVarligi kalem) async {
    await _kalemAdediniGuncelle(kalem: kalem, yeniAdet: 0);
  }

  Future<void> _urunDetayiniAc(UrunVarligi urun) async {
    final _SepeteEkleTalebi? talep =
        await showModalBottomSheet<_SepeteEkleTalebi>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return _UrunDetayAltSayfasi(urun: urun);
          },
        );

    if (talep == null) {
      return;
    }

    await _sepeteEkle(
      urun,
      adet: talep.adet,
      secenekId: talep.secenekId,
      notMetni: talep.notMetni,
    );
  }

  Future<void> _siparisiHazirla() async {
    if (widget.viewModel.sepet.kalemler.isEmpty) {
      return;
    }
    final QrMenuBaglamiVarligi? aktifBaglam = _aktifSiparisBaglami();
    if (!widget.qrModu && aktifBaglam == null) {
      _hataBildir('Siparis olusturmadan once salon ve masa secmelisin');
      return;
    }

    final bool? siparisTamamlandi =
        await Navigator.of(context).pushNamed(
              RotaYapisi.siparisOzeti,
              arguments: SiparisOzetiGirdisiVarligi(
                sepet: widget.viewModel.sepet,
                qrBaglami: aktifBaglam,
              ),
            )
            as bool?;

    if (siparisTamamlandi != true || !mounted) {
      return;
    }

    final MusteriMenuIslemSonucu sonuc = await widget.viewModel
        .siparisSonrasiYenile();
    if (!mounted || sonuc.basarili) {
      return;
    }
    _hataBildir(sonuc.mesaj);
  }

  void _salonBolumuSec(String bolumId) {
    widget.viewModel.salonBolumuSec(bolumId);
  }

  void _masaSec(String masaId) {
    widget.viewModel.masaSec(masaId);
  }

  QrMenuBaglamiVarligi? _aktifSiparisBaglami() {
    if (widget.qrModu) {
      return widget.qrBaglami;
    }
    return widget.viewModel.posMasaUrunBaglami?.qrBaglami;
  }

  void _bilgiBildir(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        backgroundColor: const Color(0xFF2B1243),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: SizedBox(
          height: 64,
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE94274).withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFFFF7BA2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  mesaj,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _hataBildir(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 300,
        backgroundColor: const Color(0xFF5A1622),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: Text(
          mesaj,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (BuildContext context, _) {
        final Size ekranBoyutu = MediaQuery.sizeOf(context);
        final bool masaustu = EkranBoyutu.masaustu(context);
        final bool genisMasaustu = masaustu;
        final bool ferahMasaustu =
            masaustu && ekranBoyutu.width >= 1500 && ekranBoyutu.height >= 860;
        final bool tablet = !masaustu && EkranBoyutu.tablet(context);
        final MusteriMenuViewModel viewModel = widget.viewModel;
        final QrMenuBaglamiVarligi? aktifBaglam = _aktifSiparisBaglami();
        final PosMasaUrunBaglamiVarligi? posBaglami = widget.qrModu
            ? null
            : viewModel.posMasaUrunBaglami;
        final Widget adisyonPaneli = _AdisyonPaneli(
          sepet: viewModel.sepet,
          islemedeMi: viewModel.yukleniyor,
          seciliBolumAdi:
              aktifBaglam?.bolumAdi ?? viewModel.seciliSalonBolumu?.ad,
          seciliMasaAdi: aktifBaglam?.masaNo ?? viewModel.seciliMasa?.ad,
          siparisiHazirla: _siparisiHazirla,
          kalemAdediniGuncelle: _kalemAdediniGuncelle,
          kalemiSil: _kalemiSil,
        );
        final Widget salonMasaPaneli = widget.qrModu
            ? const SizedBox.shrink()
            : _PosSalonMasaPaneli(
                salonBolumleri: viewModel.salonBolumleri,
                seciliSalonBolumuId: viewModel.seciliSalonBolumuId,
                seciliMasaId: viewModel.seciliMasaId,
                salonBolumuSec: _salonBolumuSec,
                masaSec: _masaSec,
              );
        final Widget? baglamPaneli = widget.qrModu
            ? (widget.qrBaglami != null
                  ? QrBaglamDurumKarti(qrBaglami: widget.qrBaglami!)
                  : null)
            : (posBaglami != null
                  ? _PosBaglamDurumKarti(baglam: posBaglami)
                  : null);

        return Scaffold(
          backgroundColor: const Color(0xFF12081F),
          body: Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF371453),
                        Color(0xFF211231),
                        Color(0xFF12081F),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -110,
                left: -80,
                child: _PosParlama(
                  cap: 320,
                  renk: const Color(0xFFE85C8C).withValues(alpha: 0.16),
                ),
              ),
              Positioned(
                top: 90,
                right: -30,
                child: _PosParlama(
                  cap: 260,
                  renk: const Color(0xFF8D53E9).withValues(alpha: 0.14),
                ),
              ),
              Positioned(
                bottom: -120,
                left: MediaQuery.sizeOf(context).width * 0.18,
                child: _PosParlama(
                  cap: 300,
                  renk: const Color(0xFFFF8A63).withValues(alpha: 0.10),
                ),
              ),
              SafeArea(
                child: viewModel.yukleniyor && viewModel.kategoriler.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1540),
                          child: Padding(
                            padding: EdgeInsets.all(genisMasaustu ? 18 : 12),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(
                                      0xFF231332,
                                    ).withValues(alpha: 0.96),
                                    const Color(
                                      0xFF1B102A,
                                    ).withValues(alpha: 0.96),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(34),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                                boxShadow: [
                                  const BoxShadow(
                                    color: Color(0x55000000),
                                    blurRadius: 44,
                                    offset: Offset(0, 24),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(34),
                                child: genisMasaustu
                                    ? _PosMasaustuYerlesim(
                                        qrModu: widget.qrModu,
                                        ferahMod: ferahMasaustu,
                                        seciliKategoriAdi:
                                            viewModel.seciliKategoriAdi,
                                        toplamUrunAdedi:
                                            viewModel.sepet.toplamUrunAdedi,
                                        salonMasaPaneli: salonMasaPaneli,
                                        baglamPaneli: baglamPaneli,
                                        hizliIslemSeridi: _HizliIslemSeridi(
                                          siparisAdedi:
                                              viewModel.sepet.toplamUrunAdedi,
                                          yatay: true,
                                          satiraSar: true,
                                          mikroKart: !ferahMasaustu,
                                        ),
                                        adisyonPaneli: adisyonPaneli,
                                        urunMerkezi: _UrunMerkezi(
                                          urunler: viewModel.urunler,
                                          seciliKategoriAdi:
                                              viewModel.seciliKategoriAdi,
                                          masaustu: true,
                                          urunDetayiAc: _urunDetayiniAc,
                                          islemedeMi: viewModel.yukleniyor,
                                          toplamUrunAdedi:
                                              viewModel.sepet.toplamUrunAdedi,
                                        ),
                                        kategoriPaneli: _KategoriPaneli(
                                          kategoriler: viewModel.kategoriler,
                                          seciliKategoriId:
                                              viewModel.seciliKategoriId,
                                          kategoriSec: _kategoriSec,
                                          tumunuSec: _tumKategorileriGoster,
                                        ),
                                      )
                                    : _PosMobilYerlesim(
                                        qrModu: widget.qrModu,
                                        seciliKategoriAdi:
                                            viewModel.seciliKategoriAdi,
                                        toplamUrunAdedi:
                                            viewModel.sepet.toplamUrunAdedi,
                                        baglamPaneli: baglamPaneli,
                                        salonMasaPaneli: salonMasaPaneli,
                                        hizliIslemSeridi: _HizliIslemSeridi(
                                          siparisAdedi:
                                              viewModel.sepet.toplamUrunAdedi,
                                          yatay: true,
                                        ),
                                        kategoriPaneli: _KategoriPaneli(
                                          kategoriler: viewModel.kategoriler,
                                          seciliKategoriId:
                                              viewModel.seciliKategoriId,
                                          kategoriSec: _kategoriSec,
                                          tumunuSec: _tumKategorileriGoster,
                                          yatay: true,
                                        ),
                                        urunMerkezi: _UrunMerkezi(
                                          urunler: viewModel.urunler,
                                          seciliKategoriAdi:
                                              viewModel.seciliKategoriAdi,
                                          masaustu: false,
                                          urunDetayiAc: _urunDetayiniAc,
                                          islemedeMi: viewModel.yukleniyor,
                                          toplamUrunAdedi:
                                              viewModel.sepet.toplamUrunAdedi,
                                          tablet: tablet,
                                          mobilYukseklik: tablet ? 760 : 620,
                                        ),
                                        adisyonPaneli: SizedBox(
                                          height: 420,
                                          child: adisyonPaneli,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PosParlama extends StatelessWidget {
  const _PosParlama({required this.cap, required this.renk});

  final double cap;
  final Color renk;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: cap,
        height: cap,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [renk, renk.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}

class _PosMasaustuYerlesim extends StatelessWidget {
  const _PosMasaustuYerlesim({
    required this.qrModu,
    required this.ferahMod,
    required this.seciliKategoriAdi,
    required this.toplamUrunAdedi,
    required this.salonMasaPaneli,
    required this.baglamPaneli,
    required this.hizliIslemSeridi,
    required this.adisyonPaneli,
    required this.urunMerkezi,
    required this.kategoriPaneli,
  });

  final bool qrModu;
  final bool ferahMod;
  final String seciliKategoriAdi;
  final int toplamUrunAdedi;
  final Widget salonMasaPaneli;
  final Widget? baglamPaneli;
  final Widget hizliIslemSeridi;
  final Widget adisyonPaneli;
  final Widget urunMerkezi;
  final Widget kategoriPaneli;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, kisit) {
        final double solGenislik = (kisit.maxWidth * (ferahMod ? 0.33 : 0.36))
            .clamp(400.0, 540.0);
        return Padding(
          padding: EdgeInsets.all(ferahMod ? 16 : 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: solGenislik,
                child: _PosSolPanel(
                  qrModu: qrModu,
                  seciliKategoriAdi: seciliKategoriAdi,
                  toplamUrunAdedi: toplamUrunAdedi,
                  salonMasaPaneli: salonMasaPaneli,
                  baglamPaneli: baglamPaneli,
                  hizliIslemSeridi: hizliIslemSeridi,
                  adisyonPaneli: adisyonPaneli,
                ),
              ),
              SizedBox(width: ferahMod ? 16 : 12),
              Expanded(
                child: _PosSagPanel(
                  seciliKategoriAdi: seciliKategoriAdi,
                  toplamUrunAdedi: toplamUrunAdedi,
                  urunMerkezi: urunMerkezi,
                  kategoriPaneli: kategoriPaneli,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PosMobilYerlesim extends StatelessWidget {
  const _PosMobilYerlesim({
    required this.qrModu,
    required this.seciliKategoriAdi,
    required this.toplamUrunAdedi,
    required this.baglamPaneli,
    required this.salonMasaPaneli,
    required this.hizliIslemSeridi,
    required this.kategoriPaneli,
    required this.urunMerkezi,
    required this.adisyonPaneli,
  });

  final bool qrModu;
  final String seciliKategoriAdi;
  final int toplamUrunAdedi;
  final Widget? baglamPaneli;
  final Widget salonMasaPaneli;
  final Widget hizliIslemSeridi;
  final Widget kategoriPaneli;
  final Widget urunMerkezi;
  final Widget adisyonPaneli;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _PosMobilUstKart(
          qrModu: qrModu,
          seciliKategoriAdi: seciliKategoriAdi,
          toplamUrunAdedi: toplamUrunAdedi,
        ),
        const SizedBox(height: 12),
        if (!qrModu) ...[salonMasaPaneli, const SizedBox(height: 12)],
        if (baglamPaneli != null) ...[
          baglamPaneli!,
          const SizedBox(height: 12),
        ],
        hizliIslemSeridi,
        const SizedBox(height: 12),
        kategoriPaneli,
        const SizedBox(height: 12),
        urunMerkezi,
        const SizedBox(height: 12),
        adisyonPaneli,
      ],
    );
  }
}

class _PosSolPanel extends StatelessWidget {
  const _PosSolPanel({
    required this.qrModu,
    required this.seciliKategoriAdi,
    required this.toplamUrunAdedi,
    required this.salonMasaPaneli,
    required this.baglamPaneli,
    required this.hizliIslemSeridi,
    required this.adisyonPaneli,
  });

  final bool qrModu;
  final String seciliKategoriAdi;
  final int toplamUrunAdedi;
  final Widget salonMasaPaneli;
  final Widget? baglamPaneli;
  final Widget hizliIslemSeridi;
  final Widget adisyonPaneli;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints kisitlar) {
        final double adisyonYuksekligi = math.min(
          qrModu ? 360 : 420,
          math.max(qrModu ? 260 : 300, kisitlar.maxHeight * 0.34),
        );

        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  qrModu ? 'QR MENU AKISI' : 'POS OPERASYON',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$seciliKategoriAdi kategorisinde $toplamUrunAdedi urun aktif.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white60,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 18),
                _PosSolBilgiRozetleri(
                  qrModu: qrModu,
                  toplamUrunAdedi: toplamUrunAdedi,
                ),
                const SizedBox(height: 18),
                if (!qrModu) ...[salonMasaPaneli, const SizedBox(height: 14)],
                if (baglamPaneli != null) ...[
                  baglamPaneli!,
                  const SizedBox(height: 14),
                ],
                hizliIslemSeridi,
                const SizedBox(height: 14),
                SizedBox(height: adisyonYuksekligi, child: adisyonPaneli),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PosSagPanel extends StatelessWidget {
  const _PosSagPanel({
    required this.seciliKategoriAdi,
    required this.toplamUrunAdedi,
    required this.urunMerkezi,
    required this.kategoriPaneli,
  });

  final String seciliKategoriAdi;
  final int toplamUrunAdedi;
  final Widget urunMerkezi;
  final Widget kategoriPaneli;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PosUstKart(
          seciliKategoriAdi: seciliKategoriAdi,
          toplamUrunAdedi: toplamUrunAdedi,
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: urunMerkezi),
              const SizedBox(width: 14),
              SizedBox(width: 176, child: kategoriPaneli),
            ],
          ),
        ),
      ],
    );
  }
}

class _PosUstKart extends StatelessWidget {
  const _PosUstKart({
    required this.seciliKategoriAdi,
    required this.toplamUrunAdedi,
  });

  final String seciliKategoriAdi;
  final int toplamUrunAdedi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE85C8C).withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.restaurant_menu_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mutfak ve servis icin sade POS akisi',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$seciliKategoriAdi secili. Operasyonda $toplamUrunAdedi urun izleniyor.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white60),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _PosUstAksiyon(
                ikon: Icons.home_rounded,
                etiket: 'Ana sayfa',
                tikla: () => anaSayfayaDon(context),
              ),
              _PosUstAksiyon(
                ikon: Icons.dashboard_customize_rounded,
                etiket: 'Yonetim',
                tikla: () =>
                    Navigator.of(context).pushNamed(RotaYapisi.yonetimPaneli),
              ),
              _PosUstAksiyon(
                ikon: Icons.badge_outlined,
                etiket: 'Personel',
                tikla: () =>
                    Navigator.of(context).pushNamed(RotaYapisi.personelGiris),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PosMobilUstKart extends StatelessWidget {
  const _PosMobilUstKart({
    required this.qrModu,
    required this.seciliKategoriAdi,
    required this.toplamUrunAdedi,
  });

  final bool qrModu;
  final String seciliKategoriAdi;
  final int toplamUrunAdedi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            qrModu ? 'QR MENU AKISI' : 'POS OPERASYON',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$seciliKategoriAdi secili. $toplamUrunAdedi urun aktif.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white60),
          ),
          const SizedBox(height: 16),
          _PosSolBilgiRozetleri(
            qrModu: qrModu,
            toplamUrunAdedi: toplamUrunAdedi,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => anaSayfayaDon(context),
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.home_rounded, size: 18),
                label: const Text('Ana sayfaya don'),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamed(RotaYapisi.personelGiris),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.badge_outlined, size: 18),
                label: const Text('Personel girisi'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PosSolBilgiRozetleri extends StatelessWidget {
  const _PosSolBilgiRozetleri({
    required this.qrModu,
    required this.toplamUrunAdedi,
  });

  final bool qrModu;
  final int toplamUrunAdedi;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _PosBilgiRozeti(
          ikon: qrModu ? Icons.qr_code_2_rounded : Icons.point_of_sale_rounded,
          etiket: qrModu ? 'QR mod' : 'POS aktif',
        ),
        _PosBilgiRozeti(
          ikon: Icons.shopping_bag_outlined,
          etiket: '$toplamUrunAdedi urun',
        ),
      ],
    );
  }
}

class _PosBilgiRozeti extends StatelessWidget {
  const _PosBilgiRozeti({required this.ikon, required this.etiket});

  final IconData ikon;
  final String etiket;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            etiket,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PosUstAksiyon extends StatelessWidget {
  const _PosUstAksiyon({
    required this.ikon,
    required this.etiket,
    required this.tikla,
  });

  final IconData ikon;
  final String etiket;
  final VoidCallback tikla;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tikla,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ikon, color: Colors.white70, size: 16),
            const SizedBox(width: 8),
            Text(
              etiket,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PosSalonMasaPaneli extends StatelessWidget {
  const _PosSalonMasaPaneli({
    required this.salonBolumleri,
    required this.seciliSalonBolumuId,
    required this.seciliMasaId,
    required this.salonBolumuSec,
    required this.masaSec,
  });

  final List<SalonBolumuVarligi> salonBolumleri;
  final String? seciliSalonBolumuId;
  final String? seciliMasaId;
  final ValueChanged<String> salonBolumuSec;
  final ValueChanged<String> masaSec;

  @override
  Widget build(BuildContext context) {
    if (salonBolumleri.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          'Salon ve masa tanimi bulunamadi. Yonetim panelinden masa plani ekleyebilirsin.',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      );
    }

    final SalonBolumuVarligi seciliBolum = _seciliBolumuBul();
    final List<MasaTanimiVarligi> masalar = seciliBolum.masalar;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF372044).withValues(alpha: 0.88),
            const Color(0xFF23152E).withValues(alpha: 0.92),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE85C8C).withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.table_restaurant_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Salon ve Masa Secimi',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Siparis acmadan once aktif bolum ve masayi belirle.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: salonBolumleri.map((SalonBolumuVarligi bolum) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _SalonButonu(
                    etiket: bolum.ad,
                    seciliMi: bolum.id == seciliBolum.id,
                    tikla: () => salonBolumuSec(bolum.id),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          if (masalar.isEmpty)
            const Text(
              'Bu bolumde masa yok.',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: masalar.map((MasaTanimiVarligi masa) {
                return _MasaButonu(
                  etiket: 'Masa ${masa.ad}',
                  kapasite: masa.kapasite,
                  seciliMi: masa.id == seciliMasaId,
                  tikla: () => masaSec(masa.id),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  SalonBolumuVarligi _seciliBolumuBul() {
    for (final SalonBolumuVarligi bolum in salonBolumleri) {
      if (bolum.id == seciliSalonBolumuId) {
        return bolum;
      }
    }
    return salonBolumleri.first;
  }
}

class _PosBaglamDurumKarti extends StatelessWidget {
  const _PosBaglamDurumKarti({required this.baglam});

  final PosMasaUrunBaglamiVarligi baglam;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF5B2247).withValues(alpha: 0.88),
            const Color(0xFF2B1736).withValues(alpha: 0.96),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.point_of_sale_rounded, color: Colors.white),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baglam.baslik,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  baglam.ozetMetni,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                _PosVarlikSatiri(
                  etiket: 'Salon varligi',
                  deger: baglam.salonBolumu.ad,
                ),
                const SizedBox(height: 6),
                _PosVarlikSatiri(
                  etiket: 'Masa varligi',
                  deger:
                      'Masa ${baglam.masa.ad} · ${baglam.masa.kapasite} kisilik',
                ),
                const SizedBox(height: 6),
                _PosVarlikSatiri(
                  etiket: 'Urun varliklari',
                  deger: _urunOzetiniHazirla(baglam.urunler),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _PosDurumRozeti(
                ikon: Icons.room_service_outlined,
                etiket: baglam.salonBolumu.ad,
              ),
              _PosDurumRozeti(
                ikon: Icons.table_restaurant_rounded,
                etiket: 'Masa ${baglam.masa.ad}',
              ),
              _PosDurumRozeti(
                ikon: Icons.restaurant_menu_rounded,
                etiket: '${baglam.toplamUrunSayisi} urun',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _urunOzetiniHazirla(List<UrunVarligi> urunler) {
    if (urunler.isEmpty) {
      return 'Urun bulunamadi';
    }
    final List<String> etiketler = urunler
        .take(3)
        .map((UrunVarligi urun) => urun.ad)
        .toList();
    if (urunler.length > 3) {
      etiketler.add('+${urunler.length - 3} urun');
    }
    return etiketler.join(', ');
  }
}

class _PosDurumRozeti extends StatelessWidget {
  const _PosDurumRozeti({required this.ikon, required this.etiket});

  final IconData ikon;
  final String etiket;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 14, color: const Color(0xFFFFC8D9)),
          const SizedBox(width: 6),
          Text(
            etiket,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PosVarlikSatiri extends StatelessWidget {
  const _PosVarlikSatiri({required this.etiket, required this.deger});

  final String etiket;
  final String deger;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$etiket: $deger',
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.9),
        fontWeight: FontWeight.w700,
        height: 1.35,
      ),
    );
  }
}

class _SalonButonu extends StatelessWidget {
  const _SalonButonu({
    required this.etiket,
    required this.seciliMi,
    required this.tikla,
  });

  final String etiket;
  final bool seciliMi;
  final VoidCallback tikla;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tikla,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: seciliMi
              ? const LinearGradient(
                  colors: [Color(0xFFE35383), Color(0xFFB93E87)],
                )
              : null,
          color: seciliMi ? null : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Text(
          etiket,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _MasaButonu extends StatelessWidget {
  const _MasaButonu({
    required this.etiket,
    required this.kapasite,
    required this.seciliMi,
    required this.tikla,
  });

  final String etiket;
  final int kapasite;
  final bool seciliMi;
  final VoidCallback tikla;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tikla,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          gradient: seciliMi
              ? const LinearGradient(
                  colors: [Color(0xFFF6E7F4), Color(0xFFFFFFFF)],
                )
              : null,
          color: seciliMi ? null : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: seciliMi
                ? Colors.white
                : Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.table_restaurant_rounded,
              size: 16,
              color: seciliMi ? const Color(0xFF4A295F) : Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              etiket,
              style: TextStyle(
                color: seciliMi ? const Color(0xFF4A295F) : Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: seciliMi
                    ? const Color(0xFFF3EAFE)
                    : Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$kapasite kisilik',
                style: TextStyle(
                  color: seciliMi ? const Color(0xFF7B5A90) : Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HizliIslemSeridi extends StatelessWidget {
  const _HizliIslemSeridi({
    required this.siparisAdedi,
    this.yatay = false,
    this.satiraSar = false,
    this.mikroKart = false,
  });

  final int siparisAdedi;
  final bool yatay;
  final bool satiraSar;
  final bool mikroKart;

  @override
  Widget build(BuildContext context) {
    final List<_HizliIslem> islemler = <_HizliIslem>[
      const _HizliIslem(Icons.add_circle, 'Yeni'),
      _HizliIslem(Icons.table_restaurant, 'Salon', rozet: '$siparisAdedi'),
      const _HizliIslem(Icons.redeem, 'Ikram'),
      const _HizliIslem(Icons.percent, 'Indirim'),
      const _HizliIslem(Icons.payments, 'Odeme'),
      const _HizliIslem(Icons.cancel, 'Iptal'),
    ];

    final Widget icerik = satiraSar
        ? LayoutBuilder(
            builder: (BuildContext context, BoxConstraints kisitlar) {
              final double kutuGenisligi = (kisitlar.maxWidth - 20) / 3;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: islemler
                    .map(
                      (_HizliIslem islem) => SizedBox(
                        width: kutuGenisligi,
                        child: _HizliIslemKutusu(
                          islem: islem,
                          seciliMi: islem.baslik.startsWith('Salon'),
                          kompakt: true,
                          mikro: mikroKart,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          )
        : yatay
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: islemler
                  .map(
                    (islem) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _HizliIslemKutusu(
                        islem: islem,
                        seciliMi: islem.baslik.startsWith('Salon'),
                        yatay: true,
                        mikro: mikroKart,
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: islemler
                  .map(
                    (islem) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _HizliIslemKutusu(
                        islem: islem,
                        seciliMi: islem.baslik.startsWith('Salon'),
                        mikro: mikroKart,
                      ),
                    ),
                  )
                  .toList(),
            ),
          );

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF35203E).withValues(alpha: 0.92),
            const Color(0xFF24172B).withValues(alpha: 0.96),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: icerik,
    );
  }
}

class _HizliIslem {
  const _HizliIslem(this.ikon, this.baslik, {this.rozet});

  final IconData ikon;
  final String baslik;
  final String? rozet;
}

class _HizliIslemKutusu extends StatelessWidget {
  const _HizliIslemKutusu({
    required this.islem,
    required this.seciliMi,
    this.yatay = false,
    this.kompakt = false,
    this.mikro = false,
  });

  final _HizliIslem islem;
  final bool seciliMi;
  final bool yatay;
  final bool kompakt;
  final bool mikro;

  @override
  Widget build(BuildContext context) {
    final bool kucukMod = kompakt || mikro;

    return Container(
      width: yatay ? (mikro ? 82 : 96) : double.infinity,
      height: kucukMod ? 78 : (yatay ? 92 : 84),
      padding: EdgeInsets.symmetric(
        horizontal: mikro ? 4 : (kompakt ? 6 : 8),
        vertical: mikro ? 6 : (kompakt ? 8 : 10),
      ),
      decoration: BoxDecoration(
        gradient: seciliMi
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE85D89), Color(0xFFB84286)],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFAF4FF), Color(0xFFF0E2F6)],
              ),
        borderRadius: BorderRadius.circular(mikro ? 18 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: seciliMi ? 0.18 : 0.06),
            blurRadius: mikro ? 8 : 12,
            offset: Offset(0, mikro ? 5 : 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            islem.ikon,
            color: seciliMi ? Colors.white : const Color(0xFF8C5BA8),
            size: mikro ? 15 : (kompakt ? 18 : 22),
          ),
          SizedBox(height: mikro ? 2 : (kompakt ? 4 : 6)),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                islem.baslik,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  color: seciliMi ? Colors.white : const Color(0xFF5D4D6C),
                  fontWeight: FontWeight.w700,
                  fontSize: mikro ? 9.5 : (kompakt ? 11 : 13),
                ),
              ),
            ),
          ),
          if (islem.rozet != null) ...[
            SizedBox(height: mikro ? 1 : (kompakt ? 2 : 4)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: mikro ? 5 : (kompakt ? 6 : 8),
                vertical: mikro ? 1 : 2,
              ),
              decoration: BoxDecoration(
                color: seciliMi
                    ? Colors.white.withValues(alpha: 0.18)
                    : const Color(0xFFF4EBFA),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                islem.rozet!,
                style: TextStyle(
                  color: seciliMi ? Colors.white : const Color(0xFF8C5BA8),
                  fontWeight: FontWeight.w800,
                  fontSize: mikro ? 8.5 : (kompakt ? 10 : 11),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AdisyonPaneli extends StatelessWidget {
  const _AdisyonPaneli({
    required this.sepet,
    required this.islemedeMi,
    required this.seciliBolumAdi,
    required this.seciliMasaAdi,
    required this.siparisiHazirla,
    required this.kalemAdediniGuncelle,
    required this.kalemiSil,
  });

  final SepetVarligi sepet;
  final bool islemedeMi;
  final String? seciliBolumAdi;
  final String? seciliMasaAdi;
  final VoidCallback siparisiHazirla;
  final Future<void> Function({
    required SepetKalemiVarligi kalem,
    required int yeniAdet,
  })
  kalemAdediniGuncelle;
  final Future<void> Function(SepetKalemiVarligi kalem) kalemiSil;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF24192F), Color(0xFF1A1222)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE85C8C).withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    seciliBolumAdi ?? 'Salon secilmedi',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE85C8C).withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    seciliMasaAdi != null ? 'Masa $seciliMasaAdi' : 'Masa sec',
                    style: const TextStyle(
                      color: Color(0xFFFFC6D8),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: sepet.kalemler.isEmpty
                  ? const _BosAdisyonDurumu()
                  : Column(
                      children: [
                        _AdisyonOzetSeridi(sepet: sepet),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.separated(
                            itemCount: sepet.kalemler.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (BuildContext context, int index) {
                              final SepetKalemiVarligi kalem =
                                  sepet.kalemler[index];
                              return _AdisyonSatiri(
                                kalem: kalem,
                                islemedeMi: islemedeMi,
                                adetAzalt: () => kalemAdediniGuncelle(
                                  kalem: kalem,
                                  yeniAdet: kalem.adet - 1,
                                ),
                                adetArtir: () => kalemAdediniGuncelle(
                                  kalem: kalem,
                                  yeniAdet: kalem.adet + 1,
                                ),
                                sil: () => kalemiSil(kalem),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
            child: Column(
              children: [
                const Divider(height: 1),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      'Ara toplam',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white70),
                    ),
                    const Spacer(),
                    Text(
                      _paraYaz(sepet.araToplam),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: sepet.kalemler.isEmpty || islemedeMi
                        ? null
                        : siparisiHazirla,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2AB36D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('ODEME AL'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdisyonOzetSeridi extends StatelessWidget {
  const _AdisyonOzetSeridi({required this.sepet});

  final SepetVarligi sepet;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _AdisyonOzetKutusu(
          baslik: 'Kalem',
          deger: '${sepet.kalemler.length}',
          vurguRengi: const Color(0xFFE04374),
        ),
        _AdisyonOzetKutusu(
          baslik: 'Urun',
          deger: '${sepet.toplamUrunAdedi}',
          vurguRengi: const Color(0xFF8C5BA8),
        ),
        _AdisyonOzetKutusu(
          baslik: 'Toplam',
          deger: _paraYaz(sepet.araToplam),
          vurguRengi: const Color(0xFF2AB36D),
        ),
      ],
    );
  }
}

class _AdisyonOzetKutusu extends StatelessWidget {
  const _AdisyonOzetKutusu({
    required this.baslik,
    required this.deger,
    required this.vurguRengi,
  });

  final String baslik;
  final String deger;
  final Color vurguRengi;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 86),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: vurguRengi.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: vurguRengi.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: TextStyle(
              color: vurguRengi,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            deger,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _BosAdisyonDurumu extends StatelessWidget {
  const _BosAdisyonDurumu();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF7D9E4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: Color(0xFFFF9AB9),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Adisyon henuz bos',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Sag taraftaki menuden urun secerek siparis akisini baslatabilirsin.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _AdisyonSatiri extends StatelessWidget {
  const _AdisyonSatiri({
    required this.kalem,
    required this.islemedeMi,
    required this.adetAzalt,
    required this.adetArtir,
    required this.sil,
  });

  final SepetKalemiVarligi kalem;
  final bool islemedeMi;
  final VoidCallback adetAzalt;
  final VoidCallback adetArtir;
  final VoidCallback sil;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${kalem.adet}x',
                style: const TextStyle(
                  color: Color(0xFFFF8FB1),
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kalem.urun.ad,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                    if ((kalem.secenekAdi ?? '').isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        kalem.secenekAdi!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFFF9AB9),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    if ((kalem.notMetni ?? '').isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        kalem.notMetni!,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.white60),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                _paraYaz(kalem.araToplam),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _AdisyonAksiyonButonu(
                ikon: Icons.remove_rounded,
                etkinMi: !islemedeMi,
                tikla: adetAzalt,
              ),
              Container(
                width: 56,
                alignment: Alignment.center,
                child: Text(
                  '${kalem.adet}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
              _AdisyonAksiyonButonu(
                ikon: Icons.add_rounded,
                etkinMi: !islemedeMi,
                tikla: adetArtir,
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: islemedeMi ? null : sil,
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Sil'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdisyonAksiyonButonu extends StatelessWidget {
  const _AdisyonAksiyonButonu({
    required this.ikon,
    required this.etkinMi,
    required this.tikla,
  });

  final IconData ikon;
  final bool etkinMi;
  final VoidCallback tikla;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: etkinMi ? tikla : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: etkinMi
              ? const Color(0xFFE85C8C).withValues(alpha: 0.20)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          ikon,
          color: etkinMi ? const Color(0xFFFFA1BE) : const Color(0xFFAD9DBA),
        ),
      ),
    );
  }
}

class _UrunMerkezi extends StatelessWidget {
  const _UrunMerkezi({
    required this.urunler,
    required this.seciliKategoriAdi,
    required this.masaustu,
    required this.urunDetayiAc,
    required this.islemedeMi,
    required this.toplamUrunAdedi,
    this.tablet = false,
    this.mobilYukseklik,
  });

  final List<UrunVarligi> urunler;
  final String seciliKategoriAdi;
  final bool masaustu;
  final bool tablet;
  final ValueChanged<UrunVarligi> urunDetayiAc;
  final bool islemedeMi;
  final int toplamUrunAdedi;
  final double? mobilYukseklik;

  @override
  Widget build(BuildContext context) {
    final int kolonSayisi = masaustu ? 4 : (tablet ? 3 : 2);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1E36), Color(0xFF1D1425)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE85C8C).withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menuler  /  $seciliKategoriAdi',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white60),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$seciliKategoriAdi Secimleri',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Aktif secimde servis ekibine uygun hizli urun akislari.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white54,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        size: 18,
                        color: Color(0xFFE04374),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$toplamUrunAdedi urun',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (masaustu)
              Expanded(child: _grid(kolonSayisi))
            else
              SizedBox(
                height: mobilYukseklik ?? 620,
                child: _grid(kolonSayisi),
              ),
          ],
        ),
      ),
    );
  }

  Widget _grid(int kolonSayisi) {
    return GridView.builder(
      itemCount: urunler.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: kolonSayisi,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: masaustu ? 0.56 : 0.62,
      ),
      itemBuilder: (BuildContext context, int index) {
        final UrunVarligi urun = urunler[index];
        return _UrunKarti(
          urun: urun,
          urunDetayiAc: urunDetayiAc,
          islemedeMi: islemedeMi,
        );
      },
    );
  }
}

class _UrunKarti extends StatelessWidget {
  const _UrunKarti({
    required this.urun,
    required this.urunDetayiAc,
    required this.islemedeMi,
  });

  final UrunVarligi urun;
  final ValueChanged<UrunVarligi> urunDetayiAc;
  final bool islemedeMi;

  @override
  Widget build(BuildContext context) {
    final List<Color> renkler = _urunRenkleri(urun.id);
    final bool etkilesimeAcik = urun.stoktaMi && !islemedeMi;
    final bool kompaktKart = MediaQuery.sizeOf(context).width < 480;

    return Material(
      color: urun.stoktaMi ? const Color(0xFF22172C) : const Color(0xFF1A1320),
      borderRadius: BorderRadius.circular(18),
      shadowColor: Colors.black.withValues(alpha: 0.16),
      elevation: 6,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: etkilesimeAcik ? () => urunDetayiAc(urun) : null,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: kompaktKart ? 64 : 96,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: renkler,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _TabakDeseniPainter(renk: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.14),
                          ),
                        ),
                        child: Icon(
                          _kategoriIkonu(urun.ad),
                          color: Colors.white.withValues(alpha: 0.88),
                          size: 20,
                        ),
                      ),
                    ),
                    if (urun.oneCikanMi)
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFFFD36A,
                            ).withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: const Color(
                                0xFFFFD36A,
                              ).withValues(alpha: 0.28),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                color: Color(0xFFFFD36A),
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'One cikan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (!urun.stoktaMi)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Stokta yok',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: kompaktKart ? 6 : 10),
              Text(
                urun.ad,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: urun.stoktaMi ? Colors.white : const Color(0xFFB8A8C5),
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: kompaktKart ? 4 : 6),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  urun.aciklama,
                  maxLines: kompaktKart ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: urun.stoktaMi
                        ? Colors.white70
                        : const Color(0xFF9989A6),
                    height: 1.35,
                  ),
                ),
              ),
              SizedBox(height: kompaktKart ? 4 : 8),
              Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        urun.secenekler.isEmpty
                            ? _paraYaz(urun.fiyat)
                            : '${_paraYaz(urun.fiyat)}+',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: urun.stoktaMi
                                  ? const Color(0xFFE04374)
                                  : const Color(0xFF9E90A8),
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: urun.stoktaMi
                          ? const Color(0xFFE85C8C).withValues(alpha: 0.16)
                          : Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      etkilesimeAcik ? Icons.add_rounded : Icons.block_rounded,
                      size: 20,
                      color: urun.stoktaMi
                          ? const Color(0xFFFFA0BE)
                          : const Color(0xFF8D7C9A),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UrunDetayAltSayfasi extends StatefulWidget {
  const _UrunDetayAltSayfasi({required this.urun});

  final UrunVarligi urun;

  @override
  State<_UrunDetayAltSayfasi> createState() => _UrunDetayAltSayfasiState();
}

class _UrunDetayAltSayfasiState extends State<_UrunDetayAltSayfasi> {
  late final TextEditingController _notDenetleyici;
  late final List<UrunSecenegiVarligi> _servisSecenekleri;
  UrunSecenegiVarligi? _seciliServis;
  int _adet = 1;

  @override
  void initState() {
    super.initState();
    _notDenetleyici = TextEditingController();
    _servisSecenekleri = widget.urun.secenekler;
    _seciliServis = widget.urun.varsayilanSecenek;
  }

  @override
  void dispose() {
    _notDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double altBosluk = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, altBosluk + 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF231133),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.urun.ad,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.urun.aciklama,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.68),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _paraYaz(_seciliBirimFiyat * _adet),
                      style: const TextStyle(
                        color: Color(0xFFFF8CB2),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_servisSecenekleri.isNotEmpty) ...[
                  Text(
                    'Servis secimi',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _servisSecenekleri.map((
                      UrunSecenegiVarligi secenek,
                    ) {
                      final bool seciliMi = secenek.id == _seciliServis?.id;
                      final String fiyatEtiketi = secenek.fiyatFarki == 0
                          ? ''
                          : '  +${_paraYaz(secenek.fiyatFarki)}';

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _seciliServis = secenek;
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: seciliMi
                                ? const Color(0xFFFF5D8F)
                                : Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: seciliMi
                                  ? const Color(0xFFFF86AF)
                                  : Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Text(
                            '${secenek.ad}$fiyatEtiketi',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
                Row(
                  children: [
                    Text(
                      'Adet',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                    const Spacer(),
                    _adetButonu(
                      ikon: Icons.remove,
                      aktifMi: _adet > 1,
                      tikla: () {
                        if (_adet <= 1) {
                          return;
                        }
                        setState(() {
                          _adet--;
                        });
                      },
                    ),
                    Container(
                      width: 64,
                      alignment: Alignment.center,
                      child: Text(
                        '$_adet',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _adetButonu(
                      ikon: Icons.add,
                      aktifMi: true,
                      tikla: () {
                        setState(() {
                          _adet++;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _notDenetleyici,
                  minLines: 2,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Mutfak notu',
                    labelStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.70),
                    ),
                    hintText: 'Sossuz, az pismis, ekstra pecete...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.38),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide(color: Color(0xFFFF5D8F)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: widget.urun.stoktaMi
                        ? () {
                            Navigator.of(context).pop(
                              _SepeteEkleTalebi(
                                adet: _adet,
                                secenekId: _seciliServis?.id,
                                notMetni: _notMetniniHazirla(
                                  ekNot: _notDenetleyici.text,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5D8F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    child: Text(
                      widget.urun.stoktaMi
                          ? '${_paraYaz(_seciliBirimFiyat * _adet)} ile ekle'
                          : 'Stokta yok',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _adetButonu({
    required IconData ikon,
    required bool aktifMi,
    required VoidCallback tikla,
  }) {
    return InkWell(
      onTap: aktifMi ? tikla : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: aktifMi
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(ikon, color: aktifMi ? Colors.white : Colors.white38),
      ),
    );
  }

  double get _seciliBirimFiyat {
    return widget.urun.fiyat + (_seciliServis?.fiyatFarki ?? 0);
  }

  String? _notMetniniHazirla({required String ekNot}) {
    final String temizNot = ekNot.trim();
    if (temizNot.isEmpty) {
      return null;
    }
    return temizNot;
  }
}

class _SepeteEkleTalebi {
  const _SepeteEkleTalebi({required this.adet, this.secenekId, this.notMetni});

  final int adet;
  final String? secenekId;
  final String? notMetni;
}

class _TabakDeseniPainter extends CustomPainter {
  const _TabakDeseniPainter({required this.renk});

  final Color renk;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint cember = Paint()
      ..color = renk.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final Offset merkez = Offset(size.width * 0.52, size.height * 0.48);
    canvas.drawCircle(merkez, math.min(size.width, size.height) * 0.34, cember);
    canvas.drawCircle(merkez, math.min(size.width, size.height) * 0.22, cember);

    final Paint leke = Paint()
      ..color = renk.withValues(alpha: 0.10)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.24, size.height * 0.28), 12, leke);
    canvas.drawCircle(Offset(size.width * 0.72, size.height * 0.66), 18, leke);
  }

  @override
  bool shouldRepaint(covariant _TabakDeseniPainter oldDelegate) {
    return oldDelegate.renk != renk;
  }
}

class _KategoriPaneli extends StatelessWidget {
  const _KategoriPaneli({
    required this.kategoriler,
    required this.seciliKategoriId,
    required this.kategoriSec,
    required this.tumunuSec,
    this.yatay = false,
  });

  final List<KategoriVarligi> kategoriler;
  final String? seciliKategoriId;
  final ValueChanged<String> kategoriSec;
  final VoidCallback tumunuSec;
  final bool yatay;

  @override
  Widget build(BuildContext context) {
    if (yatay) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF261A31), Color(0xFF1A1222)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _TumKategoriButonu(
              seciliMi: seciliKategoriId == null,
              tikla: tumunuSec,
              yatay: true,
            ),
            ...kategoriler.map(
              (kategori) => _KategoriButonu(
                kategori: kategori,
                seciliMi: kategori.id == seciliKategoriId,
                kategoriSec: kategoriSec,
                yatay: true,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF261A31), Color(0xFF1A1222)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE85C8C).withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.tune_rounded, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MENU',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Kategori secimi',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _TumKategoriButonu(
            seciliMi: seciliKategoriId == null,
            tikla: tumunuSec,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: kategoriler.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                final KategoriVarligi kategori = kategoriler[index];
                return _KategoriButonu(
                  kategori: kategori,
                  seciliMi: kategori.id == seciliKategoriId,
                  kategoriSec: kategoriSec,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TumKategoriButonu extends StatelessWidget {
  const _TumKategoriButonu({
    required this.seciliMi,
    required this.tikla,
    this.yatay = false,
  });

  final bool seciliMi;
  final VoidCallback tikla;
  final bool yatay;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tikla,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: yatay ? null : double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: yatay ? 16 : 12,
          vertical: yatay ? 12 : 18,
        ),
        decoration: BoxDecoration(
          gradient: seciliMi
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF6E5F0), Color(0xFFFFFFFF)],
                )
              : null,
          color: seciliMi ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: seciliMi
                ? Colors.white
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          'TUM URUNLER',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: seciliMi ? const Color(0xFF412454) : Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}

class _KategoriButonu extends StatelessWidget {
  const _KategoriButonu({
    required this.kategori,
    required this.seciliMi,
    required this.kategoriSec,
    this.yatay = false,
  });

  final KategoriVarligi kategori;
  final bool seciliMi;
  final ValueChanged<String> kategoriSec;
  final bool yatay;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => kategoriSec(kategori.id),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: yatay ? null : double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: yatay ? 16 : 12,
          vertical: yatay ? 12 : 18,
        ),
        decoration: BoxDecoration(
          gradient: seciliMi
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF6E5F0), Color(0xFFFFFFFF)],
                )
              : null,
          color: seciliMi ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: seciliMi
                ? Colors.white
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          kategori.ad.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: seciliMi ? const Color(0xFF412454) : Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}

List<Color> _urunRenkleri(String kaynak) {
  final List<List<Color>> paletler = <List<Color>>[
    const [Color(0xFFA86135), Color(0xFF6B2E1B)],
    const [Color(0xFF517A2D), Color(0xFF1F4A21)],
    const [Color(0xFF9A5C22), Color(0xFFD5A24A)],
    const [Color(0xFF8A3B2B), Color(0xFF4E1718)],
    const [Color(0xFF7A5A45), Color(0xFF3F251F)],
  ];

  return paletler[kaynak.hashCode.abs() % paletler.length];
}

IconData _kategoriIkonu(String ad) {
  final String kucuk = ad.toLowerCase();
  if (kucuk.contains('burger')) {
    return Icons.lunch_dining;
  }
  if (kucuk.contains('pizza')) {
    return Icons.local_pizza;
  }
  if (kucuk.contains('limonata') || kucuk.contains('icecek')) {
    return Icons.local_drink;
  }
  if (kucuk.contains('tatli') || kucuk.contains('san sebastian')) {
    return Icons.cake;
  }
  return Icons.restaurant;
}

String _paraYaz(double tutar) {
  final String tamSayi = tutar.toStringAsFixed(2).replaceAll('.', ',');
  return '$tamSayi TL';
}
