import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bilesenler/kvkk_aydinlatma_dialogu.dart';
import 'package:restoran_app/ortak/bilesenler/suruklenebilir_dialog_kapsayici.dart';
import 'package:restoran_app/ortak/tema/ana_sayfa_renk_sablonu.dart';
import 'package:restoran_app/ozellikler/rezervasyon/alan/enumlar/rezervasyon_durumu.dart';
import 'package:restoran_app/ozellikler/rezervasyon/alan/varliklar/rezervasyon_varligi.dart';
import 'package:restoran_app/ozellikler/rezervasyon/sunum/viewmodel/rezervasyon_viewmodel.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

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

class RezervasyonSayfasi extends StatefulWidget {
  const RezervasyonSayfasi({super.key, required this.viewModel});

  final RezervasyonViewModel viewModel;

  @override
  State<RezervasyonSayfasi> createState() => _RezervasyonSayfasiState();
}

class _RezervasyonSayfasiState extends State<RezervasyonSayfasi> {
  @override
  void initState() {
    super.initState();
    _yukle();
  }

  @override
  void didUpdateWidget(covariant RezervasyonSayfasi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel == widget.viewModel) {
      return;
    }
    oldWidget.viewModel.dispose();
    _yukle();
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  Future<void> _yukle() async {
    final RezervasyonIslemSonucu sonuc = await widget.viewModel.yukle();
    if (!mounted || sonuc.basarili || sonuc.mesaj.isEmpty) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  Future<void> _rezervasyonEkle() async {
    final RezervasyonOlusturmaGirdisi? girdi =
        await showDialog<RezervasyonOlusturmaGirdisi>(
          context: context,
          builder: (BuildContext context) => _RezervasyonEkleDialog(
            salonBolumleri: widget.viewModel.salonBolumleri,
          ),
        );
    if (girdi == null) {
      return;
    }
    final RezervasyonIslemSonucu sonuc = await widget.viewModel
        .rezervasyonOlustur(girdi);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  Future<void> _durumIlerle(RezervasyonVarligi rezervasyon) async {
    final RezervasyonIslemSonucu sonuc = await widget.viewModel.durumIlerle(
      rezervasyon,
    );
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  Future<void> _durumDegistir({
    required RezervasyonVarligi rezervasyon,
    required RezervasyonDurumu yeniDurum,
  }) async {
    final RezervasyonIslemSonucu sonuc = await widget.viewModel.durumDegistir(
      rezervasyon: rezervasyon,
      yeniDurum: yeniDurum,
    );
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  Future<void> _sil(RezervasyonVarligi rezervasyon) async {
    final bool? onay = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rezervasyon sil'),
        content: Text('${rezervasyon.musteriAdi} kaydi silinsin mi?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Vazgec'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (onay != true) {
      return;
    }
    final RezervasyonIslemSonucu sonuc = await widget.viewModel.rezervasyonSil(
      rezervasyon,
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
        final RezervasyonViewModel viewModel = widget.viewModel;
        final List<RezervasyonVarligi> rezervasyonlar =
            viewModel.filtrelenmisRezervasyonlar;
        return Scaffold(
          backgroundColor: _arkaPlanKoyu,
          appBar: AppBar(
            title: const Text('Rezervasyon Modulu'),
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
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _rezervasyonEkle,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Rezervasyon ekle'),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[_arkaPlanUst, _arkaPlanOrta, _arkaPlanKoyu],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: viewModel.yukleniyor
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: <Widget>[
                        _OzetKutulari(viewModel: viewModel),
                        const SizedBox(height: 12),
                        _GunSecici(viewModel: viewModel),
                        const SizedBox(height: 12),
                        _DurumFiltreleri(viewModel: viewModel),
                        const SizedBox(height: 14),
                        if (rezervasyonlar.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _panelKoyu,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _cerceve),
                            ),
                            child: const Text(
                              'Secili filtrede rezervasyon bulunamadi.',
                              style: TextStyle(
                                color: _metinIkincil,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ...rezervasyonlar.map(
                          (RezervasyonVarligi rezervasyon) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _RezervasyonKarti(
                              rezervasyon: rezervasyon,
                              durumIlerle: () => _durumIlerle(rezervasyon),
                              noShowYap: () => _durumDegistir(
                                rezervasyon: rezervasyon,
                                yeniDurum: RezervasyonDurumu.noShow,
                              ),
                              iptalEt: () => _durumDegistir(
                                rezervasyon: rezervasyon,
                                yeniDurum: RezervasyonDurumu.iptalEdildi,
                              ),
                              sil: () => _sil(rezervasyon),
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

  final RezervasyonViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: <Widget>[
        _KisaOzetKarti(
          baslik: 'Toplam',
          deger: '${viewModel.toplamRezervasyonSayisi}',
          aciklama: 'rezervasyon',
          vurgu: _metinAna,
        ),
        _KisaOzetKarti(
          baslik: 'Aktif',
          deger: '${viewModel.aktifRezervasyonSayisi}',
          aciklama: 'takipte',
          vurgu: _basari,
        ),
        _KisaOzetKarti(
          baslik: 'No-show',
          deger: '${viewModel.noShowSayisi}',
          aciklama: 'bugun',
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

class _GunSecici extends StatelessWidget {
  const _GunSecici({required this.viewModel});

  final RezervasyonViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final DateTime gun = viewModel.seciliGun;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _panelKoyu.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cerceve),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: viewModel.oncekiGuneGit,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Expanded(
            child: Text(
              _tarihYaz(gun),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _metinAna,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: viewModel.sonrakiGuneGit,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

class _DurumFiltreleri extends StatelessWidget {
  const _DurumFiltreleri({required this.viewModel});

  final RezervasyonViewModel viewModel;

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
        children: RezervasyonDurumFiltresi.values.map((
          RezervasyonDurumFiltresi filtre,
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

class _RezervasyonKarti extends StatelessWidget {
  const _RezervasyonKarti({
    required this.rezervasyon,
    required this.durumIlerle,
    required this.noShowYap,
    required this.iptalEt,
    required this.sil,
  });

  final RezervasyonVarligi rezervasyon;
  final VoidCallback durumIlerle;
  final VoidCallback noShowYap;
  final VoidCallback iptalEt;
  final VoidCallback sil;

  @override
  Widget build(BuildContext context) {
    final bool aktif = rezervasyon.durum.aktifMi;
    final String saatAraligi =
        '${_saatYaz(rezervasyon.baslangicZamani)} - ${_saatYaz(rezervasyon.bitisZamani)}';
    final String masaEtiketi = rezervasyon.masaAdi == null
        ? 'Masa atamasi yok'
        : '${rezervasyon.bolumAdi ?? 'Bolum'} / Masa ${rezervasyon.masaAdi}';

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
                  rezervasyon.musteriAdi,
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
                  color: _durumRengi(rezervasyon.durum).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  rezervasyon.durum.etiket,
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
            '${rezervasyon.telefon} - ${rezervasyon.kisiSayisi} kisi',
            style: const TextStyle(
              color: _metinIkincil,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(saatAraligi, style: const TextStyle(color: _metinIkincil)),
          const SizedBox(height: 4),
          Text(masaEtiketi, style: const TextStyle(color: _metinIkincil)),
          if (rezervasyon.notMetni.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              rezervasyon.notMetni,
              style: const TextStyle(color: _metinIkincil),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              if (_ilerleyebilirMi(rezervasyon.durum))
                FilledButton.tonal(
                  onPressed: durumIlerle,
                  child: const Text('Durum ilerlet'),
                ),
              if (aktif)
                OutlinedButton(
                  onPressed: noShowYap,
                  child: const Text('No-show'),
                ),
              if (aktif)
                OutlinedButton(onPressed: iptalEt, child: const Text('Iptal')),
              TextButton.icon(
                onPressed: sil,
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Sil'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _ilerleyebilirMi(RezervasyonDurumu durum) {
    return durum == RezervasyonDurumu.beklemede ||
        durum == RezervasyonDurumu.onaylandi ||
        durum == RezervasyonDurumu.geldi;
  }

  Color _durumRengi(RezervasyonDurumu durum) {
    switch (durum) {
      case RezervasyonDurumu.beklemede:
        return _uyari;
      case RezervasyonDurumu.onaylandi:
        return _ikincil;
      case RezervasyonDurumu.geldi:
      case RezervasyonDurumu.tamamlandi:
        return _basari;
      case RezervasyonDurumu.noShow:
      case RezervasyonDurumu.iptalEdildi:
        return _birincil;
    }
  }
}

class _RezervasyonEkleDialog extends StatefulWidget {
  const _RezervasyonEkleDialog({required this.salonBolumleri});

  final List<SalonBolumuVarligi> salonBolumleri;

  @override
  State<_RezervasyonEkleDialog> createState() => _RezervasyonEkleDialogState();
}

class _RezervasyonEkleDialogState extends State<_RezervasyonEkleDialog> {
  late final TextEditingController _adDenetleyici;
  late final TextEditingController _telefonDenetleyici;
  late final TextEditingController _kisiSayisiDenetleyici;
  late final TextEditingController _notDenetleyici;
  late DateTime _baslangicZamani;
  int _sureDakika = 90;
  String? _tercihBolumId;
  bool _aydinlatmaOnayi = false;
  bool _ticariIletisimOnayi = false;

  @override
  void initState() {
    super.initState();
    _adDenetleyici = TextEditingController();
    _telefonDenetleyici = TextEditingController();
    _kisiSayisiDenetleyici = TextEditingController(text: '2');
    _notDenetleyici = TextEditingController();
    _baslangicZamani = _varsayilanBaslangicZamani();
  }

  @override
  void dispose() {
    _adDenetleyici.dispose();
    _telefonDenetleyici.dispose();
    _kisiSayisiDenetleyici.dispose();
    _notDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuruklenebilirPopupSablonu(
      materialKullan: false,
      child: AlertDialog(
        scrollable: true,
        insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        actionsOverflowButtonSpacing: 8,
        actionsOverflowDirection: VerticalDirection.down,
        title: const Text('Rezervasyon ekle'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _adDenetleyici,
                decoration: const InputDecoration(labelText: 'Musteri adi'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _telefonDenetleyici,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefon'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _kisiSayisiDenetleyici,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Kisi sayisi'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                initialValue: _tercihBolumId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Bolum tercihi'),
                items: <DropdownMenuItem<String?>>[
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Farketmez'),
                  ),
                  ...widget.salonBolumleri.map(
                    (bolum) => DropdownMenuItem<String?>(
                      value: bolum.id,
                      child: Text(
                        bolum.ad,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: (String? deger) {
                  setState(() {
                    _tercihBolumId = deger;
                  });
                },
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (constraints.maxWidth < 360) {
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _tarihSec,
                            icon: const Icon(Icons.calendar_today_rounded),
                            label: Text(_kisaTarihYaz(_baslangicZamani)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _saatSec,
                            icon: const Icon(Icons.schedule_rounded),
                            label: Text(_saatYaz(_baslangicZamani)),
                          ),
                        ),
                      ],
                    );
                  }
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _tarihSec,
                          icon: const Icon(Icons.calendar_today_rounded),
                          label: Text(_kisaTarihYaz(_baslangicZamani)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _saatSec,
                          icon: const Icon(Icons.schedule_rounded),
                          label: Text(_saatYaz(_baslangicZamani)),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _sureDakika,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Rezervasyon suresi',
                ),
                items: const <DropdownMenuItem<int>>[
                  DropdownMenuItem<int>(value: 60, child: Text('60 dk')),
                  DropdownMenuItem<int>(value: 90, child: Text('90 dk')),
                  DropdownMenuItem<int>(value: 120, child: Text('120 dk')),
                  DropdownMenuItem<int>(value: 150, child: Text('150 dk')),
                ],
                onChanged: (int? deger) {
                  if (deger == null) {
                    return;
                  }
                  setState(() {
                    _sureDakika = deger;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notDenetleyici,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Not'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    KvkkAydinlatmaDialogu.goster(
                      context,
                      baglam: AydinlatmaBaglami.rezervasyon,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const Icon(Icons.info_outline_rounded),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Aydinlatma detaylarini gor',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _OnaySatiri(
                metin:
                    'KVKK aydinlatma metnini okudum ve onayliyorum (zorunlu)',
                secili: _aydinlatmaOnayi,
                onChanged: (bool deger) {
                  setState(() {
                    _aydinlatmaOnayi = deger;
                  });
                },
              ),
              _OnaySatiri(
                metin:
                    'Kampanya ve bilgilendirme iletileri almak istiyorum (opsiyonel)',
                secili: _ticariIletisimOnayi,
                onChanged: (bool deger) {
                  setState(() {
                    _ticariIletisimOnayi = deger;
                  });
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Vazgec'),
          ),
          FilledButton(
            onPressed: _kaydetAktifMi ? _kaydet : null,
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  bool get _kaydetAktifMi {
    final String ad = _adDenetleyici.text.trim();
    final String telefon = _telefonDenetleyici.text.trim();
    final int? kisiSayisi = int.tryParse(_kisiSayisiDenetleyici.text.trim());
    return ad.isNotEmpty &&
        telefon.isNotEmpty &&
        kisiSayisi != null &&
        kisiSayisi > 0 &&
        _aydinlatmaOnayi;
  }

  Future<void> _tarihSec() async {
    final DateTime? secilen = await showDatePicker(
      context: context,
      initialDate: _baslangicZamani,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (secilen == null) {
      return;
    }
    setState(() {
      _baslangicZamani = DateTime(
        secilen.year,
        secilen.month,
        secilen.day,
        _baslangicZamani.hour,
        _baslangicZamani.minute,
      );
    });
  }

  Future<void> _saatSec() async {
    final TimeOfDay? secilen = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_baslangicZamani),
    );
    if (secilen == null) {
      return;
    }
    setState(() {
      _baslangicZamani = DateTime(
        _baslangicZamani.year,
        _baslangicZamani.month,
        _baslangicZamani.day,
        secilen.hour,
        secilen.minute,
      );
    });
  }

  void _kaydet() {
    final String ad = _adDenetleyici.text.trim();
    final String telefon = _telefonDenetleyici.text.trim();
    final int? kisiSayisi = int.tryParse(_kisiSayisiDenetleyici.text.trim());
    if (ad.isEmpty ||
        telefon.isEmpty ||
        kisiSayisi == null ||
        kisiSayisi <= 0 ||
        !_aydinlatmaOnayi) {
      return;
    }
    Navigator.of(context).pop(
      RezervasyonOlusturmaGirdisi(
        musteriAdi: ad,
        telefon: telefon,
        kisiSayisi: kisiSayisi,
        baslangicZamani: _baslangicZamani,
        sureDakika: _sureDakika,
        notMetni: _notDenetleyici.text.trim(),
        aydinlatmaOnayi: _aydinlatmaOnayi,
        ticariIletisimOnayi: _ticariIletisimOnayi,
        tercihBolumId: _tercihBolumId,
      ),
    );
  }

  DateTime _varsayilanBaslangicZamani() {
    final DateTime simdi = DateTime.now();
    final int dakika = ((simdi.minute ~/ 15) + 1) * 15;
    final DateTime hizalanmis = DateTime(
      simdi.year,
      simdi.month,
      simdi.day,
      simdi.hour,
      0,
    ).add(Duration(minutes: dakika));
    return hizalanmis.add(const Duration(minutes: 30));
  }
}

class _OnaySatiri extends StatelessWidget {
  const _OnaySatiri({
    required this.metin,
    required this.secili,
    required this.onChanged,
  });

  final String metin;
  final bool secili;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!secili),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Checkbox(
              value: secili,
              onChanged: (bool? d) => onChanged(d ?? false),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  metin,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _tarihYaz(DateTime tarih) {
  final List<String> aylar = <String>[
    'Ocak',
    'Subat',
    'Mart',
    'Nisan',
    'Mayis',
    'Haziran',
    'Temmuz',
    'Agustos',
    'Eylul',
    'Ekim',
    'Kasim',
    'Aralik',
  ];
  final List<String> gunler = <String>[
    'Pazartesi',
    'Sali',
    'Carsamba',
    'Persembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];
  return '${tarih.day} ${aylar[tarih.month - 1]} ${gunler[tarih.weekday - 1]}';
}

String _kisaTarihYaz(DateTime tarih) {
  return '${tarih.day.toString().padLeft(2, '0')}.${tarih.month.toString().padLeft(2, '0')}.${tarih.year}';
}

String _saatYaz(DateTime zaman) {
  return '${zaman.hour.toString().padLeft(2, '0')}:${zaman.minute.toString().padLeft(2, '0')}';
}
