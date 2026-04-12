import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/kurye_konum_takip_servisi.dart';

class KuryeTakipHaritasiKarti extends StatelessWidget {
  const KuryeTakipHaritasiKarti({
    super.key,
    required this.siparisler,
    this.simdi,
  });

  final List<SiparisVarligi> siparisler;
  final DateTime? simdi;

  static final RegExp _koordinatDeseni = RegExp(
    r'(-?\d+(?:\.\d+)?)\s*[,;]\s*(-?\d+(?:\.\d+)?)',
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: kuryeKonumTakipServisi,
      builder: (BuildContext context, Widget? child) {
        final DateTime anlikZaman = simdi ?? DateTime.now();
        final LatLng restoranKonumu = const LatLng(
          UygulamaSabitleri.restoranKonumEnlem,
          UygulamaSabitleri.restoranKonumBoylam,
        );

        final List<_KuryeHatVerisi> tumHatlar = siparisler
            .where(
              (SiparisVarligi siparis) =>
                  siparis.teslimatTipi == TeslimatTipi.paketServis,
            )
            .map(
              (SiparisVarligi siparis) => _kuryeHatVerisiUret(
                siparis: siparis,
                restoranKonumu: restoranKonumu,
                anlikZaman: anlikZaman,
                canliKonum: kuryeKonumTakipServisi.siparisKonumuGetir(
                  siparis.id,
                ),
              ),
            )
            .toList();

        final List<_KuryeHatVerisi> aktifHatlar = tumHatlar
            .where((veri) => veri.aktifMi)
            .toList();

        final int yoldaSayisi = aktifHatlar
            .where((veri) => veri.yoldaMi)
            .length;
        final int bekleyenSayisi = aktifHatlar.length - yoldaSayisi < 0
            ? 0
            : aktifHatlar.length - yoldaSayisi;
        final int canliTakipSayisi = aktifHatlar
            .where((veri) => veri.canliKonumVarMi)
            .length;

        final LatLng haritaMerkezi = _haritaMerkeziHesapla(
          restoranKonumu: restoranKonumu,
          hatlar: aktifHatlar,
        );
        final double baslangicYakinlik = _baslangicYakinlikHesapla(
          restoranKonumu: restoranKonumu,
          hatlar: aktifHatlar,
        );

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFF172A3D),
                Color(0xFF274D70),
                Color(0xFF366889),
              ],
            ),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Canli kurye haritasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                aktifHatlar.isEmpty
                    ? 'Su anda haritada izlenecek aktif paket siparisi yok.'
                    : '${aktifHatlar.length} aktif paket siparisi haritada izleniyor.',
                style: const TextStyle(color: Color(0xFFD5EEFF), height: 1.4),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  _DurumRozeti(
                    ikon: Icons.local_shipping_rounded,
                    etiket: 'Aktif paket',
                    deger: '${aktifHatlar.length}',
                  ),
                  _DurumRozeti(
                    ikon: Icons.two_wheeler_rounded,
                    etiket: 'Yolda',
                    deger: '$yoldaSayisi',
                  ),
                  _DurumRozeti(
                    ikon: Icons.schedule_rounded,
                    etiket: 'Kurye bekleyen',
                    deger: '$bekleyenSayisi',
                  ),
                  _DurumRozeti(
                    ikon: Icons.gps_fixed_rounded,
                    etiket: 'Canli takip',
                    deger: '$canliTakipSayisi',
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  height: 290,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: haritaMerkezi,
                      initialZoom: baslangicYakinlik,
                    ),
                    children: <Widget>[
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.restoranapp.panel',
                      ),
                      PolylineLayer(
                        polylines: aktifHatlar.map((veri) {
                          return Polyline(
                            points: <LatLng>[restoranKonumu, veri.hedefKonumu],
                            strokeWidth: veri.yoldaMi ? 4 : 2.5,
                            color: veri.yoldaMi
                                ? const Color(0xFF57B7FF)
                                : const Color(
                                    0xFF8CD4FF,
                                  ).withValues(alpha: 0.65),
                          );
                        }).toList(),
                      ),
                      MarkerLayer(
                        markers: <Marker>[
                          Marker(
                            point: restoranKonumu,
                            width: 46,
                            height: 46,
                            child: const _KonumPini(
                              ikon: Icons.storefront_rounded,
                              renk: Color(0xFF1E7CFF),
                              etiket: 'Restoran',
                            ),
                          ),
                          ...aktifHatlar.map((veri) {
                            return Marker(
                              point: veri.hedefKonumu,
                              width: 34,
                              height: 34,
                              child: const _NoktaPini(
                                ikon: Icons.home_rounded,
                                renk: Color(0xFFFF8F3D),
                              ),
                            );
                          }),
                          ...aktifHatlar.map((veri) {
                            return Marker(
                              point: veri.kuryeKonumu,
                              width: 48,
                              height: 48,
                              child: _KonumPini(
                                ikon: veri.yoldaMi
                                    ? Icons.two_wheeler_rounded
                                    : Icons.delivery_dining_rounded,
                                renk: veri.yoldaMi
                                    ? const Color(0xFF00BFA6)
                                    : const Color(0xFFFFCA4D),
                                etiket: veri.siparis.siparisNo,
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Canli takipte cihaz GPS konumu kullanilir. Adreste koordinat yoksa hedef nokta tahmini uretilir.',
                style: const TextStyle(
                  color: Color(0xFFC0E6FF),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              if (aktifHatlar.isNotEmpty) ...<Widget>[
                const SizedBox(height: 10),
                ...aktifHatlar.take(3).map((veri) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _KuryeSatiri(veri: veri),
                  );
                }),
              ],
            ],
          ),
        );
      },
    );
  }

  _KuryeHatVerisi _kuryeHatVerisiUret({
    required SiparisVarligi siparis,
    required LatLng restoranKonumu,
    required DateTime anlikZaman,
    required KuryeCanliKonumVarligi? canliKonum,
  }) {
    final LatLng hedefKonumu = _hedefKonumuBul(
      siparis: siparis,
      restoranKonumu: restoranKonumu,
    );
    final LatLng kuryeKonumu = _kuryeKonumuBul(
      siparis: siparis,
      restoranKonumu: restoranKonumu,
      hedefKonumu: hedefKonumu,
      anlikZaman: anlikZaman,
      canliKonum: canliKonum,
    );
    final bool aktifMi =
        siparis.durum != SiparisDurumu.teslimEdildi &&
        siparis.durum != SiparisDurumu.iptalEdildi;
    return _KuryeHatVerisi(
      siparis: siparis,
      aktifMi: aktifMi,
      yoldaMi: siparis.durum == SiparisDurumu.yolda,
      kuryeKonumu: kuryeKonumu,
      hedefKonumu: hedefKonumu,
      canliKonumVarMi: canliKonum != null,
    );
  }

  LatLng _hedefKonumuBul({
    required SiparisVarligi siparis,
    required LatLng restoranKonumu,
  }) {
    final String adres = siparis.adresMetni ?? '';
    final Match? eslesme = _koordinatDeseni.firstMatch(adres);
    if (eslesme != null) {
      final double? enlem = double.tryParse(eslesme.group(1) ?? '');
      final double? boylam = double.tryParse(eslesme.group(2) ?? '');
      if (enlem != null &&
          boylam != null &&
          enlem >= -90 &&
          enlem <= 90 &&
          boylam >= -180 &&
          boylam <= 180) {
        return LatLng(enlem, boylam);
      }
    }
    return _tahminiHedefKonumUret(
      tohum: siparis.id,
      restoranKonumu: restoranKonumu,
    );
  }

  LatLng _kuryeKonumuBul({
    required SiparisVarligi siparis,
    required LatLng restoranKonumu,
    required LatLng hedefKonumu,
    required DateTime anlikZaman,
    required KuryeCanliKonumVarligi? canliKonum,
  }) {
    if (canliKonum != null) {
      return LatLng(canliKonum.enlem, canliKonum.boylam);
    }

    switch (siparis.durum) {
      case SiparisDurumu.alindi:
      case SiparisDurumu.hazirlaniyor:
      case SiparisDurumu.hazir:
        return restoranKonumu;
      case SiparisDurumu.yolda:
        final int gecenDakika = anlikZaman
            .difference(siparis.olusturmaTarihi)
            .inMinutes;
        final double ilerleme = (gecenDakika / 35).clamp(0.08, 0.95).toDouble();
        return _ikiNoktaArasiAraKonum(
          baslangic: restoranKonumu,
          bitis: hedefKonumu,
          oran: ilerleme,
        );
      case SiparisDurumu.teslimEdildi:
      case SiparisDurumu.iptalEdildi:
        return hedefKonumu;
    }
  }

  LatLng _tahminiHedefKonumUret({
    required String tohum,
    required LatLng restoranKonumu,
  }) {
    int hash = 0;
    for (final int rune in tohum.runes) {
      hash = (hash * 37) + rune;
    }
    final int normalize = hash.abs();
    final double aciRadyan = ((normalize % 360) * math.pi) / 180;
    final double uzaklikKm = 0.9 + ((normalize % 320) / 100);

    final double enlemFarki = (uzaklikKm / 111) * math.cos(aciRadyan);
    final double enlemRadyan = (restoranKonumu.latitude * math.pi) / 180;
    final double boylamOlcegi = math.max(0.20, math.cos(enlemRadyan).abs());
    final double boylamFarki =
        (uzaklikKm / (111 * boylamOlcegi)) * math.sin(aciRadyan);

    return LatLng(
      restoranKonumu.latitude + enlemFarki,
      restoranKonumu.longitude + boylamFarki,
    );
  }

  LatLng _ikiNoktaArasiAraKonum({
    required LatLng baslangic,
    required LatLng bitis,
    required double oran,
  }) {
    final double sinirliOran = oran.clamp(0.0, 1.0);
    return LatLng(
      baslangic.latitude +
          ((bitis.latitude - baslangic.latitude) * sinirliOran),
      baslangic.longitude +
          ((bitis.longitude - baslangic.longitude) * sinirliOran),
    );
  }

  LatLng _haritaMerkeziHesapla({
    required LatLng restoranKonumu,
    required List<_KuryeHatVerisi> hatlar,
  }) {
    if (hatlar.isEmpty) {
      return restoranKonumu;
    }

    double toplamEnlem = restoranKonumu.latitude;
    double toplamBoylam = restoranKonumu.longitude;
    int noktaSayisi = 1;
    for (final _KuryeHatVerisi veri in hatlar) {
      toplamEnlem += veri.kuryeKonumu.latitude + veri.hedefKonumu.latitude;
      toplamBoylam += veri.kuryeKonumu.longitude + veri.hedefKonumu.longitude;
      noktaSayisi += 2;
    }
    return LatLng(toplamEnlem / noktaSayisi, toplamBoylam / noktaSayisi);
  }

  double _baslangicYakinlikHesapla({
    required LatLng restoranKonumu,
    required List<_KuryeHatVerisi> hatlar,
  }) {
    if (hatlar.isEmpty) {
      return 13.0;
    }

    double enUzakKm = 0;
    for (final _KuryeHatVerisi veri in hatlar) {
      final double hedefMesafesi = _ikiNoktaMesafesiKm(
        restoranKonumu,
        veri.hedefKonumu,
      );
      final double kuryeMesafesi = _ikiNoktaMesafesiKm(
        restoranKonumu,
        veri.kuryeKonumu,
      );
      enUzakKm = math.max(enUzakKm, math.max(hedefMesafesi, kuryeMesafesi));
    }

    if (enUzakKm > 10) {
      return 10.3;
    }
    if (enUzakKm > 6) {
      return 11.0;
    }
    if (enUzakKm > 3) {
      return 11.8;
    }
    return 12.7;
  }

  double _ikiNoktaMesafesiKm(LatLng ilk, LatLng ikinci) {
    const double dunyaYaricapiKm = 6371;
    final double dEnlem = (ikinci.latitude - ilk.latitude) * math.pi / 180;
    final double dBoylam = (ikinci.longitude - ilk.longitude) * math.pi / 180;
    final double enlem1 = ilk.latitude * math.pi / 180;
    final double enlem2 = ikinci.latitude * math.pi / 180;

    final double a =
        (math.sin(dEnlem / 2) * math.sin(dEnlem / 2)) +
        (math.sin(dBoylam / 2) * math.sin(dBoylam / 2)) *
            math.cos(enlem1) *
            math.cos(enlem2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return dunyaYaricapiKm * c;
  }
}

