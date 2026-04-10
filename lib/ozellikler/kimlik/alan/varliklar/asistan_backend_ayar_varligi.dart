class AsistanBackendAyarVarligi {
  const AsistanBackendAyarVarligi({
    required this.tabanUrl,
    this.apiAnahtari = '',
  });

  final String tabanUrl;
  final String apiAnahtari;

  bool get tanimliMi => tabanUrl.trim().isNotEmpty;
  bool get apiAnahtariTanimliMi => apiAnahtari.trim().isNotEmpty;
}
