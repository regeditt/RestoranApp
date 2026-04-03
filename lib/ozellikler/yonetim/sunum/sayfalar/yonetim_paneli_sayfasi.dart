import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/kategori_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_karti_varligi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/urun_varligi.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/servisler/qr_menu_baglami_cozumleyici.dart';
import 'package:restoran_app/ozellikler/menu/uygulama/servisler/qr_menu_pdf_servisi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/hammadde_stok_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/recete_kalemi_varligi.dart';
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
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_rapor_kartlari.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yazici_yonetimi_karti.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/servisler/yonetim_raporu_hesaplayici.dart';
import 'package:url_launcher/url_launcher.dart';

class YonetimPaneliSayfasi extends StatefulWidget {
  const YonetimPaneliSayfasi({super.key});

  @override
  State<YonetimPaneliSayfasi> createState() => _YonetimPaneliSayfasiState();
}

class _YonetimPaneliSayfasiState extends State<YonetimPaneliSayfasi> {
  final ServisKaydi _servisKaydi = ServisKaydi.ortak;
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
  void initState() {
    super.initState();
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
  Map<String, List<ReceteKalemiVarligi>> _urunReceteleri =
      const <String, List<ReceteKalemiVarligi>>{};

  @override
  void initState() {
    super.initState();
    _salonBolumleri = widget.salonBolumleri;
    _menuKategorileri = widget.menuKategorileri;
    _menuUrunleri = widget.menuUrunleri;
    _stokVerileriniYukle();
  }

  Future<void> _stokVerileriniYukle() async {
    final List<HammaddeStokVarligi> hammaddeler = await widget.servisKaydi
        .hammaddeleriGetirUseCase();
    final Map<String, List<ReceteKalemiVarligi>> urunReceteleri =
        await _urunReceteleriniYukle(_menuUrunleri);
    if (!mounted) {
      return;
    }
    setState(() {
      _hammaddeler = hammaddeler;
      _urunReceteleri = urunReceteleri;
    });
  }

  Future<Map<String, List<ReceteKalemiVarligi>>> _urunReceteleriniYukle(
    List<UrunVarligi> urunler,
  ) async {
    final Map<String, List<ReceteKalemiVarligi>> receteler =
        <String, List<ReceteKalemiVarligi>>{};
    for (final UrunVarligi urun in urunler) {
      receteler[urun.id] = await widget.servisKaydi.receteyiGetirUseCase(
        urun.id,
      );
    }
    return receteler;
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
    final Map<String, List<ReceteKalemiVarligi>> urunReceteleri =
        await _urunReceteleriniYukle(menuUrunleri);

    if (!mounted) {
      return;
    }

    setState(() {
      _salonBolumleri = salonBolumleri;
      _menuKategorileri = menuKategorileri;
      _menuUrunleri = menuUrunleri;
      _hammaddeler = hammaddeler;
      _urunReceteleri = urunReceteleri;
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

  Future<void> _masaQrBaglamiAc(
    SalonBolumuVarligi bolum,
    MasaTanimiVarligi masa,
  ) async {
    final String qrUrl = _masaQrUrliniOlustur(bolum, masa);
    final QrMenuKartiVarligi qrKarti = QrMenuKartiVarligi(
      baslik: 'Masa ${masa.ad}',
      altBaslik: bolum.ad,
      url: qrUrl,
    );

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Masa ${masa.ad} QR baglami'),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${bolum.ad} bolumu icin gercek QR menu adresi hazir.',
                  style: const TextStyle(color: Color(0xFF6D6079)),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFDF7FB), Color(0xFFFFFFFF)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE4D8EE)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x11000000),
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCE3EC),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            UygulamaSabitleri.tamMarkaAdi,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              color: Color(0xFFA13A63),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        QrImageView(
                          data: qrUrl,
                          version: QrVersions.auto,
                          size: 220,
                          backgroundColor: Colors.white,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Color(0xFF221530),
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Color(0xFF221530),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Masa ${masa.ad}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Color(0xFF2D2140),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bolum.ad,
                          style: const TextStyle(
                            color: Color(0xFF6D6079),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tarat ve masaya ozel menuye ulas',
                          style: TextStyle(
                            color: const Color(
                              0xFF6D6079,
                            ).withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4EEF8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SelectableText(
                    qrUrl,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D2140),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text('Masa ${masa.ad}')),
                    Chip(label: Text('Bolum ${bolum.ad}')),
                    const Chip(label: Text('Kaynak qr')),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Kapat'),
            ),
            FilledButton.tonalIcon(
              onPressed: () async {
                final NavigatorState gezgin = Navigator.of(dialogContext);
                final bool acildi = await _qrLinkiniAc(qrUrl);
                if (!mounted) {
                  return;
                }
                if (!acildi) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('QR menu adresi acilamadi')),
                  );
                  return;
                }
                gezgin.pop();
              },
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('Ac'),
            ),
            FilledButton.tonalIcon(
              onPressed: () async {
                await QrMenuPdfServisi.kartlariYazdir(
                  belgeBasligi: 'Masa ${masa.ad} QR Karti',
                  kartlar: <QrMenuKartiVarligi>[qrKarti],
                );
              },
              icon: const Icon(Icons.print_rounded),
              label: const Text('Yazdir / PDF'),
            ),
            FilledButton.icon(
              onPressed: () async {
                final NavigatorState gezgin = Navigator.of(dialogContext);
                await Clipboard.setData(ClipboardData(text: qrUrl));
                if (!mounted) {
                  return;
                }
                gezgin.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Masa ${masa.ad} icin QR linki panoya kopyalandi',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.copy_rounded),
              label: const Text('Linki kopyala'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _topluQrSayfasiniAc() async {
    final List<QrMenuKartiVarligi> kartlar = _tumMasaQrKartlari;
    if (kartlar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Toplu QR icin masa bulunamadi')),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 980,
            height: 720,
            child: Padding(
              padding: const EdgeInsets.all(20),
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
                              'Toplu QR sayfasi',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Tum masalarin taranabilir QR kartlari tek yerde gorunur.',
                              style: TextStyle(color: Color(0xFF6D6079)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.tonalIcon(
                        onPressed: () async {
                          await QrMenuPdfServisi.kartlariYazdir(
                            belgeBasligi: 'Toplu Masa QR Kartlari',
                            kartlar: kartlar,
                          );
                        },
                        icon: const Icon(Icons.print_rounded),
                        label: const Text('Toplu yazdir'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.tonalIcon(
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: _topluQrMetniOlustur(kartlar)),
                          );
                          if (!mounted) {
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Tum masa QR linkleri panoya kopyalandi',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy_all_rounded),
                        label: const Text('Tum linkleri kopyala'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Kapat'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: kartlar.map((QrMenuKartiVarligi kart) {
                          return _TopluQrKarti(kart: kart);
                        }).toList(),
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

  String _masaQrUrliniOlustur(
    SalonBolumuVarligi bolum,
    MasaTanimiVarligi masa,
  ) {
    final Uri tabanUri = Uri.base;
    final String tabanUrl = tabanUri.hasScheme && tabanUri.host.isNotEmpty
        ? '${tabanUri.scheme}://${tabanUri.authority}'
        : UygulamaSabitleri.varsayilanQrTabanUrl;

    return QrMenuBaglamiCozumleyici.qrUrlOlustur(
      tabanUrl: tabanUrl,
      masaNo: masa.ad,
      bolumAdi: bolum.ad.toLowerCase().replaceAll(' ', '_'),
      kaynak: 'qr',
    );
  }

  Future<bool> _qrLinkiniAc(String qrUrl) async {
    final Uri uri = Uri.parse(qrUrl);
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  List<QrMenuKartiVarligi> get _tumMasaQrKartlari {
    final List<QrMenuKartiVarligi> kartlar = <QrMenuKartiVarligi>[];
    for (final SalonBolumuVarligi bolum in _salonBolumleri) {
      for (final MasaTanimiVarligi masa in bolum.masalar) {
        kartlar.add(
          QrMenuKartiVarligi(
            baslik: 'Masa ${masa.ad}',
            altBaslik: bolum.ad,
            url: _masaQrUrliniOlustur(bolum, masa),
          ),
        );
      }
    }
    return kartlar;
  }

  String _topluQrMetniOlustur(List<QrMenuKartiVarligi> kartlar) {
    return kartlar
        .map(
          (QrMenuKartiVarligi kart) =>
              '${kart.baslik} | ${kart.altBaslik}\n${kart.url}',
        )
        .join('\n\n');
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

  Future<void> _urunRecetesiniDuzenle(UrunVarligi urun) async {
    final List<ReceteKalemiVarligi> baslangicRecetesi =
        _urunReceteleri[urun.id] ?? const <ReceteKalemiVarligi>[];
    final List<ReceteKalemiVarligi>? sonuc =
        await showDialog<List<ReceteKalemiVarligi>>(
          context: context,
          builder: (BuildContext context) => _ReceteDuzenlemeDialog(
            urun: urun,
            hammaddeler: _hammaddeler,
            baslangicRecetesi: baslangicRecetesi,
          ),
        );
    if (sonuc == null) {
      return;
    }
    await widget.servisKaydi.receteyiKaydetUseCase(urun.id, sonuc);
    await _yenile();

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${urun.ad} recetesi guncellendi')));
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
                        eylem: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilledButton.icon(
                              onPressed: _bolumEkle,
                              icon: const Icon(Icons.add_business_rounded),
                              label: const Text('Bolum ekle'),
                            ),
                            FilledButton.tonalIcon(
                              onPressed: _topluQrSayfasiniAc,
                              icon: const Icon(Icons.qr_code_2_rounded),
                              label: const Text('Toplu QR sayfasi'),
                            ),
                          ],
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
                                    qrBaglamiAc: (MasaTanimiVarligi masa) =>
                                        _masaQrBaglamiAc(bolum, masa),
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
                                  receteOzeti: _receteOzetiniOlustur(urun.id),
                                  urunDuzenle: () => _urunEkle(urun),
                                  receteDuzenle: () =>
                                      _urunRecetesiniDuzenle(urun),
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

  String _receteOzetiniOlustur(String urunId) {
    final List<ReceteKalemiVarligi> recete =
        _urunReceteleri[urunId] ?? const <ReceteKalemiVarligi>[];
    if (recete.isEmpty) {
      return 'Recete tanimli degil';
    }

    final Map<String, HammaddeStokVarligi> hammaddeHaritasi =
        <String, HammaddeStokVarligi>{
          for (final HammaddeStokVarligi hammadde in _hammaddeler)
            hammadde.id: hammadde,
        };
    final Iterable<String> etiketler = recete.map((ReceteKalemiVarligi kalem) {
      final HammaddeStokVarligi? hammadde = hammaddeHaritasi[kalem.hammaddeId];
      if (hammadde == null) {
        return '${kalem.miktar.toStringAsFixed(1)} bilinmeyen';
      }
      return '${hammadde.ad} ${kalem.miktar.toStringAsFixed(1)} ${hammadde.birim}';
    });
    return etiketler.join(' • ');
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
    required this.qrBaglamiAc,
    required this.masaDuzenle,
    required this.masaSil,
  });

  final SalonBolumuVarligi bolum;
  final VoidCallback masaEkle;
  final VoidCallback bolumDuzenle;
  final VoidCallback bolumSil;
  final ValueChanged<MasaTanimiVarligi> qrBaglamiAc;
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
                (MasaTanimiVarligi masa) => InputChip(
                  label: Text('Masa ${masa.ad} - ${masa.kapasite} kisilik'),
                  avatar: PopupMenuButton<String>(
                    tooltip: 'Masa islemleri',
                    onSelected: (String islem) {
                      switch (islem) {
                        case 'qr':
                          qrBaglamiAc(masa);
                          break;
                        case 'duzenle':
                          masaDuzenle(masa);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => const [
                      PopupMenuItem<String>(
                        value: 'qr',
                        child: Text('QR baglamini ac'),
                      ),
                      PopupMenuItem<String>(
                        value: 'duzenle',
                        child: Text('Masayi duzenle'),
                      ),
                    ],
                    icon: const Icon(Icons.more_horiz_rounded, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  onPressed: () => qrBaglamiAc(masa),
                  onDeleted: () => masaSil(masa),
                  deleteIcon: const Icon(Icons.delete_outline_rounded),
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
    required this.receteOzeti,
    required this.urunDuzenle,
    required this.receteDuzenle,
    required this.urunSil,
  });

  final UrunVarligi urun;
  final String kategoriAdi;
  final String receteOzeti;
  final VoidCallback urunDuzenle;
  final VoidCallback receteDuzenle;
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
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5FB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recete baglantisi',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  receteOzeti,
                  style: const TextStyle(color: Color(0xFF6D6079), height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              FilledButton.tonal(
                onPressed: urunDuzenle,
                child: const Text('Duzenle'),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: receteDuzenle,
                child: const Text('Recete'),
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

class _ReceteSatiriGirdisi {
  const _ReceteSatiriGirdisi({required this.hammaddeId, required this.miktar});

  final String hammaddeId;
  final double miktar;

  _ReceteSatiriGirdisi copyWith({String? hammaddeId, double? miktar}) {
    return _ReceteSatiriGirdisi(
      hammaddeId: hammaddeId ?? this.hammaddeId,
      miktar: miktar ?? this.miktar,
    );
  }
}

class _ReceteDuzenlemeDialog extends StatefulWidget {
  const _ReceteDuzenlemeDialog({
    required this.urun,
    required this.hammaddeler,
    required this.baslangicRecetesi,
  });

  final UrunVarligi urun;
  final List<HammaddeStokVarligi> hammaddeler;
  final List<ReceteKalemiVarligi> baslangicRecetesi;

  @override
  State<_ReceteDuzenlemeDialog> createState() => _ReceteDuzenlemeDialogState();
}

class _ReceteDuzenlemeDialogState extends State<_ReceteDuzenlemeDialog> {
  late List<_ReceteSatiriGirdisi> _satirlar;

  @override
  void initState() {
    super.initState();
    _satirlar = widget.baslangicRecetesi
        .map(
          (ReceteKalemiVarligi kalem) => _ReceteSatiriGirdisi(
            hammaddeId: kalem.hammaddeId,
            miktar: kalem.miktar,
          ),
        )
        .toList();
    if (_satirlar.isEmpty && widget.hammaddeler.isNotEmpty) {
      _satirEkle();
    }
  }

  void _satirEkle() {
    if (widget.hammaddeler.isEmpty) {
      return;
    }
    final String varsayilanHammaddeId = widget.hammaddeler.first.id;
    setState(() {
      _satirlar = <_ReceteSatiriGirdisi>[
        ..._satirlar,
        _ReceteSatiriGirdisi(hammaddeId: varsayilanHammaddeId, miktar: 1),
      ];
    });
  }

  void _satirSil(int index) {
    setState(() {
      _satirlar = <_ReceteSatiriGirdisi>[..._satirlar.where((_) => true)]
        ..removeAt(index);
    });
  }

  void _satirGuncelle(int index, _ReceteSatiriGirdisi satir) {
    setState(() {
      _satirlar = <_ReceteSatiriGirdisi>[
        for (int i = 0; i < _satirlar.length; i++)
          if (i == index) satir else _satirlar[i],
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.urun.ad} recetesi'),
      content: SizedBox(
        width: 540,
        child: widget.hammaddeler.isEmpty
            ? const Text('Once hammadde ekleyip tekrar dene.')
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bu urun icin kullanilan hammaddeleri ve tuketim miktarlarini belirle.',
                    ),
                    const SizedBox(height: 16),
                    ..._satirlar.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ReceteSatiri(
                          key: ValueKey('recete_satiri_${entry.key}'),
                          satir: entry.value,
                          hammaddeler: widget.hammaddeler,
                          kaldir: _satirlar.length == 1
                              ? null
                              : () => _satirSil(entry.key),
                          guncelle: (_ReceteSatiriGirdisi satir) =>
                              _satirGuncelle(entry.key, satir),
                        ),
                      ),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: _satirEkle,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Kalem ekle'),
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
            final List<ReceteKalemiVarligi> recete = _satirlar
                .where((satir) => satir.miktar > 0)
                .map(
                  (satir) => ReceteKalemiVarligi(
                    hammaddeId: satir.hammaddeId,
                    miktar: satir.miktar,
                  ),
                )
                .toList();
            Navigator.of(context).pop(recete);
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}

class _ReceteSatiri extends StatefulWidget {
  const _ReceteSatiri({
    super.key,
    required this.satir,
    required this.hammaddeler,
    required this.guncelle,
    this.kaldir,
  });

  final _ReceteSatiriGirdisi satir;
  final List<HammaddeStokVarligi> hammaddeler;
  final ValueChanged<_ReceteSatiriGirdisi> guncelle;
  final VoidCallback? kaldir;

  @override
  State<_ReceteSatiri> createState() => _ReceteSatiriState();
}

class _ReceteSatiriState extends State<_ReceteSatiri> {
  late final TextEditingController _miktarDenetleyici;

  @override
  void initState() {
    super.initState();
    _miktarDenetleyici = TextEditingController(
      text: widget.satir.miktar.toStringAsFixed(1),
    );
  }

  @override
  void didUpdateWidget(covariant _ReceteSatiri oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.satir.miktar != widget.satir.miktar) {
      _miktarDenetleyici.text = widget.satir.miktar.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _miktarDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HammaddeStokVarligi seciliHammadde = widget.hammaddeler.firstWhere(
      (HammaddeStokVarligi hammadde) => hammadde.id == widget.satir.hammaddeId,
      orElse: () => widget.hammaddeler.first,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E0F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: DropdownButtonFormField<String>(
              initialValue: seciliHammadde.id,
              decoration: const InputDecoration(labelText: 'Hammadde'),
              items: widget.hammaddeler
                  .map(
                    (HammaddeStokVarligi hammadde) => DropdownMenuItem<String>(
                      value: hammadde.id,
                      child: Text('${hammadde.ad} (${hammadde.birim})'),
                    ),
                  )
                  .toList(),
              onChanged: (String? deger) {
                if (deger == null) {
                  return;
                }
                widget.guncelle(widget.satir.copyWith(hammaddeId: deger));
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 4,
            child: TextField(
              controller: _miktarDenetleyici,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Miktar',
                helperText: seciliHammadde.birim,
              ),
              onChanged: (String deger) {
                final double? miktar = double.tryParse(
                  deger.trim().replaceAll(',', '.'),
                );
                widget.guncelle(widget.satir.copyWith(miktar: miktar ?? 0));
              },
            ),
          ),
          if (widget.kaldir != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: widget.kaldir,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ],
      ),
    );
  }
}

class _TopluQrKarti extends StatelessWidget {
  const _TopluQrKarti({required this.kart});

  final QrMenuKartiVarligi kart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFDF7FB), Color(0xFFFFFFFF)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4D8EE)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE3EC),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              UygulamaSabitleri.tamMarkaAdi,
              style: const TextStyle(
                color: Color(0xFFA13A63),
                fontWeight: FontWeight.w900,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 10),
          QrImageView(
            data: kart.url,
            version: QrVersions.auto,
            size: 150,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            kart.baslik,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            kart.altBaslik,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6D6079),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tarat ve menuye ulas',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6D6079),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
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
