import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class SifreOzeti {
  const SifreOzeti({required this.hash, required this.tuz});

  final String hash;
  final String tuz;
}

class SifreOzetleyici {
  const SifreOzetleyici();

  static const int _varsayilanTuzUzunlugu = 16;

  SifreOzeti ozetOlustur(
    String sifre, {
    int tuzUzunlugu = _varsayilanTuzUzunlugu,
  }) {
    final String tuz = _rastgeleTuzUret(tuzUzunlugu);
    final String hash = _sha256('$tuz:$sifre');
    return SifreOzeti(hash: hash, tuz: tuz);
  }

  bool dogrula({
    required String sifre,
    required String hash,
    required String tuz,
  }) {
    final String hesaplanan = _sha256('$tuz:$sifre');
    return _sabitZamanliKarsilastir(hesaplanan, hash);
  }

  String _rastgeleTuzUret(int uzunluk) {
    final Random rnd = Random.secure();
    final List<int> byteDizisi = List<int>.generate(
      uzunluk,
      (_) => rnd.nextInt(256),
    );
    return base64Url.encode(byteDizisi);
  }

  String _sha256(String metin) {
    final List<int> bytes = utf8.encode(metin);
    return sha256.convert(bytes).toString();
  }

  bool _sabitZamanliKarsilastir(String sol, String sag) {
    if (sol.length != sag.length) {
      return false;
    }
    int fark = 0;
    for (int i = 0; i < sol.length; i++) {
      fark |= sol.codeUnitAt(i) ^ sag.codeUnitAt(i);
    }
    return fark == 0;
  }
}
