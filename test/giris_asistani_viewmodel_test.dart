import 'package:flutter_test/flutter_test.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/varliklar/asistan_mesaji_varligi.dart';
import 'package:restoran_app/ozellikler/kimlik/alan/servisler/kuralli_ayar_asistani_yanitlayici.dart';
import 'package:restoran_app/ozellikler/kimlik/sunum/viewmodel/giris_asistani_viewmodel.dart';
import 'package:restoran_app/ozellikler/kimlik/uygulama/use_case/ayar_asistani_yanit_uret_use_case.dart';

void main() {
  test(
    'GirisAsistaniViewModel acilis mesajini asistan gondereniyle baslatir',
    () {
      final GirisAsistaniViewModel viewModel = GirisAsistaniViewModel(
        yanitUretUseCase: const AyarAsistaniYanitUretUseCase(
          KuralliAyarAsistaniYanitlayici(),
        ),
      );

      expect(viewModel.mesajlar.length, 1);
      expect(viewModel.mesajlar.first.gonderen, AsistanMesajiGondereni.asistan);
    },
  );

  test(
    'GirisAsistaniViewModel mesaj gonderince kullanici ve asistan mesaji ekler',
    () async {
      final GirisAsistaniViewModel viewModel = GirisAsistaniViewModel(
        yanitUretUseCase: const AyarAsistaniYanitUretUseCase(
          KuralliAyarAsistaniYanitlayici(),
        ),
      );

      await viewModel.mesajGonder('Lisans');

      expect(viewModel.mesajlar.length, 3);
      expect(viewModel.mesajlar[1].gonderen, AsistanMesajiGondereni.kullanici);
      expect(viewModel.mesajlar[2].gonderen, AsistanMesajiGondereni.asistan);
    },
  );
}
