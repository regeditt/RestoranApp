import 'package:flutter/material.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/stok/alan/enumlar/stok_uyari_durumu.dart';
import 'package:restoran_app/ozellikler/stok/alan/varliklar/stok_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/patron_raporu_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/saatlik_siparis_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/uygulama/servisler/yonetim_raporu_hesaplayici.dart';

class PatronRaporuKarti extends StatelessWidget {
  const PatronRaporuKarti({
    super.key,
    required this.siparisler,
    required this.saatlikVeriler,
  });

  final List<SiparisVarligi> siparisler;
  final List<SaatlikSiparisOzetiVarligi> saatlikVeriler;

  @override
  Widget build(BuildContext context) {
    final PatronRaporuOzetiVarligi rapor =
        YonetimRaporuHesaplayici.patronRaporunuHesapla(
          siparisler: siparisler,
          saatlikVeriler: saatlikVeriler,
        );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF102A43), Color(0xFF1D4D6D), Color(0xFF235E73)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patron raporu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            rapor.ozetMetni,
            style: const TextStyle(color: Color(0xFFD8EEF4), height: 1.45),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MetrikKutusu(
                  etiket: 'Ort. adisyon',
                  deger: _paraYaz(rapor.ortalamaAdisyon),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetrikKutusu(
                  etiket: 'Gun sonu projeksiyon',
                  deger: _paraYaz(rapor.tahminiGunSonuCiro),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _IcerikSatiri(
            ikon: Icons.workspace_premium_outlined,
            baslik: 'En guclu kanal',
            aciklama:
                '${rapor.enGucluKanalEtiketi} bugun ${rapor.enGucluKanalAdedi} siparis ile one cikiyor.',
          ),
          const SizedBox(height: 10),
          _IcerikSatiri(
            ikon: Icons.schedule_outlined,
            baslik: 'Zirve saat',
            aciklama:
                '${rapor.zirveSaatEtiketi} diliminde ${rapor.zirveSaatAdedi} siparis goruldu.',
          ),
          const SizedBox(height: 10),
          _IcerikSatiri(
            ikon: Icons.shopping_bag_outlined,
            baslik: 'En yuksek sepet',
            aciklama:
                '${rapor.enYuksekSiparisNo} numarali siparis ${_paraYaz(rapor.enYuksekSiparisTutari)} ile gunun zirvesi.',
          ),
        ],
      ),
    );
  }
}

class StokVeMaliyetKarti extends StatelessWidget {
  const StokVeMaliyetKarti({super.key, required this.ozet});

  final StokOzetiVarligi ozet;

