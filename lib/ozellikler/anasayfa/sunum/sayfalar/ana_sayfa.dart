import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restoran_app/ortak/platform/konum_platformu.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ortak/tema/ana_sayfa_renk_sablonu.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';

const Color _anaArkaPlanKoyu = AnaSayfaRenkSablonu.arkaPlanKoyu;
const Color _anaArkaPlanOrta = AnaSayfaRenkSablonu.arkaPlanOrta;
const Color _anaArkaPlanUst = AnaSayfaRenkSablonu.arkaPlanUst;
const Color _anaPembe = AnaSayfaRenkSablonu.birincilAksiyon;
const Color _anaMor = AnaSayfaRenkSablonu.ikincilAksiyon;
const Color _panelKoyu = AnaSayfaRenkSablonu.panelKoyu;
const Color _metinAna = AnaSayfaRenkSablonu.metinAna;
const Color _metinIkincil = AnaSayfaRenkSablonu.metinIkincil;
const Color _cizgi = AnaSayfaRenkSablonu.cerceve;
const Color _yesilDurum = AnaSayfaRenkSablonu.basari;

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    final bool masaustu = EkranBoyutu.masaustu(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              _anaArkaPlanUst,
              _anaArkaPlanOrta,
              _anaArkaPlanKoyu,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1660),
              child: Padding(
                padding: EdgeInsets.all(masaustu ? 16 : 10),
                child: _PanelCercevesi(
                  child: masaustu
                      ? const AspectRatio(
                          aspectRatio: 1.86,
                          child: _MasaustuYerlesim(),
                        )
                      : const _MobilYerlesim(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PanelCercevesi extends StatelessWidget {
  const _PanelCercevesi({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[_anaPembe, _anaMor, _anaArkaPlanKoyu],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: _cizgi),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.38),
            blurRadius: 26,
            spreadRadius: 4,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(36), child: child),
    );
  }
}

class _MasaustuYerlesim extends StatelessWidget {
  const _MasaustuYerlesim();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, kisit) {
        final double solGenislik = kisit.maxWidth * 0.38;
        return Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      _anaArkaPlanUst,
                      _anaArkaPlanOrta,
                      _anaArkaPlanKoyu,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              width: solGenislik + 72,
              child: ClipPath(
                clipper: _SolPanelKivrimClipper(),
                child: const _SolPanel(),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.fromLTRB(solGenislik + 10, 14, 22, 14),
                child: const _SagPanel(masaustu: true),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MobilYerlesim extends StatelessWidget {
  const _MobilYerlesim();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: const [_SagPanel(masaustu: false)],
    );
  }
}

