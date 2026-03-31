import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/stok_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/patron_raporu_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/saatlik_siparis_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/sistem_yazici_adayi_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_is_kuyrugu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yonetim_paneli_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/servisler/yonetim_raporu_hesaplayici.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/servisler/yazici_is_kuyrugu_hesaplayici.dart';

class YonetimPaneliSayfasi extends StatefulWidget {
  const YonetimPaneliSayfasi({super.key});

  @override
  State<YonetimPaneliSayfasi> createState() => _YonetimPaneliSayfasiState();
}

class _YonetimPaneliSayfasiState extends State<YonetimPaneliSayfasi> {
  final ServisKaydi _servisKaydi = ServisKaydi.ortak;
  final TextEditingController _aramaDenetleyici = TextEditingController();

  bool _yukleniyor = true;
  List<SiparisVarligi> _siparisler = const <SiparisVarligi>[];
  List<YaziciDurumuVarligi> _yazicilar = const <YaziciDurumuVarligi>[];
  List<SistemYaziciAdayiVarligi> _sistemYazicilari =
      const <SistemYaziciAdayiVarligi>[];
  List<PersonelDurumuVarligi> _personeller = const <PersonelDurumuVarligi>[];
  List<SalonBolumuVarligi> _salonBolumleri = const <SalonBolumuVarligi>[];
  List<KategoriVarligi> _menuKategorileri = const <KategoriVarligi>[];
  List<UrunVarligi> _menuUrunleri = const <UrunVarligi>[];
  StokOzetiVarligi? _stokOzeti;
  _PanelFiltre _seciliFiltre = _PanelFiltre.tumu;
  _ZamanFiltresi _seciliZamanFiltresi = _ZamanFiltresi.bugun;
  _SiparisSirasi _seciliSiralama = _SiparisSirasi.enYeni;
  String _aramaMetni = '';

  @override
  void initState() {
    super.initState();
    _yukle();
  }

  @override
  void dispose() {
    _aramaDenetleyici.dispose();
    super.dispose();
  }

  Future<void> _yukle() async {
    final List<SiparisVarligi> siparisler = await _servisKaydi
        .siparisleriGetirUseCase();
    final List<PersonelDurumuVarligi> personeller = await _servisKaydi
        .personelleriGetirUseCase();
    final List<SistemYaziciAdayiVarligi> sistemYazicilari = await _servisKaydi
        .sistemYazicilariniGetirUseCase();
    final List<YaziciDurumuVarligi> yazicilar = await _servisKaydi
        .yazicilariGetirUseCase();
    final List<SalonBolumuVarligi> salonBolumleri = await _servisKaydi
        .salonBolumleriniGetirUseCase();
    final List<KategoriVarligi> menuKategorileri = await _servisKaydi
        .kategorileriGetirUseCase();
    final List<UrunVarligi> menuUrunleri = await _servisKaydi
        .urunleriGetirUseCase();
    final StokOzetiVarligi stokOzeti = await _servisKaydi
        .stokOzetiGetirUseCase();

    if (!mounted) {
      return;
    }

    setState(() {
      _siparisler = siparisler;
      _yazicilar = yazicilar;
      _sistemYazicilari = sistemYazicilari;
      _personeller = personeller;
      _salonBolumleri = salonBolumleri;
      _menuKategorileri = menuKategorileri;
      _menuUrunleri = menuUrunleri;
      _stokOzeti = stokOzeti;
      _yukleniyor = false;
    });
  }

  Future<void> _yazicilariYenile() async {
    final List<YaziciDurumuVarligi> yazicilar = await _servisKaydi
        .yazicilariGetirUseCase();
    final List<SistemYaziciAdayiVarligi> sistemYazicilari = await _servisKaydi
        .sistemYazicilariniGetirUseCase();

    if (!mounted) {
      return;
    }

    setState(() {
      _yazicilar = yazicilar;
      _sistemYazicilari = sistemYazicilari;
    });
  }

  Future<void> _yaziciEkle() async {
    final _YaziciFormSonucu? sonuc = await showDialog<_YaziciFormSonucu>(
      context: context,
      builder: (BuildContext context) {
        return _YaziciFormDialog(sistemYazicilari: _sistemYazicilari);
      },
    );

    if (sonuc == null) {
      return;
    }

    await _servisKaydi.yaziciEkleUseCase(
      YaziciDurumuVarligi(
        id: 'yzc_${DateTime.now().microsecondsSinceEpoch}',
        ad: sonuc.ad,
        rolEtiketi: sonuc.rolEtiketi,
        baglantiNoktasi: sonuc.baglantiNoktasi,
        aciklama: sonuc.aciklama,
        durum: sonuc.durum,
      ),
    );
    await _yazicilariYenile();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${sonuc.ad} eklendi')));
  }

  Future<void> _yaziciSil(YaziciDurumuVarligi yazici) async {
    await _servisKaydi.yaziciSilUseCase(yazici.id);
    await _yazicilariYenile();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${yazici.ad} kaldirildi')));
  }

  Future<void> _yaziciGuncelle(
    YaziciDurumuVarligi yazici, {
    String? rolEtiketi,
    YaziciBaglantiDurumu? durum,
  }) async {
    await _servisKaydi.yaziciGuncelleUseCase(
      yazici.copyWith(rolEtiketi: rolEtiketi, durum: durum),
    );
    await _yazicilariYenile();
  }

