import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bilesenler/suruklenebilir_dialog_kapsayici.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

class PaketServisOperasyonKarti extends StatelessWidget {
  const PaketServisOperasyonKarti({super.key, required this.siparisler});

  final List<SiparisVarligi> siparisler;

  @override
  Widget build(BuildContext context) {
    final List<SiparisVarligi> paketSiparisleri =
        siparisler
            .where(
              (SiparisVarligi siparis) =>
                  siparis.teslimatTipi == TeslimatTipi.paketServis,
            )
            .toList()
          ..sort(
            (SiparisVarligi a, SiparisVarligi b) =>
                a.olusturmaTarihi.compareTo(b.olusturmaTarihi),
          );

    final List<SiparisVarligi> aktifPaketSiparisleri = paketSiparisleri
        .where(
          (SiparisVarligi siparis) =>
              siparis.durum != SiparisDurumu.teslimEdildi &&
              siparis.durum != SiparisDurumu.iptalEdildi,
        )
        .toList();
    final int yoldaSayisi = aktifPaketSiparisleri
        .where((SiparisVarligi siparis) => siparis.durum == SiparisDurumu.yolda)
        .length;
    final int kuryeBekleyenSayisi = aktifPaketSiparisleri
        .where((SiparisVarligi siparis) => siparis.durum == SiparisDurumu.hazir)
        .length;
    final int mutfaktaHazirlananSayisi = aktifPaketSiparisleri
        .where(
          (SiparisVarligi siparis) =>
              siparis.durum == SiparisDurumu.alindi ||
              siparis.durum == SiparisDurumu.hazirlaniyor,
        )
        .length;
    final SiparisVarligi? kritikSiparis = aktifPaketSiparisleri.isEmpty
        ? null
        : aktifPaketSiparisleri.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF251942), Color(0xFF3B2D7A), Color(0xFF4967BA)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Paket servis operasyonu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.tonalIcon(
                onPressed: () async {
                  await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return _PaketServisDetayDialog(
                        siparisler: paketSiparisleri,
                        aktifSiparisler: aktifPaketSiparisleri,
                      );
                    },
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.local_shipping_outlined),
                label: const Text('Detayi ac'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            aktifPaketSiparisleri.isEmpty
                ? 'Bugun aktif paket siparisi yok. Kanal sakin gorunuyor.'
                : '${aktifPaketSiparisleri.length} aktif paket siparisi var. Kurye cikisi ve teslim bekleyen hat ayni ekranda izleniyor.',
            style: const TextStyle(color: Color(0xFFE3E8FF), height: 1.45),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _OperasyonMetrikKutusu(
                  etiket: 'Aktif paket',
                  deger: '${aktifPaketSiparisleri.length}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _OperasyonMetrikKutusu(
                  etiket: 'Yolda',
                  deger: '$yoldaSayisi',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _OperasyonMetrikKutusu(
                  etiket: 'Kurye bekleyen',
                  deger: '$kuryeBekleyenSayisi',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _OperasyonMetrikKutusu(
                  etiket: 'Mutfakta',
                  deger: '$mutfaktaHazirlananSayisi',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              kritikSiparis == null
                  ? 'Yeni paket siparisi geldiginde adres, kurye ve teslim adimlari burada operasyon karari olarak gorunecek.'
                  : '${kritikSiparis.siparisNo} numarali siparis operasyon onceliginde. ${_siparisSahibiEtiketi(kritikSiparis)} icin ${_paketDurumOzeti(kritikSiparis)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (aktifPaketSiparisleri.isEmpty)
            const _PaketBilgiSatiri(
              ikon: Icons.local_shipping_outlined,
              baslik: 'Hat bos',
              aciklama: 'Paket kanalinda bekleyen operasyon yok.',
            )
          else
            ...aktifPaketSiparisleri
                .take(3)
                .map(
                  (SiparisVarligi siparis) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _PaketBilgiSatiri(
                      ikon: siparis.durum == SiparisDurumu.yolda
                          ? Icons.two_wheeler_rounded
                          : Icons.receipt_long_rounded,
                      baslik:
                          '${siparis.siparisNo} · ${_durumEtiketi(siparis.durum)}',
                      aciklama:
                          '${_siparisSahibiEtiketi(siparis)} · ${siparis.adresMetni ?? 'Adres bekleniyor'}',
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class _PaketServisDetayDialog extends StatelessWidget {
  const _PaketServisDetayDialog({
    required this.siparisler,
    required this.aktifSiparisler,
  });

  final List<SiparisVarligi> siparisler;
  final List<SiparisVarligi> aktifSiparisler;

  @override
  Widget build(BuildContext context) {
    return SuruklenebilirPopupSablonu(
      tutamacUstOfset: -2,
      maxGenislik: 860,
      maxYukseklik: 760,
      materialKullan: false,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF181224), Color(0xFF241A39)],
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paket hat detayi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Adres, kurye ve teslim notlari ile aktif paket akisini izleyin.',
                        style: TextStyle(color: Color(0xFFE3E8FF)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.10),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _PaketDurumRozeti(
                  etiket: 'Toplam paket',
                  deger: '${siparisler.length}',
                ),
                _PaketDurumRozeti(
                  etiket: 'Aktif',
                  deger: '${aktifSiparisler.length}',
                ),
                _PaketDurumRozeti(
                  etiket: 'Teslim edilen',
                  deger:
                      '${siparisler.where((SiparisVarligi siparis) => siparis.durum == SiparisDurumu.teslimEdildi).length}',
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: siparisler.isEmpty
                  ? const Center(
                      child: Text(
                        'Paket siparisi bulunamadi',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.separated(
                      itemCount: siparisler.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        final SiparisVarligi siparis = siparisler[index];
                        return _PaketSiparisDetaySatiri(siparis: siparis);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaketBilgiSatiri extends StatelessWidget {
  const _PaketBilgiSatiri({
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
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
                  style: const TextStyle(color: Color(0xFFE3E8FF), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaketDurumRozeti extends StatelessWidget {
  const _PaketDurumRozeti({required this.etiket, required this.deger});

  final String etiket;
  final String deger;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiket,
            style: const TextStyle(
              color: Color(0xFFE3E8FF),
              fontWeight: FontWeight.w600,
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

class _PaketSiparisDetaySatiri extends StatelessWidget {
  const _PaketSiparisDetaySatiri({required this.siparis});

  final SiparisVarligi siparis;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
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
                      '${siparis.siparisNo} · ${_siparisSahibiEtiketi(siparis)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _paketDurumOzeti(siparis),
                      style: const TextStyle(color: Color(0xFFE3E8FF)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _durumRengi(siparis.durum).withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _durumEtiketi(siparis.durum),
                  style: TextStyle(
                    color: _durumRengi(siparis.durum),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _PaketDetaySatiri(
            etiket: 'Adres',
            deger: siparis.adresMetni ?? 'Adres girilmemis',
          ),
          const SizedBox(height: 8),
          _PaketDetaySatiri(
            etiket: 'Kurye',
            deger: siparis.kuryeAdi ?? 'Kurye henuz atanmagan',
          ),
          if ((siparis.teslimatNotu ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            _PaketDetaySatiri(etiket: 'Not', deger: siparis.teslimatNotu!),
          ],
        ],
      ),
    );
  }
}

class _PaketDetaySatiri extends StatelessWidget {
  const _PaketDetaySatiri({required this.etiket, required this.deger});

  final String etiket;
  final String deger;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 56,
          child: Text(
            etiket,
            style: const TextStyle(
              color: Color(0xFFB9C2FF),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            deger,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _OperasyonMetrikKutusu extends StatelessWidget {
  const _OperasyonMetrikKutusu({required this.etiket, required this.deger});

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

Color _durumRengi(SiparisDurumu durum) {
  switch (durum) {
    case SiparisDurumu.alindi:
      return const Color(0xFF8B6DFF);
    case SiparisDurumu.hazirlaniyor:
      return const Color(0xFFFF7A59);
    case SiparisDurumu.hazir:
      return const Color(0xFF30C48D);
    case SiparisDurumu.yolda:
      return const Color(0xFF5B8CFF);
    case SiparisDurumu.teslimEdildi:
      return const Color(0xFF00A389);
    case SiparisDurumu.iptalEdildi:
      return const Color(0xFFE44857);
  }
}

String _siparisSahibiEtiketi(SiparisVarligi siparis) {
  final String? adSoyad = siparis.sahip.misafirBilgisi?.adSoyad;
  if (adSoyad != null && adSoyad.trim().isNotEmpty) {
    return adSoyad;
  }
  return 'Misafir';
}

String _paketDurumOzeti(SiparisVarligi siparis) {
  switch (siparis.durum) {
    case SiparisDurumu.alindi:
      return 'siparis mutfaga yeni dustu';
    case SiparisDurumu.hazirlaniyor:
      return 'siparis mutfakta hazirlaniyor';
    case SiparisDurumu.hazir:
      return 'siparis kurye cikisini bekliyor';
    case SiparisDurumu.yolda:
      return '${siparis.kuryeAdi ?? 'kurye'} teslimata cikti';
    case SiparisDurumu.teslimEdildi:
      return 'teslimat tamamlandi';
    case SiparisDurumu.iptalEdildi:
      return 'siparis iptal edildi';
  }
}
