import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/saatlik_siparis_ozeti_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yonetim_paneli_ozeti_varligi.dart';

class KanalDagilimiKarti extends StatelessWidget {
  const KanalDagilimiKarti({super.key, required this.ozet});

  final YonetimPaneliOzetiVarligi ozet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kanal dagilimi',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: const Color(0xFF25192E)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Siparislerin hangi kanal uzerinden geldigini anlik izleyin.',
            style: TextStyle(color: Color(0xFF7A6D86)),
          ),
          const SizedBox(height: 18),
          SizedBox(height: 220, child: _KanalDagilimiGrafik(ozet: ozet)),
          const SizedBox(height: 18),
          _KanalSatiri(
            etiket: 'Restoranda ye',
            sayi: ozet.restorandaYeSayisi,
            renk: const Color(0xFFFF7A59),
          ),
          const SizedBox(height: 10),
          _KanalSatiri(
            etiket: 'Gel al',
            sayi: ozet.gelAlSayisi,
            renk: const Color(0xFF5B8CFF),
          ),
          const SizedBox(height: 10),
          _KanalSatiri(
            etiket: 'Paket servis',
            sayi: ozet.paketServisSayisi,
            renk: const Color(0xFF30C48D),
          ),
        ],
      ),
    );
  }
}

class SaatlikTrendKarti extends StatelessWidget {
  const SaatlikTrendKarti({super.key, required this.veriler});

  final List<SaatlikSiparisOzetiVarligi> veriler;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saatlik siparis trendi',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: const Color(0xFF25192E)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Son saatlerdeki siparis yogunlugunun mini ozeti.',
            style: TextStyle(color: Color(0xFF7A6D86)),
          ),
          const SizedBox(height: 18),
          SizedBox(height: 220, child: _SaatlikTrendGrafik(veriler: veriler)),
        ],
      ),
    );
  }
}

class _KanalSatiri extends StatelessWidget {
  const _KanalSatiri({
    required this.etiket,
    required this.sayi,
    required this.renk,
  });

