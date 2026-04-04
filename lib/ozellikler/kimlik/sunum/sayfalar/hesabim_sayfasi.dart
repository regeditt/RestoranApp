import 'package:flutter/material.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/bagimlilik/servis_saglayici.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';

class HesabimSayfasi extends StatefulWidget {
  const HesabimSayfasi({super.key});

  @override
  State<HesabimSayfasi> createState() => _HesabimSayfasiState();
}

class _HesabimSayfasiState extends State<HesabimSayfasi> {
  late final ServisKaydi _servisKaydi;
  bool _servisHazir = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _telefonDenetleyici = TextEditingController();
  final TextEditingController _sifreDenetleyici = TextEditingController();
  final TextEditingController _profilAdSoyadDenetleyici =
      TextEditingController();
  final TextEditingController _profilTelefonDenetleyici =
      TextEditingController();
  final TextEditingController _profilEpostaDenetleyici =
      TextEditingController();
  final TextEditingController _adresBaslikDenetleyici = TextEditingController();
  final TextEditingController _adresMetniDenetleyici = TextEditingController();

  KullaniciVarligi? _aktifKullanici;
  bool _yukleniyor = true;
  bool _islemde = false;
  bool _profilDuzenleniyor = false;
  List<_AdresVerisi> _adresler = const <_AdresVerisi>[
    _AdresVerisi(
      baslik: 'Ev',
      adresMetni: 'Ataturk Mah. 14. Sok. No:7 Daire:4',
    ),
    _AdresVerisi(
      baslik: 'Ofis',
      adresMetni: 'Cumhuriyet Cad. No:24 Kat:2',
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_servisHazir) {
      return;
    }
    _servisKaydi = ServisSaglayici.of(context);
    _servisHazir = true;
    _kullaniciYukle();
  }

  @override
  void dispose() {
    _telefonDenetleyici.dispose();
    _sifreDenetleyici.dispose();
    _profilAdSoyadDenetleyici.dispose();
    _profilTelefonDenetleyici.dispose();
    _profilEpostaDenetleyici.dispose();
    _adresBaslikDenetleyici.dispose();
    _adresMetniDenetleyici.dispose();
    super.dispose();
  }

  Future<void> _kullaniciYukle() async {
    final KullaniciVarligi? kullanici = await _servisKaydi
        .aktifKullaniciGetirUseCase();

    if (!mounted) {
      return;
    }

    setState(() {
      _aktifKullanici = kullanici;
      _yukleniyor = false;
    });
    if (kullanici != null) {
      _profilDenetleyicileriniDoldur(kullanici);
    }
  }

