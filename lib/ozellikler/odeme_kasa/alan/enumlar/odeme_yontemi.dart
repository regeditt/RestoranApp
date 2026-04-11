enum OdemeYontemi { nakit, kart, temassiz, online }

extension OdemeYontemiYazim on OdemeYontemi {
  String get etiket {
    switch (this) {
      case OdemeYontemi.nakit:
        return 'Nakit';
      case OdemeYontemi.kart:
        return 'Kart';
      case OdemeYontemi.temassiz:
        return 'Temassiz';
      case OdemeYontemi.online:
        return 'Online';
    }
  }
}
