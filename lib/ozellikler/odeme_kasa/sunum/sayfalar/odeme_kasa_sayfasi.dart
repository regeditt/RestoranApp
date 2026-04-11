import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bilesenler/suruklenebilir_dialog_kapsayici.dart';
import 'package:restoran_app/ortak/tema/ana_sayfa_renk_sablonu.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/alan/enumlar/odeme_yontemi.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/alan/varliklar/kasa_hareketi_varligi.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/alan/varliklar/kasa_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/alan/varliklar/siparis_ciro_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/odeme_kasa/sunum/viewmodel/odeme_kasa_viewmodel.dart';

const Color _arkaPlanKoyu = AnaSayfaRenkSablonu.arkaPlanKoyu;
const Color _arkaPlanOrta = AnaSayfaRenkSablonu.arkaPlanOrta;
const Color _arkaPlanUst = AnaSayfaRenkSablonu.arkaPlanUst;
const Color _panelKoyu = AnaSayfaRenkSablonu.panelKoyu;
const Color _panelYuksek = AnaSayfaRenkSablonu.panelYuksek;
const Color _metinAna = AnaSayfaRenkSablonu.metinAna;
const Color _metinIkincil = AnaSayfaRenkSablonu.metinIkincil;
const Color _cerceve = AnaSayfaRenkSablonu.cerceve;
const Color _birincil = AnaSayfaRenkSablonu.birincilAksiyon;
const Color _ikincil = AnaSayfaRenkSablonu.ikincilAksiyon;
const Color _basari = AnaSayfaRenkSablonu.basari;
const Color _uyari = AnaSayfaRenkSablonu.uyari;

class OdemeKasaSayfasi extends StatefulWidget {
  const OdemeKasaSayfasi({super.key, required this.viewModel});

  final OdemeKasaViewModel viewModel;

  @override
  State<OdemeKasaSayfasi> createState() => _OdemeKasaSayfasiState();
}

class _OdemeKasaSayfasiState extends State<OdemeKasaSayfasi> {
  @override
  void initState() {
    super.initState();
    _yukle();
  }

