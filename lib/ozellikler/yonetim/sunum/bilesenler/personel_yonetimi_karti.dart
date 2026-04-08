import 'package:flutter/material.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';

class PersonelYonetimiKarti extends StatelessWidget {
  const PersonelYonetimiKarti({
    super.key,
    required this.personeller,
    this.personelEkle,
    this.personelSil,
  });

  final List<PersonelDurumuVarligi> personeller;
  final VoidCallback? personelEkle;
  final ValueChanged<PersonelDurumuVarligi>? personelSil;

  @override
  Widget build(BuildContext context) {
    final int aktifSayisi = personeller
        .where((personel) => personel.durum == PersonelDurumu.aktif)
        .length;

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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Garson ve personel',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF25192E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$aktifSayisi / ${personeller.length} kisi vardiyada. Salon dagilimi ve moladaki ekip buradan gorunur.',
                      style: const TextStyle(color: Color(0xFF7A6D86)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EAF9),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.group_outlined,
                          color: Color(0xFF7D5CFF),
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Vardiya listesi',
                          style: TextStyle(
                            color: Color(0xFF412454),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (personelEkle != null)
                    FilledButton.tonalIcon(
                      onPressed: personelEkle,
                      icon: const Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 18,
                      ),
                      label: const Text('Garson ekle'),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...personeller.map(
            (PersonelDurumuVarligi personel) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PersonelSatiri(
                personel: personel,
                personelSil: personelSil,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonelSatiri extends StatelessWidget {
  const _PersonelSatiri({required this.personel, this.personelSil});

  final PersonelDurumuVarligi personel;
  final ValueChanged<PersonelDurumuVarligi>? personelSil;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F4FB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDE4F2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: personel.renk.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  personel.kisaAd,
                  style: TextStyle(
                    color: personel.renk,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      personel.adSoyad,
                      style: const TextStyle(
                        color: Color(0xFF25192E),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${personel.rolEtiketi}  |  ${personel.bolge}',
                      style: const TextStyle(color: Color(0xFF7A6D86)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: personel.renk.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  personel.durumEtiketi,
                  style: TextStyle(
                    color: personel.renk,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  personel.aciklama,
                  style: const TextStyle(color: Color(0xFF61556E)),
                ),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${personel.adSoyad} icin vardiya notu acildi',
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF412454),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.edit_calendar_outlined, size: 18),
                label: const Text('Not'),
              ),
              if (personelSil != null && personel.silinebilirMi) ...[
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => personelSil!(personel),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFB3261E),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: const Text('Sil'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
