import 'package:flutter/material.dart';

class BilgiKarti extends StatelessWidget {
  const BilgiKarti({
    super.key,
    required this.baslik,
    required this.aciklama,
    required this.ikon,
    required this.vurgu,
  });

  final String baslik;
  final String aciklama;
  final IconData ikon;
  final Color vurgu;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, vurgu.withValues(alpha: 0.12)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE6DCCF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 30,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: vurgu.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(ikon, color: vurgu),
            ),
            const Spacer(),
            Text(baslik, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text(aciklama, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
