# Proje Kurallari

Bu dosya, proje boyunca uyulacak temel kurallari icerir. Tum gelistirme adimlari bu dosyaya bakilarak yapilacaktir.

## Genel Kurallar

- Proje adi gorunen ad olarak `RestoranApp` olacak.
- Kod tarafinda teknik isimlendirme gerektiginde paket ve dosya adlari `restoran_app` biciminde olacak.
- Proje `Flutter` ile gelistirilecek.
- Proje hem `Desktop`hem`mobil` hem `web` ortaminda calisacak.
- Tek kod tabani ile cok platform destegi saglanacak.

## Mimari Kurallar

- Proje `SOLID` prensiplerine uygun olacak.
- Proje `N katmanli mimari` ile gelistirilecek.
- Mimari `feature bazli + katmanli` duzende kurgulanacak.
- Her feature icinde temel katmanlar:
  - `sunum`
  - `uygulama`
  - `alan`
  - `veri`
- UI katmani dogrudan veri kaynagina baglanmayacak.
- Is kurallari `alan` ve `uygulama` katmanlarinda toplanacak.
- Platforma bagimli detaylar `veri` veya altyapi katmaninda izole edilecek.

## Isimlendirme Kurallari

- Tum degisken, sinif, method ve alan adlari Turkce anlam tasiyacak.
- Turkce karakter kullanilmayacak.
- `c, g, i, o, s, u` ASCII harfleri tercih edilecek.
- Sinif adlari `PascalCase` olacak.
- Degisken ve method adlari `camelCase` olacak.
- Dosya adlari `snake_case` olacak.
- Gereksiz Ingilizce adlandirmadan kacinilacak.

## Urun Kurallari

- Musteri siparis verirken uye olmak zorunda olmayacak.
- Sistem `misafir siparis` destekleyecek.
- Uyeligin rolu ek avantajlar saglamak olacak; zorunlu giris olmayacak.
- `personel`, `yonetici` ve `patron` rolleri icin giris zorunlu olacak.

## Islevsel Kapsam

- Musteri menu goruntuleyebilmeli.
- Musteri urun secip sepete ekleyebilmeli.
- Musteri misafir veya uyeli olarak siparis verebilmeli.
- Siparis takibi olmali.
- Webde yonetim paneli olmali.
- `yazici yonetimi` olmali.
- `garson yonetimi` olmali.
- `patron raporlari` olmali.

## Personel ve Yetki Kurallari

- Garson ekleme olmali.
- Garson guncelleme olmali.
- Garson silme olmali.
- Garson aktif/pasif yonetimi olmali.
- Patron raporlari gorebilmeli.
- Yetkiler rol bazli yonetilecek.

## Yazici Kurallari

- Yazici yonetimi yonetim panelinde yer almali.
- Siparis yazdirma destegi olmali.
- Test ciktisi alma ozelligi olmali.
- Yazicilar farkli amaclarla eslestirilebilmeli.

## Web Uyumlulugu

- Responsive tasarim bastan dusunulecek.
- Router yapisi web URL uyumlu olacak.
- Yonetim ekranlari web oncelikli dusunulecek.
- Musteri deneyimi mobil odakli ama web uyumlu olacak.

## Gelistirme Disiplini

- Yeni kararlar alinirsa bu dosya guncellenecek.
- Kod yazmadan once bu dosyadaki kurallar referans alinacak.
- Mimariyi bozacak hizli ama gecici cozumlerden kacinilacak.

## Gelistirme Onceligi

- Su asamada gelistirme masaustu oncelikli yapilacak.
- UI kararlarinda once desktop yerlesim ve kullanim senaryolari dikkate alinacak.
- Mobil ve web destegi tamamen kaldirilmadan, aktif tasarim hedefi masaustu olacak.
- Yonetim paneli, yazici yonetimi, garson yonetimi ve patron raporlari masaustu odakli gelistirilecek.
