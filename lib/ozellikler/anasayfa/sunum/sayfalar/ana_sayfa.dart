import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bilesenler/bilgi_karti.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    final bool masaustu = EkranBoyutu.masaustu(context);
    final bool tablet = EkranBoyutu.tablet(context);
    final int kolonSayisi = masaustu ? 4 : (tablet ? 2 : 1);

    return Scaffold(
      body: Stack(
        children: [
          const _ArkaPlan(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1440),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: masaustu ? 32 : 20,
                    vertical: 24,
                  ),
                  children: [
                    const _UstMenu(),
                    const SizedBox(height: 28),
                    _KahramanAlani(masaustu: masaustu),
                    const SizedBox(height: 28),
                    _DurumSeridi(masaustu: masaustu),
                    const SizedBox(height: 32),
                    const _BolumBasligi(
                      etiket: 'Operasyon Omurgasi',
                      baslik: 'Ilk surumde odaklandigimiz alanlar',
                      aciklama:
                          'Misafir siparis, yonetim paneli, yazici yonetimi ve patron raporlari ayni tasarim dili icinde bir araya geliyor.',
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: kolonSayisi,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                      childAspectRatio: masaustu ? 1.05 : 1.12,
                      children: const [
                        BilgiKarti(
                          baslik: 'Misafir Siparis',
                          aciklama:
                              'Uyeligi zorunlu tutmadan hizli siparis akisi saglanir. Musteri dogrudan menu, sepet ve odeme adimina ilerler.',
                          ikon: Icons.shopping_bag_outlined,
                          vurgu: Color(0xFFD96F32),
                        ),
                        BilgiKarti(
                          baslik: 'Yonetim Paneli',
                          aciklama:
                              'Siparis, menu, personel ve operasyon ekranlari web ile desktop oncelikli duzende yonetilir.',
                          ikon: Icons.space_dashboard_outlined,
                          vurgu: Color(0xFF163A32),
                        ),
                        BilgiKarti(
                          baslik: 'Yazici Yonetimi',
                          aciklama:
                              'Mutfak, bar ve fis yazicilari ayri rollerle eslenir. Test ciktilari ve yazdirma akislari kontrol edilir.',
                          ikon: Icons.print_outlined,
                          vurgu: Color(0xFF8A5CF6),
                        ),
                        BilgiKarti(
                          baslik: 'Patron Raporlari',
                          aciklama:
                              'Ciro, saatlik yogunluk, en cok satanlar ve operasyonel ozetler karar vericilere sade ama guclu kartlarla sunulur.',
                          ikon: Icons.bar_chart_outlined,
                          vurgu: Color(0xFF0F766E),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _AltGrid(masaustu: masaustu),
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
          colors: [Color(0xFFF7EFE4), Color(0xFFEFE5D7), Color(0xFFF8F4ED)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -60,
            child: _Parlama(
              cap: 320,
              renk: const Color(0xFFD96F32).withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            top: 220,
            left: -80,
            child: _Parlama(
              cap: 260,
              renk: const Color(0xFF163A32).withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            bottom: -90,
            right: 160,
            child: _Parlama(
              cap: 240,
              renk: const Color(0xFFF3C969).withValues(alpha: 0.18),
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
      decoration: BoxDecoration(shape: BoxShape.circle, color: renk),
    );
  }
}

class _UstMenu extends StatelessWidget {
  const _UstMenu();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFE5D9CB)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.restaurant_menu, size: 18, color: Color(0xFFD96F32)),
              SizedBox(width: 10),
              Text('RestoranApp'),
            ],
          ),
        ),
        const Spacer(),
        Wrap(
          spacing: 10,
          children: const [
            Chip(label: Text('Desktop')),
            Chip(label: Text('Mobil')),
            Chip(label: Text('Web')),
          ],
        ),
      ],
    );
  }
}

class _KahramanAlani extends StatelessWidget {
  const _KahramanAlani({required this.masaustu});

