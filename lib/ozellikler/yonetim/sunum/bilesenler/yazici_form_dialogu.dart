import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bilesenler/suruklenebilir_dialog_kapsayici.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/sistem_yazici_adayi_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';

class YaziciFormSonucu {
  const YaziciFormSonucu({
    required this.ad,
    required this.rolEtiketi,
    required this.baglantiNoktasi,
    required this.aciklama,
    required this.durum,
  });

  final String ad;
  final String rolEtiketi;
  final String baglantiNoktasi;
  final String aciklama;
  final YaziciBaglantiDurumu durum;
}

class YaziciFormDialog extends StatefulWidget {
  const YaziciFormDialog({super.key, required this.sistemYazicilari});

  final List<SistemYaziciAdayiVarligi> sistemYazicilari;

  @override
  State<YaziciFormDialog> createState() => _YaziciFormDialogState();
}

class _YaziciFormDialogState extends State<YaziciFormDialog> {
  late final TextEditingController _adDenetleyici;
  late final TextEditingController _baglantiDenetleyici;
  late final TextEditingController _aciklamaDenetleyici;
  SistemYaziciAdayiVarligi? _seciliAday;
  String _rolEtiketi = 'Kasa';
  YaziciBaglantiDurumu _durum = YaziciBaglantiDurumu.bagli;

  @override
  void initState() {
    super.initState();
    _adDenetleyici = TextEditingController();
    _baglantiDenetleyici = TextEditingController();
    _aciklamaDenetleyici = TextEditingController(
      text: 'Yeni yazici yonetim panelinden eklendi.',
    );

    if (widget.sistemYazicilari.isNotEmpty) {
      _seciliAday = widget.sistemYazicilari.first;
      _adDenetleyici.text = _seciliAday!.ad;
      _baglantiDenetleyici.text = _seciliAday!.baglantiNoktasi;
    }
  }

  @override
  void dispose() {
    _adDenetleyici.dispose();
    _baglantiDenetleyici.dispose();
    _aciklamaDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuruklenebilirPopupSablonu(
      materialKullan: false,
      child: AlertDialog(
        title: const Text('Yazici ekle'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.sistemYazicilari.isNotEmpty)
                  DropdownButtonFormField<SistemYaziciAdayiVarligi>(
                    initialValue: _seciliAday,
                    decoration: const InputDecoration(
                      labelText: 'Sistem yazicisi',
                    ),
                    items: widget.sistemYazicilari
                        .map(
                          (aday) => DropdownMenuItem<SistemYaziciAdayiVarligi>(
                            value: aday,
                            child: Text('${aday.ad} - ${aday.baglantiNoktasi}'),
                          ),
                        )
                        .toList(),
                    onChanged: (aday) {
                      setState(() {
                        _seciliAday = aday;
                        if (aday != null) {
                          _adDenetleyici.text = aday.ad;
                          _baglantiDenetleyici.text = aday.baglantiNoktasi;
                        }
                      });
                    },
                  ),
                if (widget.sistemYazicilari.isNotEmpty)
                  const SizedBox(height: 12),
                TextField(
                  controller: _adDenetleyici,
                  decoration: const InputDecoration(labelText: 'Yazici adi'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _baglantiDenetleyici,
                  decoration: const InputDecoration(
                    labelText: 'Baglanti noktasi',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _rolEtiketi,
                  decoration: const InputDecoration(labelText: 'Rol'),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'Mutfak',
                      child: Text('Mutfak'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Icecek',
                      child: Text('Icecek'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Kasa',
                      child: Text('Kasa'),
                    ),
                  ],
                  onChanged: (deger) {
                    if (deger != null) {
                      setState(() {
                        _rolEtiketi = deger;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<YaziciBaglantiDurumu>(
                  initialValue: _durum,
                  decoration: const InputDecoration(labelText: 'Durum'),
                  items: const [
                    DropdownMenuItem<YaziciBaglantiDurumu>(
                      value: YaziciBaglantiDurumu.bagli,
                      child: Text('Bagli'),
                    ),
                    DropdownMenuItem<YaziciBaglantiDurumu>(
                      value: YaziciBaglantiDurumu.dikkat,
                      child: Text('Dikkat'),
                    ),
                    DropdownMenuItem<YaziciBaglantiDurumu>(
                      value: YaziciBaglantiDurumu.kapali,
                      child: Text('Kapali'),
                    ),
                  ],
                  onChanged: (deger) {
                    if (deger != null) {
                      setState(() {
                        _durum = deger;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _aciklamaDenetleyici,
                  minLines: 2,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Aciklama'),
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
              final String baglanti = _baglantiDenetleyici.text.trim();
              final String aciklama = _aciklamaDenetleyici.text.trim();
              if (ad.isEmpty || baglanti.isEmpty || aciklama.isEmpty) {
                return;
              }

              Navigator.of(context).pop(
                YaziciFormSonucu(
                  ad: ad,
                  rolEtiketi: _rolEtiketi,
                  baglantiNoktasi: baglanti,
                  aciklama: aciklama,
                  durum: _durum,
                ),
              );
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}
