# Changelog

## 2026-04-10

### docs: modul bazli teknik dokumantasyon eklendi

- `docs/modul_dokumantasyonu.md` dosyasi olusturuldu
- `lib/ozellikler` altindaki moduller katman bazinda belgelendi
- Placeholder moduller ve aktif moduller ayrik olarak isaretlendi
- Modul baglantilari ve bakim notlari eklendi

### docs: API dokumantasyon standardi eklendi

- `docs/api_dokumantasyon_standardi.md` olusturuldu
- JavaDoc benzeri `///` yazim kurallari tanimlandi
- `tool/generate_api_docs.ps1` ile `dart doc` cikti akisi eklendi
- `alan/depolar` ve `uygulama/use_case` dosyalarina temel API yorumlari eklendi

### docs: servis ve viewmodel API yorumlari stabilize edildi

- `uygulama/servisler` ve `sunum/viewmodel` altinda hatali konuma dusen otomatik `///` satirlari temizlendi
- Metod govdelerine giren yorumlar kaldirilarak API dokumani uretimi sade ve tutarli hale getirildi
- `flutter test`, `dart analyze lib test` ve `tool/generate_api_docs.ps1` tekrar calistirilip yesil dogrulandi

### docs: servis ve viewmodel sinif aciklamalari anlam odakli hale getirildi

- Genel/tekrarlayan sinif yorumlari kaldirilarak her sinif icin gorev odakli `///` aciklama yazildi
- Ozellikle `kurye`, `siparis`, `yonetim`, `kimlik` ve `menu` modullerindeki servis ve viewmodel siniflari netlestirildi
- API referansi yeniden uretilip (`docs/api_reference`) dokumantasyon ciktilari guncellendi

### docs: tum proje icin modul bazli detay dokuman seti eklendi

- `tool/generate_module_docs.ps1` olusturuldu
- `docs/moduller/` altinda tum moduller icin ayri dokuman dosyalari uretilmeye baslandi
- `docs/proje_dokumantasyonu.md` ile tek noktadan proje, mimari ve modul haritasi dokumanlandi
- `README.md` ve `docs/modul_dokumantasyonu.md` yeni dokuman giris noktalariyla guncellendi

## 2026-03-31

### feat: expand restaurant operations and admin flows

- Rol bazli giris akisi eklendi: `Musteri`, `Garson`, `Yonetici`
- Musteri girisinde isim, telefon ve adres toplaniyor
- Garson ve yonetici icin `POS` ve `Yonetim Paneli` arasinda gecis acildi
- `QR Menu` ve `POS` akisi tek proje icinde netlestirildi
- Siparis ozeti ve adisyon akisi guclendirildi
- Siparis tamamlandiginda yazici hedefleme ve fis olusturma altyapisi eklendi
- Windows yazici tarama ve yazdirma platform katmani eklendi
- Yonetim paneli yeniden duzenlendi ve popup tabanli yazici yonetimi getirildi
- Salon, masa, menu ve stok yonetimi icin admin CRUD akislari eklendi
- Gorsel salon plani ve operasyon ozeti gelistirildi
- Stok ve maliyet modulu baslatildi
- Hammadde, recete ve siparise gore stok dusumu eklendi
- Web mimarisi ve QR URL baglami icin dokumantasyon hazirlandi
