import 'package:restoran_app/ozellikler/siparis/alan/varliklar/kurye_takip_entegrasyon_varliklari.dart';

abstract class KuryeTakipSaglayicisi {
  KuryeTakipSaglayiciTuru get tur;

  KuryeSaglayiciTestSonucu baglantiTestEt(KuryeTakipSaglayiciVarligi saglayici);

  String takipKimligiUret({
    required KuryeTakipSaglayiciVarligi saglayici,
    required KuryeCihazEslesmesiVarligi eslesme,
  });
}
