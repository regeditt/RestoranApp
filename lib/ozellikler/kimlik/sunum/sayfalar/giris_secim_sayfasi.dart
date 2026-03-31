import 'package:flutter/material.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';

class GirisSecimSayfasi extends StatefulWidget {
  const GirisSecimSayfasi({super.key});

  @override
  State<GirisSecimSayfasi> createState() => _GirisSecimSayfasiState();
}

class _GirisSecimSayfasiState extends State<GirisSecimSayfasi> {
  final ServisKaydi _servisKaydi = ServisKaydi.ortak;
  _GirisModu _seciliMod = _GirisModu.musteri;
  final TextEditingController _adDenetleyici = TextEditingController();
  final TextEditingController _telefonDenetleyici = TextEditingController();
  final TextEditingController _adresDenetleyici = TextEditingController();
  final TextEditingController _sifreDenetleyici = TextEditingController();
  bool _islemde = false;

  @override
  void dispose() {
    _adDenetleyici.dispose();
    _telefonDenetleyici.dispose();
    _adresDenetleyici.dispose();
    _sifreDenetleyici.dispose();
    super.dispose();
  }

  Future<void> _devamEt({_GirisHedefi hedef = _GirisHedefi.qrMenu}) async {
    if (_islemde) {
      return;
    }

    setState(() {
      _islemde = true;
    });

    try {
      if (_seciliMod == _GirisModu.musteri) {
        final String ad = _adDenetleyici.text.trim();
        final String telefon = _telefonDenetleyici.text.trim();
        final String adres = _adresDenetleyici.text.trim();
        if (ad.isEmpty || telefon.isEmpty || adres.isEmpty) {
          _uyari('Musteri girisi icin ad, telefon ve adres gerekli.');
          return;
        }

        await _servisKaydi.girisYapUseCase(
          telefon: telefon,
          sifre: 'musteri',
          rol: KullaniciRolu.musteri,
          adSoyad: ad,
          adresMetni: adres,
        );

        if (!mounted) {
          return;
        }

        Navigator.of(context).pushReplacementNamed(RotaYapisi.qrMenu);
        return;
      }

      final String kullaniciAdi = _telefonDenetleyici.text.trim();
      final String sifre = _sifreDenetleyici.text.trim();
      if (kullaniciAdi.isEmpty || sifre.isEmpty) {
        _uyari('Kullanici adi ve sifre alanlarini doldur.');
        return;
      }

      await _servisKaydi.girisYapUseCase(
        telefon: kullaniciAdi,
        sifre: sifre,
        rol: _seciliMod == _GirisModu.garson
            ? KullaniciRolu.garson
            : KullaniciRolu.yonetici,
        adSoyad: kullaniciAdi,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(
        hedef == _GirisHedefi.pos ? RotaYapisi.pos : RotaYapisi.yonetimPaneli,
      );
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
                      'RestoranApp',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Ilk giriste rolunu sec ve uygun akisla devam et.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFD9CEE5), fontSize: 16),
                    ),
                    const SizedBox(height: 28),
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: _GirisModu.values
                          .map(
                            (_GirisModu mod) => _RolKarti(
                              mod: mod,
                              seciliMi: _seciliMod == mod,
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
                          if (_seciliMod == _GirisModu.musteri) ...[
                            TextField(
                              controller: _adDenetleyici,
                              decoration: const InputDecoration(
                                labelText: 'Isim soyisim',
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _telefonDenetleyici,
                              decoration: const InputDecoration(
                                labelText: 'Telefon numarasi',
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _adresDenetleyici,
                              minLines: 2,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Adres',
                              ),
                            ),
                          ] else ...[
                            TextField(
                              controller: _telefonDenetleyici,
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
                          ],
                          const SizedBox(height: 18),
                          if (_seciliMod == _GirisModu.musteri)
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: _islemde ? null : _devamEt,
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
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton(
                                    onPressed: _islemde
                                        ? null
                                        : () =>
                                              _devamEt(hedef: _GirisHedefi.pos),
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
                                          : 'POS ekranina gir',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _islemde
                                        ? null
                                        : () => _devamEt(
                                            hedef: _GirisHedefi.yonetim,
                                          ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF241036),
                                      side: const BorderSide(
                                        color: Color(0xFF241036),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                    child: const Text('Yonetim paneline git'),
                                  ),
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

enum _GirisModu {
  musteri(
    'Musteri girisi',
    'QR menu ve siparis akisina devam et.',
    'Musteri olarak devam et',
  ),
  garson(
    'Garson girisi',
    'Servis operasyonu ve masa akisina gec.',
    'Garson olarak giris yap',
  ),
  yonetici(
    'Yonetici girisi',
    'Yonetim paneli ve ayarlari ac.',
    'Yonetici olarak giris yap',
  );

  const _GirisModu(this.baslik, this.aciklama, this.butonMetni);

  final String baslik;
  final String aciklama;
  final String butonMetni;
}

enum _GirisHedefi { qrMenu, pos, yonetim }

class _RolKarti extends StatelessWidget {
  const _RolKarti({
    required this.mod,
    required this.seciliMi,
    required this.tiklandi,
  });

  final _GirisModu mod;
  final bool seciliMi;
  final VoidCallback tiklandi;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tiklandi,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 290,
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
