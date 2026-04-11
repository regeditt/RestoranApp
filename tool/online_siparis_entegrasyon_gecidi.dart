import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

Future<void> main(List<String> args) async {
  final EntegrasyonGecidiAyarlari ayarlar =
      EntegrasyonGecidiAyarlari.ortamdan();
  final SiparisDepolama depolama = SiparisDepolama(ayarlar.veriDiziniYolu);
  await depolama.hazirla();

  final HttpServer sunucu = await HttpServer.bind(ayarlar.host, ayarlar.port);
  stdout.writeln(
    'Online Siparis Entegrasyon Gecidi calisiyor: http://${ayarlar.host}:${ayarlar.port}',
  );
  stdout.writeln('Veri dizini: ${ayarlar.veriDiziniYolu}');

  await for (final HttpRequest istek in sunucu) {
    await _istegiIsle(istek, ayarlar, depolama);
  }
}

Future<void> _istegiIsle(
  HttpRequest istek,
  EntegrasyonGecidiAyarlari ayarlar,
  SiparisDepolama depolama,
) async {
  try {
    _corsBasliklariAyarla(istek.response);
    if (istek.method == 'OPTIONS') {
      istek.response.statusCode = HttpStatus.noContent;
      await istek.response.close();
      return;
    }

    final String yol = istek.uri.path;
    if (istek.method == 'GET' && yol == '/health') {
      _jsonYanit(istek.response, HttpStatus.ok, <String, dynamic>{
        'ok': true,
        'sunucuSaati': DateTime.now().toIso8601String(),
      });
      await istek.response.close();
      return;
    }

    if (istek.method == 'GET' && yol == '/api/orders/pending') {
      final List<Map<String, dynamic>> siparisler = await depolama
          .bekleyenSiparisleriGetir();
      _jsonYanit(istek.response, HttpStatus.ok, <String, dynamic>{
        'adet': siparisler.length,
        'siparisler': siparisler,
      });
      await istek.response.close();
      return;
    }

    if (istek.method == 'POST' && yol == '/api/orders/ack') {
      final Map<String, dynamic>? govde = await _jsonGovdeOku(istek);
      final List<dynamic> idlerHam =
          (govde?['ids'] as List<dynamic>?) ?? <dynamic>[];
      final List<String> idler = idlerHam
          .map((dynamic deger) => '$deger'.trim())
          .where((String deger) => deger.isNotEmpty)
          .toList(growable: false);
      final int temizlenenAdet = await depolama.siparisleriOnayla(idler);
      _jsonYanit(istek.response, HttpStatus.ok, <String, dynamic>{
        'ok': true,
        'temizlenenAdet': temizlenenAdet,
      });
      await istek.response.close();
      return;
    }

    if (istek.method == 'POST' && _webhookYoluMu(yol)) {
      final String platformKodu = _platformKoduGetir(yol);
      final String gizliAnahtar = ayarlar.gizliAnahtarGetir(platformKodu);
      if (gizliAnahtar.isEmpty) {
        _jsonYanit(
          istek.response,
          HttpStatus.serviceUnavailable,
          <String, dynamic>{
            'ok': false,
            'hata': '$platformKodu gizli anahtari tanimli degil.',
          },
        );
        await istek.response.close();
        return;
      }

      final List<int> govdeBaytlari = await istek.fold<List<int>>(
        <int>[],
        (List<int> onceki, List<int> parcacik) => onceki..addAll(parcacik),
      );
      final String? imza = _imzaBasligiGetir(istek, platformKodu);
      final bool gecerliImza = _imzaGecerliMi(
        imza: imza,
        govdeBaytlari: govdeBaytlari,
        gizliAnahtar: gizliAnahtar,
      );
      if (!gecerliImza) {
        _jsonYanit(istek.response, HttpStatus.unauthorized, <String, dynamic>{
          'ok': false,
          'hata': 'Imza dogrulama basarisiz.',
        });
        await istek.response.close();
        return;
      }

      final Object? govdeJson = jsonDecode(utf8.decode(govdeBaytlari));
      if (govdeJson is! Map<String, dynamic>) {
        _jsonYanit(
          istek.response,
          HttpStatus.unprocessableEntity,
          <String, dynamic>{'ok': false, 'hata': 'JSON nesnesi bekleniyor.'},
        );
        await istek.response.close();
        return;
      }

      final Map<String, dynamic>? normallesmis = _siparisiNormallestir(
        platformKodu: platformKodu,
        hamVeri: govdeJson,
      );
      if (normallesmis == null) {
        _jsonYanit(
          istek.response,
          HttpStatus.unprocessableEntity,
          <String, dynamic>{
            'ok': false,
            'hata': 'Siparis verisi cozumlenemedi.',
          },
        );
        await istek.response.close();
        return;
      }

      await depolama.yeniSiparisKaydet(normallesmis, govdeJson);
      _jsonYanit(istek.response, HttpStatus.accepted, <String, dynamic>{
        'ok': true,
        'id': normallesmis['id'],
      });
      await istek.response.close();
      return;
    }

    _jsonYanit(istek.response, HttpStatus.notFound, <String, dynamic>{
      'ok': false,
      'hata': 'Rota bulunamadi.',
    });
    await istek.response.close();
  } catch (hata, iz) {
    stderr.writeln('Istek isleme hatasi: $hata');
    stderr.writeln(iz);
    _jsonYanit(
      istek.response,
      HttpStatus.internalServerError,
      <String, dynamic>{'ok': false, 'hata': 'Beklenmeyen sunucu hatasi.'},
    );
    await istek.response.close();
  }
}

