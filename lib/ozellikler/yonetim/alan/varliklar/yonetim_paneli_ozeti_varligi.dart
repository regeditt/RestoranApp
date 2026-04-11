class YonetimPaneliOzetiVarligi {
  const YonetimPaneliOzetiVarligi({
    required this.toplamSiparis,
    required this.toplamCiro,
    this.toplamIndirim = 0,
    required this.hazirlananSiparis,
    required this.hazirSiparis,
    required this.yoldaSiparis,
    required this.restorandaYeSayisi,
    required this.gelAlSayisi,
    required this.paketServisSayisi,
  });

  final int toplamSiparis;
  final double toplamCiro;
  final double toplamIndirim;
  final int hazirlananSiparis;
  final int hazirSiparis;
  final int yoldaSiparis;
  final int restorandaYeSayisi;
  final int gelAlSayisi;
  final int paketServisSayisi;
}
