import 'package:restoran_app/ozellikler/lisans/alan/depolar/lisans_deposu.dart';

class LisansDeposuGercek implements LisansDeposu {
  String? _lisansAnahtari;

  @override
  Future<String?> kayitliLisansAnahtariGetir() async {
    if (_lisansAnahtari == null || _lisansAnahtari!.trim().isEmpty) {
      return null;
    }
    return _lisansAnahtari!.trim();
  }

  @override
  Future<void> lisansAnahtariKaydet(String lisansAnahtari) async {
    _lisansAnahtari = lisansAnahtari.trim();
  }

  @override
  Future<void> lisansTemizle() async {
    _lisansAnahtari = null;
  }
}
