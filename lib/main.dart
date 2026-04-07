import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:restoran_app/uygulama_kabugu/uygulama_kabugu.dart';

void main() {
  // Keep debug overlay lines (baseline/size/pointer paints) disabled.
  debugPaintBaselinesEnabled = false;
  debugPaintSizeEnabled = false;
  debugPaintPointersEnabled = false;

  if (kIsWeb) {
    usePathUrlStrategy();
  }
  runApp(const UygulamaKabugu());
}
