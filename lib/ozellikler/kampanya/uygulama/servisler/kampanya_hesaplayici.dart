import 'package:restoran_app/ozellikler/kampanya/alan/varliklar/kampanya_hesap_sonucu_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';

class KampanyaHesaplayici {
  const KampanyaHesaplayici();

  KampanyaHesapSonucuVarligi hesapla(SepetVarligi sepet, {DateTime? simdi}) {
    final String? kupon = sepet.kuponKodu?.trim().toUpperCase();
    if (kupon == null || kupon.isEmpty) {
      return KampanyaHesapSonucuVarligi.bos;
    }

    final double araToplam = sepet.araToplam;
    if (araToplam <= 0) {
      return const KampanyaHesapSonucuVarligi(
        uygulandiMi: false,
        kuponKodu: null,
        indirimTutari: 0,
        aciklama: 'Kupon uygulanmadi',
        hataMesaji: 'Bos sepete kupon uygulanamaz.',
      );
    }

    switch (kupon) {
      case 'HOSGELDIN50':
        if (araToplam < 300) {
          return const KampanyaHesapSonucuVarligi(
            uygulandiMi: false,
            kuponKodu: 'HOSGELDIN50',
            indirimTutari: 0,
            aciklama: '50 TL hosgeldin indirimi',
            hataMesaji: 'Bu kupon icin en az 300 TL sepet tutari gerekli.',
          );
        }
        return _sonuc(
          kuponKodu: kupon,
          indirimTutari: 50,
          aciklama: '50 TL hosgeldin indirimi uygulandi',
          araToplam: araToplam,
        );
      case 'YUZDE10':
        if (araToplam < 250) {
          return const KampanyaHesapSonucuVarligi(
            uygulandiMi: false,
            kuponKodu: 'YUZDE10',
            indirimTutari: 0,
            aciklama: '%10 kupon indirimi',
            hataMesaji: 'Bu kupon icin en az 250 TL sepet tutari gerekli.',
          );
        }
        return _sonuc(
          kuponKodu: kupon,
          indirimTutari: araToplam * 0.10,
          aciklama: '%10 kupon indirimi uygulandi',
          araToplam: araToplam,
        );
      case 'IKIALBIR':
        final double indirim = _ikiAlBirOdeIndirimiHesapla(sepet.kalemler);
        if (indirim <= 0) {
          return const KampanyaHesapSonucuVarligi(
            uygulandiMi: false,
            kuponKodu: 'IKIALBIR',
            indirimTutari: 0,
            aciklama: '2 al 1 ode kampanyasi',
            hataMesaji: 'Bu kupon icin ayni urunden en az 3 adet olmali.',
          );
        }
        return _sonuc(
          kuponKodu: kupon,
          indirimTutari: indirim,
          aciklama: '2 al 1 ode kampanyasi uygulandi',
          araToplam: araToplam,
        );
      case 'HAFTAICI15':
        final DateTime tarih = simdi ?? DateTime.now();
        if (tarih.weekday == DateTime.saturday ||
            tarih.weekday == DateTime.sunday) {
          return const KampanyaHesapSonucuVarligi(
            uygulandiMi: false,
            kuponKodu: 'HAFTAICI15',
            indirimTutari: 0,
            aciklama: 'Hafta ici %15 kampanya',
            hataMesaji: 'Bu kupon sadece hafta ici gecerli.',
          );
        }
        if (araToplam < 200) {
          return const KampanyaHesapSonucuVarligi(
            uygulandiMi: false,
            kuponKodu: 'HAFTAICI15',
            indirimTutari: 0,
            aciklama: 'Hafta ici %15 kampanya',
            hataMesaji: 'Bu kupon icin en az 200 TL sepet tutari gerekli.',
          );
        }
        return _sonuc(
          kuponKodu: kupon,
          indirimTutari: araToplam * 0.15,
          aciklama: 'Hafta ici %15 kampanya uygulandi',
          araToplam: araToplam,
        );
      default:
        return KampanyaHesapSonucuVarligi(
          uygulandiMi: false,
          kuponKodu: kupon,
          indirimTutari: 0,
          aciklama: 'Kupon uygulanmadi',
          hataMesaji: 'Kupon kodu taninmadi.',
        );
    }
  }

  KampanyaHesapSonucuVarligi _sonuc({
    required String kuponKodu,
    required double indirimTutari,
    required String aciklama,
    required double araToplam,
  }) {
    final double netIndirim = indirimTutari.clamp(0, araToplam).toDouble();
    return KampanyaHesapSonucuVarligi(
      uygulandiMi: netIndirim > 0,
      kuponKodu: kuponKodu,
      indirimTutari: double.parse(netIndirim.toStringAsFixed(2)),
      aciklama: aciklama,
      hataMesaji: null,
    );
  }

  double _ikiAlBirOdeIndirimiHesapla(List<SepetKalemiVarligi> kalemler) {
    double toplamIndirim = 0;
    for (final SepetKalemiVarligi kalem in kalemler) {
      if (kalem.adet < 3) {
        continue;
      }
      final int bedavaAdet = kalem.adet ~/ 3;
      toplamIndirim += bedavaAdet * kalem.birimFiyat;
    }
    return toplamIndirim;
  }
}
