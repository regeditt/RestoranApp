import 'package:restoran_app/ozellikler/siparis/alan/depolar/kurye_entegrasyon_deposu.dart';
import 'package:restoran_app/ozellikler/siparis/alan/varliklar/kurye_takip_entegrasyon_varliklari.dart';
import 'package:restoran_app/ozellikler/kurye_takip/providers/saglayicilar/kurye_takip_saglayici_adaptorleri.dart';
import 'package:restoran_app/ozellikler/kurye_takip/uygulama/servisler/kurye_takip_saglayici_kayit_defteri.dart';

/// Kurye takip saglayicilarini, onceliklerini ve kurye-cihaz eslesmelerini yonetir.
class KuryeEntegrasyonYonetimServisi {
  KuryeEntegrasyonYonetimServisi({
    KuryeEntegrasyonDeposu? depo,
    KuryeTakipSaglayiciKayitDefteri? saglayiciKayitDefteri,
    List<KuryeTakipSaglayiciVarligi>? baslangicSaglayicilar,
    List<KuryeCihazEslesmesiVarligi>? baslangicEslesmeler,
  }) : _depo = depo ?? const KuryeEntegrasyonDeposuBellek(),
       _saglayiciKayitDefteri =
           saglayiciKayitDefteri ?? varsayilanKuryeTakipSaglayiciKayitDefteri(),
       _saglayicilar = <KuryeTakipSaglayiciVarligi>[
         ...(baslangicSaglayicilar == null || baslangicSaglayicilar.isEmpty
             ? _varsayilanSaglayicilar
             : baslangicSaglayicilar),
       ],
       _eslesmeler = <KuryeCihazEslesmesiVarligi>[
         ...(baslangicEslesmeler ?? const <KuryeCihazEslesmesiVarligi>[]),
       ] {
    _saglayicilariSiraIleGetir();
    _saglayicilariNormalizeEt();
  }

  final KuryeEntegrasyonDeposu _depo;
  final KuryeTakipSaglayiciKayitDefteri _saglayiciKayitDefteri;
  final List<KuryeTakipSaglayiciVarligi> _saglayicilar;
  final List<KuryeCihazEslesmesiVarligi> _eslesmeler;
  bool _kaliciVeriYuklendi = false;
  Future<void>? _hazirlamaIslemi;

  Future<List<KuryeTakipSaglayiciVarligi>> saglayicilariGetir() async {
    await _hazirla();
    _saglayicilariNormalizeEt();
    return _saglayicilar.map((kayit) => kayit.copyWith()).toList();
  }

  Future<List<KuryeCihazEslesmesiVarligi>>
  kuryeCihazEslesmeleriniGetir() async {
    await _hazirla();
    final List<KuryeCihazEslesmesiVarligi> sirali =
        _eslesmeler.map((kayit) => kayit.copyWith()).toList()..sort(
          (a, b) =>
              a.kuryeAdi.toLowerCase().compareTo(b.kuryeAdi.toLowerCase()),
        );
    return sirali;
  }

  Future<void> saglayiciKaydet(KuryeTakipSaglayiciVarligi saglayici) async {
    await _hazirla();
    final int index = _saglayicilar.indexWhere(
      (kayit) => kayit.id == saglayici.id,
    );
    if (index < 0) {
      _saglayicilar.add(saglayici);
    } else {
      _saglayicilar[index] = saglayici;
    }

    if (saglayici.aktifMi) {
      _saglayicilarDigerleriniPasifYap(saglayici.id);
    }
    _saglayicilariSiraIleGetir();
    _saglayicilariNormalizeEt();
    await _kaliciVeriyiKaydet();
  }

  Future<void> saglayiciSil(String saglayiciId) async {
    await _hazirla();
    _saglayicilar.removeWhere((kayit) => kayit.id == saglayiciId);
    _eslesmeler.removeWhere((kayit) => kayit.saglayiciId == saglayiciId);
    _saglayicilariNormalizeEt();
    await _kaliciVeriyiKaydet();
  }

