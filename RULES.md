# Proje Kurallari

Bu dosya, proje boyunca uyulacak temel kurallari icerir. Tum gelistirme adimlari bu dosyaya bakilarak yapilacaktir.
SOLID ve modul bagimlilik kurallarinin detayli surumu icin: `RULES_SOLID.md`.
## MCP SERVER KURALI
Çalışırken Dart ve Flutter Mcp Server Sürekli Kullanılacak.

## Mimari Kurallar

- Proje `SOLID` prensiplerine uygun olacak, kesinlikle bağlı kalınacak.
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

## Genel Kurallar

- Proje adi gorunen ad olarak `RestoranApp` olacak.
- Kod tarafinda teknik isimlendirme gerektiginde paket ve dosya adlari `restoran_app` biciminde olacak.
- Proje `Flutter` ile gelistirilecek.
- Proje hem `Desktop`hem`mobil` hem `web` ortaminda calisacak.
- Tek kod tabani ile cok platform destegi saglanacak.


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
- On yuz tamamen dokunmatik ekran kullanimina uygun olacak.
- Tum ana aksiyonlar parmakla rahat secilebilecek buyuklukte ve boslukta tasarlanacak.
- Hover bagimli etkilesimler zorunlu kabul edilmeyecek; temel akislar dokunma ile tamamlanabilecek.
- Yonetim, POS ve musteri ekranlarinda once dokunmatik kullanim ergonomisi dikkate alinacak.
- Router yapisi web URL uyumlu olacak.
- Yonetim ekranlari web oncelikli dusunulecek.
- Musteri deneyimi mobil odakli ama web uyumlu olacak.
- Web musterisi icin esas URL `QR menu` girisi olacak.
- Web tarafi ayri bir teknoloji yerine mevcut `Flutter Web` ciktilari ile ilerleyecek.
- Web mimarisi plani `docs/web_mimarisi_plani.md` dosyasinda yasatilacak.

## Tema ve Tasarim Kurallari

- Projenin varsayilan tema dili `Gece Moru + Sicak Bej` olacak.
- Tema mimarisi `SOLID` bagli olacak:
  - `TemaTokenlari` soyutlamasi uzerinden karar verilecek.
  - Somut tema implementasyonlari bu soyutlamayi implemente edecek.
  - `ThemeData` olusturma sorumlulugu ayri bir olusturucu sinifta olacak.
- Renk, yazi ailesi, yaricap, dokunmatik hedef ve popup tutamac stili gibi tasarim kararlarinin tek kaynagi `lib/ortak/tema` olacak.
- Sunum dosyalarinda dogrudan `Color(0x...)` ve rastgele `Colors.*` kullanimi yeni kod icin yasak; tema tokeni/ThemeExtension kullanimi zorunlu.
- Tum popup pencereleri ortak surukleme davranisi icin `SuruklenebilirPopupSablonu` uzerinden acilacak.
- Popup tutamac tasarimi (8 nokta, yatay duzen, merkez hizasi) ortak bilesen uzerinden yonetilecek; ekranda tek tek elle cizilmeyecek.
- Yeni tasarim kararlarinda once tema tokenlari guncellenecek, sonra ekranlar bu tokenlardan beslenecek.

## Gelistirme Disiplini

- Yeni kararlar alinirsa bu dosya guncellenecek.
- Kod yazmadan once bu dosyadaki kurallar referans alinacak.
- Mimariyi bozacak hizli ama gecici cozumlerden kacinilacak.

## Gelistirme Onceligi

- Su asamada gelistirme dokunmatik ekran oncelikli yapilacak.
- UI kararlarinda once dokunmatik yerlesim, hedef boyutu ve kullanim ergonomisi dikkate alinacak.
- Mobil, tablet, kiosk ve dokunmatik masaustu kullanimlari ayni tasarim dili icinde desteklenecek.
- Yonetim paneli, yazici yonetimi, garson yonetimi ve patron raporlari fare olmadan da verimli kullanilabilecek sekilde gelistirilecek.

## Mevcut Durum

- Ana sayfa vitrini yenilendi.
- Musteri menu/POS ekrani olusturuldu.
- Sepet ve misafir siparis akisi calisiyor.
- Yonetim paneli eklendi.
- Grafikler, filtreler ve arama alani eklendi.
- Mock veriler ile menu ve siparis akislari ayakta.
- Route yapisi net ve merkezilesmis durumda.
- Dart MCP ve Codex entegrasyonu aktif edildi.

