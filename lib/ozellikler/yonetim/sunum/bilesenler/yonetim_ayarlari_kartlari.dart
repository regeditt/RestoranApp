import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:restoran_app/ortak/bilesenler/suruklenebilir_dialog_kapsayici.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_karti_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/kurye_takip_entegrasyon_varliklari.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_paneli_yardimcilari.dart';

class AyarlarKarti extends StatelessWidget {
  const AyarlarKarti({
    super.key,
    required this.baslik,
    required this.aciklama,
    required this.eylem,
    required this.child,
  });

  final String baslik;
  final String aciklama;
  final Widget eylem;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5FB),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(aciklama, style: const TextStyle(color: Color(0xFF6D6079))),
          const SizedBox(height: 14),
          eylem,
          const SizedBox(height: 16),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class AdminBolumKarti extends StatelessWidget {
  const AdminBolumKarti({
    super.key,
    required this.bolum,
    required this.masaEkle,
    required this.bolumDuzenle,
    required this.bolumSil,
    required this.qrBaglamiAc,
    required this.masaDuzenle,
    required this.masaSil,
  });

  final SalonBolumuVarligi bolum;
  final VoidCallback masaEkle;
  final VoidCallback bolumDuzenle;
  final VoidCallback bolumSil;
  final ValueChanged<MasaTanimiVarligi> qrBaglamiAc;
  final ValueChanged<MasaTanimiVarligi> masaDuzenle;
  final ValueChanged<MasaTanimiVarligi> masaSil;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
                    Text(
                      bolum.ad,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bolum.aciklama,
                      style: const TextStyle(color: Color(0xFF6D6079)),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: bolumDuzenle,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: bolumSil,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...bolum.masalar.map(
                (MasaTanimiVarligi masa) => InputChip(
                  label: Text('Masa ${masa.ad} - ${masa.kapasite} kisilik'),
                  avatar: PopupMenuButton<String>(
                    tooltip: 'Masa islemleri',
                    onSelected: (String islem) {
                      switch (islem) {
                        case 'qr':
                          qrBaglamiAc(masa);
                          break;
                        case 'duzenle':
                          masaDuzenle(masa);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => const [
                      PopupMenuItem<String>(
                        value: 'qr',
                        child: Text('QR baglamini ac'),
                      ),
                      PopupMenuItem<String>(
                        value: 'duzenle',
                        child: Text('Masayi duzenle'),
                      ),
                    ],
                    icon: const Icon(Icons.more_horiz_rounded, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  onPressed: () => qrBaglamiAc(masa),
                  onDeleted: () => masaSil(masa),
                  deleteIcon: const Icon(Icons.delete_outline_rounded),
                ),
              ),
              ActionChip(
                avatar: const Icon(Icons.add, size: 18),
                label: const Text('Masa ekle'),
                onPressed: masaEkle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminUrunSatiri extends StatelessWidget {
  const AdminUrunSatiri({
    super.key,
    required this.urun,
    required this.kategoriAdi,
    required this.receteOzeti,
    required this.urunDuzenle,
    required this.receteDuzenle,
    required this.urunSil,
  });

  final UrunVarligi urun;
  final String kategoriAdi;
  final String receteOzeti;
  final VoidCallback urunDuzenle;
  final VoidCallback receteDuzenle;
  final VoidCallback urunSil;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  urun.ad,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                paraYaz(urun.fiyat),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$kategoriAdi · ${urun.stoktaMi ? 'Stokta' : 'Kapali'}${urun.oneCikanMi ? ' · One cikan' : ''}',
            style: const TextStyle(color: Color(0xFF6D6079)),
          ),
          const SizedBox(height: 6),
          Text(urun.aciklama, style: const TextStyle(color: Color(0xFF6D6079))),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5FB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recete baglantisi',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  receteOzeti,
                  style: const TextStyle(color: Color(0xFF6D6079), height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              FilledButton.tonal(
                onPressed: urunDuzenle,
                child: const Text('Duzenle'),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: receteDuzenle,
                child: const Text('Recete'),
              ),
              const SizedBox(width: 8),
              TextButton(onPressed: urunSil, child: const Text('Kaldir')),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminHammaddeSatiri extends StatelessWidget {
  const AdminHammaddeSatiri({
    super.key,
    required this.hammadde,
    required this.duzenle,
  });

  final HammaddeStokVarligi hammadde;
  final VoidCallback duzenle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hammadde.kritikMi
              ? const Color(0xFFFFC7B8)
              : const Color(0xFFE8E0F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  hammadde.ad,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                hammadde.kritikMi ? 'Kritik' : 'Normal',
                style: TextStyle(
                  color: hammadde.kritikMi
                      ? const Color(0xFFFF7A59)
                      : const Color(0xFF30C48D),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${hammadde.mevcutMiktar.toStringAsFixed(0)} ${hammadde.birim} · Esik ${hammadde.kritikEsik.toStringAsFixed(0)} ${hammadde.birim}',
            style: const TextStyle(color: Color(0xFF6D6079)),
          ),
          const SizedBox(height: 6),
          Text(
            'Birim maliyet ${paraYaz(hammadde.birimMaliyet)}',
            style: const TextStyle(color: Color(0xFF6D6079)),
          ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: duzenle,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Duzenle'),
          ),
        ],
      ),
    );
  }
}

class AdminKuryeSaglayiciSatiri extends StatelessWidget {
  const AdminKuryeSaglayiciSatiri({
    super.key,
    required this.saglayici,
    required this.baglantiTestEt,
    required this.duzenle,
    required this.sil,
    required this.aktifYap,
    required this.oncelikYukselt,
    required this.oncelikDusur,
    required this.yukariTasinabilir,
    required this.asagiTasinabilir,
  });

  final KuryeTakipSaglayiciVarligi saglayici;
  final VoidCallback baglantiTestEt;
  final VoidCallback duzenle;
  final VoidCallback sil;
  final VoidCallback aktifYap;
  final VoidCallback oncelikYukselt;
  final VoidCallback oncelikDusur;
  final bool yukariTasinabilir;
  final bool asagiTasinabilir;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: saglayici.aktifMi
              ? const Color(0xFFB9F2DC)
              : const Color(0xFFE8E0F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  saglayici.ad,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Chip(
                label: Text(
                  saglayici.aktifMi ? 'Aktif' : 'Pasif',
                  style: TextStyle(
                    color: saglayici.aktifMi
                        ? const Color(0xFF0F8A5C)
                        : const Color(0xFF6D6079),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${saglayici.tur.etiket} - Oncelik ${saglayici.oncelik}',
            style: const TextStyle(color: Color(0xFF6D6079)),
          ),
          const SizedBox(height: 4),
          Text(
            saglayici.apiTabanUrl,
            style: const TextStyle(color: Color(0xFF6D6079)),
          ),
          const SizedBox(height: 4),
          Text(
            saglayici.aciklama,
            style: const TextStyle(color: Color(0xFF6D6079)),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              FilledButton.tonalIcon(
                onPressed: baglantiTestEt,
                icon: const Icon(Icons.health_and_safety_rounded),
                label: const Text('Test et'),
              ),
              FilledButton.tonalIcon(
                onPressed: duzenle,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Duzenle'),
              ),
              FilledButton.tonalIcon(
                onPressed: saglayici.aktifMi ? null : aktifYap,
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text('Aktif yap'),
              ),
              IconButton(
                onPressed: yukariTasinabilir ? oncelikYukselt : null,
                icon: const Icon(Icons.keyboard_arrow_up_rounded),
                tooltip: 'Onceligi artir',
              ),
              IconButton(
                onPressed: asagiTasinabilir ? oncelikDusur : null,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                tooltip: 'Onceligi azalt',
              ),
              TextButton(onPressed: sil, child: const Text('Sil')),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminKuryeEslesmeSatiri extends StatelessWidget {
  const AdminKuryeEslesmeSatiri({
    super.key,
    required this.eslesme,
    required this.saglayiciAdi,
    required this.duzenle,
    required this.sil,
  });

  final KuryeCihazEslesmesiVarligi eslesme;
  final String saglayiciAdi;
  final VoidCallback duzenle;
  final VoidCallback sil;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: eslesme.aktifMi
              ? const Color(0xFFE8E0F0)
              : const Color(0xFFF2EDF6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  eslesme.kuryeAdi,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                eslesme.aktifMi ? 'Aktif' : 'Pasif',
                style: TextStyle(
                  color: eslesme.aktifMi
                      ? const Color(0xFF30C48D)
                      : const Color(0xFF9987AA),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Saglayici: $saglayiciAdi'),
          const SizedBox(height: 4),
          Text(
            'Cihaz kimligi: ${eslesme.cihazKimligi}',
            style: const TextStyle(color: Color(0xFF6D6079)),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              FilledButton.tonalIcon(
                onPressed: duzenle,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Duzenle'),
              ),
              const SizedBox(width: 8),
              TextButton(onPressed: sil, child: const Text('Sil')),
            ],
          ),
        ],
      ),
    );
  }
}

class ReceteSatiriGirdisi {
  const ReceteSatiriGirdisi({required this.hammaddeId, required this.miktar});

  final String hammaddeId;
  final double miktar;

  ReceteSatiriGirdisi copyWith({String? hammaddeId, double? miktar}) {
    return ReceteSatiriGirdisi(
      hammaddeId: hammaddeId ?? this.hammaddeId,
      miktar: miktar ?? this.miktar,
    );
  }
}

class ReceteDuzenlemeDialog extends StatefulWidget {
  const ReceteDuzenlemeDialog({
    super.key,
    required this.urun,
    required this.hammaddeler,
    required this.baslangicRecetesi,
  });

  final UrunVarligi urun;
  final List<HammaddeStokVarligi> hammaddeler;
  final List<ReceteKalemiVarligi> baslangicRecetesi;

  @override
  State<ReceteDuzenlemeDialog> createState() => _ReceteDuzenlemeDialogState();
}

class _ReceteDuzenlemeDialogState extends State<ReceteDuzenlemeDialog> {
  late List<ReceteSatiriGirdisi> _satirlar;

  @override
  void initState() {
    super.initState();
    _satirlar = widget.baslangicRecetesi
        .map(
          (ReceteKalemiVarligi kalem) => ReceteSatiriGirdisi(
            hammaddeId: kalem.hammaddeId,
            miktar: kalem.miktar,
          ),
        )
        .toList();
    if (_satirlar.isEmpty && widget.hammaddeler.isNotEmpty) {
      _satirEkle();
    }
  }

  void _satirEkle() {
    if (widget.hammaddeler.isEmpty) {
      return;
    }
    final String varsayilanHammaddeId = widget.hammaddeler.first.id;
    setState(() {
      _satirlar = <ReceteSatiriGirdisi>[
        ..._satirlar,
        ReceteSatiriGirdisi(hammaddeId: varsayilanHammaddeId, miktar: 1),
      ];
    });
  }

  void _satirSil(int index) {
    setState(() {
      _satirlar = <ReceteSatiriGirdisi>[..._satirlar.where((_) => true)]
        ..removeAt(index);
    });
  }

  void _satirGuncelle(int index, ReceteSatiriGirdisi satir) {
    setState(() {
      _satirlar = <ReceteSatiriGirdisi>[
        for (int i = 0; i < _satirlar.length; i++)
          if (i == index) satir else _satirlar[i],
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SuruklenebilirPopupSablonu(
      materialKullan: false,
      child: AlertDialog(
        title: Text('${widget.urun.ad} recetesi'),
        content: SizedBox(
          width: 540,
          child: widget.hammaddeler.isEmpty
              ? const Text('Once hammadde ekleyip tekrar dene.')
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bu urun icin kullanilan hammaddeleri ve tuketim miktarlarini belirle.',
                      ),
                      const SizedBox(height: 16),
                      ..._satirlar.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ReceteSatiri(
                            key: ValueKey('recete_satiri_${entry.key}'),
                            satir: entry.value,
                            hammaddeler: widget.hammaddeler,
                            kaldir: _satirlar.length == 1
                                ? null
                                : () => _satirSil(entry.key),
                            guncelle: (ReceteSatiriGirdisi satir) =>
                                _satirGuncelle(entry.key, satir),
                          ),
                        ),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: _satirEkle,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Kalem ekle'),
                      ),
                    ],
                  ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Vazgec'),
          ),
          FilledButton(
            onPressed: () {
              final List<ReceteKalemiVarligi> recete = _satirlar
                  .where((satir) => satir.miktar > 0)
                  .map(
                    (satir) => ReceteKalemiVarligi(
                      hammaddeId: satir.hammaddeId,
                      miktar: satir.miktar,
                    ),
                  )
                  .toList();
              Navigator.of(context).pop(recete);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}

class ReceteSatiri extends StatefulWidget {
  const ReceteSatiri({
    super.key,
    required this.satir,
    required this.hammaddeler,
    required this.guncelle,
    this.kaldir,
  });

  final ReceteSatiriGirdisi satir;
  final List<HammaddeStokVarligi> hammaddeler;
  final ValueChanged<ReceteSatiriGirdisi> guncelle;
  final VoidCallback? kaldir;

  @override
  State<ReceteSatiri> createState() => _ReceteSatiriState();
}

class _ReceteSatiriState extends State<ReceteSatiri> {
  late final TextEditingController _miktarDenetleyici;

  @override
  void initState() {
    super.initState();
    _miktarDenetleyici = TextEditingController(
      text: widget.satir.miktar.toStringAsFixed(1),
    );
  }

  @override
  void didUpdateWidget(covariant ReceteSatiri oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.satir.miktar != widget.satir.miktar) {
      _miktarDenetleyici.text = widget.satir.miktar.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _miktarDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HammaddeStokVarligi seciliHammadde = widget.hammaddeler.firstWhere(
      (HammaddeStokVarligi hammadde) => hammadde.id == widget.satir.hammaddeId,
      orElse: () => widget.hammaddeler.first,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E0F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: DropdownButtonFormField<String>(
              initialValue: seciliHammadde.id,
              decoration: const InputDecoration(labelText: 'Hammadde'),
              items: widget.hammaddeler
                  .map(
                    (HammaddeStokVarligi hammadde) => DropdownMenuItem<String>(
                      value: hammadde.id,
                      child: Text('${hammadde.ad} (${hammadde.birim})'),
                    ),
                  )
                  .toList(),
              onChanged: (String? deger) {
                if (deger == null) {
                  return;
                }
                widget.guncelle(widget.satir.copyWith(hammaddeId: deger));
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 4,
            child: TextField(
              controller: _miktarDenetleyici,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Miktar',
                helperText: seciliHammadde.birim,
              ),
              onChanged: (String deger) {
                final double? miktar = double.tryParse(
                  deger.trim().replaceAll(',', '.'),
                );
                widget.guncelle(widget.satir.copyWith(miktar: miktar ?? 0));
              },
            ),
          ),
          if (widget.kaldir != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: widget.kaldir,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ],
      ),
    );
  }
}

class TopluQrKarti extends StatelessWidget {
  const TopluQrKarti({super.key, required this.kart});

  final QrMenuKartiVarligi kart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFDF7FB), Color(0xFFFFFFFF)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4D8EE)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE3EC),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              UygulamaSabitleri.tamMarkaAdi,
              style: const TextStyle(
                color: Color(0xFFA13A63),
                fontWeight: FontWeight.w900,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 10),
          QrImageView(
            data: kart.url,
            version: QrVersions.auto,
            size: 150,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            kart.baslik,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            kart.altBaslik,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6D6079),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tarat ve menuye ulas',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6D6079),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