  Future<void> aktifSaglayiciYap(String saglayiciId) async {
    await _hazirla();
    for (int i = 0; i < _saglayicilar.length; i++) {
      final KuryeTakipSaglayiciVarligi kayit = _saglayicilar[i];
      _saglayicilar[i] = kayit.copyWith(aktifMi: kayit.id == saglayiciId);
    }
    _saglayicilariNormalizeEt();
    await _kaliciVeriyiKaydet();
  }

  Future<void> saglayiciOnceligiDegistir({
    required String saglayiciId,
    required bool yukari,
  }) async {
    await _hazirla();
    _saglayicilariSiraIleGetir();
    final int index = _saglayicilar.indexWhere(
      (kayit) => kayit.id == saglayiciId,
    );
    if (index < 0) {
      return;
    }
    final int yeniIndex = yukari ? index - 1 : index + 1;
    if (yeniIndex < 0 || yeniIndex >= _saglayicilar.length) {
      return;
    }
    final KuryeTakipSaglayiciVarligi tasinan = _saglayicilar.removeAt(index);
    _saglayicilar.insert(yeniIndex, tasinan);
    _saglayicilariNormalizeEt();
    await _kaliciVeriyiKaydet();
  }

  Future<void> kuryeCihazEslesmesiKaydet(
    KuryeCihazEslesmesiVarligi eslesme,
  ) async {
    await _hazirla();
    final bool saglayiciVar = _saglayicilar.any(
      (kayit) => kayit.id == eslesme.saglayiciId,
    );
    if (!saglayiciVar) {
      throw StateError('Secilen saglayici bulunamadi.');
    }

    final int index = _eslesmeler.indexWhere(
      (kayit) => kayit.kuryeAdi.toLowerCase() == eslesme.kuryeAdi.toLowerCase(),
    );
    if (index < 0) {
      _eslesmeler.add(eslesme);
    } else {
      _eslesmeler[index] = eslesme;
    }
    await _kaliciVeriyiKaydet();
  }

  Future<void> kuryeCihazEslesmesiSil(String kuryeAdi) async {
    await _hazirla();
    _eslesmeler.removeWhere(
      (kayit) => kayit.kuryeAdi.toLowerCase() == kuryeAdi.toLowerCase(),
    );
    await _kaliciVeriyiKaydet();
  }

  Future<KuryeSaglayiciTestSonucu> baglantiTestEt(String saglayiciId) async {
    await _hazirla();
    final KuryeTakipSaglayiciVarligi? saglayici = _saglayicilar
        .cast<KuryeTakipSaglayiciVarligi?>()
        .firstWhere((kayit) => kayit?.id == saglayiciId, orElse: () => null);
    if (saglayici == null) {
      return const KuryeSaglayiciTestSonucu.hata('Saglayici bulunamadi.');
    }
    final saglayiciAdaptoru = _saglayiciKayitDefteri.getir(saglayici.tur);
    if (saglayiciAdaptoru == null) {
      return const KuryeSaglayiciTestSonucu.hata(
        'Secilen saglayici tipi icin adaptor bulunamadi.',
      );
    }
    return saglayiciAdaptoru.baglantiTestEt(saglayici);
  }

  Future<String?> kuryeTakipKimligiGetir(String kuryeAdi) async {
    await _hazirla();
    final String temizKuryeAdi = kuryeAdi.trim();
    if (temizKuryeAdi.isEmpty) {
      return null;
    }
    final KuryeCihazEslesmesiVarligi? eslesme = _eslesmeler
        .cast<KuryeCihazEslesmesiVarligi?>()
        .firstWhere(
          (kayit) =>
              kayit != null &&
              kayit.aktifMi &&
              kayit.kuryeAdi.toLowerCase() == temizKuryeAdi.toLowerCase(),
          orElse: () => null,
        );
    if (eslesme == null) {
      return null;
    }
    final KuryeTakipSaglayiciVarligi? saglayici = _saglayicilar
        .cast<KuryeTakipSaglayiciVarligi?>()
        .firstWhere(
          (kayit) => kayit?.id == eslesme.saglayiciId,
          orElse: () => null,
        );
    if (saglayici == null || !saglayici.aktifMi) {
      return null;
    }
    final String cihazKimligi = eslesme.cihazKimligi.trim();
    if (cihazKimligi.isEmpty) {
      return null;
    }
    final saglayiciAdaptoru = _saglayiciKayitDefteri.getir(saglayici.tur);
    if (saglayiciAdaptoru == null) {
      return null;
    }
    return saglayiciAdaptoru.takipKimligiUret(
      saglayici: saglayici,
      eslesme: eslesme,
    );
  }

