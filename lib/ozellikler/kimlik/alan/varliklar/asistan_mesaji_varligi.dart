enum AsistanMesajiGondereni { kullanici, asistan }

class AsistanMesajiVarligi {
  const AsistanMesajiVarligi({required this.metin, required this.gonderen});

  final String metin;
  final AsistanMesajiGondereni gonderen;
}
