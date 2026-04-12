enum RezervasyonDurumu {
  beklemede('Beklemede'),
  onaylandi('Onaylandi'),
  geldi('Geldi'),
  tamamlandi('Tamamlandi'),
  noShow('No-show'),
  iptalEdildi('Iptal edildi');

  const RezervasyonDurumu(this.etiket);

  final String etiket;

  bool get aktifMi {
    switch (this) {
      case RezervasyonDurumu.beklemede:
      case RezervasyonDurumu.onaylandi:
      case RezervasyonDurumu.geldi:
        return true;
      case RezervasyonDurumu.tamamlandi:
      case RezervasyonDurumu.noShow:
      case RezervasyonDurumu.iptalEdildi:
        return false;
    }
  }
}
