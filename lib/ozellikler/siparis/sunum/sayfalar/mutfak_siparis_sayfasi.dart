import 'package:flutter/material.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_is_kuyrugu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/servisler/yazici_is_kuyrugu_hesaplayici.dart';

class MutfakSiparisSayfasi extends StatefulWidget {
  const MutfakSiparisSayfasi({super.key});

  @override
  State<MutfakSiparisSayfasi> createState() => _MutfakSiparisSayfasiState();
}

class _MutfakSiparisSayfasiState extends State<MutfakSiparisSayfasi> {
  final ServisKaydi _servisKaydi = ServisKaydi.ortak;
  final ScrollController _yatayKaydirmaDenetleyicisi = ScrollController();

  bool _yukleniyor = true;
  List<SiparisVarligi> _siparisler = const <SiparisVarligi>[];
  List<YaziciDurumuVarligi> _yazicilar = const <YaziciDurumuVarligi>[];
  _TeslimatFiltresi _seciliFiltre = _TeslimatFiltresi.tumu;

  @override
  void initState() {
    super.initState();
    _yukle();
  }

  @override
  void dispose() {
    _yatayKaydirmaDenetleyicisi.dispose();
    super.dispose();
  }

  Future<void> _yukle() async {
    final List<SiparisVarligi> siparisler = await _servisKaydi
        .siparisleriGetirUseCase();
    final List<YaziciDurumuVarligi> yazicilar = await _servisKaydi
        .yazicilariGetirUseCase();
    if (!mounted) {
      return;
    }
    setState(() {
      _siparisler = siparisler;
      _yazicilar = yazicilar;
      _yukleniyor = false;
    });
  }