class _SolPanelKivrimClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path yol = Path();
    yol.moveTo(0, 0);
    yol.lineTo(size.width * 0.78, 0);
    yol.cubicTo(
      size.width * 0.96,
      size.height * 0.14,
      size.width * 0.94,
      size.height * 0.86,
      size.width * 0.72,
      size.height,
    );
    yol.lineTo(0, size.height);
    yol.close();
    return yol;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _SolPanel extends StatelessWidget {
  const _SolPanel();

  @override
  Widget build(BuildContext context) {
    final ThemeData temaVerisi = Theme.of(context);

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: <Color>[_anaPembe, _anaMor, _anaArkaPlanOrta],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double minYukseklik = (constraints.maxHeight - 40).clamp(
            0,
            double.infinity,
          );
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 20, 24, 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minYukseklik),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    UygulamaSabitleri.restoranAdi,
                    style: temaVerisi.textTheme.headlineMedium?.copyWith(
                      color: _metinAna,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Canli operasyon paneli',
                    style: temaVerisi.textTheme.labelLarge?.copyWith(
                      color: _metinIkincil,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _SaatHavaAlani(),
                  const SizedBox(height: 24),
                  const _KurListesi(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SaatHavaAlani extends StatefulWidget {
  const _SaatHavaAlani();

  @override
  State<_SaatHavaAlani> createState() => _SaatHavaAlaniState();
}

class _SaatHavaAlaniState extends State<_SaatHavaAlani> {
  DateTime _zaman = DateTime.now();
  _AnlikHavaDurumu? _havaDurumu;
  double _havaEnlem = UygulamaSabitleri.restoranKonumEnlem;
  double _havaBoylam = UygulamaSabitleri.restoranKonumBoylam;
  bool _konumHazirlamaDenendi = false;
  bool _konumKullanilabilir = false;
  Timer? _saatZamanlayicisi;
  Timer? _havaZamanlayicisi;

  static const List<String> _gunler = [
    'Pazartesi',
    'Sali',
    'Carsamba',
    'Persembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  static const List<String> _aylar = [
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

  @override
  void initState() {
    super.initState();
    _havaDurumuYukle();
    _saatZamanlayicisi = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _zaman = DateTime.now();
      });
    });
    _havaZamanlayicisi = Timer.periodic(const Duration(minutes: 10), (_) {
      _havaDurumuYukle();
    });
  }

  @override
  void dispose() {
    _saatZamanlayicisi?.cancel();
    _havaZamanlayicisi?.cancel();
    super.dispose();
  }

  Future<void> _havaDurumuYukle() async {
    await _havaKonumunuGuncelle();
    final _AnlikHavaDurumu? guncelDurum = await _HavaDurumuServisi.getir(
      enlem: _havaEnlem,
      boylam: _havaBoylam,
    );
    if (!mounted || guncelDurum == null) {
      return;
    }
    setState(() {
      _havaDurumu = guncelDurum;
    });
  }

  Future<void> _havaKonumunuGuncelle() async {
    if (!_konumHazirlamaDenendi) {
      final KonumHazirlamaSonucu hazirlamaSonucu = await konumPlatformu
          .hazirla();
      _konumKullanilabilir = hazirlamaSonucu.basarili;
      _konumHazirlamaDenendi = true;
    }
    if (!_konumKullanilabilir) {
      return;
    }
    final KonumNoktasi? konum = await konumPlatformu.anlikKonumGetir();
    if (konum == null) {
      return;
    }
    _havaEnlem = konum.enlem;
    _havaBoylam = konum.boylam;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData temaVerisi = Theme.of(context);
    final DateTime zaman = _zaman;
    final String tarih =
        '${zaman.day} ${_aylar[zaman.month - 1]} ${_gunler[zaman.weekday - 1]}';
    final String saat =
        '${_ikiBasamak(zaman.hour)}:${_ikiBasamak(zaman.minute)}';
    final _AnlikHavaDurumu? hava = _havaDurumu;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tarih,
          style: temaVerisi.textTheme.titleMedium?.copyWith(
            color: _metinIkincil.withValues(alpha: 0.96),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            Text(
              saat,
              style: temaVerisi.textTheme.displayLarge?.copyWith(
                color: _metinAna,
                fontWeight: FontWeight.w300,
                height: 0.96,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hava?.ikon ?? Icons.cloud_rounded,
                  size: 40,
                  color: _metinAna.withValues(alpha: 0.95),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hava?.sicaklikEtiketi ?? '-- C',
                      style: temaVerisi.textTheme.headlineMedium?.copyWith(
                        color: _metinAna,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      hava?.aciklama ?? 'Hava durumu yukleniyor...',
                      style: temaVerisi.textTheme.bodyLarge?.copyWith(
                        color: _metinIkincil.withValues(alpha: 0.95),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _ikiBasamak(int deger) => deger.toString().padLeft(2, '0');
}

class _AnlikHavaDurumu {
  const _AnlikHavaDurumu({required this.sicaklik, required this.havaKodu});

  final double sicaklik;
  final int havaKodu;

  String get sicaklikEtiketi => '${sicaklik.round()} C';

  String get aciklama => switch (havaKodu) {
    0 => 'Acik',
    1 => 'Az bulutlu',
    2 => 'Parcali bulutlu',
    3 => 'Bulutlu',
    45 || 48 => 'Sisli',
    51 || 53 || 55 || 56 || 57 => 'Cisenti',
    61 || 63 || 65 || 66 || 67 => 'Yagmurlu',
    71 || 73 || 75 || 77 => 'Karla karisik',
    80 || 81 || 82 => 'Saganak yagmur',
    85 || 86 => 'Kar yagisi',
    95 || 96 || 99 => 'Firtinali',
    _ => 'Bilinmiyor',
  };

  IconData get ikon => switch (havaKodu) {
    0 => Icons.wb_sunny_rounded,
    1 || 2 => Icons.wb_cloudy_rounded,
    3 => Icons.cloud_rounded,
    45 || 48 => Icons.foggy,
    51 || 53 || 55 || 56 || 57 => Icons.grain_rounded,
    61 || 63 || 65 || 66 || 67 || 80 || 81 || 82 => Icons.umbrella_rounded,
    71 || 73 || 75 || 77 || 85 || 86 => Icons.ac_unit_rounded,
    95 || 96 || 99 => Icons.thunderstorm_rounded,
    _ => Icons.cloud_rounded,
  };
}

abstract final class _HavaDurumuServisi {
  static Future<_AnlikHavaDurumu?> getir({
    required double enlem,
    required double boylam,
  }) async {
    try {
      final Uri uri =
          Uri.https('api.open-meteo.com', '/v1/forecast', <String, String>{
            'latitude': enlem.toStringAsFixed(4),
            'longitude': boylam.toStringAsFixed(4),
            'current': 'temperature_2m,weather_code',
            'timezone': 'auto',
          });
      final http.Response yanit = await http
          .get(uri)
          .timeout(const Duration(seconds: 8));
      if (yanit.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> veri =
          jsonDecode(yanit.body) as Map<String, dynamic>;
      final Map<String, dynamic>? current =
          veri['current'] as Map<String, dynamic>?;
      final num? sicaklik = current?['temperature_2m'] as num?;
      final int? havaKodu = _tamSayiCevir(current?['weather_code']);
      if (sicaklik == null || havaKodu == null) {
        return null;
      }
      return _AnlikHavaDurumu(
        sicaklik: sicaklik.toDouble(),
        havaKodu: havaKodu,
      );
    } catch (_) {
      return null;
    }
  }

  static int? _tamSayiCevir(Object? deger) {
    if (deger is int) {
      return deger;
    }
    if (deger is num) {
      return deger.toInt();
    }
    return int.tryParse('$deger');
  }
}

class _KurListesi extends StatefulWidget {
  const _KurListesi();

  @override
  State<_KurListesi> createState() => _KurListesiState();
}

class _KurListesiState extends State<_KurListesi> {
  List<_KurSatiriVerisi> _kurlar = const <_KurSatiriVerisi>[
    _KurSatiriVerisi(simge: '\$', kod: 'USD', deger: '34.2002'),
    _KurSatiriVerisi(simge: 'EUR', kod: 'EUR', deger: '37.5182'),
    _KurSatiriVerisi(simge: 'GBP', kod: 'GBP', deger: '44.8793'),
  ];
  Timer? _kurYenilemeZamanlayicisi;

  @override
  void initState() {
    super.initState();
    _kurlariYenile();
    _kurYenilemeZamanlayicisi = Timer.periodic(
      const Duration(minutes: 30),
      (_) => _kurlariYenile(),
    );
  }

  @override
  void dispose() {
    _kurYenilemeZamanlayicisi?.cancel();
    super.dispose();
  }

  Future<void> _kurlariYenile() async {
    final List<_KurSatiriVerisi>? guncelKurlar = await _KurServisi.getir();
    if (!mounted || guncelKurlar == null) {
      return;
    }
    setState(() {
      _kurlar = guncelKurlar;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData temaVerisi = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GUNCEL KURLAR',
          style: temaVerisi.textTheme.labelLarge?.copyWith(
            color: _metinAna.withValues(alpha: 0.86),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 10),
        ..._kurlar.map(
          (kur) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _KurSatiri(veri: kur),
          ),
        ),
      ],
    );
  }
}

class _KurSatiri extends StatelessWidget {
  const _KurSatiri({required this.veri});

  final _KurSatiriVerisi veri;

  @override
  Widget build(BuildContext context) {
    final ThemeData temaVerisi = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _anaArkaPlanKoyu.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _metinIkincil.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                veri.simge,
                textAlign: TextAlign.center,
                style: temaVerisi.textTheme.titleLarge?.copyWith(
                  color: _metinAna,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  veri.kod,
                  style: temaVerisi.textTheme.titleSmall?.copyWith(
                    color: _metinAna,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  veri.deger,
                  style: temaVerisi.textTheme.bodyMedium?.copyWith(
                    color: _metinIkincil,
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

class _SagPanel extends StatelessWidget {
  const _SagPanel({required this.masaustu});

  final bool masaustu;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _DurumSatiri(),
        const SizedBox(height: 14),
        _MenuIzgarasi(masaustu: masaustu),
        const SizedBox(height: 12),
        const _AltSatir(),
      ],
    );
  }
}

class _DurumSatiri extends StatelessWidget {
  const _DurumSatiri();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        children: [
          _DurumRozeti(
            ikon: Icons.storage_rounded,
            baslik: 'Server',
            alt: 'Online',
            vurgu: _yesilDurum,
          ),
          _DurumRozeti(
            ikon: Icons.wifi_rounded,
            baslik: 'Internet',
            alt: 'Online',
            vurgu: _yesilDurum,
          ),
          _DurumRozeti(
            ikon: Icons.location_city_rounded,
            baslik: UygulamaSabitleri.restoranAdi,
            alt: 'Sube',
            vurgu: _metinIkincil,
          ),
          _DurumRozeti(
            ikon: Icons.person_rounded,
            baslik: 'Yonetici',
            alt: 'aktif',
            vurgu: _metinIkincil,
            onTap: () => Navigator.of(context).pushNamed(RotaYapisi.hesabim),
          ),
        ],
      ),
    );
  }
}

class _DurumRozeti extends StatelessWidget {
  const _DurumRozeti({
    required this.ikon,
    required this.baslik,
    required this.alt,
    required this.vurgu,
    this.onTap,
  });

  final IconData ikon;
  final String baslik;
  final String alt;
  final Color vurgu;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData temaVerisi = Theme.of(context);
    final Widget icerik = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _panelKoyu.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cizgi),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 15, color: vurgu),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                baslik,
                style: temaVerisi.textTheme.labelLarge?.copyWith(
                  color: _metinAna,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                alt,
                style: temaVerisi.textTheme.labelSmall?.copyWith(
                  color: _metinIkincil.withValues(alpha: 0.92),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (onTap == null) {
      return icerik;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: icerik,
      ),
    );
  }
}

class _MenuIzgarasi extends StatelessWidget {
  const _MenuIzgarasi({required this.masaustu});

  final bool masaustu;

  @override
  Widget build(BuildContext context) {
    const List<_AnaMenuKartVerisi> kartlar = [
      _AnaMenuKartVerisi(
        ikon: Icons.local_pizza_outlined,
        baslik: 'Urunler',
        rota: RotaYapisi.qrMenu,
      ),
      _AnaMenuKartVerisi(
        ikon: Icons.inventory_2_outlined,
        baslik: 'Stoklar',
        rota: RotaYapisi.personelGiris,
      ),
      _AnaMenuKartVerisi(
        ikon: Icons.point_of_sale_rounded,
        baslik: 'Odeme Kasa',
        rota: RotaYapisi.odemeKasa,
      ),
      _AnaMenuKartVerisi(
        ikon: Icons.bar_chart_rounded,
        baslik: 'Raporlar',
        rota: RotaYapisi.raporlar,
      ),
      _AnaMenuKartVerisi(
        ikon: Icons.room_service_outlined,
        baslik: 'Siparisler',
        rota: RotaYapisi.personelGiris,
        rozet: '7',
      ),
      _AnaMenuKartVerisi(
        ikon: Icons.event_seat_rounded,
        baslik: 'Rezervasyon',
        rota: RotaYapisi.rezervasyon,
        rozet: '2',
      ),
      _AnaMenuKartVerisi(
        ikon: Icons.delivery_dining_rounded,
        baslik: 'Online Siparis',
        rota: RotaYapisi.onlineSiparisKanali,
        rozet: '0',
      ),
      _AnaMenuKartVerisi(
        ikon: Icons.soup_kitchen_outlined,
        baslik: 'Mutfak',
        rota: RotaYapisi.mutfak,
        rozet: '0',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kartlar.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: masaustu ? 4 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: masaustu ? 1.04 : 1.0,
      ),
      itemBuilder: (context, index) => _MenuKarti(veri: kartlar[index]),
    );
  }
}

class _MenuKarti extends StatelessWidget {
  const _MenuKarti({required this.veri});

  final _AnaMenuKartVerisi veri;

  @override
  Widget build(BuildContext context) {
    final ThemeData temaVerisi = Theme.of(context);
    final Color ikonArkaPlan = Color.lerp(_anaPembe, _anaMor, 0.45)!;

    return Material(
      color: _panelKoyu.withValues(alpha: 0.88),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => Navigator.of(context).pushNamed(veri.rota),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool darKarti = constraints.maxHeight < 170;
              final double ikonKutuBoyutu = darKarti ? 58 : 72;
              final double ikonBoyutu = darKarti ? 30 : 38;
              final double satirAraligi = darKarti ? 10 : 16;

              return Stack(
                alignment: Alignment.center,
                children: [
                  if (veri.rozet != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _anaPembe,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          veri.rozet!,
                          style: temaVerisi.textTheme.labelLarge?.copyWith(
                            color: _metinAna,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: ikonKutuBoyutu,
                        height: ikonKutuBoyutu,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ikonArkaPlan.withValues(alpha: 0.30),
                        ),
                        child: Icon(
                          veri.ikon,
                          color: _metinAna,
                          size: ikonBoyutu,
                        ),
                      ),
                      SizedBox(height: satirAraligi),
                      Flexible(
                        child: Text(
                          veri.baslik,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: temaVerisi.textTheme.titleMedium?.copyWith(
                            color: _metinAna,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AltSatir extends StatelessWidget {
  const _AltSatir();

  @override
  Widget build(BuildContext context) {
    final Color ayarRenk = Color.lerp(_anaMor, _anaPembe, 0.4)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pushNamed(RotaYapisi.hesabim),
          icon: const Icon(Icons.settings_rounded),
          label: const Text('Hesabim'),
          style: FilledButton.styleFrom(
            backgroundColor: ayarRenk,
            foregroundColor: _metinAna,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          ),
        ),
      ],
    );
  }
}

class _KurSatiriVerisi {
  const _KurSatiriVerisi({
    required this.simge,
    required this.kod,
    required this.deger,
  });

  final String simge;
  final String kod;
  final String deger;
}

abstract final class _KurServisi {
  static Future<List<_KurSatiriVerisi>?> getir() async {
    try {
      final Uri uri = Uri.https('open.er-api.com', '/v6/latest/TRY');
      final http.Response yanit = await http
          .get(uri)
          .timeout(const Duration(seconds: 8));
      if (yanit.statusCode != 200) {
        return null;
      }

      final Map<String, dynamic> veri =
          jsonDecode(yanit.body) as Map<String, dynamic>;
      final Map<String, dynamic>? rates =
          veri['rates'] as Map<String, dynamic>?;
      if (rates == null) {
        return null;
      }

      final double? tryUsd = _yabanciBirimBasinaTry(rates['USD']);
      final double? tryEur = _yabanciBirimBasinaTry(rates['EUR']);
      final double? tryGbp = _yabanciBirimBasinaTry(rates['GBP']);
      if (tryUsd == null || tryEur == null || tryGbp == null) {
        return null;
      }

      return <_KurSatiriVerisi>[
        _KurSatiriVerisi(
          simge: '\$',
          kod: 'USD',
          deger: _dortBasamakYaz(tryUsd),
        ),
        _KurSatiriVerisi(
          simge: 'EUR',
          kod: 'EUR',
          deger: _dortBasamakYaz(tryEur),
        ),
        _KurSatiriVerisi(
          simge: 'GBP',
          kod: 'GBP',
          deger: _dortBasamakYaz(tryGbp),
        ),
      ];
    } catch (_) {
      return null;
    }
  }

  static double? _yabanciBirimBasinaTry(Object? tryBasinaYabanciDegeri) {
    final double? deger = _doubleCevir(tryBasinaYabanciDegeri);
    if (deger == null || deger <= 0) {
      return null;
    }
    return 1 / deger;
  }

  static double? _doubleCevir(Object? deger) {
    if (deger is num) {
      return deger.toDouble();
    }
    return double.tryParse('$deger');
  }

  static String _dortBasamakYaz(double deger) => deger.toStringAsFixed(4);
}

class _AnaMenuKartVerisi {
  const _AnaMenuKartVerisi({
    required this.ikon,
    required this.baslik,
    required this.rota,
    this.rozet,
  });

  final IconData ikon;
  final String baslik;
  final String rota;
  final String? rozet;
}
