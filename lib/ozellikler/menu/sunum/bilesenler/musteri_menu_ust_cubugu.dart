import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/responsive/ekran_boyutu.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ozellikler/menu/alan/varliklar/qr_menu_baglami_varligi.dart';

class MusteriMenuUstCubugu extends StatelessWidget {
  const MusteriMenuUstCubugu({
    super.key,
    required this.seciliKategoriAdi,
    required this.qrModu,
    this.qrBaglami,
  });

  final String seciliKategoriAdi;
  final bool qrModu;
  final QrMenuBaglamiVarligi? qrBaglami;

  @override
  Widget build(BuildContext context) {
    final bool mobil =
        EkranBoyutu.mobil(context) || MediaQuery.sizeOf(context).width < 900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE53D6F), Color(0xFF6C2FD2), Color(0xFF32185A)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: mobil
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _solKisim(context, mobil),
                if (!qrModu) ...[
                  const SizedBox(height: 10),
                  _modulGecisleri(context, mobil: true),
                ],
                if (qrModu && qrBaglami?.rozetler.isNotEmpty == true) ...[
                  const SizedBox(height: 10),
                  QrRozetleri(rozetler: qrBaglami!.rozetler),
                ],
                const SizedBox(height: 12),
                _aramaKutusu(true),
              ],
            )
          : Row(
              children: [
                Expanded(child: _solKisim(context, mobil)),
                const SizedBox(width: 12),
                _DurumRozeti(
                  ikon: qrModu ? Icons.qr_code_2 : Icons.wifi,
                  etiket: qrModu ? 'QR menu' : 'Internet',
                ),
                const SizedBox(width: 10),
                const _DurumRozeti(ikon: Icons.dns, etiket: 'Server'),
                if (qrModu && qrBaglami?.rozetler.isNotEmpty == true) ...[
                  const SizedBox(width: 10),
                  QrRozetleri(rozetler: qrBaglami!.rozetler),
                ],
                const SizedBox(width: 10),
                _personelGirisiButonu(context),
                if (!qrModu) ...[
                  const SizedBox(width: 10),
                  _modulGecisleri(context),
                ],
                const SizedBox(width: 12),
                _aramaKutusu(false),
              ],
            ),
    );
  }

  Widget _solKisim(BuildContext context, bool mobil) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                      ),
                      splashRadius: 20,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${UygulamaSabitleri.restoranAdi} ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const TextSpan(
                          text: UygulamaSabitleri.markaEtiketi,
                          style: TextStyle(
                            color: Color(0xFFFFC8D9),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!mobil)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  qrModu ? Icons.qr_code_2_rounded : Icons.receipt_long,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  qrModu ? 'QR MENU' : 'SIPARIS',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        if (!mobil)
          Text(
            '${qrModu ? 'QR Menu' : UygulamaSabitleri.menuKirintiKoku}  /  $seciliKategoriAdi',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.84),
              fontWeight: FontWeight.w600,
            ),
          ),
        if (mobil) _personelGirisiButonu(context, kompakt: true),
      ],
    );
  }

  Widget _aramaKutusu(bool mobil) {
    return Container(
      width: mobil ? double.infinity : 180,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 18, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            'Ara',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.74),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _modulGecisleri(BuildContext context, {bool mobil = false}) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton.tonalIcon(
          onPressed: () {
            Navigator.of(
              context,
            ).pushReplacementNamed(RotaYapisi.yonetimPaneli);
          },
          style: FilledButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.white.withValues(alpha: 0.14),
            padding: EdgeInsets.symmetric(
              horizontal: mobil ? 12 : 14,
              vertical: 12,
            ),
          ),
          icon: const Icon(Icons.dashboard_customize_rounded, size: 18),
          label: const Text('Yonetim paneli'),
        ),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.of(
              context,
            ).pushReplacementNamed(RotaYapisi.personelGiris);
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
            padding: EdgeInsets.symmetric(
              horizontal: mobil ? 12 : 14,
              vertical: 12,
            ),
          ),
          icon: const Icon(Icons.switch_account_rounded, size: 18),
          label: const Text('Personel girisine don'),
        ),
      ],
    );
  }

  Widget _personelGirisiButonu(BuildContext context, {bool kompakt = false}) {
    return OutlinedButton.icon(
      onPressed: () {
        Navigator.of(context).pushNamed(RotaYapisi.personelGiris);
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        padding: EdgeInsets.symmetric(
          horizontal: kompakt ? 12 : 14,
          vertical: 12,
        ),
      ),
      icon: const Icon(Icons.badge_outlined, size: 18),
      label: const Text('Personel girisi'),
    );
  }
}

class QrBaglamDurumKarti extends StatelessWidget {
  const QrBaglamDurumKarti({super.key, required this.qrBaglami});

  final QrMenuBaglamiVarligi qrBaglami;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE1EC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.qr_code_2_rounded,
              color: Color(0xFFB23A68),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  qrBaglami.acilisBasligi,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  qrBaglami.acilisAciklamasi,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          QrRozetleri(rozetler: qrBaglami.rozetler),
        ],
      ),
    );
  }
}

class QrRozetleri extends StatelessWidget {
  const QrRozetleri({super.key, required this.rozetler});

  final List<String> rozetler;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: rozetler
          .map(
            (String rozet) =>
                _DurumRozeti(ikon: Icons.local_offer_outlined, etiket: rozet),
          )
          .toList(),
    );
  }
}

class _DurumRozeti extends StatelessWidget {
  const _DurumRozeti({required this.ikon, required this.etiket});

  final IconData ikon;
  final String etiket;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 14, color: const Color(0xFF6BF3A7)),
          const SizedBox(width: 6),
          Text(
            etiket,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
