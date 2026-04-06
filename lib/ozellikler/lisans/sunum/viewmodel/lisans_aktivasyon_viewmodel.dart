import 'package:flutter/foundation.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/lisans/alan/varliklar/lisans_durumu_varligi.dart';
import 'package:restoran_app/ozellikler/lisans/uygulama/use_case/lisans_aktif_et_use_case.dart';
import 'package:restoran_app/ozellikler/lisans/uygulama/use_case/lisans_durumu_getir_use_case.dart';

class LisansAktivasyonViewModel extends ChangeNotifier {
  LisansAktivasyonViewModel({
    required LisansDurumuGetirUseCase lisansDurumuGetirUseCase,
    required LisansAktifEtUseCase lisansAktifEtUseCase,
  }) : _lisansDurumuGetirUseCase = lisansDurumuGetirUseCase,
       _lisansAktifEtUseCase = lisansAktifEtUseCase;

  factory LisansAktivasyonViewModel.servisKaydindan(ServisKaydi servisKaydi) {
    return LisansAktivasyonViewModel(
      lisansDurumuGetirUseCase: servisKaydi.lisansDurumuGetirUseCase,
      lisansAktifEtUseCase: servisKaydi.lisansAktifEtUseCase,
    );
  }

  final LisansDurumuGetirUseCase _lisansDurumuGetirUseCase;
  final LisansAktifEtUseCase _lisansAktifEtUseCase;

  bool _yukleniyor = true;
  bool _islemde = false;
  LisansDurumuVarligi _durum = const LisansDurumuVarligi.pasif(
    'Lisans kontrol ediliyor...',
  );

  bool get yukleniyor => _yukleniyor;
  bool get islemde => _islemde;
  LisansDurumuVarligi get durum => _durum;
  bool get aktifMi => _durum.aktifMi;

  Future<void> lisansDurumuYukle() async {
    _yukleniyor = true;
    notifyListeners();
    _durum = await _lisansDurumuGetirUseCase();
    _yukleniyor = false;
    notifyListeners();
  }

  Future<LisansAktifEtSonucu> lisansAktifEt(String lisansAnahtari) async {
    if (_islemde) {
      return const LisansAktifEtSonucu.hata('Lisans aktivasyonu devam ediyor.');
    }
    _islemde = true;
    notifyListeners();
    try {
      final LisansAktifEtSonucu sonuc = await _lisansAktifEtUseCase(
        lisansAnahtari,
      );
      if (sonuc.basariliMi && sonuc.durum != null) {
        _durum = sonuc.durum!;
        notifyListeners();
      }
      return sonuc;
    } finally {
      _islemde = false;
      notifyListeners();
    }
  }
}