  Future<void> _durumIlerle(SiparisVarligi siparis) async {
    final SiparisDurumu? sonrakiDurum = _sonrakiDurum(siparis);
    if (sonrakiDurum == null) {
      return;
    }

    await _servisKaydi.siparisDurumuGuncelleUseCase(siparis.id, sonrakiDurum);
    await _yukle();

    if (!mounted) {
      return;
    }
    final String yaziciMesaji = _durumYaziciMesaji(siparis, sonrakiDurum);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${siparis.siparisNo} ${_durumEtiketi(sonrakiDurum).toLowerCase()} durumuna alindi. $yaziciMesaji',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool masaustu = EkranBoyutu.masaustu(context);
    final List<SiparisVarligi> filtrelenmisSiparisler = _filtrelenmisSiparisler;
    final List<SiparisVarligi> yeniSiparisler = _grupSiparisleri(
      filtrelenmisSiparisler,
      const <SiparisDurumu>[SiparisDurumu.alindi],
    );
    final List<SiparisVarligi> hazirlananlar = _grupSiparisleri(
      filtrelenmisSiparisler,
      const <SiparisDurumu>[SiparisDurumu.hazirlaniyor],
    );
    final List<SiparisVarligi> hazirlar = _grupSiparisleri(
      filtrelenmisSiparisler,
      const <SiparisDurumu>[SiparisDurumu.hazir],
    );
    final List<SiparisVarligi> kapanisAkisi = _grupSiparisleri(
      filtrelenmisSiparisler,
      const <SiparisDurumu>[SiparisDurumu.yolda, SiparisDurumu.teslimEdildi],
    );
    final List<YaziciIsKuyruguVarligi> yaziciKuyrugu =
        YaziciIsKuyruguHesaplayici.kuyruguHazirla(_siparisler);

    return Scaffold(
      backgroundColor: const Color(0xFF130F1D),
      appBar: AppBar(
        title: const Text('Mutfak Siparis Yonetimi'),
        actions: [
          IconButton(
            onPressed: _yukle,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.all(masaustu ? 20 : 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MutfakNavigasyonSeridi(mobil: !masaustu),
                    const SizedBox(height: 16),
                    _MutfakYaziciSeridi(
                      yazicilar: _yazicilar,
                      kuyruk: yaziciKuyrugu,
                    ),
                    const SizedBox(height: 16),
                    _MutfakOzetSeridi(siparisler: filtrelenmisSiparisler),
                    const SizedBox(height: 16),
                    _TeslimatFiltreSeridi(
                      seciliFiltre: _seciliFiltre,
                      filtreDegistir: (_TeslimatFiltresi filtre) {
                        setState(() {
                          _seciliFiltre = filtre;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: masaustu
                          ? Scrollbar(
                              thumbVisibility: true,
                              controller: _yatayKaydirmaDenetleyicisi,
                              child: SingleChildScrollView(
                                controller: _yatayKaydirmaDenetleyicisi,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _DurumKolonu(
                                      baslik: 'Yeni',
                                      aciklama: 'Mutfaga yeni dusen siparisler',
                                      bosDurumMetni:
                                          'Bu filtrede yeni siparis yok',
                                      vurguRengi: const Color(0xFFFF8A5B),
                                      siparisler: yeniSiparisler,
                                      aksiyonCalistir: _durumIlerle,
                                    ),
                                    const SizedBox(width: 14),
                                    _DurumKolonu(
                                      baslik: 'Hazirlaniyor',
                                      aciklama: 'Aktif mutfak operasyonu',
                                      bosDurumMetni:
                                          'Su an mutfakta aktif siparis yok',
                                      vurguRengi: const Color(0xFFFFC857),
                                      siparisler: hazirlananlar,
                                      aksiyonCalistir: _durumIlerle,
                                    ),
                                    const SizedBox(width: 14),
                                    _DurumKolonu(
                                      baslik: 'Hazir',
                                      aciklama:
                                          'Servis veya teslim bekleyenler',
                                      bosDurumMetni:
                                          'Bekleyen hazir siparis yok',
                                      vurguRengi: const Color(0xFF30C48D),
                                      siparisler: hazirlar,
                                      aksiyonCalistir: _durumIlerle,
                                    ),
                                    const SizedBox(width: 14),
                                    _DurumKolonu(
                                      baslik: 'Kapanis',
                                      aciklama: 'Dagitim ve teslim kapanisi',
                                      bosDurumMetni:
                                          'Kapanis akisinda siparis yok',
                                      vurguRengi: const Color(0xFF7BA7FF),
                                      siparisler: kapanisAkisi,
                                      aksiyonCalistir: _durumIlerle,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView(
                              children: [
                                _DurumKolonu(
                                  baslik: 'Yeni',
                                  aciklama: 'Mutfaga yeni dusen siparisler',
                                  bosDurumMetni: 'Bu filtrede yeni siparis yok',
                                  vurguRengi: const Color(0xFFFF8A5B),
                                  siparisler: yeniSiparisler,
                                  aksiyonCalistir: _durumIlerle,
                                  yukseklik: 380,
                                ),
                                const SizedBox(height: 14),
                                _DurumKolonu(
                                  baslik: 'Hazirlaniyor',
                                  aciklama: 'Aktif mutfak operasyonu',
                                  bosDurumMetni:
                                      'Su an mutfakta aktif siparis yok',
                                  vurguRengi: const Color(0xFFFFC857),
                                  siparisler: hazirlananlar,
                                  aksiyonCalistir: _durumIlerle,
                                  yukseklik: 380,
                                ),
                                const SizedBox(height: 14),
                                _DurumKolonu(
                                  baslik: 'Hazir',
                                  aciklama: 'Servis veya teslim bekleyenler',
                                  bosDurumMetni: 'Bekleyen hazir siparis yok',
                                  vurguRengi: const Color(0xFF30C48D),
                                  siparisler: hazirlar,
                                  aksiyonCalistir: _durumIlerle,
                                  yukseklik: 380,
                                ),
                                const SizedBox(height: 14),
                                _DurumKolonu(
                                  baslik: 'Kapanis',
                                  aciklama: 'Dagitim ve teslim kapanisi',
                                  bosDurumMetni: 'Kapanis akisinda siparis yok',
                                  vurguRengi: const Color(0xFF7BA7FF),
                                  siparisler: kapanisAkisi,
                                  aksiyonCalistir: _durumIlerle,
                                  yukseklik: 340,
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  List<SiparisVarligi> get _filtrelenmisSiparisler {
    if (_seciliFiltre == _TeslimatFiltresi.tumu) {
      return _siparisler;
    }

    return _siparisler
        .where(
          (SiparisVarligi siparis) =>
              siparis.teslimatTipi == _seciliFiltre.teslimatTipi,
        )
        .toList();
  }

  List<SiparisVarligi> _grupSiparisleri(
    List<SiparisVarligi> kaynak,
    List<SiparisDurumu> durumlar,
  ) {
    return kaynak
        .where((SiparisVarligi siparis) => durumlar.contains(siparis.durum))
        .toList()
      ..sort(
        (SiparisVarligi a, SiparisVarligi b) =>
            a.olusturmaTarihi.compareTo(b.olusturmaTarihi),
      );
  }

  SiparisDurumu? _sonrakiDurum(SiparisVarligi siparis) {
    switch (siparis.durum) {
      case SiparisDurumu.alindi:
        return SiparisDurumu.hazirlaniyor;
      case SiparisDurumu.hazirlaniyor:
        return SiparisDurumu.hazir;
      case SiparisDurumu.hazir:
        return siparis.teslimatTipi == TeslimatTipi.paketServis
            ? SiparisDurumu.yolda
            : SiparisDurumu.teslimEdildi;
      case SiparisDurumu.yolda:
        return SiparisDurumu.teslimEdildi;
      case SiparisDurumu.teslimEdildi:
      case SiparisDurumu.iptalEdildi:
        return null;
    }
  }

  String _durumYaziciMesaji(
    SiparisVarligi siparis,
    SiparisDurumu sonrakiDurum,
  ) {
    final String hat = _yaziciHattiEtiketi(siparis);
    switch (sonrakiDurum) {
      case SiparisDurumu.hazirlaniyor:
        return '$hat hatti aktif kuyrukta guncellendi';
      case SiparisDurumu.hazir:
        return '$hat hattina hazir bildirimi yansidi';
      case SiparisDurumu.yolda:
        return 'Kasa ve paket hattina teslim cikisi aktarıldi';
      case SiparisDurumu.teslimEdildi:
        return 'Yazici kuyrugunda siparis kapanisa alindi';
      case SiparisDurumu.alindi:
      case SiparisDurumu.iptalEdildi:
        return '$hat hatti ile senkron tamamlandi';
    }
  }
}

enum _TeslimatFiltresi {
  tumu('Tum kanallar', null),
  salon('Salon', TeslimatTipi.restorandaYe),
  gelAl('Gel al', TeslimatTipi.gelAl),
  paket('Paket', TeslimatTipi.paketServis);

  const _TeslimatFiltresi(this.etiket, this.teslimatTipi);

  final String etiket;
  final TeslimatTipi? teslimatTipi;
}

class _MutfakNavigasyonSeridi extends StatelessWidget {
  const _MutfakNavigasyonSeridi({required this.mobil});

  final bool mobil;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF231A31),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Operasyon gecisleri',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.84),
              fontSize: mobil ? 16 : 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(RotaYapisi.pos);
                },
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  padding: EdgeInsets.symmetric(
                    horizontal: mobil ? 12 : 14,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.point_of_sale_rounded, size: 18),
                label: const Text('POS ekranina git'),
              ),
              FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(RotaYapisi.yonetimPaneli);
                },
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  padding: EdgeInsets.symmetric(
                    horizontal: mobil ? 12 : 14,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.dashboard_customize_rounded, size: 18),
                label: const Text('Yonetim paneli'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(RotaYapisi.anaSayfa);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  padding: EdgeInsets.symmetric(
                    horizontal: mobil ? 12 : 14,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.switch_account_rounded, size: 18),
                label: const Text('Rol secimine don'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MutfakYaziciSeridi extends StatelessWidget {
  const _MutfakYaziciSeridi({required this.yazicilar, required this.kuyruk});

  final List<YaziciDurumuVarligi> yazicilar;
  final List<YaziciIsKuyruguVarligi> kuyruk;

  @override
  Widget build(BuildContext context) {
    final int bagliYaziciSayisi = yazicilar.where((YaziciDurumuVarligi yazici) {
      return yazici.durum == YaziciBaglantiDurumu.bagli;
    }).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF231A31),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yazici senkronu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$bagliYaziciSayisi / ${yazicilar.length} yazici aktif. Mutfak durumu ve fis kuyrugu ayni alanda izleniyor.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: yazicilar.map((YaziciDurumuVarligi yazici) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: yazici.renk.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.print_rounded, size: 16, color: yazici.renk),
                        const SizedBox(width: 8),
                        Text(
                          '${yazici.rolEtiketi}: ${yazici.durumEtiketi}',
                          style: TextStyle(
                            color: yazici.renk,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (kuyruk.isEmpty)
            Text(
              'Su an yazici kuyrugunda bekleyen is yok.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: kuyruk.take(4).map((YaziciIsKuyruguVarligi isEmri) {
                return _YaziciKuyrukRozeti(isEmri: isEmri);
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _YaziciKuyrukRozeti extends StatelessWidget {
  const _YaziciKuyrukRozeti({required this.isEmri});

  final YaziciIsKuyruguVarligi isEmri;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 300),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    isEmri.siparisNo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  isEmri.durumEtiketi,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isEmri.yaziciRolu,
              style: const TextStyle(
                color: Color(0xFFFFD36E),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isEmri.kisaAciklama,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MutfakOzetSeridi extends StatelessWidget {
  const _MutfakOzetSeridi({required this.siparisler});

  final List<SiparisVarligi> siparisler;

  @override
  Widget build(BuildContext context) {
    final DateTime simdi = DateTime.now();
    final List<SiparisVarligi> aktifSiparisler = siparisler
        .where(
          (SiparisVarligi siparis) =>
              siparis.durum != SiparisDurumu.teslimEdildi &&
              siparis.durum != SiparisDurumu.iptalEdildi,
        )
        .toList();
    final List<SiparisVarligi> acilSiparisler = aktifSiparisler
        .where(
          (SiparisVarligi siparis) => _beklemeDakikasi(siparis, simdi) >= 20,
        )
        .toList();

    int toplamDakika = 0;
    for (final SiparisVarligi siparis in aktifSiparisler) {
      toplamDakika += _beklemeDakikasi(siparis, simdi);
    }
    final int ortalamaDakika = aktifSiparisler.isEmpty
        ? 0
        : (toplamDakika / aktifSiparisler.length).round();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _OzetKarti(
          baslik: 'Aktif is',
          deger: '${aktifSiparisler.length}',
          aciklama: 'Mutfak ve teslim kapanisinda bekleyen siparis',
          vurguRengi: const Color(0xFFFF8A5B),
        ),
        _OzetKarti(
          baslik: 'Acil hat',
          deger: '${acilSiparisler.length}',
          aciklama: '20 dakikayi gecen siparis',
          vurguRengi: const Color(0xFFFFC857),
        ),
        _OzetKarti(
          baslik: 'Ortalama sure',
          deger: '$ortalamaDakika dk',
          aciklama: 'Aktif siparislerde ortalama bekleme',
          vurguRengi: const Color(0xFF7BA7FF),
        ),
      ],
    );
  }
}

class _OzetKarti extends StatelessWidget {
  const _OzetKarti({
    required this.baslik,
    required this.deger,
    required this.aciklama,
    required this.vurguRengi,
  });

  final String baslik;
  final String deger;
  final String aciklama;
  final Color vurguRengi;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 280),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF231A31),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              baslik,
              style: TextStyle(
                color: vurguRengi,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              deger,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              aciklama,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.68),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeslimatFiltreSeridi extends StatelessWidget {
  const _TeslimatFiltreSeridi({
    required this.seciliFiltre,
    required this.filtreDegistir,
  });

  final _TeslimatFiltresi seciliFiltre;
  final ValueChanged<_TeslimatFiltresi> filtreDegistir;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _TeslimatFiltresi.values.map((_TeslimatFiltresi filtre) {
          final bool seciliMi = seciliFiltre == filtre;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilterChip(
              selected: seciliMi,
              label: Text(filtre.etiket),
              onSelected: (_) => filtreDegistir(filtre),
              labelStyle: TextStyle(
                color: seciliMi ? const Color(0xFF130F1D) : Colors.white,
                fontWeight: FontWeight.w800,
              ),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
              backgroundColor: Colors.white.withValues(alpha: 0.06),
              selectedColor: const Color(0xFFFFD36E),
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DurumKolonu extends StatelessWidget {
  const _DurumKolonu({
    required this.baslik,
    required this.aciklama,
    required this.bosDurumMetni,
    required this.vurguRengi,
    required this.siparisler,
    required this.aksiyonCalistir,
    this.yukseklik,
  });

  final String baslik;
  final String aciklama;
  final String bosDurumMetni;
  final Color vurguRengi;
  final List<SiparisVarligi> siparisler;
  final ValueChanged<SiparisVarligi> aksiyonCalistir;
  final double? yukseklik;

  @override
  Widget build(BuildContext context) {
    final Widget liste = siparisler.isEmpty
        ? Center(
            child: Text(
              bosDurumMetni,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : ListView.separated(
            itemCount: siparisler.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              final SiparisVarligi siparis = siparisler[index];
              return _MutfakSiparisKarti(
                siparis: siparis,
                vurguRengi: vurguRengi,
                aksiyonCalistir: () => aksiyonCalistir(siparis),
              );
            },
          );

    return Container(
      width: 318,
      height: yukseklik,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF231A31),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: TextStyle(
              color: vurguRengi,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            aciklama,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.68),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: vurguRengi.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${siparisler.length} siparis',
              style: TextStyle(color: vurguRengi, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(child: liste),
        ],
      ),
    );
  }
}

class _MutfakSiparisKarti extends StatelessWidget {
  const _MutfakSiparisKarti({
    required this.siparis,
    required this.vurguRengi,
    required this.aksiyonCalistir,
  });

  final SiparisVarligi siparis;
  final Color vurguRengi;
  final VoidCallback aksiyonCalistir;

  @override
  Widget build(BuildContext context) {
    final DateTime simdi = DateTime.now();
    final int beklemeDakikasi = _beklemeDakikasi(siparis, simdi);
    final Color sureRengi = _sureVurguRengi(beklemeDakikasi);
    final String? aksiyonEtiketi = _aksiyonEtiketi(siparis);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
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
                      siparis.siparisNo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _konumEtiketi(siparis),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: vurguRengi.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _teslimatEtiketi(siparis.teslimatTipi),
                      style: TextStyle(
                        color: vurguRengi,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: sureRengi.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$beklemeDakikasi dk',
                      style: TextStyle(
                        color: sureRengi,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.timelapse_rounded, color: sureRengi, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _sureAciklamasi(beklemeDakikasi),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.84),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...siparis.kalemler.map(
            (SiparisKalemiVarligi kalem) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${kalem.adet}x ${kalem.urunAdi}${kalem.secenekAdi != null ? ' / ${kalem.secenekAdi}' : ''}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (aksiyonEtiketi != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: aksiyonCalistir,
                style: FilledButton.styleFrom(
                  backgroundColor: vurguRengi,
                  foregroundColor: const Color(0xFF1A1322),
                ),
                child: Text(aksiyonEtiketi),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

int _beklemeDakikasi(SiparisVarligi siparis, DateTime simdi) {
  return simdi.difference(siparis.olusturmaTarihi).inMinutes.clamp(0, 9999);
}

String? _aksiyonEtiketi(SiparisVarligi siparis) {
  switch (siparis.durum) {
    case SiparisDurumu.alindi:
      return 'Hazirlamaya al';
    case SiparisDurumu.hazirlaniyor:
      return 'Hazir oldu';
    case SiparisDurumu.hazir:
      return siparis.teslimatTipi == TeslimatTipi.paketServis
          ? 'Kuryeye ver'
          : 'Teslim edildi';
    case SiparisDurumu.yolda:
      return 'Teslim edildi';
    case SiparisDurumu.teslimEdildi:
    case SiparisDurumu.iptalEdildi:
      return null;
  }
}

Color _sureVurguRengi(int dakika) {
  if (dakika >= 20) {
    return const Color(0xFFFF8A5B);
  }
  if (dakika >= 12) {
    return const Color(0xFFFFC857);
  }
  return const Color(0xFF30C48D);
}

String _sureAciklamasi(int dakika) {
  if (dakika >= 20) {
    return 'Mudahale gerekli, siparis gecikiyor';
  }
  if (dakika >= 12) {
    return 'Takipte tut, sure esigine yaklasiyor';
  }
  return 'Akis normal, mutfak temposu uygun';
}

String _teslimatEtiketi(TeslimatTipi teslimatTipi) {
  switch (teslimatTipi) {
    case TeslimatTipi.restorandaYe:
      return 'Salon';
    case TeslimatTipi.gelAl:
      return 'Gel al';
    case TeslimatTipi.paketServis:
      return 'Paket';
  }
}

String _durumEtiketi(SiparisDurumu durum) {
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

String _yaziciHattiEtiketi(SiparisVarligi siparis) {
  switch (siparis.teslimatTipi) {
    case TeslimatTipi.restorandaYe:
      return 'Mutfak';
    case TeslimatTipi.gelAl:
      return 'Kasa';
    case TeslimatTipi.paketServis:
      return 'Icecek';
  }
}

String _konumEtiketi(SiparisVarligi siparis) {
  if (siparis.masaNo != null && siparis.masaNo!.isNotEmpty) {
    return 'Masa ${siparis.masaNo} / ${siparis.bolumAdi ?? 'Salon'}';
  }
  if (siparis.adresMetni != null && siparis.adresMetni!.isNotEmpty) {
    return siparis.adresMetni!;
  }
  return 'Operasyon sirasi bekliyor';
}
