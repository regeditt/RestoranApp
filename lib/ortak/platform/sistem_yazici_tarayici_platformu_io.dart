import 'dart:convert';
import 'dart:io';

import 'package:restoran_app/ortak/platform/sistem_yazici_tarayici_platformu.dart';
import 'package:restoran_app/ozellikler/yonetim/alan/varliklar/sistem_yazici_adayi_varligi.dart';

class _SistemYaziciTarayiciPlatformuIo
    implements SistemYaziciTarayiciPlatformu {
  @override
  Future<List<SistemYaziciAdayiVarligi>> getir() async {
    if (!Platform.isWindows) {
      return const <SistemYaziciAdayiVarligi>[];
    }

    try {
      final ProcessResult sonuc = await Process.run('powershell', <String>[
        '-NoProfile',
        '-Command',
        r"Get-Printer | Select-Object Name,PortName | ConvertTo-Json -Compress",
      ]);

      if (sonuc.exitCode != 0) {
        return const <SistemYaziciAdayiVarligi>[];
      }

      final String ham = (sonuc.stdout as String).trim();
      if (ham.isEmpty) {
        return const <SistemYaziciAdayiVarligi>[];
      }

      final dynamic cozulen = jsonDecode(ham);
      final List<dynamic> liste = cozulen is List<dynamic>
          ? cozulen
          : <dynamic>[cozulen];

      return liste
          .whereType<Map<String, dynamic>>()
          .map(
            (veri) => SistemYaziciAdayiVarligi(
              ad: (veri['Name'] as String?) ?? 'Bilinmeyen Yazici',
              baglantiNoktasi: (veri['PortName'] as String?) ?? 'Baglanti yok',
            ),
          )
          .toList();
    } catch (_) {
      return const <SistemYaziciAdayiVarligi>[];
    }
  }
}

SistemYaziciTarayiciPlatformu sistemYaziciTarayiciPlatformuOlustur() {
  return _SistemYaziciTarayiciPlatformuIo();
}
