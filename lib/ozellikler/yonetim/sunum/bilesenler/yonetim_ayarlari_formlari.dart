import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bilesenler/suruklenebilir_dialog_kapsayici.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/kurye_takip_entegrasyon_varliklari.dart';
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
    required this.gorselUrl,
    required this.stoktaMi,
    required this.oneCikanMi,
  });

  final String kategoriId;
  final String ad;
  final String aciklama;
  final double fiyat;
  final String? gorselUrl;
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
  static const int _maksimumGorselBoyutuBayt = 500 * 1024;

  late final TextEditingController _adDenetleyici;
  late final TextEditingController _aciklamaDenetleyici;
  late final TextEditingController _fiyatDenetleyici;
  late final TextEditingController _gorselUrlDenetleyici;
  late String _kategoriId;
  late bool _stoktaMi;
  late bool _oneCikanMi;
  bool _gorselSeciliyor = false;

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
    _gorselUrlDenetleyici = TextEditingController(
      text: widget.urun?.gorselUrl ?? '',
    );
  }

  @override
  void dispose() {
    _adDenetleyici.dispose();
    _aciklamaDenetleyici.dispose();
    _fiyatDenetleyici.dispose();
    _gorselUrlDenetleyici.dispose();
    super.dispose();
  }

  Future<void> _cihazdanGorselSec() async {
    if (_gorselSeciliyor) {
      return;
    }
    setState(() {
      _gorselSeciliyor = true;
    });
    try {
      final FilePickerResult? sonuc = await FilePicker.pickFiles(
        dialogTitle: 'Urun gorselini sec',
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (sonuc == null || sonuc.files.isEmpty || !mounted) {
        return;
      }
      final PlatformFile dosya = sonuc.files.first;
      final Uint8List? veri = dosya.bytes;
      if (veri == null || veri.isEmpty) {
        _hataMesajiGoster('Secilen gorselin icerigi okunamadi.');
        return;
      }
      if (veri.lengthInBytes > _maksimumGorselBoyutuBayt) {
        _hataMesajiGoster(
          'Gorsel 500 KB sinirini asiyor (${(veri.lengthInBytes / 1024).toStringAsFixed(0)} KB).',
        );
        return;
      }
      final String mimeTuru = _mimeTuruBelirle(dosya.extension);
      final String veriUri = 'data:$mimeTuru;base64,${base64Encode(veri)}';
      _gorselUrlDenetleyici.text = veriUri;
      setState(() {});
    } catch (hata) {
      _hataMesajiGoster('Gorsel secimi basarisiz: $hata');
    } finally {
      if (mounted) {
        setState(() {
          _gorselSeciliyor = false;
        });
      }
    }
  }

  String _mimeTuruBelirle(String? uzanti) {
    switch ((uzanti ?? '').toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'svg':
      case 'svgz':
        return 'image/svg+xml';
      case 'jpg':
      case 'jpeg':
      default:
        return 'image/jpeg';
    }
  }

  bool _gorselBoyutuGecerliMi(String? gorselKaynagi) {
    if (gorselKaynagi == null || gorselKaynagi.trim().isEmpty) {
      return true;
    }
    final Uint8List? veri = _veriUriBytesiniCoz(gorselKaynagi);
    if (veri == null) {
      return true;
    }
    if (veri.lengthInBytes <= _maksimumGorselBoyutuBayt) {
      return true;
    }
    _hataMesajiGoster(
      'Gorsel 500 KB sinirini asiyor (${(veri.lengthInBytes / 1024).toStringAsFixed(0)} KB).',
    );
    return false;
  }

  Uint8List? _veriUriBytesiniCoz(String kaynak) {
    final String temiz = kaynak.trim();
    if (!temiz.startsWith('data:image/')) {
      return null;
    }
    final int ayirac = temiz.indexOf(',');
    if (ayirac <= 0 || ayirac >= temiz.length - 1) {
      return null;
    }
    final String baslik = temiz.substring(0, ayirac).toLowerCase();
    if (!baslik.contains(';base64')) {
      return null;
    }
    try {
      return base64Decode(temiz.substring(ayirac + 1));
    } catch (_) {
      return null;
    }
  }

  void _gorseliKaldir() {
    if (_gorselUrlDenetleyici.text.trim().isEmpty) {
      return;
    }
    setState(() {
      _gorselUrlDenetleyici.clear();
    });
  }

  void _hataMesajiGoster(String mesaj) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mesaj), backgroundColor: const Color(0xFF8A2F2F)),
    );
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
                TextField(
                  controller: _gorselUrlDenetleyici,
                  decoration: const InputDecoration(
                    labelText: 'Gorsel baglantisi (opsiyonel)',
                    hintText: 'https://.../urun.jpg',
                    helperText: 'Dosyadan secilen gorsellerde maksimum 500 KB.',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _gorselSeciliyor ? null : _cihazdanGorselSec,
                        icon: _gorselSeciliyor
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.add_photo_alternate_outlined),
                        label: Text(
                          _gorselSeciliyor ? 'Seciliyor...' : 'Dosyadan sec',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: _gorselUrlDenetleyici.text.trim().isEmpty
                          ? null
                          : _gorseliKaldir,
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text('Gorseli kaldir'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _UrunGorselOnizleme(kaynak: _gorselUrlDenetleyici.text),
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
              final String gorselUrlMetni = _gorselUrlDenetleyici.text.trim();
              final String? gorselUrl = gorselUrlMetni.isEmpty
                  ? null
                  : gorselUrlMetni;
              if (ad.isEmpty || aciklama.isEmpty || fiyat == null) {
                return;
              }
              if (!_gorselBoyutuGecerliMi(gorselUrl)) {
                return;
              }
              Navigator.of(context).pop(
                UrunFormSonucu(
                  kategoriId: _kategoriId,
                  ad: ad,
                  aciklama: aciklama,
                  fiyat: fiyat,
                  gorselUrl: gorselUrl,
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

class _UrunGorselOnizleme extends StatelessWidget {
  const _UrunGorselOnizleme({required this.kaynak});

  final String kaynak;

  @override
  Widget build(BuildContext context) {
    final String temizKaynak = kaynak.trim();
    if (temizKaynak.isEmpty) {
      return _mesajAlani('Henuz gorsel secilmedi.');
    }

    final Uint8List? veriBytes = _veriUriBytesiniCoz(temizKaynak);
    if (veriBytes != null) {
      return _gorselKapsayici(
        child: Image.memory(
          veriBytes,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
                return _mesajAlani('Gorsel yuklenemedi.');
              },
        ),
      );
    }

    final Uri? uri = Uri.tryParse(temizKaynak);
    final bool gecerliAgBaglantisi =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;

    if (!gecerliAgBaglantisi) {
      return _mesajAlani(
        'Gecerli bir http/https baglantisi gir veya dosyadan sec.',
      );
    }

    return _gorselKapsayici(
      child: Image.network(
        temizKaynak,
        fit: BoxFit.cover,
        errorBuilder: (BuildContext context, Object hata, StackTrace? iz) {
          return _mesajAlani('Gorsel yuklenemedi.');
        },
      ),
    );
  }

  Widget _gorselKapsayici({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 130,
        color: const Color(0xFFF8F5FB),
        child: child,
      ),
    );
  }

  Widget _mesajAlani(String metin) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(metin, style: const TextStyle(color: Color(0xFF6D6079))),
    );
  }

  Uint8List? _veriUriBytesiniCoz(String kaynak) {
    if (!kaynak.startsWith('data:image/')) {
      return null;
    }
    final int ayirac = kaynak.indexOf(',');
    if (ayirac <= 0 || ayirac >= kaynak.length - 1) {
      return null;
    }
    final String baslik = kaynak.substring(0, ayirac).toLowerCase();
    if (!baslik.contains(';base64')) {
      return null;
    }
    try {
      return base64Decode(kaynak.substring(ayirac + 1));
    } catch (_) {
      return null;
    }
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

class KuryeSaglayiciFormSonucu {
  const KuryeSaglayiciFormSonucu({
    required this.ad,
    required this.tur,
    required this.apiTabanUrl,
    required this.apiAnahtari,
    required this.aciklama,
    required this.aktifMi,
  });

  final String ad;
  final KuryeTakipSaglayiciTuru tur;
  final String apiTabanUrl;
  final String apiAnahtari;
  final String aciklama;
  final bool aktifMi;
}

class KuryeSaglayiciFormDialog extends StatefulWidget {
  const KuryeSaglayiciFormDialog({super.key, this.baslangicSaglayici});

  final KuryeTakipSaglayiciVarligi? baslangicSaglayici;

  @override
  State<KuryeSaglayiciFormDialog> createState() =>
      _KuryeSaglayiciFormDialogState();
}

class _KuryeSaglayiciFormDialogState extends State<KuryeSaglayiciFormDialog> {
  late final TextEditingController _adDenetleyici;
  late final TextEditingController _apiTabanUrlDenetleyici;
  late final TextEditingController _apiAnahtariDenetleyici;
  late final TextEditingController _aciklamaDenetleyici;
  late KuryeTakipSaglayiciTuru _seciliTur;
  late bool _aktifMi;
  _KuryeSaglayiciSablonu? _sonUygulananSablon;

  @override
  void initState() {
    super.initState();
    _seciliTur =
        widget.baslangicSaglayici?.tur ?? KuryeTakipSaglayiciTuru.ozelApi;
    _aktifMi = widget.baslangicSaglayici?.aktifMi ?? false;
    _adDenetleyici = TextEditingController(
      text: widget.baslangicSaglayici?.ad ?? '',
    );
    _apiTabanUrlDenetleyici = TextEditingController(
      text: widget.baslangicSaglayici?.apiTabanUrl ?? '',
    );
    _apiAnahtariDenetleyici = TextEditingController(
      text: widget.baslangicSaglayici?.apiAnahtari ?? '',
    );
    _aciklamaDenetleyici = TextEditingController(
      text: widget.baslangicSaglayici?.aciklama ?? '',
    );
    if (widget.baslangicSaglayici == null) {
      _sablonuUygula(_seciliTur, zorla: true);
    } else {
      _sonUygulananSablon = _sablonuGetir(_seciliTur);
    }
  }

  @override
  void dispose() {
    _adDenetleyici.dispose();
    _apiTabanUrlDenetleyici.dispose();
    _apiAnahtariDenetleyici.dispose();
    _aciklamaDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuruklenebilirPopupSablonu(
      materialKullan: false,
      child: AlertDialog(
        title: Text(
          widget.baslangicSaglayici == null
              ? 'Kurye saglayicisi ekle'
              : 'Kurye saglayicisini duzenle',
        ),
        content: SizedBox(
          width: 460,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _adDenetleyici,
                  decoration: const InputDecoration(labelText: 'Saglayici adi'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<KuryeTakipSaglayiciTuru>(
                  initialValue: _seciliTur,
                  decoration: const InputDecoration(
                    labelText: 'Saglayici tipi',
                  ),
                  items: KuryeTakipSaglayiciTuru.values
                      .map(
                        (KuryeTakipSaglayiciTuru tur) =>
                            DropdownMenuItem<KuryeTakipSaglayiciTuru>(
                              value: tur,
                              child: Text(tur.etiket),
                            ),
                      )
                      .toList(),
                  onChanged: (KuryeTakipSaglayiciTuru? tur) {
                    if (tur == null) {
                      return;
                    }
                    setState(() {
                      _seciliTur = tur;
                    });
                    _sablonuUygula(tur);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _apiTabanUrlDenetleyici,
                  decoration: const InputDecoration(
                    labelText: 'API taban URL',
                    helperText: 'Saglayici tipine gore URL otomatik onerilir.',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _apiAnahtariDenetleyici,
                  decoration: InputDecoration(
                    labelText: 'API anahtari',
                    hintText: _sablonuGetir(_seciliTur).apiAnahtariOrnegi,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _aciklamaDenetleyici,
                  minLines: 2,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Aciklama'),
                ),
                const SizedBox(height: 6),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Aktif saglayici yap'),
                  value: _aktifMi,
                  onChanged: (bool deger) {
                    setState(() {
                      _aktifMi = deger;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Vazgec'),
          ),
          FilledButton(
            onPressed: () {
              final String ad = _adDenetleyici.text.trim();
              final String apiTabanUrl = _apiTabanUrlDenetleyici.text.trim();
              final String apiAnahtari = _apiAnahtariDenetleyici.text.trim();
              final String aciklama = _aciklamaDenetleyici.text.trim();
              if (ad.isEmpty ||
                  apiTabanUrl.isEmpty ||
                  apiAnahtari.isEmpty ||
                  aciklama.isEmpty) {
                return;
              }
              Navigator.of(context).pop(
                KuryeSaglayiciFormSonucu(
                  ad: ad,
                  tur: _seciliTur,
                  apiTabanUrl: apiTabanUrl,
                  apiAnahtari: apiAnahtari,
                  aciklama: aciklama,
                  aktifMi: _aktifMi,
                ),
              );
            },
            child: Text(widget.baslangicSaglayici == null ? 'Ekle' : 'Kaydet'),
          ),
        ],
      ),
    );
  }

  void _sablonuUygula(KuryeTakipSaglayiciTuru tur, {bool zorla = false}) {
    final _KuryeSaglayiciSablonu sablon = _sablonuGetir(tur);
    if (_alanGuncellenebilirMi(
      mevcut: _adDenetleyici.text,
      oncekiSablonDegeri: _sonUygulananSablon?.ad,
      zorla: zorla,
    )) {
      _adDenetleyici.text = sablon.ad;
    }
    if (_alanGuncellenebilirMi(
      mevcut: _apiTabanUrlDenetleyici.text,
      oncekiSablonDegeri: _sonUygulananSablon?.apiTabanUrl,
      zorla: zorla,
    )) {
      _apiTabanUrlDenetleyici.text = sablon.apiTabanUrl;
    }
    if (_alanGuncellenebilirMi(
      mevcut: _aciklamaDenetleyici.text,
      oncekiSablonDegeri: _sonUygulananSablon?.aciklama,
      zorla: zorla,
    )) {
      _aciklamaDenetleyici.text = sablon.aciklama;
    }
    _sonUygulananSablon = sablon;
  }

  bool _alanGuncellenebilirMi({
    required String mevcut,
    required String? oncekiSablonDegeri,
    required bool zorla,
  }) {
    final String temizMevcut = mevcut.trim();
    if (zorla || temizMevcut.isEmpty) {
      return true;
    }
    if (oncekiSablonDegeri == null) {
      return false;
    }
    return temizMevcut == oncekiSablonDegeri.trim();
  }

  _KuryeSaglayiciSablonu _sablonuGetir(KuryeTakipSaglayiciTuru tur) {
    switch (tur) {
      case KuryeTakipSaglayiciTuru.dahiliGps:
        return const _KuryeSaglayiciSablonu(
          ad: 'Dahili Cihaz GPS',
          apiTabanUrl: 'https://lokal-cihaz-gps',
          apiAnahtariOrnegi: 'cihaz-izinli',
          aciklama: 'Kurye telefonunun dahili GPS akisindan konum alir.',
        );
      case KuryeTakipSaglayiciTuru.traccar:
        return const _KuryeSaglayiciSablonu(
          ad: 'Traccar',
          apiTabanUrl: 'https://api.traccar.ornek',
          apiAnahtariOrnegi: 'traccar-api-key',
          aciklama: 'Traccar tabanli cihaz ve filo konum verisini kullanir.',
        );
      case KuryeTakipSaglayiciTuru.navixy:
        return const _KuryeSaglayiciSablonu(
          ad: 'Navix',
          apiTabanUrl: 'https://api.navix.ornek',
          apiAnahtariOrnegi: 'navix-api-key',
          aciklama: 'Navix entegrasyonu ile kurye cihaz konumlarini alir.',
        );
      case KuryeTakipSaglayiciTuru.ozelApi:
        return const _KuryeSaglayiciSablonu(
          ad: 'Ozel API',
          apiTabanUrl: 'https://api.saglayici.com',
          apiAnahtariOrnegi: 'ozel-api-key',
          aciklama: 'Ozel servis uzerinden kurye konumlari alinir.',
        );
      case KuryeTakipSaglayiciTuru.turkSaglayici1:
        return const _KuryeSaglayiciSablonu(
          ad: 'Arvento',
          apiTabanUrl: 'https://api.arvento.com',
          apiAnahtariOrnegi: 'arvento-api-key',
          aciklama: 'Arvento entegrasyon kaydi.',
        );
      case KuryeTakipSaglayiciTuru.turkSaglayici2:
        return const _KuryeSaglayiciSablonu(
          ad: 'Mobiliz',
          apiTabanUrl: 'https://api.mobiliz.com.tr',
          apiAnahtariOrnegi: 'mobiliz-api-key',
          aciklama: 'Mobiliz entegrasyon kaydi.',
        );
      case KuryeTakipSaglayiciTuru.turkSaglayici3:
        return const _KuryeSaglayiciSablonu(
          ad: 'Seyir Mobil',
          apiTabanUrl: 'https://api.seyirmobil.com',
          apiAnahtariOrnegi: 'seyir-api-key',
          aciklama: 'Seyir Mobil entegrasyon kaydi.',
        );
      case KuryeTakipSaglayiciTuru.turkSaglayici4:
        return const _KuryeSaglayiciSablonu(
          ad: 'Trio Mobil',
          apiTabanUrl: 'https://api.triomobil.com',
          apiAnahtariOrnegi: 'trio-api-key',
          aciklama: 'Trio Mobil entegrasyon kaydi.',
        );
      case KuryeTakipSaglayiciTuru.turkSaglayici5:
        return const _KuryeSaglayiciSablonu(
          ad: 'TakipOn',
          apiTabanUrl: 'https://api.takipon.com',
          apiAnahtariOrnegi: 'takipon-api-key',
          aciklama: 'TakipOn entegrasyon kaydi.',
        );
    }
  }
}

class _KuryeSaglayiciSablonu {
  const _KuryeSaglayiciSablonu({
    required this.ad,
    required this.apiTabanUrl,
    required this.apiAnahtariOrnegi,
    required this.aciklama,
  });

  final String ad;
  final String apiTabanUrl;
  final String apiAnahtariOrnegi;
  final String aciklama;
}

class KuryeCihazEslesmesiFormSonucu {
  const KuryeCihazEslesmesiFormSonucu({
    required this.kuryeAdi,
    required this.saglayiciId,
    required this.cihazKimligi,
    required this.aktifMi,
  });

  final String kuryeAdi;
  final String saglayiciId;
  final String cihazKimligi;
  final bool aktifMi;
}

class KuryeCihazEslesmesiFormDialog extends StatefulWidget {
  const KuryeCihazEslesmesiFormDialog({
    super.key,
    required this.saglayicilar,
    this.baslangicEslesmesi,
  });

  final List<KuryeTakipSaglayiciVarligi> saglayicilar;
  final KuryeCihazEslesmesiVarligi? baslangicEslesmesi;

  @override
  State<KuryeCihazEslesmesiFormDialog> createState() =>
      _KuryeCihazEslesmesiFormDialogState();
}

class _KuryeCihazEslesmesiFormDialogState
    extends State<KuryeCihazEslesmesiFormDialog> {
  late final TextEditingController _kuryeAdiDenetleyici;
  late final TextEditingController _cihazKimligiDenetleyici;
  late String _seciliSaglayiciId;
  late bool _aktifMi;

  @override
  void initState() {
    super.initState();
    _seciliSaglayiciId =
        widget.baslangicEslesmesi?.saglayiciId ?? widget.saglayicilar.first.id;
    _aktifMi = widget.baslangicEslesmesi?.aktifMi ?? true;
    _kuryeAdiDenetleyici = TextEditingController(
      text: widget.baslangicEslesmesi?.kuryeAdi ?? '',
    );
    _cihazKimligiDenetleyici = TextEditingController(
      text: widget.baslangicEslesmesi?.cihazKimligi ?? '',
    );
  }

  @override
  void dispose() {
    _kuryeAdiDenetleyici.dispose();
    _cihazKimligiDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuruklenebilirPopupSablonu(
      materialKullan: false,
      child: AlertDialog(
        title: Text(
          widget.baslangicEslesmesi == null
              ? 'Kurye cihaz eslesmesi ekle'
              : 'Kurye cihaz eslesmesini duzenle',
        ),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _kuryeAdiDenetleyici,
                  decoration: const InputDecoration(labelText: 'Kurye adi'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _seciliSaglayiciId,
                  decoration: const InputDecoration(labelText: 'Saglayici'),
                  items: widget.saglayicilar
                      .map(
                        (KuryeTakipSaglayiciVarligi saglayici) =>
                            DropdownMenuItem<String>(
                              value: saglayici.id,
                              child: Text(
                                '${saglayici.ad} (${saglayici.tur.etiket})',
                              ),
                            ),
                      )
                      .toList(),
                  onChanged: (String? deger) {
                    if (deger == null) {
                      return;
                    }
                    setState(() {
                      _seciliSaglayiciId = deger;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _cihazKimligiDenetleyici,
                  decoration: const InputDecoration(
                    labelText: 'Cihaz kimligi / IMEI',
                  ),
                ),
                const SizedBox(height: 6),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Eslesme aktif'),
                  value: _aktifMi,
                  onChanged: (bool deger) {
                    setState(() {
                      _aktifMi = deger;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Vazgec'),
          ),
          FilledButton(
            onPressed: () {
              final String kuryeAdi = _kuryeAdiDenetleyici.text.trim();
              final String cihazKimligi = _cihazKimligiDenetleyici.text.trim();
              if (kuryeAdi.isEmpty || cihazKimligi.isEmpty) {
                return;
              }
              Navigator.of(context).pop(
                KuryeCihazEslesmesiFormSonucu(
                  kuryeAdi: kuryeAdi,
                  saglayiciId: _seciliSaglayiciId,
                  cihazKimligi: cihazKimligi,
                  aktifMi: _aktifMi,
                ),
              );
            },
            child: Text(widget.baslangicEslesmesi == null ? 'Ekle' : 'Kaydet'),
          ),
        ],
      ),
    );
  }
}