  final bool masaustu;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(masaustu ? 34 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1D1A16), Color(0xFF2A251F), Color(0xFF11352E)],
        ),
        borderRadius: BorderRadius.circular(36),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 36,
            offset: Offset(0, 24),
          ),
        ],
      ),
      child: masaustu
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(flex: 6, child: _KahramanMetni()),
                SizedBox(width: 28),
                Expanded(flex: 4, child: _KahramanOzetKutusu()),
              ],
            )
          : const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _KahramanMetni(),
                SizedBox(height: 24),
                _KahramanOzetKutusu(),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'Modern restoran operasyon deneyimi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Lezzeti,\nsiparisi ve operasyonu\ntek merkezde topla.',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(
          UygulamaSabitleri.uygulamaAciklamasi,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: const Color(0xFFE7DED1)),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Yol haritasini kur'),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.auto_graph_outlined),
              label: const Text('Modulleri incele'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KahramanOzetKutusu extends StatelessWidget {
  const _KahramanOzetKutusu();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: const Column(
        children: [
          _OzetSatiri(
            baslik: 'Aktif siparis akisi',
            deger: '124',
            aciklama: 'Misafir ve uyeli siparisler ayni omurgada birlesir.',
          ),
          SizedBox(height: 14),
          _OzetSatiri(
            baslik: 'Yazici senaryosu',
            deger: '08',
            aciklama: 'Mutfak, bar ve fis yazicilari ayri yonetilebilir.',
          ),
          SizedBox(height: 14),
          _OzetSatiri(
            baslik: 'Patron gorunumu',
            deger: '24/7',
            aciklama:
                'Ciro ve raporlar web ile desktop uzerinden anlik izlenir.',
          ),
        ],
      ),
    );
  }
}

class _OzetSatiri extends StatelessWidget {
  const _OzetSatiri({
    required this.baslik,
    required this.deger,
    required this.aciklama,
  });

  final String baslik;
  final String deger;
  final String aciklama;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFF3C969),
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Text(
              deger,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: const Color(0xFF1D1A16)),
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
                const SizedBox(height: 6),
                Text(
                  aciklama,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFE6DDD1),
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

class _DurumSeridi extends StatelessWidget {
  const _DurumSeridi({required this.masaustu});

  final bool masaustu;

  @override
  Widget build(BuildContext context) {
    final List<_DurumVerisi> veriler = <_DurumVerisi>[
      const _DurumVerisi('Cok platform', 'Desktop, mobil ve web ayni tabanda'),
      const _DurumVerisi('Misafir akisi', 'Uyelik zorunlu olmadan siparis'),
      const _DurumVerisi('Role dayali', 'Personel, yonetici ve patron ayrimi'),
    ];

    return Wrap(
      spacing: 18,
      runSpacing: 18,
      children: veriler
          .map(
            (veri) => SizedBox(
              width: masaustu ? 430 : double.infinity,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE7DACB)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFF163A32),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            veri.baslik,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            veri.aciklama,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DurumVerisi {
  const _DurumVerisi(this.baslik, this.aciklama);

  final String baslik;
  final String aciklama;
}

class _BolumBasligi extends StatelessWidget {
  const _BolumBasligi({
    required this.etiket,
    required this.baslik,
    required this.aciklama,
  });

  final String etiket;
  final String baslik;
  final String aciklama;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiket,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: const Color(0xFFD96F32)),
        ),
        const SizedBox(height: 8),
        Text(baslik, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Text(aciklama, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}

class _MimariKutusu extends StatelessWidget {
  const _MimariKutusu();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE4D8CA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mimari notlar',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              Chip(label: Text('SOLID')),
              Chip(label: Text('N Katmanli')),
              Chip(label: Text('Feature Bazli')),
              Chip(label: Text('Turkce ASCII Isimlendirme')),
              Chip(label: Text('Yazici Yonetimi')),
              Chip(label: Text('Garson Yonetimi')),
              Chip(label: Text('Patron Raporlari')),
              Chip(label: Text('Misafir Siparis')),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Bu tasarim ilk ekrani sadece doldurmak icin kurulmadi; sonraki moduller icin guclu bir ton, hiyerarsi ve responsive davranis tabani olusturuyor.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _SonrakiAdimKutusu extends StatelessWidget {
  const _SonrakiAdimKutusu();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFD96F32),
        borderRadius: BorderRadius.circular(30),
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
            'Kimlik, menu ve siparis modullerini bu tasarim diliyle gercek ekranlara tasiyalim.',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 14),
          Text(
            'Bir sonraki iterasyonda ana sayfadan sonra musteri akisina gecip menu ve kategori deneyimini olusturabiliriz.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFFFFEFE2)),
          ),
        ],
      ),
    );
  }
}

class _AltGrid extends StatelessWidget {
  const _AltGrid({required this.masaustu});

  final bool masaustu;

  @override
  Widget build(BuildContext context) {
    return masaustu
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: _MimariKutusu()),
              const SizedBox(width: 18),
              Expanded(flex: 5, child: _SonrakiAdimKutusu()),
            ],
          )
        : const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _MimariKutusu(),
              SizedBox(height: 18),
              _SonrakiAdimKutusu(),
            ],
          );
  }
}
