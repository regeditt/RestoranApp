import 'package:drift/drift.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/depolar/personel_deposu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/personel_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/yonetim/veri/depolar/personel_deposu_mock.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class PersonelDeposuSqlite implements PersonelDeposu {
  PersonelDeposuSqlite(this._veritabani);

  final UygulamaVeritabani _veritabani;
  final PersonelDeposuMock _seedDeposu = PersonelDeposuMock();
  bool _seedKontrolEdildi = false;

  @override
  Future<List<PersonelDurumuVarligi>> personelleriGetir() async {
    await _seedEminOl();
    final kayitlar = await _veritabani
        .select(_veritabani.personelKayitlari)
        .get();
    return kayitlar
        .map(
          (kayit) => PersonelDurumuVarligi(
            adSoyad: kayit.adSoyad,
            rolEtiketi: kayit.rolEtiketi,
            bolge: kayit.bolge,
            aciklama: kayit.aciklama,
            durum: PersonelDurumu.values[kayit.durum],
          ),
        )
        .toList();
  }

  Future<void> _seedEminOl() async {
    if (_seedKontrolEdildi) {
      return;
    }
    final mevcutKayitlar = await _veritabani
        .select(_veritabani.personelKayitlari)
        .get();
    if (mevcutKayitlar.isNotEmpty) {
      _seedKontrolEdildi = true;
      return;
    }

    final List<PersonelDurumuVarligi> personeller = await _seedDeposu
        .personelleriGetir();
    await _veritabani.transaction(() async {
      for (final personel in personeller) {
        await _veritabani
            .into(_veritabani.personelKayitlari)
            .insertOnConflictUpdate(
              PersonelKayitlariCompanion(
                kimlik: Value(
                  await _veritabani.sonrakiNumerikKimlikGetir(
                    tabloAdi: 'personel_kayitlari',
                    kimlikKolonu: 'kimlik',
                  ),
                ),
                adSoyad: Value(personel.adSoyad),
                rolEtiketi: Value(personel.rolEtiketi),
                bolge: Value(personel.bolge),
                aciklama: Value(personel.aciklama),
                durum: Value(personel.durum.index),
              ),
            );
      }
    });
    _seedKontrolEdildi = true;
  }
}
