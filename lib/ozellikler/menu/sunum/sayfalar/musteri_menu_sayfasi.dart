import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
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
    return widget.viewModel.posBaglami;
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
        final bool masaustu = EkranBoyutu.masaustu(context);
        final bool tablet = EkranBoyutu.tablet(context);
        final MusteriMenuViewModel viewModel = widget.viewModel;
        final QrMenuBaglamiVarligi? aktifBaglam = _aktifSiparisBaglami();

        return Scaffold(
          backgroundColor: const Color(0xFF12081F),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3E1A64),
                  Color(0xFF26113E),
                  Color(0xFF17091F),
                ],
              ),
            ),
            child: SafeArea(
              child: viewModel.yukleniyor && viewModel.kategoriler.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1540),
                        child: Padding(
                          padding: EdgeInsets.all(masaustu ? 18 : 12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF2B1243,
                              ).withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x40000000),
                                  blurRadius: 44,
                                  offset: Offset(0, 24),
                                ),
                              ],
                            ),
                            child: masaustu
                                ? Column(
                                    children: [
                                      MusteriMenuUstCubugu(
                                        seciliKategoriAdi:
                                            viewModel.seciliKategoriAdi,
                                        qrModu: widget.qrModu,
                                        qrBaglami: aktifBaglam,
                                      ),
                                      if (widget.qrModu &&
                                          widget.qrBaglami != null) ...[
                                        const SizedBox(height: 12),
                                        QrBaglamDurumKarti(
                                          qrBaglami: widget.qrBaglami!,
                                        ),
                                      ],
                                      if (!widget.qrModu) ...[
                                        const SizedBox(height: 12),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                          ),
                                          child: _PosSalonMasaPaneli(
                                            salonBolumleri:
                                                viewModel.salonBolumleri,
                                            seciliSalonBolumuId:
                                                viewModel.seciliSalonBolumuId,
                                            seciliMasaId: viewModel.seciliMasaId,
                                            salonBolumuSec: _salonBolumuSec,
                                            masaSec: _masaSec,
                                          ),
                                        ),
                                      ],
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              SizedBox(
                                                width: 94,
                                                child: _HizliIslemSeridi(
                                                  siparisAdedi: viewModel
                                                      .sepet
                                                      .toplamUrunAdedi,
                                                ),
                                              ),
                                              const SizedBox(width: 14),
                                              SizedBox(
                                                width: 330,
                                                child: _AdisyonPaneli(
                                                  sepet: viewModel.sepet,
                                                  islemedeMi:
                                                      viewModel.yukleniyor,
                                                  seciliBolumAdi:
                                                      aktifBaglam?.bolumAdi ??
                                                      viewModel
                                                          .seciliSalonBolumu
                                                          ?.ad,
                                                  seciliMasaAdi:
                                                      aktifBaglam?.masaNo ??
                                                      viewModel.seciliMasa?.ad,
                                                  siparisiHazirla:
                                                      _siparisiHazirla,
                                                  kalemAdediniGuncelle:
                                                      _kalemAdediniGuncelle,
                                                  kalemiSil: _kalemiSil,
                                                ),
                                              ),
                                              const SizedBox(width: 14),
                                              Expanded(
                                                child: _UrunMerkezi(
                                                  urunler: viewModel.urunler,
                                                  seciliKategoriAdi: viewModel
                                                      .seciliKategoriAdi,
                                                  masaustu: true,
                                                  urunDetayiAc: _urunDetayiniAc,
                                                  islemedeMi:
                                                      viewModel.yukleniyor,
                                                  toplamUrunAdedi: viewModel
                                                      .sepet
                                                      .toplamUrunAdedi,
                                                ),
                                              ),
                                              const SizedBox(width: 14),
                                              SizedBox(
                                                width: 150,
                                                child: _KategoriPaneli(
                                                  kategoriler:
                                                      viewModel.kategoriler,
                                                  seciliKategoriId: viewModel
                                                      .seciliKategoriId,
                                                  kategoriSec: _kategoriSec,
                                                  tumunuSec:
                                                      _tumKategorileriGoster,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : ListView(
                                    padding: const EdgeInsets.all(12),
                                    children: [
                                      MusteriMenuUstCubugu(
                                        seciliKategoriAdi:
                                            viewModel.seciliKategoriAdi,
                                        qrModu: widget.qrModu,
                                        qrBaglami: aktifBaglam,
                                      ),
                                      if (widget.qrModu &&
                                          widget.qrBaglami != null) ...[
                                        const SizedBox(height: 12),
                                        QrBaglamDurumKarti(
                                          qrBaglami: widget.qrBaglami!,
                                        ),
                                      ],
                                      if (!widget.qrModu) ...[
                                        const SizedBox(height: 12),
                                        _PosSalonMasaPaneli(
                                          salonBolumleri:
                                              viewModel.salonBolumleri,
                                          seciliSalonBolumuId:
                                              viewModel.seciliSalonBolumuId,
                                          seciliMasaId: viewModel.seciliMasaId,
                                          salonBolumuSec: _salonBolumuSec,
                                          masaSec: _masaSec,
                                        ),
                                      ],
                                      const SizedBox(height: 12),
                                      _HizliIslemSeridi(
                                        siparisAdedi:
                                            viewModel.sepet.toplamUrunAdedi,
                                        yatay: true,
                                      ),
                                      const SizedBox(height: 12),
                                      _KategoriPaneli(
                                        kategoriler: viewModel.kategoriler,
                                        seciliKategoriId:
                                            viewModel.seciliKategoriId,
                                        kategoriSec: _kategoriSec,
                                        tumunuSec: _tumKategorileriGoster,
                                        yatay: true,
                                      ),
                                      const SizedBox(height: 12),
                                      _UrunMerkezi(
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
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        height: 420,
                                        child: _AdisyonPaneli(
                                          sepet: viewModel.sepet,
                                          islemedeMi: viewModel.yukleniyor,
                                          seciliBolumAdi:
                                              aktifBaglam?.bolumAdi ??
                                              viewModel.seciliSalonBolumu?.ad,
                                          seciliMasaAdi:
                                              aktifBaglam?.masaNo ??
                                              viewModel.seciliMasa?.ad,
                                          siparisiHazirla: _siparisiHazirla,
                                          kalemAdediniGuncelle:
                                              _kalemAdediniGuncelle,
                                          kalemiSil: _kalemiSil,
                                        ),
                                      ),
                                    ],
                                  ),
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
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
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
          const SizedBox(height: 10),
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
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
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
          color: seciliMi
              ? const Color(0xFFE94274)
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Text(
          etiket,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
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
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: seciliMi ? Colors.white : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
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
  const _HizliIslemSeridi({required this.siparisAdedi, this.yatay = false});

  final int siparisAdedi;
  final bool yatay;

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

    final Widget icerik = yatay
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
                      ),
                    ),
                  )
                  .toList(),
            ),
          );

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
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
  });

  final _HizliIslem islem;
  final bool seciliMi;
  final bool yatay;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: yatay ? 96 : double.infinity,
      height: yatay ? 92 : 84,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: seciliMi ? const Color(0xFFE94274) : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            islem.ikon,
            color: seciliMi ? Colors.white : const Color(0xFF8C5BA8),
            size: 22,
          ),
          const SizedBox(height: 6),
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
                  fontSize: 13,
                ),
              ),
            ),
          ),
          if (islem.rozet != null) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                  fontSize: 11,
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
        color: const Color(0xFFF8F5FB),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    seciliBolumAdi ?? 'Salon secilmedi',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF4A295F),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE2EB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    seciliMasaAdi != null ? 'Masa $seciliMasaAdi' : 'Masa sec',
                    style: const TextStyle(
                      color: Color(0xFFE04374),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF7A678A),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _paraYaz(sepet.araToplam),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF4A295F),
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
              color: Color(0xFF4A295F),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAE2F1)),
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
              color: Color(0xFFE04374),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Adisyon henuz bos',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: const Color(0xFF4A295F)),
          ),
          const SizedBox(height: 8),
          Text(
            'Sag taraftaki menuden urun secerek siparis akisini baslatabilirsin.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF7A678A)),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDE4F2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${kalem.adet}x',
                style: const TextStyle(
                  color: Color(0xFFE04374),
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF4A295F),
                      ),
                    ),
                    if ((kalem.secenekAdi ?? '').isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        kalem.secenekAdi!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFE04374),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    if ((kalem.notMetni ?? '').isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        kalem.notMetni!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF8D7A9D),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                _paraYaz(kalem.araToplam),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF4A295F),
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
                    color: Color(0xFF4A295F),
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
          color: etkinMi ? const Color(0xFFF7D9E4) : const Color(0xFFF0EAF5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          ikon,
          color: etkinMi ? const Color(0xFFE04374) : const Color(0xFFAD9DBA),
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
        color: const Color(0xFFF4F0F8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menuler  /  $seciliKategoriAdi',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF8B789A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$seciliKategoriAdi Secimleri',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF412454),
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
                    color: Colors.white,
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
                          color: Color(0xFF412454),
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
      color: urun.stoktaMi ? Colors.white : const Color(0xFFF2ECF5),
      borderRadius: BorderRadius.circular(18),
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
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          _kategoriIkonu(urun.ad),
                          color: Colors.white.withValues(alpha: 0.88),
                          size: 28,
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
                  color: urun.stoktaMi
                      ? const Color(0xFF412454)
                      : const Color(0xFF8D7C9A),
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
                        ? const Color(0xFF887694)
                        : const Color(0xFFA89AB2),
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
                  if (urun.oneCikanMi)
                    const Icon(
                      Icons.local_fire_department,
                      color: Color(0xFFFF7A59),
                      size: 18,
                    ),
                  const SizedBox(width: 6),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: urun.stoktaMi
                          ? const Color(0xFFFFE2EB)
                          : const Color(0xFFE2D9E8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color: urun.stoktaMi
                          ? const Color(0xFFE04374)
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
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
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
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'MENU',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              letterSpacing: 1.2,
            ),
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
          color: seciliMi ? Colors.white : Colors.transparent,
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
          color: seciliMi ? Colors.white : Colors.transparent,
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
