import 'package:flutter/material.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/bagimlilik/servis_saglayici.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/stok_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/saatlik_siparis_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/sistem_yazici_adayi_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yonetim_paneli_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_analiz_kartlari.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/masa_plani_karti.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/paket_servis_operasyon_karti.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/personel_yonetimi_karti.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_ayarlari_dialogu.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_paneli_yardimcilari.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yazici_form_dialogu.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_rapor_kartlari.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yazici_yonetimi_karti.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/servisler/yonetim_raporu_hesaplayici.dart';

class YonetimPaneliSayfasi extends StatefulWidget {
  const YonetimPaneliSayfasi({super.key});

  @override
  State<YonetimPaneliSayfasi> createState() => _YonetimPaneliSayfasiState();
}

class _YonetimPaneliSayfasiState extends State<YonetimPaneliSayfasi> {
  late final ServisKaydi _servisKaydi;
  bool _servisHazir = false;
  final TextEditingController _aramaDenetleyici = TextEditingController();
  final ScrollController _sayfaKaydirmaDenetleyicisi = ScrollController();

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_servisHazir) {
      return;
    }
    _servisKaydi = ServisSaglayici.of(context);
    _servisHazir = true;
    _yukle();
  }

  @override
  void dispose() {
    _aramaDenetleyici.dispose();
    _sayfaKaydirmaDenetleyicisi.dispose();
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
    final YaziciFormSonucu? sonuc = await showDialog<YaziciFormSonucu>(
      context: context,
      builder: (BuildContext context) {
        return YaziciFormDialog(sistemYazicilari: _sistemYazicilari);
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
        return YaziciYonetimiDialog(
          yazicilar: _yazicilar,
          siparisler: _siparisler,
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
        return YonetimAyarlariDialog(
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
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: _sayfaKaydirmaDenetleyicisi,
                        child: ListView(
                          controller: _sayfaKaydirmaDenetleyicisi,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
            final int durumKarsilastirma = durumOnceligi(
              a.durum,
            ).compareTo(durumOnceligi(b.durum));
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
                      ).pushReplacementNamed(RotaYapisi.personelGiris);
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
                    label: const Text('Personel girisine don'),
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
                  deger: paraYaz(ozet.toplamCiro),
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
        mainAxisSize: MainAxisSize.min,
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
      final Color durumRenk = durumRengi(siparis.durum);

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
                      siparisAltEtiketi(siparis),
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
                  durumEtiketi(siparis.durum),
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double genislik = constraints.maxWidth;
        final bool ikiKolon = genislik >= 760;
        final double yariGenislik = ikiKolon ? (genislik - 18) / 2 : genislik;

        return Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            SizedBox(
              width: yariGenislik,
              child: KanalDagilimiKarti(ozet: ozet),
            ),
            SizedBox(
              width: yariGenislik,
              child: PaketServisOperasyonKarti(siparisler: siparisler),
            ),
            SizedBox(
              width: yariGenislik,
              child: SaatlikTrendKarti(veriler: saatlikVeriler),
            ),
            if (stokOzeti != null)
              SizedBox(
                width: yariGenislik,
                child: StokVeMaliyetKarti(ozet: stokOzeti!),
              ),
            SizedBox(
              width: yariGenislik,
              child: PatronRaporuKarti(
                siparisler: siparisler,
                saatlikVeriler: saatlikVeriler,
              ),
            ),
            SizedBox(
              width: yariGenislik,
              child: PersonelYonetimiKarti(personeller: personeller),
            ),
            SizedBox(
              width: genislik,
              child: MasaPlaniKarti(
                siparisler: siparisler,
                salonBolumleri: salonBolumleri,
              ),
            ),
          ],
        );
      },
    );
  }
}
