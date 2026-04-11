import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/tema/restoran_tema_uzantilari.dart';

class PopupTutamacDeseni {
  const PopupTutamacDeseni({
    this.satir = 2,
    this.sutun = 8,
    this.noktaBoyutu = 4,
  });

  final int satir;
  final int sutun;
  final double noktaBoyutu;
}

class PopupYuzeyi extends StatelessWidget {
  const PopupYuzeyi({
    super.key,
    required this.child,
    this.arkaPlanRengi,
    this.kenarYaricapi = const BorderRadius.all(Radius.circular(28)),
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final Color? arkaPlanRengi;
  final BorderRadius kenarYaricapi;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: arkaPlanRengi ?? Theme.of(context).colorScheme.surface,
      borderRadius: kenarYaricapi,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

class SuruklenebilirDialogKapsayici extends StatefulWidget {
  const SuruklenebilirDialogKapsayici({
    super.key,
    required this.child,
    this.tutamacGoster = true,
    this.tutamacRenk,
    this.tutamacGenislik = 60,
    this.tutamacYukseklik = 12,
    this.tutamacAlanYukseklik = 26,
    this.tutamacUstOfset = 8,
    this.tutamacDeseni = const PopupTutamacDeseni(),
    this.tutamacSol = 24,
    this.tutamacSag = 24,
    this.ustBantSuruklemeGoster = true,
    this.ustBantYukseklik = 52,
    this.ustBantSol = 12,
    this.ustBantSag = 84,
    this.ekranSinirPayi = 80,
  });

  final Widget child;
  final bool tutamacGoster;
  final Color? tutamacRenk;
  final double tutamacGenislik;
  final double tutamacYukseklik;
  final double tutamacAlanYukseklik;
  final double tutamacUstOfset;
  final PopupTutamacDeseni tutamacDeseni;
  final double tutamacSol;
  final double tutamacSag;
  final bool ustBantSuruklemeGoster;
  final double ustBantYukseklik;
  final double ustBantSol;
  final double ustBantSag;
  final double ekranSinirPayi;

  @override
  State<SuruklenebilirDialogKapsayici> createState() =>
      _SuruklenebilirDialogKapsayiciState();
}

class _SuruklenebilirDialogKapsayiciState
    extends State<SuruklenebilirDialogKapsayici> {
  Offset _ofset = Offset.zero;

  void _deltaIleSurukle(Offset delta) {
    final Size ekranBoyutu = MediaQuery.sizeOf(context);
    final double yataySinir = ((ekranBoyutu.width / 2) - widget.ekranSinirPayi)
        .clamp(0, double.infinity);
    final double dikeySinir = ((ekranBoyutu.height / 2) - widget.ekranSinirPayi)
        .clamp(0, double.infinity);
    final Offset yeniOfset = _ofset + delta;
    setState(() {
      _ofset = Offset(
        yeniOfset.dx.clamp(-yataySinir, yataySinir),
        yeniOfset.dy.clamp(-dikeySinir, dikeySinir),
      );
    });
  }

  void _surukle(DragUpdateDetails detaylar) {
    _deltaIleSurukle(detaylar.delta);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _ofset,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (widget.ustBantSuruklemeGoster)
            Positioned(
              left: widget.ustBantSol,
              right: widget.ustBantSag,
              top: 0,
              height: widget.ustBantYukseklik,
              child: MouseRegion(
                cursor: SystemMouseCursors.move,
                child: GestureDetector(
                  onPanUpdate: _surukle,
                  behavior: HitTestBehavior.translucent,
                ),
              ),
            ),
          if (widget.tutamacGoster)
            Positioned(
              left: widget.tutamacSol,
              right: widget.tutamacSag,
              top: widget.tutamacUstOfset,
              child: MouseRegion(
                cursor: SystemMouseCursors.move,
                child: GestureDetector(
                  onPanUpdate: _surukle,
                  behavior: HitTestBehavior.opaque,
                  child: _SuruklenebilirTutamac(
                    height: widget.tutamacAlanYukseklik,
                    color:
                        widget.tutamacRenk ??
                        context.restoranTema.suruklemeTutamaci,
                    width: widget.tutamacGenislik,
                    dotsAreaHeight: widget.tutamacYukseklik,
                    desen: widget.tutamacDeseni,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SuruklenebilirTutamac extends StatelessWidget {
  const _SuruklenebilirTutamac({
    required this.height,
    required this.width,
    required this.dotsAreaHeight,
    required this.color,
    required this.desen,
  });

  final double height;
  final double width;
  final double dotsAreaHeight;
  final Color color;
  final PopupTutamacDeseni desen;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: width,
          height: dotsAreaHeight,
          child: _TutamacNoktaMatrisi(desen: desen, color: color),
        ),
      ),
    );
  }
}

class _TutamacNoktaMatrisi extends StatelessWidget {
  const _TutamacNoktaMatrisi({required this.desen, required this.color});

  final PopupTutamacDeseni desen;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List<Widget>.generate(
        desen.satir,
        (_) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(
            desen.sutun,
            (_) => Container(
              width: desen.noktaBoyutu,
              height: desen.noktaBoyutu,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SuruklenebilirPopupSablonu extends StatelessWidget {
  const SuruklenebilirPopupSablonu({
    super.key,
    required this.child,
    this.disBosluk = const EdgeInsets.all(24),
    this.genislik,
    this.yukseklik,
    this.maxGenislik,
    this.maxYukseklik,
    this.materialKullan = true,
    this.arkaPlanRengi,
    this.kenarYaricapi = const BorderRadius.all(Radius.circular(28)),
    this.clipBehavior = Clip.antiAlias,
    this.tutamacUstOfset = 8,
    this.tutamacRenk,
  });

  final Widget child;
  final EdgeInsets disBosluk;
  final double? genislik;
  final double? yukseklik;
  final double? maxGenislik;
  final double? maxYukseklik;
  final bool materialKullan;
  final Color? arkaPlanRengi;
  final BorderRadius kenarYaricapi;
  final Clip clipBehavior;
  final double tutamacUstOfset;
  final Color? tutamacRenk;

  @override
  Widget build(BuildContext context) {
    final Size ekranBoyutu = MediaQuery.sizeOf(context);
    final double ekranIciMaxGenislik = math.max(
      0,
      ekranBoyutu.width - disBosluk.horizontal,
    );
    final double ekranIciMaxYukseklik = math.max(
      0,
      ekranBoyutu.height - disBosluk.vertical,
    );
    Widget icerik = child;

    if (genislik != null || yukseklik != null) {
      icerik = SizedBox(width: genislik, height: yukseklik, child: icerik);
    }

    final double hedefMaxGenislik = math.min(
      maxGenislik ?? ekranIciMaxGenislik,
      ekranIciMaxGenislik,
    );
    final double hedefMaxYukseklik = math.min(
      maxYukseklik ?? ekranIciMaxYukseklik,
      ekranIciMaxYukseklik,
    );

    icerik = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: hedefMaxGenislik,
        maxHeight: hedefMaxYukseklik,
      ),
      child: icerik,
    );

    if (materialKullan) {
      icerik = PopupYuzeyi(
        arkaPlanRengi: arkaPlanRengi,
        kenarYaricapi: kenarYaricapi,
        clipBehavior: clipBehavior,
        child: icerik,
      );
    }

    return SuruklenebilirDialogKapsayici(
      tutamacUstOfset: tutamacUstOfset,
      tutamacRenk: tutamacRenk,
      child: Padding(
        padding: disBosluk,
        child: Center(child: icerik),
      ),
    );
  }
}
