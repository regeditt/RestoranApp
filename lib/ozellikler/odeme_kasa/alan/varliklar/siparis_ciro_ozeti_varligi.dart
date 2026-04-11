class SiparisCiroOzetiVarligi {
  const SiparisCiroOzetiVarligi({
    required this.siparisAdedi,
    required this.brutCiro,
    required this.indirimToplami,
    required this.netCiro,
  });

  final int siparisAdedi;
  final double brutCiro;
  final double indirimToplami;
  final double netCiro;

  static const SiparisCiroOzetiVarligi bos = SiparisCiroOzetiVarligi(
    siparisAdedi: 0,
    brutCiro: 0,
    indirimToplami: 0,
    netCiro: 0,
  );
}