  final String etiket;
  final int sayi;
  final Color renk;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            etiket,
            style: const TextStyle(
              color: Color(0xFF5D5366),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: renk.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$sayi',
            style: TextStyle(color: renk, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _KanalDagilimiGrafik extends StatefulWidget {
  const _KanalDagilimiGrafik({required this.ozet});

  final YonetimPaneliOzetiVarligi ozet;

  @override
  State<_KanalDagilimiGrafik> createState() => _KanalDagilimiGrafikState();
}

class _KanalDagilimiGrafikState extends State<_KanalDagilimiGrafik> {
  int _dokunulanIndex = -1;

  @override
  Widget build(BuildContext context) {
    final List<_KanalVeri> veriler = <_KanalVeri>[
      _KanalVeri(
        etiket: 'Restoranda ye',
        deger: widget.ozet.restorandaYeSayisi.toDouble(),
        renk: const Color(0xFFFF7A59),
      ),
      _KanalVeri(
        etiket: 'Gel al',
        deger: widget.ozet.gelAlSayisi.toDouble(),
        renk: const Color(0xFF5B8CFF),
      ),
      _KanalVeri(
        etiket: 'Paket servis',
        deger: widget.ozet.paketServisSayisi.toDouble(),
        renk: const Color(0xFF30C48D),
      ),
    ];

    final double toplam = veriler.fold<double>(
      0,
      (double onceki, _KanalVeri veri) => onceki + veri.deger,
    );

    return Row(
      children: [
        Expanded(
          flex: 6,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      _dokunulanIndex = -1;
                    } else {
                      _dokunulanIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    }
                  });
                },
              ),
              sectionsSpace: 3,
              centerSpaceRadius: 42,
              startDegreeOffset: -90,
              sections: veriler.asMap().entries.map((entry) {
                final int index = entry.key;
                final _KanalVeri veri = entry.value;
                final bool secili = index == _dokunulanIndex;

                return PieChartSectionData(
                  value: veri.deger <= 0 ? 0.01 : veri.deger,
                  color: veri.renk,
                  radius: secili ? 50 : 42,
                  title: toplam == 0
                      ? '0%'
                      : '%${((veri.deger / toplam) * 100).round()}',
                  badgeWidget: secili
                      ? _KanalGrafikRozeti(
                          etiket: veri.etiket,
                          sayi: veri.deger.toInt(),
                        )
                      : null,
                  badgePositionPercentageOffset: 1.28,
                  titleStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: secili ? 12 : 11,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: veriler
                .map(
                  (_KanalVeri veri) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _KanalLejantSatiri(
                      veri: veri,
                      toplam: toplam,
                      seciliMi: veriler.indexOf(veri) == _dokunulanIndex,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _KanalVeri {
  const _KanalVeri({
    required this.etiket,
    required this.deger,
    required this.renk,
  });

  final String etiket;
  final double deger;
  final Color renk;
}

class _KanalLejantSatiri extends StatelessWidget {
  const _KanalLejantSatiri({
    required this.veri,
    required this.toplam,
    this.seciliMi = false,
  });

  final _KanalVeri veri;
  final double toplam;
  final bool seciliMi;

  @override
  Widget build(BuildContext context) {
    final int oran = toplam == 0 ? 0 : ((veri.deger / toplam) * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: veri.renk.withValues(alpha: seciliMi ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(16),
        border: seciliMi
            ? Border.all(color: veri.renk.withValues(alpha: 0.35))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: veri.renk, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  veri.etiket,
                  style: const TextStyle(
                    color: Color(0xFF25192E),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${veri.deger.toInt()} siparis  -  %$oran',
                  style: const TextStyle(
                    color: Color(0xFF7A6D86),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KanalGrafikRozeti extends StatelessWidget {
  const _KanalGrafikRozeti({required this.etiket, required this.sayi});

  final String etiket;
  final int sayi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF25192E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        '$etiket: $sayi',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SaatlikTrendGrafik extends StatelessWidget {
  const _SaatlikTrendGrafik({required this.veriler});

  final List<SaatlikSiparisOzetiVarligi> veriler;

  @override
  Widget build(BuildContext context) {
    final double enYuksek = veriler.isEmpty
        ? 1
        : veriler
                  .map((veri) => veri.adet.toDouble())
                  .reduce((a, b) => a > b ? a : b) +
              1;

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: enYuksek,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: Color(0xFFECE4F2), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, _) => Text(
                value.toInt().toString(),
                style: const TextStyle(color: Color(0xFF8B7D98), fontSize: 11),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, _) {
                final int index = value.toInt();
                if (index < 0 || index >= veriler.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    veriler[index].etiket,
                    style: const TextStyle(
                      color: Color(0xFF8B7D98),
                      fontSize: 11,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Color(0xFFE0D7E8)),
            bottom: BorderSide(color: Color(0xFFE0D7E8)),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: const Color(0xFF7D5CFF),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, barData, index, chartData) =>
                  FlDotCirclePainter(
                    radius: 4,
                    color: const Color(0xFFFF5D8F),
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF7D5CFF).withValues(alpha: 0.28),
                  const Color(0xFF7D5CFF).withValues(alpha: 0.02),
                ],
              ),
            ),
            spots: veriler
                .asMap()
                .entries
                .map(
                  (entry) =>
                      FlSpot(entry.key.toDouble(), entry.value.adet.toDouble()),
                )
                .toList(),
          ),
        ],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF25192E),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((LineBarSpot spot) {
                final int index = spot.x.toInt();
                final String etiket = index >= 0 && index < veriler.length
                    ? veriler[index].etiket
                    : '';
                return LineTooltipItem(
                  '$etiket\n${spot.y.toInt()} siparis',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
