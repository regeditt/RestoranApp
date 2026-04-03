import 'package:flutter/material.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

class MasaPlaniKarti extends StatelessWidget {
  const MasaPlaniKarti({
    super.key,
    required this.siparisler,
    required this.salonBolumleri,
  });

  final List<SiparisVarligi> siparisler;
  final List<SalonBolumuVarligi> salonBolumleri;

  @override
  Widget build(BuildContext context) {
    final List<_BolumPlaniVeri> bolumler = _BolumPlaniVeri.uret(
      siparisler,
      salonBolumleri,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masa plani',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: const Color(0xFF25192E)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Salon yerlesimini bolum bazli izle, dolu masalari aninda fark et.',
            style: TextStyle(color: Color(0xFF7A6D86)),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _MasaDurumLejandi(
                etiket: 'Bos',
                renk: Color(0xFF5B8CFF),
                ikon: Icons.event_seat_outlined,
              ),
              _MasaDurumLejandi(
                etiket: 'Siparis bekliyor',
                renk: Color(0xFFFF8B6B),
                ikon: Icons.restaurant_menu_rounded,
              ),
              _MasaDurumLejandi(
                etiket: 'Serviste',
                renk: Color(0xFFC58CFF),
                ikon: Icons.room_service_rounded,
              ),
              _MasaDurumLejandi(
                etiket: 'Temizleniyor',
                renk: Color(0xFF9AA6B2),
                ikon: Icons.cleaning_services_rounded,
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...bolumler.map(
            (_BolumPlaniVeri bolum) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _BolumPlaniKapsulu(bolum: bolum),
            ),
          ),
        ],
      ),
    );
  }
}

class _MasaDurumLejandi extends StatelessWidget {
  const _MasaDurumLejandi({
    required this.etiket,
    required this.renk,
    required this.ikon,
  });

