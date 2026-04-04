import 'package:flutter/material.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/bagimlilik/servis_saglayici.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';

class GirisSecimSayfasi extends StatefulWidget {
  const GirisSecimSayfasi({super.key});

  @override
  State<GirisSecimSayfasi> createState() => _GirisSecimSayfasiState();
}

class _GirisSecimSayfasiState extends State<GirisSecimSayfasi> {
  late final ServisKaydi _servisKaydi;
  bool _servisHazir = false;
  _PersonelGirisModu _seciliMod = _PersonelGirisModu.garson;
  final TextEditingController _kullaniciAdiDenetleyici =
      TextEditingController();
  final TextEditingController _sifreDenetleyici = TextEditingController();
  bool _islemde = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_servisHazir) {
      return;
    }
    _servisKaydi = ServisSaglayici.of(context);
    _servisHazir = true;
  }

  @override
  void dispose() {
    _kullaniciAdiDenetleyici.dispose();
    _sifreDenetleyici.dispose();
    super.dispose();
  }

  Future<void> _devamEt({_GirisHedefi hedef = _GirisHedefi.pos}) async {
    if (_islemde) {
      return;
    }

    final String kullaniciAdi = _kullaniciAdiDenetleyici.text.trim();
    final String sifre = _sifreDenetleyici.text.trim();
    if (kullaniciAdi.isEmpty || sifre.isEmpty) {
      _uyari('Kullanici adi ve sifre alanlarini doldur.');
      return;
    }

    setState(() {
      _islemde = true;
    });

    try {
      await _servisKaydi.girisYapUseCase(
        telefon: kullaniciAdi,
        sifre: sifre,
        rol: _seciliMod == _PersonelGirisModu.garson
            ? KullaniciRolu.garson
            : KullaniciRolu.yonetici,
        adSoyad: kullaniciAdi,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(switch (hedef) {
        _GirisHedefi.pos => RotaYapisi.pos,
        _GirisHedefi.yonetim => RotaYapisi.yonetimPaneli,
        _GirisHedefi.mutfak => RotaYapisi.mutfak,
      });
    } finally {
      if (mounted) {
        setState(() {
          _islemde = false;
        });
      }
    }
  }

  void _uyari(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mesaj)));
  }

  @override
  Widget build(BuildContext context) {
    final bool mobil = MediaQuery.sizeOf(context).width < 760;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF120A1F), Color(0xFF241036), Color(0xFF3C184F)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Text(
                      'Personel girisi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Musteri akisi dogrudan QR menu ile acilir. Garson ve yonetici girisleri bu ekrandan yonetilir.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFD9CEE5), fontSize: 16),
                    ),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.center,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed(RotaYapisi.qrMenu);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            icon: const Icon(Icons.qr_code_2_rounded, size: 18),
                            label: const Text('QR menuye don'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: _PersonelGirisModu.values
                          .map(
                            (_PersonelGirisModu mod) => _RolKarti(
                              mod: mod,
                              seciliMi: _seciliMod == mod,
                              genislik: mobil ? double.infinity : 452,
                              tiklandi: () {
                                setState(() {
                                  _seciliMod = mod;
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _seciliMod.baslik,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _seciliMod.aciklama,
                            style: const TextStyle(color: Color(0xFF6D6079)),
                          ),
                          const SizedBox(height: 18),
                          TextField(
                            controller: _kullaniciAdiDenetleyici,
                            decoration: const InputDecoration(
                              labelText: 'Kullanici adi',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _sifreDenetleyici,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Sifre',
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _islemde
                                  ? null
                                  : () => _devamEt(hedef: _seciliMod.ilkHedef),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFFF5D8F),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: Text(
                                _islemde
                                    ? 'Hazirlaniyor...'
                                    : _seciliMod.butonMetni,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              OutlinedButton.icon(
                                onPressed: _islemde
                                    ? null
                                    : () =>
                                          _devamEt(hedef: _GirisHedefi.mutfak),
                                icon: const Icon(Icons.restaurant_rounded),
                                label: const Text('Mutfak ekranina git'),
                              ),
                              if (_seciliMod == _PersonelGirisModu.yonetici)
                                OutlinedButton.icon(
                                  onPressed: _islemde
                                      ? null
                                      : () => _devamEt(
                                          hedef: _GirisHedefi.yonetim,
                                        ),
                                  icon: const Icon(Icons.dashboard_rounded),
                                  label: const Text('Yonetim paneline git'),
                                ),
                            ],
                          ),
                        ],
                      ),
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
}

enum _PersonelGirisModu {
  garson(
    'Garson girisi',
    'Servis operasyonu ve masa akisina gec.',
    'Garson olarak giris yap',
    _GirisHedefi.pos,
  ),
  yonetici(
    'Yonetici girisi',
    'Yonetim paneli, mutfak ve operasyon ekranlarini ac.',
    'Yonetici olarak giris yap',
    _GirisHedefi.yonetim,
  );

  const _PersonelGirisModu(
    this.baslik,
    this.aciklama,
    this.butonMetni,
    this.ilkHedef,
  );

  final String baslik;
  final String aciklama;
  final String butonMetni;
  final _GirisHedefi ilkHedef;
}

enum _GirisHedefi { pos, yonetim, mutfak }

class _RolKarti extends StatelessWidget {
  const _RolKarti({
    required this.mod,
    required this.seciliMi,
    required this.tiklandi,
    required this.genislik,
  });

  final _PersonelGirisModu mod;
  final bool seciliMi;
  final VoidCallback tiklandi;
  final double genislik;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tiklandi,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: genislik,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: seciliMi
              ? const Color(0xFFFF5D8F)
              : Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: seciliMi
                ? const Color(0xFFFFB3C9)
                : Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mod.baslik,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mod.aciklama,
              style: const TextStyle(color: Color(0xFFF8EAF0), height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}
