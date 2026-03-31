import 'package:flutter/material.dart';

class UygulamaTema {
  const UygulamaTema._();

  static const Color _anaRenk = Color(0xFFD96F32);
  static const Color _yardimciRenk = Color(0xFF163A32);
  static const Color _vurguRenk = Color(0xFFF3C969);
  static const Color _zeminRenk = Color(0xFFF5EFE6);
  static const Color _kartRenk = Color(0xFFFFFCF8);
  static const Size _dokunmatikHedefBoyutu = Size(56, 56);

  static ThemeData get acikTema {
    final ColorScheme renkSemasi =
        ColorScheme.fromSeed(
          seedColor: _anaRenk,
          brightness: Brightness.light,
        ).copyWith(
          primary: _anaRenk,
          secondary: _yardimciRenk,
          tertiary: _vurguRenk,
          surface: _kartRenk,
        );

    const String govdeYaziAilesi = 'Trebuchet MS';
    const String baslikYaziAilesi = 'Georgia';

    final TextTheme temelYaziTemasi = const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 52,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1E1C18),
        height: 1.02,
        fontFamily: baslikYaziAilesi,
      ),
      headlineMedium: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1E1C18),
        fontFamily: baslikYaziAilesi,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1E1C18),
        fontFamily: govdeYaziAilesi,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF2E2A25),
        fontFamily: govdeYaziAilesi,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w500,
        color: Color(0xFF4E463D),
        fontFamily: govdeYaziAilesi,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.55,
        fontWeight: FontWeight.w500,
        color: Color(0xFF5D554C),
        fontFamily: govdeYaziAilesi,
      ),
      labelLarge: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF2E2A25),
        fontFamily: govdeYaziAilesi,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: renkSemasi,
      scaffoldBackgroundColor: _zeminRenk,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textTheme: temelYaziTemasi,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: renkSemasi.onSurface,
        titleTextStyle: temelYaziTemasi.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: _kartRenk,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: Color(0xFFEAE0D2)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: const BorderSide(color: Color(0xFFE3D7C8)),
        ),
        labelStyle: temelYaziTemasi.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _yardimciRenk,
          foregroundColor: Colors.white,
          minimumSize: _dokunmatikHedefBoyutu,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            fontFamily: govdeYaziAilesi,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: _dokunmatikHedefBoyutu,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            fontFamily: govdeYaziAilesi,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: _dokunmatikHedefBoyutu,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            fontFamily: govdeYaziAilesi,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: _dokunmatikHedefBoyutu,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            fontFamily: govdeYaziAilesi,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: _dokunmatikHedefBoyutu,
          padding: const EdgeInsets.all(14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.94),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE3D7C8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE3D7C8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: renkSemasi.primary, width: 1.4),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        minTileHeight: 56,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
    );
  }
}
