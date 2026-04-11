import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restoran_app/ortak/bilesenler/ana_sayfaya_donus.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/tema/ana_sayfa_renk_sablonu.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/paket_teslimat_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/mutfak_operasyon_varliklari.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/viewmodel/mutfak_siparis_viewmodel.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/mutfak_operasyon_hesaplayici.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_is_kuyrugu_varligi.dart';

typedef _TeslimatFiltresi = TeslimatFiltresi;
typedef _PaketlemeDurumGuncelle =
    void Function(
      String siparisId, {
      bool? hazirlandi,
      bool? paketlendi,
      bool? teslimeCikti,
    });

const Color _renkArkaPlanKoyu = AnaSayfaRenkSablonu.arkaPlanKoyu;
const Color _renkArkaPlanOrta = AnaSayfaRenkSablonu.arkaPlanOrta;
const Color _renkArkaPlanUst = AnaSayfaRenkSablonu.arkaPlanUst;
const Color _renkPanel = AnaSayfaRenkSablonu.panelKoyu;
const Color _renkPanelYuksek = AnaSayfaRenkSablonu.panelYuksek;
const Color _renkCerceve = AnaSayfaRenkSablonu.cerceve;
const Color _renkBirincil = AnaSayfaRenkSablonu.birincilAksiyon;
const Color _renkIkincil = AnaSayfaRenkSablonu.ikincilAksiyon;
const Color _renkUcuncul = AnaSayfaRenkSablonu.ucunculAksiyon;
const Color _renkCanliMavi = AnaSayfaRenkSablonu.bilgilendirici;
const Color _renkBasari = AnaSayfaRenkSablonu.basari;
const Color _renkMetinIkincil = AnaSayfaRenkSablonu.metinIkincil;
const Color _renkAlarmYuzey = AnaSayfaRenkSablonu.panelAlarm;
const Color _renkBasariYuzey = AnaSayfaRenkSablonu.panelBasari;

class MutfakSiparisSayfasi extends StatefulWidget {
  const MutfakSiparisSayfasi({super.key, required this.viewModel});

  final MutfakSiparisViewModel viewModel;

  @override
  State<MutfakSiparisSayfasi> createState() => _MutfakSiparisSayfasiState();
}

class _MutfakSiparisSayfasiState extends State<MutfakSiparisSayfasi> {
  Timer? _canliSureZamanlayicisi;
  Timer? _otomatikVeriYenileZamanlayicisi;
  bool _sadeceGecikenleriGoster = false;
  bool _otomatikYenilemeAktif = true;
  bool _fireNowModu = false;
  bool _sesliUyariAktif = true;
  DateTime? _sonYenilemeZamani;
  final Set<String> _bildirilenGecikmeler = <String>{};
  final Map<String, _PaketlemeTakipDurumu> _paketlemeTakipleri =
      <String, _PaketlemeTakipDurumu>{};
  final Map<String, String> _mutfakNotlari = <String, String>{};

  bool get _yukleniyor => widget.viewModel.yukleniyor;
  List<YaziciDurumuVarligi> get _yazicilar => widget.viewModel.yazicilar;
  _TeslimatFiltresi get _seciliFiltre => widget.viewModel.seciliFiltre;

