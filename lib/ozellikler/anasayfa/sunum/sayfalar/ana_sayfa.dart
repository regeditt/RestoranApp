import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    final bool masaustu = EkranBoyutu.masaustu(context);

    return Scaffold(
      body: Stack(
        children: [
          const _ArkaPlan(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: masaustu ? 28 : 18,
                    vertical: masaustu ? 24 : 16,
                  ),
                  children: [
                    _UstCubuk(masaustu: masaustu),
                    const SizedBox(height: 20),
                    _KahramanAlan(masaustu: masaustu),
                    const SizedBox(height: 20),
                    _AltAlan(masaustu: masaustu),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArkaPlan extends StatelessWidget {
  const _ArkaPlan();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF120A1F), Color(0xFF241036), Color(0xFF3C184F)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -40,
            child: _Parlama(
              cap: 320,
              renk: const Color(0xFFFF6B8A).withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            top: 180,
            right: -60,
            child: _Parlama(
              cap: 360,
              renk: const Color(0xFF7C4DFF).withValues(alpha: 0.16),
            ),
          ),
          Positioned(
            bottom: -80,
            left: 140,
            child: _Parlama(
              cap: 280,
              renk: const Color(0xFF2AE39A).withValues(alpha: 0.10),
            ),
          ),
        ],
      ),
    );
  }
}

class _Parlama extends StatelessWidget {
  const _Parlama({required this.cap, required this.renk});

  final double cap;
  final Color renk;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cap,
      height: cap,
      decoration: BoxDecoration(color: renk, shape: BoxShape.circle),
    );
  }
}

class _UstCubuk extends StatelessWidget {
  const _UstCubuk({required this.masaustu});

  final bool masaustu;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: masaustu
          ? Row(
              children: [
                const _MarkaAlani(),
                const Spacer(),
                const _BilgiRozeti(
                  ikon: Icons.devices_outlined,
                  metin: 'Desktop, web, mobil',
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RotaYapisi.qrMenu);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('QR Menu'),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RotaYapisi.hesabim);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Hesabim'),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RotaYapisi.yonetimPaneli);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Yonetim'),
                ),
                const SizedBox(width: 14),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RotaYapisi.qrMenu);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5D8F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(UygulamaSabitleri.anaAksiyonMetni),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _MarkaAlani(),
                const SizedBox(height: 14),
                const Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _BilgiRozeti(
                      ikon: Icons.devices_outlined,
                      metin: 'Desktop, web, mobil',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(RotaYapisi.qrMenu);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('QR Menu'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(RotaYapisi.hesabim);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Hesabim'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(RotaYapisi.yonetimPaneli);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Yonetim paneli'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(RotaYapisi.musteriMenusu);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5D8F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(UygulamaSabitleri.anaAksiyonMetni),
                  ),
                ),
              ],
            ),
    );
  }
}

class _MarkaAlani extends StatelessWidget {
  const _MarkaAlani();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF7B72), Color(0xFF8A5CFF)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.restaurant_menu, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              UygulamaSabitleri.uygulamaAdi,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Restoran operasyon vitrini',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFFD6C7E2)),
            ),
          ],
        ),
      ],
    );
  }
}

class _BilgiRozeti extends StatelessWidget {
  const _BilgiRozeti({required this.ikon, required this.metin});

  final IconData ikon;
  final String metin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 16, color: const Color(0xFF82FFD0)),
          const SizedBox(width: 8),
          Text(
            metin,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _KahramanAlan extends StatelessWidget {
  const _KahramanAlan({required this.masaustu});

  final bool masaustu;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(masaustu ? 30 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF20112C), Color(0xFF34144C), Color(0xFF5A1D53)],
        ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: masaustu
          ? const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: _KahramanMetni()),
                SizedBox(width: 20),
                Expanded(flex: 4, child: _KahramanPaneli()),
              ],
            )
          : const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _KahramanMetni(),
                SizedBox(height: 18),
                _KahramanPaneli(),
              ],
            ),
    );
  }
}