  @override
  Widget build(BuildContext context) {
    final MenuMaliyetVarligi? enDusukMarjli = ozet.menuMaliyetleri.isEmpty
        ? null
        : ozet.menuMaliyetleri.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF113127), Color(0xFF1D4B3C), Color(0xFF275E4B)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stok ve maliyet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${ozet.toplamHammaddeSayisi} hammadde izleniyor. '
            '${ozet.alarmliMalzemeSayisi} kalem alarm seviyesinde.',
            style: const TextStyle(color: Color(0xFFDDF4EA), height: 1.45),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MetrikKutusu(
                  etiket: 'Stok degeri',
                  deger: _paraYaz(ozet.toplamStokDegeri),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetrikKutusu(
                  etiket: 'Alarmli kalem',
                  deger: '${ozet.alarmliMalzemeSayisi}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StokDurumRozeti(
                etiket: 'Uyari ${ozet.uyariMalzemeSayisi}',
                renk: const Color(0xFFFFE6A6),
                yaziRengi: const Color(0xFF684B00),
              ),
              _StokDurumRozeti(
                etiket: 'Kritik ${ozet.kritikMalzemeSayisi}',
                renk: const Color(0xFFFFC1B4),
                yaziRengi: const Color(0xFF7C220C),
              ),
              _StokDurumRozeti(
                etiket: 'Tukendi ${ozet.tukenenMalzemeSayisi}',
                renk: const Color(0xFFFFA694),
                yaziRengi: const Color(0xFF6E1400),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (ozet.stokUyariKalemleri.isNotEmpty) ...[
            const Text(
              'Stok uyarilari',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            ...ozet.stokUyariKalemleri.map(
              (StokUyariKalemiVarligi malzeme) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _StokUyariSatiri(malzeme: malzeme),
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (enDusukMarjli != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Marj takibi',
                    style: TextStyle(
                      color: Color(0xFFDDF4EA),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${enDusukMarjli.urunAdi} icin recete maliyeti ${_paraYaz(enDusukMarjli.receteMaliyeti)}. Tahmini marj %${enDusukMarjli.karMarjiOrani.toStringAsFixed(0)}. Mevcut stokla yaklasik ${enDusukMarjli.uretilebilirAdet} adet cikabilir.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          if (ozet.haftalikKritikAlarmOzetleri.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Haftalik kritik alarm ilk 10',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...ozet.haftalikKritikAlarmOzetleri.map(
                    (HaftalikKritikAlarmOzetiVarligi kayit) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              kayit.hammaddeAdi,
                              style: const TextStyle(
                                color: Color(0xFFEAFEF2),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${kayit.alarmAdedi} kez',
                            style: const TextStyle(
                              color: Color(0xFFDDF4EA),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StokUyariSatiri extends StatelessWidget {
  const _StokUyariSatiri({required this.malzeme});

  final StokUyariKalemiVarligi malzeme;

  @override
  Widget build(BuildContext context) {
    final ({Color vurgu, Color zemin}) renkler = _durumRenkleri(malzeme.durum);
    final Color vurguRengi = renkler.vurgu;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: renkler.zemin,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: vurguRengi.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Icon(Icons.inventory_2_outlined, color: vurguRengi),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  malzeme.ad,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  malzeme.uyariEtiketi,
                  style: TextStyle(
                    color: vurguRengi,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              malzeme.kalanMiktarMetni,
              style: TextStyle(
                color: const Color(0xFFEAFEF2),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ({Color vurgu, Color zemin}) _durumRenkleri(StokUyariDurumu durum) {
    switch (durum) {
      case StokUyariDurumu.tukendi:
        return (
          vurgu: const Color(0xFFFFA694),
          zemin: Colors.white.withValues(alpha: 0.20),
        );
      case StokUyariDurumu.kritik:
        return (
          vurgu: const Color(0xFFFFC1B4),
          zemin: Colors.white.withValues(alpha: 0.16),
        );
      case StokUyariDurumu.uyari:
        return (
          vurgu: const Color(0xFFFFE6A6),
          zemin: Colors.white.withValues(alpha: 0.10),
        );
      case StokUyariDurumu.normal:
        return (
          vurgu: const Color(0xFFDDF4EA),
          zemin: Colors.white.withValues(alpha: 0.08),
        );
    }
  }
}

class _StokDurumRozeti extends StatelessWidget {
  const _StokDurumRozeti({
    required this.etiket,
    required this.renk,
    required this.yaziRengi,
  });

  final String etiket;
  final Color renk;
  final Color yaziRengi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: renk,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        etiket,
        style: TextStyle(
          color: yaziRengi,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _MetrikKutusu extends StatelessWidget {
  const _MetrikKutusu({required this.etiket, required this.deger});

  final String etiket;
  final String deger;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiket,
            style: const TextStyle(
              color: Color(0xFFD8EEF4),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            deger,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _IcerikSatiri extends StatelessWidget {
  const _IcerikSatiri({
    required this.ikon,
    required this.baslik,
    required this.aciklama,
  });

  final IconData ikon;
  final String baslik;
  final String aciklama;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(ikon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baslik,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  aciklama,
                  style: const TextStyle(color: Color(0xFFD8EEF4), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _paraYaz(double tutar) {
  final String tamSayi = tutar.toStringAsFixed(2).replaceAll('.', ',');
  return '$tamSayi TL';
}