bool _webhookYoluMu(String yol) {
  return RegExp(r'^/webhook/[a-zA-Z0-9_-]+$').hasMatch(yol);
}

String _platformKoduGetir(String yol) {
  final List<String> parcaciklar = yol.split('/');
  if (parcaciklar.length < 3) {
    return '';
  }
  return parcaciklar.last.trim().toLowerCase();
}

String _kaynakEtiketi(String platformKodu) {
  final String normalize = platformKodu.trim().toLowerCase();
  if (normalize.isEmpty) {
    return 'Diger';
  }
  if (normalize == 'yemeksepeti') return 'Yemeksepeti';
  if (normalize == 'getir') return 'Getir';
  if (normalize == 'trendyol') return 'Trendyol';
  final List<String> parcalar = normalize.split(RegExp(r'[_-]+'));
  return parcalar
      .where((parca) => parca.isNotEmpty)
      .map((parca) => parca[0].toUpperCase() + parca.substring(1))
      .join(' ');
}

String? _imzaBasligiGetir(HttpRequest istek, String platformKodu) {
  final String normalize = platformKodu.trim().toLowerCase();
  final List<String> adaylar = <String>[
    'x-signature',
    if (normalize.isNotEmpty) 'x-$normalize-signature',
    if (normalize.isNotEmpty) 'x-$normalize-hmac',
  ];

  for (final String baslik in adaylar) {
    final String? deger = istek.headers.value(baslik);
    if (deger != null && deger.trim().isNotEmpty) {
      return deger.trim();
    }
  }
  return null;
}

bool _imzaGecerliMi({
  required String? imza,
  required List<int> govdeBaytlari,
  required String gizliAnahtar,
}) {
  if (imza == null || imza.isEmpty) {
    return false;
  }
  final Digest ozet = Hmac(
    sha256,
    utf8.encode(gizliAnahtar),
  ).convert(govdeBaytlari);
  final String hexImza = ozet.toString();
  final String base64Imza = base64Encode(ozet.bytes);
  final String normalize = imza
      .trim()
      .replaceFirst(RegExp(r'^sha256=', caseSensitive: false), '')
      .replaceAll(' ', '');
  return _sabitZamanliEslesir(normalize.toLowerCase(), hexImza.toLowerCase()) ||
      _sabitZamanliEslesir(normalize, base64Imza);
}

