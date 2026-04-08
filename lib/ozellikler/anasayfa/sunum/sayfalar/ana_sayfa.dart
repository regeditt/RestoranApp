import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ortak/tema/restoran_tema_uzantilari.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    final bool masaustu = EkranBoyutu.masaustu(context);
    final RestoranTemaRenkleri tema = context.restoranTema;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              tema.anaArkaPlan,
              tema.anaArkaPlanIkincil,
              tema.anaArkaPlanUcuncul,
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
    final RestoranTemaRenkleri tema = context.restoranTema;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color.lerp(
          tema.anaArkaPlanIkincil,
          tema.anaArkaPlanUcuncul,
          0.65,
        ),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(
          color: tema.metinIkincilAcik.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: tema.anaArkaPlan.withValues(alpha: 0.38),
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
    final RestoranTemaRenkleri tema = context.restoranTema;
    return LayoutBuilder(
      builder: (context, kisit) {
        final double solGenislik = kisit.maxWidth * 0.38;
        return Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.lerp(
                        tema.anaArkaPlanIkincil,
                        tema.anaArkaPlanUcuncul,
                        0.35,
                      )!,
                      Color.lerp(
                        tema.anaArkaPlan,
                        tema.anaArkaPlanIkincil,
                        0.25,
                      )!,
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
      children: const [
        SizedBox(
          height: 420,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(26)),
            child: _SolPanel(),
          ),
        ),
        SizedBox(height: 10),
        _SagPanel(masaustu: false),
      ],
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
    final RestoranTemaRenkleri tema = context.restoranTema;
    final ThemeData temaVerisi = Theme.of(context);
    final Color pembe = temaVerisi.colorScheme.tertiary;
    final Color mor = temaVerisi.colorScheme.secondary;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(pembe, temaVerisi.colorScheme.primary, 0.30)!,
            Color.lerp(mor, tema.anaArkaPlanUcuncul, 0.60)!,
          ],
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${UygulamaSabitleri.restoranAdi.toUpperCase()} Pos',
                        style: temaVerisi.textTheme.headlineMedium?.copyWith(
                          color: tema.metinBirincilAcik,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        UygulamaSabitleri.tamMarkaAdi.toUpperCase(),
                        style: temaVerisi.textTheme.labelLarge?.copyWith(
                          color: tema.metinIkincilAcik.withValues(alpha: 0.95),
                          letterSpacing: 1.6,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const _SaatHavaAlani(),
                      const SizedBox(height: 26),
                      const _KurListesi(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.support_agent_rounded,
                          color: tema.metinBirincilAcik,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Musteri Hizmetleri',
                          style: temaVerisi.textTheme.titleMedium?.copyWith(
                            color: tema.metinBirincilAcik.withValues(
                              alpha: 0.95,
                            ),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SaatHavaAlani extends StatelessWidget {
  const _SaatHavaAlani();

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
  Widget build(BuildContext context) {
    final RestoranTemaRenkleri tema = context.restoranTema;
    final ThemeData temaVerisi = Theme.of(context);
    return StreamBuilder<DateTime>(
      stream: Stream<DateTime>.periodic(
        const Duration(seconds: 1),
        (_) => DateTime.now(),
      ),
      initialData: DateTime.now(),
      builder: (context, snapshot) {
        final DateTime zaman = snapshot.data ?? DateTime.now();
        final String tarih =
            '${zaman.day} ${_aylar[zaman.month - 1]} ${_gunler[zaman.weekday - 1]}';
        final String saat =
            '${_ikiBasamak(zaman.hour)}:${_ikiBasamak(zaman.minute)}';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tarih,
              style: temaVerisi.textTheme.titleMedium?.copyWith(
                color: tema.metinIkincilAcik.withValues(alpha: 0.96),
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
                    color: tema.metinBirincilAcik,
                    fontWeight: FontWeight.w300,
                    height: 0.96,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_rounded,
                      size: 40,
                      color: tema.metinBirincilAcik.withValues(alpha: 0.95),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '20°',
                          style: temaVerisi.textTheme.headlineMedium?.copyWith(
                            color: tema.metinBirincilAcik,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Parcali bulutlu',
                          style: temaVerisi.textTheme.bodyLarge?.copyWith(
                            color: tema.metinIkincilAcik.withValues(
                              alpha: 0.95,
                            ),
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
      },
    );
  }

  String _ikiBasamak(int deger) => deger.toString().padLeft(2, '0');
}

class _KurListesi extends StatelessWidget {
  const _KurListesi();

  @override
  Widget build(BuildContext context) {
    final RestoranTemaRenkleri tema = context.restoranTema;
    final ThemeData temaVerisi = Theme.of(context);
    const List<_KurSatiriVerisi> kurlar = [
      _KurSatiriVerisi(
        simge: '\$',
        kod: 'USD',
        deger: '34.2002',
        fark: '+0.06',
      ),
      _KurSatiriVerisi(simge: '€', kod: 'EUR', deger: '37.5182', fark: '+0.12'),
      _KurSatiriVerisi(simge: '£', kod: 'GBP', deger: '44.8793', fark: '+0.16'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GUNCEL KURLAR',
          style: temaVerisi.textTheme.labelLarge?.copyWith(
            color: tema.metinBirincilAcik.withValues(alpha: 0.86),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 10),
        ...kurlar.map(
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
    final RestoranTemaRenkleri tema = context.restoranTema;
    final ThemeData temaVerisi = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: tema.anaArkaPlan.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: tema.metinIkincilAcik.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              veri.simge,
              textAlign: TextAlign.center,
              style: temaVerisi.textTheme.titleLarge?.copyWith(
                color: tema.metinBirincilAcik,
                fontWeight: FontWeight.w800,
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
                    color: tema.metinBirincilAcik,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  veri.deger,
                  style: temaVerisi.textTheme.bodyMedium?.copyWith(
                    color: tema.metinIkincilAcik,
                  ),
                ),
              ],
            ),
          ),
          Text(
            veri.fark,
            style: temaVerisi.textTheme.titleSmall?.copyWith(
              color: tema.metinBirincilAcik,
              fontWeight: FontWeight.w700,
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
    final RestoranTemaRenkleri tema = context.restoranTema;
    final Color yesil = Color.lerp(Colors.green, tema.metinBirincilAcik, 0.2)!;
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
            vurgu: yesil,
          ),
          _DurumRozeti(
            ikon: Icons.wifi_rounded,
            baslik: 'Internet',
            alt: 'Online',
            vurgu: yesil,
          ),
          _DurumRozeti(
            ikon: Icons.location_city_rounded,
            baslik: UygulamaSabitleri.restoranAdi,
            alt: 'Sube',
            vurgu: tema.metinIkincilAcik,
          ),
          _DurumRozeti(
            ikon: Icons.person_rounded,
            baslik: 'Yonetici',
            alt: 'aktif',
            vurgu: tema.metinIkincilAcik,
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
  });

  final IconData ikon;
  final String baslik;
  final String alt;
  final Color vurgu;

  @override
  Widget build(BuildContext context) {
    final RestoranTemaRenkleri tema = context.restoranTema;
    final ThemeData temaVerisi = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: tema.anaArkaPlan.withValues(alpha: 0.26),
        borderRadius: BorderRadius.circular(12),
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
                  color: tema.metinBirincilAcik,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                alt,
                style: temaVerisi.textTheme.labelSmall?.copyWith(
                  color: tema.metinIkincilAcik.withValues(alpha: 0.92),
                ),
              ),
            ],
          ),
        ],
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
        ikon: Icons.badge_outlined,
        baslik: 'Cariler',
        rota: RotaYapisi.hesabim,
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
        ikon: Icons.shopping_basket_outlined,
        baslik: 'Hizli Satis',
        rota: RotaYapisi.personelGiris,
        rozet: '1',
      ),
      _AnaMenuKartVerisi(
        ikon: Icons.delivery_dining_rounded,
        baslik: 'Paketler',
        rota: RotaYapisi.personelGiris,
        rozet: '0',
      ),
      _AnaMenuKartVerisi(
        ikon: Icons.soup_kitchen_outlined,
        baslik: 'Mutfak',
        rota: RotaYapisi.personelGiris,
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
    final RestoranTemaRenkleri tema = context.restoranTema;
    final ThemeData temaVerisi = Theme.of(context);
    final Color ikonArkaPlan = Color.lerp(
      temaVerisi.colorScheme.tertiary,
      temaVerisi.colorScheme.primary,
      0.40,
    )!;

    return Material(
      color: Color.lerp(tema.anaArkaPlan, tema.anaArkaPlanIkincil, 0.28),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => Navigator.of(context).pushNamed(veri.rota),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (veri.rozet != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Text(
                    veri.rozet!,
                    style: temaVerisi.textTheme.titleSmall?.copyWith(
                      color: tema.metinIkincilAcik,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ikonArkaPlan.withValues(alpha: 0.22),
                    ),
                    child: Icon(
                      veri.ikon,
                      color: tema.metinBirincilAcik,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    veri.baslik,
                    textAlign: TextAlign.center,
                    style: temaVerisi.textTheme.titleLarge?.copyWith(
                      color: tema.metinBirincilAcik,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
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
    final RestoranTemaRenkleri tema = context.restoranTema;
    final ThemeData temaVerisi = Theme.of(context);
    final Color ayarRenk = Color.lerp(
      temaVerisi.colorScheme.secondary,
      temaVerisi.colorScheme.tertiary,
      0.5,
    )!;

    return Row(
      children: [
        Expanded(
          child: Text(
            '${UygulamaSabitleri.tamMarkaAdi.toUpperCase()} CENTURY',
            style: temaVerisi.textTheme.titleSmall?.copyWith(
              color: tema.metinIkincilAcik.withValues(alpha: 0.76),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ),
        FilledButton.icon(
          onPressed: () =>
              Navigator.of(context).pushNamed(RotaYapisi.personelGiris),
          icon: const Icon(Icons.settings_rounded),
          label: const Text('Ayarlar'),
          style: FilledButton.styleFrom(
            backgroundColor: ayarRenk,
            foregroundColor: tema.metinBirincilAcik,
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
    required this.fark,
  });

  final String simge;
  final String kod;
  final String deger;
  final String fark;
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