class _KuryeSatiri extends StatelessWidget {
  const _KuryeSatiri({required this.veri});

  final _KuryeHatVerisi veri;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            veri.yoldaMi ? Icons.two_wheeler_rounded : Icons.schedule_rounded,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${veri.siparis.siparisNo} - ${veri.siparis.kuryeAdi ?? 'Kurye atanmadi'}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            veri.yoldaMi ? 'Yolda' : 'Hazir',
            style: TextStyle(
              color: veri.yoldaMi
                  ? const Color(0xFF7EE6D7)
                  : const Color(0xFFFFE59A),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DurumRozeti extends StatelessWidget {
  const _DurumRozeti({
    required this.ikon,
    required this.etiket,
    required this.deger,
  });

  final IconData ikon;
  final String etiket;
  final String deger;

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
        children: <Widget>[
          Icon(ikon, size: 15, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            '$etiket: $deger',
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

class _KonumPini extends StatelessWidget {
  const _KonumPini({
    required this.ikon,
    required this.renk,
    required this.etiket,
  });

  final IconData ikon;
  final Color renk;
  final String etiket;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: etiket,
      child: Container(
        decoration: BoxDecoration(
          color: renk,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(ikon, color: Colors.white, size: 22),
      ),
    );
  }
}

class _NoktaPini extends StatelessWidget {
  const _NoktaPini({required this.ikon, required this.renk});

  final IconData ikon;
  final Color renk;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: renk,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white, width: 1.8),
      ),
      child: Icon(ikon, color: Colors.white, size: 16),
    );
  }
}

class _KuryeHatVerisi {
  const _KuryeHatVerisi({
    required this.siparis,
    required this.aktifMi,
    required this.yoldaMi,
    required this.kuryeKonumu,
    required this.hedefKonumu,
    required this.canliKonumVarMi,
  });

  final SiparisVarligi siparis;
  final bool aktifMi;
  final bool yoldaMi;
  final LatLng kuryeKonumu;
  final LatLng hedefKonumu;
  final bool canliKonumVarMi;
}