  Future<void> _hazirla() async {
    if (_kaliciVeriYuklendi) {
      return;
    }
    final Future<void> calisma = _hazirlamaIslemi ?? _kaliciVeriyiYukle();
    _hazirlamaIslemi = calisma;
    await calisma;
  }

  Future<void> _kaliciVeriyiYukle() async {
    try {
      final KuryeEntegrasyonDepoKaydi? kayit = await _depo.yukle();
      if (kayit != null) {
        if (kayit.saglayicilar.isNotEmpty) {
          _saglayicilar
            ..clear()
            ..addAll(kayit.saglayicilar);
        }
        _eslesmeler
          ..clear()
          ..addAll(kayit.eslesmeler);
        _eksikVarsayilanSaglayicilariEkle();
      }
    } catch (_) {
      // Kalici veri okunamazsa bellekteki baslangic verisiyle devam edilir.
    } finally {
      _saglayicilariSiraIleGetir();
      _saglayicilariNormalizeEt();
      _kaliciVeriYuklendi = true;
      _hazirlamaIslemi = null;
    }
    await _kaliciVeriyiKaydet();
  }

  Future<void> _kaliciVeriyiKaydet() async {
    if (!_kaliciVeriYuklendi) {
      return;
    }
    await _depo.kaydet(
      KuryeEntegrasyonDepoKaydi(
        saglayicilar: _saglayicilar.map((kayit) => kayit.copyWith()).toList(),
        eslesmeler: _eslesmeler.map((kayit) => kayit.copyWith()).toList(),
      ),
    );
  }

  void _saglayicilariNormalizeEt() {
    for (int i = 0; i < _saglayicilar.length; i++) {
      _saglayicilar[i] = _saglayicilar[i].copyWith(oncelik: i + 1);
    }
    final int aktifSayisi = _saglayicilar
        .where((kayit) => kayit.aktifMi)
        .length;
    if (_saglayicilar.isNotEmpty && aktifSayisi == 0) {
      _saglayicilar[0] = _saglayicilar[0].copyWith(aktifMi: true);
    } else if (aktifSayisi > 1) {
      bool ilkAktifBulundu = false;
      for (int i = 0; i < _saglayicilar.length; i++) {
        final KuryeTakipSaglayiciVarligi kayit = _saglayicilar[i];
        if (kayit.aktifMi && !ilkAktifBulundu) {
          ilkAktifBulundu = true;
          continue;
        }
        if (kayit.aktifMi) {
          _saglayicilar[i] = kayit.copyWith(aktifMi: false);
        }
      }
    }
  }

  void _saglayicilarDigerleriniPasifYap(String aktifSaglayiciId) {
    for (int i = 0; i < _saglayicilar.length; i++) {
      final KuryeTakipSaglayiciVarligi kayit = _saglayicilar[i];
      _saglayicilar[i] = kayit.copyWith(aktifMi: kayit.id == aktifSaglayiciId);
    }
  }

  void _eksikVarsayilanSaglayicilariEkle() {
    final Set<String> mevcutKimlikler = _saglayicilar
        .map((saglayici) => saglayici.id)
        .toSet();
    for (final KuryeTakipSaglayiciVarligi varsayilan
        in _varsayilanSaglayicilar) {
      if (mevcutKimlikler.contains(varsayilan.id)) {
        continue;
      }
      _saglayicilar.add(
        varsayilan.copyWith(oncelik: _saglayicilar.length + 1, aktifMi: false),
      );
      mevcutKimlikler.add(varsayilan.id);
    }
  }

