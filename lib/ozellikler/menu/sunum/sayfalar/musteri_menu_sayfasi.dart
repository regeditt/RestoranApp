import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_baglami_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_secenegi_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_ozeti_girdisi_varligi.dart';

class MusteriMenuSayfasi extends StatefulWidget {
  const MusteriMenuSayfasi({super.key, this.qrModu = false, this.qrBaglami});

  final bool qrModu;
  final QrMenuBaglamiVarligi? qrBaglami;

  @override
  State<MusteriMenuSayfasi> createState() => _MusteriMenuSayfasiState();
}

class _MusteriMenuSayfasiState extends State<MusteriMenuSayfasi> {
  final ServisKaydi _servisKaydi = ServisKaydi.ortak;

  bool _yukleniyor = true;
  List<KategoriVarligi> _kategoriler = const <KategoriVarligi>[];
  List<UrunVarligi> _urunler = const <UrunVarligi>[];
  SepetVarligi _sepet = const SepetVarligi(id: 'sep_001', kalemler: []);
  String? _seciliKategoriId;
  int _kategoriIstekSayaci = 0;

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  Future<void> _verileriYukle() async {
    try {
      final List<KategoriVarligi> kategoriler = await _servisKaydi
          .kategorileriGetirUseCase();
      final SepetVarligi sepet = await _servisKaydi.sepetiGetirUseCase();

      String? seciliKategoriId = _seciliKategoriId;
      if (kategoriler.isNotEmpty &&
          (seciliKategoriId == null ||
              kategoriler.every(
                (kategori) => kategori.id != seciliKategoriId,
              ))) {
        seciliKategoriId = kategoriler.first.id;
      }

      final List<UrunVarligi> urunler = seciliKategoriId == null
          ? await _servisKaydi.urunleriGetirUseCase()
          : await _servisKaydi.kategoriyeGoreUrunleriGetirUseCase(
              seciliKategoriId,
            );

      if (!mounted) {
        return;
      }

      setState(() {
        _kategoriler = kategoriler;
        _sepet = sepet;
        _seciliKategoriId = seciliKategoriId;
        _urunler = urunler;
        _yukleniyor = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _yukleniyor = false;
      });
      _hataBildir('Veriler yuklenemedi');
    }
  }

  Future<void> _kategoriSec(String kategoriId) async {
    final int istekNo = ++_kategoriIstekSayaci;

    setState(() {
      _seciliKategoriId = kategoriId;
      _yukleniyor = true;
    });

    try {
      final List<UrunVarligi> urunler = await _servisKaydi
          .kategoriyeGoreUrunleriGetirUseCase(kategoriId);

      if (!mounted || istekNo != _kategoriIstekSayaci) {
        return;
      }

      setState(() {
        _urunler = urunler;
        _yukleniyor = false;
      });
    } catch (_) {
      if (!mounted || istekNo != _kategoriIstekSayaci) {
        return;
      }

      setState(() {
        _yukleniyor = false;
      });
      _hataBildir('Kategori urunleri yuklenemedi');
    }
  }

