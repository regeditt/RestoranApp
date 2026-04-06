import 'package:flutter/material.dart';
import 'package:restoran_app/ozellikler/lisans/uygulama/use_case/lisans_aktif_et_use_case.dart';
import 'package:restoran_app/ozellikler/lisans/sunum/viewmodel/lisans_aktivasyon_viewmodel.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ortak/tema/restoran_tema_uzantilari.dart';

class LisansAktivasyonSayfasi extends StatefulWidget {
  const LisansAktivasyonSayfasi({super.key, required this.viewModel});

  final LisansAktivasyonViewModel viewModel;

  @override
  State<LisansAktivasyonSayfasi> createState() =>
      _LisansAktivasyonSayfasiState();
}

class _LisansAktivasyonSayfasiState extends State<LisansAktivasyonSayfasi> {
  final TextEditingController _anahtarDenetleyici = TextEditingController();
  String _mesaj = '';

  @override
  void dispose() {
    _anahtarDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RestoranTemaRenkleri tema = context.restoranTema;
    final ThemeData temaVerisi = Theme.of(context);

    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        return Scaffold(
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  tema.anaArkaPlan,
                  tema.anaArkaPlanIkincil,
                  tema.anaArkaPlanUcuncul,
                ],
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 540),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: tema.popupYuzey,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: tema.inceKenar),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: widget.viewModel.yukleniyor
                          ? const SizedBox(
                              height: 220,
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lisans Korumasi',
                                  style: temaVerisi.textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${UygulamaSabitleri.uygulamaAdi} kilitli. Devam etmek icin gecerli lisans anahtari girin.',
                                  style: temaVerisi.textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 14),
                                _DurumSatiri(
                                  mesaj: _mesaj.isEmpty
                                      ? widget.viewModel.durum.mesaj
                                      : _mesaj,
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _anahtarDenetleyici,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  enabled: !widget.viewModel.islemde,
                                  decoration: const InputDecoration(
                                    labelText: 'Lisans anahtari',
                                    hintText: 'RST-YYYYMMDD-XXXXXX',
                                  ),
                                ),
                                const SizedBox(height: 14),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: widget.viewModel.islemde
                                        ? null
                                        : _aktifEt,
                                    icon: const Icon(Icons.lock_open_rounded),
                                    label: Text(
                                      widget.viewModel.islemde
                                          ? 'Dogrulaniyor...'
                                          : 'Lisansi aktif et',
                                    ),
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

  Future<void> _aktifEt() async {
    final LisansAktifEtSonucu sonuc = await widget.viewModel.lisansAktifEt(
      _anahtarDenetleyici.text,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _mesaj = sonuc.mesaj;
    });
  }
}

class _DurumSatiri extends StatelessWidget {
  const _DurumSatiri({required this.mesaj});

  final String mesaj;

  @override
  Widget build(BuildContext context) {
    final RestoranTemaRenkleri tema = context.restoranTema;
    final ThemeData temaVerisi = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: tema.kartYuzey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        mesaj,
        style: temaVerisi.textTheme.bodyMedium?.copyWith(
          color: tema.metinBirincilKoyu,
        ),
      ),
    );
  }
}
