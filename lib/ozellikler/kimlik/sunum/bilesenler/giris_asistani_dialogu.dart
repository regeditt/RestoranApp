import 'package:flutter/material.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/asistan_mesaji_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/viewmodel/giris_asistani_viewmodel.dart';

class GirisAsistaniDialog extends StatefulWidget {
  const GirisAsistaniDialog({super.key, required this.viewModel});

  final GirisAsistaniViewModel viewModel;

  @override
  State<GirisAsistaniDialog> createState() => _GirisAsistaniDialogState();
}

class _GirisAsistaniDialogState extends State<GirisAsistaniDialog> {
  final TextEditingController _mesajDenetleyici = TextEditingController();

  @override
  void dispose() {
    _mesajDenetleyici.dispose();
    widget.viewModel.dispose();
    super.dispose();
  }

  Future<void> _mesajGonder() async {
    final String mesaj = _mesajDenetleyici.text.trim();
    if (mesaj.isEmpty) {
      return;
    }
    await widget.viewModel.mesajGonder(mesaj);
    _mesajDenetleyici.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (BuildContext context, Widget? child) {
        final ThemeData tema = Theme.of(context);
        final bool yanitBekleniyor = widget.viewModel.yanitBekleniyor;
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.smart_toy_rounded),
              SizedBox(width: 8),
              Text('Ayar Chatbot'),
            ],
          ),
          content: SizedBox(
            width: 560,
            height: 460,
            child: Column(
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.viewModel.hizliSoruEtiketleri
                      .map(
                        (String etiket) => _HizliSoruCipi(
                          etiket: etiket,
                          tikla: yanitBekleniyor
                              ? null
                              : () => widget.viewModel.hizliSoruSec(etiket),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                if (yanitBekleniyor) ...[
                  const LinearProgressIndicator(minHeight: 3),
                  const SizedBox(height: 8),
                ],
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: widget.viewModel.mesajlar.length,
                      itemBuilder: (BuildContext context, int index) {
                        final AsistanMesajiVarligi mesaj =
                            widget.viewModel.mesajlar[index];
                        final bool kullaniciMesajiMi =
                            mesaj.gonderen == AsistanMesajiGondereni.kullanici;
                        final Color balonRengi = kullaniciMesajiMi
                            ? tema.colorScheme.primary
                            : Colors.white;
                        final Color metinRengi = kullaniciMesajiMi
                            ? Colors.white
                            : const Color(0xFF1F2330);

                        return Align(
                          alignment: kullaniciMesajiMi
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            constraints: const BoxConstraints(maxWidth: 380),
                            decoration: BoxDecoration(
                              color: balonRengi,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE5E8F1),
                                width: kullaniciMesajiMi ? 0 : 1,
                              ),
                            ),
                            child: Text(
                              mesaj.metin,
                              style: tema.textTheme.bodyMedium?.copyWith(
                                color: metinRengi,
                                height: 1.35,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _mesajDenetleyici,
                        enabled: !yanitBekleniyor,
                        onSubmitted: (_) {
                          if (!yanitBekleniyor) {
                            _mesajGonder();
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Sorunu yaz...',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: yanitBekleniyor ? null : _mesajGonder,
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('Gonder'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }
}

class _HizliSoruCipi extends StatelessWidget {
  const _HizliSoruCipi({required this.etiket, required this.tikla});

  final String etiket;
  final VoidCallback? tikla;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.flash_on_rounded, size: 16),
      label: Text(etiket),
      onPressed: tikla,
    );
  }
}