  Future<void> _girisYap() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _islemde = true;
    });

    try {
      final KullaniciVarligi kullanici = await _servisKaydi.girisYapUseCase(
        telefon: _telefonDenetleyici.text.trim(),
        sifre: _sifreDenetleyici.text.trim(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _aktifKullanici = kullanici;
        _islemde = false;
      });
      _profilDenetleyicileriniDoldur(kullanici);
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _islemde = false;
      });
      _bildirimGoster('Giris yapilamadi');
    }
  }

  Future<void> _cikisYap() async {
    setState(() {
      _islemde = true;
    });

    try {
      await _servisKaydi.cikisYapUseCase();

      if (!mounted) {
        return;
      }

      setState(() {
        _aktifKullanici = null;
        _islemde = false;
        _profilDuzenleniyor = false;
        _telefonDenetleyici.clear();
        _sifreDenetleyici.clear();
        _profilAdSoyadDenetleyici.clear();
        _profilTelefonDenetleyici.clear();
        _profilEpostaDenetleyici.clear();
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _islemde = false;
      });
      _bildirimGoster('Cikis yapilamadi');
    }
  }

  void _bildirimGoster(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mesaj)),
    );
  }

  void _profilDenetleyicileriniDoldur(KullaniciVarligi kullanici) {
    _profilAdSoyadDenetleyici.text = kullanici.adSoyad;
    _profilTelefonDenetleyici.text = kullanici.telefon;
    _profilEpostaDenetleyici.text = kullanici.eposta ?? '';
  }

  void _profilDuzenlemeyiAc() {
    final KullaniciVarligi? kullanici = _aktifKullanici;
    if (kullanici == null) {
      return;
    }

    _profilDenetleyicileriniDoldur(kullanici);
    setState(() {
      _profilDuzenleniyor = true;
    });
  }

  void _profilKaydet() {
    final KullaniciVarligi? kullanici = _aktifKullanici;
    if (kullanici == null) {
      return;
    }

    setState(() {
      _aktifKullanici = KullaniciVarligi(
        id: kullanici.id,
        adSoyad: _profilAdSoyadDenetleyici.text.trim(),
        telefon: _profilTelefonDenetleyici.text.trim(),
        eposta: _profilEpostaDenetleyici.text.trim().isEmpty
            ? null
            : _profilEpostaDenetleyici.text.trim(),
        rol: kullanici.rol,
        aktifMi: kullanici.aktifMi,
      );
      _profilDuzenleniyor = false;
    });
    _bildirimGoster('Profil bilgileri guncellendi');
  }

  void _adresEkle() {
    final String baslik = _adresBaslikDenetleyici.text.trim();
    final String adresMetni = _adresMetniDenetleyici.text.trim();
    if (baslik.isEmpty || adresMetni.isEmpty) {
      _bildirimGoster('Adres basligi ve adres metni gerekli');
      return;
    }

    setState(() {
      _adresler = <_AdresVerisi>[
        ..._adresler,
        _AdresVerisi(baslik: baslik, adresMetni: adresMetni),
      ];
      _adresBaslikDenetleyici.clear();
      _adresMetniDenetleyici.clear();
    });
    _bildirimGoster('Adres eklendi');
  }

  void _adresSil(_AdresVerisi adres) {
    setState(() {
      _adresler = _adresler
          .where((mevcutAdres) => mevcutAdres != adres)
          .toList();
    });
    _bildirimGoster('Adres kaldirildi');
  }

  @override
  Widget build(BuildContext context) {
    final bool masaustu = EkranBoyutu.masaustu(context);

    return Scaffold(
      backgroundColor: const Color(0xFF110C1B),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF17101F), Color(0xFF28143A), Color(0xFF150C20)],
          ),
        ),
        child: SafeArea(
          child: _yukleniyor
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1160),
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: masaustu
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 11, child: _solAlan()),
                                const SizedBox(width: 20),
                                Expanded(flex: 9, child: _sagAlan()),
                              ],
                            )
                          : ListView(
                              children: [
                                _solAlan(),
                                const SizedBox(height: 18),
                                _sagAlan(),
                              ],
                            ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _solAlan() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE74179), Color(0xFF7A4DFF), Color(0xFF352056)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton.filledTonal(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          const SizedBox(height: 22),
          Text(
            '${UygulamaSabitleri.restoranAdi} hesabin',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _aktifKullanici == null
                ? 'Personel ve yonetici girisini tek alandan yonet. Bu ilk adimda giris ve temel profil gorunumu hazir.'
                : 'Aktif kullanicinin temel profil bilgileri ve rol durumu burada gorunur.',
            style: const TextStyle(
              color: Color(0xFFF7E9F2),
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _KimlikRozeti(metin: 'Giris akisi'),
              _KimlikRozeti(metin: 'Profil gorunumu'),
              _KimlikRozeti(metin: 'Rol bilgisi'),
              _KimlikRozeti(metin: 'Adres yonetimi'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sagAlan() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: _aktifKullanici == null ? _girisKart() : _profilKart(),
    );
  }

  Widget _girisKart() {
    return Container(
      key: const ValueKey<String>('giris'),
      padding: const EdgeInsets.all(24),
      decoration: _panelDekorasyonu(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Giris yap',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mock ortamda herhangi bir telefon ve sifre ile oturum acabilirsin.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.70),
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _telefonDenetleyici,
              keyboardType: TextInputType.phone,
              decoration: _girdiDekorasyonu('Telefon'),
              validator: (String? deger) {
                if (deger == null || deger.trim().length < 10) {
                  return 'Gecerli bir telefon gir';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sifreDenetleyici,
              obscureText: true,
              decoration: _girdiDekorasyonu('Sifre'),
              validator: (String? deger) {
                if (deger == null || deger.trim().length < 4) {
                  return 'Sifre en az 4 karakter olmali';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _islemde ? null : _girisYap,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5D8F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: _islemde
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Oturum ac'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profilKart() {
    final KullaniciVarligi kullanici = _aktifKullanici!;

    return Container(
      key: const ValueKey<String>('profil'),
      padding: const EdgeInsets.all(24),
      decoration: _panelDekorasyonu(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5D8F).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.person_rounded, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kullanici.adSoyad,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _rolEtiketi(kullanici.rol),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          if (_profilDuzenleniyor) ...[
            TextFormField(
              controller: _profilAdSoyadDenetleyici,
              decoration: _girdiDekorasyonu('Ad soyad'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _profilTelefonDenetleyici,
              decoration: _girdiDekorasyonu('Telefon'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _profilEpostaDenetleyici,
              decoration: _girdiDekorasyonu('E-posta'),
            ),
            const SizedBox(height: 12),
            _profilSatiri('Durum', kullanici.aktifMi ? 'Aktif' : 'Pasif'),
          ] else ...[
            _profilSatiri('Telefon', kullanici.telefon),
            const SizedBox(height: 12),
            _profilSatiri('E-posta', kullanici.eposta ?? 'Yok'),
            const SizedBox(height: 12),
            _profilSatiri('Durum', kullanici.aktifMi ? 'Aktif' : 'Pasif'),
          ],
          const SizedBox(height: 22),
          _adresYonetimKarti(),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _profilDuzenleniyor ? _profilKaydet : _profilDuzenlemeyiAc,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF5D8F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: Text(
                _profilDuzenleniyor ? 'Profili kaydet' : 'Profili duzenle',
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _islemde ? null : _cikisYap,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: _islemde
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Cikis yap'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _adresYonetimKarti() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kayitli adresler',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Siparislerde hizli secim icin adreslerini burada tut.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.68),
            ),
          ),
          const SizedBox(height: 14),
          ..._adresler.map(
            (adres) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            adres.baslik,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            adres.adresMetni,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.72),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _adresSil(adres),
                      icon: const Icon(Icons.delete_outline_rounded),
                      color: const Color(0xFFFF8AAE),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _adresBaslikDenetleyici,
            decoration: _girdiDekorasyonu('Adres basligi'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _adresMetniDenetleyici,
            minLines: 2,
            maxLines: 3,
            decoration: _girdiDekorasyonu('Adres metni'),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: _adresEkle,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
              ),
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Adres ekle'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profilSatiri(String etiket, String deger) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              etiket,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.64),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            deger,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _panelDekorasyonu() {
    return BoxDecoration(
      color: const Color(0xFF22142E),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
    );
  }

  InputDecoration _girdiDekorasyonu(String etiket) {
    return InputDecoration(
      labelText: etiket,
      labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: Color(0xFFFF5D8F)),
      ),
    );
  }

  String _rolEtiketi(KullaniciRolu rol) {
    switch (rol) {
      case KullaniciRolu.misafir:
        return 'Misafir';
      case KullaniciRolu.musteri:
        return 'Musteri';
      case KullaniciRolu.garson:
        return 'Garson';
      case KullaniciRolu.yonetici:
        return 'Yonetici';
      case KullaniciRolu.patron:
        return 'Patron';
    }
  }
}

class _KimlikRozeti extends StatelessWidget {
  const _KimlikRozeti({required this.metin});

  final String metin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        metin,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _AdresVerisi {
  const _AdresVerisi({
    required this.baslik,
    required this.adresMetni,
  });

  final String baslik;
  final String adresMetni;
}
