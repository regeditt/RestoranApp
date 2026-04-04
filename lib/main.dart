import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:restoran_app/uygulama_kabugu/uygulama_kabugu.dart';

void main() {
  assert(() {
    debugPaintBaselinesEnabled = false;
    debugPaintSizeEnabled = false;
    debugPaintPointersEnabled = false;
    return true;
  }());

  if (kIsWeb) {
    usePathUrlStrategy();
  }
  runApp(const UygulamaKabugu());
}
