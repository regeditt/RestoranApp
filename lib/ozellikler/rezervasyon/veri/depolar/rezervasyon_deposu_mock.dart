import 'package:restoran_app/ozellikler/rezervasyon/alan/depolar/rezervasyon_deposu.dart';
import 'package:restoran_app/ozellikler/rezervasyon/alan/enumlar/rezervasyon_durumu.dart';
import 'package:restoran_app/ozellikler/rezervasyon/alan/varliklar/rezervasyon_varligi.dart';

class RezervasyonDeposuMock implements RezervasyonDeposu {
  RezervasyonDeposuMock() : _kayitlar = _tohumKayitlariOlustur();

  final List<RezervasyonVarligi> _kayitlar;

  @override
  Future<void> rezervasyonDurumuGuncelle({
    required String rezervasyonId,
    required RezervasyonDurumu durum,
  }) async {
    final int index = _kayitlar.indexWhere(
      (kayit) => kayit.id == rezervasyonId,
    );
    if (index < 0) {
      return;
    }
    _kayitlar[index] = _kayitlar[index].copyWith(durum: durum);
  }

  @override
  Future<void> rezervasyonKaydet(RezervasyonVarligi rezervasyon) async {
    final int index = _kayitlar.indexWhere(
      (kayit) => kayit.id == rezervasyon.id,
    );
    if (index < 0) {
      _kayitlar.add(rezervasyon);
      return;
    }
    _kayitlar[index] = rezervasyon;
  }

  @override
  Future<List<RezervasyonVarligi>> rezervasyonlariGetir({DateTime? gun}) async {
    Iterable<RezervasyonVarligi> sonuc = _kayitlar;
    if (gun != null) {
      final DateTime gunBaslangici = DateTime(gun.year, gun.month, gun.day);
      final DateTime gunBitisi = gunBaslangici.add(const Duration(days: 1));
      sonuc = sonuc.where((rezervasyon) {
        return rezervasyon.baslangicZamani.isBefore(gunBitisi) &&
            rezervasyon.bitisZamani.isAfter(gunBaslangici);
      });
    }
    final List<RezervasyonVarligi> sirali = sonuc.toList()
      ..sort((a, b) => a.baslangicZamani.compareTo(b.baslangicZamani));
    return sirali.map((kayit) => kayit.copyWith()).toList(growable: false);
  }

  @override
  Future<void> rezervasyonSil(String rezervasyonId) async {
    _kayitlar.removeWhere((kayit) => kayit.id == rezervasyonId);
  }

  static List<RezervasyonVarligi> _tohumKayitlariOlustur() {
    final DateTime simdi = DateTime.now();
    final DateTime bugun = DateTime(simdi.year, simdi.month, simdi.day);
    return <RezervasyonVarligi>[
      RezervasyonVarligi(
        id: 'rez_1001',
        musteriAdi: 'Ayse Yilmaz',
        telefon: '05325550001',
        kisiSayisi: 2,
        baslangicZamani: bugun.add(const Duration(hours: 19)),
        bitisZamani: bugun.add(const Duration(hours: 20, minutes: 30)),
        durum: RezervasyonDurumu.onaylandi,
        olusturmaZamani: simdi.subtract(const Duration(hours: 4)),
        bolumId: 'blm_salon',
        bolumAdi: 'Salon',
        masaId: 'masa_2',
        masaAdi: '2',
        notMetni: 'Cam kenari tercih edildi.',
      ),
      RezervasyonVarligi(
        id: 'rez_1002',
        musteriAdi: 'Mert Kara',
        telefon: '05325550002',
        kisiSayisi: 5,
        baslangicZamani: bugun.add(const Duration(hours: 20)),
        bitisZamani: bugun.add(const Duration(hours: 22)),
        durum: RezervasyonDurumu.beklemede,
        olusturmaZamani: simdi.subtract(const Duration(hours: 2)),
        bolumId: 'blm_bahce',
        bolumAdi: 'Bahce',
        masaId: 'masa_13',
        masaAdi: '13',
      ),
      RezervasyonVarligi(
        id: 'rez_1003',
        musteriAdi: 'Deniz Acar',
        telefon: '05325550003',
        kisiSayisi: 3,
        baslangicZamani: bugun.subtract(const Duration(hours: 1)),
        bitisZamani: bugun.add(const Duration(minutes: 30)),
        durum: RezervasyonDurumu.noShow,
        olusturmaZamani: simdi.subtract(const Duration(days: 1)),
        bolumId: 'blm_teras',
        bolumAdi: 'Teras',
        masaId: 'masa_8',
        masaAdi: '8',
      ),
    ];
  }
}
