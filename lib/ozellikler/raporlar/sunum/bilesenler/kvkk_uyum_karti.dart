import 'package:flutter/material.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

class KvkkUyumKarti extends StatelessWidget {
  const KvkkUyumKarti({super.key, required this.siparisler});

  final List<SiparisVarligi> siparisler;

  @override
  Widget build(BuildContext context) {
    final int toplamSiparis = siparisler.length;
    final int aydinlatmaOnayli = siparisler
        .where((SiparisVarligi siparis) => siparis.aydinlatmaOnayi)
        .length;
    final int iletisimIzinli = siparisler
        .where((SiparisVarligi siparis) => siparis.ticariIletisimOnayi)
        .length;
    final int tamUyumlu = siparisler
        .where(
          (SiparisVarligi siparis) =>
              siparis.aydinlatmaOnayi && siparis.ticariIletisimOnayi,
        )
        .length;
    final int aydinlatmaEksik = toplamSiparis - aydinlatmaOnayli;
    final double aydinlatmaOrani = _oranHesapla(
      aydinlatmaOnayli,
      toplamSiparis,
    );
    final double iletisimOrani = _oranHesapla(iletisimIzinli, toplamSiparis);
    final double tamUyumOrani = _oranHesapla(tamUyumlu, toplamSiparis);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF0F3C36),
            Color(0xFF1C6B5A),
            Color(0xFF2F8A66),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'KVKK uyum',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            toplamSiparis == 0
                ? 'Secili filtrede siparis yok. KVKK uyum metrigi olusmadi.'
                : '$aydinlatmaOnayli/$toplamSiparis sipariste KVKK aydinlatma onayi var. $tamUyumlu sipariste tam uyum goruluyor.',
            style: const TextStyle(color: Color(0xFFD6F8EE), height: 1.45),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              _UyumMetrikRozeti(
                etiket: 'Toplam siparis',
                deger: '$toplamSiparis',
              ),
              _UyumMetrikRozeti(
                etiket: 'KVKK onayli',
                deger: '$aydinlatmaOnayli',
              ),
              _UyumMetrikRozeti(
                etiket: 'Iletisim izinli',
                deger: '$iletisimIzinli',
              ),
              _UyumMetrikRozeti(etiket: 'Tam uyum', deger: '$tamUyumlu'),
            ],
          ),
          const SizedBox(height: 16),
          _OranSatiri(
            etiket: 'Aydinlatma onayi',
            oran: aydinlatmaOrani,
            renk: const Color(0xFF86FFCF),
          ),
          const SizedBox(height: 10),
          _OranSatiri(
            etiket: 'Ticari iletisim izni',
            oran: iletisimOrani,
            renk: const Color(0xFFB8FFD9),
          ),
          const SizedBox(height: 10),
          _OranSatiri(
            etiket: 'Tam uyum orani',
            oran: tamUyumOrani,
            renk: const Color(0xFFE5FFB7),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              aydinlatmaEksik == 0
                  ? 'Tum siparislerde KVKK aydinlatma onayi mevcut. Uyum riski gorunmuyor.'
                  : '$aydinlatmaEksik sipariste KVKK aydinlatma onayi eksik. Kampanya ve iletisim akislari oncesinde onay adimini guclendirin.',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _oranHesapla(int pay, int payda) {
    if (payda == 0) {
      return 0;
    }
    return pay / payda;
  }
}

class _UyumMetrikRozeti extends StatelessWidget {
  const _UyumMetrikRozeti({required this.etiket, required this.deger});

  final String etiket;
  final String deger;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            etiket,
            style: const TextStyle(
              color: Color(0xFFD9FFF0),
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

class _OranSatiri extends StatelessWidget {
  const _OranSatiri({
    required this.etiket,
    required this.oran,
    required this.renk,
  });

  final String etiket;
  final double oran;
  final Color renk;

  @override
  Widget build(BuildContext context) {
    final double normalizeOran = oran.clamp(0, 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                etiket,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '%${(normalizeOran * 100).toStringAsFixed(0)}',
              style: const TextStyle(
                color: Color(0xFFE8FFF5),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: normalizeOran,
          minHeight: 8,
          borderRadius: BorderRadius.circular(999),
          backgroundColor: Colors.white.withValues(alpha: 0.20),
          valueColor: AlwaysStoppedAnimation<Color>(renk),
        ),
      ],
    );
  }
}