## Is Modeli Karari

- Uygulama tek restoran yapisinda ilerleyecek.
- Coklu restoran secimi, restoran listeleme ve restoranlar arasi gecis olmayacak.
- Musteri akisinda tek giris noktasi `QR menu` olacak.
- Klasik ayri musteri menu vitrini tutulmayacak; ayni menu verisi QR akisi uzerinden acilacak.

## Sistem Tasarim Karari

- Referans olarak genel restoran yonetim sistemi dokumanlari incelenebilir ancak uygulama cok restoranli marketplace mantigina tasinmayacak.
- `restaurant search`, `restaurant rating`, `delivery agent marketplace` ve restoranlar arasi gecis MVP kapsamina alinmayacak.
- Sistem servis mantiginda su alanlara ayrilacak:
  - `kimlik`
  - `menu`
  - `sepet`
  - `siparis`
  - `yonetim`
  - `yazici`
  - `personel`
  - `rapor`
- Is kurallari ve rapor hesaplari dogrudan `sunum` katmaninda birikmeyecek; uygun oldugunda `alan` ve `uygulama` katmanina tasinacak.
- Kritik operasyon verileri icin guclu tutarlilik esas alinacak:
  - menu fiyatlari
  - siparis durumu
  - personel durumu
  - yazici eslesmeleri
- Daha esnek alanlar ileride ayri dusunulebilir:
  - degerlendirme
  - log
  - rapor snapshot verileri
- API ve servis dusuncesi tek restoran operasyonunu onceleyecek; dis restoran kesfi yerine ic operasyon yonelecektir.
- `QR menu` ayri bir marketplace akisina donusmeyecek; mevcut `menu` feature'inin QR varyanti olarak ele alinacak.

## Eksik Alanlar

- Stok ve maliyet yonetimi
- Mutfak siparis yonetimi icin ayri operasyon ekrani
- Paket servis operasyon akisi
- Garson yetki ve salon atama detaylari
- Rezervasyon ve masa birlestirme akisi
- Sadakat ve tekrar musteri ozellikleri
- Offline / baglanti kopma senaryolari
- Test katmaninin genisletilmesi

## MVP Kapsami

Ilk surumde mutlaka tamamlanacak akislar:

- tek restoran menu/POS deneyimi
- sepete urun ekleme
- siparis ozeti
- misafir siparis olusturma
- aktif siparisleri yonetim panelinde izleme
- temel grafik ve filtrelerle operasyon ozeti sunma

## Gelistirme Yol Haritasi

Siradaki gelistirmeler bagimlilik ve operasyon onceligine gore asagidaki gibi ilerleyecek.

### Faz 1: Operasyon cekirdegi

1. `stok ve maliyet` modulu baslatilacak
2. urun -> recete -> hammadde iliskisi kurulacak
3. siparis tamamlandiginda stok dusumu ve temel maliyet hesabi yapilacak
4. yonetim paneline kritik stok ve maliyet ozet kartlari eklenecek

### Faz 2: Mutfak ve servis akisi

1. `mutfak siparis yonetimi` icin ayri ekran yapilacak
2. siparis durumlari `alindi -> hazirlaniyor -> hazir -> teslim edildi` akisi ile canli guncellenecek
3. yazici ciktilari mutfak ekrani ve siparis durumlari ile senkron calisacak
4. garson kullanicisi sadece kendi operasyon ekranini ve ilgili masalari gorecek

### Faz 3: Paket servis ve kanal yonetimi

1. `paket servis` akisi ayri operasyon tipi olarak ele alinacak
2. adres, kurye, teslimat durumu ve siparis notlari bu akis icinde izlenecek
3. yonetim panelinde salon ve paket akislarinin ayrik filtreleri olacak
4. QR, salon, gel al ve paket kanallari rapor tarafinda tek yerde toplanacak

### Faz 4: Yetki ve isletme kurallari

1. garson bazli salon atama yapisi eklenecek
2. islem bazli yetkiler tanimlanacak
   - iptal
   - ikram
   - fiyat degistirme
   - masa tasima
3. yonetici ve garson ekranlari ayri akis mantigina kavusturulacak

