import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ortak/bagimlilik/servis_saglayici.dart';
import 'package:restoran_app/ortak/sabitler/uygulama_sabitleri.dart';
import 'package:restoran_app/ortak/tema/uygulama_tema.dart';
import 'package:restoran_app/ortak/yonlendirme/rota_yapisi.dart';
import 'package:restoran_app/ortak/veri/veri_kaynagi_tipi.dart';
import 'package:restoran_app/ozellikler/lisans/sunum/sayfalar/lisans_aktivasyon_sayfasi.dart';
import 'package:restoran_app/ozellikler/lisans/sunum/viewmodel/lisans_aktivasyon_viewmodel.dart';

class UygulamaKabugu extends StatefulWidget {
  const UygulamaKabugu({super.key, this.veriKaynagi = VeriKaynagiTipi.sqlite});

  final VeriKaynagiTipi veriKaynagi;

  @override
  State<UygulamaKabugu> createState() => _UygulamaKabuguState();
}

class _UygulamaKabuguState extends State<UygulamaKabugu> {
  late final ServisKaydi _servisKaydi = ServisKaydi.olustur(widget.veriKaynagi);
  late final LisansAktivasyonViewModel _lisansViewModel =
      LisansAktivasyonViewModel.servisKaydindan(_servisKaydi);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lisansViewModel.lisansDurumuYukle();
    });
  }

  @override
  void dispose() {
    _lisansViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Force-disable debug paint overlays that reduce readability in UI.
    debugPaintBaselinesEnabled = false;
    debugPaintSizeEnabled = false;
    debugPaintPointersEnabled = false;

    return ServisSaglayici(
      servis: _servisKaydi,
      child: MaterialApp(
        title: UygulamaSabitleri.uygulamaAdi,
        debugShowCheckedModeBanner: false,
        theme: UygulamaTema.acikTema,
        home: AnimatedBuilder(
          animation: _lisansViewModel,
          builder: (context, _) {
            if (_lisansViewModel.yukleniyor) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!_lisansViewModel.aktifMi) {
              return LisansAktivasyonSayfasi(viewModel: _lisansViewModel);
            }

            return _LisansliUygulamaKoku(
              baslangicRotasi: baslangicRotasiBelirle(
                webMu: kIsWeb,
                platform: defaultTargetPlatform,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LisansliUygulamaKoku extends StatelessWidget {
  const _LisansliUygulamaKoku({required this.baslangicRotasi});

  final String baslangicRotasi;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: baslangicRotasi,
      onGenerateRoute: RotaYapisi.rotaOlustur,
    );
  }
}

@visibleForTesting
String baslangicRotasiBelirle({
  required bool webMu,
  required TargetPlatform platform,
}) {
  return RotaYapisi.anaSayfa;
}