  final String etiket;
  final Color renk;
  final IconData ikon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 16, color: renk),
          const SizedBox(width: 8),
          Text(
            etiket,
            style: TextStyle(color: renk, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _BolumPlaniKapsulu extends StatelessWidget {
  const _BolumPlaniKapsulu({required this.bolum});

  final _BolumPlaniVeri bolum;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bolum.zeminRengi,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: bolum.kenarRengi),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(bolum.ikon, color: bolum.vurguRengi),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bolum.baslik,
                      style: const TextStyle(
                        color: Color(0xFF25192E),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bolum.aciklama,
                      style: const TextStyle(
                        color: Color(0xFF6D6079),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${bolum.doluMasaSayisi}/${bolum.masalar.length} dolu',
                  style: TextStyle(
                    color: bolum.vurguRengi,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double kartGenisligi = constraints.maxWidth < 520
                  ? 120
                  : 138;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: bolum.masalar
                    .map(
                      (_MasaPlaniKutusuVeri masa) => SizedBox(
                        width: kartGenisligi,
                        child: _MasaPlaniKutusu(masa: masa),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MasaPlaniKutusu extends StatelessWidget {
  const _MasaPlaniKutusu({required this.masa});

  final _MasaPlaniKutusuVeri masa;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 142),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: masa.renk.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: masa.renk.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(masa.ikon, color: masa.renk, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.80),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                masa.durumEtiketi,
                style: TextStyle(
                  color: masa.renk,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            masa.baslik,
            style: const TextStyle(
              color: Color(0xFF25192E),
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${masa.kapasite} kisilik duzen',
            style: const TextStyle(
              color: Color(0xFF6D6079),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            masa.aciklama,
            style: const TextStyle(
              color: Color(0xFF6D6079),
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _BolumPlaniVeri {
  const _BolumPlaniVeri({
    required this.baslik,
    required this.aciklama,
    required this.ikon,
    required this.vurguRengi,
    required this.zeminRengi,
    required this.kenarRengi,
    required this.masalar,
  });

  final String baslik;
  final String aciklama;
  final IconData ikon;
  final Color vurguRengi;
  final Color zeminRengi;
  final Color kenarRengi;
  final List<_MasaPlaniKutusuVeri> masalar;

  int get doluMasaSayisi =>
      masalar.where((_MasaPlaniKutusuVeri masa) => masa.doluMu).length;

  static List<_BolumPlaniVeri> uret(
    List<SiparisVarligi> siparisler,
    List<SalonBolumuVarligi> salonBolumleri,
  ) {
    final List<SiparisVarligi> salonSiparisleri = siparisler
        .where((siparis) => siparis.teslimatTipi == TeslimatTipi.restorandaYe)
        .toList();

    return salonBolumleri.asMap().entries.map((entry) {
      final int index = entry.key;
      final SalonBolumuVarligi bolum = entry.value;
      final _BolumGorunumu gorunum = _BolumGorunumu.indexIle(index, bolum.ad);

      return _BolumPlaniVeri(
        baslik: bolum.ad == 'Salon' ? 'Ana salon' : bolum.ad,
        aciklama: bolum.aciklama,
        ikon: gorunum.ikon,
        vurguRengi: gorunum.vurguRengi,
        zeminRengi: gorunum.zeminRengi,
        kenarRengi: gorunum.kenarRengi,
        masalar: _bolumMasalariniHazirla(
          bolum: bolum,
          siparisler: salonSiparisleri,
        ),
      );
    }).toList();
  }

  static List<_MasaPlaniKutusuVeri> _bolumMasalariniHazirla({
    required SalonBolumuVarligi bolum,
    required List<SiparisVarligi> siparisler,
  }) {
    return bolum.masalar.map((MasaTanimiVarligi masa) {
      SiparisVarligi? eslesenSiparis;
      for (final SiparisVarligi siparis in siparisler) {
        final String adayBolum = (siparis.bolumAdi ?? bolum.ad).trim();
        final String adayMasa = (siparis.masaNo ?? '').trim();
        if (adayBolum.toLowerCase() == bolum.ad.toLowerCase() &&
            adayMasa == masa.ad) {
          eslesenSiparis = siparis;
          break;
        }
      }

      if (eslesenSiparis != null) {
        return _MasaPlaniKutusuVeri.siparisten(
          masaNo: masa.ad,
          kapasite: masa.kapasite,
          siparis: eslesenSiparis,
        );
      }

      final int index = bolum.masalar.indexOf(masa);
      return _MasaPlaniKutusuVeri.beklemede(
        masaNo: masa.ad,
        kapasite: masa.kapasite,
        varyant: index % 3,
      );
    }).toList();
  }
}

class _BolumGorunumu {
  const _BolumGorunumu({
    required this.ikon,
    required this.vurguRengi,
    required this.zeminRengi,
    required this.kenarRengi,
  });

  final IconData ikon;
  final Color vurguRengi;
  final Color zeminRengi;
  final Color kenarRengi;

  factory _BolumGorunumu.indexIle(int index, String ad) {
    final String adKucuk = ad.toLowerCase();
    if (adKucuk.contains('teras')) {
      return const _BolumGorunumu(
        ikon: Icons.deck_rounded,
        vurguRengi: Color(0xFF5B8CFF),
        zeminRengi: Color(0xFFF2F7FF),
        kenarRengi: Color(0xFFD6E5FF),
      );
    }
    if (adKucuk.contains('bahce')) {
      return const _BolumGorunumu(
        ikon: Icons.park_rounded,
        vurguRengi: Color(0xFF30C48D),
        zeminRengi: Color(0xFFF1FBF5),
        kenarRengi: Color(0xFFD4F1DE),
      );
    }
    const List<_BolumGorunumu> varsayilanlar = <_BolumGorunumu>[
      _BolumGorunumu(
        ikon: Icons.chair_alt_rounded,
        vurguRengi: Color(0xFFFF7A59),
        zeminRengi: Color(0xFFFFF4EF),
        kenarRengi: Color(0xFFFFD5C6),
      ),
      _BolumGorunumu(
        ikon: Icons.coffee_rounded,
        vurguRengi: Color(0xFFC58CFF),
        zeminRengi: Color(0xFFF7F0FF),
        kenarRengi: Color(0xFFE8D8FF),
      ),
      _BolumGorunumu(
        ikon: Icons.window_rounded,
        vurguRengi: Color(0xFF5B8CFF),
        zeminRengi: Color(0xFFF2F7FF),
        kenarRengi: Color(0xFFD6E5FF),
      ),
    ];
    return varsayilanlar[index % varsayilanlar.length];
  }
}

class _MasaPlaniKutusuVeri {
  const _MasaPlaniKutusuVeri({
    required this.baslik,
    required this.durumEtiketi,
    required this.aciklama,
    required this.kapasite,
    required this.ikon,
    required this.renk,
    required this.doluMu,
  });

  final String baslik;
  final String durumEtiketi;
  final String aciklama;
  final int kapasite;
  final IconData ikon;
  final Color renk;
  final bool doluMu;

  factory _MasaPlaniKutusuVeri.siparisten({
    required String masaNo,
    required int kapasite,
    required SiparisVarligi siparis,
  }) {
    final _MasaDurumSunumu sunum = _MasaDurumSunumu.siparisten(siparis.durum);
    return _MasaPlaniKutusuVeri(
      baslik: 'Masa $masaNo',
      durumEtiketi: sunum.etiket,
      aciklama:
          '${siparis.sahip.misafirBilgisi?.adSoyad ?? 'Misafir'} - ${siparis.kalemler.length} kalem',
      kapasite: kapasite,
      ikon: sunum.ikon,
      renk: sunum.renk,
      doluMu: true,
    );
  }

  factory _MasaPlaniKutusuVeri.beklemede({
    required String masaNo,
    required int kapasite,
    required int varyant,
  }) {
    switch (varyant) {
      case 0:
        return _MasaPlaniKutusuVeri(
          baslik: 'Masa $masaNo',
          durumEtiketi: 'Bos',
          aciklama: 'Yeni misafir icin hazir bekliyor.',
          kapasite: kapasite,
          ikon: Icons.event_seat_outlined,
          renk: const Color(0xFF5B8CFF),
          doluMu: false,
        );
      case 1:
        return _MasaPlaniKutusuVeri(
          baslik: 'Masa $masaNo',
          durumEtiketi: 'Temizleniyor',
          aciklama: 'Kapanan servis sonrasi masa duzeni yenileniyor.',
          kapasite: kapasite,
          ikon: Icons.cleaning_services_rounded,
          renk: const Color(0xFF9AA6B2),
          doluMu: false,
        );
      default:
        return _MasaPlaniKutusuVeri(
          baslik: 'Masa $masaNo',
          durumEtiketi: 'Hazir',
          aciklama: 'Kuver ve QR karti yerlestirildi.',
          kapasite: kapasite,
          ikon: Icons.check_circle_outline_rounded,
          renk: const Color(0xFF30C48D),
          doluMu: false,
        );
    }
  }
}

class _MasaDurumSunumu {
  const _MasaDurumSunumu({
    required this.etiket,
    required this.ikon,
    required this.renk,
  });

  final String etiket;
  final IconData ikon;
  final Color renk;

  factory _MasaDurumSunumu.siparisten(SiparisDurumu durum) {
    switch (durum) {
      case SiparisDurumu.alindi:
        return const _MasaDurumSunumu(
          etiket: 'Siparis bekliyor',
          ikon: Icons.restaurant_menu_rounded,
          renk: Color(0xFFFF8B6B),
        );
      case SiparisDurumu.hazirlaniyor:
        return const _MasaDurumSunumu(
          etiket: 'Hazirlaniyor',
          ikon: Icons.local_fire_department_outlined,
          renk: Color(0xFFFF7A59),
        );
      case SiparisDurumu.hazir:
        return const _MasaDurumSunumu(
          etiket: 'Serviste',
          ikon: Icons.room_service_rounded,
          renk: Color(0xFFC58CFF),
        );
      case SiparisDurumu.yolda:
        return const _MasaDurumSunumu(
          etiket: 'Hesap istendi',
          ikon: Icons.receipt_long_rounded,
          renk: Color(0xFF7B6DFF),
        );
      case SiparisDurumu.teslimEdildi:
        return const _MasaDurumSunumu(
          etiket: 'Kapanisa yakin',
          ikon: Icons.payments_outlined,
          renk: Color(0xFF30C48D),
        );
      case SiparisDurumu.iptalEdildi:
        return const _MasaDurumSunumu(
          etiket: 'Iptal edildi',
          ikon: Icons.do_not_disturb_alt_rounded,
          renk: Color(0xFFEF6A6A),
        );
    }
  }
}
