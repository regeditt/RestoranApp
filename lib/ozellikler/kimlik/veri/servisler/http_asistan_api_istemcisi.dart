import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/asistan_api_istemcisi.dart';

class HttpAsistanApiIstemcisi implements AsistanApiIstemcisi {
  HttpAsistanApiIstemcisi({http.Client? istemci, Duration? zamanAsimi})
    : _istemci = istemci ?? http.Client(),
      _zamanAsimi = zamanAsimi ?? const Duration(seconds: 12);

  final http.Client _istemci;
  final Duration _zamanAsimi;

  @override
  Future<bool> baglantiTestEt(String tabanUrl, {String apiAnahtari = ''}) async {
    final List<Uri> adaylar = <Uri>[
      _urlOlustur(tabanUrl, 'health'),
      _urlOlustur(tabanUrl, 'api/health'),
      _tabanUrl(tabanUrl),
    ];
    for (final Uri url in adaylar) {
      try {
        final http.Response yanit = await _istemci
            .get(
              url,
              headers: _istekBasliklari(apiAnahtari: apiAnahtari),
            )
            .timeout(_zamanAsimi);
        if (yanit.statusCode >= 200 && yanit.statusCode < 300) {
          return true;
        }
      } catch (_) {
        continue;
      }
    }
    return false;
  }

  @override
  Future<String?> yanitIste({
    required String tabanUrl,
    required String soru,
    String apiAnahtari = '',
  }) async {
    final List<Uri> adaylar = <Uri>[
      _tabanUrl(tabanUrl),
      _urlOlustur(tabanUrl, 'api/chatbot'),
      _urlOlustur(tabanUrl, 'chatbot'),
      _urlOlustur(tabanUrl, 'api/chat'),
      _urlOlustur(tabanUrl, 'chat'),
    ];

    final String istekGovdesi = jsonEncode(<String, Object?>{
      'message': soru,
      'source': 'restoran_app',
    });

    for (final Uri url in adaylar) {
      try {
        final http.Response yanit = await _istemci
            .post(
              url,
              headers: _istekBasliklari(
                apiAnahtari: apiAnahtari,
                jsonIcerik: true,
              ),
              body: istekGovdesi,
            )
            .timeout(_zamanAsimi);
        if (yanit.statusCode < 200 || yanit.statusCode >= 300) {
          final String? hataMesaji = _hataMesajiCoz(
            durumKodu: yanit.statusCode,
            govde: yanit.body,
          );
          if (hataMesaji != null && hataMesaji.trim().isNotEmpty) {
            return hataMesaji.trim();
          }
          continue;
        }
        final String? cozulmusYanit = _yanitiCoz(yanit.body);
        if (cozulmusYanit != null && cozulmusYanit.trim().isNotEmpty) {
          return cozulmusYanit.trim();
        }
      } catch (_) {
        continue;
      }
    }

    return null;
  }

  Map<String, String> _istekBasliklari({
    required String apiAnahtari,
    bool jsonIcerik = false,
  }) {
    final Map<String, String> basliklar = <String, String>{
      'Accept': jsonIcerik ? 'application/json' : '*/*',
    };
    if (jsonIcerik) {
      basliklar['Content-Type'] = 'application/json';
    }
    final String temizApiAnahtari = apiAnahtari.trim();
    if (temizApiAnahtari.isNotEmpty) {
      basliklar['Authorization'] = 'Bearer $temizApiAnahtari';
      basliklar['X-API-Key'] = temizApiAnahtari;
    }
    return basliklar;
  }

  Uri _tabanUrl(String tabanUrl) {
    final String temiz = tabanUrl.trim();
    if (temiz.startsWith('http://') || temiz.startsWith('https://')) {
      return Uri.parse(temiz);
    }
    return Uri.parse('https://$temiz');
  }

  Uri _urlOlustur(String tabanUrl, String yol) {
    return _tabanUrl(tabanUrl).resolve(yol);
  }

  String? _hataMesajiCoz({required int durumKodu, required String govde}) {
    if (durumKodu == 404 || durumKodu == 405) {
      return null;
    }
    final String? govdeMesaji = _yanitiCoz(govde);
    if (govdeMesaji != null && govdeMesaji.trim().isNotEmpty) {
      return govdeMesaji.trim();
    }
    return 'Sunucu hatasi ($durumKodu)';
  }

  String? _yanitiCoz(String govde) {
    if (govde.trim().isEmpty) {
      return null;
    }
    try {
      final dynamic cozulen = jsonDecode(govde);
      if (cozulen is String) {
        return cozulen;
      }
      if (cozulen is Map) {
        final Map<String, dynamic> harita = Map<String, dynamic>.from(cozulen);
        for (final String anahtar in const <String>[
          'reply',
          'answer',
          'message',
          'content',
          'output',
          'error',
        ]) {
          final dynamic deger = harita[anahtar];
          if (deger is String && deger.trim().isNotEmpty) {
            return deger;
          }
        }
      }
      return null;
    } catch (_) {
      return govde;
    }
  }
}
