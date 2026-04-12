import 'package:flutter/material.dart';

/// Uygulamanin tum ekranlarinda kullanilan ana sayfa renk sablonu.
abstract final class AnaSayfaRenkSablonu {
  static const Color arkaPlanKoyu = Color(0xFF120728);
  static const Color arkaPlanOrta = Color(0xFF2A0D4A);
  static const Color arkaPlanUst = Color(0xFF3A0F63);

  static const Color panelKoyu = Color(0xFF25113F);
  static const Color panelYuksek = Color(0xFF31195A);
  static const Color panelAlarm = Color(0xFF43173B);
  static const Color panelBasari = Color(0xFF173A2D);

  static const Color birincilAksiyon = Color(0xFFE62D7A);
  static const Color ikincilAksiyon = Color(0xFF7A3DFF);
  static const Color ucunculAksiyon = Color(0xFFB06CFF);
  static const Color basari = Color(0xFF2DBE63);
  static const Color bilgilendirici = Color(0xFF58A3FF);
  static const Color uyari = Color(0xFFFFD36E);

  static const Color metinAna = Colors.white;
  static const Color metinIkincil = Color(0xFFD6C9EA);
  static const Color metinAcikZemin = Color(0xFF2D2140);
  static const Color metinAcikZeminIkincil = Color(0xFF6D6079);
  static const Color cerceve = Color(0x33FFFFFF);

  static const LinearGradient anaArkaPlanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[arkaPlanUst, arkaPlanOrta, arkaPlanKoyu],
  );

  static const LinearGradient panelVurguGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[birincilAksiyon, ikincilAksiyon, arkaPlanKoyu],
  );

  static const LinearGradient icYuzeyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[panelYuksek, panelKoyu],
  );

  /// Acik/koyu zemin farkina gore otomatik kontrastli metin rengi secer.
  static Color kontrastliMetinRengi(Color zemin) {
    return zemin.computeLuminance() > 0.55 ? metinAcikZemin : metinAna;
  }

  /// Gri/siyah yerine tematik golge tonu kullan.
  static Color tematikGolge(double alpha) =>
      arkaPlanKoyu.withValues(alpha: alpha);
}
