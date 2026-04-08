import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/viewmodel/giris_secim_viewmodel.dart';

typedef _PersonelGirisModu = PersonelGirisModu;
typedef _GirisHedefi = GirisHedefi;

class GirisSecimSayfasi extends StatefulWidget {
  const GirisSecimSayfasi({super.key, required this.viewModel});

  final GirisSecimViewModel viewModel;

  @override
  State<GirisSecimSayfasi> createState() => _GirisSecimSayfasiState();
}

class _GirisSecimSayfasiState extends State<GirisSecimSayfasi> {
  final TextEditingController _adSoyadDenetleyici = TextEditingController();
  final TextEditingController _kullaniciAdiDenetleyici =
      TextEditingController();
  final TextEditingController _sifreDenetleyici = TextEditingController();

  @override
  void didUpdateWidget(covariant GirisSecimSayfasi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      oldWidget.viewModel.dispose();
    }
  }

  @override
  void dispose() {
    _adSoyadDenetleyici.dispose();
    _kullaniciAdiDenetleyici.dispose();
    _sifreDenetleyici.dispose();
    widget.viewModel.dispose();
    super.dispose();
  }

  Future<void> _devamEt({_GirisHedefi hedef = _GirisHedefi.pos}) async {
    final GirisSecimIslemSonucu sonuc = await widget.viewModel.devamEt(
      adSoyad: _adSoyadDenetleyici.text,
      kullaniciAdi: _kullaniciAdiDenetleyici.text,
      sifre: _sifreDenetleyici.text,
      hedef: hedef,
    );

    if (!mounted) {
      return;
    }

    if (!sonuc.basarili || sonuc.hedef == null) {
      _uyari(sonuc.mesaj);
      return;
    }

    Navigator.of(context).pushReplacementNamed(switch (sonuc.hedef!) {
      _GirisHedefi.pos => RotaYapisi.pos,
      _GirisHedefi.yonetim => RotaYapisi.yonetimPaneli,
      _GirisHedefi.mutfak => RotaYapisi.mutfak,
    });
  }

  void _uyari(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mesaj)));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (BuildContext context, Widget? child) {
        final bool mobil = MediaQuery.sizeOf(context).width < 760;
        final bool islemde = widget.viewModel.islemde;
        final _PersonelGirisModu seciliMod = widget.viewModel.seciliMod;
        final bool hesapOlusturmaModu = widget.viewModel.hesapOlusturmaModu;

        return Scaffold(
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF120A1F),
                  Color(0xFF241036),
                  Color(0xFF3C184F),
                ],
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
                          style: TextStyle(
                            color: Color(0xFFD9CEE5),
                            fontSize: 16,
                          ),
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
                                icon: const Icon(
                                  Icons.qr_code_2_rounded,
                                  size: 18,
                                ),
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
                                  seciliMi: seciliMod == mod,
                                  genislik: mobil ? double.infinity : 452,
                                  tiklandi: () => widget.viewModel.modSec(mod),
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
                              if (widget
                                      .viewModel
                                      .kullanilabilirEkranModlari
                                      .length >
                                  1) ...[
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: widget
                                      .viewModel
                                      .kullanilabilirEkranModlari
                                      .where(
                                        (KimlikEkranModu mod) =>
                                            mod != widget.viewModel.ekranModu,
                                      )
                                      .map(
                                        (KimlikEkranModu mod) => ChoiceChip(
                                          label: Text(
                                            mod == KimlikEkranModu.girisYap
                                                ? 'Girise don'
                                                : mod.baslik,
                                          ),
                                          selected: false,
                                          onSelected: islemde
                                              ? null
                                              : (_) => widget.viewModel
                                                    .ekranModuSec(mod),
                                        ),
                                      )
                                      .toList(),
                                ),
                                const SizedBox(height: 16),
                              ],
                              Text(
                                widget.viewModel.formBaslik,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.viewModel.formAciklama,
                                style: const TextStyle(
                                  color: Color(0xFF6D6079),
                                ),
                              ),
                              const SizedBox(height: 18),
                              if (hesapOlusturmaModu) ...[
                                TextField(
                                  controller: _adSoyadDenetleyici,
                                  decoration: const InputDecoration(
                                    labelText: 'Ad soyad',
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                              TextField(
                                controller: _kullaniciAdiDenetleyici,
                                decoration: const InputDecoration(
                                  labelText: 'Kullanici adi / telefon',
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
                                  onPressed: islemde
                                      ? null
                                      : () =>
                                            _devamEt(hedef: seciliMod.ilkHedef),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF5D8F),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: Text(
                                    islemde
                                        ? 'Hazirlaniyor...'
                                        : widget.viewModel.anaAksiyonMetni,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: islemde
                                        ? null
                                        : () => _devamEt(
                                            hedef: _GirisHedefi.mutfak,
                                          ),
                                    icon: const Icon(Icons.restaurant_rounded),
                                    label: const Text('Mutfak ekranina git'),
                                  ),
                                  if (seciliMod == _PersonelGirisModu.yonetici)
                                    OutlinedButton.icon(
                                      onPressed: islemde
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
      },
    );
  }
}

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
