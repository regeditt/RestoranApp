import 'package:flutter/material.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

class MasaPlaniKarti extends StatefulWidget {
  const MasaPlaniKarti({
    super.key,
    required this.siparisler,
    required this.salonBolumleri,
  });

  final List<SiparisVarligi> siparisler;
  final List<SalonBolumuVarligi> salonBolumleri;

  @override
  State<MasaPlaniKarti> createState() => _MasaPlaniKartiState();
}

class _MasaPlaniKartiState extends State<MasaPlaniKarti> {
  _MasaFiltre _seciliFiltre = _MasaFiltre.tumu;
  _HizliAksiyon _seciliAksiyon = _HizliAksiyon.barkod;
  String? _seciliBolumId;
  String? _seciliMasaAnahtari;

  @override
  Widget build(BuildContext context) {
    final List<_BolumPlaniVeri> bolumler = _bolumleriHazirla(
      siparisler: widget.siparisler,
      salonBolumleri: widget.salonBolumleri,
    );
    final _BolumPlaniVeri? seciliBolum = _seciliBolumGetir(bolumler);
    final List<_MasaPlaniVeri> filtreliMasalar = _filtreliMasalariGetir(
      bolum: seciliBolum,
    );
    final List<SiparisVarligi> aktifAdisyonlar = _aktifAdisyonlariGetir();
    final double toplamTutar = aktifAdisyonlar.fold<double>(
      0,
      (double toplam, SiparisVarligi siparis) => toplam + siparis.toplamTutar,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MasaPlaniUstCubugu(uyariSayisi: aktifAdisyonlar.length),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool dikeyYerlesim = constraints.maxWidth < 1120;
              if (dikeyYerlesim) {
                return Column(
                  children: [
                    _SolAdisyonPaneli(
                      seciliAksiyon: _seciliAksiyon,
                      aksiyonSec: _aksiyonSec,
                      aktifAdisyonlar: aktifAdisyonlar,
                      toplamTutar: toplamTutar,
                      adisyonSec: _adisyondanMasaSec,
                    ),
                    const SizedBox(height: 12),
                    _SagFiltrePaneli(
                      bolumler: bolumler,
                      seciliFiltre: _seciliFiltre,
                      seciliBolumId: seciliBolum?.id,
                      filtreSec: _filtreSec,
                      bolumSec: _bolumSec,
                    ),
                    const SizedBox(height: 12),
                    _OrtaMasaPlaniPaneli(
                      bolum: seciliBolum,
                      masalar: filtreliMasalar,
                      seciliMasaAnahtari: _seciliMasaAnahtari,
                      masaSec: _masaSec,
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 334,
                    child: _SolAdisyonPaneli(
                      seciliAksiyon: _seciliAksiyon,
                      aksiyonSec: _aksiyonSec,
                      aktifAdisyonlar: aktifAdisyonlar,
                      toplamTutar: toplamTutar,
                      adisyonSec: _adisyondanMasaSec,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OrtaMasaPlaniPaneli(
                      bolum: seciliBolum,
                      masalar: filtreliMasalar,
                      seciliMasaAnahtari: _seciliMasaAnahtari,
                      masaSec: _masaSec,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 176,
                    child: _SagFiltrePaneli(
                      bolumler: bolumler,
                      seciliFiltre: _seciliFiltre,
                      seciliBolumId: seciliBolum?.id,
                      filtreSec: _filtreSec,
                      bolumSec: _bolumSec,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<SiparisVarligi> _aktifAdisyonlariGetir() {
    final List<SiparisVarligi> salonSiparisleri = widget.siparisler.where((
      SiparisVarligi siparis,
    ) {
      if (siparis.teslimatTipi != TeslimatTipi.restorandaYe) {
        return false;
      }
      return siparis.durum != SiparisDurumu.teslimEdildi &&
          siparis.durum != SiparisDurumu.iptalEdildi;
    }).toList();
    salonSiparisleri.sort(
      (SiparisVarligi a, SiparisVarligi b) =>
          b.olusturmaTarihi.compareTo(a.olusturmaTarihi),
    );
    return salonSiparisleri;
  }

  _BolumPlaniVeri? _seciliBolumGetir(List<_BolumPlaniVeri> bolumler) {
    if (bolumler.isEmpty) {
      return null;
    }
    if (_seciliBolumId == null) {
      return bolumler.first;
    }
    return bolumler.firstWhere(
      (_BolumPlaniVeri bolum) => bolum.id == _seciliBolumId,
      orElse: () => bolumler.first,
    );
  }

  List<_MasaPlaniVeri> _filtreliMasalariGetir({
    required _BolumPlaniVeri? bolum,
  }) {
    if (bolum == null) {
      return const <_MasaPlaniVeri>[];
    }
    switch (_seciliFiltre) {
      case _MasaFiltre.tumu:
        return bolum.masalar;
      case _MasaFiltre.dolu:
        return bolum.masalar
            .where((_MasaPlaniVeri masa) => masa.doluMu)
            .toList();
      case _MasaFiltre.bos:
        return bolum.masalar
            .where((_MasaPlaniVeri masa) => !masa.doluMu)
            .toList();
    }
  }

  void _aksiyonSec(_HizliAksiyon aksiyon) {
    setState(() {
      _seciliAksiyon = aksiyon;
    });
  }

  void _filtreSec(_MasaFiltre filtre) {
    setState(() {
      _seciliFiltre = filtre;
    });
  }

  void _bolumSec(String bolumId) {
    setState(() {
      _seciliBolumId = bolumId;
    });
  }

  void _masaSec(_MasaPlaniVeri masa) {
    setState(() {
      _seciliMasaAnahtari = masa.anahtar;
    });
  }

  void _adisyondanMasaSec(SiparisVarligi siparis) {
    final String bolumAdi = (siparis.bolumAdi ?? '').trim().toLowerCase();
    final String? bulunanBolumId = widget.salonBolumleri
        .where(
          (SalonBolumuVarligi bolum) =>
              bolum.ad.trim().toLowerCase() == bolumAdi,
        )
        .map((SalonBolumuVarligi bolum) => bolum.id)
        .cast<String?>()
        .firstWhere(
          (String? id) => id != null,
          orElse: () => widget.salonBolumleri.isEmpty
              ? null
              : widget.salonBolumleri.first.id,
        );
    setState(() {
      _seciliBolumId = bulunanBolumId;
      _seciliMasaAnahtari =
          '${(bulunanBolumId ?? '').toLowerCase()}::${_masaNormallestir(siparis.masaNo ?? '')}';
    });
  }
}

class _MasaPlaniUstCubugu extends StatelessWidget {
  const _MasaPlaniUstCubugu({required this.uyariSayisi});

  final int uyariSayisi;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xFFE53D6F),
            Color(0xFF7931D6),
            Color(0xFF291046),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.verified_user_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'RESTORANAPP Pos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_active_rounded,
                color: Colors.white,
                size: 18,
              ),
              if (uyariSayisi > 0)
                Positioned(
                  right: -10,
                  top: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFCF4A),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      uyariSayisi > 99 ? '99+' : '$uyariSayisi',
                      style: const TextStyle(
                        color: Color(0xFF301336),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SolAdisyonPaneli extends StatelessWidget {
  const _SolAdisyonPaneli({
    required this.seciliAksiyon,
    required this.aksiyonSec,
    required this.aktifAdisyonlar,
    required this.toplamTutar,
    required this.adisyonSec,
  });

  final _HizliAksiyon seciliAksiyon;
  final ValueChanged<_HizliAksiyon> aksiyonSec;
  final List<SiparisVarligi> aktifAdisyonlar;
  final double toplamTutar;
  final ValueChanged<SiparisVarligi> adisyonSec;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6FB),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xFF8E2B83), Color(0xFF57206E)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                ..._HizliAksiyon.values.map((aksiyon) {
                  final bool seciliMi = seciliAksiyon == aksiyon;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    child: InkWell(
                      onTap: () => aksiyonSec(aksiyon),
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 140),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        decoration: BoxDecoration(
                          color: seciliMi
                              ? Colors.white.withValues(alpha: 0.18)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Icon(aksiyon.ikon, size: 16, color: Colors.white),
                            const SizedBox(height: 4),
                            Text(
                              aksiyon.etiket,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${aktifAdisyonlar.length} ADISYON',
                    style: const TextStyle(
                      color: Color(0xFFE53D6F),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: aktifAdisyonlar.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (BuildContext context, int index) {
                        final SiparisVarligi siparis = aktifAdisyonlar[index];
                        return InkWell(
                          onTap: () => adisyonSec(siparis),
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE53D6F),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _masaBasligi(siparis),
                                    style: const TextStyle(
                                      color: Color(0xFF2B1D3A),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Text(
                                  _saatYaz(siparis.olusturmaTarihi),
                                  style: const TextStyle(
                                    color: Color(0xFF7C6F89),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${siparis.toplamTutar.toStringAsFixed(0)} TL',
                                  style: const TextStyle(
                                    color: Color(0xFF2B1D3A),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'TOPLAM',
                          style: TextStyle(
                            color: Color(0xFF6C5F7C),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${toplamTutar.toStringAsFixed(0)} TL',
                          style: const TextStyle(
                            color: Color(0xFF3A2057),
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrtaMasaPlaniPaneli extends StatelessWidget {
  const _OrtaMasaPlaniPaneli({
    required this.bolum,
    required this.masalar,
    required this.seciliMasaAnahtari,
    required this.masaSec,
  });

  final _BolumPlaniVeri? bolum;
  final List<_MasaPlaniVeri> masalar;
  final String? seciliMasaAnahtari;
  final ValueChanged<_MasaPlaniVeri> masaSec;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6FB),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Katlar  >  ${bolum?.ad ?? '-'}',
                style: const TextStyle(
                  color: Color(0xFF6F627D),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${masalar.where((_MasaPlaniVeri masa) => masa.doluMu).length} dolu masa',
                style: const TextStyle(
                  color: Color(0xFF2B1D3A),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (masalar.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Secili filtrede masa bulunamadi.',
                style: TextStyle(
                  color: Color(0xFF7C6F89),
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final int kolonSayisi = constraints.maxWidth < 640
                      ? 2
                      : constraints.maxWidth < 930
                      ? 3
                      : 4;
                  final double kutuGenisligi =
                      (constraints.maxWidth - ((kolonSayisi - 1) * 10)) /
                      kolonSayisi;
                  return SingleChildScrollView(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: masalar.map((_MasaPlaniVeri masa) {
                        final bool seciliMi =
                            masa.anahtar == seciliMasaAnahtari;
                        return SizedBox(
                          width: kutuGenisligi,
                          child: InkWell(
                            onTap: () => masaSec(masa),
                            borderRadius: BorderRadius.circular(14),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 140),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: masa.zeminRengi,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: seciliMi
                                      ? const Color(0xFF5822C9)
                                      : masa.kenarRengi,
                                  width: seciliMi ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    masa.baslik,
                                    style: TextStyle(
                                      color: masa.yaziRengi,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    masa.durumEtiketi,
                                    style: TextStyle(
                                      color: masa.altYaziRengi,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    masa.aciklama,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: masa.altYaziRengi,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${masa.kapasite} kisilik',
                                    style: TextStyle(
                                      color: masa.altYaziRengi,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _SagFiltrePaneli extends StatelessWidget {
  const _SagFiltrePaneli({
    required this.bolumler,
    required this.seciliFiltre,
    required this.seciliBolumId,
    required this.filtreSec,
    required this.bolumSec,
  });

  final List<_BolumPlaniVeri> bolumler;
  final _MasaFiltre seciliFiltre;
  final String? seciliBolumId;
  final ValueChanged<_MasaFiltre> filtreSec;
  final ValueChanged<String> bolumSec;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFF2B1644), Color(0xFF1E1233)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MASALAR',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          _yanFiltreButonu(
            etiket: 'Tum masalar',
            seciliMi: seciliFiltre == _MasaFiltre.tumu,
            onTap: () => filtreSec(_MasaFiltre.tumu),
          ),
          const SizedBox(height: 8),
          _yanFiltreButonu(
            etiket: 'Dolu masalar',
            seciliMi: seciliFiltre == _MasaFiltre.dolu,
            onTap: () => filtreSec(_MasaFiltre.dolu),
          ),
          const SizedBox(height: 8),
          _yanFiltreButonu(
            etiket: 'Bos masalar',
            seciliMi: seciliFiltre == _MasaFiltre.bos,
            onTap: () => filtreSec(_MasaFiltre.bos),
          ),
          const SizedBox(height: 16),
          const Text(
            'BOLUMLER',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: bolumler.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (BuildContext context, int index) {
                final _BolumPlaniVeri bolum = bolumler[index];
                return _yanFiltreButonu(
                  etiket: bolum.ad.toUpperCase(),
                  seciliMi: seciliBolumId == bolum.id,
                  onTap: () => bolumSec(bolum.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _yanFiltreButonu({
    required String etiket,
    required bool seciliMi,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: seciliMi ? Colors.white : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          etiket,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: seciliMi ? const Color(0xFF25183A) : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

enum _MasaFiltre { tumu, dolu, bos }

enum _HizliAksiyon {
  barkod(Icons.qr_code_scanner_rounded, 'Barkod'),
  duzenle(Icons.tune_rounded, 'Duzenle'),
  iptal(Icons.cancel_rounded, 'Iptal'),
  paket(Icons.local_shipping_rounded, 'Paket'),
  notlar(Icons.sticky_note_2_rounded, 'Notlar'),
  tasi(Icons.swap_horiz_rounded, 'Tasi');

  const _HizliAksiyon(this.ikon, this.etiket);

  final IconData ikon;
  final String etiket;
}

class _BolumPlaniVeri {
  const _BolumPlaniVeri({
    required this.id,
    required this.ad,
    required this.masalar,
  });

  final String id;
  final String ad;
  final List<_MasaPlaniVeri> masalar;
}

class _MasaPlaniVeri {
  const _MasaPlaniVeri({
    required this.anahtar,
    required this.baslik,
    required this.durumEtiketi,
    required this.aciklama,
    required this.kapasite,
    required this.doluMu,
    required this.zeminRengi,
    required this.kenarRengi,
    required this.yaziRengi,
    required this.altYaziRengi,
  });

  final String anahtar;
  final String baslik;
  final String durumEtiketi;
  final String aciklama;
  final int kapasite;
  final bool doluMu;
  final Color zeminRengi;
  final Color kenarRengi;
  final Color yaziRengi;
  final Color altYaziRengi;
}

List<_BolumPlaniVeri> _bolumleriHazirla({
  required List<SiparisVarligi> siparisler,
  required List<SalonBolumuVarligi> salonBolumleri,
}) {
  final List<SiparisVarligi> salonSiparisleri =
      siparisler
          .where(
            (SiparisVarligi siparis) =>
                siparis.teslimatTipi == TeslimatTipi.restorandaYe,
          )
          .toList()
        ..sort(
          (SiparisVarligi a, SiparisVarligi b) =>
              b.olusturmaTarihi.compareTo(a.olusturmaTarihi),
        );

  return salonBolumleri.map((SalonBolumuVarligi bolum) {
    final List<_MasaPlaniVeri> masaKartlari = bolum.masalar.map((
      MasaTanimiVarligi masa,
    ) {
      final SiparisVarligi? eslesen = salonSiparisleri
          .cast<SiparisVarligi?>()
          .firstWhere((SiparisVarligi? siparis) {
            if (siparis == null) {
              return false;
            }
            final bool bolumEslesiyor =
                (siparis.bolumAdi ?? bolum.ad).trim().toLowerCase() ==
                bolum.ad.trim().toLowerCase();
            final bool masaEslesiyor =
                _masaNormallestir(siparis.masaNo ?? '') ==
                _masaNormallestir(masa.ad);
            return bolumEslesiyor && masaEslesiyor;
          }, orElse: () => null);
      return _masaKartiniUret(bolumId: bolum.id, masa: masa, siparis: eslesen);
    }).toList();

    return _BolumPlaniVeri(id: bolum.id, ad: bolum.ad, masalar: masaKartlari);
  }).toList();
}

_MasaPlaniVeri _masaKartiniUret({
  required String bolumId,
  required MasaTanimiVarligi masa,
  required SiparisVarligi? siparis,
}) {
  final String anahtar =
      '${bolumId.toLowerCase()}::${_masaNormallestir(masa.ad)}';
  final String baslik = 'Salon ${masa.ad}';
  if (siparis == null) {
    return _MasaPlaniVeri(
      anahtar: anahtar,
      baslik: baslik,
      durumEtiketi: 'Bos',
      aciklama: 'Yeni misafir icin hazir',
      kapasite: masa.kapasite,
      doluMu: false,
      zeminRengi: Colors.white,
      kenarRengi: const Color(0xFFE4DDEB),
      yaziRengi: const Color(0xFF3A2A4A),
      altYaziRengi: const Color(0xFF8A7C97),
    );
  }

  final String sahip =
      siparis.sahip.misafirBilgisi?.adSoyad ??
      siparis.sahip.kullanici?.adSoyad ??
      'Misafir';
  final String aciklama =
      '$sahip - ${siparis.toplamTutar.toStringAsFixed(0)} TL';

  switch (siparis.durum) {
    case SiparisDurumu.alindi:
    case SiparisDurumu.hazirlaniyor:
      return _MasaPlaniVeri(
        anahtar: anahtar,
        baslik: baslik,
        durumEtiketi: 'Sipariste',
        aciklama: aciklama,
        kapasite: masa.kapasite,
        doluMu: true,
        zeminRengi: const Color(0xFFFA3B78),
        kenarRengi: const Color(0xFFFA3B78),
        yaziRengi: Colors.white,
        altYaziRengi: const Color(0xFFFFD8E7),
      );
    case SiparisDurumu.hazir:
    case SiparisDurumu.yolda:
      return _MasaPlaniVeri(
        anahtar: anahtar,
        baslik: baslik,
        durumEtiketi: 'Serviste',
        aciklama: aciklama,
        kapasite: masa.kapasite,
        doluMu: true,
        zeminRengi: const Color(0xFF678CD9),
        kenarRengi: const Color(0xFF678CD9),
        yaziRengi: Colors.white,
        altYaziRengi: const Color(0xFFDDE8FF),
      );
    case SiparisDurumu.teslimEdildi:
      return _MasaPlaniVeri(
        anahtar: anahtar,
        baslik: baslik,
        durumEtiketi: 'Hesapta',
        aciklama: aciklama,
        kapasite: masa.kapasite,
        doluMu: true,
        zeminRengi: const Color(0xFFD7A567),
        kenarRengi: const Color(0xFFD7A567),
        yaziRengi: Colors.white,
        altYaziRengi: const Color(0xFFFFF0DB),
      );
    case SiparisDurumu.iptalEdildi:
      return _MasaPlaniVeri(
        anahtar: anahtar,
        baslik: baslik,
        durumEtiketi: 'Bos',
        aciklama: 'Tekrar kullanim icin uygun',
        kapasite: masa.kapasite,
        doluMu: false,
        zeminRengi: Colors.white,
        kenarRengi: const Color(0xFFE4DDEB),
        yaziRengi: const Color(0xFF3A2A4A),
        altYaziRengi: const Color(0xFF8A7C97),
      );
  }
}

String _masaNormallestir(String ham) {
  return ham.toLowerCase().replaceAll('masa', '').replaceAll(' ', '');
}

String _masaBasligi(SiparisVarligi siparis) {
  final String masa = (siparis.masaNo ?? '-').trim();
  return 'Salon $masa';
}

String _saatYaz(DateTime tarih) {
  final String saat = tarih.hour.toString().padLeft(2, '0');
  final String dakika = tarih.minute.toString().padLeft(2, '0');
  return '$saat:$dakika';
}