  Future<void> _yaziciYonetiminiAc() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return _YaziciYonetimiDialog(
          yazicilar: _yazicilar,
          siparisler: _siparisler,
          sistemYazicilari: _sistemYazicilari,
          yaziciEkle: _yaziciEkle,
          yaziciSil: _yaziciSil,
          yaziciGuncelle: _yaziciGuncelle,
        );
      },
    );
    await _yazicilariYenile();
  }

  Future<void> _yonetimVerileriniYenile() async {
    final List<SalonBolumuVarligi> salonBolumleri = await _servisKaydi
        .salonBolumleriniGetirUseCase();
    final List<KategoriVarligi> menuKategorileri = await _servisKaydi
        .kategorileriGetirUseCase();
    final List<UrunVarligi> menuUrunleri = await _servisKaydi
        .urunleriGetirUseCase();
    final StokOzetiVarligi stokOzeti = await _servisKaydi
        .stokOzetiGetirUseCase();

    if (!mounted) {
      return;
    }

    setState(() {
      _salonBolumleri = salonBolumleri;
      _menuKategorileri = menuKategorileri;
      _menuUrunleri = menuUrunleri;
      _stokOzeti = stokOzeti;
    });
  }

  Future<void> _yonetimAyarlariniAc([int baslangicSekmesi = 0]) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return _YonetimAyarlariDialog(
          salonBolumleri: _salonBolumleri,
          menuKategorileri: _menuKategorileri,
          menuUrunleri: _menuUrunleri,
          veriYenile: _yonetimVerileriniYenile,
          servisKaydi: _servisKaydi,
          baslangicSekmesi: baslangicSekmesi,
        );
      },
    );
    await _yonetimVerileriniYenile();
  }

  @override
  Widget build(BuildContext context) {
    final bool masaustu = EkranBoyutu.masaustu(context);
    final List<SiparisVarligi> filtreliSiparisler = _filtreliSiparisler;
    final YonetimPaneliOzetiVarligi ozet =
        YonetimRaporuHesaplayici.panelOzetiniHesapla(filtreliSiparisler);
    final List<SaatlikSiparisOzetiVarligi> saatlikVeriler =
        YonetimRaporuHesaplayici.saatlikVeriUret(filtreliSiparisler);

    return Scaffold(
      backgroundColor: const Color(0xFF110D18),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF17111F), Color(0xFF241733), Color(0xFF321A45)],
          ),
        ),
        child: SafeArea(
          child: _yukleniyor
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1500),
                    child: Padding(
                      padding: EdgeInsets.all(masaustu ? 22 : 14),
                      child: ListView(
                        children: [
                          _KompaktUstAlan(
                            ozet: ozet,
                            seciliFiltre: _seciliFiltre,
                            filtreSec: (_PanelFiltre filtre) {
                              setState(() {
                                _seciliFiltre = filtre;
                              });
                            },
                            seciliZamanFiltresi: _seciliZamanFiltresi,
                            zamanFiltresiSec: (_ZamanFiltresi filtre) {
                              setState(() {
                                _seciliZamanFiltresi = filtre;
                              });
                            },
                            seciliSiralama: _seciliSiralama,
                            siralamaSec: (_SiparisSirasi siralama) {
                              setState(() {
                                _seciliSiralama = siralama;
                              });
                            },
                            yaziciYonetimiAc: _yaziciYonetiminiAc,
                            salonYonetimiAc: () => _yonetimAyarlariniAc(0),
                            menuYonetimiAc: () => _yonetimAyarlariniAc(1),
                            stokYonetimiAc: () => _yonetimAyarlariniAc(2),
                          ),
                          const SizedBox(height: 18),
                          masaustu
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: _SiparisAkisi(
                                        siparisler: filtreliSiparisler,
                                        aramaMetni: _aramaMetni,
                                        aramaDenetleyici: _aramaDenetleyici,
                                        aramaDegisti: (String deger) {
                                          setState(() {
                                            _aramaMetni = deger;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      flex: 5,
                                      child: _YanPanel(
                                        ozet: ozet,
                                        saatlikVeriler: saatlikVeriler,
                                        siparisler: filtreliSiparisler,
                                        salonBolumleri: _salonBolumleri,
                                        stokOzeti: _stokOzeti,
                                        yazicilar: _yazicilar,
                                        sistemYazicilari: _sistemYazicilari,
                                        yaziciEkle: _yaziciEkle,
                                        yaziciSil: _yaziciSil,
                                        yaziciGuncelle: _yaziciGuncelle,
                                        personeller: _personeller,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    _SiparisAkisi(
                                      siparisler: filtreliSiparisler,
                                      aramaMetni: _aramaMetni,
                                      aramaDenetleyici: _aramaDenetleyici,
                                      aramaDegisti: (String deger) {
                                        setState(() {
                                          _aramaMetni = deger;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 18),
                                    _YanPanel(
                                      ozet: ozet,
                                      saatlikVeriler: saatlikVeriler,
                                      siparisler: filtreliSiparisler,
                                      salonBolumleri: _salonBolumleri,
                                      stokOzeti: _stokOzeti,
                                      yazicilar: _yazicilar,
                                      sistemYazicilari: _sistemYazicilari,
                                      yaziciEkle: _yaziciEkle,
                                      yaziciSil: _yaziciSil,
                                      yaziciGuncelle: _yaziciGuncelle,
                                      personeller: _personeller,
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  List<SiparisVarligi> get _filtreliSiparisler {
    final List<SiparisVarligi> zamanFiltreli = _zamanFiltresiUygula(
      _siparisler,
    );

    final List<SiparisVarligi> kanalFiltreli;
    switch (_seciliFiltre) {
      case _PanelFiltre.tumu:
        kanalFiltreli = zamanFiltreli;
      case _PanelFiltre.aktif:
        kanalFiltreli = zamanFiltreli
            .where(
              (siparis) =>
                  siparis.durum == SiparisDurumu.alindi ||
                  siparis.durum == SiparisDurumu.hazirlaniyor ||
                  siparis.durum == SiparisDurumu.hazir ||
                  siparis.durum == SiparisDurumu.yolda,
            )
            .toList();
      case _PanelFiltre.gelAl:
        kanalFiltreli = zamanFiltreli
            .where((siparis) => siparis.teslimatTipi == TeslimatTipi.gelAl)
            .toList();
      case _PanelFiltre.paketServis:
        kanalFiltreli = zamanFiltreli
            .where(
              (siparis) => siparis.teslimatTipi == TeslimatTipi.paketServis,
            )
            .toList();
      case _PanelFiltre.restorandaYe:
        kanalFiltreli = zamanFiltreli
            .where(
              (siparis) => siparis.teslimatTipi == TeslimatTipi.restorandaYe,
            )
            .toList();
    }

    return _sirala(_aramaUygula(kanalFiltreli));
  }

  List<SiparisVarligi> _aramaUygula(List<SiparisVarligi> kaynak) {
    final String sorgu = _aramaMetni.trim().toLowerCase();
    if (sorgu.isEmpty) {
      return kaynak;
    }

    return kaynak.where((SiparisVarligi siparis) {
      final String adSoyad =
          siparis.sahip.misafirBilgisi?.adSoyad.toLowerCase() ?? '';
      final String siparisNo = siparis.siparisNo.toLowerCase();
      return adSoyad.contains(sorgu) || siparisNo.contains(sorgu);
    }).toList();
  }

  List<SiparisVarligi> _zamanFiltresiUygula(List<SiparisVarligi> kaynak) {
    if (kaynak.isEmpty || _seciliZamanFiltresi == _ZamanFiltresi.tumu) {
      return kaynak;
    }

    final DateTime enYeniTarih = kaynak
        .map((siparis) => siparis.olusturmaTarihi)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    switch (_seciliZamanFiltresi) {
      case _ZamanFiltresi.bugun:
        return kaynak
            .where(
              (siparis) =>
                  siparis.olusturmaTarihi.year == enYeniTarih.year &&
                  siparis.olusturmaTarihi.month == enYeniTarih.month &&
                  siparis.olusturmaTarihi.day == enYeniTarih.day,
            )
            .toList();
      case _ZamanFiltresi.sonIkiSaat:
        final DateTime esik = enYeniTarih.subtract(const Duration(hours: 2));
        return kaynak
            .where(
              (siparis) =>
                  !siparis.olusturmaTarihi.isBefore(esik) &&
                  !siparis.olusturmaTarihi.isAfter(enYeniTarih),
            )
            .toList();
      case _ZamanFiltresi.tumu:
        return kaynak;
    }
  }

  List<SiparisVarligi> _sirala(List<SiparisVarligi> kaynak) {
    final List<SiparisVarligi> sirali = List<SiparisVarligi>.from(kaynak);

    switch (_seciliSiralama) {
      case _SiparisSirasi.enYeni:
        sirali.sort((a, b) => b.olusturmaTarihi.compareTo(a.olusturmaTarihi));
      case _SiparisSirasi.tutarYuksek:
        sirali.sort((a, b) => b.toplamTutar.compareTo(a.toplamTutar));
      case _SiparisSirasi.durumOncelikli:
        sirali.sort((a, b) {
          final int durumKarsilastirma = _durumOnceligi(
            a.durum,
          ).compareTo(_durumOnceligi(b.durum));
          if (durumKarsilastirma != 0) {
            return durumKarsilastirma;
          }
          return b.olusturmaTarihi.compareTo(a.olusturmaTarihi);
        });
    }

    return sirali;
  }
}

enum _PanelFiltre { tumu, aktif, gelAl, paketServis, restorandaYe }

enum _ZamanFiltresi { bugun, sonIkiSaat, tumu }

enum _SiparisSirasi { enYeni, tutarYuksek, durumOncelikli }

class _KontrolCubugu extends StatelessWidget {
  const _KontrolCubugu({
    required this.seciliZamanFiltresi,
    required this.zamanFiltresiSec,
    required this.seciliSiralama,
    required this.siralamaSec,
  });

  final _ZamanFiltresi seciliZamanFiltresi;
  final ValueChanged<_ZamanFiltresi> zamanFiltresiSec;
  final _SiparisSirasi seciliSiralama;
  final ValueChanged<_SiparisSirasi> siralamaSec;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _SecimKutusu<_ZamanFiltresi>(
          baslik: 'Zaman',
          seciliDeger: seciliZamanFiltresi,
          secenekler: const [
            (_ZamanFiltresi.bugun, 'Bugun'),
            (_ZamanFiltresi.sonIkiSaat, 'Son 2 saat'),
            (_ZamanFiltresi.tumu, 'Tum zaman'),
          ],
          degisti: zamanFiltresiSec,
        ),
        _SecimKutusu<_SiparisSirasi>(
          baslik: 'Sirala',
          seciliDeger: seciliSiralama,
          secenekler: const [
            (_SiparisSirasi.enYeni, 'En yeni'),
            (_SiparisSirasi.tutarYuksek, 'Tutar'),
            (_SiparisSirasi.durumOncelikli, 'Durum'),
          ],
          degisti: siralamaSec,
        ),
      ],
    );
  }
}

class _SecimKutusu<T> extends StatelessWidget {
  const _SecimKutusu({
    required this.baslik,
    required this.seciliDeger,
    required this.secenekler,
    required this.degisti,
  });

  final String baslik;
  final T seciliDeger;
  final List<(T, String)> secenekler;
  final ValueChanged<T> degisti;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$baslik: ',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: seciliDeger,
              dropdownColor: const Color(0xFF2B1D3A),
              borderRadius: BorderRadius.circular(16),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              iconEnabledColor: Colors.white,
              items: secenekler
                  .map(
                    (secenek) => DropdownMenuItem<T>(
                      value: secenek.$1,
                      child: Text(secenek.$2),
                    ),
                  )
                  .toList(),
              onChanged: (T? deger) {
                if (deger != null) {
                  degisti(deger);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltreCubugu extends StatelessWidget {
  const _FiltreCubugu({required this.seciliFiltre, required this.filtreSec});

  final _PanelFiltre seciliFiltre;
  final ValueChanged<_PanelFiltre> filtreSec;

  @override
  Widget build(BuildContext context) {
    final List<(_PanelFiltre, String)> filtreler = <(_PanelFiltre, String)>[
      (_PanelFiltre.tumu, 'Tumu'),
      (_PanelFiltre.aktif, 'Aktif'),
      (_PanelFiltre.gelAl, 'Gel al'),
      (_PanelFiltre.paketServis, 'Paket'),
      (_PanelFiltre.restorandaYe, 'Salon'),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: filtreler.map((veri) {
        final bool seciliMi = veri.$1 == seciliFiltre;
        return InkWell(
          onTap: () => filtreSec(veri.$1),
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: seciliMi
                  ? const Color(0xFFFF5D8F)
                  : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: seciliMi
                    ? const Color(0xFFFF84AB)
                    : Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              veri.$2,
              style: TextStyle(
                color: Colors.white,
                fontWeight: seciliMi ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _KompaktUstAlan extends StatelessWidget {
  const _KompaktUstAlan({
    required this.ozet,
    required this.seciliFiltre,
    required this.filtreSec,
    required this.seciliZamanFiltresi,
    required this.zamanFiltresiSec,
    required this.seciliSiralama,
    required this.siralamaSec,
    required this.yaziciYonetimiAc,
    required this.salonYonetimiAc,
    required this.menuYonetimiAc,
    required this.stokYonetimiAc,
  });

  final YonetimPaneliOzetiVarligi ozet;
  final _PanelFiltre seciliFiltre;
  final ValueChanged<_PanelFiltre> filtreSec;
  final _ZamanFiltresi seciliZamanFiltresi;
  final ValueChanged<_ZamanFiltresi> zamanFiltresiSec;
  final _SiparisSirasi seciliSiralama;
  final ValueChanged<_SiparisSirasi> siralamaSec;
  final Future<void> Function() yaziciYonetimiAc;
  final Future<void> Function() salonYonetimiAc;
  final Future<void> Function() menuYonetimiAc;
  final Future<void> Function() stokYonetimiAc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C1327), Color(0xFF2A1938), Color(0xFF3B1E4C)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
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
                      UygulamaSabitleri.yonetimPaneliBasligi,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Karmasayi azaltan, karar vermeyi hizlandiran operasyon gorunumu.',
                      style: TextStyle(color: Color(0xFFD8CDE3), height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(RotaYapisi.pos);
                    },
                    style: FilledButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                    icon: const Icon(Icons.point_of_sale_rounded, size: 18),
                    label: const Text('POS ekranina git'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(RotaYapisi.anaSayfa);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                    icon: const Icon(Icons.switch_account_rounded, size: 18),
                    label: const Text('Rol secimine don'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: salonYonetimiAc,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8B6B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.chair_alt_rounded),
                label: const Text('Salon yonetimi'),
              ),
              FilledButton.tonalIcon(
                onPressed: menuYonetimiAc,
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.restaurant_menu_rounded),
                label: const Text('Menu yonetimi'),
              ),
              FilledButton.tonalIcon(
                onPressed: stokYonetimiAc,
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.inventory_2_rounded),
                label: const Text('Stok yonetimi'),
              ),
              FilledButton.icon(
                onPressed: yaziciYonetimiAc,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF271830),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.print_rounded),
                label: const Text('Yazici yonetimi'),
              ),
              Text(
                'Yazici ayarlari popup pencerede acilir.',
                style: const TextStyle(
                  color: Color(0xFFE8DDF0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _OperasyonMetrigi(
                baslik: 'Aktif siparis',
                deger:
                    '${ozet.hazirlananSiparis + ozet.hazirSiparis + ozet.yoldaSiparis}',
                renk: const Color(0xFFFF8B6B),
              ),
              _OperasyonMetrigi(
                baslik: 'Gunluk ciro',
                deger: _paraYaz(ozet.toplamCiro),
                renk: const Color(0xFF7FE7B3),
              ),
              _OperasyonMetrigi(
                baslik: 'Salon',
                deger: '${ozet.restorandaYeSayisi}',
                renk: const Color(0xFF74A2FF),
              ),
              _OperasyonMetrigi(
                baslik: 'Paket',
                deger: '${ozet.paketServisSayisi}',
                renk: const Color(0xFFC58CFF),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _FiltreCubugu(seciliFiltre: seciliFiltre, filtreSec: filtreSec),
          const SizedBox(height: 12),
          _KontrolCubugu(
            seciliZamanFiltresi: seciliZamanFiltresi,
            zamanFiltresiSec: zamanFiltresiSec,
            seciliSiralama: seciliSiralama,
            siralamaSec: siralamaSec,
          ),
        ],
      ),
    );
  }
}

class _OperasyonMetrigi extends StatelessWidget {
  const _OperasyonMetrigi({
    required this.baslik,
    required this.deger,
    required this.renk,
  });

  final String baslik;
  final String deger;
  final Color renk;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: const TextStyle(
              color: Color(0xFFD8CDE3),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            deger,
            style: TextStyle(
              color: renk,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SiparisAkisi extends StatelessWidget {
  const _SiparisAkisi({
    required this.siparisler,
    required this.aramaMetni,
    required this.aramaDenetleyici,
    required this.aramaDegisti,
  });

  final List<SiparisVarligi> siparisler;
  final String aramaMetni;
  final TextEditingController aramaDenetleyici;
  final ValueChanged<String> aramaDegisti;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5FB),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Canli siparis akisi',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFF25192E),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Mutfak ve servis ekibinin takip edecegi operasyon listesi.',
            style: TextStyle(color: Color(0xFF7A6D86)),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: aramaDenetleyici,
            onChanged: aramaDegisti,
            decoration: InputDecoration(
              hintText: 'Siparis no veya musteri ara',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: aramaMetni.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        aramaDenetleyici.clear();
                        aramaDegisti('');
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (siparisler.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Filtreye uygun siparis bulunamadi.',
                style: TextStyle(
                  color: Color(0xFF7A6D86),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            ...siparisler.map((siparis) => _SiparisSatiri(siparis: siparis)),
        ],
      ),
    );
  }
}

class _SiparisSatiri extends StatelessWidget {
  const _SiparisSatiri({required this.siparis});

  final SiparisVarligi siparis;

  @override
  Widget build(BuildContext context) {
    final Color durumRenk = _durumRengi(siparis.durum);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: durumRenk.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                siparis.siparisNo,
                style: TextStyle(
                  color: durumRenk,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    siparis.sahip.misafirBilgisi?.adSoyad ?? 'Misafir',
                    style: const TextStyle(
                      color: Color(0xFF261B30),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _siparisAltEtiketi(siparis),
                    style: const TextStyle(color: Color(0xFF7A6D86)),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: durumRenk.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                _durumEtiketi(siparis.durum),
                style: TextStyle(color: durumRenk, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${siparis.toplamTutar.toStringAsFixed(0)} TL',
              style: const TextStyle(
                color: Color(0xFF261B30),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YanPanel extends StatelessWidget {
  const _YanPanel({
    required this.ozet,
    required this.saatlikVeriler,
    required this.siparisler,
    required this.salonBolumleri,
    required this.stokOzeti,
    required this.yazicilar,
    required this.sistemYazicilari,
    required this.yaziciEkle,
    required this.yaziciSil,
    required this.yaziciGuncelle,
    required this.personeller,
  });

  final YonetimPaneliOzetiVarligi ozet;
  final List<SaatlikSiparisOzetiVarligi> saatlikVeriler;
  final List<SiparisVarligi> siparisler;
  final List<SalonBolumuVarligi> salonBolumleri;
  final StokOzetiVarligi? stokOzeti;
  final List<YaziciDurumuVarligi> yazicilar;
  final List<SistemYaziciAdayiVarligi> sistemYazicilari;
  final Future<void> Function() yaziciEkle;
  final Future<void> Function(YaziciDurumuVarligi yazici) yaziciSil;
  final Future<void> Function(
    YaziciDurumuVarligi yazici, {
    String? rolEtiketi,
    YaziciBaglantiDurumu? durum,
  })
  yaziciGuncelle;
  final List<PersonelDurumuVarligi> personeller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kanal dagilimi',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF25192E),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Siparislerin hangi kanal uzerinden geldigini anlik izleyin.',
                style: TextStyle(color: Color(0xFF7A6D86)),
              ),
              const SizedBox(height: 18),
              SizedBox(height: 220, child: _KanalDagilimiGrafik(ozet: ozet)),
              const SizedBox(height: 18),
              _KanalSatiri(
                etiket: 'Restoranda ye',
                sayi: ozet.restorandaYeSayisi,
                renk: const Color(0xFFFF7A59),
              ),
              const SizedBox(height: 10),
              _KanalSatiri(
                etiket: 'Gel al',
                sayi: ozet.gelAlSayisi,
                renk: const Color(0xFF5B8CFF),
              ),
              const SizedBox(height: 10),
              _KanalSatiri(
                etiket: 'Paket servis',
                sayi: ozet.paketServisSayisi,
                renk: const Color(0xFF30C48D),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (stokOzeti != null) ...[
          _StokVeMaliyetKarti(ozet: stokOzeti!),
          const SizedBox(height: 18),
        ],
        _MasaPlaniKarti(siparisler: siparisler, salonBolumleri: salonBolumleri),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saatlik siparis trendi',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF25192E),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Son saatlerdeki siparis yogunlugunun mini ozeti.',
                style: TextStyle(color: Color(0xFF7A6D86)),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 220,
                child: _SaatlikTrendGrafik(veriler: saatlikVeriler),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _PatronRaporuKarti(
          siparisler: siparisler,
          saatlikVeriler: saatlikVeriler,
        ),
        const SizedBox(height: 18),
        _PersonelYonetimiKarti(personeller: personeller),
      ],
    );
  }
}

class _PatronRaporuKarti extends StatelessWidget {
  const _PatronRaporuKarti({
    required this.siparisler,
    required this.saatlikVeriler,
  });

  final List<SiparisVarligi> siparisler;
  final List<SaatlikSiparisOzetiVarligi> saatlikVeriler;

  @override
  Widget build(BuildContext context) {
    final PatronRaporuOzetiVarligi rapor =
        YonetimRaporuHesaplayici.patronRaporunuHesapla(
          siparisler: siparisler,
          saatlikVeriler: saatlikVeriler,
        );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF102A43), Color(0xFF1D4D6D), Color(0xFF235E73)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patron raporu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            rapor.ozetMetni,
            style: const TextStyle(color: Color(0xFFD8EEF4), height: 1.45),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _PatronMetrikKutusu(
                  etiket: 'Ort. adisyon',
                  deger: _paraYaz(rapor.ortalamaAdisyon),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PatronMetrikKutusu(
                  etiket: 'Gun sonu projeksiyon',
                  deger: _paraYaz(rapor.tahminiGunSonuCiro),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _PatronIcerikSatiri(
            ikon: Icons.workspace_premium_outlined,
            baslik: 'En guclu kanal',
            aciklama:
                '${rapor.enGucluKanalEtiketi} bugun ${rapor.enGucluKanalAdedi} siparis ile one cikiyor.',
          ),
          const SizedBox(height: 10),
          _PatronIcerikSatiri(
            ikon: Icons.schedule_outlined,
            baslik: 'Zirve saat',
            aciklama:
                '${rapor.zirveSaatEtiketi} diliminde ${rapor.zirveSaatAdedi} siparis goruldu.',
          ),
          const SizedBox(height: 10),
          _PatronIcerikSatiri(
            ikon: Icons.shopping_bag_outlined,
            baslik: 'En yuksek sepet',
            aciklama:
                '${rapor.enYuksekSiparisNo} numarali siparis ${_paraYaz(rapor.enYuksekSiparisTutari)} ile gunun zirvesi.',
          ),
        ],
      ),
    );
  }
}

class _StokVeMaliyetKarti extends StatelessWidget {
  const _StokVeMaliyetKarti({required this.ozet});

  final StokOzetiVarligi ozet;

  @override
  Widget build(BuildContext context) {
    final MenuMaliyetVarligi? enDusukMarjli = ozet.menuMaliyetleri.isEmpty
        ? null
        : ozet.menuMaliyetleri.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF113127), Color(0xFF1D4B3C), Color(0xFF275E4B)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stok ve maliyet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${ozet.toplamHammaddeSayisi} hammadde izleniyor. ${ozet.kritikMalzemeSayisi} kalem kritik seviyeye yakin.',
            style: const TextStyle(color: Color(0xFFDDF4EA), height: 1.45),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _PatronMetrikKutusu(
                  etiket: 'Stok degeri',
                  deger: _paraYaz(ozet.toplamStokDegeri),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PatronMetrikKutusu(
                  etiket: 'Kritik kalem',
                  deger: '${ozet.kritikMalzemeSayisi}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (ozet.kritikMalzemeler.isNotEmpty) ...[
            const Text(
              'Kritik malzemeler',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            ...ozet.kritikMalzemeler.map(
              (KritikMalzemeVarligi malzeme) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _StokUyariSatiri(malzeme: malzeme),
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (enDusukMarjli != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Marj takibi',
                    style: TextStyle(
                      color: Color(0xFFDDF4EA),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${enDusukMarjli.urunAdi} icin recete maliyeti ${_paraYaz(enDusukMarjli.receteMaliyeti)}. Tahmini marj %${enDusukMarjli.karMarjiOrani.toStringAsFixed(0)}.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StokUyariSatiri extends StatelessWidget {
  const _StokUyariSatiri({required this.malzeme});

  final KritikMalzemeVarligi malzeme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.inventory_2_outlined, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              malzeme.ad,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            malzeme.kalanMiktarMetni,
            style: const TextStyle(
              color: Color(0xFFDDF4EA),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PatronMetrikKutusu extends StatelessWidget {
  const _PatronMetrikKutusu({required this.etiket, required this.deger});

  final String etiket;
  final String deger;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiket,
            style: const TextStyle(
              color: Color(0xFFD8EEF4),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            deger,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PatronIcerikSatiri extends StatelessWidget {
  const _PatronIcerikSatiri({
    required this.ikon,
    required this.baslik,
    required this.aciklama,
  });

  final IconData ikon;
  final String baslik;
  final String aciklama;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(ikon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baslik,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  aciklama,
                  style: const TextStyle(color: Color(0xFFD8EEF4), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _YaziciYonetimiKarti extends StatelessWidget {
  const _YaziciYonetimiKarti({
    required this.yazicilar,
    required this.siparisler,
    required this.sistemYazicilari,
    required this.yaziciEkle,
    required this.yaziciSil,
    required this.yaziciGuncelle,
  });

  final List<YaziciDurumuVarligi> yazicilar;
  final List<SiparisVarligi> siparisler;
  final List<SistemYaziciAdayiVarligi> sistemYazicilari;
  final Future<void> Function() yaziciEkle;
  final Future<void> Function(YaziciDurumuVarligi yazici) yaziciSil;
  final Future<void> Function(
    YaziciDurumuVarligi yazici, {
    String? rolEtiketi,
    YaziciBaglantiDurumu? durum,
  })
  yaziciGuncelle;

  @override
  Widget build(BuildContext context) {
    final int bagliYaziciSayisi = yazicilar
        .where((yazici) => yazici.durum == YaziciBaglantiDurumu.bagli)
        .length;
    final List<YaziciIsKuyruguVarligi> kuyruk =
        YaziciIsKuyruguHesaplayici.kuyruguHazirla(siparisler);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2D1B41), Color(0xFF4A2569)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Yazici yonetimi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$bagliYaziciSayisi / ${yazicilar.length} yazici bagli durumda. Mutfak, bar ve fis rollerini buradan takip et.',
                      style: const TextStyle(color: Color(0xFFE8DDF0)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: yaziciEkle,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.add),
                label: const Text('Yazici ekle'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (kuyruk.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Canli yazici kuyrugu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...kuyruk.map(
                    (isEmri) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _YaziciKuyrukSatiri(isEmri: isEmri),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          ...yazicilar.map(
            (YaziciDurumuVarligi yazici) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _YaziciSatiri(
                yazici: yazici,
                yaziciSil: yaziciSil,
                yaziciGuncelle: yaziciGuncelle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _YaziciYonetimiDialog extends StatelessWidget {
  const _YaziciYonetimiDialog({
    required this.yazicilar,
    required this.siparisler,
    required this.sistemYazicilari,
    required this.yaziciEkle,
    required this.yaziciSil,
    required this.yaziciGuncelle,
  });

  final List<YaziciDurumuVarligi> yazicilar;
  final List<SiparisVarligi> siparisler;
  final List<SistemYaziciAdayiVarligi> sistemYazicilari;
  final Future<void> Function() yaziciEkle;
  final Future<void> Function(YaziciDurumuVarligi yazici) yaziciSil;
  final Future<void> Function(
    YaziciDurumuVarligi yazici, {
    String? rolEtiketi,
    YaziciBaglantiDurumu? durum,
  })
  yaziciGuncelle;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860, maxHeight: 760),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: _YaziciYonetimiKarti(
                yazicilar: yazicilar,
                siparisler: siparisler,
                sistemYazicilari: sistemYazicilari,
                yaziciEkle: yaziciEkle,
                yaziciSil: yaziciSil,
                yaziciGuncelle: yaziciGuncelle,
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: IconButton.filled(
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.18),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YaziciSatiri extends StatelessWidget {
  const _YaziciSatiri({
    required this.yazici,
    required this.yaziciSil,
    required this.yaziciGuncelle,
  });

  final YaziciDurumuVarligi yazici;
  final Future<void> Function(YaziciDurumuVarligi yazici) yaziciSil;
  final Future<void> Function(
    YaziciDurumuVarligi yazici, {
    String? rolEtiketi,
    YaziciBaglantiDurumu? durum,
  })
  yaziciGuncelle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.print_rounded, color: yazici.renk, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      yazici.ad,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${yazici.rolEtiketi}  |  ${yazici.baglantiNoktasi}',
                      style: const TextStyle(color: Color(0xFFE8DDF0)),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (String deger) {
                  switch (deger) {
                    case 'rol_mutfak':
                      yaziciGuncelle(yazici, rolEtiketi: 'Mutfak');
                    case 'rol_icecek':
                      yaziciGuncelle(yazici, rolEtiketi: 'Icecek');
                    case 'rol_kasa':
                      yaziciGuncelle(yazici, rolEtiketi: 'Kasa');
                    case 'durum_bagli':
                      yaziciGuncelle(yazici, durum: YaziciBaglantiDurumu.bagli);
                    case 'durum_dikkat':
                      yaziciGuncelle(
                        yazici,
                        durum: YaziciBaglantiDurumu.dikkat,
                      );
                    case 'durum_kapali':
                      yaziciGuncelle(
                        yazici,
                        durum: YaziciBaglantiDurumu.kapali,
                      );
                    case 'sil':
                      yaziciSil(yazici);
                  }
                },
                color: const Color(0xFF43235F),
                itemBuilder: (BuildContext context) => const [
                  PopupMenuItem<String>(
                    value: 'rol_mutfak',
                    child: Text('Rol: Mutfak'),
                  ),
                  PopupMenuItem<String>(
                    value: 'rol_icecek',
                    child: Text('Rol: Icecek'),
                  ),
                  PopupMenuItem<String>(
                    value: 'rol_kasa',
                    child: Text('Rol: Kasa'),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'durum_bagli',
                    child: Text('Durum: Bagli'),
                  ),
                  PopupMenuItem<String>(
                    value: 'durum_dikkat',
                    child: Text('Durum: Dikkat'),
                  ),
                  PopupMenuItem<String>(
                    value: 'durum_kapali',
                    child: Text('Durum: Kapali'),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'sil',
                    child: Text('Yaziciyi sil'),
                  ),
                ],
                icon: const Icon(Icons.more_horiz, color: Colors.white),
              ),
              const SizedBox(width: 8),
              _YaziciDurumRozeti(yazici: yazici),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  yazici.aciklama,
                  style: const TextStyle(color: Color(0xFFE8DDF0)),
                ),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${yazici.ad} icin test cikti kuyruga alindi',
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.receipt_long_outlined, size: 18),
                label: const Text('Test'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SistemYaziciRozeti extends StatelessWidget {
  const _SistemYaziciRozeti({required this.etiket});

  final String etiket;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        etiket,
        style: const TextStyle(
          color: Color(0xFFE8DDF0),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _YaziciDurumRozeti extends StatelessWidget {
  const _YaziciDurumRozeti({required this.yazici});

  final YaziciDurumuVarligi yazici;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        yazici.durumEtiketi,
        style: TextStyle(color: yazici.renk, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _YaziciKuyrukSatiri extends StatelessWidget {
  const _YaziciKuyrukSatiri({required this.isEmri});

  final YaziciIsKuyruguVarligi isEmri;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            isEmri.siparisNo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${isEmri.yaziciRolu} - ${isEmri.durumEtiketi}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                isEmri.kisaAciklama,
                style: const TextStyle(color: Color(0xFFE8DDF0), fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PersonelYonetimiKarti extends StatelessWidget {
  const _PersonelYonetimiKarti({required this.personeller});

  final List<PersonelDurumuVarligi> personeller;

  @override
  Widget build(BuildContext context) {
    final int aktifSayisi = personeller
        .where((personel) => personel.durum == PersonelDurumu.aktif)
        .length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Garson ve personel',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF25192E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$aktifSayisi / ${personeller.length} kisi vardiyada. Salon dagilimi ve moladaki ekip buradan gorunur.',
                      style: const TextStyle(color: Color(0xFF7A6D86)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EAF9),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.group_outlined,
                      color: Color(0xFF7D5CFF),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Vardiya listesi',
                      style: TextStyle(
                        color: Color(0xFF412454),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...personeller.map(
            (PersonelDurumuVarligi personel) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PersonelSatiri(personel: personel),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonelSatiri extends StatelessWidget {
  const _PersonelSatiri({required this.personel});

  final PersonelDurumuVarligi personel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F4FB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDE4F2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: personel.renk.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  personel.kisaAd,
                  style: TextStyle(
                    color: personel.renk,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      personel.adSoyad,
                      style: const TextStyle(
                        color: Color(0xFF25192E),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${personel.rolEtiketi}  |  ${personel.bolge}',
                      style: const TextStyle(color: Color(0xFF7A6D86)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: personel.renk.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  personel.durumEtiketi,
                  style: TextStyle(
                    color: personel.renk,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  personel.aciklama,
                  style: const TextStyle(color: Color(0xFF61556E)),
                ),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${personel.adSoyad} icin vardiya notu acildi',
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF412454),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.edit_calendar_outlined, size: 18),
                label: const Text('Not'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MasaPlaniKarti extends StatelessWidget {
  const _MasaPlaniKarti({
    required this.siparisler,
    required this.salonBolumleri,
  });

  final List<SiparisVarligi> siparisler;
  final List<SalonBolumuVarligi> salonBolumleri;

  @override
  Widget build(BuildContext context) {
    final List<_BolumPlaniVeri> bolumler = _BolumPlaniVeri.uret(
      siparisler,
      salonBolumleri,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masa plani',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: const Color(0xFF25192E)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Salon yerlesimini bolum bazli izle, dolu masalari aninda fark et.',
            style: TextStyle(color: Color(0xFF7A6D86)),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _MasaDurumLejandi(
                etiket: 'Bos',
                renk: Color(0xFF5B8CFF),
                ikon: Icons.event_seat_outlined,
              ),
              _MasaDurumLejandi(
                etiket: 'Siparis bekliyor',
                renk: Color(0xFFFF8B6B),
                ikon: Icons.restaurant_menu_rounded,
              ),
              _MasaDurumLejandi(
                etiket: 'Serviste',
                renk: Color(0xFFC58CFF),
                ikon: Icons.room_service_rounded,
              ),
              _MasaDurumLejandi(
                etiket: 'Temizleniyor',
                renk: Color(0xFF9AA6B2),
                ikon: Icons.cleaning_services_rounded,
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...bolumler.map(
            (_BolumPlaniVeri bolum) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _BolumPlaniKapsulu(bolum: bolum),
            ),
          ),
        ],
      ),
    );
  }
}

class _MasaDurumLejandi extends StatelessWidget {
  const _MasaDurumLejandi({
    required this.etiket,
    required this.renk,
    required this.ikon,
  });

  final String etiket;
  final Color renk;
  final IconData ikon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 16, color: renk),
          const SizedBox(width: 8),
          Text(
            etiket,
            style: TextStyle(color: renk, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _BolumPlaniKapsulu extends StatelessWidget {
  const _BolumPlaniKapsulu({required this.bolum});

  final _BolumPlaniVeri bolum;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bolum.zeminRengi,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: bolum.kenarRengi),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(bolum.ikon, color: bolum.vurguRengi),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bolum.baslik,
                      style: const TextStyle(
                        color: Color(0xFF25192E),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bolum.aciklama,
                      style: const TextStyle(
                        color: Color(0xFF6D6079),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${bolum.doluMasaSayisi}/${bolum.masalar.length} dolu',
                  style: TextStyle(
                    color: bolum.vurguRengi,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double kartGenisligi = constraints.maxWidth < 520
                  ? 120
                  : 138;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: bolum.masalar
                    .map(
                      (_MasaPlaniKutusuVeri masa) => SizedBox(
                        width: kartGenisligi,
                        child: _MasaPlaniKutusu(masa: masa),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MasaPlaniKutusu extends StatelessWidget {
  const _MasaPlaniKutusu({required this.masa});

  final _MasaPlaniKutusuVeri masa;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 142),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: masa.renk.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: masa.renk.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(masa.ikon, color: masa.renk, size: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.80),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  masa.durumEtiketi,
                  style: TextStyle(
                    color: masa.renk,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            masa.baslik,
            style: const TextStyle(
              color: Color(0xFF25192E),
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${masa.kapasite} kisilik duzen',
            style: const TextStyle(
              color: Color(0xFF6D6079),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            masa.aciklama,
            style: const TextStyle(
              color: Color(0xFF6D6079),
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _KanalSatiri extends StatelessWidget {
  const _KanalSatiri({
    required this.etiket,
    required this.sayi,
    required this.renk,
  });

  final String etiket;
  final int sayi;
  final Color renk;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            etiket,
            style: const TextStyle(
              color: Color(0xFF5D5366),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: renk.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$sayi',
            style: TextStyle(color: renk, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _KanalDagilimiGrafik extends StatefulWidget {
  const _KanalDagilimiGrafik({required this.ozet});

  final YonetimPaneliOzetiVarligi ozet;

  @override
  State<_KanalDagilimiGrafik> createState() => _KanalDagilimiGrafikState();
}

class _KanalDagilimiGrafikState extends State<_KanalDagilimiGrafik> {
  int _dokunulanIndex = -1;

  @override
  Widget build(BuildContext context) {
    final List<_KanalVeri> veriler = <_KanalVeri>[
      _KanalVeri(
        etiket: 'Restoranda ye',
        deger: widget.ozet.restorandaYeSayisi.toDouble(),
        renk: const Color(0xFFFF7A59),
      ),
      _KanalVeri(
        etiket: 'Gel al',
        deger: widget.ozet.gelAlSayisi.toDouble(),
        renk: const Color(0xFF5B8CFF),
      ),
      _KanalVeri(
        etiket: 'Paket servis',
        deger: widget.ozet.paketServisSayisi.toDouble(),
        renk: const Color(0xFF30C48D),
      ),
    ];

    final double toplam = veriler.fold<double>(
      0,
      (double onceki, _KanalVeri veri) => onceki + veri.deger,
    );

    return Row(
      children: [
        Expanded(
          flex: 6,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      _dokunulanIndex = -1;
                    } else {
                      _dokunulanIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    }
                  });
                },
              ),
              sectionsSpace: 3,
              centerSpaceRadius: 42,
              startDegreeOffset: -90,
              sections: veriler.asMap().entries.map((entry) {
                final int index = entry.key;
                final _KanalVeri veri = entry.value;
                final bool secili = index == _dokunulanIndex;

                return PieChartSectionData(
                  value: veri.deger <= 0 ? 0.01 : veri.deger,
                  color: veri.renk,
                  radius: secili ? 50 : 42,
                  title: toplam == 0
                      ? '0%'
                      : '%${((veri.deger / toplam) * 100).round()}',
                  badgeWidget: secili
                      ? _KanalGrafikRozeti(
                          etiket: veri.etiket,
                          sayi: veri.deger.toInt(),
                        )
                      : null,
                  badgePositionPercentageOffset: 1.28,
                  titleStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: secili ? 12 : 11,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: veriler
                .map(
                  (_KanalVeri veri) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _KanalLejantSatiri(
                      veri: veri,
                      toplam: toplam,
                      seciliMi: veriler.indexOf(veri) == _dokunulanIndex,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _KanalVeri {
  const _KanalVeri({
    required this.etiket,
    required this.deger,
    required this.renk,
  });

  final String etiket;
  final double deger;
  final Color renk;
}

class _KanalLejantSatiri extends StatelessWidget {
  const _KanalLejantSatiri({
    required this.veri,
    required this.toplam,
    this.seciliMi = false,
  });

  final _KanalVeri veri;
  final double toplam;
  final bool seciliMi;

  @override
  Widget build(BuildContext context) {
    final int oran = toplam == 0 ? 0 : ((veri.deger / toplam) * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: veri.renk.withValues(alpha: seciliMi ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(16),
        border: seciliMi
            ? Border.all(color: veri.renk.withValues(alpha: 0.35))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: veri.renk, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  veri.etiket,
                  style: const TextStyle(
                    color: Color(0xFF25192E),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${veri.deger.toInt()} siparis  -  %$oran',
                  style: const TextStyle(
                    color: Color(0xFF7A6D86),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KanalGrafikRozeti extends StatelessWidget {
  const _KanalGrafikRozeti({required this.etiket, required this.sayi});

  final String etiket;
  final int sayi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF25192E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        '$etiket: $sayi',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SaatlikTrendGrafik extends StatelessWidget {
  const _SaatlikTrendGrafik({required this.veriler});

  final List<SaatlikSiparisOzetiVarligi> veriler;

  @override
  Widget build(BuildContext context) {
    final double enYuksek = veriler.isEmpty
        ? 1
        : veriler
                  .map((veri) => veri.adet.toDouble())
                  .reduce((a, b) => a > b ? a : b) +
              1;

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: enYuksek,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: Color(0xFFECE4F2), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, _) => Text(
                value.toInt().toString(),
                style: const TextStyle(color: Color(0xFF8B7D98), fontSize: 11),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, _) {
                final int index = value.toInt();
                if (index < 0 || index >= veriler.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    veriler[index].etiket,
                    style: const TextStyle(
                      color: Color(0xFF8B7D98),
                      fontSize: 11,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Color(0xFFE0D7E8)),
            bottom: BorderSide(color: Color(0xFFE0D7E8)),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: const Color(0xFF7D5CFF),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, barData, index, chartData) =>
                  FlDotCirclePainter(
                    radius: 4,
                    color: const Color(0xFFFF5D8F),
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF7D5CFF).withValues(alpha: 0.28),
                  const Color(0xFF7D5CFF).withValues(alpha: 0.02),
                ],
              ),
            ),
            spots: veriler
                .asMap()
                .entries
                .map(
                  (entry) =>
                      FlSpot(entry.key.toDouble(), entry.value.adet.toDouble()),
                )
                .toList(),
          ),
        ],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF25192E),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((LineBarSpot spot) {
                final int index = spot.x.toInt();
                final String etiket = index >= 0 && index < veriler.length
                    ? veriler[index].etiket
                    : '';
                return LineTooltipItem(
                  '$etiket\n${spot.y.toInt()} siparis',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

class _BolumPlaniVeri {
  const _BolumPlaniVeri({
    required this.baslik,
    required this.aciklama,
    required this.ikon,
    required this.vurguRengi,
    required this.zeminRengi,
    required this.kenarRengi,
    required this.masalar,
  });

  final String baslik;
  final String aciklama;
  final IconData ikon;
  final Color vurguRengi;
  final Color zeminRengi;
  final Color kenarRengi;
  final List<_MasaPlaniKutusuVeri> masalar;

  int get doluMasaSayisi =>
      masalar.where((_MasaPlaniKutusuVeri masa) => masa.doluMu).length;

  static List<_BolumPlaniVeri> uret(
    List<SiparisVarligi> siparisler,
    List<SalonBolumuVarligi> salonBolumleri,
  ) {
    final List<SiparisVarligi> salonSiparisleri = siparisler
        .where((siparis) => siparis.teslimatTipi == TeslimatTipi.restorandaYe)
        .toList();

    return salonBolumleri.asMap().entries.map((entry) {
      final int index = entry.key;
      final SalonBolumuVarligi bolum = entry.value;
      final _BolumGorunumu gorunum = _BolumGorunumu.indexIle(index, bolum.ad);

      return _BolumPlaniVeri(
        baslik: bolum.ad == 'Salon' ? 'Ana salon' : bolum.ad,
        aciklama: bolum.aciklama,
        ikon: gorunum.ikon,
        vurguRengi: gorunum.vurguRengi,
        zeminRengi: gorunum.zeminRengi,
        kenarRengi: gorunum.kenarRengi,
        masalar: _bolumMasalariniHazirla(
          bolum: bolum,
          siparisler: salonSiparisleri,
        ),
      );
    }).toList();
  }

  static List<_MasaPlaniKutusuVeri> _bolumMasalariniHazirla({
    required SalonBolumuVarligi bolum,
    required List<SiparisVarligi> siparisler,
  }) {
    return bolum.masalar.map((MasaTanimiVarligi masa) {
      SiparisVarligi? eslesenSiparis;
      for (final SiparisVarligi siparis in siparisler) {
        final String adayBolum = (siparis.bolumAdi ?? bolum.ad).trim();
        final String adayMasa = (siparis.masaNo ?? '').trim();
        if (adayBolum.toLowerCase() == bolum.ad.toLowerCase() &&
            adayMasa == masa.ad) {
          eslesenSiparis = siparis;
          break;
        }
      }

      if (eslesenSiparis != null) {
        return _MasaPlaniKutusuVeri.siparisten(
          masaNo: masa.ad,
          kapasite: masa.kapasite,
          siparis: eslesenSiparis,
        );
      }

      final int index = bolum.masalar.indexOf(masa);
      return _MasaPlaniKutusuVeri.beklemede(
        masaNo: masa.ad,
        kapasite: masa.kapasite,
        varyant: index % 3,
      );
    }).toList();
  }
}

class _BolumGorunumu {
  const _BolumGorunumu({
    required this.ikon,
    required this.vurguRengi,
    required this.zeminRengi,
    required this.kenarRengi,
  });

  final IconData ikon;
  final Color vurguRengi;
  final Color zeminRengi;
  final Color kenarRengi;

  factory _BolumGorunumu.indexIle(int index, String ad) {
    final String adKucuk = ad.toLowerCase();
    if (adKucuk.contains('teras')) {
      return const _BolumGorunumu(
        ikon: Icons.deck_rounded,
        vurguRengi: Color(0xFF5B8CFF),
        zeminRengi: Color(0xFFF2F7FF),
        kenarRengi: Color(0xFFD6E5FF),
      );
    }
    if (adKucuk.contains('bahce')) {
      return const _BolumGorunumu(
        ikon: Icons.park_rounded,
        vurguRengi: Color(0xFF30C48D),
        zeminRengi: Color(0xFFF1FBF5),
        kenarRengi: Color(0xFFD4F1DE),
      );
    }
    const List<_BolumGorunumu> varsayilanlar = <_BolumGorunumu>[
      _BolumGorunumu(
        ikon: Icons.chair_alt_rounded,
        vurguRengi: Color(0xFFFF7A59),
        zeminRengi: Color(0xFFFFF4EF),
        kenarRengi: Color(0xFFFFD5C6),
      ),
      _BolumGorunumu(
        ikon: Icons.coffee_rounded,
        vurguRengi: Color(0xFFC58CFF),
        zeminRengi: Color(0xFFF7F0FF),
        kenarRengi: Color(0xFFE8D8FF),
      ),
      _BolumGorunumu(
        ikon: Icons.window_rounded,
        vurguRengi: Color(0xFF5B8CFF),
        zeminRengi: Color(0xFFF2F7FF),
        kenarRengi: Color(0xFFD6E5FF),
      ),
    ];
    return varsayilanlar[index % varsayilanlar.length];
  }
}

class _MasaPlaniKutusuVeri {
  const _MasaPlaniKutusuVeri({
    required this.baslik,
    required this.durumEtiketi,
    required this.aciklama,
    required this.kapasite,
    required this.ikon,
    required this.renk,
    required this.doluMu,
  });

  final String baslik;
  final String durumEtiketi;
  final String aciklama;
  final int kapasite;
  final IconData ikon;
  final Color renk;
  final bool doluMu;

  factory _MasaPlaniKutusuVeri.siparisten({
    required String masaNo,
    required int kapasite,
    required SiparisVarligi siparis,
  }) {
    final _MasaDurumSunumu sunum = _MasaDurumSunumu.siparisten(siparis.durum);
    return _MasaPlaniKutusuVeri(
      baslik: 'Masa $masaNo',
      durumEtiketi: sunum.etiket,
      aciklama:
          '${siparis.sahip.misafirBilgisi?.adSoyad ?? 'Misafir'} · ${siparis.kalemler.length} kalem',
      kapasite: kapasite,
      ikon: sunum.ikon,
      renk: sunum.renk,
      doluMu: true,
    );
  }

  factory _MasaPlaniKutusuVeri.beklemede({
    required String masaNo,
    required int kapasite,
    required int varyant,
  }) {
    switch (varyant) {
      case 0:
        return _MasaPlaniKutusuVeri(
          baslik: 'Masa $masaNo',
          durumEtiketi: 'Bos',
          aciklama: 'Yeni misafir icin hazir bekliyor.',
          kapasite: kapasite,
          ikon: Icons.event_seat_outlined,
          renk: const Color(0xFF5B8CFF),
          doluMu: false,
        );
      case 1:
        return _MasaPlaniKutusuVeri(
          baslik: 'Masa $masaNo',
          durumEtiketi: 'Temizleniyor',
          aciklama: 'Kapanan servis sonrasi masa duzeni yenileniyor.',
          kapasite: kapasite,
          ikon: Icons.cleaning_services_rounded,
          renk: const Color(0xFF9AA6B2),
          doluMu: false,
        );
      default:
        return _MasaPlaniKutusuVeri(
          baslik: 'Masa $masaNo',
          durumEtiketi: 'Hazir',
          aciklama: 'Kuver ve QR karti yerlestirildi.',
          kapasite: kapasite,
          ikon: Icons.check_circle_outline_rounded,
          renk: const Color(0xFF30C48D),
          doluMu: false,
        );
    }
  }
}

class _MasaDurumSunumu {
  const _MasaDurumSunumu({
    required this.etiket,
    required this.ikon,
    required this.renk,
  });

  final String etiket;
  final IconData ikon;
  final Color renk;

  factory _MasaDurumSunumu.siparisten(SiparisDurumu durum) {
    switch (durum) {
      case SiparisDurumu.alindi:
        return const _MasaDurumSunumu(
          etiket: 'Siparis bekliyor',
          ikon: Icons.restaurant_menu_rounded,
          renk: Color(0xFFFF8B6B),
        );
      case SiparisDurumu.hazirlaniyor:
        return const _MasaDurumSunumu(
          etiket: 'Hazirlaniyor',
          ikon: Icons.local_fire_department_outlined,
          renk: Color(0xFFFF7A59),
        );
      case SiparisDurumu.hazir:
        return const _MasaDurumSunumu(
          etiket: 'Serviste',
          ikon: Icons.room_service_rounded,
          renk: Color(0xFFC58CFF),
        );
      case SiparisDurumu.yolda:
        return const _MasaDurumSunumu(
          etiket: 'Hesap istendi',
          ikon: Icons.receipt_long_rounded,
          renk: Color(0xFF7B6DFF),
        );
      case SiparisDurumu.teslimEdildi:
        return const _MasaDurumSunumu(
          etiket: 'Kapanisa yakin',
          ikon: Icons.payments_outlined,
          renk: Color(0xFF30C48D),
        );
      case SiparisDurumu.iptalEdildi:
        return const _MasaDurumSunumu(
          etiket: 'Iptal edildi',
          ikon: Icons.do_not_disturb_alt_rounded,
          renk: Color(0xFFEF6A6A),
        );
    }
  }
}

class _YaziciFormSonucu {
  const _YaziciFormSonucu({
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

class _YaziciFormDialog extends StatefulWidget {
  const _YaziciFormDialog({required this.sistemYazicilari});

  final List<SistemYaziciAdayiVarligi> sistemYazicilari;

  @override
  State<_YaziciFormDialog> createState() => _YaziciFormDialogState();
}

class _YaziciFormDialogState extends State<_YaziciFormDialog> {
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
    return AlertDialog(
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
                  DropdownMenuItem<String>(value: 'Kasa', child: Text('Kasa')),
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
              _YaziciFormSonucu(
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
    );
  }
}

class _YonetimAyarlariDialog extends StatefulWidget {
  const _YonetimAyarlariDialog({
    required this.salonBolumleri,
    required this.menuKategorileri,
    required this.menuUrunleri,
    required this.veriYenile,
    required this.servisKaydi,
    required this.baslangicSekmesi,
  });

  final List<SalonBolumuVarligi> salonBolumleri;
  final List<KategoriVarligi> menuKategorileri;
  final List<UrunVarligi> menuUrunleri;
  final Future<void> Function() veriYenile;
  final ServisKaydi servisKaydi;
  final int baslangicSekmesi;

  @override
  State<_YonetimAyarlariDialog> createState() => _YonetimAyarlariDialogState();
}

class _YonetimAyarlariDialogState extends State<_YonetimAyarlariDialog> {
  late List<SalonBolumuVarligi> _salonBolumleri;
  late List<KategoriVarligi> _menuKategorileri;
  late List<UrunVarligi> _menuUrunleri;
  List<HammaddeStokVarligi> _hammaddeler = const <HammaddeStokVarligi>[];

  @override
  void initState() {
    super.initState();
    _salonBolumleri = widget.salonBolumleri;
    _menuKategorileri = widget.menuKategorileri;
    _menuUrunleri = widget.menuUrunleri;
    _hammaddeleriYukle();
  }

  Future<void> _hammaddeleriYukle() async {
    final List<HammaddeStokVarligi> hammaddeler = await widget.servisKaydi
        .hammaddeleriGetirUseCase();
    if (!mounted) {
      return;
    }
    setState(() {
      _hammaddeler = hammaddeler;
    });
  }

  Future<void> _yenile() async {
    await widget.veriYenile();
    final List<SalonBolumuVarligi> salonBolumleri = await widget.servisKaydi
        .salonBolumleriniGetirUseCase();
    final List<KategoriVarligi> menuKategorileri = await widget.servisKaydi
        .kategorileriGetirUseCase();
    final List<UrunVarligi> menuUrunleri = await widget.servisKaydi
        .urunleriGetirUseCase();
    final List<HammaddeStokVarligi> hammaddeler = await widget.servisKaydi
        .hammaddeleriGetirUseCase();

    if (!mounted) {
      return;
    }

    setState(() {
      _salonBolumleri = salonBolumleri;
      _menuKategorileri = menuKategorileri;
      _menuUrunleri = menuUrunleri;
      _hammaddeler = hammaddeler;
    });
  }

  Future<void> _bolumEkle() async {
    final _SalonBolumuFormSonucu? sonuc =
        await showDialog<_SalonBolumuFormSonucu>(
          context: context,
          builder: (BuildContext context) => const _SalonBolumuFormDialog(),
        );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.salonBolumuEkleUseCase(
      SalonBolumuVarligi(
        id: 'blm_${DateTime.now().microsecondsSinceEpoch}',
        ad: sonuc.ad,
        aciklama: sonuc.aciklama,
      ),
    );
    await _yenile();
  }

  Future<void> _bolumDuzenle(SalonBolumuVarligi bolum) async {
    final _SalonBolumuFormSonucu? sonuc =
        await showDialog<_SalonBolumuFormSonucu>(
          context: context,
          builder: (BuildContext context) =>
              _SalonBolumuFormDialog(baslangicBolumu: bolum),
        );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.salonBolumuGuncelleUseCase(
      bolum.copyWith(ad: sonuc.ad, aciklama: sonuc.aciklama),
    );
    await _yenile();
  }

  Future<void> _bolumSil(SalonBolumuVarligi bolum) async {
    await widget.servisKaydi.salonBolumuSilUseCase(bolum.id);
    await _yenile();
  }

  Future<void> _masaEkle(SalonBolumuVarligi bolum) async {
    final _MasaFormSonucu? sonuc = await showDialog<_MasaFormSonucu>(
      context: context,
      builder: (BuildContext context) => _MasaFormDialog(bolumAdi: bolum.ad),
    );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.masaEkleUseCase(
      bolum.id,
      MasaTanimiVarligi(
        id: 'masa_${DateTime.now().microsecondsSinceEpoch}',
        ad: sonuc.ad,
        kapasite: sonuc.kapasite,
      ),
    );
    await _yenile();
  }

  Future<void> _masaDuzenle(
    SalonBolumuVarligi bolum,
    MasaTanimiVarligi masa,
  ) async {
    final _MasaFormSonucu? sonuc = await showDialog<_MasaFormSonucu>(
      context: context,
      builder: (BuildContext context) =>
          _MasaFormDialog(bolumAdi: bolum.ad, baslangicMasasi: masa),
    );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.masaGuncelleUseCase(
      bolumId: bolum.id,
      masa: masa.copyWith(ad: sonuc.ad, kapasite: sonuc.kapasite),
    );
    await _yenile();
  }

  Future<void> _masaSil(
    SalonBolumuVarligi bolum,
    MasaTanimiVarligi masa,
  ) async {
    await widget.servisKaydi.masaSilUseCase(bolumId: bolum.id, masaId: masa.id);
    await _yenile();
  }

  Future<void> _kategoriEkle() async {
    final _KategoriFormSonucu? sonuc = await showDialog<_KategoriFormSonucu>(
      context: context,
      builder: (BuildContext context) => const _KategoriFormDialog(),
    );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.kategoriEkleUseCase(
      KategoriVarligi(
        id: 'kat_${DateTime.now().microsecondsSinceEpoch}',
        ad: sonuc.ad,
        sira: _menuKategorileri.length + 1,
      ),
    );
    await _yenile();
  }

  Future<void> _kategoriDuzenle(KategoriVarligi kategori) async {
    final _KategoriFormSonucu? sonuc = await showDialog<_KategoriFormSonucu>(
      context: context,
      builder: (BuildContext context) =>
          _KategoriFormDialog(baslangicKategori: kategori),
    );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.kategoriGuncelleUseCase(
      kategori.copyWith(ad: sonuc.ad),
    );
    await _yenile();
  }

  Future<void> _kategoriSil(KategoriVarligi kategori) async {
    await widget.servisKaydi.kategoriSilUseCase(kategori.id);
    await _yenile();
  }

  Future<void> _urunEkle([UrunVarligi? urun]) async {
    if (_menuKategorileri.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Once bir kategori eklemelisin.')),
      );
      return;
    }
    final _UrunFormSonucu? sonuc = await showDialog<_UrunFormSonucu>(
      context: context,
      builder: (BuildContext context) =>
          _UrunFormDialog(kategoriler: _menuKategorileri, urun: urun),
    );
    if (sonuc == null) {
      return;
    }
    if (urun == null) {
      await widget.servisKaydi.urunEkleUseCase(
        UrunVarligi(
          id: 'urn_${DateTime.now().microsecondsSinceEpoch}',
          kategoriId: sonuc.kategoriId,
          ad: sonuc.ad,
          aciklama: sonuc.aciklama,
          fiyat: sonuc.fiyat,
          stoktaMi: sonuc.stoktaMi,
          oneCikanMi: sonuc.oneCikanMi,
        ),
      );
    } else {
      await widget.servisKaydi.urunGuncelleUseCase(
        urun.copyWith(
          kategoriId: sonuc.kategoriId,
          ad: sonuc.ad,
          aciklama: sonuc.aciklama,
          fiyat: sonuc.fiyat,
          stoktaMi: sonuc.stoktaMi,
          oneCikanMi: sonuc.oneCikanMi,
        ),
      );
    }
    await _yenile();
  }

  Future<void> _urunSil(UrunVarligi urun) async {
    await widget.servisKaydi.urunSilUseCase(urun.id);
    await _yenile();
  }

  Future<void> _hammaddeEkle() async {
    final _HammaddeFormSonucu? sonuc = await showDialog<_HammaddeFormSonucu>(
      context: context,
      builder: (BuildContext context) => const _HammaddeFormDialog(),
    );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.hammaddeEkleUseCase(
      HammaddeStokVarligi(
        id: 'ham_${DateTime.now().microsecondsSinceEpoch}',
        ad: sonuc.ad,
        birim: sonuc.birim,
        mevcutMiktar: sonuc.mevcutMiktar,
        kritikEsik: sonuc.kritikEsik,
        birimMaliyet: sonuc.birimMaliyet,
      ),
    );
    await _yenile();
  }

  Future<void> _hammaddeDuzenle(HammaddeStokVarligi hammadde) async {
    final _HammaddeFormSonucu? sonuc = await showDialog<_HammaddeFormSonucu>(
      context: context,
      builder: (BuildContext context) =>
          _HammaddeFormDialog(baslangicHammadde: hammadde),
    );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.hammaddeGuncelleUseCase(
      hammadde.copyWith(
        ad: sonuc.ad,
        birim: sonuc.birim,
        mevcutMiktar: sonuc.mevcutMiktar,
        kritikEsik: sonuc.kritikEsik,
        birimMaliyet: sonuc.birimMaliyet,
      ),
    );
    await _yenile();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: widget.baslangicSekmesi,
      child: Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120, maxHeight: 760),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin ayarlari',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Salon, masa, menu ve stok duzenini buradan yonetebilirsin.',
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4EEF8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const TabBar(
                    tabs: [
                      Tab(text: 'Salon'),
                      Tab(text: 'Menu'),
                      Tab(text: 'Stok'),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: TabBarView(
                    children: [
                      _AyarlarKart(
                        baslik: 'Salon ve masa yonetimi',
                        aciklama:
                            'Bolum ekle, masa kapasitesini tanimla ve gerekmeyen masalari kaldir.',
                        eylem: FilledButton.icon(
                          onPressed: _bolumEkle,
                          icon: const Icon(Icons.add_business_rounded),
                          label: const Text('Bolum ekle'),
                        ),
                        child: ListView(
                          children: _salonBolumleri
                              .map(
                                (SalonBolumuVarligi bolum) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _AdminBolumKarti(
                                    bolum: bolum,
                                    masaEkle: () => _masaEkle(bolum),
                                    bolumDuzenle: () => _bolumDuzenle(bolum),
                                    bolumSil: () => _bolumSil(bolum),
                                    masaDuzenle: (MasaTanimiVarligi masa) =>
                                        _masaDuzenle(bolum, masa),
                                    masaSil: (MasaTanimiVarligi masa) =>
                                        _masaSil(bolum, masa),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      _AyarlarKart(
                        baslik: 'Menu yonetimi',
                        aciklama:
                            'Kategori ve urunleri canli olarak duzenle, fiyatlari guncelle.',
                        eylem: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilledButton.icon(
                              onPressed: _kategoriEkle,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Kategori ekle'),
                            ),
                            FilledButton.tonalIcon(
                              onPressed: () => _urunEkle(),
                              icon: const Icon(Icons.restaurant_menu_rounded),
                              label: const Text('Urun ekle'),
                            ),
                          ],
                        ),
                        child: ListView(
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _menuKategorileri
                                  .map(
                                    (KategoriVarligi kategori) => InputChip(
                                      label: Text(kategori.ad),
                                      onPressed: () =>
                                          _kategoriDuzenle(kategori),
                                      onDeleted: () => _kategoriSil(kategori),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 16),
                            ..._menuUrunleri.map(
                              (UrunVarligi urun) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _AdminUrunSatiri(
                                  urun: urun,
                                  kategoriAdi: _kategoriAdiBul(urun.kategoriId),
                                  urunDuzenle: () => _urunEkle(urun),
                                  urunSil: () => _urunSil(urun),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _AyarlarKart(
                        baslik: 'Stok girisi',
                        aciklama:
                            'Hammadde ekle ve kritik seviyeye yaklasan kalemleri izle.',
                        eylem: FilledButton.icon(
                          onPressed: _hammaddeEkle,
                          icon: const Icon(Icons.inventory_2_rounded),
                          label: const Text('Hammadde ekle'),
                        ),
                        child: ListView(
                          children: _hammaddeler
                              .map(
                                (HammaddeStokVarligi hammadde) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _AdminHammaddeSatiri(
                                    hammadde: hammadde,
                                    duzenle: () => _hammaddeDuzenle(hammadde),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _kategoriAdiBul(String kategoriId) {
    for (final KategoriVarligi kategori in _menuKategorileri) {
      if (kategori.id == kategoriId) {
        return kategori.ad;
      }
    }
    return 'Kategori yok';
  }
}

class _AyarlarKart extends StatelessWidget {
  const _AyarlarKart({
    required this.baslik,
    required this.aciklama,
    required this.eylem,
    required this.child,
  });

  final String baslik;
  final String aciklama;
  final Widget eylem;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5FB),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(aciklama, style: const TextStyle(color: Color(0xFF6D6079))),
          const SizedBox(height: 14),
          eylem,
          const SizedBox(height: 16),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _AdminBolumKarti extends StatelessWidget {
  const _AdminBolumKarti({
    required this.bolum,
    required this.masaEkle,
    required this.bolumDuzenle,
    required this.bolumSil,
    required this.masaDuzenle,
    required this.masaSil,
  });

  final SalonBolumuVarligi bolum;
  final VoidCallback masaEkle;
  final VoidCallback bolumDuzenle;
  final VoidCallback bolumSil;
  final ValueChanged<MasaTanimiVarligi> masaDuzenle;
  final ValueChanged<MasaTanimiVarligi> masaSil;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bolum.ad,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bolum.aciklama,
                      style: const TextStyle(color: Color(0xFF6D6079)),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: bolumDuzenle,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: bolumSil,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...bolum.masalar.map(
                (MasaTanimiVarligi masa) => Chip(
                  label: Text('Masa ${masa.ad} · ${masa.kapasite} kisilik'),
                  avatar: IconButton(
                    onPressed: () => masaDuzenle(masa),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  onDeleted: () => masaSil(masa),
                ),
              ),
              ActionChip(
                avatar: const Icon(Icons.add, size: 18),
                label: const Text('Masa ekle'),
                onPressed: masaEkle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminUrunSatiri extends StatelessWidget {
  const _AdminUrunSatiri({
    required this.urun,
    required this.kategoriAdi,
    required this.urunDuzenle,
    required this.urunSil,
  });

  final UrunVarligi urun;
  final String kategoriAdi;
  final VoidCallback urunDuzenle;
  final VoidCallback urunSil;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  urun.ad,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                _paraYaz(urun.fiyat),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$kategoriAdi · ${urun.stoktaMi ? 'Stokta' : 'Kapali'}${urun.oneCikanMi ? ' · One cikan' : ''}',
            style: const TextStyle(color: Color(0xFF6D6079)),
          ),
          const SizedBox(height: 6),
          Text(urun.aciklama, style: const TextStyle(color: Color(0xFF6D6079))),
          const SizedBox(height: 10),
          Row(
            children: [
              FilledButton.tonal(
                onPressed: urunDuzenle,
                child: const Text('Duzenle'),
              ),
              const SizedBox(width: 8),
              TextButton(onPressed: urunSil, child: const Text('Kaldir')),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminHammaddeSatiri extends StatelessWidget {
  const _AdminHammaddeSatiri({required this.hammadde, required this.duzenle});

  final HammaddeStokVarligi hammadde;
  final VoidCallback duzenle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hammadde.kritikMi
              ? const Color(0xFFFFC7B8)
              : const Color(0xFFE8E0F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  hammadde.ad,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                hammadde.kritikMi ? 'Kritik' : 'Normal',
                style: TextStyle(
                  color: hammadde.kritikMi
                      ? const Color(0xFFFF7A59)
                      : const Color(0xFF30C48D),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${hammadde.mevcutMiktar.toStringAsFixed(0)} ${hammadde.birim} · Esik ${hammadde.kritikEsik.toStringAsFixed(0)} ${hammadde.birim}',
            style: const TextStyle(color: Color(0xFF6D6079)),
          ),
          const SizedBox(height: 6),
          Text(
            'Birim maliyet ${_paraYaz(hammadde.birimMaliyet)}',
            style: const TextStyle(color: Color(0xFF6D6079)),
          ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: duzenle,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Duzenle'),
          ),
        ],
      ),
    );
  }
}

class _SalonBolumuFormSonucu {
  const _SalonBolumuFormSonucu({required this.ad, required this.aciklama});

  final String ad;
  final String aciklama;
}

class _SalonBolumuFormDialog extends StatefulWidget {
  const _SalonBolumuFormDialog({this.baslangicBolumu});

  final SalonBolumuVarligi? baslangicBolumu;

  @override
  State<_SalonBolumuFormDialog> createState() => _SalonBolumuFormDialogState();
}

class _SalonBolumuFormDialogState extends State<_SalonBolumuFormDialog> {
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
    return AlertDialog(
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
            ).pop(_SalonBolumuFormSonucu(ad: ad, aciklama: aciklama));
          },
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}

class _MasaFormSonucu {
  const _MasaFormSonucu({required this.ad, required this.kapasite});

  final String ad;
  final int kapasite;
}

class _MasaFormDialog extends StatefulWidget {
  const _MasaFormDialog({required this.bolumAdi, this.baslangicMasasi});

  final String bolumAdi;
  final MasaTanimiVarligi? baslangicMasasi;

  @override
  State<_MasaFormDialog> createState() => _MasaFormDialogState();
}

class _MasaFormDialogState extends State<_MasaFormDialog> {
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
    return AlertDialog(
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
            ).pop(_MasaFormSonucu(ad: ad, kapasite: _kapasite));
          },
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}

class _KategoriFormSonucu {
  const _KategoriFormSonucu({required this.ad});

  final String ad;
}

class _KategoriFormDialog extends StatefulWidget {
  const _KategoriFormDialog({this.baslangicKategori});

  final KategoriVarligi? baslangicKategori;

  @override
  State<_KategoriFormDialog> createState() => _KategoriFormDialogState();
}

class _KategoriFormDialogState extends State<_KategoriFormDialog> {
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
    return AlertDialog(
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
            Navigator.of(context).pop(_KategoriFormSonucu(ad: ad));
          },
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}

class _UrunFormSonucu {
  const _UrunFormSonucu({
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

class _UrunFormDialog extends StatefulWidget {
  const _UrunFormDialog({required this.kategoriler, this.urun});

  final List<KategoriVarligi> kategoriler;
  final UrunVarligi? urun;

  @override
  State<_UrunFormDialog> createState() => _UrunFormDialogState();
}

class _UrunFormDialogState extends State<_UrunFormDialog> {
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
    return AlertDialog(
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
              _UrunFormSonucu(
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
    );
  }
}

class _HammaddeFormSonucu {
  const _HammaddeFormSonucu({
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

class _HammaddeFormDialog extends StatefulWidget {
  const _HammaddeFormDialog({this.baslangicHammadde});

  final HammaddeStokVarligi? baslangicHammadde;

  @override
  State<_HammaddeFormDialog> createState() => _HammaddeFormDialogState();
}

class _HammaddeFormDialogState extends State<_HammaddeFormDialog> {
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
    return AlertDialog(
      title: Text(
        widget.baslangicHammadde == null ? 'Hammadde ekle' : 'Hammadde duzenle',
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
              _HammaddeFormSonucu(
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
    );
  }
}

String _durumEtiketi(SiparisDurumu durum) {
  switch (durum) {
    case SiparisDurumu.alindi:
      return 'Alindi';
    case SiparisDurumu.hazirlaniyor:
      return 'Hazirlaniyor';
    case SiparisDurumu.hazir:
      return 'Hazir';
    case SiparisDurumu.yolda:
      return 'Yolda';
    case SiparisDurumu.teslimEdildi:
      return 'Teslim edildi';
    case SiparisDurumu.iptalEdildi:
      return 'Iptal edildi';
  }
}

String _teslimatEtiketi(TeslimatTipi teslimatTipi) {
  switch (teslimatTipi) {
    case TeslimatTipi.restorandaYe:
      return 'Restoranda ye';
    case TeslimatTipi.gelAl:
      return 'Gel al';
    case TeslimatTipi.paketServis:
      return 'Paket servis';
  }
}

String _siparisAltEtiketi(SiparisVarligi siparis) {
  final String masaEtiketi =
      siparis.masaNo != null && siparis.masaNo!.isNotEmpty
      ? ' - Masa ${siparis.masaNo}'
      : '';
  return '${_teslimatEtiketi(siparis.teslimatTipi)}$masaEtiketi - ${siparis.kalemler.length} kalem';
}

Color _durumRengi(SiparisDurumu durum) {
  switch (durum) {
    case SiparisDurumu.alindi:
      return const Color(0xFF8B6DFF);
    case SiparisDurumu.hazirlaniyor:
      return const Color(0xFFFF7A59);
    case SiparisDurumu.hazir:
      return const Color(0xFF30C48D);
    case SiparisDurumu.yolda:
      return const Color(0xFF5B8CFF);
    case SiparisDurumu.teslimEdildi:
      return const Color(0xFF00A389);
    case SiparisDurumu.iptalEdildi:
      return const Color(0xFFE44857);
  }
}

int _durumOnceligi(SiparisDurumu durum) {
  switch (durum) {
    case SiparisDurumu.hazirlaniyor:
      return 0;
    case SiparisDurumu.hazir:
      return 1;
    case SiparisDurumu.yolda:
      return 2;
    case SiparisDurumu.alindi:
      return 3;
    case SiparisDurumu.teslimEdildi:
      return 4;
    case SiparisDurumu.iptalEdildi:
      return 5;
  }
}

String _paraYaz(double tutar) {
  final String tamSayi = tutar.toStringAsFixed(2).replaceAll('.', ',');
  return '$tamSayi TL';
}
