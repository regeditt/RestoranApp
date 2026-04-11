import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bagimlilik/servis_saglayici.dart';
import 'package:restoran_app/ortak/bilesenler/ana_sayfaya_donus.dart';
import 'package:restoran_app/ortak/tema/ana_sayfa_renk_sablonu.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/roller/kullanici_rolu.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/bilesenler/giris_asistani_dialogu.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/viewmodel/giris_asistani_viewmodel.dart';
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

  Future<void> _chatbotuAc() {
    final GirisAsistaniViewModel asistanViewModel =
        GirisAsistaniViewModel.servisKaydindan(ServisSaglayici.of(context));
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return GirisAsistaniDialog(viewModel: asistanViewModel);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (BuildContext context, Widget? child) {
        final ThemeData temelTema = Theme.of(context);
        const Color formAlanMetinRengi = AnaSayfaRenkSablonu.metinAcikZemin;
        const Color formAlanIkincilMetinRengi = Color(0xFF56466C);
        const Color formAlanKenarRengi = Color(0xFFD8CCE7);
        final ThemeData acikFormTema = temelTema.copyWith(
          canvasColor: const Color(0xFFF4EFF9),
          colorScheme: temelTema.colorScheme.copyWith(
            surface: const Color(0xFFF4EFF9),
            onSurface: formAlanMetinRengi,
          ),
          textTheme: temelTema.textTheme.apply(
            bodyColor: formAlanMetinRengi,
            displayColor: formAlanMetinRengi,
          ),
          iconTheme: const IconThemeData(color: Color(0xFF6B5A80)),
          popupMenuTheme: PopupMenuThemeData(
            color: const Color(0xFFF4EFF9),
            surfaceTintColor: Colors.transparent,
            textStyle: const TextStyle(
              color: formAlanMetinRengi,
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: formAlanKenarRengi),
            ),
          ),
          inputDecorationTheme: temelTema.inputDecorationTheme.copyWith(
            filled: true,
            fillColor: const Color(0xFFF4EFF9),
            labelStyle: const TextStyle(
              color: Color(0xFF5A4A70),
              fontWeight: FontWeight.w700,
            ),
            floatingLabelStyle: const TextStyle(
              color: AnaSayfaRenkSablonu.birincilAksiyon,
              fontWeight: FontWeight.w800,
            ),
            hintStyle: const TextStyle(
              color: Color(0xFF7B6B8F),
              fontWeight: FontWeight.w500,
            ),
            prefixIconColor: const Color(0xFF6B5A80),
            suffixIconColor: const Color(0xFF6B5A80),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: formAlanKenarRengi),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: formAlanKenarRengi),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                color: AnaSayfaRenkSablonu.birincilAksiyon,
                width: 1.8,
              ),
            ),
          ),
        );
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
                  AnaSayfaRenkSablonu.arkaPlanKoyu,
                  AnaSayfaRenkSablonu.arkaPlanOrta,
                  AnaSayfaRenkSablonu.arkaPlanUst,
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
                            color: AnaSayfaRenkSablonu.metinIkincil,
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
                              FilledButton.tonalIcon(
                                onPressed: () => anaSayfayaDon(context),
                                style: FilledButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.14,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                icon: const Icon(Icons.home_rounded, size: 18),
                                label: const Text('Ana sayfaya don'),
                              ),
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
                              OutlinedButton.icon(
                                onPressed: _chatbotuAc,
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
                                  Icons.smart_toy_rounded,
                                  size: 18,
                                ),
                                label: const Text('Chatbot'),
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
                        Theme(
                          data: acikFormTema,
                          child: Container(
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
                                    color: formAlanMetinRengi,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.viewModel.formAciklama,
                                  style: const TextStyle(
                                    color: formAlanIkincilMetinRengi,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                if (hesapOlusturmaModu) ...[
                                  DropdownButtonFormField<KullaniciRolu>(
                                    initialValue: widget
                                        .viewModel
                                        .seciliHesapOlusturmaRolu,
                                    dropdownColor: const Color(0xFFF4EFF9),
                                    style: const TextStyle(
                                      color: formAlanMetinRengi,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'Rol',
                                    ),
                                    items: widget
                                        .viewModel
                                        .secilebilirHesapRolleri
                                        .map(
                                          (KullaniciRolu rol) =>
                                              DropdownMenuItem<KullaniciRolu>(
                                                value: rol,
                                                child: Text(
                                                  widget.viewModel.rolEtiketi(
                                                    rol,
                                                  ),
                                                ),
                                              ),
                                        )
                                        .toList(),
                                    onChanged: islemde
                                        ? null
                                        : (KullaniciRolu? rol) {
                                            if (rol == null) {
                                              return;
                                            }
                                            widget.viewModel
                                                .hesapOlusturmaRoluSec(rol);
                                          },
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _adSoyadDenetleyici,
                                    style: const TextStyle(
                                      color: formAlanMetinRengi,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'Ad soyad',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                TextField(
                                  controller: _kullaniciAdiDenetleyici,
                                  style: const TextStyle(
                                    color: formAlanMetinRengi,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: 'Kullanici adi / telefon',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _sifreDenetleyici,
                                  obscureText: true,
                                  style: const TextStyle(
                                    color: formAlanMetinRengi,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: 'Sifre',
                                  ),
                                ),
                                const SizedBox(height: 18),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: islemde ? null : _devamEt,
                                    style: FilledButton.styleFrom(
                                      backgroundColor:
                                          AnaSayfaRenkSablonu.birincilAksiyon,
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
                                      icon: const Icon(
                                        Icons.restaurant_rounded,
                                      ),
                                      label: const Text('Mutfak ekranina git'),
                                    ),
                                    if (seciliMod ==
                                        _PersonelGirisModu.yonetici)
                                      OutlinedButton.icon(
                                        onPressed: islemde
                                            ? null
                                            : () => _devamEt(
                                                hedef: _GirisHedefi.yonetim,
                                              ),
                                        icon: const Icon(
                                          Icons.dashboard_rounded,
                                        ),
                                        label: const Text(
                                          'Yonetim paneline git',
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
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
              ? AnaSayfaRenkSablonu.birincilAksiyon
              : Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: seciliMi
                ? AnaSayfaRenkSablonu.metinIkincil
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
              style: const TextStyle(
                color: AnaSayfaRenkSablonu.metinIkincil,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
