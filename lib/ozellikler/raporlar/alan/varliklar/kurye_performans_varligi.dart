class KuryePerformansOzetiVarligi {
  const KuryePerformansOzetiVarligi({
    required this.toplamPaketSiparisi,
    required this.aktifPaketSiparisi,
    required this.teslimEdilenSiparisSayisi,
    required this.iptalEdilenSiparisSayisi,
    required this.yoldaSiparisSayisi,
    required this.kuryeBekleyenSiparisSayisi,
    required this.aktifKuryeSayisi,
    required this.teslimatBasariOrani,
    required this.ortalamaTeslimatSuresi,
    required this.kuryeBasinaTamamlananSiparis,
    required this.bolgeYogunlukleri,
    required this.kuryeSiralamasi,
  });

  final int toplamPaketSiparisi;
  final int aktifPaketSiparisi;
  final int teslimEdilenSiparisSayisi;
  final int iptalEdilenSiparisSayisi;
  final int yoldaSiparisSayisi;
  final int kuryeBekleyenSiparisSayisi;
  final int aktifKuryeSayisi;
  final double teslimatBasariOrani;
  final Duration ortalamaTeslimatSuresi;
  final double kuryeBasinaTamamlananSiparis;
  final List<KuryeBolgeYogunlukVarligi> bolgeYogunlukleri;
  final List<KuryePerformansSatiriVarligi> kuryeSiralamasi;
}

class KuryeBolgeYogunlukVarligi {
  const KuryeBolgeYogunlukVarligi({
    required this.bolgeEtiketi,
    required this.siparisSayisi,
    required this.yogunlukOrani,
  });

  final String bolgeEtiketi;
  final int siparisSayisi;
  final double yogunlukOrani;
}

class KuryePerformansSatiriVarligi {
  const KuryePerformansSatiriVarligi({
    required this.kuryeAdi,
    required this.aktifSiparisSayisi,
    required this.tamamlananSiparisSayisi,
    required this.iptalSiparisSayisi,
    required this.basariOrani,
    required this.ortalamaTeslimatSuresi,
  });

  final String kuryeAdi;
  final int aktifSiparisSayisi;
  final int tamamlananSiparisSayisi;
  final int iptalSiparisSayisi;
  final double basariOrani;
  final Duration ortalamaTeslimatSuresi;
}
