enum KuryeTakipSaglayiciTuru {
  dahiliGps,
  traccar,
  navixy,
  ozelApi,
  turkSaglayici1,
  turkSaglayici2,
  turkSaglayici3,
  turkSaglayici4,
  turkSaglayici5,
}

extension KuryeTakipSaglayiciTuruEtiketi on KuryeTakipSaglayiciTuru {
  String get etiket {
    switch (this) {
      case KuryeTakipSaglayiciTuru.dahiliGps:
        return 'Dahili GPS';
      case KuryeTakipSaglayiciTuru.traccar:
        return 'Traccar';
      case KuryeTakipSaglayiciTuru.navixy:
        return 'Navix';
      case KuryeTakipSaglayiciTuru.ozelApi:
        return 'Ozel API';
      case KuryeTakipSaglayiciTuru.turkSaglayici1:
        return 'Arvento';
      case KuryeTakipSaglayiciTuru.turkSaglayici2:
        return 'Mobiliz';
      case KuryeTakipSaglayiciTuru.turkSaglayici3:
        return 'Seyir Mobil';
      case KuryeTakipSaglayiciTuru.turkSaglayici4:
        return 'Trio Mobil';
      case KuryeTakipSaglayiciTuru.turkSaglayici5:
        return 'TakipOn';
    }
  }
}

class KuryeTakipSaglayiciVarligi {
  const KuryeTakipSaglayiciVarligi({
    required this.id,
    required this.ad,
    required this.tur,
    required this.apiTabanUrl,
    required this.apiAnahtari,
    required this.aktifMi,
    required this.oncelik,
    required this.aciklama,
  });

  final String id;
  final String ad;
  final KuryeTakipSaglayiciTuru tur;
  final String apiTabanUrl;
  final String apiAnahtari;
  final bool aktifMi;
  final int oncelik;
  final String aciklama;

  KuryeTakipSaglayiciVarligi copyWith({
    String? id,
    String? ad,
    KuryeTakipSaglayiciTuru? tur,
    String? apiTabanUrl,
    String? apiAnahtari,
    bool? aktifMi,
    int? oncelik,
    String? aciklama,
  }) {
    return KuryeTakipSaglayiciVarligi(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      tur: tur ?? this.tur,
      apiTabanUrl: apiTabanUrl ?? this.apiTabanUrl,
      apiAnahtari: apiAnahtari ?? this.apiAnahtari,
      aktifMi: aktifMi ?? this.aktifMi,
      oncelik: oncelik ?? this.oncelik,
      aciklama: aciklama ?? this.aciklama,
    );
  }
}

class KuryeCihazEslesmesiVarligi {
  const KuryeCihazEslesmesiVarligi({
    required this.kuryeAdi,
    required this.saglayiciId,
    required this.cihazKimligi,
    required this.aktifMi,
  });

  final String kuryeAdi;
  final String saglayiciId;
  final String cihazKimligi;
  final bool aktifMi;

  KuryeCihazEslesmesiVarligi copyWith({
    String? kuryeAdi,
    String? saglayiciId,
    String? cihazKimligi,
    bool? aktifMi,
  }) {
    return KuryeCihazEslesmesiVarligi(
      kuryeAdi: kuryeAdi ?? this.kuryeAdi,
      saglayiciId: saglayiciId ?? this.saglayiciId,
      cihazKimligi: cihazKimligi ?? this.cihazKimligi,
      aktifMi: aktifMi ?? this.aktifMi,
    );
  }
}

class KuryeSaglayiciTestSonucu {
  const KuryeSaglayiciTestSonucu.basarili(this.mesaj) : basarili = true;

  const KuryeSaglayiciTestSonucu.hata(this.mesaj) : basarili = false;

  final bool basarili;
  final String mesaj;
}
