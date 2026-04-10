import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bilesenler/ana_sayfaya_donus.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/paket_teslimat_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/viewmodel/mutfak_siparis_viewmodel.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_is_kuyrugu_varligi.dart';

typedef _TeslimatFiltresi = TeslimatFiltresi;

class MutfakSiparisSayfasi extends StatefulWidget {
  const MutfakSiparisSayfasi({super.key, required this.viewModel});

  final MutfakSiparisViewModel viewModel;

  @override
  State<MutfakSiparisSayfasi> createState() => _MutfakSiparisSayfasiState();
}

class _MutfakSiparisSayfasiState extends State<MutfakSiparisSayfasi> {
  final ScrollController _yatayKaydirmaDenetleyicisi = ScrollController();

  bool get _yukleniyor => widget.viewModel.yukleniyor;
  List<YaziciDurumuVarligi> get _yazicilar => widget.viewModel.yazicilar;
  _TeslimatFiltresi get _seciliFiltre => widget.viewModel.seciliFiltre;

  @override
  void initState() {
    super.initState();
    _yukle();
  }

  @override
  void didUpdateWidget(covariant MutfakSiparisSayfasi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      oldWidget.viewModel.dispose();
      _yukle();
    }
  }

  @override
  void dispose() {
    _yatayKaydirmaDenetleyicisi.dispose();
    widget.viewModel.dispose();
    super.dispose();
  }

  Future<void> _yukle() async {
    final MutfakSiparisIslemSonucu sonuc = await widget.viewModel.yukle();
    if (!mounted) {
      return;
    }
    if (!sonuc.basarili) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
    }
  }

  Future<void> _durumIlerle(SiparisVarligi siparis) async {
    String? kuryeAdi;
    if (_kuryeSecimiGerekliMi(siparis)) {
      kuryeAdi = await _kuryeAdiSec(siparis);
      if (!mounted) {
        return;
      }
      if (kuryeAdi == null) {
        return;
      }
    }

    final MutfakSiparisIslemSonucu sonuc = await widget.viewModel.durumIlerle(
      siparis,
      kuryeAdi: kuryeAdi,
    );

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  bool _kuryeSecimiGerekliMi(SiparisVarligi siparis) {
    return siparis.teslimatTipi == TeslimatTipi.paketServis &&
        siparis.durum == SiparisDurumu.hazir;
  }

  Future<String?> _kuryeAdiSec(SiparisVarligi siparis) async {
    final TextEditingController denetleyici = TextEditingController(
      text: siparis.kuryeAdi ?? '',
    );
    final List<String> mevcutKuryeler =
        widget.viewModel.siparisler
            .map((SiparisVarligi siparis) => siparis.kuryeAdi?.trim() ?? '')
            .where((String ad) => ad.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    final String? secilen = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kurye Sec'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${siparis.siparisNo} icin teslimata cikacak kuryeyi sec.'),
              const SizedBox(height: 12),
              TextField(
                controller: denetleyici,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Kurye adi',
                  hintText: 'Ornek: Emre Kurye',
                ),
                onSubmitted: (_) {
                  final String? sonuc = _kuryeAdiTemizle(denetleyici.text);
                  if (sonuc != null) {
                    Navigator.of(context).pop(sonuc);
                  }
                },
              ),
              if (mevcutKuryeler.isNotEmpty) ...<Widget>[
                const SizedBox(height: 12),
                const Text(
                  'Hizli secim',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: mevcutKuryeler.map((String ad) {
                    return ActionChip(
                      label: Text(ad),
                      onPressed: () {
                        denetleyici.text = ad;
                      },
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Vazgec'),
            ),
            FilledButton(
              onPressed: () {
                final String? sonuc = _kuryeAdiTemizle(denetleyici.text);
                if (sonuc == null) {
                  return;
                }
                Navigator.of(context).pop(sonuc);
              },
              child: const Text('Devam et'),
            ),
          ],
        );
      },
    );

    denetleyici.dispose();
    return secilen;
  }

  String? _kuryeAdiTemizle(String hamMetin) {
    final String temiz = hamMetin.trim();
    if (temiz.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kurye adi bos birakilamaz.')),
      );
      return null;
    }
    return temiz;
  }

  Future<void> _siparisiIptalEt(SiparisVarligi siparis) async {
    final MutfakSiparisIslemSonucu sonuc = await widget.viewModel
        .siparisiIptalEt(siparis);

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
        final bool masaustu = EkranBoyutu.masaustu(context);
        final List<SiparisVarligi> filtrelenmisSiparisler =
            widget.viewModel.filtrelenmisSiparisler;
        final List<SiparisVarligi> yeniSiparisler =
            widget.viewModel.yeniSiparisler;
        final List<SiparisVarligi> hazirlananlar =
            widget.viewModel.hazirlananlar;
        final List<SiparisVarligi> hazirlar = widget.viewModel.hazirlar;
        final List<SiparisVarligi> kapanisAkisi = widget.viewModel.kapanisAkisi;
        final List<YaziciIsKuyruguVarligi> yaziciKuyrugu =
            widget.viewModel.yaziciKuyrugu;
        final List<SiparisVarligi> aktifSiparisler =
            widget.viewModel.aktifSiparisler;
        final bool durumIlerletmeYetkisiVar =
            widget.viewModel.durumIlerletmeYetkisiVar;
        final bool siparisIptalYetkisiVar =
            widget.viewModel.siparisIptalYetkisiVar;

        return Scaffold(
          backgroundColor: const Color(0xFF130F1D),
          appBar: AppBar(
            title: const Text('Mutfak Siparis Yonetimi'),
            actions: [
              IconButton(
                onPressed: _yukle,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          body: _yukleniyor
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: masaustu
                      ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _MutfakNavigasyonSeridi(mobil: false),
                              const SizedBox(height: 16),
                              _MutfakYaziciSeridi(
                                yazicilar: _yazicilar,
                                kuyruk: yaziciKuyrugu,
                              ),
                              const SizedBox(height: 16),
                              _MutfakOzetSeridi(
                                siparisler: filtrelenmisSiparisler,
                              ),
                              const SizedBox(height: 16),
                              _MutfakOncelikSeridi(siparisler: aktifSiparisler),
                              const SizedBox(height: 16),
                              _MutfakKanalDagilimSeridi(
                                siparisler: aktifSiparisler,
                              ),
                              const SizedBox(height: 16),
                              _TeslimatFiltreSeridi(
                                seciliFiltre: _seciliFiltre,
                                filtreDegistir: widget.viewModel.filtreSec,
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: LayoutBuilder(
                                  builder:
                                      (
                                        BuildContext context,
                                        BoxConstraints constraints,
                                      ) {
                                        final double kolonYuksekligi =
                                            constraints.maxHeight;

                                        return Scrollbar(
                                          thumbVisibility: true,
                                          controller:
                                              _yatayKaydirmaDenetleyicisi,
                                          child: SingleChildScrollView(
                                            controller:
                                                _yatayKaydirmaDenetleyicisi,
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _DurumKolonu(
                                                  baslik: 'Yeni',
                                                  aciklama:
                                                      'Mutfaga yeni dusen siparisler',
                                                  bosDurumMetni:
                                                      'Bu filtrede yeni siparis yok',
                                                  vurguRengi: const Color(
                                                    0xFFFF8A5B,
                                                  ),
                                                  siparisler: yeniSiparisler,
                                                  aksiyonCalistir: _durumIlerle,
                                                  iptalCalistir:
                                                      _siparisiIptalEt,
                                                  aksiyonAktifMi:
                                                      durumIlerletmeYetkisiVar,
                                                  iptalAktifMi:
                                                      siparisIptalYetkisiVar,
                                                  yukseklik: kolonYuksekligi,
                                                ),
                                                const SizedBox(width: 14),
                                                _DurumKolonu(
                                                  baslik: 'Hazirlaniyor',
                                                  aciklama:
                                                      'Aktif mutfak operasyonu',
                                                  bosDurumMetni:
                                                      'Su an mutfakta aktif siparis yok',
                                                  vurguRengi: const Color(
                                                    0xFFFFC857,
                                                  ),
                                                  siparisler: hazirlananlar,
                                                  aksiyonCalistir: _durumIlerle,
                                                  iptalCalistir:
                                                      _siparisiIptalEt,
                                                  aksiyonAktifMi:
                                                      durumIlerletmeYetkisiVar,
                                                  iptalAktifMi:
                                                      siparisIptalYetkisiVar,
                                                  yukseklik: kolonYuksekligi,
                                                ),
                                                const SizedBox(width: 14),
                                                _DurumKolonu(
                                                  baslik: 'Hazir',
                                                  aciklama:
                                                      'Servis veya teslim bekleyenler',
                                                  bosDurumMetni:
                                                      'Bekleyen hazir siparis yok',
                                                  vurguRengi: const Color(
                                                    0xFF30C48D,
                                                  ),
                                                  siparisler: hazirlar,
                                                  aksiyonCalistir: _durumIlerle,
                                                  iptalCalistir:
                                                      _siparisiIptalEt,
                                                  aksiyonAktifMi:
                                                      durumIlerletmeYetkisiVar,
                                                  iptalAktifMi:
                                                      siparisIptalYetkisiVar,
                                                  yukseklik: kolonYuksekligi,
                                                ),
                                                const SizedBox(width: 14),
                                                _DurumKolonu(
                                                  baslik: 'Kapanis',
                                                  aciklama:
                                                      'Dagitim ve teslim kapanisi',
                                                  bosDurumMetni:
                                                      'Kapanis akisinda siparis yok',
                                                  vurguRengi: const Color(
                                                    0xFF7BA7FF,
                                                  ),
                                                  siparisler: kapanisAkisi,
                                                  aksiyonCalistir: _durumIlerle,
                                                  iptalCalistir:
                                                      _siparisiIptalEt,
                                                  aksiyonAktifMi:
                                                      durumIlerletmeYetkisiVar,
                                                  iptalAktifMi:
                                                      siparisIptalYetkisiVar,
                                                  yukseklik: kolonYuksekligi,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(14),
                          children: [
                            _MutfakNavigasyonSeridi(mobil: true),
                            const SizedBox(height: 16),
                            _MutfakYaziciSeridi(
                              yazicilar: _yazicilar,
                              kuyruk: yaziciKuyrugu,
                            ),
                            const SizedBox(height: 16),
                            _MutfakOzetSeridi(
                              siparisler: filtrelenmisSiparisler,
                            ),
                            const SizedBox(height: 16),
                            _MutfakOncelikSeridi(siparisler: aktifSiparisler),
                            const SizedBox(height: 16),
                            _MutfakKanalDagilimSeridi(
                              siparisler: aktifSiparisler,
                            ),
                            const SizedBox(height: 16),
                            _TeslimatFiltreSeridi(
                              seciliFiltre: _seciliFiltre,
                              filtreDegistir: widget.viewModel.filtreSec,
                            ),
                            const SizedBox(height: 16),
                            _DurumKolonu(
                              baslik: 'Yeni',
                              aciklama: 'Mutfaga yeni dusen siparisler',
                              bosDurumMetni: 'Bu filtrede yeni siparis yok',
                              vurguRengi: const Color(0xFFFF8A5B),
                              siparisler: yeniSiparisler,
                              aksiyonCalistir: _durumIlerle,
                              iptalCalistir: _siparisiIptalEt,
                              aksiyonAktifMi: durumIlerletmeYetkisiVar,
                              iptalAktifMi: siparisIptalYetkisiVar,
                              yukseklik: 380,
                            ),
                            const SizedBox(height: 14),
                            _DurumKolonu(
                              baslik: 'Hazirlaniyor',
                              aciklama: 'Aktif mutfak operasyonu',
                              bosDurumMetni: 'Su an mutfakta aktif siparis yok',
                              vurguRengi: const Color(0xFFFFC857),
                              siparisler: hazirlananlar,
                              aksiyonCalistir: _durumIlerle,
                              iptalCalistir: _siparisiIptalEt,
                              aksiyonAktifMi: durumIlerletmeYetkisiVar,
                              iptalAktifMi: siparisIptalYetkisiVar,
                              yukseklik: 380,
                            ),
                            const SizedBox(height: 14),
                            _DurumKolonu(
                              baslik: 'Hazir',
                              aciklama: 'Servis veya teslim bekleyenler',
                              bosDurumMetni: 'Bekleyen hazir siparis yok',
                              vurguRengi: const Color(0xFF30C48D),
                              siparisler: hazirlar,
                              aksiyonCalistir: _durumIlerle,
                              iptalCalistir: _siparisiIptalEt,
                              aksiyonAktifMi: durumIlerletmeYetkisiVar,
                              iptalAktifMi: siparisIptalYetkisiVar,
                              yukseklik: 380,
                            ),
                            const SizedBox(height: 14),
                            _DurumKolonu(
                              baslik: 'Kapanis',
                              aciklama: 'Dagitim ve teslim kapanisi',
                              bosDurumMetni: 'Kapanis akisinda siparis yok',
                              vurguRengi: const Color(0xFF7BA7FF),
                              siparisler: kapanisAkisi,
                              aksiyonCalistir: _durumIlerle,
                              iptalCalistir: _siparisiIptalEt,
                              aksiyonAktifMi: durumIlerletmeYetkisiVar,
                              iptalAktifMi: siparisIptalYetkisiVar,
                              yukseklik: 340,
                            ),
                          ],
                        ),
                ),
        );
      },
    );
  }
}

class _MutfakNavigasyonSeridi extends StatelessWidget {
  const _MutfakNavigasyonSeridi({required this.mobil});

  final bool mobil;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF231A31),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Operasyon gecisleri',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.84),
              fontSize: mobil ? 16 : 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => anaSayfayaDon(context),
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  padding: EdgeInsets.symmetric(
                    horizontal: mobil ? 12 : 14,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.home_rounded, size: 18),
                label: const Text('Ana sayfaya don'),
              ),
              FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(RotaYapisi.pos);
                },
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  padding: EdgeInsets.symmetric(
                    horizontal: mobil ? 12 : 14,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.point_of_sale_rounded, size: 18),
                label: const Text('POS ekranina git'),
              ),
              FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(RotaYapisi.yonetimPaneli);
                },
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  padding: EdgeInsets.symmetric(
                    horizontal: mobil ? 12 : 14,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.dashboard_customize_rounded, size: 18),
                label: const Text('Yonetim paneli'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(RotaYapisi.personelGiris);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  padding: EdgeInsets.symmetric(
                    horizontal: mobil ? 12 : 14,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.switch_account_rounded, size: 18),
                label: const Text('Personel girisine don'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MutfakYaziciSeridi extends StatelessWidget {
  const _MutfakYaziciSeridi({required this.yazicilar, required this.kuyruk});

  final List<YaziciDurumuVarligi> yazicilar;
  final List<YaziciIsKuyruguVarligi> kuyruk;

  @override
  Widget build(BuildContext context) {
    final int bagliYaziciSayisi = yazicilar.where((YaziciDurumuVarligi yazici) {
      return yazici.durum == YaziciBaglantiDurumu.bagli;
    }).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF231A31),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yazici senkronu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$bagliYaziciSayisi / ${yazicilar.length} yazici aktif. Mutfak durumu ve fis kuyrugu ayni alanda izleniyor.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: yazicilar.map((YaziciDurumuVarligi yazici) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: yazici.renk.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.print_rounded, size: 16, color: yazici.renk),
                        const SizedBox(width: 8),
                        Text(
                          '${yazici.rolEtiketi}: ${yazici.durumEtiketi}',
                          style: TextStyle(
                            color: yazici.renk,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (kuyruk.isEmpty)
            Text(
              'Su an yazici kuyrugunda bekleyen is yok.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: kuyruk.take(4).map((YaziciIsKuyruguVarligi isEmri) {
                return _YaziciKuyrukRozeti(isEmri: isEmri);
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _YaziciKuyrukRozeti extends StatelessWidget {
  const _YaziciKuyrukRozeti({required this.isEmri});

  final YaziciIsKuyruguVarligi isEmri;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 300),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    isEmri.siparisNo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  isEmri.durumEtiketi,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isEmri.yaziciRolu,
              style: const TextStyle(
                color: Color(0xFFFFD36E),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isEmri.kisaAciklama,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MutfakOzetSeridi extends StatelessWidget {
  const _MutfakOzetSeridi({required this.siparisler});

  final List<SiparisVarligi> siparisler;

  @override
  Widget build(BuildContext context) {
    final DateTime simdi = DateTime.now();
    final List<SiparisVarligi> aktifSiparisler = siparisler
        .where(
          (SiparisVarligi siparis) =>
              siparis.durum != SiparisDurumu.teslimEdildi &&
              siparis.durum != SiparisDurumu.iptalEdildi,
        )
        .toList();
    final List<SiparisVarligi> acilSiparisler = aktifSiparisler
        .where(
          (SiparisVarligi siparis) => _beklemeDakikasi(siparis, simdi) >= 20,
        )
        .toList();

    int toplamDakika = 0;
    for (final SiparisVarligi siparis in aktifSiparisler) {
      toplamDakika += _beklemeDakikasi(siparis, simdi);
    }
    final int ortalamaDakika = aktifSiparisler.isEmpty
        ? 0
        : (toplamDakika / aktifSiparisler.length).round();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _OzetKarti(
          baslik: 'Aktif is',
          deger: '${aktifSiparisler.length}',
          aciklama: 'Mutfak ve teslim kapanisinda bekleyen siparis',
          vurguRengi: const Color(0xFFFF8A5B),
        ),
        _OzetKarti(
          baslik: 'Acil hat',
          deger: '${acilSiparisler.length}',
          aciklama: '20 dakikayi gecen siparis',
          vurguRengi: const Color(0xFFFFC857),
        ),
        _OzetKarti(
          baslik: 'Ortalama sure',
          deger: '$ortalamaDakika dk',
          aciklama: 'Aktif siparislerde ortalama bekleme',
          vurguRengi: const Color(0xFF7BA7FF),
        ),
      ],
    );
  }
}

class _MutfakOncelikSeridi extends StatelessWidget {
  const _MutfakOncelikSeridi({required this.siparisler});

  final List<SiparisVarligi> siparisler;

  @override
  Widget build(BuildContext context) {
    final DateTime simdi = DateTime.now();
    final List<SiparisVarligi> sirali = List<SiparisVarligi>.from(siparisler)
      ..sort(
        (SiparisVarligi a, SiparisVarligi b) => _mutfakOnceligiSkoru(
          b,
          simdi,
        ).compareTo(_mutfakOnceligiSkoru(a, simdi)),
      );
    final SiparisVarligi? enKritik = sirali.isEmpty ? null : sirali.first;
    final SiparisVarligi? siradaki = sirali.length > 1 ? sirali[1] : null;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: 360,
          child: _OncelikKarti(
            baslik: 'Kritik siparis',
            aciklama: enKritik == null
                ? 'Su an kritik esigi gecen aktif siparis yok.'
                : '${enKritik.siparisNo} once ele alinmali. ${_siparisKisaDurumMetni(enKritik, simdi)}',
            vurguRengi: const Color(0xFFFF8A5B),
          ),
        ),
        SizedBox(
          width: 360,
          child: _OncelikKarti(
            baslik: 'Siradaki hazirlik',
            aciklama: siradaki == null
                ? 'Yedek operasyon sirasi bos.'
                : '${siradaki.siparisNo} ikinci sirada. ${_siparisKisaDurumMetni(siradaki, simdi)}',
            vurguRengi: const Color(0xFF7BA7FF),
          ),
        ),
      ],
    );
  }
}

class _OncelikKarti extends StatelessWidget {
  const _OncelikKarti({
    required this.baslik,
    required this.aciklama,
    required this.vurguRengi,
  });

  final String baslik;
  final String aciklama;
  final Color vurguRengi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF231A31),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: TextStyle(
              color: vurguRengi,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            aciklama,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MutfakKanalDagilimSeridi extends StatelessWidget {
  const _MutfakKanalDagilimSeridi({required this.siparisler});

  final List<SiparisVarligi> siparisler;

  @override
  Widget build(BuildContext context) {
    final int salonSayisi = siparisler
        .where(
          (SiparisVarligi siparis) =>
              siparis.teslimatTipi == TeslimatTipi.restorandaYe,
        )
        .length;
    final int gelAlSayisi = siparisler
        .where(
          (SiparisVarligi siparis) =>
              siparis.teslimatTipi == TeslimatTipi.gelAl,
        )
        .length;
    final int paketSayisi = siparisler
        .where(
          (SiparisVarligi siparis) =>
              siparis.teslimatTipi == TeslimatTipi.paketServis,
        )
        .length;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _KanalKarti(
          baslik: 'Salon',
          adet: salonSayisi,
          aciklama: 'Servis bekleyen masa operasyonu',
          vurguRengi: const Color(0xFFFFD36E),
        ),
        _KanalKarti(
          baslik: 'Gel al',
          adet: gelAlSayisi,
          aciklama: 'Tezgahtan teslim alinacak siparis',
          vurguRengi: const Color(0xFF7BA7FF),
        ),
        _KanalKarti(
          baslik: 'Paket',
          adet: paketSayisi,
          aciklama: 'Kurye veya paket cikari bekleyen siparis',
          vurguRengi: const Color(0xFF30C48D),
        ),
      ],
    );
  }
}

class _KanalKarti extends StatelessWidget {
  const _KanalKarti({
    required this.baslik,
    required this.adet,
    required this.aciklama,
    required this.vurguRengi,
  });

  final String baslik;
  final int adet;
  final String aciklama;
  final Color vurguRengi;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 280),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF231A31),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              baslik,
              style: TextStyle(color: vurguRengi, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              '$adet',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              aciklama,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.68),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OzetKarti extends StatelessWidget {
  const _OzetKarti({
    required this.baslik,
    required this.deger,
    required this.aciklama,
    required this.vurguRengi,
  });

  final String baslik;
  final String deger;
  final String aciklama;
  final Color vurguRengi;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 280),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF231A31),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              baslik,
              style: TextStyle(
                color: vurguRengi,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              deger,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              aciklama,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.68),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeslimatFiltreSeridi extends StatelessWidget {
  const _TeslimatFiltreSeridi({
    required this.seciliFiltre,
    required this.filtreDegistir,
  });

  final _TeslimatFiltresi seciliFiltre;
  final ValueChanged<_TeslimatFiltresi> filtreDegistir;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tum kanallar',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.82),
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _TeslimatFiltresi.values.map((_TeslimatFiltresi filtre) {
              final bool seciliMi = seciliFiltre == filtre;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FilterChip(
                  selected: seciliMi,
                  label: Text(filtre.etiket),
                  onSelected: (_) => filtreDegistir(filtre),
                  labelStyle: TextStyle(
                    color: seciliMi ? const Color(0xFF130F1D) : Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
                  backgroundColor: Colors.white.withValues(alpha: 0.06),
                  selectedColor: const Color(0xFFFFD36E),
                  showCheckmark: false,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _DurumKolonu extends StatelessWidget {
  const _DurumKolonu({
    required this.baslik,
    required this.aciklama,
    required this.bosDurumMetni,
    required this.vurguRengi,
    required this.siparisler,
    required this.aksiyonCalistir,
    required this.iptalCalistir,
    required this.aksiyonAktifMi,
    required this.iptalAktifMi,
    this.yukseklik,
  });

  final String baslik;
  final String aciklama;
  final String bosDurumMetni;
  final Color vurguRengi;
  final List<SiparisVarligi> siparisler;
  final ValueChanged<SiparisVarligi> aksiyonCalistir;
  final ValueChanged<SiparisVarligi> iptalCalistir;
  final bool aksiyonAktifMi;
  final bool iptalAktifMi;
  final double? yukseklik;

  @override
  Widget build(BuildContext context) {
    final Widget liste = siparisler.isEmpty
        ? Center(
            child: Text(
              bosDurumMetni,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : ListView.separated(
            itemCount: siparisler.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              final SiparisVarligi siparis = siparisler[index];
              return _MutfakSiparisKarti(
                siparis: siparis,
                vurguRengi: vurguRengi,
                aksiyonCalistir: () => aksiyonCalistir(siparis),
                iptalCalistir: () => iptalCalistir(siparis),
                aksiyonAktifMi: aksiyonAktifMi,
                iptalAktifMi: iptalAktifMi,
              );
            },
          );

    return Container(
      width: 318,
      height: yukseklik,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF231A31),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: TextStyle(
              color: vurguRengi,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            aciklama,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.68),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: vurguRengi.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${siparisler.length} siparis',
              style: TextStyle(color: vurguRengi, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(child: liste),
        ],
      ),
    );
  }
}

class _MutfakSiparisKarti extends StatelessWidget {
  const _MutfakSiparisKarti({
    required this.siparis,
    required this.vurguRengi,
    required this.aksiyonCalistir,
    required this.iptalCalistir,
    required this.aksiyonAktifMi,
    required this.iptalAktifMi,
  });

  final SiparisVarligi siparis;
  final Color vurguRengi;
  final VoidCallback aksiyonCalistir;
  final VoidCallback iptalCalistir;
  final bool aksiyonAktifMi;
  final bool iptalAktifMi;

  @override
  Widget build(BuildContext context) {
    final DateTime simdi = DateTime.now();
    final int beklemeDakikasi = _beklemeDakikasi(siparis, simdi);
    final Color sureRengi = _sureVurguRengi(beklemeDakikasi);
    final String? aksiyonEtiketi = _aksiyonEtiketi(siparis);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      siparis.siparisNo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_siparisSahibiEtiketi(siparis)} - ${_konumEtiketi(siparis)}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: vurguRengi.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _teslimatEtiketi(siparis.teslimatTipi),
                      style: TextStyle(
                        color: vurguRengi,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: sureRengi.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$beklemeDakikasi dk',
                      style: TextStyle(
                        color: sureRengi,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _BilgiRozeti(
                ikon: Icons.flag_rounded,
                metin: _oncelikEtiketi(beklemeDakikasi),
                renk: sureRengi,
              ),
              _BilgiRozeti(
                ikon: Icons.receipt_long_rounded,
                metin: '${siparis.kalemler.length} kalem',
                renk: const Color(0xFFFFD36E),
              ),
              _BilgiRozeti(
                ikon: Icons.payments_rounded,
                metin: _paraYaz(siparis.toplamTutar),
                renk: const Color(0xFF7BA7FF),
              ),
              if (siparis.paketTeslimatDurumu != null)
                _BilgiRozeti(
                  ikon: Icons.local_shipping_rounded,
                  metin: _paketTeslimatDurumuEtiketi(
                    siparis.paketTeslimatDurumu!,
                  ),
                  renk: const Color(0xFFFF8A5B),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.timelapse_rounded, color: sureRengi, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _sureAciklamasi(beklemeDakikasi),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.84),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (siparis.kaynak != null && siparis.kaynak!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Kaynak: ${siparis.kaynak}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.68),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (siparis.kuryeAdi != null && siparis.kuryeAdi!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Kurye: ${siparis.kuryeAdi}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.68),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (siparis.teslimatNotu != null &&
              siparis.teslimatNotu!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Teslimat notu: ${siparis.teslimatNotu}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.68),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 12),
          ...siparis.kalemler.map(
            (SiparisKalemiVarligi kalem) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${kalem.adet}x ${kalem.urunAdi}${kalem.secenekAdi != null ? ' / ${kalem.secenekAdi}' : ''}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (aksiyonEtiketi != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: aksiyonAktifMi ? aksiyonCalistir : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: vurguRengi,
                      foregroundColor: const Color(0xFF1A1322),
                    ),
                    child: Text(aksiyonEtiketi),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed:
                      !iptalAktifMi || siparis.durum == SiparisDurumu.yolda
                      ? null
                      : iptalCalistir,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: const Text('Iptal'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _BilgiRozeti extends StatelessWidget {
  const _BilgiRozeti({
    required this.ikon,
    required this.metin,
    required this.renk,
  });

  final IconData ikon;
  final String metin;
  final Color renk;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 16, color: renk),
          const SizedBox(width: 6),
          Text(
            metin,
            style: TextStyle(color: renk, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

int _beklemeDakikasi(SiparisVarligi siparis, DateTime simdi) {
  return simdi.difference(siparis.olusturmaTarihi).inMinutes.clamp(0, 9999);
}

int _mutfakOnceligiSkoru(SiparisVarligi siparis, DateTime simdi) {
  final int beklemeDakikasi = _beklemeDakikasi(siparis, simdi);
  final int durumPuani = switch (siparis.durum) {
    SiparisDurumu.alindi => 35,
    SiparisDurumu.hazirlaniyor => 50,
    SiparisDurumu.hazir => 40,
    SiparisDurumu.yolda => 15,
    SiparisDurumu.teslimEdildi => 0,
    SiparisDurumu.iptalEdildi => -20,
  };
  final int kanalPuani = switch (siparis.teslimatTipi) {
    TeslimatTipi.restorandaYe => 8,
    TeslimatTipi.gelAl => 5,
    TeslimatTipi.paketServis => 10,
  };
  return durumPuani + kanalPuani + beklemeDakikasi;
}

String _siparisKisaDurumMetni(SiparisVarligi siparis, DateTime simdi) {
  final int dakika = _beklemeDakikasi(siparis, simdi);
  return '${_siparisSahibiEtiketi(siparis)} - ${_teslimatEtiketi(siparis.teslimatTipi)} - $dakika dk bekliyor';
}

String? _aksiyonEtiketi(SiparisVarligi siparis) {
  switch (siparis.durum) {
    case SiparisDurumu.alindi:
      return 'Hazirlamaya al';
    case SiparisDurumu.hazirlaniyor:
      return 'Hazir oldu';
    case SiparisDurumu.hazir:
      return siparis.teslimatTipi == TeslimatTipi.paketServis
          ? 'Kuryeye ver'
          : 'Teslim edildi';
    case SiparisDurumu.yolda:
      return 'Teslim edildi';
    case SiparisDurumu.teslimEdildi:
    case SiparisDurumu.iptalEdildi:
      return null;
  }
}

Color _sureVurguRengi(int dakika) {
  if (dakika >= 20) {
    return const Color(0xFFFF8A5B);
  }
  if (dakika >= 12) {
    return const Color(0xFFFFC857);
  }
  return const Color(0xFF30C48D);
}

String _oncelikEtiketi(int dakika) {
  if (dakika >= 20) {
    return 'Kritik';
  }
  if (dakika >= 12) {
    return 'Takipte';
  }
  return 'Normal';
}

String _sureAciklamasi(int dakika) {
  if (dakika >= 20) {
    return 'Mudahale gerekli, siparis gecikiyor';
  }
  if (dakika >= 12) {
    return 'Takipte tut, sure esigine yaklasiyor';
  }
  return 'Akis normal, mutfak temposu uygun';
}

String _teslimatEtiketi(TeslimatTipi teslimatTipi) {
  switch (teslimatTipi) {
    case TeslimatTipi.restorandaYe:
      return 'Salon';
    case TeslimatTipi.gelAl:
      return 'Gel al';
    case TeslimatTipi.paketServis:
      return 'Paket';
  }
}

String _paketTeslimatDurumuEtiketi(PaketTeslimatDurumu durum) {
  switch (durum) {
    case PaketTeslimatDurumu.adresDogrulandi:
      return 'Adres dogrulandi';
    case PaketTeslimatDurumu.kuryeBekliyor:
      return 'Kurye bekliyor';
    case PaketTeslimatDurumu.kuryeYolda:
      return 'Kurye yolda';
    case PaketTeslimatDurumu.teslimEdildi:
      return 'Teslim edildi';
  }
}

String _konumEtiketi(SiparisVarligi siparis) {
  if (siparis.masaNo != null && siparis.masaNo!.isNotEmpty) {
    return 'Masa ${siparis.masaNo} / ${siparis.bolumAdi ?? 'Salon'}';
  }
  if (siparis.adresMetni != null && siparis.adresMetni!.isNotEmpty) {
    return siparis.adresMetni!;
  }
  return 'Operasyon sirasi bekliyor';
}

String _siparisSahibiEtiketi(SiparisVarligi siparis) {
  final String? adSoyad = siparis.sahip.misafirBilgisi?.adSoyad;
  if (adSoyad != null && adSoyad.isNotEmpty) {
    return adSoyad;
  }
  return 'Misafir';
}

String _paraYaz(double tutar) {
  return '${tutar.toStringAsFixed(2).replaceAll('.', ',')} TL';
}
