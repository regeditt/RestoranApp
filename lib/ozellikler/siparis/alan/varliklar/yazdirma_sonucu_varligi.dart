class YazdirmaSonucuVarligi {
  const YazdirmaSonucuVarligi({
    required this.yaziciAdlari,
    required this.ozetMetni,
    this.gercekYaziciAdlari = const <String>[],
    this.kuyrukYaziciAdlari = const <String>[],
  });

  final List<String> yaziciAdlari;
  final String ozetMetni;
  final List<String> gercekYaziciAdlari;
  final List<String> kuyrukYaziciAdlari;
}
