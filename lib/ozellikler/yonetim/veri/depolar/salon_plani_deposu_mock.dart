import 'package:restoran_app/ozellikler/yonetim/alan/depolar/salon_plani_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/salon_bolumu_varligi.dart';

class SalonPlaniDeposuMock implements SalonPlaniDeposu {
  final List<SalonBolumuVarligi> _bolumler = <SalonBolumuVarligi>[
    const SalonBolumuVarligi(
      id: 'blm_salon',
      ad: 'Salon',
      aciklama: 'Yuksek devirli ana servis alani.',
      masalar: <MasaTanimiVarligi>[
        MasaTanimiVarligi(id: 'masa_1', ad: '1', kapasite: 4),
        MasaTanimiVarligi(id: 'masa_2', ad: '2', kapasite: 2),
        MasaTanimiVarligi(id: 'masa_3', ad: '3', kapasite: 4),
        MasaTanimiVarligi(id: 'masa_4', ad: '4', kapasite: 2),
        MasaTanimiVarligi(id: 'masa_5', ad: '5', kapasite: 4),
        MasaTanimiVarligi(id: 'masa_6', ad: '6', kapasite: 2),
      ],
    ),
    const SalonBolumuVarligi(
      id: 'blm_teras',
      ad: 'Teras',
      aciklama: 'Aksam ve kahve servisi icin sakin bolge.',
      masalar: <MasaTanimiVarligi>[
        MasaTanimiVarligi(id: 'masa_7', ad: '7', kapasite: 4),
        MasaTanimiVarligi(id: 'masa_8', ad: '8', kapasite: 2),
        MasaTanimiVarligi(id: 'masa_9', ad: '9', kapasite: 4),
        MasaTanimiVarligi(id: 'masa_10', ad: '10', kapasite: 2),
      ],
    ),
    const SalonBolumuVarligi(
      id: 'blm_bahce',
      ad: 'Bahce',
      aciklama: 'Genis grup ve hafta sonu yogunlugu icin acik alan.',
      masalar: <MasaTanimiVarligi>[
        MasaTanimiVarligi(id: 'masa_11', ad: '11', kapasite: 4),
        MasaTanimiVarligi(id: 'masa_12', ad: '12', kapasite: 4),
        MasaTanimiVarligi(id: 'masa_13', ad: '13', kapasite: 6),
        MasaTanimiVarligi(id: 'masa_14', ad: '14', kapasite: 6),
      ],
    ),
  ];

  @override
  Future<void> bolumEkle(SalonBolumuVarligi bolum) async {
    _bolumler.add(bolum);
  }

  @override
  Future<void> bolumGuncelle(SalonBolumuVarligi bolum) async {
    final int index = _bolumler.indexWhere(
      (SalonBolumuVarligi kayit) => kayit.id == bolum.id,
    );
    if (index >= 0) {
      _bolumler[index] = bolum;
    }
  }

  @override
  Future<List<SalonBolumuVarligi>> bolumleriGetir() async {
    return _bolumler
        .map(
          (SalonBolumuVarligi bolum) => bolum.copyWith(
            masalar: bolum.masalar
                .map((MasaTanimiVarligi masa) => masa.copyWith())
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Future<void> bolumSil(String bolumId) async {
    _bolumler.removeWhere((SalonBolumuVarligi bolum) => bolum.id == bolumId);
  }

  @override
  Future<void> masaEkle(String bolumId, MasaTanimiVarligi masa) async {
    final int index = _bolumler.indexWhere(
      (SalonBolumuVarligi bolum) => bolum.id == bolumId,
    );
    if (index < 0) {
      return;
    }

    final SalonBolumuVarligi bolum = _bolumler[index];
    _bolumler[index] = bolum.copyWith(
      masalar: <MasaTanimiVarligi>[...bolum.masalar, masa],
    );
  }

  @override
  Future<void> masaGuncelle({
    required String bolumId,
    required MasaTanimiVarligi masa,
  }) async {
    final int index = _bolumler.indexWhere(
      (SalonBolumuVarligi bolum) => bolum.id == bolumId,
    );
    if (index < 0) {
      return;
    }

    final SalonBolumuVarligi bolum = _bolumler[index];
    _bolumler[index] = bolum.copyWith(
      masalar: bolum.masalar.map((MasaTanimiVarligi kayit) {
        return kayit.id == masa.id ? masa : kayit;
      }).toList(),
    );
  }

  @override
  Future<void> masaSil({
    required String bolumId,
    required String masaId,
  }) async {
    final int index = _bolumler.indexWhere(
      (SalonBolumuVarligi bolum) => bolum.id == bolumId,
    );
    if (index < 0) {
      return;
    }

    final SalonBolumuVarligi bolum = _bolumler[index];
    _bolumler[index] = bolum.copyWith(
      masalar: bolum.masalar
          .where((MasaTanimiVarligi masa) => masa.id != masaId)
          .toList(),
    );
  }
}
