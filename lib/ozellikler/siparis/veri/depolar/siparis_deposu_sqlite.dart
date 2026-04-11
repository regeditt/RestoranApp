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
import 'package:restoran_app/ozellikler/siparis/veri/depolar/siparis_durumu_yardimcisi.dart';

class SiparisDeposuSqlite implements SiparisDeposu {
  SiparisDeposuSqlite(this._veritabani);

  final UygulamaVeritabani _veritabani;

  @override
  Future<SiparisVarligi> siparisOlustur(SiparisVarligi siparis) async {
    final String siparisId = await _veritabani.numerikKimlikCozumle(
      tabloAdi: 'siparis_kayitlari',
      adayKimlik: siparis.id,
    );
    final List<SiparisKalemiVarligi> kalemler = <SiparisKalemiVarligi>[];
    for (final SiparisKalemiVarligi kalem in siparis.kalemler) {
      final String kalemId = await _veritabani.numerikKimlikCozumle(
        tabloAdi: 'siparis_kalemleri',
        adayKimlik: kalem.id,
      );
      kalemler.add(
        SiparisKalemiVarligi(
          id: kalemId,
          urunId: kalem.urunId,
          urunAdi: kalem.urunAdi,
          birimFiyat: kalem.birimFiyat,
          adet: kalem.adet,
          secenekAdi: kalem.secenekAdi,
          notMetni: kalem.notMetni,
        ),
      );
    }
    final SiparisVarligi kaydedilecekSiparis = siparis.copyWith(
      id: siparisId,
      kalemler: kalemler,
    );

    await _veritabani.transaction(() async {
      await _veritabani
          .into(_veritabani.siparisKayitlari)
          .insertOnConflictUpdate(
            SiparisKayitlariCompanion(
              id: Value(kaydedilecekSiparis.id),
              siparisNo: Value(kaydedilecekSiparis.siparisNo),
              teslimatTipi: Value(kaydedilecekSiparis.teslimatTipi.index),
              durum: Value(kaydedilecekSiparis.durum.index),
              olusturmaTarihi: Value(kaydedilecekSiparis.olusturmaTarihi),
              adresMetni: Value(kaydedilecekSiparis.adresMetni),
              teslimatNotu: Value(kaydedilecekSiparis.teslimatNotu),
              kuryeAdi: Value(kaydedilecekSiparis.kuryeAdi),
              paketTeslimatDurumu: Value(
                kaydedilecekSiparis.paketTeslimatDurumu?.index,
              ),
              masaNo: Value(kaydedilecekSiparis.masaNo),
              bolumAdi: Value(kaydedilecekSiparis.bolumAdi),
              kaynak: Value(kaydedilecekSiparis.kaynak),
              kuponKodu: Value(kaydedilecekSiparis.kuponKodu),
              indirimTutari: Value(kaydedilecekSiparis.indirimTutari),
              sahipMisafir: Value(kaydedilecekSiparis.sahip.misafirMi),
              sahipAdSoyad: Value(
                kaydedilecekSiparis.sahip.misafirBilgisi?.adSoyad ??
                    kaydedilecekSiparis.sahip.kullanici?.adSoyad ??
                    'Misafir',
              ),
              sahipTelefon: Value(
                kaydedilecekSiparis.sahip.misafirBilgisi?.telefon ??
                    kaydedilecekSiparis.sahip.kullanici?.telefon ??
                    '',
              ),
              sahipEposta: Value(
                kaydedilecekSiparis.sahip.misafirBilgisi?.eposta ??
                    kaydedilecekSiparis.sahip.kullanici?.eposta,
              ),
              sahipAdres: Value(
                kaydedilecekSiparis.sahip.misafirBilgisi?.adres ??
                    kaydedilecekSiparis.sahip.kullanici?.adresMetni,
              ),
            ),
          );

      for (final SiparisKalemiVarligi kalem in kaydedilecekSiparis.kalemler) {
        await _veritabani
            .into(_veritabani.siparisKalemleri)
            .insertOnConflictUpdate(
              SiparisKalemleriCompanion(
                id: Value(kalem.id),
                siparisId: Value(kaydedilecekSiparis.id),
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

    return kaydedilecekSiparis;
  }

  @override
  Future<SiparisVarligi> siparisDurumuGuncelle(
    String siparisId,
    SiparisDurumu yeniDurum, {
    String? kuryeAdi,
  }) async {
    final SiparisVarligi? mevcutSiparis = await siparisGetir(siparisId);
    if (mevcutSiparis == null) {
      throw StateError('Siparis bulunamadi');
    }
    final PaketServisDurumGuncellemesi durumGuncellemesi =
        paketServisDurumGuncellemesiniHesapla(
          mevcutSiparis,
          yeniDurum,
          kuryeAdi: kuryeAdi,
        );

    await (_veritabani.update(
      _veritabani.siparisKayitlari,
    )..where((tbl) => tbl.id.equals(siparisId))).write(
      SiparisKayitlariCompanion(
        durum: Value(yeniDurum.index),
        kuryeAdi: Value(durumGuncellemesi.kuryeAdi),
        paketTeslimatDurumu: Value(
          durumGuncellemesi.paketTeslimatDurumu?.index,
        ),
      ),
    );
    final SiparisVarligi? siparis = await siparisGetir(siparisId);
    if (siparis == null) {
      throw StateError('Siparis bulunamadi');
    }
    return siparis;
  }

  @override
  Future<List<SiparisVarligi>> siparisleriGetir() async {
    final siparisKayitlari = await _veritabani
        .select(_veritabani.siparisKayitlari)
        .get();
    if (siparisKayitlari.isEmpty) {
      return <SiparisVarligi>[];
    }
    final List<String> siparisIdleri = siparisKayitlari
        .map((kayit) => kayit.id)
        .toList();
    final List<SiparisKalemleriData> tumKalemler = await (_veritabani.select(
      _veritabani.siparisKalemleri,
    )..where((tbl) => tbl.siparisId.isIn(siparisIdleri))).get();
    final Map<String, List<SiparisKalemleriData>> kalemHaritasi =
        <String, List<SiparisKalemleriData>>{};
    for (final SiparisKalemleriData kalem in tumKalemler) {
      (kalemHaritasi[kalem.siparisId] ??= <SiparisKalemleriData>[]).add(kalem);
    }
    final List<SiparisVarligi> sonuc = <SiparisVarligi>[];
    for (final kayit in siparisKayitlari) {
      sonuc.add(
        _siparisCoz(kayit, kalemHaritasi[kayit.id] ?? <SiparisKalemleriData>[]),
      );
    }
    return sonuc;
  }

  @override
  Future<SiparisVarligi?> siparisGetir(String siparisId) async {
    final kayit = await (_veritabani.select(
      _veritabani.siparisKayitlari,
    )..where((tbl) => tbl.id.equals(siparisId))).getSingleOrNull();
    if (kayit == null) return null;
    final kalemler = await (_veritabani.select(
      _veritabani.siparisKalemleri,
    )..where((tbl) => tbl.siparisId.equals(kayit.id))).get();
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
      kuponKodu: kayit.kuponKodu,
      indirimTutari: kayit.indirimTutari,
    );
  }
}