bool _sabitZamanliEslesir(String a, String b) {
  if (a.length != b.length) {
    return false;
  }
  int fark = 0;
  for (int i = 0; i < a.length; i++) {
    fark |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return fark == 0;
}

Future<Map<String, dynamic>?> _jsonGovdeOku(HttpRequest istek) async {
  final String govde = await utf8.decoder.bind(istek).join();
  if (govde.trim().isEmpty) {
    return <String, dynamic>{};
  }
  final Object? jsonNesnesi = jsonDecode(govde);
  if (jsonNesnesi is Map<String, dynamic>) {
    return jsonNesnesi;
  }
  return null;
}

Map<String, dynamic>? _siparisiNormallestir({
  required String platformKodu,
  required Map<String, dynamic> hamVeri,
}) {
  final String kaynak = _kaynakEtiketi(platformKodu);
  final String? platformSiparisId = _degerOkuMetin(hamVeri, <String>[
    'order.id',
    'order.orderId',
    'order.code',
    'order.number',
    'orderNumber',
    'orderId',
    'id',
  ]);
  if (platformSiparisId == null || platformSiparisId.isEmpty) {
    return null;
  }

  final List<Map<String, dynamic>> kalemler = _kalemleriNormallestir(hamVeri);
  final double toplamTutar =
      _degerOkuDouble(hamVeri, <String>[
        'order.totalPrice',
        'order.totalAmount',
        'payment.total',
        'totalPrice',
        'totalAmount',
        'total',
      ]) ??
      kalemler.fold<double>(
        0,
        (double onceki, Map<String, dynamic> kalem) =>
            onceki + ((kalem['lineTotal'] as num?)?.toDouble() ?? 0),
      );

  final DateTime olusturmaTarihi =
      _degerOkuTarih(hamVeri, <String>[
        'createdAt',
        'order.createdAt',
        'orderDate',
      ]) ??
      DateTime.now().toUtc();

  final String siparisKimligi = '${platformKodu}_$platformSiparisId';
  final String siparisNo = 'ONL-${platformSiparisId.toUpperCase()}';

  return <String, dynamic>{
    'id': siparisKimligi,
    'platform': platformKodu,
    'platformOrderId': platformSiparisId,
    'siparisNo': siparisNo,
    'kaynak': kaynak,
    'durum': 'alindi',
    'teslimatTipi': _teslimatTipiBelirle(hamVeri),
    'musteri': <String, dynamic>{
      'adSoyad':
          _degerOkuMetin(hamVeri, <String>[
            'customer.name',
            'customer.fullName',
            'delivery.customerName',
            'buyer.fullName',
            'buyer.name',
          ]) ??
          'Misafir',
      'telefon':
          _degerOkuMetin(hamVeri, <String>[
            'customer.phone',
            'delivery.phone',
            'buyer.phone',
            'phone',
          ]) ??
          '',
    },
    'adresMetni': _degerOkuMetin(hamVeri, <String>[
      'delivery.address',
      'delivery.fullAddress',
      'address.fullAddress',
      'address',
    ]),
    'teslimatNotu': _degerOkuMetin(hamVeri, <String>[
      'delivery.note',
      'note',
      'notes',
      'order.note',
    ]),
    'toplamTutar': toplamTutar,
    'paraBirimi':
        _degerOkuMetin(hamVeri, <String>['currency', 'order.currency']) ??
        'TRY',
    'olusturmaTarihi': olusturmaTarihi.toIso8601String(),
    'kalemler': kalemler,
  };
}

List<Map<String, dynamic>> _kalemleriNormallestir(
  Map<String, dynamic> hamVeri,
) {
  final List<dynamic> hamKalemler =
      _degerOkuListe(hamVeri, <String>[
        'order.items',
        'items',
        'products',
        'order.lines',
        'lines',
      ]) ??
      <dynamic>[];

  final List<Map<String, dynamic>> sonuc = <Map<String, dynamic>>[];
  int sira = 1;
  for (final dynamic hamKalem in hamKalemler) {
    if (hamKalem is! Map<String, dynamic>) {
      continue;
    }
    final String ad =
        _degerOkuMetin(hamKalem, <String>[
          'name',
          'productName',
          'title',
          'itemName',
        ]) ??
        'Urun $sira';
    final double adet =
        _degerOkuDouble(hamKalem, <String>[
          'quantity',
          'qty',
          'count',
          'amount',
        ]) ??
        1;
    final double birimFiyat =
        _degerOkuDouble(hamKalem, <String>['unitPrice', 'price', 'amount']) ??
        0;
    final double araToplam =
        _degerOkuDouble(hamKalem, <String>[
          'lineTotal',
          'totalPrice',
          'total',
          'subtotal',
        ]) ??
        (adet * birimFiyat);

    sonuc.add(<String, dynamic>{
      'id': 'kalem_$sira',
      'urunAdi': ad,
      'adet': adet,
      'birimFiyat': birimFiyat,
      'lineTotal': araToplam,
    });
    sira++;
  }
  return sonuc;
}

String _teslimatTipiBelirle(Map<String, dynamic> hamVeri) {
  final String? teslimatTuru = _degerOkuMetin(hamVeri, <String>[
    'delivery.type',
    'deliveryType',
    'order.deliveryType',
    'fulfillment.type',
  ]);
  final String tur = (teslimatTuru ?? '').toLowerCase();
  if (tur.contains('pickup') ||
      tur.contains('gelal') ||
      tur.contains('takeaway')) {
    return 'gelAl';
  }
  if (tur.contains('dinein') || tur.contains('restorandaye')) {
    return 'restorandaYe';
  }
  return 'paketServis';
}

String? _degerOkuMetin(Map<String, dynamic> kok, List<String> yollar) {
  for (final String yol in yollar) {
    final Object? deger = _yolDegeriGetir(kok, yol);
    if (deger == null) {
      continue;
    }
    final String metin = '$deger'.trim();
    if (metin.isNotEmpty) {
      return metin;
    }
  }
  return null;
}

double? _degerOkuDouble(Map<String, dynamic> kok, List<String> yollar) {
  for (final String yol in yollar) {
    final Object? deger = _yolDegeriGetir(kok, yol);
    if (deger == null) {
      continue;
    }
    if (deger is num) {
      return deger.toDouble();
    }
    final double? parsed = double.tryParse('$deger');
    if (parsed != null) {
      return parsed;
    }
  }
  return null;
}

DateTime? _degerOkuTarih(Map<String, dynamic> kok, List<String> yollar) {
  for (final String yol in yollar) {
    final Object? deger = _yolDegeriGetir(kok, yol);
    if (deger == null) {
      continue;
    }
    if (deger is String) {
      final DateTime? parsed = DateTime.tryParse(deger);
      if (parsed != null) {
        return parsed.toUtc();
      }
    }
    if (deger is int) {
      final DateTime tarih = DateTime.fromMillisecondsSinceEpoch(
        deger > 9999999999 ? deger : deger * 1000,
        isUtc: true,
      );
      return tarih;
    }
  }
  return null;
}

List<dynamic>? _degerOkuListe(Map<String, dynamic> kok, List<String> yollar) {
  for (final String yol in yollar) {
    final Object? deger = _yolDegeriGetir(kok, yol);
    if (deger is List<dynamic>) {
      return deger;
    }
  }
  return null;
}

Object? _yolDegeriGetir(Map<String, dynamic> kok, String yol) {
  Object? aktif = kok;
  for (final String parcacik in yol.split('.')) {
    if (aktif is Map<String, dynamic>) {
      if (!aktif.containsKey(parcacik)) {
        return null;
      }
      aktif = aktif[parcacik];
      continue;
    }
    return null;
  }
  return aktif;
}

void _jsonYanit(HttpResponse yanit, int durumKodu, Map<String, dynamic> govde) {
  yanit.statusCode = durumKodu;
  yanit.headers.contentType = ContentType.json;
  yanit.write(jsonEncode(govde));
}

void _corsBasliklariAyarla(HttpResponse yanit) {
  yanit.headers.set('Access-Control-Allow-Origin', '*');
  yanit.headers.set('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
  yanit.headers.set('Access-Control-Allow-Headers', '*');
}

class EntegrasyonGecidiAyarlari {
  EntegrasyonGecidiAyarlari({
    required this.host,
    required this.port,
    required this.veriDiziniYolu,
    required this.platformGizliAnahtarlari,
  });

  factory EntegrasyonGecidiAyarlari.ortamdan() {
    final Map<String, String> env = Platform.environment;
    final Map<String, String> platformGizliAnahtarlari = <String, String>{};

    final String jsonGizliAnahtarlar =
        env['ONLINE_WEBHOOK_SECRETS_JSON']?.trim() ?? '';
    if (jsonGizliAnahtarlar.isNotEmpty) {
      try {
        final Object? jsonNesnesi = jsonDecode(jsonGizliAnahtarlar);
        if (jsonNesnesi is Map<String, dynamic>) {
          for (final MapEntry<String, dynamic> kayit in jsonNesnesi.entries) {
            final String platform = _platformKodunuNormalizeEt(kayit.key);
            final String secret = '${kayit.value}'.trim();
            if (platform.isNotEmpty && secret.isNotEmpty) {
              platformGizliAnahtarlari[platform] = secret;
            }
          }
        }
      } catch (_) {}
    }

    final String yemeksepetiSecret = env['YEMEKSEPETI_WEBHOOK_SECRET'] ?? '';
    final String getirSecret = env['GETIR_WEBHOOK_SECRET'] ?? '';
    final String trendyolSecret = env['TRENDYOL_WEBHOOK_SECRET'] ?? '';
    if (yemeksepetiSecret.trim().isNotEmpty) {
      platformGizliAnahtarlari['yemeksepeti'] = yemeksepetiSecret.trim();
    }
    if (getirSecret.trim().isNotEmpty) {
      platformGizliAnahtarlari['getir'] = getirSecret.trim();
    }
    if (trendyolSecret.trim().isNotEmpty) {
      platformGizliAnahtarlari['trendyol'] = trendyolSecret.trim();
    }

    return EntegrasyonGecidiAyarlari(
      host: env['INTEGRATION_GATEWAY_HOST'] ?? '127.0.0.1',
      port: int.tryParse(env['INTEGRATION_GATEWAY_PORT'] ?? '') ?? 8787,
      veriDiziniYolu:
          env['INTEGRATION_GATEWAY_DATA_DIR'] ?? 'integration_gateway/data',
      platformGizliAnahtarlari: platformGizliAnahtarlari,
    );
  }

  final String host;
  final int port;
  final String veriDiziniYolu;
  final Map<String, String> platformGizliAnahtarlari;

  String gizliAnahtarGetir(String platformKodu) {
    final String normalize = _platformKodunuNormalizeEt(platformKodu);
    return platformGizliAnahtarlari[normalize] ?? '';
  }

  static String _platformKodunuNormalizeEt(String platformKodu) {
    return platformKodu.trim().toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9_-]+'),
      '',
    );
  }
}

