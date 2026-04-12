import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/tema/ana_sayfa_renk_sablonu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/viewmodel/online_siparis_kanali_viewmodel.dart';

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

class OnlineSiparisKanaliSayfasi extends StatefulWidget {
  const OnlineSiparisKanaliSayfasi({super.key, required this.viewModel});

  final OnlineSiparisKanaliViewModel viewModel;

  @override
  State<OnlineSiparisKanaliSayfasi> createState() =>
      _OnlineSiparisKanaliSayfasiState();
}

class _OnlineSiparisKanaliSayfasiState
    extends State<OnlineSiparisKanaliSayfasi> {
  @override
  void initState() {
    super.initState();
    _yukle();
  }

  @override
  void didUpdateWidget(covariant OnlineSiparisKanaliSayfasi oldWidget) {
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
    final OnlineSiparisKanaliIslemSonucu sonuc = await widget.viewModel.yukle();
    if (!mounted || sonuc.basarili) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  Future<void> _durumIlerle(SiparisVarligi siparis) async {
    final OnlineSiparisKanaliIslemSonucu sonuc = await widget.viewModel
        .durumIlerle(siparis);
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
        final List<SiparisVarligi> siparisler =
            widget.viewModel.filtrelenmisSiparisler;
        return Scaffold(
          backgroundColor: _arkaPlanKoyu,
          appBar: AppBar(
            title: const Text('Online Siparis Kanali'),
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
              ),
            ],
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
                : SafeArea(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: <Widget>[
                        _OzetKutulari(viewModel: widget.viewModel),
                        if (widget
                            .viewModel
                            .yogunlukModuOnerisiVar) ...<Widget>[
                          const SizedBox(height: 12),
                          _YogunlukUyariKarti(
                            mesaj: widget.viewModel.yogunlukMesaji,
                          ),
                        ],
                        const SizedBox(height: 12),
                        _KanalFiltreleri(viewModel: widget.viewModel),
                        const SizedBox(height: 12),
                        _DurumFiltreleri(viewModel: widget.viewModel),
                        const SizedBox(height: 14),
                        if (siparisler.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _panelKoyu,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _cerceve),
                            ),
                            child: const Text(
                              'Secili filtreye uygun online siparis bulunamadi.',
                              style: TextStyle(
                                color: _metinIkincil,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ...siparisler.map(
                          (SiparisVarligi siparis) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _OnlineSiparisKarti(
                              siparis: siparis,
                              viewModel: widget.viewModel,
                              durumIlerle: () => _durumIlerle(siparis),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _OzetKutulari extends StatelessWidget {
  const _OzetKutulari({required this.viewModel});

  final OnlineSiparisKanaliViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: <Widget>[
        _KisaOzetKarti(
          baslik: 'Toplam online',
          deger: '${viewModel.toplamOnlineSiparisSayisi}',
          aciklama: 'siparis',
          vurgu: _metinAna,
        ),
        _KisaOzetKarti(
          baslik: 'Aktif',
          deger: '${viewModel.aktifOnlineSiparisSayisi}',
          aciklama: 'islemde',
          vurgu: _basari,
        ),
        _KisaOzetKarti(
          baslik: 'Online ciro',
          deger: _paraYaz(viewModel.toplamOnlineCiro),
          aciklama: 'toplam',
          vurgu: _uyari,
        ),
      ],
    );
  }
}

class _KisaOzetKarti extends StatelessWidget {
  const _KisaOzetKarti({
    required this.baslik,
    required this.deger,
    required this.aciklama,
    required this.vurgu,
  });

  final String baslik;
  final String deger;
  final String aciklama;
  final Color vurgu;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[_panelYuksek, _panelKoyu],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cerceve),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            baslik,
            style: const TextStyle(
              color: _metinIkincil,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            deger,
            style: TextStyle(
              color: vurgu,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(aciklama, style: const TextStyle(color: _metinIkincil)),
        ],
      ),
    );
  }
}

class _YogunlukUyariKarti extends StatelessWidget {
  const _YogunlukUyariKarti({required this.mesaj});

  final String mesaj;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _uyari.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _uyari.withValues(alpha: 0.40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.warning_amber_rounded, color: _uyari),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              mesaj,
              style: const TextStyle(
                color: _metinAna,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KanalFiltreleri extends StatelessWidget {
  const _KanalFiltreleri({required this.viewModel});

  final OnlineSiparisKanaliViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _panelKoyu.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cerceve),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: viewModel.kanalFiltreleri.map((String kanal) {
          return ChoiceChip(
            label: Text(kanal),
            selected: viewModel.seciliKanal == kanal,
            onSelected: (_) => viewModel.kanalSec(kanal),
          );
        }).toList(),
      ),
    );
  }
}

class _DurumFiltreleri extends StatelessWidget {
  const _DurumFiltreleri({required this.viewModel});

  final OnlineSiparisKanaliViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _panelKoyu.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cerceve),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: OnlineSiparisDurumFiltresi.values.map((
          OnlineSiparisDurumFiltresi filtre,
        ) {
          return ChoiceChip(
            label: Text(filtre.etiket),
            selected: viewModel.seciliDurumFiltresi == filtre,
            onSelected: (_) => viewModel.durumFiltresiSec(filtre),
          );
        }).toList(),
      ),
    );
  }
}

class _OnlineSiparisKarti extends StatelessWidget {
  const _OnlineSiparisKarti({
    required this.siparis,
    required this.viewModel,
    required this.durumIlerle,
  });

  final SiparisVarligi siparis;
  final OnlineSiparisKanaliViewModel viewModel;
  final VoidCallback durumIlerle;

  @override
  Widget build(BuildContext context) {
    final String kanal = viewModel.kanalEtiketi(siparis);
    final String durum = viewModel.durumEtiketi(siparis.durum);
    final String? aksiyon = viewModel.aksiyonEtiketi(siparis);
    final int dakika = DateTime.now()
        .difference(siparis.olusturmaTarihi)
        .inMinutes;
    final String musteri = siparis.sahip.misafirBilgisi?.adSoyad ?? 'Misafir';
    final String konum = siparis.adresMetni ?? siparis.masaNo ?? 'Belirtilmedi';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _panelKoyu.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cerceve),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  siparis.siparisNo,
                  style: const TextStyle(
                    color: _metinAna,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _ikincil.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  kanal,
                  style: const TextStyle(
                    color: _metinAna,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$musteri - $konum',
            style: const TextStyle(
              color: _metinIkincil,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Durum: $durum - Bekleme: $dakika dk',
            style: const TextStyle(color: _metinIkincil),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Text(
                _paraYaz(siparis.toplamTutar),
                style: const TextStyle(
                  color: _uyari,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              if (aksiyon != null)
                FilledButton(
                  onPressed: viewModel.durumIlerletmeYetkisiVar
                      ? durumIlerle
                      : null,
                  child: Text(aksiyon),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

String _paraYaz(double tutar) =>
    '${tutar.toStringAsFixed(2).replaceAll('.', ',')} TL';
