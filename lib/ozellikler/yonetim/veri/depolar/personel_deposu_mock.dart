import 'package:restoran_app/ozellikler/yonetim/alan/depolar/personel_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';

class PersonelDeposuMock implements PersonelDeposu {
  final List<PersonelDurumuVarligi> _personeller =
      const <PersonelDurumuVarligi>[
        PersonelDurumuVarligi(
          adSoyad: 'Selin Acar',
          rolEtiketi: 'Garson',
          bolge: 'Salon A',
          aciklama: 'Uc aktif masa ve iki hazir teslim siparisi yonetiyor.',
          durum: PersonelDurumu.aktif,
        ),
        PersonelDurumuVarligi(
          adSoyad: 'Emre Koc',
          rolEtiketi: 'Garson',
          bolge: 'Salon B',
          aciklama: 'On dakika mola icin ayrildi, siparisleri devredildi.',
          durum: PersonelDurumu.mola,
        ),
        PersonelDurumuVarligi(
          adSoyad: 'Derya Tunali',
          rolEtiketi: 'Kasiyer',
          bolge: 'Kasa',
          aciklama: 'Gel al ve paket servis odemelerini topluyor.',
          durum: PersonelDurumu.aktif,
        ),
        PersonelDurumuVarligi(
          adSoyad: 'Ozan Cetin',
          rolEtiketi: 'Destek',
          bolge: 'Arka alan',
          aciklama: 'Aksam vardiyasi icin beklemede, gorev atamasi yok.',
          durum: PersonelDurumu.pasif,
        ),
      ];

  @override
  Future<List<PersonelDurumuVarligi>> personelleriGetir() async {
    return _personeller;
  }
}