class _KahramanMetni extends StatelessWidget {
  const _KahramanMetni();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            '${UygulamaSabitleri.restoranAdi} operasyon deneyimi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Siparisi hizlandiran,\nmasayi temiz gosteren\ntek ekran deneyimi.',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(color: Colors.white, height: 1.0),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            'Gereksiz kalabaligi atan, personeli yormayan ve musteriyi hizli aksiyona goturen bir restoran uygulamasi. ${UygulamaSabitleri.uygulamaAciklamasi}.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: const Color(0xFFE9DEEF)),
          ),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(RotaYapisi.qrMenu);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF121A2C),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.qr_code_2_rounded),
              label: const Text('QR menu'),
            ),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(RotaYapisi.qrMenu);
              },
              icon: const Icon(Icons.restaurant_menu_outlined),
              label: const Text('QR menuyu ac'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.20)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(RotaYapisi.yonetimPaneli);
              },
              icon: const Icon(Icons.space_dashboard_outlined),
              label: const Text('Yonetim paneli'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.20)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KahramanPaneli extends StatelessWidget {
  const _KahramanPaneli();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: const [
          _PanelSatiri(
            sayi: '01',
            baslik: 'Tek odak',
            aciklama: 'Ana sayfa artik daha sade ve dogrudan urune giriyor.',
          ),
          SizedBox(height: 12),
          _PanelSatiri(
            sayi: '02',
            baslik: 'Hizli demo',
            aciklama: 'Kullaniciyi tek tikla POS ekranina yonlendiriyor.',
          ),
          SizedBox(height: 12),
          _PanelSatiri(
            sayi: '03',
            baslik: 'Temiz hiyerarsi',
            aciklama: 'Kart yiginlari yerine net mesaj ve net CTA kullaniyor.',
          ),
        ],
      ),
    );
  }
}

class _PanelSatiri extends StatelessWidget {
  const _PanelSatiri({
    required this.sayi,
    required this.baslik,
    required this.aciklama,
  });

  final String sayi;
  final String baslik;
  final String aciklama;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC857),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              sayi,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF1D1322),
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
                  baslik,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  aciklama,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFE2D6EB),
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

class _AltAlan extends StatelessWidget {
  const _AltAlan({required this.masaustu});

  final bool masaustu;

  @override
  Widget build(BuildContext context) {
    return masaustu
        ? const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: _VizyonKutusu()),
              SizedBox(width: 20),
              Expanded(flex: 5, child: _AksiyonKutusu()),
            ],
          )
        : const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_VizyonKutusu(), SizedBox(height: 20), _AksiyonKutusu()],
          );
  }
}

class _VizyonKutusu extends StatelessWidget {
  const _VizyonKutusu();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Neyi kaldirdik?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFF241331),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Fazla bilgi kartlari, tekrar eden aciklamalar ve ilk ekranda karar yoran bloklar cikti. Yerine daha guclu bir mesaj, net yonlendirme ve uygulamanin asil degerini gosteren bir vitrin geldi.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF5E4E6A)),
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _Etiket(metin: 'Daha sade'),
              _Etiket(metin: 'Daha hizli'),
              _Etiket(metin: 'Daha guclu CTA'),
              _Etiket(metin: 'POS odakli vitrin'),
            ],
          ),
        ],
      ),
    );
  }
}

class _AksiyonKutusu extends StatelessWidget {
  const _AksiyonKutusu();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF5D8F), Color(0xFFFF7D59)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sonraki adim',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            'Ana sayfadan sonra yonetim paneli ve detayli masa plani ekranlarini da ayni dilde toparlayabiliriz.',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 14),
          Text(
            'Su anki yapi kullaniciyi demo ekrana daha hizli goturuyor ve proje acildiginda daha profesyonel bir ilk izlenim veriyor.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFFFFE8DF)),
          ),
        ],
      ),
    );
  }
}

class _Etiket extends StatelessWidget {
  const _Etiket({required this.metin});

  final String metin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EEF9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        metin,
        style: const TextStyle(
          color: Color(0xFF4A2E63),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
