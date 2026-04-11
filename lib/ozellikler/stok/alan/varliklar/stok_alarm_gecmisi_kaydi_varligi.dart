import 'package:restoran_app/ozellikler/stok/alan/enumlar/stok_uyari_durumu.dart';

class StokAlarmGecmisiKaydiVarligi {
  const StokAlarmGecmisiKaydiVarligi({
    required this.id,
    required this.zaman,
    required this.hammaddeId,
    required this.hammaddeAdi,
    required this.oncekiMiktar,
    required this.yeniMiktar,
    required this.oncekiDurum,
    required this.yeniDurum,
    required this.tetikleyenIslem,
  });

  final String id;
  final DateTime zaman;
  final String hammaddeId;
  final String hammaddeAdi;
  final double oncekiMiktar;
  final double yeniMiktar;
  final StokUyariDurumu oncekiDurum;
  final StokUyariDurumu yeniDurum;
  final String tetikleyenIslem;
}
