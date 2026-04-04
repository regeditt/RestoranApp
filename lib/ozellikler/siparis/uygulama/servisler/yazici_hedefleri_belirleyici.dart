import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';

abstract class YaziciHedefleriBelirleyici {
  const YaziciHedefleriBelirleyici();

  Set<String> hedefRolleri(SiparisVarligi siparis);
}

class VarsayilanYaziciHedefleriBelirleyici
    implements YaziciHedefleriBelirleyici {
  const VarsayilanYaziciHedefleriBelirleyici();

  @override
  Set<String> hedefRolleri(SiparisVarligi siparis) {
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
}
