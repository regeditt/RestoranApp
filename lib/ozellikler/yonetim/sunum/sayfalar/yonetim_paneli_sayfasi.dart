import 'package:flutter/material.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/stok_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/saatlik_siparis_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yonetim_paneli_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_analiz_kartlari.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/masa_plani_karti.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/paket_servis_operasyon_karti.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/personel_yonetimi_karti.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_ayarlari_dialogu.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yazici_form_dialogu.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yonetim_rapor_kartlari.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/bilesenler/yazici_yonetimi_karti.dart';
import 'package:restoran_app/ozellikler/yonetim/sunum/viewmodel/yonetim_paneli_viewmodel.dart';

class YonetimPaneliSayfasi extends StatefulWidget {
  const YonetimPaneliSayfasi({
    super.key,
    required this.viewModel,
    required this.servisKaydi,
  });

  final YonetimPaneliViewModel viewModel;
  final ServisKaydi servisKaydi;

  @override
  State<YonetimPaneliSayfasi> createState() => _YonetimPaneliSayfasiState();
}

class _YonetimPaneliSayfasiState extends State<YonetimPaneliSayfasi> {
  final TextEditingController _aramaDenetleyici = TextEditingController();
  final ScrollController _sayfaKaydirmaDenetleyicisi = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _yukle();
    });
  }

  @override
  void didUpdateWidget(covariant YonetimPaneliSayfasi oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel == widget.viewModel) {
      return;
    }
    oldWidget.viewModel.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _yukle();
    });
  }

  @override
  void dispose() {
    _aramaDenetleyici.dispose();
    _sayfaKaydirmaDenetleyicisi.dispose();
    widget.viewModel.dispose();
    super.dispose();
  }

  Future<void> _yukle() async {
    final YonetimPaneliIslemSonucu sonuc = await widget.viewModel.yukle();
    if (!mounted || sonuc.basarili) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  Future<void> _yaziciEkle() async {
    final YonetimPaneliViewModel viewModel = widget.viewModel;
    final YaziciFormSonucu? sonuc = await showDialog<YaziciFormSonucu>(
      context: context,
      builder: (BuildContext context) {
        return YaziciFormDialog(sistemYazicilari: viewModel.sistemYazicilari);
      },
    );

    if (sonuc == null) {
      return;
    }

    final YonetimPaneliIslemSonucu islemSonucu = await viewModel.yaziciEkle(
      YaziciDurumuVarligi(
        id: 'yzc_${DateTime.now().microsecondsSinceEpoch}',
        ad: sonuc.ad,
        rolEtiketi: sonuc.rolEtiketi,
        baglantiNoktasi: sonuc.baglantiNoktasi,
        aciklama: sonuc.aciklama,
        durum: sonuc.durum,
      ),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(islemSonucu.mesaj)));
  }

  Future<void> _yaziciSil(YaziciDurumuVarligi yazici) async {
    final YonetimPaneliIslemSonucu sonuc = await widget.viewModel.yaziciSil(
      yazici,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  Future<void> _yaziciGuncelle(
    YaziciDurumuVarligi yazici, {
    String? rolEtiketi,
    YaziciBaglantiDurumu? durum,
  }) async {
    final YonetimPaneliIslemSonucu sonuc = await widget.viewModel
        .yaziciGuncelle(yazici, rolEtiketi: rolEtiketi, durum: durum);
    if (!mounted || sonuc.basarili) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  Future<void> _yaziciYonetiminiAc() async {
    final YonetimPaneliViewModel viewModel = widget.viewModel;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return YaziciYonetimiDialog(
          yazicilar: viewModel.yazicilar,
          siparisler: viewModel.siparisler,
          yaziciEkle: _yaziciEkle,
          yaziciSil: _yaziciSil,
          yaziciGuncelle: _yaziciGuncelle,
        );
      },
    );
  }

  Future<void> _yonetimVerileriniYenile() async {
    final YonetimPaneliIslemSonucu sonuc = await widget.viewModel
        .yonetimVerileriniYenile();
    if (!mounted || sonuc.basarili) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(sonuc.mesaj)));
  }

  Future<void> _yonetimAyarlariniAc([int baslangicSekmesi = 0]) async {
    final YonetimPaneliViewModel viewModel = widget.viewModel;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return YonetimAyarlariDialog(
          salonBolumleri: viewModel.salonBolumleri,
          menuKategorileri: viewModel.menuKategorileri,
          menuUrunleri: viewModel.menuUrunleri,
          veriYenile: _yonetimVerileriniYenile,
          servisKaydi: widget.servisKaydi,
          baslangicSekmesi: baslangicSekmesi,
        );
      },
    );
    await _yonetimVerileriniYenile();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (BuildContext context, _) {
        final YonetimPaneliViewModel viewModel = widget.viewModel;
        final bool masaustu = EkranBoyutu.masaustu(context);
        final List<SiparisVarligi> filtreliSiparisler =
            viewModel.filtreliSiparisler;
        final YonetimPaneliOzetiVarligi ozet = viewModel.panelOzeti;
        final List<SaatlikSiparisOzetiVarligi> saatlikVeriler =
            viewModel.saatlikVeriler;

        return Scaffold(
          backgroundColor: const Color(0xFF110D18),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF17111F),
                  Color(0xFF241733),
                  Color(0xFF321A45),
                ],
              ),
            ),
            child: SafeArea(
              child: viewModel.yukleniyor
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1500),
                        child: Padding(
                          padding: EdgeInsets.all(masaustu ? 22 : 14),
                          child: Scrollbar(
                            thumbVisibility: true,
                            controller: _sayfaKaydirmaDenetleyicisi,
                            child: ListView(
                              controller: _sayfaKaydirmaDenetleyicisi,
                              children: [
                                _KompaktUstAlan(
                                  ozet: ozet,
                                  seciliFiltre: viewModel.seciliFiltre,
                                  filtreSec: viewModel.filtreSec,
                                  seciliZamanFiltresi:
                                      viewModel.seciliZamanFiltresi,
                                  zamanFiltresiSec: viewModel.zamanFiltresiSec,
                                  seciliSiralama: viewModel.seciliSiralama,
                                  siralamaSec: viewModel.siralamaSec,
                                  yaziciYonetimiAc: _yaziciYonetiminiAc,
                                  salonYonetimiAc: () =>
                                      _yonetimAyarlariniAc(0),
                                  menuYonetimiAc: () => _yonetimAyarlariniAc(1),
                                  stokYonetimiAc: () => _yonetimAyarlariniAc(2),
                                ),
                                const SizedBox(height: 18),
                                masaustu
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 7,
                                            child: _SiparisAkisi(
                                              siparisler: filtreliSiparisler,
                                              aramaMetni: viewModel.aramaMetni,
                                              aramaDenetleyici:
                                                  _aramaDenetleyici,
                                              aramaDegisti:
                                                  viewModel.aramaMetniDegisti,
                                            ),
                                          ),
                                          const SizedBox(width: 18),
                                          Expanded(
                                            flex: 5,
                                            child: _YanPanel(
                                              ozet: ozet,
                                              saatlikVeriler: saatlikVeriler,
                                              siparisler: filtreliSiparisler,
                                              salonBolumleri:
                                                  viewModel.salonBolumleri,
                                              stokOzeti: viewModel.stokOzeti,
                                              yaziciEkle: _yaziciEkle,
                                              yaziciSil: _yaziciSil,
                                              yaziciGuncelle: _yaziciGuncelle,
                                              personeller:
                                                  viewModel.personeller,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          _SiparisAkisi(
                                            siparisler: filtreliSiparisler,
                                            aramaMetni: viewModel.aramaMetni,
                                            aramaDenetleyici: _aramaDenetleyici,
                                            aramaDegisti:
                                                viewModel.aramaMetniDegisti,
                                          ),
                                          const SizedBox(height: 18),
                                          _YanPanel(
                                            ozet: ozet,
                                            saatlikVeriler: saatlikVeriler,
                                            siparisler: filtreliSiparisler,
                                            salonBolumleri:
                                                viewModel.salonBolumleri,
                                            stokOzeti: viewModel.stokOzeti,
                                            yaziciEkle: _yaziciEkle,
                                            yaziciSil: _yaziciSil,
                                            yaziciGuncelle: _yaziciGuncelle,
                                            personeller: viewModel.personeller,
                                          ),
                                        ],
                                      ),
                              ],
                            ),
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

typedef _PanelFiltre = PanelFiltre;

typedef _ZamanFiltresi = ZamanFiltresi;

typedef _SiparisSirasi = SiparisSirasi;

class _KontrolCubugu extends StatelessWidget {
  const _KontrolCubugu({
    required this.seciliZamanFiltresi,
    required this.zamanFiltresiSec,
    required this.seciliSiralama,
    required this.siralamaSec,
  });

  final _ZamanFiltresi seciliZamanFiltresi;
  final ValueChanged<_ZamanFiltresi> zamanFiltresiSec;
  final _SiparisSirasi seciliSiralama;
  final ValueChanged<_SiparisSirasi> siralamaSec;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _SecimKutusu<_ZamanFiltresi>(
          baslik: 'Zaman',
          seciliDeger: seciliZamanFiltresi,
          secenekler: const [
            (_ZamanFiltresi.bugun, 'Bugun'),
            (_ZamanFiltresi.sonIkiSaat, 'Son 2 saat'),
            (_ZamanFiltresi.tumu, 'Tum zaman'),
          ],
          degisti: zamanFiltresiSec,
        ),
        _SecimKutusu<_SiparisSirasi>(
          baslik: 'Sirala',
          seciliDeger: seciliSiralama,
          secenekler: const [
            (_SiparisSirasi.enYeni, 'En yeni'),
            (_SiparisSirasi.tutarYuksek, 'Tutar'),
            (_SiparisSirasi.durumOncelikli, 'Durum'),
          ],
          degisti: siralamaSec,
        ),
      ],
    );
  }
}

