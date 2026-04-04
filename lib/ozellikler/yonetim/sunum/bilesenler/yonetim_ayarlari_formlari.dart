import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bilesenler/suruklenebilir_dialog_kapsayici.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

class SalonBolumuFormSonucu {
  const SalonBolumuFormSonucu({required this.ad, required this.aciklama});

  final String ad;
  final String aciklama;
}

class SalonBolumuFormDialog extends StatefulWidget {
  const SalonBolumuFormDialog({super.key, this.baslangicBolumu});

  final SalonBolumuVarligi? baslangicBolumu;

  @override
  State<SalonBolumuFormDialog> createState() => SalonBolumuFormDialogState();
}

class SalonBolumuFormDialogState extends State<SalonBolumuFormDialog> {
  late final TextEditingController _adDenetleyici;
  late final TextEditingController _aciklamaDenetleyici;

  @override
  void initState() {
    super.initState();
    _adDenetleyici = TextEditingController(
      text: widget.baslangicBolumu?.ad ?? '',
    );
    _aciklamaDenetleyici = TextEditingController(
      text: widget.baslangicBolumu?.aciklama ?? '',
    );
  }

  @override
  void dispose() {
    _adDenetleyici.dispose();
    _aciklamaDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuruklenebilirPopupSablonu(
      materialKullan: false,
      child: AlertDialog(
        title: const Text('Bolum ekle'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _adDenetleyici,
                decoration: const InputDecoration(labelText: 'Bolum adi'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _aciklamaDenetleyici,
                decoration: const InputDecoration(labelText: 'Aciklama'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Vazgec'),
          ),
          FilledButton(
            onPressed: () {
              final String ad = _adDenetleyici.text.trim();
              final String aciklama = _aciklamaDenetleyici.text.trim();
              if (ad.isEmpty || aciklama.isEmpty) {
                return;
              }
              Navigator.of(
                context,
              ).pop(SalonBolumuFormSonucu(ad: ad, aciklama: aciklama));
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}

class MasaFormSonucu {
  const MasaFormSonucu({required this.ad, required this.kapasite});

  final String ad;
  final int kapasite;
}

class MasaFormDialog extends StatefulWidget {
  const MasaFormDialog({
    super.key,
    required this.bolumAdi,
    this.baslangicMasasi,
  });

  final String bolumAdi;
  final MasaTanimiVarligi? baslangicMasasi;

  @override
  State<MasaFormDialog> createState() => MasaFormDialogState();
}

class MasaFormDialogState extends State<MasaFormDialog> {
  late final TextEditingController _adDenetleyici;
  late int _kapasite;

  @override
  void initState() {
    super.initState();
    _adDenetleyici = TextEditingController(
      text: widget.baslangicMasasi?.ad ?? '',
    );
    _kapasite = widget.baslangicMasasi?.kapasite ?? 4;
  }

  @override
  void dispose() {
    _adDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuruklenebilirPopupSablonu(
      materialKullan: false,
      child: AlertDialog(
        title: Text('${widget.bolumAdi} icin masa ekle'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _adDenetleyici,
                decoration: const InputDecoration(labelText: 'Masa no'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _kapasite,
                decoration: const InputDecoration(labelText: 'Kapasite'),
                items: const [2, 4, 6, 8]
                    .map(
                      (int deger) => DropdownMenuItem<int>(
                        value: deger,
                        child: Text('$deger kisilik'),
                      ),
                    )
                    .toList(),
                onChanged: (int? deger) {
                  if (deger != null) {
                    setState(() {
                      _kapasite = deger;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Vazgec'),
          ),
          FilledButton(
            onPressed: () {
              final String ad = _adDenetleyici.text.trim();
              if (ad.isEmpty) {
                return;
              }
              Navigator.of(
                context,
              ).pop(MasaFormSonucu(ad: ad, kapasite: _kapasite));
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}

class KategoriFormSonucu {
  const KategoriFormSonucu({required this.ad});

  final String ad;
}

class KategoriFormDialog extends StatefulWidget {
  const KategoriFormDialog({super.key, this.baslangicKategori});

  final KategoriVarligi? baslangicKategori;

  @override
  State<KategoriFormDialog> createState() => KategoriFormDialogState();
}

class KategoriFormDialogState extends State<KategoriFormDialog> {
  late final TextEditingController _adDenetleyici;

  @override
  void initState() {
    super.initState();
    _adDenetleyici = TextEditingController(
      text: widget.baslangicKategori?.ad ?? '',
    );
  }

  @override
  void dispose() {
    _adDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuruklenebilirPopupSablonu(
      materialKullan: false,
      child: AlertDialog(
        title: const Text('Kategori ekle'),
        content: TextField(
          controller: _adDenetleyici,
          decoration: const InputDecoration(labelText: 'Kategori adi'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Vazgec'),
          ),
          FilledButton(
            onPressed: () {
              final String ad = _adDenetleyici.text.trim();
              if (ad.isEmpty) {
                return;
              }
              Navigator.of(context).pop(KategoriFormSonucu(ad: ad));
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}

class UrunFormSonucu {
  const UrunFormSonucu({
    required this.kategoriId,
    required this.ad,
    required this.aciklama,
    required this.fiyat,
    required this.stoktaMi,
    required this.oneCikanMi,
  });

  final String kategoriId;
  final String ad;
  final String aciklama;
  final double fiyat;
  final bool stoktaMi;
  final bool oneCikanMi;
}

class UrunFormDialog extends StatefulWidget {
  const UrunFormDialog({super.key, required this.kategoriler, this.urun});

  final List<KategoriVarligi> kategoriler;
  final UrunVarligi? urun;

  @override
  State<UrunFormDialog> createState() => UrunFormDialogState();
}

class UrunFormDialogState extends State<UrunFormDialog> {
  late final TextEditingController _adDenetleyici;
  late final TextEditingController _aciklamaDenetleyici;
  late final TextEditingController _fiyatDenetleyici;
  late String _kategoriId;
  late bool _stoktaMi;
  late bool _oneCikanMi;

  @override
  void initState() {
    super.initState();
    _kategoriId = widget.urun?.kategoriId ?? widget.kategoriler.first.id;
    _stoktaMi = widget.urun?.stoktaMi ?? true;
    _oneCikanMi = widget.urun?.oneCikanMi ?? false;
    _adDenetleyici = TextEditingController(text: widget.urun?.ad ?? '');
    _aciklamaDenetleyici = TextEditingController(
      text: widget.urun?.aciklama ?? '',
    );
    _fiyatDenetleyici = TextEditingController(
      text: widget.urun?.fiyat.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _adDenetleyici.dispose();
    _aciklamaDenetleyici.dispose();
    _fiyatDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuruklenebilirPopupSablonu(
      materialKullan: false,
      child: AlertDialog(
        title: Text(widget.urun == null ? 'Urun ekle' : 'Urunu duzenle'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _kategoriId,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  items: widget.kategoriler
                      .map(
                        (KategoriVarligi kategori) => DropdownMenuItem<String>(
                          value: kategori.id,
                          child: Text(kategori.ad),
                        ),
                      )
                      .toList(),
                  onChanged: (String? deger) {
                    if (deger != null) {
                      setState(() {
                        _kategoriId = deger;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _adDenetleyici,
                  decoration: const InputDecoration(labelText: 'Urun adi'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _aciklamaDenetleyici,
                  minLines: 2,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Aciklama'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _fiyatDenetleyici,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Fiyat'),
                ),
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Stokta'),
                  value: _stoktaMi,
                  onChanged: (bool deger) {
                    setState(() {
                      _stoktaMi = deger;
                    });
                  },
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('One cikan urun'),
                  value: _oneCikanMi,
                  onChanged: (bool deger) {
                    setState(() {
                      _oneCikanMi = deger;
                    });
                  },
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
              final String ad = _adDenetleyici.text.trim();
              final String aciklama = _aciklamaDenetleyici.text.trim();
              final double? fiyat = double.tryParse(
                _fiyatDenetleyici.text.trim().replaceAll(',', '.'),
              );
              if (ad.isEmpty || aciklama.isEmpty || fiyat == null) {
                return;
              }
              Navigator.of(context).pop(
                UrunFormSonucu(
                  kategoriId: _kategoriId,
                  ad: ad,
                  aciklama: aciklama,
                  fiyat: fiyat,
                  stoktaMi: _stoktaMi,
                  oneCikanMi: _oneCikanMi,
                ),
              );
            },
            child: Text(widget.urun == null ? 'Ekle' : 'Kaydet'),
          ),
        ],
      ),
    );
  }
}

class HammaddeFormSonucu {
  const HammaddeFormSonucu({
    required this.ad,
    required this.birim,
    required this.mevcutMiktar,
    required this.kritikEsik,
    required this.birimMaliyet,
  });

  final String ad;
  final String birim;
  final double mevcutMiktar;
  final double kritikEsik;
  final double birimMaliyet;
}

class HammaddeFormDialog extends StatefulWidget {
  const HammaddeFormDialog({super.key, this.baslangicHammadde});

  final HammaddeStokVarligi? baslangicHammadde;

  @override
  State<HammaddeFormDialog> createState() => HammaddeFormDialogState();
}

class HammaddeFormDialogState extends State<HammaddeFormDialog> {
  late final TextEditingController _adDenetleyici;
  late final TextEditingController _birimDenetleyici;
  late final TextEditingController _miktarDenetleyici;
  late final TextEditingController _esikDenetleyici;
  late final TextEditingController _maliyetDenetleyici;

  @override
  void initState() {
    super.initState();
    _adDenetleyici = TextEditingController(
      text: widget.baslangicHammadde?.ad ?? '',
    );
    _birimDenetleyici = TextEditingController(
      text: widget.baslangicHammadde?.birim ?? 'adet',
    );
    _miktarDenetleyici = TextEditingController(
      text: widget.baslangicHammadde?.mevcutMiktar.toStringAsFixed(0) ?? '',
    );
    _esikDenetleyici = TextEditingController(
      text: widget.baslangicHammadde?.kritikEsik.toStringAsFixed(0) ?? '',
    );
    _maliyetDenetleyici = TextEditingController(
      text: widget.baslangicHammadde?.birimMaliyet.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _adDenetleyici.dispose();
    _birimDenetleyici.dispose();
    _miktarDenetleyici.dispose();
    _esikDenetleyici.dispose();
    _maliyetDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuruklenebilirPopupSablonu(
      materialKullan: false,
      child: AlertDialog(
        title: Text(
          widget.baslangicHammadde == null
              ? 'Hammadde ekle'
              : 'Hammadde duzenle',
        ),
        content: SizedBox(
          width: 380,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _adDenetleyici,
                  decoration: const InputDecoration(labelText: 'Hammadde adi'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _birimDenetleyici,
                  decoration: const InputDecoration(labelText: 'Birim'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _miktarDenetleyici,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Mevcut miktar'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _esikDenetleyici,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Kritik esik'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _maliyetDenetleyici,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Birim maliyet'),
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
              final String ad = _adDenetleyici.text.trim();
              final String birim = _birimDenetleyici.text.trim();
              final double? miktar = double.tryParse(
                _miktarDenetleyici.text.trim().replaceAll(',', '.'),
              );
              final double? esik = double.tryParse(
                _esikDenetleyici.text.trim().replaceAll(',', '.'),
              );
              final double? maliyet = double.tryParse(
                _maliyetDenetleyici.text.trim().replaceAll(',', '.'),
              );
              if (ad.isEmpty ||
                  birim.isEmpty ||
                  miktar == null ||
                  esik == null ||
                  maliyet == null) {
                return;
              }
              Navigator.of(context).pop(
                HammaddeFormSonucu(
                  ad: ad,
                  birim: birim,
                  mevcutMiktar: miktar,
                  kritikEsik: esik,
                  birimMaliyet: maliyet,
                ),
              );
            },
            child: Text(widget.baslangicHammadde == null ? 'Ekle' : 'Kaydet'),
          ),
        ],
      ),
    );
  }
}
