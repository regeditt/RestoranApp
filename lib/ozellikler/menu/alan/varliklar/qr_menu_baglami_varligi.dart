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
}
