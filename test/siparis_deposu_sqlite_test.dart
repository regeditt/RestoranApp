import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/misafir_bilgisi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/paket_teslimat_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/siparis_durumu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/enumlar/teslimat_tipi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_kalemi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_sahibi_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/siparis_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/veri/depolar/siparis_deposu_sqlite.dart';
import 'package:restoran_app/ortak/veri/veritabani.dart';

void main() {
  test(
    'SiparisDeposuSqlite paket siparisini yolda durumuna alirken kurye ve dagitim bilgisini gunceller',
    () async {
      final UygulamaVeritabani veritabani = UygulamaVeritabani.test(
        NativeDatabase.memory(),
      );
      addTearDown(veritabani.close);

      final SiparisDeposuSqlite depo = SiparisDeposuSqlite(veritabani);
      final SiparisVarligi kaydedilenSiparis = await depo.siparisOlustur(
        SiparisVarligi(
          id: 'sip_1',
          siparisNo: 'R-9001',
          sahip: SiparisSahibiVarligi.misafir(
            const MisafirBilgisiVarligi(
              adSoyad: 'Paket Musteri',
              telefon: '5550001122',
            ),
          ),
          teslimatTipi: TeslimatTipi.paketServis,
          durum: SiparisDurumu.hazir,
          kalemler: const <SiparisKalemiVarligi>[
            SiparisKalemiVarligi(
              id: 'kal_1',
              urunId: 'urn_1',
              urunAdi: 'Karisik Pizza',
              birimFiyat: 320,
              adet: 1,
            ),
          ],
          olusturmaTarihi: DateTime(2026, 4, 8, 12, 0),
          adresMetni: 'Ataturk Mah. 12. Sok. No:4',
          paketTeslimatDurumu: PaketTeslimatDurumu.kuryeBekliyor,
        ),
      );

      final SiparisVarligi guncelSiparis = await depo.siparisDurumuGuncelle(
        kaydedilenSiparis.id,
        SiparisDurumu.yolda,
      );

      expect(guncelSiparis.durum, SiparisDurumu.yolda);
      expect(guncelSiparis.kuryeAdi, 'Moto Kurye');
      expect(guncelSiparis.paketTeslimatDurumu, PaketTeslimatDurumu.kuryeYolda);

      final SiparisVarligi? veritabaniKaydi = await depo.siparisGetir(
        kaydedilenSiparis.id,
      );
      expect(veritabaniKaydi, isNotNull);
      expect(veritabaniKaydi?.kuryeAdi, 'Moto Kurye');
      expect(
        veritabaniKaydi?.paketTeslimatDurumu,
        PaketTeslimatDurumu.kuryeYolda,
      );
    },
  );
}