class SiparisDepolama {
  SiparisDepolama(this.veriDiziniYolu);

  final String veriDiziniYolu;

  late final Directory _veriDizini = Directory(veriDiziniYolu);
  late final File _bekleyenSiparisDosyasi = File(
    '${_veriDizini.path}${Platform.pathSeparator}pending_orders.json',
  );
  late final File _olayGunluguDosyasi = File(
    '${_veriDizini.path}${Platform.pathSeparator}order_events.jsonl',
  );

  Future<void> hazirla() async {
    if (!await _veriDizini.exists()) {
      await _veriDizini.create(recursive: true);
    }
    if (!await _bekleyenSiparisDosyasi.exists()) {
      await _bekleyenSiparisDosyasi.writeAsString('[]');
    }
    if (!await _olayGunluguDosyasi.exists()) {
      await _olayGunluguDosyasi.writeAsString('');
    }
  }

  Future<List<Map<String, dynamic>>> bekleyenSiparisleriGetir() async {
    final String metin = await _bekleyenSiparisDosyasi.readAsString();
    final Object? jsonNesnesi = jsonDecode(metin);
    if (jsonNesnesi is! List<dynamic>) {
      return <Map<String, dynamic>>[];
    }
    return jsonNesnesi
        .whereType<Map<String, dynamic>>()
        .map((Map<String, dynamic> satir) => Map<String, dynamic>.from(satir))
        .toList();
  }

