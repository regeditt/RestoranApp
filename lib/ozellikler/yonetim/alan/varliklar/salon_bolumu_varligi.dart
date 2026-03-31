class SalonBolumuVarligi {
  const SalonBolumuVarligi({
    required this.id,
    required this.ad,
    required this.aciklama,
    this.masalar = const <MasaTanimiVarligi>[],
  });

  final String id;
  final String ad;
  final String aciklama;
  final List<MasaTanimiVarligi> masalar;

  SalonBolumuVarligi copyWith({
    String? id,
    String? ad,
    String? aciklama,
    List<MasaTanimiVarligi>? masalar,
  }) {
    return SalonBolumuVarligi(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      aciklama: aciklama ?? this.aciklama,
      masalar: masalar ?? this.masalar,
    );
  }
}

class MasaTanimiVarligi {
  const MasaTanimiVarligi({
    required this.id,
    required this.ad,
    required this.kapasite,
  });

  final String id;
  final String ad;
  final int kapasite;

  MasaTanimiVarligi copyWith({String? id, String? ad, int? kapasite}) {
    return MasaTanimiVarligi(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      kapasite: kapasite ?? this.kapasite,
    );
  }
}
