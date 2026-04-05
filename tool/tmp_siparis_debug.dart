import 'dart:developer' as developer;

import 'package:restoran_app/bagimlilik_enjeksiyonu/servis_kaydi.dart';
import 'package:restoran_app/ozellikler/sepet/alan/varliklar/sepet_varligi.dart';
import 'package:restoran_app/ozellikler/siparis/sunum/viewmodel/siparis_ozeti_viewmodel.dart';

Future<void> main() async {
  final servis = ServisKaydi.sqlite();
  await servis.sepeteUrunEkleUseCase(urunId: '1', adet: 1);
  final SepetVarligi sepet = await servis.sepetiGetirUseCase();
  final vm = SiparisOzetiViewModel.servisKaydindan(servis, sepet: sepet);
  await vm.varsayilanBilgileriYukle();
  final sonuc = await vm.siparisiOnayla();
  developer.log('basarili: ${sonuc.basarili}', name: 'tmp_siparis_debug');
  developer.log('mesaj: ${sonuc.mesaj}', name: 'tmp_siparis_debug');
  developer.log(
    'siparis: ${sonuc.siparis?.siparisNo}',
    name: 'tmp_siparis_debug',
  );
}
