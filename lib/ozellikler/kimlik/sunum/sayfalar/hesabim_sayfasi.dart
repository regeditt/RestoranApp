import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bilesenler/ana_sayfaya_donus.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ortak/tema/ana_sayfa_renk_sablonu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/kullanici_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/viewmodel/hesabim_viewmodel.dart';

typedef _AdresVerisi = AdresVerisi;

class HesabimSayfasi extends StatefulWidget {
  const HesabimSayfasi({super.key, required this.viewModel});

  final HesabimViewModel viewModel;

  @override
  State<HesabimSayfasi> createState() => _HesabimSayfasiState();
}

class _HesabimSayfasiState extends State<HesabimSayfasi> {
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

  KullaniciVarligi? get _aktifKullanici => widget.viewModel.aktifKullanici;
  bool get _yukleniyor => widget.viewModel.yukleniyor;
  bool get _islemde => widget.viewModel.islemde;
  bool get _profilDuzenleniyor => widget.viewModel.profilDuzenleniyor;
  List<_AdresVerisi> get _adresler => widget.viewModel.adresler;

  @override
  void initState() {
    super.initState();
    _kullaniciYukle();
  }

  @override
  void didUpdateWidget(covariant HesabimSayfasi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      oldWidget.viewModel.dispose();
      _kullaniciYukle();
    }
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
    widget.viewModel.dispose();
    super.dispose();
  }

  Future<void> _kullaniciYukle() async {
    final HesabimIslemSonucu sonuc = await widget.viewModel.kullaniciYukle();

    if (!mounted) {
      return;
    }

    if (!sonuc.basarili) {
      _bildirimGoster(sonuc.mesaj);
      return;
    }

    final KullaniciVarligi? kullanici = widget.viewModel.aktifKullanici;
    if (kullanici != null) {
      _profilDenetleyicileriniDoldur(kullanici);
    }
  }

  Future<void> _girisYap() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final HesabimIslemSonucu sonuc = await widget.viewModel.girisYap(
      telefon: _telefonDenetleyici.text,
      sifre: _sifreDenetleyici.text,
    );

    if (!mounted) {
      return;
    }

    if (!sonuc.basarili) {
      _bildirimGoster(sonuc.mesaj);
      return;
    }

    final KullaniciVarligi? kullanici = widget.viewModel.aktifKullanici;
    if (kullanici != null) {
      _profilDenetleyicileriniDoldur(kullanici);
    }
  }

  Future<void> _cikisYap() async {
    final HesabimIslemSonucu sonuc = await widget.viewModel.cikisYap();

    if (!mounted) {
      return;
    }

    if (!sonuc.basarili) {
      _bildirimGoster(sonuc.mesaj);
      return;
    }

    _telefonDenetleyici.clear();
    _sifreDenetleyici.clear();
    _profilAdSoyadDenetleyici.clear();
    _profilTelefonDenetleyici.clear();
    _profilEpostaDenetleyici.clear();
  }

  void _bildirimGoster(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mesaj)));
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
    widget.viewModel.profilDuzenlemeyiAc();
  }

  void _profilKaydet() {
    final KullaniciVarligi? kullanici = _aktifKullanici;
    if (kullanici == null) {
      return;
    }

    final HesabimIslemSonucu sonuc = widget.viewModel.profilKaydet(
      adSoyad: _profilAdSoyadDenetleyici.text,
      telefon: _profilTelefonDenetleyici.text,
      eposta: _profilEpostaDenetleyici.text,
    );
    _bildirimGoster(sonuc.mesaj);
  }

  void _adresEkle() {
    final HesabimIslemSonucu sonuc = widget.viewModel.adresEkle(
      baslik: _adresBaslikDenetleyici.text,
      adresMetni: _adresMetniDenetleyici.text,
    );
    if (sonuc.basarili) {
      _adresBaslikDenetleyici.clear();
      _adresMetniDenetleyici.clear();
    }
    _bildirimGoster(sonuc.mesaj);
  }

  void _adresSil(_AdresVerisi adres) {
    final HesabimIslemSonucu sonuc = widget.viewModel.adresSil(adres);
    _bildirimGoster(sonuc.mesaj);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (BuildContext context, Widget? child) {
        final bool masaustu = EkranBoyutu.masaustu(context);

        return Scaffold(
          backgroundColor: AnaSayfaRenkSablonu.arkaPlanKoyu,
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AnaSayfaRenkSablonu.arkaPlanKoyu,
                  AnaSayfaRenkSablonu.arkaPlanOrta,
                  AnaSayfaRenkSablonu.arkaPlanUst,
                ],
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
                          child: ListView(
                            children: [
                              if (masaustu)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 11, child: _solAlan()),
                                    const SizedBox(width: 20),
                                    Expanded(flex: 9, child: _sagAlan()),
                                  ],
                                )
                              else ...<Widget>[
                                _solAlan(),
                                const SizedBox(height: 18),
                                _sagAlan(),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _solAlan() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AnaSayfaRenkSablonu.birincilAksiyon,
            AnaSayfaRenkSablonu.ikincilAksiyon,
            AnaSayfaRenkSablonu.panelKoyu,
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              IconButton.filledTonal(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              OutlinedButton.icon(
                onPressed: () => anaSayfayaDon(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.home_rounded, size: 18),
                label: const Text('Ana sayfa'),
              ),
            ],
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
              color: AnaSayfaRenkSablonu.metinIkincil,
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
              style: TextStyle(color: Colors.white.withValues(alpha: 0.70)),
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
                  backgroundColor: AnaSayfaRenkSablonu.birincilAksiyon,
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
                  color: AnaSayfaRenkSablonu.birincilAksiyon.withValues(
                    alpha: 0.14,
                  ),
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
              onPressed: _profilDuzenleniyor
                  ? _profilKaydet
                  : _profilDuzenlemeyiAc,
              style: FilledButton.styleFrom(
                backgroundColor: AnaSayfaRenkSablonu.birincilAksiyon,
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
            style: TextStyle(color: Colors.white.withValues(alpha: 0.68)),
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
                      color: AnaSayfaRenkSablonu.metinIkincil,
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
      color: AnaSayfaRenkSablonu.panelKoyu,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
    );
  }

  InputDecoration _girdiDekorasyonu(String etiket) {
    return InputDecoration(labelText: etiket);
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
