# API Dokumantasyon Standardi (JavaDoc Benzeri)

Bu proje icin JavaDoc benzeri teknik dokumantasyon standardi `Dart Doc` uzerinden uygulanir.

## 1) Uretim Komutu

API dokumani üretmek icin:

```powershell
dart doc --output docs/api_reference
```

Uretilen HTML cikti:

- `docs/api_reference/index.html`

## 2) Yorum Yazim Formati

Public API'lerde `///` ile dokumantasyon yazilir.

### Sinif Ornegi

```dart
/// Siparis akisindaki tum operasyonlari koordine eden uygulama servisi.
class SiparisServisi {
  /// ...
}
```

### Metot Ornegi

```dart
/// Verilen siparisi kaydeder ve olusturulan siparis kaydini dondurur.
///
/// [siparis] bos kalem listesi icerirse hata firlatir.
Future<SiparisVarligi> siparisOlustur(SiparisVarligi siparis);
```

### Parametre Referansi

- Parametre ve tip referanslari koseli parantezle yazilir: `[siparisId]`, `[SiparisDurumu]`
- Davranis yan etkileri acik yazilir: "veriyi gunceller", "kaydi siler", "yanlis durumda hata doner"

## 3) Kapsam Kurali

Asagidaki katmanlarda public API dokumani zorunludur:

- `alan/depolar/*`
- `uygulama/use_case/*`
- `uygulama/servisler/*` (public sinif ve public metodlar)

Asagidaki alanlarda ozet yorum yeterlidir:

- `sunum/viewmodel/*`
- `sunum/sayfalar/*`

## 4) Dokumantasyon Seviyesi

Her public API icin en az:

1. Ne yaptigi
2. Hangi girdiyi bekledigi
3. Ne dondurdugu
4. Hata/istisna kosulu

## 5) Guncelleme Disiplini

- Yeni public API eklendiginde ayni PR/commit icinde `///` yorumu da eklenir.
- API degisimi varsa `docs/changelog.md` notu guncellenir.
