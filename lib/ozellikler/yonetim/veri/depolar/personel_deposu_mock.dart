import 'package:restoran_app/ozellikler/yonetim/alan/depolar/personel_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';

class PersonelDeposuMock implements PersonelDeposu {
  Future<void> Function(String kimlik)? _kimlikSilici;
  late final List<PersonelDurumuVarligi> _personeller = <PersonelDurumuVarligi>[
    PersonelDurumuVarligi(
      kimlik: 'per_1',
      adSoyad: 'Selin Acar',
      rolEtiketi: 'Garson',
      bolge: 'Salon A',
      aciklama: 'Uc aktif masa ve iki hazir teslim siparisi yonetiyor.',
      durum: PersonelDurumu.aktif,
    ),
    PersonelDurumuVarligi(
      kimlik: 'per_2',
      adSoyad: 'Emre Koc',
      rolEtiketi: 'Garson',
      bolge: 'Salon B',
      aciklama: 'On dakika mola icin ayrildi, siparisleri devredildi.',
      durum: PersonelDurumu.mola,
    ),
    PersonelDurumuVarligi(
      kimlik: 'per_3',
      adSoyad: 'Derya Tunali',
      rolEtiketi: 'Kasiyer',
      bolge: 'Kasa',
      aciklama: 'Gel al ve paket servis odemelerini topluyor.',
      durum: PersonelDurumu.aktif,
    ),
    PersonelDurumuVarligi(
      kimlik: 'per_4',
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

  @override
  Future<void> personelSil(String kimlik) async {
    await _kimlikSilici?.call(kimlik);
    _personeller.removeWhere((PersonelDurumuVarligi personel) {
      return personel.kimlik == kimlik;
    });
  }

  void kimlikSiliciAta(Future<void> Function(String kimlik) silici) {
    _kimlikSilici = silici;
  }

  void personelEkle(PersonelDurumuVarligi personel) {
    _personeller.removeWhere(
      (PersonelDurumuVarligi kayit) => kayit.kimlik == personel.kimlik,
    );
    _personeller.add(personel);
  }
}
