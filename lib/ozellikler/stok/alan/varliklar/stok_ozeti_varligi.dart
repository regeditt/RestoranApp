import 'package:restoran_app/ozellikler/stok/alan/enumlar/stok_uyari_durumu.dart';

class StokOzetiVarligi {
  const StokOzetiVarligi({
    required this.toplamStokDegeri,
    required this.alarmliMalzemeSayisi,
    required this.uyariMalzemeSayisi,
    required this.kritikMalzemeSayisi,
    required this.tukenenMalzemeSayisi,
    required this.toplamHammaddeSayisi,
    required this.kritikMalzemeler,
    required this.stokUyariKalemleri,
    required this.haftalikKritikAlarmOzetleri,
    required this.menuMaliyetleri,
  });

  final double toplamStokDegeri;
  final int alarmliMalzemeSayisi;
  final int uyariMalzemeSayisi;
  final int kritikMalzemeSayisi;
  final int tukenenMalzemeSayisi;
  final int toplamHammaddeSayisi;
  final List<KritikMalzemeVarligi> kritikMalzemeler;
  final List<StokUyariKalemiVarligi> stokUyariKalemleri;
  final List<HaftalikKritikAlarmOzetiVarligi> haftalikKritikAlarmOzetleri;
  final List<MenuMaliyetVarligi> menuMaliyetleri;
}

class KritikMalzemeVarligi {
  const KritikMalzemeVarligi({
    required this.ad,
    required this.kalanMiktarMetni,
    required this.uyariEtiketi,
    required this.aciliyetOrani,
  });

  final String ad;
  final String kalanMiktarMetni;
  final String uyariEtiketi;
  final double aciliyetOrani;
}

class StokUyariKalemiVarligi {
  const StokUyariKalemiVarligi({
    required this.ad,
    required this.kalanMiktarMetni,
    required this.uyariEtiketi,
    required this.aciliyetOrani,
    required this.durum,
  });

  final String ad;
  final String kalanMiktarMetni;
  final String uyariEtiketi;
  final double aciliyetOrani;
  final StokUyariDurumu durum;
}

class MenuMaliyetVarligi {
  const MenuMaliyetVarligi({
    required this.urunAdi,
    required this.satisFiyati,
    required this.receteMaliyeti,
    required this.karMarjiOrani,
    required this.uretilebilirAdet,
  });

  final String urunAdi;
  final double satisFiyati;
  final double receteMaliyeti;
  final double karMarjiOrani;
  final int uretilebilirAdet;
}

class HaftalikKritikAlarmOzetiVarligi {
  const HaftalikKritikAlarmOzetiVarligi({
    required this.hammaddeId,
    required this.hammaddeAdi,
    required this.alarmAdedi,
  });

  final String hammaddeId;
  final String hammaddeAdi;
  final int alarmAdedi;
}
