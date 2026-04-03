# Web Mimarisi Plani

Bu dokuman, `RestoranApp` icin web tarafinin nasil kurgulanacagini netlestirir.

## Hedef

- Tek kod tabani ile `Flutter Web` ciktisi almak
- Musteri tarafinda `QR menu` odakli bir web deneyimi sunmak
- Yonetim tarafinda masaustu odakli bir web paneli sunmak
- Tek restoran modelini korumak

## Web Roller

- `musteri`
  - QR kod ile menuye girer
  - urunleri inceler
  - sepete ekler
  - siparis verir
- `personel`
  - aktif siparisleri gorur
  - operasyon ekranlarini kullanir
- `yonetici`
  - yazici, personel ve operasyon ekranlarini yonetir
- `patron`
  - rapor ve ozet ekranlarini gorur

## Web Rota Yapisi

- `/`
  - tanitim ve yonlendirme sayfasi
- `/qr-menu`
  - musteri icin esas giris noktasi
- `/siparis-ozeti`
  - sepetten sonra siparis adimi
- `/yonetim-paneli`
  - operasyon ve raporlama paneli
- `/hesabim`
  - yetkili kullanici veya gelecekte profil akisi

## QR Menu URL Stratejisi

QR kodlar dogrudan web URL'sine gitmelidir.

Ornekler:

- `/qr-menu?masa=12`
- `/qr-menu?bolum=teras`
- `/qr-menu?kaynak=qr`

Ileride desteklenebilir:

- `/qr-menu?masa=12&kampanya=ogle`
- `/qr-menu?masa=12&garson=ahmet`

## Musteri Web Deneyimi

- mobil oncelikli tasarlanacak
- QR acilisi ile menu dogrudan gorunecek
- gereksiz ana sayfa katmanlari olmayacak
- kategori, urun detay, secenek ve sepet akisi hizli olacak
- siparis tamamlama adimi sade tutulacak

## Yonetim Web Deneyimi

- masaustu oncelikli tasarlanacak
- genis ekranlarda cift kolon ve panel mantigi korunacak
- siparis listesi, yazici, personel ve rapor ayni panelde koordineli calisacak
- tablet boyutunda sade ama kullanilabilir alternatif yerlesim sunulacak

## Veri ve Durum Akisi

- `sunum` katmani sadece ekran durumunu yonetecek
- menu, sepet, siparis, yazici ve personel verileri use-case uzerinden gelecek
- web ozel davranislar ayri platform hack'leri ile degil, ortak feature yapisi icinde cozulmeli
- URL query parametreleri gerekli oldugunda `sunum` katmaninda okunup `uygulama` katmanina aktarilacak

## Web Teknik Kararlar

- yayina alinacak cikti `flutter build web` ile uretilecek
- ilk asamada `hash` yerine temiz URL destekleyen rota duzeni tercih edilecek
- hosting tarafinda tum rota istekleri `index.html`'e dondurulecek
- tek restoran modeli nedeniyle alt alan adi veya coklu magaza secimi gerekmeyecek

## Yayinlama Secenekleri

Ilk asamada uygun secenekler:

- Firebase Hosting
- Netlify
- Vercel
- Nginx veya Apache uzerinden statik yayin

Yayinlama kosullari:

- tum route'lar `index.html` fallback ile acilmali
- cache politikasi `index.html` icin dikkatli ayarlanmali
- web ikonlari ve manifest Flutter varsayilanindan restoran markasina gore guncellenmeli

## Yaklasan Web Isleri

1. yonetim panelinde masa bazli gercek `QR URL` uretimi ekle
2. `masa` bilgisini siparis olusturma akisina bagla
3. web icin ayri giris/yetki korumasi tanimla
4. `flutter build web` alip tarayicida akisi dogrula
5. hosting fallback kurallarini dokumante et

## Mevcut QR Durumu

- `QR menu` sayfasi query parametrelerinden `masa`, `bolum` ve `kaynak` bilgisini okuyacak sekilde merkezilestirildi
- Web URL stratejisi temiz rota mantigina cekildi
- Referans URL kalibi:
  - `/qr-menu?masa=12&bolum=teras&kaynak=qr`
- QR kodun gorsel bitmap olarak uretimi sonraki adimda yonetim paneline eklenecek

## MVP Web Kapsami

- QR kod ile acilan menu
- sepete ekleme
- siparis ozeti
- yonetim paneli goruntuleme
- temel responsive destek

## Sonraki Web Kapsami

- rol bazli web girisi
- online API baglantisi
- stok ve recete baglantisi
- entegrasyon paneli
- offline stratejisi
