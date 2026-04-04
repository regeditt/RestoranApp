import 'package:flutter/material.dart';
import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';

class ServisSaglayici extends InheritedWidget {
  const ServisSaglayici({
    super.key,
    required this.servis,
    required super.child,
  });

  final ServisKaydi servis;

  static ServisKaydi of(BuildContext context) {
    final ServisSaglayici? sonuc =
        context.dependOnInheritedWidgetOfExactType<ServisSaglayici>();
    assert(sonuc != null, 'ServisSaglayici bulunamadi.');
    return sonuc!.servis;
  }

  @override
  bool updateShouldNotify(ServisSaglayici oldWidget) {
    return servis != oldWidget.servis;
  }
}
