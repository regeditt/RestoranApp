import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:restoran_app/ortak/platform/cihaz_kimligi_saglayici.dart';

class _CihazKimligiSaglayiciIo implements CihazKimligiSaglayici {
  const _CihazKimligiSaglayiciIo();

  static final BigInt _kodUzayi = BigInt.from(2176782336); // 36^6

  @override
  String cihazKoduGetir() {
    final Map<String, String> ortam = Platform.environment;
    final String parmakIzi =
        '${Platform.operatingSystem}|'
        '${Platform.operatingSystemVersion}|'
        '${Platform.localHostname}|'
        '${ortam['COMPUTERNAME'] ?? ''}|'
        '${ortam['USERDOMAIN'] ?? ''}|'
        '${ortam['PROCESSOR_IDENTIFIER'] ?? ''}';
    final String hex = sha256.convert(utf8.encode(parmakIzi)).toString();
    final BigInt sayi = BigInt.parse(hex.substring(0, 16), radix: 16);
    final int kodDegeri = (sayi % _kodUzayi).toInt();
    return kodDegeri.toRadixString(36).padLeft(6, '0').toUpperCase();
  }
}

CihazKimligiSaglayici cihazKimligiSaglayiciOlustur() {
  return const _CihazKimligiSaglayiciIo();
}