### Faz 5: Gelismis musteri ve isletme modulleri

1. `masa rezervasyonu` akisi eklenecek
2. kalabalik gruplar icin masa birlestirme / ayirma desteklenecek
3. `sadakat yonetimi` icin musteri tekrar ziyaret altyapisi kurulacak
4. ileride uygun olursa `kiosk`, `menuboard` ve benzeri genisleme modulleri ele alinacak

### Faz 6: Dayaniklilik ve kalite

1. offline senaryolari icin siparis kuyrugu stratejisi tanimlanacak
2. widget testleri ve alan/use-case testleri artirilacak
3. yazici, siparis ve salon akislari icin hata durumlari guclendirilecek

## Rekabet ve Fark Yaratma Plani

Bu plan, sektordeki benzer urunlerle rekabette ayrisma alanlarini netlestirir.

### MVP (0-6 hafta)

1. Offline/low-connectivity davranisi, siparis kuyruklama ve otomatik retry.
2. Garson/mutfak/kurye ekranlarinda hizli aksiyon kisayollari.
3. Yonetim panelinde gunluk/haftalik ciro, urun performansi, saatlik yogunluk kartlari.

### V2 (6-12 hafta)

1. Kurye atama, teslimat suresi analizi ve paket servis detayli takip.
2. Entegrasyonlarin ilk dalgasi: Yemeksepeti, Getir, Trendyol.
3. Cihaz ve yazici uyumlulugu icin resmi test matrisi.

### V3 (12+ hafta)

1. E-Adisyon ve OKC entegrasyonlari.
2. Online magaza / e-ticaret kanali.

## Entegrasyon Teknik Yol Haritasi

### Mimari Temel

1. integration_gateway katmani ile standart entegrasyon arayuzu.
2. menu, urun, varyant ve fiyat esleme tablolari.
3. event kuyruğu ve offline senkronizasyon stratejisi.

### Dalga 1 Entegrasyonlar

1. Yemeksepeti: siparis cekme, durum guncelleme, iptal akisleri.
2. Getir: siparis ve teslimat tipleri, kurye bilgisi eslemesi.
3. Trendyol: kategori esleme ve kampanya uyumu.

### Yasal ve Cihaz Entegrasyonlari

1. E-Adisyon modulu ile GIB sureclerine uyum.
2. OKC POS entegrasyonu ile odeme-adisyon senkronu.
3. Yazici uyumu icin Windows/Android/iOS testleri.

### UX ve Operasyon

1. Entegrasyon durumu sayfasi: aktif entegrasyon, hata durumu, son senkron zamani.
2. Siparis kaynagi bazli filtreler: mutfak ve yonetim ekranlari.

## Kisa Donem Uygulama Plani

Bir sonraki teknik sira su olacak:

1. `stok ve maliyet` feature'ini alan/veri/uygulama katmanlariyla baslat
2. urunlere recete ve stok dusum baglantisi ekle
3. mutfak siparis yonetimi icin ayri ekran olustur
4. paket servis akisina adres ve teslimat durumu katmani ekle

## Oncelikli Ozellik Sirasi (1-10)

Asagidaki sira, urun backlog planinda korunacak ve adimlar bu oncelige gore alinacak.

1. Rezervasyon modulu
2. Online siparis kanali
3. Odeme ve kasa
4. Kampanya ve kupon
5. Sadakat programi
6. Stok uyari sistemi
7. Mutfak ekrani gelistirmesi
8. Kurye performans paneli
9. Rol ve yetki yonetimi
10. Yedekleme ve veri aktarim
   - Yonetim panelinde tek tik disa aktar / ice aktar aksiyonlari olacak.
   - JSON tabanli yedek formati surumlu ilerleyecek.
   - Felaket kurtarma ve sube tasima senaryosu desteklenecek.

## Kod Kalitesi Notlari

- Ekran dosyasi gereksiz buyurse kucuk widgetlara ayrilacak.
- Yeni ozellik once fake data ile dogrulanacak, sonra gercek servis baglantisina gecilecek.
- Loading, bos durum ve hata senaryosu eksik birakilmayacak.
- UI dogrudan veri kaynagina baglanmayacak.
- AI her seferinde tek bir ozellik veya tek bir teknik gorev icin kullanilacak.
