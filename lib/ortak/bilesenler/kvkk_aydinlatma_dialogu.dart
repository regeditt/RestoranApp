import 'package:flutter/material.dart';
import 'package:restoran_app/ortak/bilesenler/suruklenebilir_dialog_kapsayici.dart';

enum AydinlatmaBaglami { siparis, rezervasyon }

class KvkkAydinlatmaDialogu {
  const KvkkAydinlatmaDialogu._();

  static Future<void> goster(
    BuildContext context, {
    required AydinlatmaBaglami baglam,
  }) async {
    final String baslik = switch (baglam) {
      AydinlatmaBaglami.siparis => 'Siparis aydinlatma metni',
      AydinlatmaBaglami.rezervasyon => 'Rezervasyon aydinlatma metni',
    };
    final String kapsamAciklamasi = switch (baglam) {
      AydinlatmaBaglami.siparis =>
        'Siparisin olusturulmasi, teslimati ve operasyon raporlamasi icin gerekli veriler islenir.',
      AydinlatmaBaglami.rezervasyon =>
        'Rezervasyonun planlanmasi, masa atamasi ve no-show takibi icin gerekli veriler islenir.',
    };

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SuruklenebilirPopupSablonu(
          materialKullan: false,
          child: AlertDialog(
            scrollable: true,
            title: Text(baslik),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      kapsamAciklamasi,
                      style: const TextStyle(height: 1.45),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Asgari bilgilendirme',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '- Veri sorumlusu: Isletme yonetimi\n'
                      '- Islenen veriler: ad-soyad, telefon, adres/not, siparis veya rezervasyon kayitlari\n'
                      '- Isleme amaci: hizmetin sunulmasi, operasyonel takip, yasal yukumluluklerin yerine getirilmesi\n'
                      '- Aktarim: gerekli oldugunda yetkili kamu kurumlari ve entegre operasyon saglayicilari\n'
                      '- Saklama: isleme amaci ve mevzuatta ongorulen sure kadar',
                      style: TextStyle(height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Haklariniz',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '- Verinizin islenip islenmedigini ogrenme\n'
                      '- Isleme amacini ve amaca uygun kullanimi ogrenme\n'
                      '- Duzeltme, silme veya anonimlestirme talep etme\n'
                      '- Itiraz ve zarar halinde tazmin talep etme',
                      style: TextStyle(height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Not: Ticari iletisim izni opsiyoneldir; aydinlatma onayi ise hizmetin kurulabilmesi icin zorunludur.',
                      style: TextStyle(
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Okudum'),
              ),
            ],
          ),
        );
      },
    );
  }
}
