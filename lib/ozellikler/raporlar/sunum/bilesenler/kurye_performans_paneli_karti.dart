import 'package:flutter/material.dart';
import 'package:restoran_app/ozellikler/raporlar/alan/varliklar/kurye_performans_varligi.dart';
import 'package:restoran_app/ozellikler/raporlar/uygulama/servisler/kurye_performans_hesaplayici.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

class KuryePerformansPaneliKarti extends StatelessWidget {
  const KuryePerformansPaneliKarti({
    super.key,
    required this.siparisler,
    this.simdi,
  });

  final List<SiparisVarligi> siparisler;
  final DateTime? simdi;

  @override
  Widget build(BuildContext context) {
    final KuryePerformansOzetiVarligi ozet =
        KuryePerformansHesaplayici.ozetHesapla(
          siparisler: siparisler,
          simdi: simdi,
        );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF3E1E4A),
            Color(0xFF5B2D55),
            Color(0xFF7D3C5D),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Kurye performans paneli',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Teslimat hizi, bolge yogunlugu ve kurye bazli basariyi tek kartta izle.',
            style: TextStyle(color: Color(0xFFFFE7EF), height: 1.45),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              _MetrikRozeti(
                etiket: 'Toplam paket',
                deger: '${ozet.toplamPaketSiparisi}',
              ),
              _MetrikRozeti(
                etiket: 'Aktif',
                deger: '${ozet.aktifPaketSiparisi}',
              ),
              _MetrikRozeti(
                etiket: 'Basari orani',
                deger:
                    '%${(ozet.teslimatBasariOrani * 100).toStringAsFixed(1)}',
              ),
              _MetrikRozeti(
                etiket: 'Ort. teslimat',
                deger: _sureYaz(ozet.ortalamaTeslimatSuresi),
              ),
              _MetrikRozeti(
                etiket: 'Aktif kurye',
                deger: '${ozet.aktifKuryeSayisi}',
              ),
              _MetrikRozeti(
                etiket: 'Kurye basina tamamlanan',
                deger: ozet.kuryeBasinaTamamlananSiparis.toStringAsFixed(1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _BaslikSatiri(
            ikon: Icons.location_on_rounded,
            baslik: 'Bolge bazli yogunluk',
          ),
          const SizedBox(height: 10),
          if (ozet.bolgeYogunlukleri.isEmpty)
            const _BilgiMetni(
              'Aktif paket siparisi olmadigi icin bolge yogunlugu olusmadi.',
            )
          else
            ...ozet.bolgeYogunlukleri
                .take(4)
                .map(
                  (KuryeBolgeYogunlukVarligi bolge) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _BolgeSatiri(veri: bolge),
                  ),
                ),
          const SizedBox(height: 14),
          _BaslikSatiri(
            ikon: Icons.emoji_events_rounded,
            baslik: 'Kurye bazli performans',
          ),
          const SizedBox(height: 10),
          if (ozet.kuryeSiralamasi.isEmpty)
            const _BilgiMetni(
              'Kurye performansi icin henuz paket siparisi olusmadi.',
            )
          else
            ...ozet.kuryeSiralamasi
                .take(4)
                .map(
                  (KuryePerformansSatiriVarligi satir) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _KuryeSatiri(veri: satir),
                  ),
                ),
        ],
      ),
    );
  }

  String _sureYaz(Duration sure) {
    if (sure == Duration.zero) {
      return '-';
    }
    final int saat = sure.inHours;
    final int dakika = sure.inMinutes % 60;
    if (saat > 0) {
      return '${saat}s ${dakika}dk';
    }
    return '${sure.inMinutes}dk';
  }
}

class _MetrikRozeti extends StatelessWidget {
  const _MetrikRozeti({required this.etiket, required this.deger});

  final String etiket;
  final String deger;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            etiket,
            style: const TextStyle(
              color: Color(0xFFFFDCE8),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            deger,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _BaslikSatiri extends StatelessWidget {
  const _BaslikSatiri({required this.ikon, required this.baslik});

  final IconData ikon;
  final String baslik;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(ikon, color: const Color(0xFFFFD8E5), size: 18),
        const SizedBox(width: 8),
        Text(
          baslik,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _BilgiMetni extends StatelessWidget {
  const _BilgiMetni(this.metin);

  final String metin;

  @override
  Widget build(BuildContext context) {
    return Text(
      metin,
      style: const TextStyle(color: Color(0xFFFFDFEA), height: 1.4),
    );
  }
}

class _BolgeSatiri extends StatelessWidget {
  const _BolgeSatiri({required this.veri});

  final KuryeBolgeYogunlukVarligi veri;

  @override
  Widget build(BuildContext context) {
    final double oran = veri.yogunlukOrani.clamp(0, 1);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  veri.bolgeEtiketi,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${veri.siparisSayisi} siparis',
                style: const TextStyle(
                  color: Color(0xFFFFD6E5),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: oran,
            minHeight: 7,
            borderRadius: BorderRadius.circular(999),
            backgroundColor: const Color(0xFFFFEDF3).withValues(alpha: 0.22),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF91B4)),
          ),
        ],
      ),
    );
  }
}

class _KuryeSatiri extends StatelessWidget {
  const _KuryeSatiri({required this.veri});

  final KuryePerformansSatiriVarligi veri;

  @override
  Widget build(BuildContext context) {
    final String basariYuzdesi =
        '%${(veri.basariOrani * 100).toStringAsFixed(0)}';
    final int dakika = veri.ortalamaTeslimatSuresi.inMinutes;
    final String sureMetni = dakika <= 0 ? '-' : '${dakika}dk';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              veri.kuryeAdi,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _KucukDeger(
            etiket: 'Tamam',
            deger: '${veri.tamamlananSiparisSayisi}',
          ),
          _KucukDeger(etiket: 'Iptal', deger: '${veri.iptalSiparisSayisi}'),
          _KucukDeger(etiket: 'Aktif', deger: '${veri.aktifSiparisSayisi}'),
          _KucukDeger(etiket: 'Basari', deger: basariYuzdesi),
          _KucukDeger(etiket: 'Ort.', deger: sureMetni),
        ],
      ),
    );
  }
}

class _KucukDeger extends StatelessWidget {
  const _KucukDeger({required this.etiket, required this.deger});

  final String etiket;
  final String deger;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            etiket,
            style: const TextStyle(color: Color(0xFFFFD6E5), fontSize: 11),
          ),
          const SizedBox(height: 2),
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
}
