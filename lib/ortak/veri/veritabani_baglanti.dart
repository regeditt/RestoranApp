import 'package:drift/drift.dart';

import 'veritabani_baglanti_stub.dart'
    if (dart.library.io) 'veritabani_baglanti_io.dart'
    if (dart.library.html) 'veritabani_baglanti_web.dart';

QueryExecutor veritabaniBaglantisiOlustur() => platformVeritabaniBaglantisi();
