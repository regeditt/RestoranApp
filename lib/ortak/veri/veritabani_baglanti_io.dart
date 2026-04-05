import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

QueryExecutor platformVeritabaniBaglantisi() {
  return LazyDatabase(() async {
    final Directory dizin = await getApplicationDocumentsDirectory();
    final File dosya = File('${dizin.path}/restoran_app.sqlite');
    return NativeDatabase(dosya);
  });
}
