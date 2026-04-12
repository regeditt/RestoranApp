import 'package:restoran_app/ozellikler/lisans/alan/depolar/lisans_deposu.dart';

class LisansDeposuMock implements LisansDeposu {
  LisansDeposuMock({
    String? baslangicLisansAnahtari,
    DateTime? baslangicDenemeTarihi,
  }) : _lisansAnahtari = baslangicLisansAnahtari,
       _denemeBaslangicTarihi = baslangicDenemeTarihi;

  String? _lisansAnahtari;
  DateTime? _denemeBaslangicTarihi;

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
  Future<DateTime?> denemeBaslangicTarihiGetir() async {
    return _denemeBaslangicTarihi;
  }

  @override
  Future<void> denemeBaslangicTarihiKaydet(DateTime baslangicTarihi) async {
    _denemeBaslangicTarihi = DateTime(
      baslangicTarihi.year,
      baslangicTarihi.month,
      baslangicTarihi.day,
    );
  }

  @override
  Future<void> lisansTemizle() async {
    _lisansAnahtari = null;
  }
}
