# SOLID ve Modul Kurallari

Bu dosya, `RULES.md` icindeki genel kararlarin SOLID ve modul bagimliligi tarafindaki detayli uygulama kurallarini icerir.

## 1) Kapsam

- Tum `lib/ozellikler/*` kodu bu kurallara tabidir.
- `bagimlilik_enjeksiyonu` klasoru composition root kabul edilir; somut implementasyonlar burada birlestirilebilir.
- `ortak` klasoru platform ve uygulama genelindeki paylasilan detaylar icin kullanilabilir.

## 2) Katman Modeli

Temel katmanlar:

- `sunum`
- `uygulama`
- `alan`
- `veri`

Ek katman eslemeleri (kurye takip gibi entegrasyon modulleri icin):

- `core` => `alan` gibi davranir (soylesme/kontrat odakli)
- `providers` => `veri` gibi davranir (adaptor/altyapi odakli)

## 3) Zorunlu Bagimlilik Matrisi

Ayni feature icinde:

- `sunum` -> `sunum`, `uygulama`, `alan` (izinli)
- `uygulama` -> `uygulama`, `alan` (izinli)
- `alan` -> yalnizca `alan` (izinli)
- `veri` -> `veri`, `alan` (izinli)

Farkli feature arasinda:

- `sunum` -> yalnizca diger feature `alan`
- `uygulama` -> yalnizca diger feature `alan`
- `alan` -> yalnizca diger feature `alan`
- `veri` -> yalnizca diger feature `alan`

Yasaklar:

- `sunum` katmanindan dogrudan `veri` bagimliligi.
- `uygulama` katmanindan `sunum` bagimliligi.
- `alan` katmanindan `sunum`, `uygulama`, `veri` bagimliligi.
- `alan` katmaninda `package:flutter/*` bagimliligi.

## 4) SOLID Uygulama Kurallari

- `S`: Bir sinifin tek degisim sebebi olacak. 400+ satir dosyalar parcalanmali.
- `O`: Yeni entegrasyonlar mevcut servisleri buyuterek degil, yeni adaptor/implementasyon ekleyerek yapilacak.
- `L`: Soyutlama kontratini ihlal eden "ozel kosullu" alt siniflar olusturulmayacak.
- `I`: Buyuk arayuzler yerine amaca ozel kucuk kontratlar tercih edilecek.
- `D`: Ust katmanlar somut siniflara degil, kontratlara baglanacak.

## 5) Veri Katmani Ozel Kurali

- `*_gercek.dart` dosyalarinin `*_mock.dart` dosyalarindan kalitim almasi yeni kodda yasaktir.
- Mock ve gercek implementasyonlar ortak bir `alan/depolar/*` kontratini implemente etmelidir.

## 6) Uygulama ve Denetim

Bu kurallar su komutla denetlenir:

```bash
dart run tool/solid_kural_kontrolu.dart
```

Mevcut teknik borc baseline kaydini guncellemek icin:

```bash
dart run tool/solid_kural_kontrolu.dart --update-baseline
```

Baseline dosyasi:

- `tool/solid_kural_baseline.txt`

Not: Baseline sadece mevcut borcu dondurmek icindir. Yeni ihlal eklenmesi kabul edilmez.
