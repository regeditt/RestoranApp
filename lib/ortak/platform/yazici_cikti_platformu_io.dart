import 'dart:io';

import 'package:restoran_app/ortak/platform/yazici_cikti_platformu.dart';

class _YaziciCiktiPlatformuIo implements YaziciCiktiPlatformu {
  @override
  Future<bool> gonder({
    required String yaziciAdi,
    required String icerik,
  }) async {
    if (!Platform.isWindows) {
      return false;
    }

    final Directory geciciKlasor = await Directory.systemTemp.createTemp(
      'restoran_app_print_',
    );
    final File geciciDosya = File('${geciciKlasor.path}\\siparis_fisi.txt');

    try {
      await geciciDosya.writeAsString(icerik);

      final ProcessResult sonuc = await Process.run('powershell', <String>[
        '-NoProfile',
        '-Command',
        "Get-Content -LiteralPath '${geciciDosya.path}' | Out-Printer -Name '$yaziciAdi'",
      ]);

      return sonuc.exitCode == 0;
    } catch (_) {
      return false;
    } finally {
      try {
        if (await geciciDosya.exists()) {
          await geciciDosya.delete();
        }
      } catch (_) {}
      try {
        if (await geciciKlasor.exists()) {
          await geciciKlasor.delete(recursive: true);
        }
      } catch (_) {}
    }
  }
}

YaziciCiktiPlatformu yaziciCiktiPlatformuOlustur() {
  return _YaziciCiktiPlatformuIo();
}
