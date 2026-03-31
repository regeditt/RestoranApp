import 'package:restoran_app/ortak/platform/yazici_cikti_platformu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/yazdirma_sonucu_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/uygulama/servisler/siparis_fisi_olusturucu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/depolar/yazici_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/yazici_durumu_varligi.dart';

class SiparisiYazdirUseCase {
  const SiparisiYazdirUseCase(this._yaziciDeposu);

  final YaziciDeposu _yaziciDeposu;

  Future<YazdirmaSonucuVarligi> call(SiparisVarligi siparis) async {
    final List<YaziciDurumuVarligi> yazicilar = await _yaziciDeposu
        .yazicilariGetir();
    final Set<String> hedefRoller = _hedefRolleriBelirle(siparis);

    final List<YaziciDurumuVarligi> hedefYazicilar = yazicilar.where((yazici) {
      final bool rolEslesiyor = hedefRoller.contains(yazici.rolEtiketi);
      final bool kullanilabilir =
          yazici.durum == YaziciBaglantiDurumu.bagli ||
          yazici.durum == YaziciBaglantiDurumu.dikkat;
      return rolEslesiyor && kullanilabilir;
    }).toList();

    if (hedefYazicilar.isEmpty) {
      return const YazdirmaSonucuVarligi(
        yaziciAdlari: <String>[],
        ozetMetni: 'Uygun yazici bulunamadi',
      );
    }

    final List<String> adlar = hedefYazicilar
        .map((yazici) => yazici.ad)
        .toList();
    final List<String> gercekYazicilar = <String>[];
    final List<String> kuyrukYazicilar = <String>[];

    for (final YaziciDurumuVarligi yazici in hedefYazicilar) {
      final bool brotherMi = yazici.ad.toLowerCase().contains('brother');
      if (brotherMi) {
        final bool basarili = await yaziciCiktiPlatformu.gonder(
          yaziciAdi: yazici.ad,
          icerik: SiparisFisiOlusturucu.olustur(
            siparis: siparis,
            yazici: yazici,
          ),
        );
        if (basarili) {
          gercekYazicilar.add(yazici.ad);
          continue;
        }
      }
      kuyrukYazicilar.add(yazici.ad);
    }

    return YazdirmaSonucuVarligi(
      yaziciAdlari: adlar,
      gercekYaziciAdlari: gercekYazicilar,
      kuyrukYaziciAdlari: kuyrukYazicilar,
      ozetMetni: _ozetMetniOlustur(
        gercekYazicilar: gercekYazicilar,
        kuyrukYazicilar: kuyrukYazicilar,
      ),
    );
  }

  Set<String> _hedefRolleriBelirle(SiparisVarligi siparis) {
    final Set<String> roller = <String>{'Kasa'};

    if (_mutfagaGitmeli(siparis)) {
      roller.add('Mutfak');
    }
    if (_icecekVarMi(siparis)) {
      roller.add('Icecek');
    }

    if (siparis.teslimatTipi == TeslimatTipi.paketServis) {
      roller.add('Icecek');
    }

    return roller;
  }

  bool _mutfagaGitmeli(SiparisVarligi siparis) {
    return siparis.kalemler.any((kalem) {
      final String ad = kalem.urunAdi.toLowerCase();
      return !ad.contains('limonata') &&
          !ad.contains('kola') &&
          !ad.contains('ayran') &&
          !ad.contains('soda') &&
          !ad.contains('icecek');
    });
  }

  bool _icecekVarMi(SiparisVarligi siparis) {
    return siparis.kalemler.any((kalem) {
      final String ad = kalem.urunAdi.toLowerCase();
      return ad.contains('limonata') ||
          ad.contains('kola') ||
          ad.contains('ayran') ||
          ad.contains('soda') ||
          ad.contains('icecek');
    });
  }

  String _ozetMetniOlustur({
    required List<String> gercekYazicilar,
    required List<String> kuyrukYazicilar,
  }) {
    final List<String> parcalar = <String>[];
    if (gercekYazicilar.isNotEmpty) {
      parcalar.add(
        '${gercekYazicilar.join(', ')} icin fiziksel cikti gonderildi',
      );
    }
    if (kuyrukYazicilar.isNotEmpty) {
      parcalar.add('${kuyrukYazicilar.join(', ')} icin cikti kuyruga alindi');
    }
    return parcalar.join('. ');
  }
}
