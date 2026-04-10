import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/asistan_mesaji_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/ayar_asistani_yanit_uret_use_case.dart';

class GirisAsistaniViewModel extends ChangeNotifier {
  GirisAsistaniViewModel({
    required AyarAsistaniYanitUretUseCase yanitUretUseCase,
  }) : _yanitUretUseCase = yanitUretUseCase,
       _hizliSoruEtiketleri = List<String>.unmodifiable(
         yanitUretUseCase.hizliSoruEtiketleri,
       ),
       _mesajlar = <AsistanMesajiVarligi>[
         AsistanMesajiVarligi(
           metin: yanitUretUseCase.acilisMesaji,
           gonderen: AsistanMesajiGondereni.asistan,
         ),
       ];

  factory GirisAsistaniViewModel.servisKaydindan(ServisKaydi servisKaydi) {
    return GirisAsistaniViewModel(
      yanitUretUseCase: servisKaydi.ayarAsistaniYanitUretUseCase,
    );
  }

  final AyarAsistaniYanitUretUseCase _yanitUretUseCase;
  final List<String> _hizliSoruEtiketleri;
  List<AsistanMesajiVarligi> _mesajlar;
  bool _yanitBekleniyor = false;

  List<String> get hizliSoruEtiketleri => _hizliSoruEtiketleri;

  List<AsistanMesajiVarligi> get mesajlar =>
      List<AsistanMesajiVarligi>.unmodifiable(_mesajlar);

  bool get yanitBekleniyor => _yanitBekleniyor;

  Future<void> mesajGonder(String metin) async {
    final String temizMesaj = metin.trim();
    if (temizMesaj.isEmpty || _yanitBekleniyor) {
      return;
    }
    _mesajlar = <AsistanMesajiVarligi>[
      ..._mesajlar,
      AsistanMesajiVarligi(
        metin: temizMesaj,
        gonderen: AsistanMesajiGondereni.kullanici,
      ),
    ];
    _yanitBekleniyor = true;
    notifyListeners();

    try {
      final String yanit = await _yanitUretUseCase(temizMesaj);
      _mesajlar = <AsistanMesajiVarligi>[
        ..._mesajlar,
        AsistanMesajiVarligi(
          metin: yanit,
          gonderen: AsistanMesajiGondereni.asistan,
        ),
      ];
    } catch (_) {
      _mesajlar = <AsistanMesajiVarligi>[
        ..._mesajlar,
        const AsistanMesajiVarligi(
          metin:
              'Sunucuya baglanirken bir hata oldu. Ayarlar ekranindan backend baglantisini test edip tekrar deneyebilirsin.',
          gonderen: AsistanMesajiGondereni.asistan,
        ),
      ];
    } finally {
      _yanitBekleniyor = false;
    }
    notifyListeners();
  }

  void hizliSoruSec(String etiket) {
    unawaited(mesajGonder(etiket));
  }
}