  @override
  void didUpdateWidget(covariant OdemeKasaSayfasi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      oldWidget.viewModel.dispose();
      _yukle();
    }
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  Future<void> _yukle() async {
    final OdemeKasaIslemSonucu sonuc = await widget.viewModel.yukle();
    if (!mounted || sonuc.basarili) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  Future<void> _bugunFiltrele() async {
    final OdemeKasaIslemSonucu sonuc = await widget.viewModel.bugunFiltrele();
    if (!mounted || sonuc.basarili) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  Future<void> _sonYediGunFiltrele() async {
    final OdemeKasaIslemSonucu sonuc = await widget.viewModel
        .sonYediGunFiltrele();
    if (!mounted || sonuc.basarili) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  Future<void> _hareketEkleDialogunuAc() async {
    final KasaHareketiEkleGirdisi? girdi =
        await showDialog<KasaHareketiEkleGirdisi>(
          context: context,
          builder: (BuildContext context) => const _KasaHareketiFormDialog(),
        );
    if (girdi == null) {
      return;
    }
    final OdemeKasaIslemSonucu sonuc = await widget.viewModel.hareketEkle(
      girdi,
    );
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (BuildContext context, Widget? child) {
        final KasaOzetiVarligi? ozet = widget.viewModel.kasaOzeti;
        final SiparisCiroOzetiVarligi siparisCiroOzeti =
            widget.viewModel.siparisCiroOzeti;
        return Scaffold(
          backgroundColor: _arkaPlanKoyu,
          appBar: AppBar(
            title: const Text('Odeme ve Kasa'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[_birincil, _ikincil, _arkaPlanKoyu],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: _yukle,
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Yenile',
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _hareketEkleDialogunuAc,
            icon: const Icon(Icons.add_card_rounded),
            label: const Text('Hareket ekle'),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[_arkaPlanUst, _arkaPlanOrta, _arkaPlanKoyu],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: widget.viewModel.yukleniyor
                ? const Center(child: CircularProgressIndicator())
                : ozet == null
                ? const Center(
                    child: Text(
                      'Kasa ozeti bulunamadi.',
                      style: TextStyle(color: _metinAna),
                    ),
                  )
                : SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: <Widget>[
                              FilledButton.icon(
                                onPressed: _bugunFiltrele,
                                icon: const Icon(Icons.today_rounded),
                                label: const Text('Bugun'),
                              ),
                              FilledButton.tonalIcon(
                                onPressed: _sonYediGunFiltrele,
                                icon: const Icon(Icons.date_range_rounded),
                                label: const Text('Son 7 gun'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _GenelBakiyeKarti(
                            ozet: ozet,
                            siparisCiroOzeti: siparisCiroOzeti,
                          ),
                          const SizedBox(height: 14),
                          LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints c) {
                              final bool dar = c.maxWidth < 900;
                              return GridView.count(
                                crossAxisCount: dar ? 2 : 4,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: dar ? 1.35 : 1.7,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  _OdemeYontemiKarti(
                                    yontem: OdemeYontemi.nakit,
                                    tutar: ozet.nakitToplam,
                                  ),
                                  _OdemeYontemiKarti(
                                    yontem: OdemeYontemi.kart,
                                    tutar: ozet.kartToplam,
                                  ),
                                  _OdemeYontemiKarti(
                                    yontem: OdemeYontemi.temassiz,
                                    tutar: ozet.temassizToplam,
                                  ),
                                  _OdemeYontemiKarti(
                                    yontem: OdemeYontemi.online,
                                    tutar: ozet.onlineToplam,
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Son kasa hareketleri',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: _metinAna,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 10),
                          _KasaHareketListesi(hareketler: ozet.sonHareketler),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _GenelBakiyeKarti extends StatelessWidget {
  const _GenelBakiyeKarti({required this.ozet, required this.siparisCiroOzeti});

  final KasaOzetiVarligi ozet;
  final SiparisCiroOzetiVarligi siparisCiroOzeti;

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[_panelYuksek, _panelKoyu],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cerceve),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: <Widget>[
          _KisaOzetKutusu(
            baslik: 'Tahsilat',
            deger: _paraYaz(ozet.toplamTahsilat),
            vurgu: _basari,
          ),
          _KisaOzetKutusu(
            baslik: 'Iade',
            deger: _paraYaz(ozet.toplamIade),
            vurgu: _uyari,
          ),
          _KisaOzetKutusu(
            baslik: 'Kasa bakiye',
            deger: _paraYaz(ozet.kasaBakiye),
            vurgu: _metinAna,
          ),
          _KisaOzetKutusu(
            baslik: 'Siparis brut',
            deger: _paraYaz(siparisCiroOzeti.brutCiro),
            vurgu: _metinAna,
          ),
          _KisaOzetKutusu(
            baslik: 'Kampanya indirimi',
            deger: _paraYaz(siparisCiroOzeti.indirimToplami),
            vurgu: _uyari,
          ),
          _KisaOzetKutusu(
            baslik: 'Siparis net',
            deger: _paraYaz(siparisCiroOzeti.netCiro),
            vurgu: _basari,
          ),
          _KisaOzetKutusu(
            baslik: 'Siparis adedi',
            deger: '${siparisCiroOzeti.siparisAdedi}',
            vurgu: _metinAna,
          ),
          Text(
            'Filtre: ${_tarihYaz(DateTime.now())}',
            style: tema.textTheme.bodyMedium?.copyWith(color: _metinIkincil),
          ),
        ],
      ),
    );
  }
}

class _KisaOzetKutusu extends StatelessWidget {
  const _KisaOzetKutusu({
    required this.baslik,
    required this.deger,
    required this.vurgu,
  });

  final String baslik;
  final String deger;
  final Color vurgu;

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _arkaPlanKoyu.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cerceve),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            baslik,
            style: tema.textTheme.labelLarge?.copyWith(color: _metinIkincil),
          ),
          const SizedBox(height: 4),
          Text(
            deger,
            style: tema.textTheme.titleLarge?.copyWith(
              color: vurgu,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _OdemeYontemiKarti extends StatelessWidget {
  const _OdemeYontemiKarti({required this.yontem, required this.tutar});

  final OdemeYontemi yontem;
  final double tutar;

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _panelKoyu.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cerceve),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(_ikon(yontem), color: _metinAna),
          const Spacer(),
          Text(
            yontem.etiket,
            style: tema.textTheme.titleMedium?.copyWith(
              color: _metinAna,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _paraYaz(tutar),
            style: tema.textTheme.titleLarge?.copyWith(
              color: _metinIkincil,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  IconData _ikon(OdemeYontemi yontem) {
    switch (yontem) {
      case OdemeYontemi.nakit:
        return Icons.payments_rounded;
      case OdemeYontemi.kart:
        return Icons.credit_card_rounded;
      case OdemeYontemi.temassiz:
        return Icons.contactless_rounded;
      case OdemeYontemi.online:
        return Icons.language_rounded;
    }
  }
}

class _KasaHareketListesi extends StatelessWidget {
  const _KasaHareketListesi({required this.hareketler});

  final List<KasaHareketiVarligi> hareketler;

  @override
  Widget build(BuildContext context) {
    if (hareketler.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _panelKoyu,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cerceve),
        ),
        child: const Text(
          'Secili tarihte kasa hareketi yok.',
          style: TextStyle(color: _metinIkincil),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: _panelKoyu.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cerceve),
      ),
      child: ListView.separated(
        itemCount: hareketler.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, _) =>
            Divider(height: 1, color: _metinIkincil.withValues(alpha: 0.15)),
        itemBuilder: (BuildContext context, int index) {
          final KasaHareketiVarligi hareket = hareketler[index];
          final Color vurgu = hareket.tahsilatMi ? _basari : _uyari;
          final String onEk = hareket.tahsilatMi ? '+' : '-';
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            leading: CircleAvatar(
              backgroundColor: vurgu.withValues(alpha: 0.18),
              child: Icon(
                hareket.tahsilatMi
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: vurgu,
              ),
            ),
            title: Text(
              hareket.baslik,
              style: const TextStyle(
                color: _metinAna,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              '${hareket.detay} - ${_saatYaz(hareket.zaman)} - ${hareket.odemeYontemi.etiket}',
              style: const TextStyle(color: _metinIkincil),
            ),
            trailing: Text(
              '$onEk${_paraYaz(hareket.tutar)}',
              style: TextStyle(color: vurgu, fontWeight: FontWeight.w800),
            ),
          );
        },
      ),
    );
  }
}

class _KasaHareketiFormDialog extends StatefulWidget {
  const _KasaHareketiFormDialog();

  @override
  State<_KasaHareketiFormDialog> createState() =>
      _KasaHareketiFormDialogState();
}

class _KasaHareketiFormDialogState extends State<_KasaHareketiFormDialog> {
  late final TextEditingController _baslikDenetleyici;
  late final TextEditingController _detayDenetleyici;
  late final TextEditingController _tutarDenetleyici;
  OdemeYontemi _odemeYontemi = OdemeYontemi.kart;
  bool _tahsilatMi = true;
  int _parcaSayisi = 1;

  @override
  void initState() {
    super.initState();
    _baslikDenetleyici = TextEditingController(text: 'Salon odemesi');
    _detayDenetleyici = TextEditingController(text: 'Masa');
    _tutarDenetleyici = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _baslikDenetleyici.dispose();
    _detayDenetleyici.dispose();
    _tutarDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuruklenebilirPopupSablonu(
      materialKullan: false,
      child: AlertDialog(
        title: const Text('Kasa hareketi ekle'),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _baslikDenetleyici,
                  decoration: const InputDecoration(labelText: 'Baslik'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _detayDenetleyici,
                  decoration: const InputDecoration(labelText: 'Detay'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _tutarDenetleyici,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Tutar'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<OdemeYontemi>(
                  initialValue: _odemeYontemi,
                  decoration: const InputDecoration(labelText: 'Odeme yontemi'),
                  items: OdemeYontemi.values
                      .map(
                        (yontem) => DropdownMenuItem<OdemeYontemi>(
                          value: yontem,
                          child: Text(yontem.etiket),
                        ),
                      )
                      .toList(),
                  onChanged: (OdemeYontemi? deger) {
                    if (deger == null) {
                      return;
                    }
                    setState(() {
                      _odemeYontemi = deger;
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  initialValue: _parcaSayisi,
                  decoration: const InputDecoration(
                    labelText: 'Parcali odeme adedi',
                  ),
                  items: const <DropdownMenuItem<int>>[
                    DropdownMenuItem<int>(value: 1, child: Text('Tek cekim')),
                    DropdownMenuItem<int>(value: 2, child: Text('2 parca')),
                    DropdownMenuItem<int>(value: 3, child: Text('3 parca')),
                    DropdownMenuItem<int>(value: 4, child: Text('4 parca')),
                  ],
                  onChanged: (int? deger) {
                    if (deger == null) {
                      return;
                    }
                    setState(() {
                      _parcaSayisi = deger;
                    });
                  },
                ),
                const SizedBox(height: 8),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Tahsilat'),
                  subtitle: Text(_tahsilatMi ? 'Tahsilat' : 'Iade/Gider'),
                  value: _tahsilatMi,
                  onChanged: (bool deger) {
                    setState(() {
                      _tahsilatMi = deger;
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
          FilledButton(onPressed: _kaydet, child: const Text('Ekle')),
        ],
      ),
    );
  }

  void _kaydet() {
    final String baslik = _baslikDenetleyici.text.trim();
    final String detay = _detayDenetleyici.text.trim();
    final double? tutar = double.tryParse(
      _tutarDenetleyici.text.trim().replaceAll(',', '.'),
    );
    if (baslik.isEmpty || detay.isEmpty || tutar == null || tutar <= 0) {
      return;
    }
    Navigator.of(context).pop(
      KasaHareketiEkleGirdisi(
        baslik: baslik,
        detay: detay,
        tutar: tutar,
        odemeYontemi: _odemeYontemi,
        tahsilatMi: _tahsilatMi,
        parcaSayisi: _parcaSayisi,
      ),
    );
  }
}

String _paraYaz(double tutar) =>
    '${tutar.toStringAsFixed(2).replaceAll('.', ',')} TL';

String _saatYaz(DateTime tarih) =>
    '${tarih.hour.toString().padLeft(2, '0')}:${tarih.minute.toString().padLeft(2, '0')}';

String _tarihYaz(DateTime tarih) =>
    '${tarih.day.toString().padLeft(2, '0')}.${tarih.month.toString().padLeft(2, '0')}.${tarih.year}';
