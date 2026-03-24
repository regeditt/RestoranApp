import 'package:flutter/widgets.dart';

class EkranBoyutu {
  const EkranBoyutu._();

  static bool masaustu(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1200;

  static bool tablet(BuildContext context) {
    final double genislik = MediaQuery.sizeOf(context).width;
    return genislik >= 700 && genislik < 1200;
  }

  static bool mobil(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 700;
}
