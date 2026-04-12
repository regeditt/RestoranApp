class MutfakOperasyonOzetiVarligi {
  const MutfakOperasyonOzetiVarligi({
    required this.toplamKalanDakika,
    required this.ortalamaKalanDakika,
    required this.gecikenSiparisSayisi,
    required this.siparisTahminleri,
    required this.gecikmeUyarilari,
    required this.istasyonYukleri,
  });

  final int toplamKalanDakika;
  final int ortalamaKalanDakika;
  final int gecikenSiparisSayisi;
  final Map<String, MutfakSiparisTahminiVarligi> siparisTahminleri;
  final List<MutfakGecikmeUyarisiVarligi> gecikmeUyarilari;
  final List<MutfakIstasyonYukuVarligi> istasyonYukleri;
}

class MutfakSiparisTahminiVarligi {
  const MutfakSiparisTahminiVarligi({
    required this.siparisId,
    required this.istasyonAdi,
    required this.hedefHazirlikDakikasi,
    required this.kalanDakika,
    required this.gecikmeDakikasi,
    required this.gecikiyorMu,
  });

  final String siparisId;
  final String istasyonAdi;
  final int hedefHazirlikDakikasi;
  final int kalanDakika;
  final int gecikmeDakikasi;
  final bool gecikiyorMu;
}

class MutfakGecikmeUyarisiVarligi {
  const MutfakGecikmeUyarisiVarligi({
    required this.siparisId,
    required this.siparisNo,
    required this.istasyonAdi,
    required this.gecikmeDakikasi,
  });

  final String siparisId;
  final String siparisNo;
  final String istasyonAdi;
  final int gecikmeDakikasi;
}

class MutfakIstasyonYukuVarligi {
  const MutfakIstasyonYukuVarligi({
    required this.istasyonAdi,
    required this.aktifSiparisSayisi,
    required this.toplamKalanDakika,
  });

  final String istasyonAdi;
  final int aktifSiparisSayisi;
  final int toplamKalanDakika;
}
