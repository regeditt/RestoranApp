# Restoran Akisi Uygulama Notlari

Bu not, hem yabanci hem de Turkce kaynaklardan alinmis operasyon prensiplerinin
uygulamadaki somut karsiliklarini listeler.

## Uctan Uca Akis

1. Ana sayfa:
   Musteri ve personel akislari ayridir.
2. Musteri:
   QR/menu -> sepet -> kampanya/kupon -> siparis ozeti -> odeme -> takip.
3. Personel:
   Online siparis -> mutfak -> teslimat/servis kapanisi -> odeme-kasa -> rapor.
4. Rezervasyon:
   Kayit -> onay -> geldi -> tamamlandi/no-show/iptal.

## Uygulanan Kurallar

1. Siparis durum akisi tek merkezden dogrulanir.
   - alindi -> hazirlaniyor -> hazir -> (paket ise yolda) -> teslim edildi
   - iptal sadece kapanmamis sipariste mumkundur
   - kapanmis sipariste yeniden durum degisikligi engellenir
   - yolda durumu sadece paket servis icin gecerlidir

2. Rezervasyonda no-show otomasyonu vardir.
   - beklemede/onaylandi durumundaki rezervasyonlar
   - baslangic saatinden +15 dakika sonra hala aktifse
   - otomatik no-show olarak isaretlenir

3. Online siparis ekraninda yogunluk uyarisi vardir.
   - aktif siparis veya aktif paket siparis esigi asildiginda
   - kanal yavaslatma/pause ve hazirlama suresi artirma onerisi gosterilir

4. KVKK ve on bilgilendirme akisi UI'da zorunlu hale getirilmistir.
   - Siparis ozetinde aydinlatma onayi zorunlu, ticari iletisim onayi opsiyoneldir
   - Rezervasyon eklemede aydinlatma onayi zorunlu, ticari iletisim onayi opsiyoneldir
   - Rezervasyon kaydinda bu onaylar veri modelinde saklanir
   - Siparis tarafinda onay bilgisi siparis notuna islenerek operasyon kaydina eklenir

## Referanslar

- Toast (KDS ve prep-time, future order): support.toasttab.com
- Square (restoran operasyonu/split check): squareup.com/help
- OpenTable (rezervasyon ve no-show pratiği): opentable.com/restaurant-solutions
- Yemeksepeti entegrasyon dokumantasyonu: integration.yemeksepeti.com
- KVKK aydinlatma ve veri saklama yukumlulukleri: kvkk.gov.tr
- GIB e-Belge duyurulari: ebelge.gib.gov.tr
- Ticaret Bakanligi mesafeli sozlesmeler bilgilendirmesi: tuketici.ticaret.gov.tr
