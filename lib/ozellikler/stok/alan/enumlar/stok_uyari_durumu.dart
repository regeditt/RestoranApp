enum StokUyariDurumu { normal, uyari, kritik, tukendi }

extension StokUyariDurumuX on StokUyariDurumu {
  String get etiket {
    switch (this) {
      case StokUyariDurumu.normal:
        return 'Normal';
      case StokUyariDurumu.uyari:
        return 'Uyari';
      case StokUyariDurumu.kritik:
        return 'Kritik';
      case StokUyariDurumu.tukendi:
        return 'Tukendi';
    }
  }
}
