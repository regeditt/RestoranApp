class QrMenuBaglamiVarligi {
  const QrMenuBaglamiVarligi({this.masaNo, this.bolumAdi, this.kaynak});

  final String? masaNo;
  final String? bolumAdi;
  final String? kaynak;

  List<String> get rozetler {
    final List<String> degerler = <String>[];
    if (masaNo != null && masaNo!.trim().isNotEmpty) {
      degerler.add('Masa $masaNo');
    }
    if (bolumAdi != null && bolumAdi!.trim().isNotEmpty) {
      degerler.add('Bolum $bolumAdi');
    }
    if (kaynak != null && kaynak!.trim().isNotEmpty) {
      degerler.add('Kaynak $kaynak');
    }
    return degerler;
  }

  String get acilisBasligi {
    if (masaNo != null && masaNo!.trim().isNotEmpty) {
      return 'Masa $masaNo icin QR menu';
    }
    if (bolumAdi != null && bolumAdi!.trim().isNotEmpty) {
      return '$bolumAdi bolumu icin QR menu';
    }
    return 'QR menu baglami aktif';
  }

  String get acilisAciklamasi {
    if (masaNo != null && masaNo!.trim().isNotEmpty) {
      return 'Siparisin ilgili masa baglami ile olusmasi icin bu ekran QR akisi ile acildi.';
    }
    if (bolumAdi != null && bolumAdi!.trim().isNotEmpty) {
      return 'Bolume ozel hizli menu acilisi aktif. Siparis akisi bu baglamla ilerleyecek.';
    }
    return 'Bu menu ozel QR baglami ile acildi.';
  }
}
