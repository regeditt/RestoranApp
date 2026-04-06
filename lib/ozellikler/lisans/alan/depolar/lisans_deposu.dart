abstract class LisansDeposu {
  Future<String?> kayitliLisansAnahtariGetir();

  Future<void> lisansAnahtariKaydet(String lisansAnahtari);

  Future<void> lisansTemizle();
}