  @override
  void initState() {
    super.initState();
    _canliSureZamanlayicisi = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        setState(() {});
      }
    });
    _otomatikVeriYenileZamanlayicisi = Timer.periodic(
      const Duration(seconds: 90),
      (_) async {
        if (!mounted || !_otomatikYenilemeAktif || _yukleniyor) {
          return;
        }
        await _yukle(gosterHata: false);
      },
    );
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
    _canliSureZamanlayicisi?.cancel();
    _otomatikVeriYenileZamanlayicisi?.cancel();
    widget.viewModel.dispose();
    super.dispose();
  }

  Future<void> _yukle({bool gosterHata = true}) async {
    final MutfakSiparisIslemSonucu sonuc = await widget.viewModel.yukle();
    if (!mounted) {
      return;
    }
    if (sonuc.basarili) {
      setState(() {
        _sonYenilemeZamani = DateTime.now();
      });
      _kritikSesliUyariKontrolEt(widget.viewModel.siparisler);
      return;
    }
    if (gosterHata) {
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
          scrollable: true,
          title: const Text('Kurye Sec'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${siparis.siparisNo} icin teslimata cikacak kuryeyi sec.',
                ),
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

  void _sadeceGecikenleriDegistir(bool deger) {
    if (_sadeceGecikenleriGoster == deger) {
      return;
    }
    setState(() {
      _sadeceGecikenleriGoster = deger;
    });
  }

  void _otomatikYenilemeyiDegistir(bool deger) {
    if (_otomatikYenilemeAktif == deger) {
      return;
    }
    setState(() {
      _otomatikYenilemeAktif = deger;
    });
  }

  void _fireNowModunuDegistir(bool deger) {
    if (_fireNowModu == deger) {
      return;
    }
    setState(() {
      _fireNowModu = deger;
    });
  }

  void _sesliUyariyiDegistir(bool deger) {
    if (_sesliUyariAktif == deger) {
      return;
    }
    setState(() {
      _sesliUyariAktif = deger;
    });
  }

  _PaketlemeTakipDurumu _paketlemeDurumuGetir(String siparisId) {
    return _paketlemeTakipleri[siparisId] ?? const _PaketlemeTakipDurumu();
  }

  void _paketlemeDurumuGuncelle(
    String siparisId, {
    bool? hazirlandi,
    bool? paketlendi,
    bool? teslimeCikti,
  }) {
    final _PaketlemeTakipDurumu mevcut = _paketlemeDurumuGetir(siparisId);
    setState(() {
      _paketlemeTakipleri[siparisId] = mevcut.copyWith(
        hazirlandi: hazirlandi,
        paketlendi: paketlendi,
        teslimeCikti: teslimeCikti,
      );
    });
  }

  Future<void> _mutfakNotuDuzenle(SiparisVarligi siparis) async {
    final TextEditingController denetleyici = TextEditingController(
      text: _mutfakNotlari[siparis.id] ?? '',
    );
    final String? not = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text('${siparis.siparisNo} mutfak notu'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: TextField(
              controller: denetleyici,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Ornek: Sos ayri gitsin',
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Vazgec'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(denetleyici.text),
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
    denetleyici.dispose();
    if (!mounted || not == null) {
      return;
    }
    setState(() {
      if (not.trim().isEmpty) {
        _mutfakNotlari.remove(siparis.id);
      } else {
        _mutfakNotlari[siparis.id] = not.trim();
      }
    });
  }

  void _kritikSesliUyariKontrolEt(List<SiparisVarligi> siparisler) {
    final MutfakOperasyonOzetiVarligi ozet =
        MutfakOperasyonHesaplayici.ozetHesapla(siparisler: siparisler);
    final Set<String> mevcutKritikler = ozet.gecikmeUyarilari
        .map((MutfakGecikmeUyarisiVarligi uyari) => uyari.siparisId)
        .toSet();
    final bool yeniKritikVar = mevcutKritikler
        .difference(_bildirilenGecikmeler)
        .isNotEmpty;
    if (_sesliUyariAktif && yeniKritikVar) {
      SystemSound.play(SystemSoundType.alert);
    }
    _bildirilenGecikmeler
      ..clear()
      ..addAll(mevcutKritikler);
  }

  List<_SiparisGrubuOzet> _siparisGruplariniOlustur(
    List<SiparisVarligi> siparisler,
  ) {
    final Map<String, List<SiparisVarligi>> harita =
        <String, List<SiparisVarligi>>{};
    for (final SiparisVarligi siparis in siparisler) {
      final String anahtar =
          '${_siparisSahibiEtiketi(siparis)}|${_teslimatEtiketi(siparis.teslimatTipi)}|${_konumEtiketi(siparis)}';
      harita.putIfAbsent(anahtar, () => <SiparisVarligi>[]).add(siparis);
    }
    final List<_SiparisGrubuOzet> gruplar =
        harita.entries
            .where((MapEntry<String, List<SiparisVarligi>> kayit) {
              return kayit.value.length > 1;
            })
            .map((MapEntry<String, List<SiparisVarligi>> kayit) {
              final List<SiparisVarligi> degerler = kayit.value;
              int kalemSayisi = 0;
              for (final SiparisVarligi siparis in degerler) {
                kalemSayisi += siparis.kalemler.length;
              }
              return _SiparisGrubuOzet(
                grupEtiketi: kayit.key.replaceAll('|', ' • '),
                siparisSayisi: degerler.length,
                toplamKalemSayisi: kalemSayisi,
              );
            })
            .toList()
          ..sort((a, b) => b.siparisSayisi.compareTo(a.siparisSayisi));
    return gruplar;
  }

  List<SiparisVarligi> _durumaGoreFiltrele(
    List<SiparisVarligi> kaynak,
    List<SiparisDurumu> durumlar,
  ) {
    return kaynak
        .where((SiparisVarligi siparis) => durumlar.contains(siparis.durum))
        .toList()
      ..sort(
        (SiparisVarligi a, SiparisVarligi b) =>
            a.olusturmaTarihi.compareTo(b.olusturmaTarihi),
      );
  }

  List<SiparisVarligi> _gecikenSiparisleriSec(
    List<SiparisVarligi> kaynak,
    MutfakOperasyonOzetiVarligi ozet,
  ) {
    return kaynak.where((SiparisVarligi siparis) {
      final MutfakSiparisTahminiVarligi? tahmin =
          ozet.siparisTahminleri[siparis.id];
      return tahmin?.gecikiyorMu ?? false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (BuildContext context, Widget? child) {
        final bool masaustu = EkranBoyutu.masaustu(context);
        final List<SiparisVarligi> kaynakSiparisler =
            widget.viewModel.filtrelenmisSiparisler;
        final MutfakOperasyonOzetiVarligi kaynakOperasyonOzeti =
            MutfakOperasyonHesaplayici.ozetHesapla(
              siparisler: kaynakSiparisler,
            );
        final bool gecikmeOdakliFiltre =
            _sadeceGecikenleriGoster || _fireNowModu;
        final List<SiparisVarligi> filtrelenmisSiparisler = gecikmeOdakliFiltre
            ? _gecikenSiparisleriSec(kaynakSiparisler, kaynakOperasyonOzeti)
            : kaynakSiparisler;
        final MutfakOperasyonOzetiVarligi operasyonOzeti =
            _sadeceGecikenleriGoster
            ? MutfakOperasyonHesaplayici.ozetHesapla(
                siparisler: filtrelenmisSiparisler,
              )
            : kaynakOperasyonOzeti;
        final List<SiparisVarligi> yeniSiparisler = _durumaGoreFiltrele(
          filtrelenmisSiparisler,
          const <SiparisDurumu>[SiparisDurumu.alindi],
        );
        final List<SiparisVarligi> hazirlananlar = _durumaGoreFiltrele(
          filtrelenmisSiparisler,
          const <SiparisDurumu>[SiparisDurumu.hazirlaniyor],
        );
        final List<SiparisVarligi> hazirlar = _durumaGoreFiltrele(
          filtrelenmisSiparisler,
          const <SiparisDurumu>[SiparisDurumu.hazir],
        );
        final List<SiparisVarligi> kapanisAkisi = _durumaGoreFiltrele(
          filtrelenmisSiparisler,
          const <SiparisDurumu>[
            SiparisDurumu.yolda,
            SiparisDurumu.teslimEdildi,
          ],
        );
        final List<SiparisVarligi> aktifSiparisler = filtrelenmisSiparisler
            .where(
              (SiparisVarligi siparis) =>
                  siparis.durum != SiparisDurumu.teslimEdildi &&
                  siparis.durum != SiparisDurumu.iptalEdildi,
            )
            .toList();
        final List<YaziciIsKuyruguVarligi> yaziciKuyrugu =
            widget.viewModel.yaziciKuyrugu;
        final bool durumIlerletmeYetkisiVar =
            widget.viewModel.durumIlerletmeYetkisiVar;
        final bool siparisIptalYetkisiVar =
            widget.viewModel.siparisIptalYetkisiVar;

        return Scaffold(
          backgroundColor: _renkArkaPlanKoyu,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    _renkBirincil,
                    _renkIkincil,
                    _renkArkaPlanKoyu,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
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
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          _renkArkaPlanUst,
                          _renkArkaPlanOrta,
                          _renkArkaPlanKoyu,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: masaustu
                        ? ListView(
                            padding: const EdgeInsets.all(20),
                            children: [
                              _MutfakNavigasyonSeridi(mobil: false),
                              const SizedBox(height: 14),
                              const _BolumBasligi(
                                metin: 'Komuta ve filtre',
                                aciklama:
                                    'Yenileme, gecikme filtresi ve teslimat kanali secimi.',
                              ),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 7,
                                    child: _MutfakKontrolSeridi(
                                      sadeceGecikenleriGoster:
                                          _sadeceGecikenleriGoster,
                                      otomatikYenilemeAktif:
                                          _otomatikYenilemeAktif,
                                      sonYenilemeZamani: _sonYenilemeZamani,
                                      sadeceGecikenleriDegistir:
                                          _sadeceGecikenleriDegistir,
                                      otomatikYenilemeyiDegistir:
                                          _otomatikYenilemeyiDegistir,
                                      fireNowModu: _fireNowModu,
                                      fireNowModunuDegistir:
                                          _fireNowModunuDegistir,
                                      sesliUyariAktif: _sesliUyariAktif,
                                      sesliUyariyiDegistir:
                                          _sesliUyariyiDegistir,
                                      elleYenile: () => _yukle(),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 5,
                                    child: _TeslimatFiltreSeridi(
                                      seciliFiltre: _seciliFiltre,
                                      filtreDegistir:
                                          widget.viewModel.filtreSec,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const _BolumBasligi(
                                          metin: 'Siparis akisi',
                                          aciklama:
                                              'Mutfak durum kolonlarini tek alanda yonet.',
                                        ),
                                        const SizedBox(height: 10),
                                        _DurumPanosu(
                                          masaustu: true,
                                          yeniSiparisler: yeniSiparisler,
                                          hazirlananlar: hazirlananlar,
                                          hazirlar: hazirlar,
                                          kapanisAkisi: kapanisAkisi,
                                          aksiyonCalistir: _durumIlerle,
                                          iptalCalistir: _siparisiIptalEt,
                                          aksiyonAktifMi:
                                              durumIlerletmeYetkisiVar,
                                          iptalAktifMi: siparisIptalYetkisiVar,
                                          siparisTahminleri:
                                              operasyonOzeti.siparisTahminleri,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const _BolumBasligi(
                                          metin: 'Operasyon izleme',
                                        ),
                                        const SizedBox(height: 10),
                                        _MutfakOzetSeridi(
                                          siparisler: filtrelenmisSiparisler,
                                          operasyonOzeti: operasyonOzeti,
                                        ),
                                        const SizedBox(height: 12),
                                        _MutfakAlarmSeridi(
                                          uyarilar:
                                              operasyonOzeti.gecikmeUyarilari,
                                        ),
                                        const SizedBox(height: 12),
                                        _MutfakOncelikSeridi(
                                          siparisler: aktifSiparisler,
                                        ),
                                        const SizedBox(height: 12),
                                        _MutfakGelismisPaneli(
                                          siparisler: aktifSiparisler,
                                          operasyonOzeti: operasyonOzeti,
                                          yazicilar: _yazicilar,
                                          fireNowModu: _fireNowModu,
                                          sesliUyariAktif: _sesliUyariAktif,
                                          siparisGruplari:
                                              _siparisGruplariniOlustur(
                                                aktifSiparisler,
                                              ),
                                          paketlemeDurumuGetir:
                                              _paketlemeDurumuGetir,
                                          paketlemeDurumuGuncelle:
                                              _paketlemeDurumuGuncelle,
                                          mutfakNotuGetir: (String siparisId) =>
                                              _mutfakNotlari[siparisId] ?? '',
                                          mutfakNotuDuzenle: _mutfakNotuDuzenle,
                                        ),
                                        const SizedBox(height: 12),
                                        _MutfakKanalDagilimSeridi(
                                          siparisler: aktifSiparisler,
                                        ),
                                        const SizedBox(height: 12),
                                        const _BolumBasligi(
                                          metin: 'Altyapi ve cihazlar',
                                        ),
                                        const SizedBox(height: 10),
                                        _MutfakIstasyonSeridi(
                                          istasyonYukleri:
                                              operasyonOzeti.istasyonYukleri,
                                        ),
                                        const SizedBox(height: 12),
                                        _MutfakYaziciSeridi(
                                          yazicilar: _yazicilar,
                                          kuyruk: yaziciKuyrugu,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : ListView(
                            padding: const EdgeInsets.all(14),
                            children: [
                              _MutfakNavigasyonSeridi(mobil: true),
                              const SizedBox(height: 16),
                              const _BolumBasligi(
                                metin: 'Komuta ve filtre',
                                aciklama:
                                    'Yenileme, gecikme filtresi ve teslimat secimi.',
                              ),
                              const SizedBox(height: 10),
                              _MutfakKontrolSeridi(
                                sadeceGecikenleriGoster:
                                    _sadeceGecikenleriGoster,
                                otomatikYenilemeAktif: _otomatikYenilemeAktif,
                                sonYenilemeZamani: _sonYenilemeZamani,
                                sadeceGecikenleriDegistir:
                                    _sadeceGecikenleriDegistir,
                                otomatikYenilemeyiDegistir:
                                    _otomatikYenilemeyiDegistir,
                                fireNowModu: _fireNowModu,
                                fireNowModunuDegistir: _fireNowModunuDegistir,
                                sesliUyariAktif: _sesliUyariAktif,
                                sesliUyariyiDegistir: _sesliUyariyiDegistir,
                                elleYenile: () => _yukle(),
                              ),
                              const SizedBox(height: 16),
                              _TeslimatFiltreSeridi(
                                seciliFiltre: _seciliFiltre,
                                filtreDegistir: widget.viewModel.filtreSec,
                              ),
                              const SizedBox(height: 16),
                              const _BolumBasligi(
                                metin: 'Siparis akisi',
                                aciklama: 'Asama kartlarini asagidan yonet.',
                              ),
                              const SizedBox(height: 10),
                              _DurumPanosu(
                                masaustu: false,
                                yeniSiparisler: yeniSiparisler,
                                hazirlananlar: hazirlananlar,
                                hazirlar: hazirlar,
                                kapanisAkisi: kapanisAkisi,
                                aksiyonCalistir: _durumIlerle,
                                iptalCalistir: _siparisiIptalEt,
                                aksiyonAktifMi: durumIlerletmeYetkisiVar,
                                iptalAktifMi: siparisIptalYetkisiVar,
                                siparisTahminleri:
                                    operasyonOzeti.siparisTahminleri,
                              ),
                              const SizedBox(height: 16),
                              const _BolumBasligi(metin: 'Operasyon izleme'),
                              const SizedBox(height: 10),
                              _MutfakOzetSeridi(
                                siparisler: filtrelenmisSiparisler,
                                operasyonOzeti: operasyonOzeti,
                              ),
                              const SizedBox(height: 16),
                              _MutfakAlarmSeridi(
                                uyarilar: operasyonOzeti.gecikmeUyarilari,
                              ),
                              const SizedBox(height: 16),
                              _MutfakOncelikSeridi(siparisler: aktifSiparisler),
                              const SizedBox(height: 16),
                              _MutfakGelismisPaneli(
                                siparisler: aktifSiparisler,
                                operasyonOzeti: operasyonOzeti,
                                yazicilar: _yazicilar,
                                fireNowModu: _fireNowModu,
                                sesliUyariAktif: _sesliUyariAktif,
                                siparisGruplari: _siparisGruplariniOlustur(
                                  aktifSiparisler,
                                ),
                                paketlemeDurumuGetir: _paketlemeDurumuGetir,
                                paketlemeDurumuGuncelle:
                                    _paketlemeDurumuGuncelle,
                                mutfakNotuGetir: (String siparisId) =>
                                    _mutfakNotlari[siparisId] ?? '',
                                mutfakNotuDuzenle: _mutfakNotuDuzenle,
                              ),
                              const SizedBox(height: 16),
                              _MutfakKanalDagilimSeridi(
                                siparisler: aktifSiparisler,
                              ),
                              const SizedBox(height: 16),
                              const _BolumBasligi(metin: 'Altyapi ve cihazlar'),
                              const SizedBox(height: 10),
                              _MutfakIstasyonSeridi(
                                istasyonYukleri: operasyonOzeti.istasyonYukleri,
                              ),
                              const SizedBox(height: 16),
                              _MutfakYaziciSeridi(
                                yazicilar: _yazicilar,
                                kuyruk: yaziciKuyrugu,
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

class _BolumBasligi extends StatelessWidget {
  const _BolumBasligi({required this.metin, this.aciklama});

  final String metin;
  final String? aciklama;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          metin,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.86),
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (aciklama != null) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            aciklama!,
            style: TextStyle(
              color: _renkMetinIkincil,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _SiparisGrubuOzet {
  const _SiparisGrubuOzet({
    required this.grupEtiketi,
    required this.siparisSayisi,
    required this.toplamKalemSayisi,
  });

  final String grupEtiketi;
  final int siparisSayisi;
  final int toplamKalemSayisi;
}

class _PaketlemeTakipDurumu {
  const _PaketlemeTakipDurumu({
    this.hazirlandi = false,
    this.paketlendi = false,
    this.teslimeCikti = false,
  });

  final bool hazirlandi;
  final bool paketlendi;
  final bool teslimeCikti;

  _PaketlemeTakipDurumu copyWith({
    bool? hazirlandi,
    bool? paketlendi,
    bool? teslimeCikti,
  }) {
    return _PaketlemeTakipDurumu(
      hazirlandi: hazirlandi ?? this.hazirlandi,
      paketlendi: paketlendi ?? this.paketlendi,
      teslimeCikti: teslimeCikti ?? this.teslimeCikti,
    );
  }
}

class _MutfakGelismisPaneli extends StatelessWidget {
  const _MutfakGelismisPaneli({
    required this.siparisler,
    required this.operasyonOzeti,
    required this.yazicilar,
    required this.fireNowModu,
    required this.sesliUyariAktif,
    required this.siparisGruplari,
    required this.paketlemeDurumuGetir,
    required this.paketlemeDurumuGuncelle,
    required this.mutfakNotuGetir,
    required this.mutfakNotuDuzenle,
  });

  final List<SiparisVarligi> siparisler;
  final MutfakOperasyonOzetiVarligi operasyonOzeti;
  final List<YaziciDurumuVarligi> yazicilar;
  final bool fireNowModu;
  final bool sesliUyariAktif;
  final List<_SiparisGrubuOzet> siparisGruplari;
  final _PaketlemeTakipDurumu Function(String siparisId) paketlemeDurumuGetir;
  final _PaketlemeDurumGuncelle paketlemeDurumuGuncelle;
  final String Function(String siparisId) mutfakNotuGetir;
  final ValueChanged<SiparisVarligi> mutfakNotuDuzenle;

  @override
  Widget build(BuildContext context) {
    final DateTime simdi = DateTime.now();
    final List<SiparisVarligi> oncelikListesi =
        List<SiparisVarligi>.from(siparisler)..sort(
          (SiparisVarligi a, SiparisVarligi b) => _mutfakOnceligiSkoru(
            b,
            simdi,
          ).compareTo(_mutfakOnceligiSkoru(a, simdi)),
        );
    final List<SiparisVarligi> paketSiparisleri = siparisler
        .where(
          (SiparisVarligi siparis) =>
              siparis.teslimatTipi == TeslimatTipi.paketServis,
        )
        .take(4)
        .toList(growable: false);
    final int bagliYaziciSayisi = yazicilar
        .where(
          (YaziciDurumuVarligi yazici) =>
              yazici.durum == YaziciBaglantiDurumu.bagli,
        )
        .length;
    final double gecikmeOrani = siparisler.isEmpty
        ? 0
        : operasyonOzeti.gecikenSiparisSayisi / siparisler.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[_renkPanelYuksek, _renkPanel],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _renkCerceve),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Gelismis mutfak panelleri',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          _GelisimBlok(
            baslik: '1) Siparis birlestirme',
            icerik: siparisGruplari.isEmpty
                ? 'Birlesmeye uygun grup yok.'
                : siparisGruplari
                      .take(3)
                      .map(
                        (_SiparisGrubuOzet grup) =>
                            '${grup.grupEtiketi} (${grup.siparisSayisi} siparis / ${grup.toplamKalemSayisi} kalem)',
                      )
                      .join('\n'),
          ),
          _GelisimBlok(
            baslik: '2) Hazirlik SLA',
            icerik: 'Firin 18 dk • Izgara 14 dk • Soguk 10 dk • Paket +4 dk',
          ),
          _GelisimBlok(
            baslik: '3) Istasyon atama',
            icerik: operasyonOzeti.istasyonYukleri.isEmpty
                ? 'Istasyon yuku verisi yok.'
                : operasyonOzeti.istasyonYukleri
                      .take(3)
                      .map(
                        (MutfakIstasyonYukuVarligi y) =>
                            '${y.istasyonAdi}: ${y.aktifSiparisSayisi} is',
                      )
                      .join(' • '),
          ),
          _GelisimBlok(
            baslik: '4) Oncelik motoru',
            icerik: oncelikListesi.isEmpty
                ? 'Onceliklendirilecek aktif siparis yok.'
                : oncelikListesi
                      .take(3)
                      .map(
                        (SiparisVarligi siparis) =>
                            '${siparis.siparisNo} (skor ${_mutfakOnceligiSkoru(siparis, simdi)})',
                      )
                      .join(' • '),
          ),
          _GelisimBlok(
            baslik: '5) Fire Now modu',
            icerik: fireNowModu
                ? 'Aktif: sadece gecikme odakli akis gosteriliyor.'
                : 'Pasif: normal mutfak akis gorunumu.',
          ),
          _GelisimBlok(
            baslik: '6) Paketleme kontrolu',
            icerikWidget: paketSiparisleri.isEmpty
                ? const Text(
                    'Paket siparisi yok.',
                    style: TextStyle(color: Color(0xFFBFB6CA)),
                  )
                : Column(
                    children: paketSiparisleri
                        .map((SiparisVarligi siparis) {
                          final _PaketlemeTakipDurumu durum =
                              paketlemeDurumuGetir(siparis.id);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    siparis.siparisNo,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Checkbox(
                                  value: durum.hazirlandi,
                                  onChanged: (bool? deger) {
                                    paketlemeDurumuGuncelle(
                                      siparis.id,
                                      hazirlandi: deger ?? false,
                                    );
                                  },
                                ),
                                Checkbox(
                                  value: durum.paketlendi,
                                  onChanged: (bool? deger) {
                                    paketlemeDurumuGuncelle(
                                      siparis.id,
                                      paketlendi: deger ?? false,
                                    );
                                  },
                                ),
                                Checkbox(
                                  value: durum.teslimeCikti,
                                  onChanged: (bool? deger) {
                                    paketlemeDurumuGuncelle(
                                      siparis.id,
                                      teslimeCikti: deger ?? false,
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        })
                        .toList(growable: false),
                  ),
          ),
          _GelisimBlok(
            baslik: '7) Yazici guvenligi',
            icerik: bagliYaziciSayisi == yazicilar.length
                ? 'Tum yazicilar aktif, yedek rota hazir.'
                : 'Yedek mod devrede: bagli $bagliYaziciSayisi / ${yazicilar.length}.',
          ),
          _GelisimBlok(
            baslik: '8) Mutfak notlari',
            icerikWidget: Column(
              children: siparisler
                  .take(3)
                  .map((SiparisVarligi siparis) {
                    final String not = mutfakNotuGetir(siparis.id);
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        siparis.siparisNo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        not.isEmpty ? 'Not yok' : not,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () => mutfakNotuDuzenle(siparis),
                        icon: const Icon(Icons.edit_note_rounded),
                        color: _renkUcuncul,
                      ),
                    );
                  })
                  .toList(growable: false),
            ),
          ),
          _GelisimBlok(
            baslik: '9) Sesli uyari',
            icerik: sesliUyariAktif
                ? 'Aktif: yeni kritiklerde sistem uyarisi calar.'
                : 'Pasif: sesli uyari kapali.',
          ),
          _GelisimBlok(
            baslik: '10) Performans paneli',
            icerikWidget: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                _KucukPerformansRozeti(
                  etiket: 'Gecikme',
                  deger: '%${(gecikmeOrani * 100).toStringAsFixed(0)}',
                ),
                _KucukPerformansRozeti(
                  etiket: 'Kalan sure',
                  deger: '${operasyonOzeti.toplamKalanDakika} dk',
                ),
                _KucukPerformansRozeti(
                  etiket: 'Ortalama',
                  deger: '${operasyonOzeti.ortalamaKalanDakika} dk',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GelisimBlok extends StatelessWidget {
  const _GelisimBlok({required this.baslik, this.icerik, this.icerikWidget});

  final String baslik;
  final String? icerik;
  final Widget? icerikWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              baslik,
              style: const TextStyle(
                color: Color(0xFFFFD36E),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            if (icerikWidget != null)
              icerikWidget!
            else
              Text(
                icerik ?? '',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _KucukPerformansRozeti extends StatelessWidget {
  const _KucukPerformansRozeti({required this.etiket, required this.deger});

  final String etiket;
  final String deger;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _renkCerceve,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$etiket: $deger',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DurumPanosu extends StatelessWidget {
  const _DurumPanosu({
    required this.masaustu,
    required this.yeniSiparisler,
    required this.hazirlananlar,
    required this.hazirlar,
    required this.kapanisAkisi,
    required this.aksiyonCalistir,
    required this.iptalCalistir,
    required this.aksiyonAktifMi,
    required this.iptalAktifMi,
    required this.siparisTahminleri,
  });

  final bool masaustu;
  final List<SiparisVarligi> yeniSiparisler;
  final List<SiparisVarligi> hazirlananlar;
  final List<SiparisVarligi> hazirlar;
  final List<SiparisVarligi> kapanisAkisi;
  final ValueChanged<SiparisVarligi> aksiyonCalistir;
  final ValueChanged<SiparisVarligi> iptalCalistir;
  final bool aksiyonAktifMi;
  final bool iptalAktifMi;
  final Map<String, MutfakSiparisTahminiVarligi> siparisTahminleri;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double bosluk = 14;
        final int hedefKolonSayisi = masaustu
            ? (constraints.maxWidth > 1500 ? 3 : 2)
            : 1;
        final double kartGenisligi = masaustu
            ? (constraints.maxWidth - (hedefKolonSayisi - 1) * bosluk) /
                  hedefKolonSayisi
            : constraints.maxWidth;
        final double kartYuksekligi = masaustu ? 500 : 370;

        return Wrap(
          spacing: bosluk,
          runSpacing: bosluk,
          children: <Widget>[
            _durumKartSarmalayici(
              genislik: kartGenisligi,
              kart: _DurumKolonu(
                baslik: 'Yeni',
                aciklama: 'Mutfaga yeni dusen siparisler',
                bosDurumMetni: 'Bu filtrede yeni siparis yok',
                vurguRengi: _renkBirincil,
                siparisler: yeniSiparisler,
                aksiyonCalistir: aksiyonCalistir,
                iptalCalistir: iptalCalistir,
                aksiyonAktifMi: aksiyonAktifMi,
                iptalAktifMi: iptalAktifMi,
                siparisTahminleri: siparisTahminleri,
                yukseklik: kartYuksekligi,
              ),
            ),
            _durumKartSarmalayici(
              genislik: kartGenisligi,
              kart: _DurumKolonu(
                baslik: 'Hazirlaniyor',
                aciklama: 'Aktif mutfak operasyonu',
                bosDurumMetni: 'Su an mutfakta aktif siparis yok',
                vurguRengi: _renkIkincil,
                siparisler: hazirlananlar,
                aksiyonCalistir: aksiyonCalistir,
                iptalCalistir: iptalCalistir,
                aksiyonAktifMi: aksiyonAktifMi,
                iptalAktifMi: iptalAktifMi,
                siparisTahminleri: siparisTahminleri,
                yukseklik: kartYuksekligi,
              ),
            ),
            _durumKartSarmalayici(
              genislik: kartGenisligi,
              kart: _DurumKolonu(
                baslik: 'Hazir',
                aciklama: 'Servis veya teslim bekleyenler',
                bosDurumMetni: 'Bekleyen hazir siparis yok',
                vurguRengi: _renkBasari,
                siparisler: hazirlar,
                aksiyonCalistir: aksiyonCalistir,
                iptalCalistir: iptalCalistir,
                aksiyonAktifMi: aksiyonAktifMi,
                iptalAktifMi: iptalAktifMi,
                siparisTahminleri: siparisTahminleri,
                yukseklik: kartYuksekligi,
              ),
            ),
            _durumKartSarmalayici(
              genislik: kartGenisligi,
              kart: _DurumKolonu(
                baslik: 'Kapanis',
                aciklama: 'Dagitim ve teslim kapanisi',
                bosDurumMetni: 'Kapanis akisinda siparis yok',
                vurguRengi: _renkCanliMavi,
                siparisler: kapanisAkisi,
                aksiyonCalistir: aksiyonCalistir,
                iptalCalistir: iptalCalistir,
                aksiyonAktifMi: aksiyonAktifMi,
                iptalAktifMi: iptalAktifMi,
                siparisTahminleri: siparisTahminleri,
                yukseklik: kartYuksekligi,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _durumKartSarmalayici({
    required double genislik,
    required Widget kart,
  }) {
    return SizedBox(width: genislik, child: kart);
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
        color: _renkPanel,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _renkCerceve),
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
                  backgroundColor: _renkBirincil,
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
                  backgroundColor: _renkIkincil,
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
                  backgroundColor: _renkPanelYuksek,
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
                  side: BorderSide(color: _renkUcuncul.withValues(alpha: 0.35)),
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
        color: _renkPanel,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _renkCerceve),
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
  const _MutfakOzetSeridi({
    required this.siparisler,
    required this.operasyonOzeti,
  });

  final List<SiparisVarligi> siparisler;
  final MutfakOperasyonOzetiVarligi operasyonOzeti;

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
          vurguRengi: _renkBirincil,
          ikon: Icons.restaurant_menu_rounded,
        ),
        _OzetKarti(
          baslik: 'Acil hat',
          deger: '${acilSiparisler.length}',
          aciklama: '20 dakikayi gecen siparis',
          vurguRengi: _renkIkincil,
          ikon: Icons.priority_high_rounded,
        ),
        _OzetKarti(
          baslik: 'Ortalama sure',
          deger: '$ortalamaDakika dk',
          aciklama: 'Aktif siparislerde ortalama bekleme',
          vurguRengi: _renkCanliMavi,
          ikon: Icons.schedule_rounded,
        ),
        _OzetKarti(
          baslik: 'Tahmini kalan',
          deger: '${operasyonOzeti.toplamKalanDakika} dk',
          aciklama: operasyonOzeti.gecikenSiparisSayisi == 0
              ? 'Mevcut tempoda mutfak cikis tahmini'
              : '${operasyonOzeti.gecikenSiparisSayisi} siparis gecikme alarminda',
          vurguRengi: operasyonOzeti.gecikenSiparisSayisi == 0
              ? _renkBasari
              : _renkBirincil,
          ikon: Icons.timelapse_rounded,
        ),
      ],
    );
  }
}

class _MutfakAlarmSeridi extends StatelessWidget {
  const _MutfakAlarmSeridi({required this.uyarilar});

  final List<MutfakGecikmeUyarisiVarligi> uyarilar;

  @override
  Widget build(BuildContext context) {
    final List<MutfakGecikmeUyarisiVarligi> kritikler = uyarilar
        .take(3)
        .toList();
    final bool alarmVar = kritikler.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: alarmVar ? _renkAlarmYuzey : _renkBasariYuzey,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: alarmVar
              ? _renkBirincil.withValues(alpha: 0.45)
              : _renkBasari.withValues(alpha: 0.38),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                alarmVar ? Icons.warning_amber_rounded : Icons.task_alt_rounded,
                color: alarmVar ? _renkBirincil : _renkBasari,
              ),
              const SizedBox(width: 8),
              Text(
                alarmVar ? 'Gecikme alarmlari' : 'Gecikme alarmi yok',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (!alarmVar)
            Text(
              'Aktif siparisler hedef hazirlik suresi icinde ilerliyor.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.78),
                fontWeight: FontWeight.w600,
              ),
            )
          else
            ...kritikler.map((MutfakGecikmeUyarisiVarligi uyari) {
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '${uyari.siparisNo} (${uyari.istasyonAdi}) +${uyari.gecikmeDakikasi} dk gecikti',
                  style: TextStyle(
                    color: const Color(0xFFFFCCBC),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _MutfakIstasyonSeridi extends StatelessWidget {
  const _MutfakIstasyonSeridi({required this.istasyonYukleri});

  final List<MutfakIstasyonYukuVarligi> istasyonYukleri;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _renkPanel,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _renkCerceve),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Istasyon bazli is paylasimi',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          if (istasyonYukleri.isEmpty)
            Text(
              'Aktif mutfak istasyonu yuk verisi henuz olusmadi.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontWeight: FontWeight.w600,
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: istasyonYukleri
                    .map((MutfakIstasyonYukuVarligi istasyon) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                          width: 210,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  istasyon.istasyonAdi,
                                  style: TextStyle(
                                    color: _renkUcuncul,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${istasyon.aktifSiparisSayisi} aktif siparis',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${istasyon.toplamKalanDakika} dk tahmini kalan',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.72),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                    .toList(growable: false),
              ),
            ),
        ],
      ),
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
            vurguRengi: _renkBirincil,
          ),
        ),
        SizedBox(
          width: 360,
          child: _OncelikKarti(
            baslik: 'Siradaki hazirlik',
            aciklama: siradaki == null
                ? 'Yedek operasyon sirasi bos.'
                : '${siradaki.siparisNo} ikinci sirada. ${_siparisKisaDurumMetni(siradaki, simdi)}',
            vurguRengi: _renkCanliMavi,
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
        color: _renkPanel,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _renkCerceve),
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
          vurguRengi: _renkUcuncul,
        ),
        _KanalKarti(
          baslik: 'Gel al',
          adet: gelAlSayisi,
          aciklama: 'Tezgahtan teslim alinacak siparis',
          vurguRengi: _renkCanliMavi,
        ),
        _KanalKarti(
          baslik: 'Paket',
          adet: paketSayisi,
          aciklama: 'Kurye veya paket cikari bekleyen siparis',
          vurguRengi: _renkBasari,
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
          color: _renkPanel,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _renkCerceve),
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

class _MutfakKontrolSeridi extends StatelessWidget {
  const _MutfakKontrolSeridi({
    required this.sadeceGecikenleriGoster,
    required this.otomatikYenilemeAktif,
    required this.sonYenilemeZamani,
    required this.sadeceGecikenleriDegistir,
    required this.otomatikYenilemeyiDegistir,
    required this.fireNowModu,
    required this.fireNowModunuDegistir,
    required this.sesliUyariAktif,
    required this.sesliUyariyiDegistir,
    required this.elleYenile,
  });

  final bool sadeceGecikenleriGoster;
  final bool otomatikYenilemeAktif;
  final DateTime? sonYenilemeZamani;
  final ValueChanged<bool> sadeceGecikenleriDegistir;
  final ValueChanged<bool> otomatikYenilemeyiDegistir;
  final bool fireNowModu;
  final ValueChanged<bool> fireNowModunuDegistir;
  final bool sesliUyariAktif;
  final ValueChanged<bool> sesliUyariyiDegistir;
  final VoidCallback elleYenile;

  @override
  Widget build(BuildContext context) {
    final String yenilemeMetni = sonYenilemeZamani == null
        ? 'Henuz yenilenmedi'
        : '${_ikiHane(sonYenilemeZamani!.hour)}:${_ikiHane(sonYenilemeZamani!.minute)}:${_ikiHane(sonYenilemeZamani!.second)}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[_renkPanel, _renkPanelYuksek],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _renkCerceve),
      ),
      child: Wrap(
        spacing: 14,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          FilterChip(
            selected: sadeceGecikenleriGoster,
            onSelected: sadeceGecikenleriDegistir,
            showCheckmark: false,
            label: const Text('Sadece gecikenleri goster'),
            labelStyle: TextStyle(
              color: sadeceGecikenleriGoster ? Colors.white : _renkMetinIkincil,
              fontWeight: FontWeight.w700,
            ),
            selectedColor: _renkBirincil,
            backgroundColor: _renkPanelYuksek,
            side: BorderSide(color: _renkUcuncul.withValues(alpha: 0.35)),
          ),
          FilterChip(
            selected: fireNowModu,
            onSelected: fireNowModunuDegistir,
            showCheckmark: false,
            avatar: Icon(
              Icons.flash_on_rounded,
              size: 16,
              color: fireNowModu ? Colors.white : _renkMetinIkincil,
            ),
            label: const Text('Fire Now'),
            labelStyle: TextStyle(
              color: fireNowModu ? Colors.white : _renkMetinIkincil,
              fontWeight: FontWeight.w800,
            ),
            selectedColor: _renkIkincil,
            backgroundColor: _renkPanelYuksek,
            side: BorderSide(color: _renkUcuncul.withValues(alpha: 0.35)),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.autorenew_rounded,
                color: _renkMetinIkincil,
                size: 18,
              ),
              const SizedBox(width: 6),
              const Text(
                'Otomatik yenile',
                style: TextStyle(
                  color: _renkMetinIkincil,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Switch(
                value: otomatikYenilemeAktif,
                onChanged: otomatikYenilemeyiDegistir,
                activeThumbColor: _renkBasari,
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                sesliUyariAktif
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
                color: _renkMetinIkincil,
                size: 18,
              ),
              const SizedBox(width: 6),
              const Text(
                'Sesli uyari',
                style: TextStyle(
                  color: _renkMetinIkincil,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Switch(
                value: sesliUyariAktif,
                onChanged: sesliUyariyiDegistir,
                activeThumbColor: _renkUcuncul,
              ),
            ],
          ),
          FilledButton.tonalIcon(
            onPressed: elleYenile,
            style: FilledButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: _renkPanelYuksek,
            ),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Simdi yenile'),
          ),
          Text(
            'Son yenileme: $yenilemeMetni',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.74),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _ikiHane(int deger) => deger.toString().padLeft(2, '0');
}

class _OzetKarti extends StatelessWidget {
  const _OzetKarti({
    required this.baslik,
    required this.deger,
    required this.aciklama,
    required this.vurguRengi,
    required this.ikon,
  });

  final String baslik;
  final String deger;
  final String aciklama;
  final Color vurguRengi;
  final IconData ikon;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 280),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[_renkPanel, vurguRengi.withValues(alpha: 0.14)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _renkCerceve),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                Icon(ikon, color: vurguRengi, size: 18),
                const SizedBox(width: 8),
                Text(
                  baslik,
                  style: TextStyle(
                    color: vurguRengi,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              deger,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
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
                    color: seciliMi ? Colors.white : _renkMetinIkincil,
                    fontWeight: FontWeight.w800,
                  ),
                  side: BorderSide(color: _renkUcuncul.withValues(alpha: 0.35)),
                  backgroundColor: _renkPanelYuksek,
                  selectedColor: _renkBirincil,
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
    required this.siparisTahminleri,
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
  final Map<String, MutfakSiparisTahminiVarligi> siparisTahminleri;
  final double? yukseklik;

  @override
  Widget build(BuildContext context) {
    final List<SiparisVarligi> gorunenSiparisler =
        List<SiparisVarligi>.from(siparisler)..sort((
          SiparisVarligi a,
          SiparisVarligi b,
        ) {
          final MutfakSiparisTahminiVarligi? aTahmin = siparisTahminleri[a.id];
          final MutfakSiparisTahminiVarligi? bTahmin = siparisTahminleri[b.id];
          final int aGecikme = aTahmin?.gecikmeDakikasi ?? 0;
          final int bGecikme = bTahmin?.gecikmeDakikasi ?? 0;
          if (aGecikme != bGecikme) {
            return bGecikme.compareTo(aGecikme);
          }
          final int aKalan = aTahmin?.kalanDakika ?? 9999;
          final int bKalan = bTahmin?.kalanDakika ?? 9999;
          if (aKalan != bKalan) {
            return aKalan.compareTo(bKalan);
          }
          return a.olusturmaTarihi.compareTo(b.olusturmaTarihi);
        });

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
            itemCount: gorunenSiparisler.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              final SiparisVarligi siparis = gorunenSiparisler[index];
              return _MutfakSiparisKarti(
                siparis: siparis,
                vurguRengi: vurguRengi,
                aksiyonCalistir: () => aksiyonCalistir(siparis),
                iptalCalistir: () => iptalCalistir(siparis),
                aksiyonAktifMi: aksiyonAktifMi,
                iptalAktifMi: iptalAktifMi,
                siparisTahmini: siparisTahminleri[siparis.id],
              );
            },
          );

    return Container(
      width: double.infinity,
      height: yukseklik,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[_renkPanel, vurguRengi.withValues(alpha: 0.12)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _renkCerceve),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: vurguRengi.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_durumIkonu(baslik), color: vurguRengi, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      baslik,
                      style: TextStyle(
                        color: vurguRengi,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      aciklama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.68),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${siparisler.length}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
    this.siparisTahmini,
  });

  final SiparisVarligi siparis;
  final Color vurguRengi;
  final VoidCallback aksiyonCalistir;
  final VoidCallback iptalCalistir;
  final bool aksiyonAktifMi;
  final bool iptalAktifMi;
  final MutfakSiparisTahminiVarligi? siparisTahmini;

  @override
  Widget build(BuildContext context) {
    final DateTime simdi = DateTime.now();
    final int beklemeDakikasi = _beklemeDakikasi(siparis, simdi);
    final Color sureRengi = _sureVurguRengi(beklemeDakikasi);
    final String? aksiyonEtiketi = _aksiyonEtiketi(siparis);
    final String kalemOzeti = _kisaKalemOzeti(siparis.kalemler);
    final String ekBilgi = _siparisEkBilgiMetni(siparis);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Colors.white.withValues(alpha: 0.05),
            vurguRengi.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: _renkCerceve),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      siparis.siparisNo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
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
                children: <Widget>[
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
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _BilgiRozeti(
                ikon: Icons.flag_rounded,
                metin: _oncelikEtiketi(beklemeDakikasi),
                renk: sureRengi,
              ),
              if (siparisTahmini != null)
                _BilgiRozeti(
                  ikon: Icons.timer_rounded,
                  metin: 'Tahmini ${siparisTahmini!.kalanDakika} dk',
                  renk: siparisTahmini!.gecikiyorMu
                      ? _renkBirincil
                      : _renkBasari,
                ),
              _BilgiRozeti(
                ikon: Icons.payments_rounded,
                metin: _paraYaz(siparis.toplamTutar),
                renk: _renkCanliMavi,
              ),
              if (siparis.paketTeslimatDurumu != null)
                _BilgiRozeti(
                  ikon: Icons.local_shipping_rounded,
                  metin: _paketTeslimatDurumuEtiketi(
                    siparis.paketTeslimatDurumu!,
                  ),
                  renk: _renkBirincil,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.timelapse_rounded, color: sureRengi, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _sureAciklamasi(
                      beklemeDakikasi,
                      siparisTahmini: siparisTahmini,
                    ),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.84),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            kalemOzeti,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.84),
              fontWeight: FontWeight.w700,
            ),
          ),
          if (ekBilgi.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              ekBilgi,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.66),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (aksiyonEtiketi != null) ...<Widget>[
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton(
                    onPressed: aksiyonAktifMi ? aksiyonCalistir : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: vurguRengi,
                      foregroundColor: _renkArkaPlanKoyu,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
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
  return simdi.difference(siparis.olusturmaTarihi).inMinutes.clamp(0, 180);
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

String _kisaKalemOzeti(List<SiparisKalemiVarligi> kalemler) {
  if (kalemler.isEmpty) {
    return 'Kalem bilgisi bulunamadi';
  }
  final List<String> parcalar = kalemler.take(2).map((
    SiparisKalemiVarligi kalem,
  ) {
    final String secenek = kalem.secenekAdi == null
        ? ''
        : ' / ${kalem.secenekAdi}';
    return '${kalem.adet}x ${kalem.urunAdi}$secenek';
  }).toList();
  final int kalan = kalemler.length - parcalar.length;
  if (kalan > 0) {
    parcalar.add('+$kalan urun daha');
  }
  return parcalar.join(' • ');
}

String _siparisEkBilgiMetni(SiparisVarligi siparis) {
  final List<String> parcalar = <String>[];
  if (siparis.kaynak != null && siparis.kaynak!.isNotEmpty) {
    parcalar.add('Kaynak: ${siparis.kaynak}');
  }
  if (siparis.kuryeAdi != null && siparis.kuryeAdi!.isNotEmpty) {
    parcalar.add('Kurye: ${siparis.kuryeAdi}');
  }
  if (siparis.teslimatNotu != null && siparis.teslimatNotu!.isNotEmpty) {
    parcalar.add('Not: ${siparis.teslimatNotu}');
  }
  return parcalar.join(' • ');
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
    return _renkBirincil;
  }
  if (dakika >= 12) {
    return _renkIkincil;
  }
  return _renkBasari;
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

IconData _durumIkonu(String baslik) {
  switch (baslik) {
    case 'Yeni':
      return Icons.fiber_new_rounded;
    case 'Hazirlaniyor':
      return Icons.soup_kitchen_rounded;
    case 'Hazir':
      return Icons.task_alt_rounded;
    case 'Kapanis':
      return Icons.local_shipping_rounded;
    default:
      return Icons.list_alt_rounded;
  }
}

String _sureAciklamasi(
  int dakika, {
  MutfakSiparisTahminiVarligi? siparisTahmini,
}) {
  if (siparisTahmini != null) {
    if (siparisTahmini.gecikiyorMu) {
      return 'Hedef sure asildi, +${siparisTahmini.gecikmeDakikasi} dk gecikme var';
    }
    return '${siparisTahmini.istasyonAdi} istasyonunda hedef ${siparisTahmini.hedefHazirlikDakikasi} dk';
  }
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
