import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/tema/restoran_tema_uzantilari.dart';
import 'package:restoran_app/ortak/tema/tema_tokenlari.dart';

class UygulamaTemaOlusturucu {
  const UygulamaTemaOlusturucu({required this.temaTokenlari});

  final TemaTokenlari temaTokenlari;

  ThemeData olustur() {
    final ColorScheme renkSemasi =
        ColorScheme.fromSeed(
          seedColor: temaTokenlari.birincilAksiyon,
          brightness: Brightness.dark,
        ).copyWith(
          primary: temaTokenlari.birincilAksiyon,
          secondary: temaTokenlari.ikincilAksiyon,
          tertiary: temaTokenlari.vurguAksiyon,
          surface: temaTokenlari.kartYuzey,
          onSurface: temaTokenlari.metinBirincilAcik,
        );

    final TextTheme yaziTemasi = TextTheme(
      headlineLarge: TextStyle(
        fontSize: 52,
        fontWeight: FontWeight.w700,
        color: temaTokenlari.metinBirincilKoyu,
        height: 1.02,
      ),
      headlineMedium: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: temaTokenlari.metinBirincilKoyu,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: temaTokenlari.metinBirincilKoyu,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: temaTokenlari.metinBirincilKoyu,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w500,
        color: temaTokenlari.metinIkincilKoyu,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.55,
        fontWeight: FontWeight.w500,
        color: temaTokenlari.metinIkincilKoyu,
      ),
      labelLarge: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: temaTokenlari.metinBirincilKoyu,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: renkSemasi,
      scaffoldBackgroundColor: temaTokenlari.anaArkaPlan,
      canvasColor: renkSemasi.surface,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textTheme: yaziTemasi,
      extensions: <ThemeExtension<dynamic>>[
        RestoranTemaRenkleri(
          anaArkaPlan: temaTokenlari.anaArkaPlan,
          anaArkaPlanIkincil: temaTokenlari.anaArkaPlanIkincil,
          anaArkaPlanUcuncul: temaTokenlari.anaArkaPlanUcuncul,
          popupYuzey: temaTokenlari.popupYuzey,
          popupAltYuzey: temaTokenlari.popupAltYuzey,
          kartYuzey: temaTokenlari.kartYuzey,
          inceKenar: temaTokenlari.inceKenar,
          metinBirincilKoyu: temaTokenlari.metinBirincilKoyu,
          metinIkincilKoyu: temaTokenlari.metinIkincilKoyu,
          metinBirincilAcik: temaTokenlari.metinBirincilAcik,
          metinIkincilAcik: temaTokenlari.metinIkincilAcik,
          suruklemeTutamaci: temaTokenlari.suruklemeTutamaci,
        ),
      ],
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: renkSemasi.onSurface,
        titleTextStyle: yaziTemasi.titleLarge,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: temaTokenlari.popupYuzey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: temaTokenlari.kartYuzey,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: temaTokenlari.inceKenar),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: temaTokenlari.kartYuzey.withValues(alpha: 0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: BorderSide(color: temaTokenlari.inceKenar),
        ),
        labelStyle: yaziTemasi.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: temaTokenlari.birincilAksiyon,
          foregroundColor: temaTokenlari.metinBirincilAcik,
          minimumSize: temaTokenlari.dokunmatikHedefBoyutu,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          textStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: temaTokenlari.birincilAksiyon,
          foregroundColor: temaTokenlari.metinBirincilAcik,
          minimumSize: temaTokenlari.dokunmatikHedefBoyutu,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          textStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: temaTokenlari.dokunmatikHedefBoyutu,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: temaTokenlari.dokunmatikHedefBoyutu,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: temaTokenlari.dokunmatikHedefBoyutu,
          padding: const EdgeInsets.all(14),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: renkSemasi.surface,
        surfaceTintColor: Colors.transparent,
        textStyle: TextStyle(
          color: renkSemasi.onSurface,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: temaTokenlari.inceKenar.withValues(alpha: 0.8),
          ),
        ),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(renkSemasi.surface),
          surfaceTintColor: const WidgetStatePropertyAll<Color>(
            Colors.transparent,
          ),
          side: WidgetStatePropertyAll<BorderSide>(
            BorderSide(color: temaTokenlari.inceKenar.withValues(alpha: 0.8)),
          ),
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: TextStyle(
          color: renkSemasi.onSurface,
          fontWeight: FontWeight.w700,
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(renkSemasi.surface),
          surfaceTintColor: const WidgetStatePropertyAll<Color>(
            Colors.transparent,
          ),
          side: WidgetStatePropertyAll<BorderSide>(
            BorderSide(color: temaTokenlari.inceKenar.withValues(alpha: 0.8)),
          ),
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.06),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: TextStyle(
          color: temaTokenlari.metinIkincilAcik.withValues(alpha: 0.92),
          fontWeight: FontWeight.w700,
        ),
        floatingLabelStyle: TextStyle(
          color: renkSemasi.primary,
          fontWeight: FontWeight.w800,
        ),
        hintStyle: TextStyle(
          color: temaTokenlari.metinIkincilAcik.withValues(alpha: 0.74),
          fontWeight: FontWeight.w500,
        ),
        prefixIconColor: temaTokenlari.metinIkincilAcik.withValues(alpha: 0.88),
        suffixIconColor: temaTokenlari.metinIkincilAcik.withValues(alpha: 0.88),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: temaTokenlari.inceKenar.withValues(alpha: 0.80),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: temaTokenlari.inceKenar.withValues(alpha: 0.80),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: renkSemasi.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: renkSemasi.error.withValues(alpha: 0.86),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: renkSemasi.error, width: 1.8),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent,
        labelColor: temaTokenlari.birincilAksiyon,
        unselectedLabelColor: temaTokenlari.metinBirincilKoyu,
      ),
      listTileTheme: const ListTileThemeData(
        minTileHeight: 56,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
    );
  }
}