class _SecimKutusu<T> extends StatelessWidget {
  const _SecimKutusu({
    required this.baslik,
    required this.seciliDeger,
    required this.secenekler,
    required this.degisti,
  });

  final String baslik;
  final T seciliDeger;
  final List<(T, String)> secenekler;
  final ValueChanged<T> degisti;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$baslik: ',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: seciliDeger,
              dropdownColor: const Color(0xFF2B1D3A),
              borderRadius: BorderRadius.circular(16),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              iconEnabledColor: Colors.white,
              items: secenekler
                  .map(
                    (secenek) => DropdownMenuItem<T>(
                      value: secenek.$1,
                      child: Text(secenek.$2),
                    ),
                  )
                  .toList(),
              onChanged: (T? deger) {
                if (deger != null) {
                  degisti(deger);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltreCubugu extends StatelessWidget {
  const _FiltreCubugu({required this.seciliFiltre, required this.filtreSec});

  final _PanelFiltre seciliFiltre;
  final ValueChanged<_PanelFiltre> filtreSec;

  @override
  Widget build(BuildContext context) {
    final List<(_PanelFiltre, String)> filtreler = <(_PanelFiltre, String)>[
      (_PanelFiltre.tumu, 'Tumu'),
      (_PanelFiltre.aktif, 'Aktif'),
      (_PanelFiltre.gelAl, 'Gel al'),
      (_PanelFiltre.paketServis, 'Paket'),
      (_PanelFiltre.restorandaYe, 'Salon'),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: filtreler.map((veri) {
        final bool seciliMi = veri.$1 == seciliFiltre;
        return InkWell(
          onTap: () => filtreSec(veri.$1),
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: seciliMi
                  ? const Color(0xFFFF5D8F)
                  : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: seciliMi
                    ? const Color(0xFFFF84AB)
                    : Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              veri.$2,
              style: TextStyle(
                color: Colors.white,
                fontWeight: seciliMi ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _KompaktUstAlan extends StatelessWidget {
  const _KompaktUstAlan({
    required this.ozet,
    required this.seciliFiltre,
    required this.filtreSec,
    required this.seciliZamanFiltresi,
    required this.zamanFiltresiSec,
    required this.seciliSiralama,
    required this.siralamaSec,
    required this.yaziciYonetimiAc,
    required this.salonYonetimiAc,
    required this.menuYonetimiAc,
    required this.stokYonetimiAc,
  });

  final YonetimPaneliOzetiVarligi ozet;
  final _PanelFiltre seciliFiltre;
  final ValueChanged<_PanelFiltre> filtreSec;
  final _ZamanFiltresi seciliZamanFiltresi;
  final ValueChanged<_ZamanFiltresi> zamanFiltresiSec;
  final _SiparisSirasi seciliSiralama;
  final ValueChanged<_SiparisSirasi> siralamaSec;
  final Future<void> Function() yaziciYonetimiAc;
  final Future<void> Function() salonYonetimiAc;
  final Future<void> Function() menuYonetimiAc;
  final Future<void> Function() stokYonetimiAc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C1327), Color(0xFF2A1938), Color(0xFF3B1E4C)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UygulamaSabitleri.yonetimPaneliBasligi,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Karmasayi azaltan, karar vermeyi hizlandiran operasyon gorunumu.',
                      style: TextStyle(color: Color(0xFFD8CDE3), height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(RotaYapisi.pos);
                    },
                    style: FilledButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                    icon: const Icon(Icons.point_of_sale_rounded, size: 18),
                    label: const Text('POS ekranina git'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(RotaYapisi.personelGiris);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                    icon: const Icon(Icons.switch_account_rounded, size: 18),
                    label: const Text('Personel girisine don'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: salonYonetimiAc,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8B6B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.chair_alt_rounded),
                label: const Text('Salon yonetimi'),
              ),
              FilledButton.tonalIcon(
                onPressed: menuYonetimiAc,
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.restaurant_menu_rounded),
                label: const Text('Menu yonetimi'),
              ),
              FilledButton.tonalIcon(
                onPressed: stokYonetimiAc,
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.inventory_2_rounded),
                label: const Text('Stok yonetimi'),
              ),
              FilledButton.icon(
                onPressed: yaziciYonetimiAc,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF271830),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.print_rounded),
                label: const Text('Yazici yonetimi'),
              ),
              Text(
                'Yazici ayarlari popup pencerede acilir.',
                style: const TextStyle(
                  color: Color(0xFFE8DDF0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _OperasyonMetrigi(
                baslik: 'Aktif siparis',
                deger:
                    '${ozet.hazirlananSiparis + ozet.hazirSiparis + ozet.yoldaSiparis}',
                renk: const Color(0xFFFF8B6B),
              ),
              _OperasyonMetrigi(
                baslik: 'Gunluk ciro',
                deger: paraYaz(ozet.toplamCiro),
                renk: const Color(0xFF7FE7B3),
              ),
              _OperasyonMetrigi(
                baslik: 'Salon',
                deger: '${ozet.restorandaYeSayisi}',
                renk: const Color(0xFF74A2FF),
              ),
              _OperasyonMetrigi(
                baslik: 'Paket',
                deger: '${ozet.paketServisSayisi}',
                renk: const Color(0xFFC58CFF),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _FiltreCubugu(seciliFiltre: seciliFiltre, filtreSec: filtreSec),
          const SizedBox(height: 12),
          _KontrolCubugu(
            seciliZamanFiltresi: seciliZamanFiltresi,
            zamanFiltresiSec: zamanFiltresiSec,
            seciliSiralama: seciliSiralama,
            siralamaSec: siralamaSec,
          ),
        ],
      ),
    );
  }
}

class _OperasyonMetrigi extends StatelessWidget {
  const _OperasyonMetrigi({
    required this.baslik,
    required this.deger,
    required this.renk,
  });

  final String baslik;
  final String deger;
  final Color renk;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: const TextStyle(
              color: Color(0xFFD8CDE3),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            deger,
            style: TextStyle(
              color: renk,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SiparisAkisi extends StatelessWidget {
  const _SiparisAkisi({
    required this.siparisler,
    required this.aramaMetni,
    required this.aramaDenetleyici,
    required this.aramaDegisti,
  });

  final List<SiparisVarligi> siparisler;
  final String aramaMetni;
  final TextEditingController aramaDenetleyici;
  final ValueChanged<String> aramaDegisti;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5FB),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Canli siparis akisi',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFF25192E),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Mutfak ve servis ekibinin takip edecegi operasyon listesi.',
            style: TextStyle(color: Color(0xFF7A6D86)),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: aramaDenetleyici,
            onChanged: aramaDegisti,
            decoration: InputDecoration(
              hintText: 'Siparis no veya musteri ara',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: aramaMetni.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        aramaDenetleyici.clear();
                        aramaDegisti('');
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (siparisler.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Filtreye uygun siparis bulunamadi.',
                style: TextStyle(
                  color: Color(0xFF7A6D86),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            ...siparisler.map((siparis) => _SiparisSatiri(siparis: siparis)),
        ],
      ),
    );
  }
}

class _SiparisSatiri extends StatelessWidget {
  const _SiparisSatiri({required this.siparis});

  final SiparisVarligi siparis;

  @override
  Widget build(BuildContext context) {
    final Color durumRenk = durumRengi(siparis.durum);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: durumRenk.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                siparis.siparisNo,
                style: TextStyle(
                  color: durumRenk,
                  fontSize: 11,
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
                    siparis.sahip.misafirBilgisi?.adSoyad ?? 'Misafir',
                    style: const TextStyle(
                      color: Color(0xFF261B30),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    siparisAltEtiketi(siparis),
                    style: const TextStyle(color: Color(0xFF7A6D86)),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: durumRenk.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                durumEtiketi(siparis.durum),
                style: TextStyle(color: durumRenk, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${siparis.toplamTutar.toStringAsFixed(0)} TL',
              style: const TextStyle(
                color: Color(0xFF261B30),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YanPanel extends StatelessWidget {
  const _YanPanel({
    required this.ozet,
    required this.saatlikVeriler,
    required this.siparisler,
    required this.salonBolumleri,
    required this.stokOzeti,
    required this.yaziciEkle,
    required this.yaziciSil,
    required this.yaziciGuncelle,
    required this.personeller,
  });

  final YonetimPaneliOzetiVarligi ozet;
  final List<SaatlikSiparisOzetiVarligi> saatlikVeriler;
  final List<SiparisVarligi> siparisler;
  final List<SalonBolumuVarligi> salonBolumleri;
  final StokOzetiVarligi? stokOzeti;
  final Future<void> Function() yaziciEkle;
  final Future<void> Function(YaziciDurumuVarligi yazici) yaziciSil;
  final Future<void> Function(
    YaziciDurumuVarligi yazici, {
    String? rolEtiketi,
    YaziciBaglantiDurumu? durum,
  })
  yaziciGuncelle;
  final List<PersonelDurumuVarligi> personeller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double genislik = constraints.maxWidth;
        final bool ikiKolon = genislik >= 760;
        final double yariGenislik = ikiKolon ? (genislik - 18) / 2 : genislik;

        return Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            SizedBox(
              width: yariGenislik,
              child: KanalDagilimiKarti(ozet: ozet),
            ),
            SizedBox(
              width: yariGenislik,
              child: PaketServisOperasyonKarti(siparisler: siparisler),
            ),
            SizedBox(
              width: yariGenislik,
              child: SaatlikTrendKarti(veriler: saatlikVeriler),
            ),
            if (stokOzeti != null)
              SizedBox(
                width: yariGenislik,
                child: StokVeMaliyetKarti(ozet: stokOzeti!),
              ),
            SizedBox(
              width: yariGenislik,
              child: PatronRaporuKarti(
                siparisler: siparisler,
                saatlikVeriler: saatlikVeriler,
              ),
            ),
            SizedBox(
              width: yariGenislik,
              child: PersonelYonetimiKarti(personeller: personeller),
            ),
            SizedBox(
              width: genislik,
              child: MasaPlaniKarti(
                siparisler: siparisler,
                salonBolumleri: salonBolumleri,
              ),
            ),
          ],
        );
      },
    );
  }
}

String paraYaz(double tutar) {
  return '${tutar.toStringAsFixed(0)} TL';
}

Color durumRengi(SiparisDurumu durum) {
  switch (durum) {
    case SiparisDurumu.alindi:
      return const Color(0xFFFF8B6B);
    case SiparisDurumu.hazirlaniyor:
      return const Color(0xFFFFC857);
    case SiparisDurumu.hazir:
      return const Color(0xFF48CFA4);
    case SiparisDurumu.yolda:
      return const Color(0xFF74A2FF);
    case SiparisDurumu.teslimEdildi:
      return const Color(0xFF8B9BB2);
    case SiparisDurumu.iptalEdildi:
      return const Color(0xFFFF6F91);
  }
}

String siparisAltEtiketi(SiparisVarligi siparis) {
  final String kanal = switch (siparis.teslimatTipi) {
    TeslimatTipi.restorandaYe => 'Salon',
    TeslimatTipi.gelAl => 'Gel al',
    TeslimatTipi.paketServis => 'Paket servis',
  };
  final int urunAdedi = siparis.kalemler.fold<int>(
    0,
    (toplam, kalem) => toplam + kalem.adet,
  );
  return '$kanal · $urunAdedi urun';
}

String durumEtiketi(SiparisDurumu durum) {
  switch (durum) {
    case SiparisDurumu.alindi:
      return 'Alindi';
    case SiparisDurumu.hazirlaniyor:
      return 'Hazirlaniyor';
    case SiparisDurumu.hazir:
      return 'Hazir';
    case SiparisDurumu.yolda:
      return 'Yolda';
    case SiparisDurumu.teslimEdildi:
      return 'Teslim edildi';
    case SiparisDurumu.iptalEdildi:
      return 'Iptal edildi';
  }
}