  Future<void> _sepeteEkle(
    UrunVarligi urun, {
    int adet = 1,
    String? secenekId,
    String? notMetni,
  }) async {
    setState(() {
      _yukleniyor = true;
    });

    try {
      final SepetVarligi sepet = await _servisKaydi.sepeteUrunEkleUseCase(
        urunId: urun.id,
        adet: adet,
        secenekId: secenekId,
        notMetni: notMetni,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _sepet = sepet;
        _yukleniyor = false;
      });

      _bilgiBildir('$adet x ${urun.ad} sepete eklendi');
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _yukleniyor = false;
      });
      _hataBildir('Urun sepete eklenemedi');
    }
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
    if (_sepet.kalemler.isEmpty) {
      return;
    }

    final bool? siparisTamamlandi =
        await Navigator.of(context).pushNamed(
              RotaYapisi.siparisOzeti,
              arguments: SiparisOzetiGirdisiVarligi(
                sepet: _sepet,
                qrBaglami: widget.qrBaglami,
              ),
            )
            as bool?;

    if (siparisTamamlandi != true || !mounted) {
      return;
    }

    try {
      final SepetVarligi bosSepet = await _servisKaydi.sepetiGetirUseCase();

      if (!mounted) {
        return;
      }

      setState(() {
        _sepet = bosSepet;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      _hataBildir('Sepet durumu yenilenemedi');
    }
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
  Widget build(BuildContext context) {
    final bool masaustu = EkranBoyutu.masaustu(context);
    final bool tablet = EkranBoyutu.tablet(context);

    return Scaffold(
      backgroundColor: const Color(0xFF12081F),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3E1A64), Color(0xFF26113E), Color(0xFF17091F)],
          ),
        ),
        child: SafeArea(
          child: _yukleniyor && _kategoriler.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1540),
                    child: Padding(
                      padding: EdgeInsets.all(masaustu ? 18 : 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B1243).withValues(alpha: 0.7),
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
                                  _UstCubuk(
                                    seciliKategoriAdi: _seciliKategoriAdi,
                                    qrModu: widget.qrModu,
                                    qrBaglami: widget.qrBaglami,
                                  ),
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
                                              siparisAdedi:
                                                  _sepet.toplamUrunAdedi,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          SizedBox(
                                            width: 330,
                                            child: _AdisyonPaneli(
                                              sepet: _sepet,
                                              islemedeMi: _yukleniyor,
                                              siparisiHazirla: _siparisiHazirla,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: _UrunMerkezi(
                                              urunler: _urunler,
                                              seciliKategoriAdi:
                                                  _seciliKategoriAdi,
                                              masaustu: true,
                                              urunDetayiAc: _urunDetayiniAc,
                                              islemedeMi: _yukleniyor,
                                              toplamUrunAdedi:
                                                  _sepet.toplamUrunAdedi,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          SizedBox(
                                            width: 150,
                                            child: _KategoriPaneli(
                                              kategoriler: _kategoriler,
                                              seciliKategoriId:
                                                  _seciliKategoriId,
                                              kategoriSec: _kategoriSec,
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
                                  _UstCubuk(
                                    seciliKategoriAdi: _seciliKategoriAdi,
                                    qrModu: widget.qrModu,
                                    qrBaglami: widget.qrBaglami,
                                  ),
                                  const SizedBox(height: 12),
                                  _HizliIslemSeridi(
                                    siparisAdedi: _sepet.toplamUrunAdedi,
                                    yatay: true,
                                  ),
                                  const SizedBox(height: 12),
                                  _KategoriPaneli(
                                    kategoriler: _kategoriler,
                                    seciliKategoriId: _seciliKategoriId,
                                    kategoriSec: _kategoriSec,
                                    yatay: true,
                                  ),
                                  const SizedBox(height: 12),
                                  _UrunMerkezi(
                                    urunler: _urunler,
                                    seciliKategoriAdi: _seciliKategoriAdi,
                                    masaustu: false,
                                    urunDetayiAc: _urunDetayiniAc,
                                    islemedeMi: _yukleniyor,
                                    toplamUrunAdedi: _sepet.toplamUrunAdedi,
                                    tablet: tablet,
                                    mobilYukseklik: tablet ? 760 : 620,
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height: 420,
                                    child: _AdisyonPaneli(
                                      sepet: _sepet,
                                      islemedeMi: _yukleniyor,
                                      siparisiHazirla: _siparisiHazirla,
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
  }

  String get _seciliKategoriAdi {
    for (final KategoriVarligi kategori in _kategoriler) {
      if (kategori.id == _seciliKategoriId) {
        return kategori.ad;
      }
    }
    return _kategoriler.isNotEmpty ? _kategoriler.first.ad : 'Menu';
  }
}

class _UstCubuk extends StatelessWidget {
  const _UstCubuk({
    required this.seciliKategoriAdi,
    required this.qrModu,
    this.qrBaglami,
  });

  final String seciliKategoriAdi;
  final bool qrModu;
  final QrMenuBaglamiVarligi? qrBaglami;

  @override
  Widget build(BuildContext context) {
    final bool mobil = EkranBoyutu.mobil(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE53D6F), Color(0xFF6C2FD2), Color(0xFF32185A)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: mobil
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _solKisim(context, mobil),
                if (!qrModu) ...[
                  const SizedBox(height: 10),
                  _modulGecisleri(context, mobil: true),
                ],
                if (qrModu && qrBaglami?.rozetler.isNotEmpty == true) ...[
                  const SizedBox(height: 10),
                  _QrRozetleri(rozetler: qrBaglami!.rozetler),
                ],
                const SizedBox(height: 12),
                _aramaKutusu(true),
              ],
            )
          : Row(
              children: [
                Expanded(child: _solKisim(context, mobil)),
                const SizedBox(width: 12),
                _DurumRozeti(
                  ikon: qrModu ? Icons.qr_code_2 : Icons.wifi,
                  etiket: qrModu ? 'QR menu' : 'Internet',
                ),
                const SizedBox(width: 10),
                const _DurumRozeti(ikon: Icons.dns, etiket: 'Server'),
                if (qrModu && qrBaglami?.rozetler.isNotEmpty == true) ...[
                  const SizedBox(width: 10),
                  _QrRozetleri(rozetler: qrBaglami!.rozetler),
                ],
                if (!qrModu) ...[
                  const SizedBox(width: 10),
                  _modulGecisleri(context),
                ],
                const SizedBox(width: 12),
                _aramaKutusu(false),
              ],
            ),
    );
  }

  Widget _solKisim(BuildContext context, bool mobil) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                ),
                splashRadius: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${UygulamaSabitleri.restoranAdi} ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  TextSpan(
                    text: UygulamaSabitleri.markaEtiketi,
                    style: TextStyle(
                      color: Color(0xFFFFC8D9),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!mobil)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  qrModu ? Icons.qr_code_2_rounded : Icons.receipt_long,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  qrModu ? 'QR MENU' : 'SIPARIS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        if (!mobil)
          Text(
            '${qrModu ? 'QR Menu' : UygulamaSabitleri.menuKirintiKoku}  /  $seciliKategoriAdi',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.84),
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _aramaKutusu(bool mobil) {
    return Container(
      width: mobil ? double.infinity : 180,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 18, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            'Ara',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.74),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _modulGecisleri(BuildContext context, {bool mobil = false}) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton.tonalIcon(
          onPressed: () {
            Navigator.of(
              context,
            ).pushReplacementNamed(RotaYapisi.yonetimPaneli);
          },
          style: FilledButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.white.withValues(alpha: 0.14),
            padding: EdgeInsets.symmetric(
              horizontal: mobil ? 12 : 14,
              vertical: 12,
            ),
          ),
          icon: const Icon(Icons.dashboard_customize_rounded, size: 18),
          label: const Text('Yonetim paneli'),
        ),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(RotaYapisi.anaSayfa);
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
            padding: EdgeInsets.symmetric(
              horizontal: mobil ? 12 : 14,
              vertical: 12,
            ),
          ),
          icon: const Icon(Icons.switch_account_rounded, size: 18),
          label: const Text('Rol secimine don'),
        ),
      ],
    );
  }
}

