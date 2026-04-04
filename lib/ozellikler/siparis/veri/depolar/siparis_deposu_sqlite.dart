import 'package:drift/drift.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/depolar/siparis_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/paket_teslimat_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

class SiparisDeposuSqlite implements SiparisDeposu {
  SiparisDeposuSqlite(this._veritabani);

  final UygulamaVeritabani _veritabani;

  @override
  Future<SiparisVarligi> siparisOlustur(SiparisVarligi siparis) async {
    await _veritabani.transaction(() async {
      await _veritabani
          .into(_veritabani.siparisKayitlari)
          .insertOnConflictUpdate(
        SiparisKayitlariCompanion(
          id: Value(siparis.id),
          siparisNo: Value(siparis.siparisNo),
          teslimatTipi: Value(siparis.teslimatTipi.index),
          durum: Value(siparis.durum.index),
          olusturmaTarihi: Value(siparis.olusturmaTarihi),
          adresMetni: Value(siparis.adresMetni),
          teslimatNotu: Value(siparis.teslimatNotu),
          kuryeAdi: Value(siparis.kuryeAdi),
          paketTeslimatDurumu: Value(
            siparis.paketTeslimatDurumu?.index,
          ),
          masaNo: Value(siparis.masaNo),
          bolumAdi: Value(siparis.bolumAdi),
          kaynak: Value(siparis.kaynak),
          sahipMisafir: Value(siparis.sahip.misafirMi),
          sahipAdSoyad: Value(
            siparis.sahip.misafirBilgisi?.adSoyad ??
                siparis.sahip.kullanici?.adSoyad ??
                'Misafir',
          ),
          sahipTelefon: Value(
            siparis.sahip.misafirBilgisi?.telefon ??
                siparis.sahip.kullanici?.telefon ??
                '',
          ),
          sahipEposta: Value(
            siparis.sahip.misafirBilgisi?.eposta ??
                siparis.sahip.kullanici?.eposta,
          ),
          sahipAdres: Value(
            siparis.sahip.misafirBilgisi?.adres ??
                siparis.sahip.kullanici?.adresMetni,
          ),
        ),
      );

      for (final SiparisKalemiVarligi kalem in siparis.kalemler) {
        await _veritabani
            .into(_veritabani.siparisKalemleri)
            .insertOnConflictUpdate(
          SiparisKalemleriCompanion(
            id: Value(kalem.id),
            siparisId: Value(siparis.id),
            urunId: Value(kalem.urunId),
            urunAdi: Value(kalem.urunAdi),
            birimFiyat: Value(kalem.birimFiyat),
            adet: Value(kalem.adet),
            secenekAdi: Value(kalem.secenekAdi),
            notMetni: Value(kalem.notMetni),
          ),
        );
      }
    });

    return siparis;
  }

  @override
  Future<SiparisVarligi> siparisDurumuGuncelle(
    String siparisId,
    SiparisDurumu yeniDurum,
  ) async {
    await (_veritabani.update(_veritabani.siparisKayitlari)
          ..where((tbl) => tbl.id.equals(siparisId)))
        .write(SiparisKayitlariCompanion(durum: Value(yeniDurum.index)));
    final SiparisVarligi? siparis = await siparisGetir(siparisId);
    if (siparis == null) {
      throw StateError('Siparis bulunamadi');
    }
    return siparis;
  }

  @override
  Future<List<SiparisVarligi>> siparisleriGetir() async {
    final siparisKayitlari =
        await _veritabani.select(_veritabani.siparisKayitlari).get();
    if (siparisKayitlari.isEmpty) {
      return <SiparisVarligi>[];
    }
    final List<String> siparisIdleri =
        siparisKayitlari.map((kayit) => kayit.id).toList();
    final List<SiparisKalemleriData> tumKalemler =
        await (_veritabani.select(_veritabani.siparisKalemleri)
              ..where((tbl) => tbl.siparisId.isIn(siparisIdleri)))
            .get();
    final Map<String, List<SiparisKalemleriData>> kalemHaritasi =
        <String, List<SiparisKalemleriData>>{};
    for (final SiparisKalemleriData kalem in tumKalemler) {
      (kalemHaritasi[kalem.siparisId] ??= <SiparisKalemleriData>[])
          .add(kalem);
    }
    final List<SiparisVarligi> sonuc = <SiparisVarligi>[];
    for (final kayit in siparisKayitlari) {
      sonuc.add(
        _siparisCoz(
          kayit,
          kalemHaritasi[kayit.id] ?? <SiparisKalemleriData>[],
        ),
      );
    }
    return sonuc;
  }

  @override
  Future<SiparisVarligi?> siparisGetir(String siparisId) async {
    final kayit = await (_veritabani.select(_veritabani.siparisKayitlari)
          ..where((tbl) => tbl.id.equals(siparisId)))
        .getSingleOrNull();
    if (kayit == null) return null;
    final kalemler = await (_veritabani.select(_veritabani.siparisKalemleri)
          ..where((tbl) => tbl.siparisId.equals(kayit.id)))
        .get();
    return _siparisCoz(kayit, kalemler);
  }

  SiparisVarligi _siparisCoz(
    SiparisKayitlariData kayit,
    List<SiparisKalemleriData> kalemKayitlari,
  ) {
    final SiparisSahibiVarligi sahip = SiparisSahibiVarligi.misafir(
      MisafirBilgisiVarligi(
        adSoyad: kayit.sahipAdSoyad,
        telefon: kayit.sahipTelefon,
        eposta: kayit.sahipEposta,
        adres: kayit.sahipAdres,
      ),
    );
    return SiparisVarligi(
      id: kayit.id,
      siparisNo: kayit.siparisNo,
      sahip: sahip,
      teslimatTipi: TeslimatTipi.values[kayit.teslimatTipi],
      durum: SiparisDurumu.values[kayit.durum],
      kalemler: kalemKayitlari
          .map(
            (kalem) => SiparisKalemiVarligi(
              id: kalem.id,
              urunId: kalem.urunId,
              urunAdi: kalem.urunAdi,
              birimFiyat: kalem.birimFiyat,
              adet: kalem.adet,
              secenekAdi: kalem.secenekAdi,
              notMetni: kalem.notMetni,
            ),
          )
          .toList(),
      olusturmaTarihi: kayit.olusturmaTarihi,
      adresMetni: kayit.adresMetni,
      teslimatNotu: kayit.teslimatNotu,
      kuryeAdi: kayit.kuryeAdi,
      paketTeslimatDurumu: kayit.paketTeslimatDurumu == null
          ? null
          : PaketTeslimatDurumu.values[kayit.paketTeslimatDurumu!],
      masaNo: kayit.masaNo,
      bolumAdi: kayit.bolumAdi,
      kaynak: kayit.kaynak,
    );
  }
}
