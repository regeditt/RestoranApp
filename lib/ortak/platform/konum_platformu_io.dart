import 'package:geolocator/geolocator.dart';
import 'package:restoran_app/ortak/platform/konum_platformu.dart';

class _KonumPlatformuIo implements KonumPlatformu {
  const _KonumPlatformuIo();

  @override
  Future<KonumHazirlamaSonucu> hazirla() async {
    try {
      final bool servisAcik = await Geolocator.isLocationServiceEnabled();
      if (!servisAcik) {
        return const KonumHazirlamaSonucu.hata(
          'Konum servisi kapali. Lutfen cihaz konumunu ac.',
        );
      }

      LocationPermission izin = await Geolocator.checkPermission();
      if (izin == LocationPermission.denied) {
        izin = await Geolocator.requestPermission();
      }

      if (izin == LocationPermission.denied) {
        return const KonumHazirlamaSonucu.hata(
          'Konum izni reddedildi. Canli takip baslatilamadi.',
        );
      }
      if (izin == LocationPermission.deniedForever) {
        return const KonumHazirlamaSonucu.hata(
          'Konum izni kalici olarak reddedildi. Ayarlardan izin vermelisin.',
        );
      }

      return const KonumHazirlamaSonucu.basarili();
    } catch (_) {
      return const KonumHazirlamaSonucu.hata(
        'Konum servisine ulasilamadi. Cihazda konum destegini kontrol et.',
      );
    }
  }

  @override
  Future<KonumNoktasi?> anlikKonumGetir() async {
    try {
      final Position konum = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      );
      return KonumNoktasi(
        enlem: konum.latitude,
        boylam: konum.longitude,
        olusturmaTarihi: konum.timestamp,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<KonumNoktasi> konumAkisi() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 8,
      ),
    ).map((Position konum) {
      return KonumNoktasi(
        enlem: konum.latitude,
        boylam: konum.longitude,
        olusturmaTarihi: konum.timestamp,
      );
    });
  }
}

KonumPlatformu konumPlatformuOlustur() {
  return const _KonumPlatformuIo();
}