class _DurumRozeti extends StatelessWidget {
  const _DurumRozeti({required this.ikon, required this.etiket});

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
          Icon(ikon, size: 14, color: const Color(0xFF6BF3A7)),
          const SizedBox(width: 6),
          Text(
            etiket,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _QrRozetleri extends StatelessWidget {
  const _QrRozetleri({required this.rozetler});

  final List<String> rozetler;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: rozetler
          .map(
            (rozet) =>
                _DurumRozeti(ikon: Icons.local_offer_outlined, etiket: rozet),
          )
          .toList(),
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
        : Column(
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
    required this.siparisiHazirla,
  });

  final SepetVarligi sepet;
  final bool islemedeMi;
  final VoidCallback siparisiHazirla;

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
                    'Salon 8',
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
                  child: const Text(
                    'Oguzhan Aydin',
                    style: TextStyle(
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
                  : ListView.separated(
                      itemCount: sepet.kalemler.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (BuildContext context, int index) {
                        final SepetKalemiVarligi kalem = sepet.kalemler[index];
                        return _AdisyonSatiri(kalem: kalem);
                      },
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
  const _AdisyonSatiri({required this.kalem});

  final SepetKalemiVarligi kalem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDE4F2)),
      ),
      child: Row(
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

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: islemedeMi ? null : () => urunDetayiAc(urun),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 96,
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
              const SizedBox(height: 10),
              Text(
                urun.ad,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF412454),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  urun.aciklama,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF887694),
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 8),
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
                              color: const Color(0xFFE04374),
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
                      color: const Color(0xFFFFE2EB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 18,
                      color: Color(0xFFE04374),
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
                    onPressed: () {
                      Navigator.of(context).pop(
                        _SepeteEkleTalebi(
                          adet: _adet,
                          secenekId: _seciliServis?.id,
                          notMetni: _notMetniniHazirla(
                            ekNot: _notDenetleyici.text,
                          ),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5D8F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    child: Text(
                      '${_paraYaz(_seciliBirimFiyat * _adet)} ile ekle',
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
    this.yatay = false,
  });

  final List<KategoriVarligi> kategoriler;
  final String? seciliKategoriId;
  final ValueChanged<String> kategoriSec;
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
          children: kategoriler
              .map(
                (kategori) => _KategoriButonu(
                  kategori: kategori,
                  seciliMi: kategori.id == seciliKategoriId,
                  kategoriSec: kategoriSec,
                  yatay: true,
                ),
              )
              .toList(),
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