  Future<void> yeniSiparisKaydet(
    Map<String, dynamic> siparis,
    Map<String, dynamic> hamPayload,
  ) async {
    final List<Map<String, dynamic>> bekleyenler =
        await bekleyenSiparisleriGetir();
    final String id = '${siparis['id']}';
    final int mevcutIndex = bekleyenler.indexWhere(
      (Map<String, dynamic> kayit) => '${kayit['id']}' == id,
    );

    final Map<String, dynamic> kayit = <String, dynamic>{
      ...siparis,
      'alindigiZaman': DateTime.now().toUtc().toIso8601String(),
      'ham': hamPayload,
    };

    if (mevcutIndex >= 0) {
      bekleyenler[mevcutIndex] = kayit;
    } else {
      bekleyenler.add(kayit);
    }

    await _jsonDosyasiniYaz(_bekleyenSiparisDosyasi, bekleyenler);
    await _olayYaz(<String, dynamic>{
      'olay': 'yeni_siparis',
      'zaman': DateTime.now().toUtc().toIso8601String(),
      'id': id,
      'platform': siparis['platform'],
      'platformOrderId': siparis['platformOrderId'],
    });
  }

  Future<int> siparisleriOnayla(List<String> idler) async {
    if (idler.isEmpty) {
      return 0;
    }
    final Set<String> onaySeti = idler.toSet();
    final List<Map<String, dynamic>> bekleyenler =
        await bekleyenSiparisleriGetir();
    final int oncekiAdet = bekleyenler.length;
    bekleyenler.removeWhere(
      (Map<String, dynamic> kayit) => onaySeti.contains('${kayit['id']}'),
    );
    final int temizlenen = oncekiAdet - bekleyenler.length;
    await _jsonDosyasiniYaz(_bekleyenSiparisDosyasi, bekleyenler);
    if (temizlenen > 0) {
      await _olayYaz(<String, dynamic>{
        'olay': 'onaylandi',
        'zaman': DateTime.now().toUtc().toIso8601String(),
        'adet': temizlenen,
        'ids': idler,
      });
    }
    return temizlenen;
  }

  Future<void> _jsonDosyasiniYaz(File dosya, Object jsonNesnesi) async {
    final File gecici = File('${dosya.path}.tmp');
    final String metin = const JsonEncoder.withIndent(
      '  ',
    ).convert(jsonNesnesi);
    await gecici.writeAsString(metin);
    if (await dosya.exists()) {
      await dosya.delete();
    }
    await gecici.rename(dosya.path);
  }

  Future<void> _olayYaz(Map<String, dynamic> olay) async {
    await _olayGunluguDosyasi.writeAsString(
      '${jsonEncode(olay)}\n',
      mode: FileMode.append,
    );
  }
}
