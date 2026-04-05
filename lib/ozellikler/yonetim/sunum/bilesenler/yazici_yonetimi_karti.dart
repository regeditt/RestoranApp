import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bilesenler/suruklenebilir_dialog_kapsayici.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_is_kuyrugu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/servisler/yazici_is_kuyrugu_hesaplayici.dart';

class YaziciYonetimiKarti extends StatelessWidget {
  const YaziciYonetimiKarti({
    super.key,
    required this.yazicilar,
    required this.siparisler,
    required this.yaziciEkle,
    required this.yaziciSil,
    required this.yaziciGuncelle,
  });

  final List<YaziciDurumuVarligi> yazicilar;
  final List<SiparisVarligi> siparisler;
  final Future<void> Function() yaziciEkle;
  final Future<void> Function(YaziciDurumuVarligi yazici) yaziciSil;
  final Future<void> Function(
    YaziciDurumuVarligi yazici, {
    String? rolEtiketi,
    YaziciBaglantiDurumu? durum,
  })
  yaziciGuncelle;

  @override
  Widget build(BuildContext context) {
    final int bagliYaziciSayisi = yazicilar
        .where((yazici) => yazici.durum == YaziciBaglantiDurumu.bagli)
        .length;
    final List<YaziciIsKuyruguVarligi> kuyruk =
        YaziciIsKuyruguHesaplayici.kuyruguHazirla(siparisler);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2D1B41), Color(0xFF4A2569)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Yazici yonetimi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$bagliYaziciSayisi / ${yazicilar.length} yazici bagli durumda. Mutfak, bar ve fis rollerini buradan takip et.',
                      style: const TextStyle(
                        color: Color(0xFFE8DDF0),
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: FilledButton.icon(
                  onPressed: yaziciEkle,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.12),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Yazici ekle',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (kuyruk.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Canli Yazici kuyrugu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...kuyruk.map(
                    (isEmri) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _YaziciKuyrukSatiri(isEmri: isEmri),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          ...yazicilar.map(
            (YaziciDurumuVarligi yazici) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _YaziciSatiri(
                yazici: yazici,
                yaziciSil: yaziciSil,
                yaziciGuncelle: yaziciGuncelle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class YaziciYonetimiDialog extends StatelessWidget {
  const YaziciYonetimiDialog({
    super.key,
    required this.yazicilar,
    required this.siparisler,
    required this.yaziciEkle,
    required this.yaziciSil,
    required this.yaziciGuncelle,
  });

  final List<YaziciDurumuVarligi> yazicilar;
  final List<SiparisVarligi> siparisler;
  final Future<void> Function() yaziciEkle;
  final Future<void> Function(YaziciDurumuVarligi yazici) yaziciSil;
  final Future<void> Function(
    YaziciDurumuVarligi yazici, {
    String? rolEtiketi,
    YaziciBaglantiDurumu? durum,
  })
  yaziciGuncelle;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData medya = MediaQuery.of(context);
    return SuruklenebilirPopupSablonu(
      maxGenislik: 860,
      maxYukseklik: 760,
      materialKullan: false,
      tutamacRenk: const Color(0x80E8DDF0),
      child: MediaQuery(
        data: medya.copyWith(textScaler: const TextScaler.linear(1)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SingleChildScrollView(
              child: YaziciYonetimiKarti(
                yazicilar: yazicilar,
                siparisler: siparisler,
                yaziciEkle: yaziciEkle,
                yaziciSil: yaziciSil,
                yaziciGuncelle: yaziciGuncelle,
              ),
            ),
            Positioned(
              right: -10,
              top: -10,
              child: IconButton.filled(
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.18),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YaziciSatiri extends StatelessWidget {
  const _YaziciSatiri({
    required this.yazici,
    required this.yaziciSil,
    required this.yaziciGuncelle,
  });

  final YaziciDurumuVarligi yazici;
  final Future<void> Function(YaziciDurumuVarligi yazici) yaziciSil;
  final Future<void> Function(
    YaziciDurumuVarligi yazici, {
    String? rolEtiketi,
    YaziciBaglantiDurumu? durum,
  })
  yaziciGuncelle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.print_rounded, color: yazici.renk, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      yazici.ad,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${yazici.rolEtiketi}  |  ${yazici.baglantiNoktasi}',
                      style: const TextStyle(
                        color: Color(0xFFE8DDF0),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (String deger) {
                  switch (deger) {
                    case 'rol_mutfak':
                      yaziciGuncelle(yazici, rolEtiketi: 'Mutfak');
                    case 'rol_icecek':
                      yaziciGuncelle(yazici, rolEtiketi: 'Icecek');
                    case 'rol_kasa':
                      yaziciGuncelle(yazici, rolEtiketi: 'Kasa');
                    case 'durum_bagli':
                      yaziciGuncelle(yazici, durum: YaziciBaglantiDurumu.bagli);
                    case 'durum_dikkat':
                      yaziciGuncelle(
                        yazici,
                        durum: YaziciBaglantiDurumu.dikkat,
                      );
                    case 'durum_kapali':
                      yaziciGuncelle(
                        yazici,
                        durum: YaziciBaglantiDurumu.kapali,
                      );
                    case 'sil':
                      yaziciSil(yazici);
                  }
                },
                color: const Color(0xFF43235F),
                itemBuilder: (BuildContext context) => const [
                  PopupMenuItem<String>(
                    value: 'rol_mutfak',
                    child: Text('Rol: Mutfak'),
                  ),
                  PopupMenuItem<String>(
                    value: 'rol_icecek',
                    child: Text('Rol: Icecek'),
                  ),
                  PopupMenuItem<String>(
                    value: 'rol_kasa',
                    child: Text('Rol: Kasa'),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'durum_bagli',
                    child: Text('Durum: Bagli'),
                  ),
                  PopupMenuItem<String>(
                    value: 'durum_dikkat',
                    child: Text('Durum: Dikkat'),
                  ),
                  PopupMenuItem<String>(
                    value: 'durum_kapali',
                    child: Text('Durum: Kapali'),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'sil',
                    child: Text('Yaziciyi sil'),
                  ),
                ],
                icon: const Icon(Icons.more_horiz, color: Colors.white),
              ),
              const SizedBox(width: 8),
              _YaziciDurumRozeti(yazici: yazici),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  yazici.aciklama,
                  style: const TextStyle(
                    color: Color(0xFFE8DDF0),
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${yazici.ad} icin test cikti kuyruga alindi',
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.receipt_long_outlined, size: 18),
                label: const Text(
                  'Test',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _YaziciDurumRozeti extends StatelessWidget {
  const _YaziciDurumRozeti({required this.yazici});

  final YaziciDurumuVarligi yazici;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        yazici.durumEtiketi,
        style: TextStyle(
          color: yazici.renk,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _YaziciKuyrukSatiri extends StatelessWidget {
  const _YaziciKuyrukSatiri({required this.isEmri});

  final YaziciIsKuyruguVarligi isEmri;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            isEmri.siparisNo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${isEmri.yaziciRolu} - ${isEmri.durumEtiketi}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                isEmri.kisaAciklama,
                style: const TextStyle(color: Color(0xFFE8DDF0), fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