  void _saglayicilariSiraIleGetir() {
    _saglayicilar.sort((a, b) => a.oncelik.compareTo(b.oncelik));
  }
}

final KuryeEntegrasyonYonetimServisi kuryeEntegrasyonYonetimServisi =
    KuryeEntegrasyonYonetimServisi();

const List<KuryeTakipSaglayiciVarligi> _varsayilanSaglayicilar =
    <KuryeTakipSaglayiciVarligi>[
      KuryeTakipSaglayiciVarligi(
        id: 'sgl_dahili',
        ad: 'Dahili Cihaz GPS',
        tur: KuryeTakipSaglayiciTuru.dahiliGps,
        apiTabanUrl: 'https://lokal-cihaz-gps',
        apiAnahtari: 'cihaz-izinli',
        aktifMi: true,
        oncelik: 1,
        aciklama: 'Kurye telefonunun dahili GPS akisindan konum alir.',
      ),
      KuryeTakipSaglayiciVarligi(
        id: 'sgl_traccar',
        ad: 'Traccar',
        tur: KuryeTakipSaglayiciTuru.traccar,
        apiTabanUrl: 'https://api.traccar.ornek',
        apiAnahtari: 'traccar-api-key',
        aktifMi: false,
        oncelik: 2,
        aciklama: 'Traccar tabanli cihaz ve filo konum verisini kullanir.',
      ),
      KuryeTakipSaglayiciVarligi(
        id: 'sgl_navix',
        ad: 'Navix',
        tur: KuryeTakipSaglayiciTuru.navixy,
        apiTabanUrl: 'https://api.navix.ornek',
        apiAnahtari: 'navix-api-key',
        aktifMi: false,
        oncelik: 3,
        aciklama: 'Navix entegrasyonu ile kurye cihaz konumlarini alir.',
      ),
      KuryeTakipSaglayiciVarligi(
        id: 'sgl_turk_1',
        ad: 'Arvento',
        tur: KuryeTakipSaglayiciTuru.turkSaglayici1,
        apiTabanUrl: 'https://api.arvento.com',
        apiAnahtari: 'arvento-api-key',
        aktifMi: false,
        oncelik: 4,
        aciklama: 'Arvento entegrasyon kaydi.',
      ),
      KuryeTakipSaglayiciVarligi(
        id: 'sgl_turk_2',
        ad: 'Mobiliz',
        tur: KuryeTakipSaglayiciTuru.turkSaglayici2,
        apiTabanUrl: 'https://api.mobiliz.com.tr',
        apiAnahtari: 'mobiliz-api-key',
        aktifMi: false,
        oncelik: 5,
        aciklama: 'Mobiliz entegrasyon kaydi.',
      ),
      KuryeTakipSaglayiciVarligi(
        id: 'sgl_turk_3',
        ad: 'Seyir Mobil',
        tur: KuryeTakipSaglayiciTuru.turkSaglayici3,
        apiTabanUrl: 'https://api.seyirmobil.com',
        apiAnahtari: 'seyir-api-key',
        aktifMi: false,
        oncelik: 6,
        aciklama: 'Seyir Mobil entegrasyon kaydi.',
      ),
      KuryeTakipSaglayiciVarligi(
        id: 'sgl_turk_4',
        ad: 'Trio Mobil',
        tur: KuryeTakipSaglayiciTuru.turkSaglayici4,
        apiTabanUrl: 'https://api.triomobil.com',
        apiAnahtari: 'trio-api-key',
        aktifMi: false,
        oncelik: 7,
        aciklama: 'Trio Mobil entegrasyon kaydi.',
      ),
      KuryeTakipSaglayiciVarligi(
        id: 'sgl_turk_5',
        ad: 'TakipOn',
        tur: KuryeTakipSaglayiciTuru.turkSaglayici5,
        apiTabanUrl: 'https://api.takipon.com',
        apiAnahtari: 'takipon-api-key',
        aktifMi: false,
        oncelik: 8,
        aciklama: 'TakipOn entegrasyon kaydi.',
      ),
    ];
