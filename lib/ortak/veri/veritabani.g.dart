// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'veritabani.dart';

// ignore_for_file: type=lint
class $KullaniciKayitlariTable extends KullaniciKayitlari
    with TableInfo<$KullaniciKayitlariTable, KullaniciKayitlariData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KullaniciKayitlariTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adSoyadMeta = const VerificationMeta(
    'adSoyad',
  );
  @override
  late final GeneratedColumn<String> adSoyad = GeneratedColumn<String>(
    'ad_soyad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonMeta = const VerificationMeta(
    'telefon',
  );
  @override
  late final GeneratedColumn<String> telefon = GeneratedColumn<String>(
    'telefon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _epostaMeta = const VerificationMeta('eposta');
  @override
  late final GeneratedColumn<String> eposta = GeneratedColumn<String>(
    'eposta',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rolMeta = const VerificationMeta('rol');
  @override
  late final GeneratedColumn<int> rol = GeneratedColumn<int>(
    'rol',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aktifMiMeta = const VerificationMeta(
    'aktifMi',
  );
  @override
  late final GeneratedColumn<bool> aktifMi = GeneratedColumn<bool>(
    'aktif_mi',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("aktif_mi" IN (0, 1))',
    ),
  );
  static const VerificationMeta _adresMetniMeta = const VerificationMeta(
    'adresMetni',
  );
  @override
  late final GeneratedColumn<String> adresMetni = GeneratedColumn<String>(
    'adres_metni',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    adSoyad,
    telefon,
    eposta,
    rol,
    aktifMi,
    adresMetni,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kullanici_kayitlari';
  @override
  VerificationContext validateIntegrity(
    Insertable<KullaniciKayitlariData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ad_soyad')) {
      context.handle(
        _adSoyadMeta,
        adSoyad.isAcceptableOrUnknown(data['ad_soyad']!, _adSoyadMeta),
      );
    } else if (isInserting) {
      context.missing(_adSoyadMeta);
    }
    if (data.containsKey('telefon')) {
      context.handle(
        _telefonMeta,
        telefon.isAcceptableOrUnknown(data['telefon']!, _telefonMeta),
      );
    } else if (isInserting) {
      context.missing(_telefonMeta);
    }
    if (data.containsKey('eposta')) {
      context.handle(
        _epostaMeta,
        eposta.isAcceptableOrUnknown(data['eposta']!, _epostaMeta),
      );
    }
    if (data.containsKey('rol')) {
      context.handle(
        _rolMeta,
        rol.isAcceptableOrUnknown(data['rol']!, _rolMeta),
      );
    } else if (isInserting) {
      context.missing(_rolMeta);
    }
    if (data.containsKey('aktif_mi')) {
      context.handle(
        _aktifMiMeta,
        aktifMi.isAcceptableOrUnknown(data['aktif_mi']!, _aktifMiMeta),
      );
    } else if (isInserting) {
      context.missing(_aktifMiMeta);
    }
    if (data.containsKey('adres_metni')) {
      context.handle(
        _adresMetniMeta,
        adresMetni.isAcceptableOrUnknown(data['adres_metni']!, _adresMetniMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KullaniciKayitlariData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KullaniciKayitlariData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      adSoyad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ad_soyad'],
      )!,
      telefon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefon'],
      )!,
      eposta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}eposta'],
      ),
      rol: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rol'],
      )!,
      aktifMi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}aktif_mi'],
      )!,
      adresMetni: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adres_metni'],
      ),
    );
  }

  @override
  $KullaniciKayitlariTable createAlias(String alias) {
    return $KullaniciKayitlariTable(attachedDatabase, alias);
  }
}

class KullaniciKayitlariData extends DataClass
    implements Insertable<KullaniciKayitlariData> {
  final String id;
  final String adSoyad;
  final String telefon;
  final String? eposta;
  final int rol;
  final bool aktifMi;
  final String? adresMetni;
  const KullaniciKayitlariData({
    required this.id,
    required this.adSoyad,
    required this.telefon,
    this.eposta,
    required this.rol,
    required this.aktifMi,
    this.adresMetni,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ad_soyad'] = Variable<String>(adSoyad);
    map['telefon'] = Variable<String>(telefon);
    if (!nullToAbsent || eposta != null) {
      map['eposta'] = Variable<String>(eposta);
    }
    map['rol'] = Variable<int>(rol);
    map['aktif_mi'] = Variable<bool>(aktifMi);
    if (!nullToAbsent || adresMetni != null) {
      map['adres_metni'] = Variable<String>(adresMetni);
    }
    return map;
  }

  KullaniciKayitlariCompanion toCompanion(bool nullToAbsent) {
    return KullaniciKayitlariCompanion(
      id: Value(id),
      adSoyad: Value(adSoyad),
      telefon: Value(telefon),
      eposta: eposta == null && nullToAbsent
          ? const Value.absent()
          : Value(eposta),
      rol: Value(rol),
      aktifMi: Value(aktifMi),
      adresMetni: adresMetni == null && nullToAbsent
          ? const Value.absent()
          : Value(adresMetni),
    );
  }

  factory KullaniciKayitlariData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KullaniciKayitlariData(
      id: serializer.fromJson<String>(json['id']),
      adSoyad: serializer.fromJson<String>(json['adSoyad']),
      telefon: serializer.fromJson<String>(json['telefon']),
      eposta: serializer.fromJson<String?>(json['eposta']),
      rol: serializer.fromJson<int>(json['rol']),
      aktifMi: serializer.fromJson<bool>(json['aktifMi']),
      adresMetni: serializer.fromJson<String?>(json['adresMetni']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'adSoyad': serializer.toJson<String>(adSoyad),
      'telefon': serializer.toJson<String>(telefon),
      'eposta': serializer.toJson<String?>(eposta),
      'rol': serializer.toJson<int>(rol),
      'aktifMi': serializer.toJson<bool>(aktifMi),
      'adresMetni': serializer.toJson<String?>(adresMetni),
    };
  }

  KullaniciKayitlariData copyWith({
    String? id,
    String? adSoyad,
    String? telefon,
    Value<String?> eposta = const Value.absent(),
    int? rol,
    bool? aktifMi,
    Value<String?> adresMetni = const Value.absent(),
  }) => KullaniciKayitlariData(
    id: id ?? this.id,
    adSoyad: adSoyad ?? this.adSoyad,
    telefon: telefon ?? this.telefon,
    eposta: eposta.present ? eposta.value : this.eposta,
    rol: rol ?? this.rol,
    aktifMi: aktifMi ?? this.aktifMi,
    adresMetni: adresMetni.present ? adresMetni.value : this.adresMetni,
  );
  KullaniciKayitlariData copyWithCompanion(KullaniciKayitlariCompanion data) {
    return KullaniciKayitlariData(
      id: data.id.present ? data.id.value : this.id,
      adSoyad: data.adSoyad.present ? data.adSoyad.value : this.adSoyad,
      telefon: data.telefon.present ? data.telefon.value : this.telefon,
      eposta: data.eposta.present ? data.eposta.value : this.eposta,
      rol: data.rol.present ? data.rol.value : this.rol,
      aktifMi: data.aktifMi.present ? data.aktifMi.value : this.aktifMi,
      adresMetni: data.adresMetni.present
          ? data.adresMetni.value
          : this.adresMetni,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KullaniciKayitlariData(')
          ..write('id: $id, ')
          ..write('adSoyad: $adSoyad, ')
          ..write('telefon: $telefon, ')
          ..write('eposta: $eposta, ')
          ..write('rol: $rol, ')
          ..write('aktifMi: $aktifMi, ')
          ..write('adresMetni: $adresMetni')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, adSoyad, telefon, eposta, rol, aktifMi, adresMetni);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KullaniciKayitlariData &&
          other.id == this.id &&
          other.adSoyad == this.adSoyad &&
          other.telefon == this.telefon &&
          other.eposta == this.eposta &&
          other.rol == this.rol &&
          other.aktifMi == this.aktifMi &&
          other.adresMetni == this.adresMetni);
}

class KullaniciKayitlariCompanion
    extends UpdateCompanion<KullaniciKayitlariData> {
  final Value<String> id;
  final Value<String> adSoyad;
  final Value<String> telefon;
  final Value<String?> eposta;
  final Value<int> rol;
  final Value<bool> aktifMi;
  final Value<String?> adresMetni;
  final Value<int> rowid;
  const KullaniciKayitlariCompanion({
    this.id = const Value.absent(),
    this.adSoyad = const Value.absent(),
    this.telefon = const Value.absent(),
    this.eposta = const Value.absent(),
    this.rol = const Value.absent(),
    this.aktifMi = const Value.absent(),
    this.adresMetni = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KullaniciKayitlariCompanion.insert({
    required String id,
    required String adSoyad,
    required String telefon,
    this.eposta = const Value.absent(),
    required int rol,
    required bool aktifMi,
    this.adresMetni = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       adSoyad = Value(adSoyad),
       telefon = Value(telefon),
       rol = Value(rol),
       aktifMi = Value(aktifMi);
  static Insertable<KullaniciKayitlariData> custom({
    Expression<String>? id,
    Expression<String>? adSoyad,
    Expression<String>? telefon,
    Expression<String>? eposta,
    Expression<int>? rol,
    Expression<bool>? aktifMi,
    Expression<String>? adresMetni,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (adSoyad != null) 'ad_soyad': adSoyad,
      if (telefon != null) 'telefon': telefon,
      if (eposta != null) 'eposta': eposta,
      if (rol != null) 'rol': rol,
      if (aktifMi != null) 'aktif_mi': aktifMi,
      if (adresMetni != null) 'adres_metni': adresMetni,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KullaniciKayitlariCompanion copyWith({
    Value<String>? id,
    Value<String>? adSoyad,
    Value<String>? telefon,
    Value<String?>? eposta,
    Value<int>? rol,
    Value<bool>? aktifMi,
    Value<String?>? adresMetni,
    Value<int>? rowid,
  }) {
    return KullaniciKayitlariCompanion(
      id: id ?? this.id,
      adSoyad: adSoyad ?? this.adSoyad,
      telefon: telefon ?? this.telefon,
      eposta: eposta ?? this.eposta,
      rol: rol ?? this.rol,
      aktifMi: aktifMi ?? this.aktifMi,
      adresMetni: adresMetni ?? this.adresMetni,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (adSoyad.present) {
      map['ad_soyad'] = Variable<String>(adSoyad.value);
    }
    if (telefon.present) {
      map['telefon'] = Variable<String>(telefon.value);
    }
    if (eposta.present) {
      map['eposta'] = Variable<String>(eposta.value);
    }
    if (rol.present) {
      map['rol'] = Variable<int>(rol.value);
    }
    if (aktifMi.present) {
      map['aktif_mi'] = Variable<bool>(aktifMi.value);
    }
    if (adresMetni.present) {
      map['adres_metni'] = Variable<String>(adresMetni.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KullaniciKayitlariCompanion(')
          ..write('id: $id, ')
          ..write('adSoyad: $adSoyad, ')
          ..write('telefon: $telefon, ')
          ..write('eposta: $eposta, ')
          ..write('rol: $rol, ')
          ..write('aktifMi: $aktifMi, ')
          ..write('adresMetni: $adresMetni, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MisafirKayitlariTable extends MisafirKayitlari
    with TableInfo<$MisafirKayitlariTable, MisafirKayitlariData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MisafirKayitlariTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _adSoyadMeta = const VerificationMeta(
    'adSoyad',
  );
  @override
  late final GeneratedColumn<String> adSoyad = GeneratedColumn<String>(
    'ad_soyad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonMeta = const VerificationMeta(
    'telefon',
  );
  @override
  late final GeneratedColumn<String> telefon = GeneratedColumn<String>(
    'telefon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _epostaMeta = const VerificationMeta('eposta');
  @override
  late final GeneratedColumn<String> eposta = GeneratedColumn<String>(
    'eposta',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _adresMeta = const VerificationMeta('adres');
  @override
  late final GeneratedColumn<String> adres = GeneratedColumn<String>(
    'adres',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [adSoyad, telefon, eposta, adres];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'misafir_kayitlari';
  @override
  VerificationContext validateIntegrity(
    Insertable<MisafirKayitlariData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ad_soyad')) {
      context.handle(
        _adSoyadMeta,
        adSoyad.isAcceptableOrUnknown(data['ad_soyad']!, _adSoyadMeta),
      );
    } else if (isInserting) {
      context.missing(_adSoyadMeta);
    }
    if (data.containsKey('telefon')) {
      context.handle(
        _telefonMeta,
        telefon.isAcceptableOrUnknown(data['telefon']!, _telefonMeta),
      );
    } else if (isInserting) {
      context.missing(_telefonMeta);
    }
    if (data.containsKey('eposta')) {
      context.handle(
        _epostaMeta,
        eposta.isAcceptableOrUnknown(data['eposta']!, _epostaMeta),
      );
    }
    if (data.containsKey('adres')) {
      context.handle(
        _adresMeta,
        adres.isAcceptableOrUnknown(data['adres']!, _adresMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {telefon};
  @override
  MisafirKayitlariData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MisafirKayitlariData(
      adSoyad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ad_soyad'],
      )!,
      telefon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefon'],
      )!,
      eposta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}eposta'],
      ),
      adres: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adres'],
      ),
    );
  }

  @override
  $MisafirKayitlariTable createAlias(String alias) {
    return $MisafirKayitlariTable(attachedDatabase, alias);
  }
}

class MisafirKayitlariData extends DataClass
    implements Insertable<MisafirKayitlariData> {
  final String adSoyad;
  final String telefon;
  final String? eposta;
  final String? adres;
  const MisafirKayitlariData({
    required this.adSoyad,
    required this.telefon,
    this.eposta,
    this.adres,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ad_soyad'] = Variable<String>(adSoyad);
    map['telefon'] = Variable<String>(telefon);
    if (!nullToAbsent || eposta != null) {
      map['eposta'] = Variable<String>(eposta);
    }
    if (!nullToAbsent || adres != null) {
      map['adres'] = Variable<String>(adres);
    }
    return map;
  }

  MisafirKayitlariCompanion toCompanion(bool nullToAbsent) {
    return MisafirKayitlariCompanion(
      adSoyad: Value(adSoyad),
      telefon: Value(telefon),
      eposta: eposta == null && nullToAbsent
          ? const Value.absent()
          : Value(eposta),
      adres: adres == null && nullToAbsent
          ? const Value.absent()
          : Value(adres),
    );
  }

  factory MisafirKayitlariData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MisafirKayitlariData(
      adSoyad: serializer.fromJson<String>(json['adSoyad']),
      telefon: serializer.fromJson<String>(json['telefon']),
      eposta: serializer.fromJson<String?>(json['eposta']),
      adres: serializer.fromJson<String?>(json['adres']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'adSoyad': serializer.toJson<String>(adSoyad),
      'telefon': serializer.toJson<String>(telefon),
      'eposta': serializer.toJson<String?>(eposta),
      'adres': serializer.toJson<String?>(adres),
    };
  }

  MisafirKayitlariData copyWith({
    String? adSoyad,
    String? telefon,
    Value<String?> eposta = const Value.absent(),
    Value<String?> adres = const Value.absent(),
  }) => MisafirKayitlariData(
    adSoyad: adSoyad ?? this.adSoyad,
    telefon: telefon ?? this.telefon,
    eposta: eposta.present ? eposta.value : this.eposta,
    adres: adres.present ? adres.value : this.adres,
  );
  MisafirKayitlariData copyWithCompanion(MisafirKayitlariCompanion data) {
    return MisafirKayitlariData(
      adSoyad: data.adSoyad.present ? data.adSoyad.value : this.adSoyad,
      telefon: data.telefon.present ? data.telefon.value : this.telefon,
      eposta: data.eposta.present ? data.eposta.value : this.eposta,
      adres: data.adres.present ? data.adres.value : this.adres,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MisafirKayitlariData(')
          ..write('adSoyad: $adSoyad, ')
          ..write('telefon: $telefon, ')
          ..write('eposta: $eposta, ')
          ..write('adres: $adres')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(adSoyad, telefon, eposta, adres);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MisafirKayitlariData &&
          other.adSoyad == this.adSoyad &&
          other.telefon == this.telefon &&
          other.eposta == this.eposta &&
          other.adres == this.adres);
}

class MisafirKayitlariCompanion extends UpdateCompanion<MisafirKayitlariData> {
  final Value<String> adSoyad;
  final Value<String> telefon;
  final Value<String?> eposta;
  final Value<String?> adres;
  final Value<int> rowid;
  const MisafirKayitlariCompanion({
    this.adSoyad = const Value.absent(),
    this.telefon = const Value.absent(),
    this.eposta = const Value.absent(),
    this.adres = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MisafirKayitlariCompanion.insert({
    required String adSoyad,
    required String telefon,
    this.eposta = const Value.absent(),
    this.adres = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : adSoyad = Value(adSoyad),
       telefon = Value(telefon);
  static Insertable<MisafirKayitlariData> custom({
    Expression<String>? adSoyad,
    Expression<String>? telefon,
    Expression<String>? eposta,
    Expression<String>? adres,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (adSoyad != null) 'ad_soyad': adSoyad,
      if (telefon != null) 'telefon': telefon,
      if (eposta != null) 'eposta': eposta,
      if (adres != null) 'adres': adres,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MisafirKayitlariCompanion copyWith({
    Value<String>? adSoyad,
    Value<String>? telefon,
    Value<String?>? eposta,
    Value<String?>? adres,
    Value<int>? rowid,
  }) {
    return MisafirKayitlariCompanion(
      adSoyad: adSoyad ?? this.adSoyad,
      telefon: telefon ?? this.telefon,
      eposta: eposta ?? this.eposta,
      adres: adres ?? this.adres,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (adSoyad.present) {
      map['ad_soyad'] = Variable<String>(adSoyad.value);
    }
    if (telefon.present) {
      map['telefon'] = Variable<String>(telefon.value);
    }
    if (eposta.present) {
      map['eposta'] = Variable<String>(eposta.value);
    }
    if (adres.present) {
      map['adres'] = Variable<String>(adres.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MisafirKayitlariCompanion(')
          ..write('adSoyad: $adSoyad, ')
          ..write('telefon: $telefon, ')
          ..write('eposta: $eposta, ')
          ..write('adres: $adres, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KategoriKayitlariTable extends KategoriKayitlari
    with TableInfo<$KategoriKayitlariTable, KategoriKayitlariData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KategoriKayitlariTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adMeta = const VerificationMeta('ad');
  @override
  late final GeneratedColumn<String> ad = GeneratedColumn<String>(
    'ad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siraMeta = const VerificationMeta('sira');
  @override
  late final GeneratedColumn<int> sira = GeneratedColumn<int>(
    'sira',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acikMiMeta = const VerificationMeta('acikMi');
  @override
  late final GeneratedColumn<bool> acikMi = GeneratedColumn<bool>(
    'acik_mi',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("acik_mi" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, ad, sira, acikMi];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kategori_kayitlari';
  @override
  VerificationContext validateIntegrity(
    Insertable<KategoriKayitlariData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ad')) {
      context.handle(_adMeta, ad.isAcceptableOrUnknown(data['ad']!, _adMeta));
    } else if (isInserting) {
      context.missing(_adMeta);
    }
    if (data.containsKey('sira')) {
      context.handle(
        _siraMeta,
        sira.isAcceptableOrUnknown(data['sira']!, _siraMeta),
      );
    } else if (isInserting) {
      context.missing(_siraMeta);
    }
    if (data.containsKey('acik_mi')) {
      context.handle(
        _acikMiMeta,
        acikMi.isAcceptableOrUnknown(data['acik_mi']!, _acikMiMeta),
      );
    } else if (isInserting) {
      context.missing(_acikMiMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KategoriKayitlariData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KategoriKayitlariData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ad'],
      )!,
      sira: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sira'],
      )!,
      acikMi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}acik_mi'],
      )!,
    );
  }

  @override
  $KategoriKayitlariTable createAlias(String alias) {
    return $KategoriKayitlariTable(attachedDatabase, alias);
  }
}

class KategoriKayitlariData extends DataClass
    implements Insertable<KategoriKayitlariData> {
  final String id;
  final String ad;
  final int sira;
  final bool acikMi;
  const KategoriKayitlariData({
    required this.id,
    required this.ad,
    required this.sira,
    required this.acikMi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ad'] = Variable<String>(ad);
    map['sira'] = Variable<int>(sira);
    map['acik_mi'] = Variable<bool>(acikMi);
    return map;
  }

  KategoriKayitlariCompanion toCompanion(bool nullToAbsent) {
    return KategoriKayitlariCompanion(
      id: Value(id),
      ad: Value(ad),
      sira: Value(sira),
      acikMi: Value(acikMi),
    );
  }

  factory KategoriKayitlariData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KategoriKayitlariData(
      id: serializer.fromJson<String>(json['id']),
      ad: serializer.fromJson<String>(json['ad']),
      sira: serializer.fromJson<int>(json['sira']),
      acikMi: serializer.fromJson<bool>(json['acikMi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ad': serializer.toJson<String>(ad),
      'sira': serializer.toJson<int>(sira),
      'acikMi': serializer.toJson<bool>(acikMi),
    };
  }

  KategoriKayitlariData copyWith({
    String? id,
    String? ad,
    int? sira,
    bool? acikMi,
  }) => KategoriKayitlariData(
    id: id ?? this.id,
    ad: ad ?? this.ad,
    sira: sira ?? this.sira,
    acikMi: acikMi ?? this.acikMi,
  );
  KategoriKayitlariData copyWithCompanion(KategoriKayitlariCompanion data) {
    return KategoriKayitlariData(
      id: data.id.present ? data.id.value : this.id,
      ad: data.ad.present ? data.ad.value : this.ad,
      sira: data.sira.present ? data.sira.value : this.sira,
      acikMi: data.acikMi.present ? data.acikMi.value : this.acikMi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KategoriKayitlariData(')
          ..write('id: $id, ')
          ..write('ad: $ad, ')
          ..write('sira: $sira, ')
          ..write('acikMi: $acikMi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ad, sira, acikMi);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KategoriKayitlariData &&
          other.id == this.id &&
          other.ad == this.ad &&
          other.sira == this.sira &&
          other.acikMi == this.acikMi);
}

class KategoriKayitlariCompanion
    extends UpdateCompanion<KategoriKayitlariData> {
  final Value<String> id;
  final Value<String> ad;
  final Value<int> sira;
  final Value<bool> acikMi;
  final Value<int> rowid;
  const KategoriKayitlariCompanion({
    this.id = const Value.absent(),
    this.ad = const Value.absent(),
    this.sira = const Value.absent(),
    this.acikMi = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KategoriKayitlariCompanion.insert({
    required String id,
    required String ad,
    required int sira,
    required bool acikMi,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ad = Value(ad),
       sira = Value(sira),
       acikMi = Value(acikMi);
  static Insertable<KategoriKayitlariData> custom({
    Expression<String>? id,
    Expression<String>? ad,
    Expression<int>? sira,
    Expression<bool>? acikMi,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ad != null) 'ad': ad,
      if (sira != null) 'sira': sira,
      if (acikMi != null) 'acik_mi': acikMi,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KategoriKayitlariCompanion copyWith({
    Value<String>? id,
    Value<String>? ad,
    Value<int>? sira,
    Value<bool>? acikMi,
    Value<int>? rowid,
  }) {
    return KategoriKayitlariCompanion(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      sira: sira ?? this.sira,
      acikMi: acikMi ?? this.acikMi,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ad.present) {
      map['ad'] = Variable<String>(ad.value);
    }
    if (sira.present) {
      map['sira'] = Variable<int>(sira.value);
    }
    if (acikMi.present) {
      map['acik_mi'] = Variable<bool>(acikMi.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KategoriKayitlariCompanion(')
          ..write('id: $id, ')
          ..write('ad: $ad, ')
          ..write('sira: $sira, ')
          ..write('acikMi: $acikMi, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UrunKayitlariTable extends UrunKayitlari
    with TableInfo<$UrunKayitlariTable, UrunKayitlariData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UrunKayitlariTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kategoriIdMeta = const VerificationMeta(
    'kategoriId',
  );
  @override
  late final GeneratedColumn<String> kategoriId = GeneratedColumn<String>(
    'kategori_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adMeta = const VerificationMeta('ad');
  @override
  late final GeneratedColumn<String> ad = GeneratedColumn<String>(
    'ad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aciklamaMeta = const VerificationMeta(
    'aciklama',
  );
  @override
  late final GeneratedColumn<String> aciklama = GeneratedColumn<String>(
    'aciklama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiyatMeta = const VerificationMeta('fiyat');
  @override
  late final GeneratedColumn<double> fiyat = GeneratedColumn<double>(
    'fiyat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gorselUrlMeta = const VerificationMeta(
    'gorselUrl',
  );
  @override
  late final GeneratedColumn<String> gorselUrl = GeneratedColumn<String>(
    'gorsel_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stoktaMiMeta = const VerificationMeta(
    'stoktaMi',
  );
  @override
  late final GeneratedColumn<bool> stoktaMi = GeneratedColumn<bool>(
    'stokta_mi',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("stokta_mi" IN (0, 1))',
    ),
  );
  static const VerificationMeta _oneCikanMiMeta = const VerificationMeta(
    'oneCikanMi',
  );
  @override
  late final GeneratedColumn<bool> oneCikanMi = GeneratedColumn<bool>(
    'one_cikan_mi',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("one_cikan_mi" IN (0, 1))',
    ),
  );
  static const VerificationMeta _seceneklerJsonMeta = const VerificationMeta(
    'seceneklerJson',
  );
  @override
  late final GeneratedColumn<String> seceneklerJson = GeneratedColumn<String>(
    'secenekler_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kategoriId,
    ad,
    aciklama,
    fiyat,
    gorselUrl,
    stoktaMi,
    oneCikanMi,
    seceneklerJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'urun_kayitlari';
  @override
  VerificationContext validateIntegrity(
    Insertable<UrunKayitlariData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kategori_id')) {
      context.handle(
        _kategoriIdMeta,
        kategoriId.isAcceptableOrUnknown(data['kategori_id']!, _kategoriIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kategoriIdMeta);
    }
    if (data.containsKey('ad')) {
      context.handle(_adMeta, ad.isAcceptableOrUnknown(data['ad']!, _adMeta));
    } else if (isInserting) {
      context.missing(_adMeta);
    }
    if (data.containsKey('aciklama')) {
      context.handle(
        _aciklamaMeta,
        aciklama.isAcceptableOrUnknown(data['aciklama']!, _aciklamaMeta),
      );
    } else if (isInserting) {
      context.missing(_aciklamaMeta);
    }
    if (data.containsKey('fiyat')) {
      context.handle(
        _fiyatMeta,
        fiyat.isAcceptableOrUnknown(data['fiyat']!, _fiyatMeta),
      );
    } else if (isInserting) {
      context.missing(_fiyatMeta);
    }
    if (data.containsKey('gorsel_url')) {
      context.handle(
        _gorselUrlMeta,
        gorselUrl.isAcceptableOrUnknown(data['gorsel_url']!, _gorselUrlMeta),
      );
    }
    if (data.containsKey('stokta_mi')) {
      context.handle(
        _stoktaMiMeta,
        stoktaMi.isAcceptableOrUnknown(data['stokta_mi']!, _stoktaMiMeta),
      );
    } else if (isInserting) {
      context.missing(_stoktaMiMeta);
    }
    if (data.containsKey('one_cikan_mi')) {
      context.handle(
        _oneCikanMiMeta,
        oneCikanMi.isAcceptableOrUnknown(
          data['one_cikan_mi']!,
          _oneCikanMiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_oneCikanMiMeta);
    }
    if (data.containsKey('secenekler_json')) {
      context.handle(
        _seceneklerJsonMeta,
        seceneklerJson.isAcceptableOrUnknown(
          data['secenekler_json']!,
          _seceneklerJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_seceneklerJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UrunKayitlariData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UrunKayitlariData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kategoriId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kategori_id'],
      )!,
      ad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ad'],
      )!,
      aciklama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aciklama'],
      )!,
      fiyat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiyat'],
      )!,
      gorselUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gorsel_url'],
      ),
      stoktaMi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}stokta_mi'],
      )!,
      oneCikanMi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}one_cikan_mi'],
      )!,
      seceneklerJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secenekler_json'],
      )!,
    );
  }

  @override
  $UrunKayitlariTable createAlias(String alias) {
    return $UrunKayitlariTable(attachedDatabase, alias);
  }
}

class UrunKayitlariData extends DataClass
    implements Insertable<UrunKayitlariData> {
  final String id;
  final String kategoriId;
  final String ad;
  final String aciklama;
  final double fiyat;
  final String? gorselUrl;
  final bool stoktaMi;
  final bool oneCikanMi;
  final String seceneklerJson;
  const UrunKayitlariData({
    required this.id,
    required this.kategoriId,
    required this.ad,
    required this.aciklama,
    required this.fiyat,
    this.gorselUrl,
    required this.stoktaMi,
    required this.oneCikanMi,
    required this.seceneklerJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kategori_id'] = Variable<String>(kategoriId);
    map['ad'] = Variable<String>(ad);
    map['aciklama'] = Variable<String>(aciklama);
    map['fiyat'] = Variable<double>(fiyat);
    if (!nullToAbsent || gorselUrl != null) {
      map['gorsel_url'] = Variable<String>(gorselUrl);
    }
    map['stokta_mi'] = Variable<bool>(stoktaMi);
    map['one_cikan_mi'] = Variable<bool>(oneCikanMi);
    map['secenekler_json'] = Variable<String>(seceneklerJson);
    return map;
  }

  UrunKayitlariCompanion toCompanion(bool nullToAbsent) {
    return UrunKayitlariCompanion(
      id: Value(id),
      kategoriId: Value(kategoriId),
      ad: Value(ad),
      aciklama: Value(aciklama),
      fiyat: Value(fiyat),
      gorselUrl: gorselUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(gorselUrl),
      stoktaMi: Value(stoktaMi),
      oneCikanMi: Value(oneCikanMi),
      seceneklerJson: Value(seceneklerJson),
    );
  }

  factory UrunKayitlariData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UrunKayitlariData(
      id: serializer.fromJson<String>(json['id']),
      kategoriId: serializer.fromJson<String>(json['kategoriId']),
      ad: serializer.fromJson<String>(json['ad']),
      aciklama: serializer.fromJson<String>(json['aciklama']),
      fiyat: serializer.fromJson<double>(json['fiyat']),
      gorselUrl: serializer.fromJson<String?>(json['gorselUrl']),
      stoktaMi: serializer.fromJson<bool>(json['stoktaMi']),
      oneCikanMi: serializer.fromJson<bool>(json['oneCikanMi']),
      seceneklerJson: serializer.fromJson<String>(json['seceneklerJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kategoriId': serializer.toJson<String>(kategoriId),
      'ad': serializer.toJson<String>(ad),
      'aciklama': serializer.toJson<String>(aciklama),
      'fiyat': serializer.toJson<double>(fiyat),
      'gorselUrl': serializer.toJson<String?>(gorselUrl),
      'stoktaMi': serializer.toJson<bool>(stoktaMi),
      'oneCikanMi': serializer.toJson<bool>(oneCikanMi),
      'seceneklerJson': serializer.toJson<String>(seceneklerJson),
    };
  }

  UrunKayitlariData copyWith({
    String? id,
    String? kategoriId,
    String? ad,
    String? aciklama,
    double? fiyat,
    Value<String?> gorselUrl = const Value.absent(),
    bool? stoktaMi,
    bool? oneCikanMi,
    String? seceneklerJson,
  }) => UrunKayitlariData(
    id: id ?? this.id,
    kategoriId: kategoriId ?? this.kategoriId,
    ad: ad ?? this.ad,
    aciklama: aciklama ?? this.aciklama,
    fiyat: fiyat ?? this.fiyat,
    gorselUrl: gorselUrl.present ? gorselUrl.value : this.gorselUrl,
    stoktaMi: stoktaMi ?? this.stoktaMi,
    oneCikanMi: oneCikanMi ?? this.oneCikanMi,
    seceneklerJson: seceneklerJson ?? this.seceneklerJson,
  );
  UrunKayitlariData copyWithCompanion(UrunKayitlariCompanion data) {
    return UrunKayitlariData(
      id: data.id.present ? data.id.value : this.id,
      kategoriId: data.kategoriId.present
          ? data.kategoriId.value
          : this.kategoriId,
      ad: data.ad.present ? data.ad.value : this.ad,
      aciklama: data.aciklama.present ? data.aciklama.value : this.aciklama,
      fiyat: data.fiyat.present ? data.fiyat.value : this.fiyat,
      gorselUrl: data.gorselUrl.present ? data.gorselUrl.value : this.gorselUrl,
      stoktaMi: data.stoktaMi.present ? data.stoktaMi.value : this.stoktaMi,
      oneCikanMi: data.oneCikanMi.present
          ? data.oneCikanMi.value
          : this.oneCikanMi,
      seceneklerJson: data.seceneklerJson.present
          ? data.seceneklerJson.value
          : this.seceneklerJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UrunKayitlariData(')
          ..write('id: $id, ')
          ..write('kategoriId: $kategoriId, ')
          ..write('ad: $ad, ')
          ..write('aciklama: $aciklama, ')
          ..write('fiyat: $fiyat, ')
          ..write('gorselUrl: $gorselUrl, ')
          ..write('stoktaMi: $stoktaMi, ')
          ..write('oneCikanMi: $oneCikanMi, ')
          ..write('seceneklerJson: $seceneklerJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kategoriId,
    ad,
    aciklama,
    fiyat,
    gorselUrl,
    stoktaMi,
    oneCikanMi,
    seceneklerJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UrunKayitlariData &&
          other.id == this.id &&
          other.kategoriId == this.kategoriId &&
          other.ad == this.ad &&
          other.aciklama == this.aciklama &&
          other.fiyat == this.fiyat &&
          other.gorselUrl == this.gorselUrl &&
          other.stoktaMi == this.stoktaMi &&
          other.oneCikanMi == this.oneCikanMi &&
          other.seceneklerJson == this.seceneklerJson);
}

class UrunKayitlariCompanion extends UpdateCompanion<UrunKayitlariData> {
  final Value<String> id;
  final Value<String> kategoriId;
  final Value<String> ad;
  final Value<String> aciklama;
  final Value<double> fiyat;
  final Value<String?> gorselUrl;
  final Value<bool> stoktaMi;
  final Value<bool> oneCikanMi;
  final Value<String> seceneklerJson;
  final Value<int> rowid;
  const UrunKayitlariCompanion({
    this.id = const Value.absent(),
    this.kategoriId = const Value.absent(),
    this.ad = const Value.absent(),
    this.aciklama = const Value.absent(),
    this.fiyat = const Value.absent(),
    this.gorselUrl = const Value.absent(),
    this.stoktaMi = const Value.absent(),
    this.oneCikanMi = const Value.absent(),
    this.seceneklerJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UrunKayitlariCompanion.insert({
    required String id,
    required String kategoriId,
    required String ad,
    required String aciklama,
    required double fiyat,
    this.gorselUrl = const Value.absent(),
    required bool stoktaMi,
    required bool oneCikanMi,
    required String seceneklerJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kategoriId = Value(kategoriId),
       ad = Value(ad),
       aciklama = Value(aciklama),
       fiyat = Value(fiyat),
       stoktaMi = Value(stoktaMi),
       oneCikanMi = Value(oneCikanMi),
       seceneklerJson = Value(seceneklerJson);
  static Insertable<UrunKayitlariData> custom({
    Expression<String>? id,
    Expression<String>? kategoriId,
    Expression<String>? ad,
    Expression<String>? aciklama,
    Expression<double>? fiyat,
    Expression<String>? gorselUrl,
    Expression<bool>? stoktaMi,
    Expression<bool>? oneCikanMi,
    Expression<String>? seceneklerJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kategoriId != null) 'kategori_id': kategoriId,
      if (ad != null) 'ad': ad,
      if (aciklama != null) 'aciklama': aciklama,
      if (fiyat != null) 'fiyat': fiyat,
      if (gorselUrl != null) 'gorsel_url': gorselUrl,
      if (stoktaMi != null) 'stokta_mi': stoktaMi,
      if (oneCikanMi != null) 'one_cikan_mi': oneCikanMi,
      if (seceneklerJson != null) 'secenekler_json': seceneklerJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UrunKayitlariCompanion copyWith({
    Value<String>? id,
    Value<String>? kategoriId,
    Value<String>? ad,
    Value<String>? aciklama,
    Value<double>? fiyat,
    Value<String?>? gorselUrl,
    Value<bool>? stoktaMi,
    Value<bool>? oneCikanMi,
    Value<String>? seceneklerJson,
    Value<int>? rowid,
  }) {
    return UrunKayitlariCompanion(
      id: id ?? this.id,
      kategoriId: kategoriId ?? this.kategoriId,
      ad: ad ?? this.ad,
      aciklama: aciklama ?? this.aciklama,
      fiyat: fiyat ?? this.fiyat,
      gorselUrl: gorselUrl ?? this.gorselUrl,
      stoktaMi: stoktaMi ?? this.stoktaMi,
      oneCikanMi: oneCikanMi ?? this.oneCikanMi,
      seceneklerJson: seceneklerJson ?? this.seceneklerJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kategoriId.present) {
      map['kategori_id'] = Variable<String>(kategoriId.value);
    }
    if (ad.present) {
      map['ad'] = Variable<String>(ad.value);
    }
    if (aciklama.present) {
      map['aciklama'] = Variable<String>(aciklama.value);
    }
    if (fiyat.present) {
      map['fiyat'] = Variable<double>(fiyat.value);
    }
    if (gorselUrl.present) {
      map['gorsel_url'] = Variable<String>(gorselUrl.value);
    }
    if (stoktaMi.present) {
      map['stokta_mi'] = Variable<bool>(stoktaMi.value);
    }
    if (oneCikanMi.present) {
      map['one_cikan_mi'] = Variable<bool>(oneCikanMi.value);
    }
    if (seceneklerJson.present) {
      map['secenekler_json'] = Variable<String>(seceneklerJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UrunKayitlariCompanion(')
          ..write('id: $id, ')
          ..write('kategoriId: $kategoriId, ')
          ..write('ad: $ad, ')
          ..write('aciklama: $aciklama, ')
          ..write('fiyat: $fiyat, ')
          ..write('gorselUrl: $gorselUrl, ')
          ..write('stoktaMi: $stoktaMi, ')
          ..write('oneCikanMi: $oneCikanMi, ')
          ..write('seceneklerJson: $seceneklerJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SepetKayitlariTable extends SepetKayitlari
    with TableInfo<$SepetKayitlariTable, SepetKayitlariData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SepetKayitlariTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kuponKoduMeta = const VerificationMeta(
    'kuponKodu',
  );
  @override
  late final GeneratedColumn<String> kuponKodu = GeneratedColumn<String>(
    'kupon_kodu',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, kuponKodu];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sepet_kayitlari';
  @override
  VerificationContext validateIntegrity(
    Insertable<SepetKayitlariData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kupon_kodu')) {
      context.handle(
        _kuponKoduMeta,
        kuponKodu.isAcceptableOrUnknown(data['kupon_kodu']!, _kuponKoduMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SepetKayitlariData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SepetKayitlariData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kuponKodu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kupon_kodu'],
      ),
    );
  }

  @override
  $SepetKayitlariTable createAlias(String alias) {
    return $SepetKayitlariTable(attachedDatabase, alias);
  }
}

class SepetKayitlariData extends DataClass
    implements Insertable<SepetKayitlariData> {
  final String id;
  final String? kuponKodu;
  const SepetKayitlariData({required this.id, this.kuponKodu});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || kuponKodu != null) {
      map['kupon_kodu'] = Variable<String>(kuponKodu);
    }
    return map;
  }

  SepetKayitlariCompanion toCompanion(bool nullToAbsent) {
    return SepetKayitlariCompanion(
      id: Value(id),
      kuponKodu: kuponKodu == null && nullToAbsent
          ? const Value.absent()
          : Value(kuponKodu),
    );
  }

  factory SepetKayitlariData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SepetKayitlariData(
      id: serializer.fromJson<String>(json['id']),
      kuponKodu: serializer.fromJson<String?>(json['kuponKodu']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kuponKodu': serializer.toJson<String?>(kuponKodu),
    };
  }

  SepetKayitlariData copyWith({
    String? id,
    Value<String?> kuponKodu = const Value.absent(),
  }) => SepetKayitlariData(
    id: id ?? this.id,
    kuponKodu: kuponKodu.present ? kuponKodu.value : this.kuponKodu,
  );
  SepetKayitlariData copyWithCompanion(SepetKayitlariCompanion data) {
    return SepetKayitlariData(
      id: data.id.present ? data.id.value : this.id,
      kuponKodu: data.kuponKodu.present ? data.kuponKodu.value : this.kuponKodu,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SepetKayitlariData(')
          ..write('id: $id, ')
          ..write('kuponKodu: $kuponKodu')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kuponKodu);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SepetKayitlariData &&
          other.id == this.id &&
          other.kuponKodu == this.kuponKodu);
}

class SepetKayitlariCompanion extends UpdateCompanion<SepetKayitlariData> {
  final Value<String> id;
  final Value<String?> kuponKodu;
  final Value<int> rowid;
  const SepetKayitlariCompanion({
    this.id = const Value.absent(),
    this.kuponKodu = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SepetKayitlariCompanion.insert({
    required String id,
    this.kuponKodu = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<SepetKayitlariData> custom({
    Expression<String>? id,
    Expression<String>? kuponKodu,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kuponKodu != null) 'kupon_kodu': kuponKodu,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SepetKayitlariCompanion copyWith({
    Value<String>? id,
    Value<String?>? kuponKodu,
    Value<int>? rowid,
  }) {
    return SepetKayitlariCompanion(
      id: id ?? this.id,
      kuponKodu: kuponKodu ?? this.kuponKodu,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kuponKodu.present) {
      map['kupon_kodu'] = Variable<String>(kuponKodu.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SepetKayitlariCompanion(')
          ..write('id: $id, ')
          ..write('kuponKodu: $kuponKodu, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SepetKalemleriTable extends SepetKalemleri
    with TableInfo<$SepetKalemleriTable, SepetKalemleriData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SepetKalemleriTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sepetIdMeta = const VerificationMeta(
    'sepetId',
  );
  @override
  late final GeneratedColumn<String> sepetId = GeneratedColumn<String>(
    'sepet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urunIdMeta = const VerificationMeta('urunId');
  @override
  late final GeneratedColumn<String> urunId = GeneratedColumn<String>(
    'urun_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birimFiyatMeta = const VerificationMeta(
    'birimFiyat',
  );
  @override
  late final GeneratedColumn<double> birimFiyat = GeneratedColumn<double>(
    'birim_fiyat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adetMeta = const VerificationMeta('adet');
  @override
  late final GeneratedColumn<int> adet = GeneratedColumn<int>(
    'adet',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secenekAdiMeta = const VerificationMeta(
    'secenekAdi',
  );
  @override
  late final GeneratedColumn<String> secenekAdi = GeneratedColumn<String>(
    'secenek_adi',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notMetniMeta = const VerificationMeta(
    'notMetni',
  );
  @override
  late final GeneratedColumn<String> notMetni = GeneratedColumn<String>(
    'not_metni',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sepetId,
    urunId,
    birimFiyat,
    adet,
    secenekAdi,
    notMetni,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sepet_kalemleri';
  @override
  VerificationContext validateIntegrity(
    Insertable<SepetKalemleriData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sepet_id')) {
      context.handle(
        _sepetIdMeta,
        sepetId.isAcceptableOrUnknown(data['sepet_id']!, _sepetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sepetIdMeta);
    }
    if (data.containsKey('urun_id')) {
      context.handle(
        _urunIdMeta,
        urunId.isAcceptableOrUnknown(data['urun_id']!, _urunIdMeta),
      );
    } else if (isInserting) {
      context.missing(_urunIdMeta);
    }
    if (data.containsKey('birim_fiyat')) {
      context.handle(
        _birimFiyatMeta,
        birimFiyat.isAcceptableOrUnknown(data['birim_fiyat']!, _birimFiyatMeta),
      );
    } else if (isInserting) {
      context.missing(_birimFiyatMeta);
    }
    if (data.containsKey('adet')) {
      context.handle(
        _adetMeta,
        adet.isAcceptableOrUnknown(data['adet']!, _adetMeta),
      );
    } else if (isInserting) {
      context.missing(_adetMeta);
    }
    if (data.containsKey('secenek_adi')) {
      context.handle(
        _secenekAdiMeta,
        secenekAdi.isAcceptableOrUnknown(data['secenek_adi']!, _secenekAdiMeta),
      );
    }
    if (data.containsKey('not_metni')) {
      context.handle(
        _notMetniMeta,
        notMetni.isAcceptableOrUnknown(data['not_metni']!, _notMetniMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SepetKalemleriData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SepetKalemleriData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sepetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sepet_id'],
      )!,
      urunId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}urun_id'],
      )!,
      birimFiyat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birim_fiyat'],
      )!,
      adet: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}adet'],
      )!,
      secenekAdi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secenek_adi'],
      ),
      notMetni: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}not_metni'],
      ),
    );
  }

  @override
  $SepetKalemleriTable createAlias(String alias) {
    return $SepetKalemleriTable(attachedDatabase, alias);
  }
}

class SepetKalemleriData extends DataClass
    implements Insertable<SepetKalemleriData> {
  final String id;
  final String sepetId;
  final String urunId;
  final double birimFiyat;
  final int adet;
  final String? secenekAdi;
  final String? notMetni;
  const SepetKalemleriData({
    required this.id,
    required this.sepetId,
    required this.urunId,
    required this.birimFiyat,
    required this.adet,
    this.secenekAdi,
    this.notMetni,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sepet_id'] = Variable<String>(sepetId);
    map['urun_id'] = Variable<String>(urunId);
    map['birim_fiyat'] = Variable<double>(birimFiyat);
    map['adet'] = Variable<int>(adet);
    if (!nullToAbsent || secenekAdi != null) {
      map['secenek_adi'] = Variable<String>(secenekAdi);
    }
    if (!nullToAbsent || notMetni != null) {
      map['not_metni'] = Variable<String>(notMetni);
    }
    return map;
  }

  SepetKalemleriCompanion toCompanion(bool nullToAbsent) {
    return SepetKalemleriCompanion(
      id: Value(id),
      sepetId: Value(sepetId),
      urunId: Value(urunId),
      birimFiyat: Value(birimFiyat),
      adet: Value(adet),
      secenekAdi: secenekAdi == null && nullToAbsent
          ? const Value.absent()
          : Value(secenekAdi),
      notMetni: notMetni == null && nullToAbsent
          ? const Value.absent()
          : Value(notMetni),
    );
  }

  factory SepetKalemleriData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SepetKalemleriData(
      id: serializer.fromJson<String>(json['id']),
      sepetId: serializer.fromJson<String>(json['sepetId']),
      urunId: serializer.fromJson<String>(json['urunId']),
      birimFiyat: serializer.fromJson<double>(json['birimFiyat']),
      adet: serializer.fromJson<int>(json['adet']),
      secenekAdi: serializer.fromJson<String?>(json['secenekAdi']),
      notMetni: serializer.fromJson<String?>(json['notMetni']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sepetId': serializer.toJson<String>(sepetId),
      'urunId': serializer.toJson<String>(urunId),
      'birimFiyat': serializer.toJson<double>(birimFiyat),
      'adet': serializer.toJson<int>(adet),
      'secenekAdi': serializer.toJson<String?>(secenekAdi),
      'notMetni': serializer.toJson<String?>(notMetni),
    };
  }

  SepetKalemleriData copyWith({
    String? id,
    String? sepetId,
    String? urunId,
    double? birimFiyat,
    int? adet,
    Value<String?> secenekAdi = const Value.absent(),
    Value<String?> notMetni = const Value.absent(),
  }) => SepetKalemleriData(
    id: id ?? this.id,
    sepetId: sepetId ?? this.sepetId,
    urunId: urunId ?? this.urunId,
    birimFiyat: birimFiyat ?? this.birimFiyat,
    adet: adet ?? this.adet,
    secenekAdi: secenekAdi.present ? secenekAdi.value : this.secenekAdi,
    notMetni: notMetni.present ? notMetni.value : this.notMetni,
  );
  SepetKalemleriData copyWithCompanion(SepetKalemleriCompanion data) {
    return SepetKalemleriData(
      id: data.id.present ? data.id.value : this.id,
      sepetId: data.sepetId.present ? data.sepetId.value : this.sepetId,
      urunId: data.urunId.present ? data.urunId.value : this.urunId,
      birimFiyat: data.birimFiyat.present
          ? data.birimFiyat.value
          : this.birimFiyat,
      adet: data.adet.present ? data.adet.value : this.adet,
      secenekAdi: data.secenekAdi.present
          ? data.secenekAdi.value
          : this.secenekAdi,
      notMetni: data.notMetni.present ? data.notMetni.value : this.notMetni,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SepetKalemleriData(')
          ..write('id: $id, ')
          ..write('sepetId: $sepetId, ')
          ..write('urunId: $urunId, ')
          ..write('birimFiyat: $birimFiyat, ')
          ..write('adet: $adet, ')
          ..write('secenekAdi: $secenekAdi, ')
          ..write('notMetni: $notMetni')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sepetId, urunId, birimFiyat, adet, secenekAdi, notMetni);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SepetKalemleriData &&
          other.id == this.id &&
          other.sepetId == this.sepetId &&
          other.urunId == this.urunId &&
          other.birimFiyat == this.birimFiyat &&
          other.adet == this.adet &&
          other.secenekAdi == this.secenekAdi &&
          other.notMetni == this.notMetni);
}

class SepetKalemleriCompanion extends UpdateCompanion<SepetKalemleriData> {
  final Value<String> id;
  final Value<String> sepetId;
  final Value<String> urunId;
  final Value<double> birimFiyat;
  final Value<int> adet;
  final Value<String?> secenekAdi;
  final Value<String?> notMetni;
  final Value<int> rowid;
  const SepetKalemleriCompanion({
    this.id = const Value.absent(),
    this.sepetId = const Value.absent(),
    this.urunId = const Value.absent(),
    this.birimFiyat = const Value.absent(),
    this.adet = const Value.absent(),
    this.secenekAdi = const Value.absent(),
    this.notMetni = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SepetKalemleriCompanion.insert({
    required String id,
    required String sepetId,
    required String urunId,
    required double birimFiyat,
    required int adet,
    this.secenekAdi = const Value.absent(),
    this.notMetni = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sepetId = Value(sepetId),
       urunId = Value(urunId),
       birimFiyat = Value(birimFiyat),
       adet = Value(adet);
  static Insertable<SepetKalemleriData> custom({
    Expression<String>? id,
    Expression<String>? sepetId,
    Expression<String>? urunId,
    Expression<double>? birimFiyat,
    Expression<int>? adet,
    Expression<String>? secenekAdi,
    Expression<String>? notMetni,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sepetId != null) 'sepet_id': sepetId,
      if (urunId != null) 'urun_id': urunId,
      if (birimFiyat != null) 'birim_fiyat': birimFiyat,
      if (adet != null) 'adet': adet,
      if (secenekAdi != null) 'secenek_adi': secenekAdi,
      if (notMetni != null) 'not_metni': notMetni,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SepetKalemleriCompanion copyWith({
    Value<String>? id,
    Value<String>? sepetId,
    Value<String>? urunId,
    Value<double>? birimFiyat,
    Value<int>? adet,
    Value<String?>? secenekAdi,
    Value<String?>? notMetni,
    Value<int>? rowid,
  }) {
    return SepetKalemleriCompanion(
      id: id ?? this.id,
      sepetId: sepetId ?? this.sepetId,
      urunId: urunId ?? this.urunId,
      birimFiyat: birimFiyat ?? this.birimFiyat,
      adet: adet ?? this.adet,
      secenekAdi: secenekAdi ?? this.secenekAdi,
      notMetni: notMetni ?? this.notMetni,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sepetId.present) {
      map['sepet_id'] = Variable<String>(sepetId.value);
    }
    if (urunId.present) {
      map['urun_id'] = Variable<String>(urunId.value);
    }
    if (birimFiyat.present) {
      map['birim_fiyat'] = Variable<double>(birimFiyat.value);
    }
    if (adet.present) {
      map['adet'] = Variable<int>(adet.value);
    }
    if (secenekAdi.present) {
      map['secenek_adi'] = Variable<String>(secenekAdi.value);
    }
    if (notMetni.present) {
      map['not_metni'] = Variable<String>(notMetni.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SepetKalemleriCompanion(')
          ..write('id: $id, ')
          ..write('sepetId: $sepetId, ')
          ..write('urunId: $urunId, ')
          ..write('birimFiyat: $birimFiyat, ')
          ..write('adet: $adet, ')
          ..write('secenekAdi: $secenekAdi, ')
          ..write('notMetni: $notMetni, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SiparisKayitlariTable extends SiparisKayitlari
    with TableInfo<$SiparisKayitlariTable, SiparisKayitlariData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SiparisKayitlariTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siparisNoMeta = const VerificationMeta(
    'siparisNo',
  );
  @override
  late final GeneratedColumn<String> siparisNo = GeneratedColumn<String>(
    'siparis_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teslimatTipiMeta = const VerificationMeta(
    'teslimatTipi',
  );
  @override
  late final GeneratedColumn<int> teslimatTipi = GeneratedColumn<int>(
    'teslimat_tipi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durumMeta = const VerificationMeta('durum');
  @override
  late final GeneratedColumn<int> durum = GeneratedColumn<int>(
    'durum',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _olusturmaTarihiMeta = const VerificationMeta(
    'olusturmaTarihi',
  );
  @override
  late final GeneratedColumn<DateTime> olusturmaTarihi =
      GeneratedColumn<DateTime>(
        'olusturma_tarihi',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _adresMetniMeta = const VerificationMeta(
    'adresMetni',
  );
  @override
  late final GeneratedColumn<String> adresMetni = GeneratedColumn<String>(
    'adres_metni',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _teslimatNotuMeta = const VerificationMeta(
    'teslimatNotu',
  );
  @override
  late final GeneratedColumn<String> teslimatNotu = GeneratedColumn<String>(
    'teslimat_notu',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kuryeAdiMeta = const VerificationMeta(
    'kuryeAdi',
  );
  @override
  late final GeneratedColumn<String> kuryeAdi = GeneratedColumn<String>(
    'kurye_adi',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paketTeslimatDurumuMeta =
      const VerificationMeta('paketTeslimatDurumu');
  @override
  late final GeneratedColumn<int> paketTeslimatDurumu = GeneratedColumn<int>(
    'paket_teslimat_durumu',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _masaNoMeta = const VerificationMeta('masaNo');
  @override
  late final GeneratedColumn<String> masaNo = GeneratedColumn<String>(
    'masa_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bolumAdiMeta = const VerificationMeta(
    'bolumAdi',
  );
  @override
  late final GeneratedColumn<String> bolumAdi = GeneratedColumn<String>(
    'bolum_adi',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kaynakMeta = const VerificationMeta('kaynak');
  @override
  late final GeneratedColumn<String> kaynak = GeneratedColumn<String>(
    'kaynak',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sahipMisafirMeta = const VerificationMeta(
    'sahipMisafir',
  );
  @override
  late final GeneratedColumn<bool> sahipMisafir = GeneratedColumn<bool>(
    'sahip_misafir',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sahip_misafir" IN (0, 1))',
    ),
  );
  static const VerificationMeta _sahipAdSoyadMeta = const VerificationMeta(
    'sahipAdSoyad',
  );
  @override
  late final GeneratedColumn<String> sahipAdSoyad = GeneratedColumn<String>(
    'sahip_ad_soyad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sahipTelefonMeta = const VerificationMeta(
    'sahipTelefon',
  );
  @override
  late final GeneratedColumn<String> sahipTelefon = GeneratedColumn<String>(
    'sahip_telefon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sahipEpostaMeta = const VerificationMeta(
    'sahipEposta',
  );
  @override
  late final GeneratedColumn<String> sahipEposta = GeneratedColumn<String>(
    'sahip_eposta',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sahipAdresMeta = const VerificationMeta(
    'sahipAdres',
  );
  @override
  late final GeneratedColumn<String> sahipAdres = GeneratedColumn<String>(
    'sahip_adres',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    siparisNo,
    teslimatTipi,
    durum,
    olusturmaTarihi,
    adresMetni,
    teslimatNotu,
    kuryeAdi,
    paketTeslimatDurumu,
    masaNo,
    bolumAdi,
    kaynak,
    sahipMisafir,
    sahipAdSoyad,
    sahipTelefon,
    sahipEposta,
    sahipAdres,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'siparis_kayitlari';
  @override
  VerificationContext validateIntegrity(
    Insertable<SiparisKayitlariData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('siparis_no')) {
      context.handle(
        _siparisNoMeta,
        siparisNo.isAcceptableOrUnknown(data['siparis_no']!, _siparisNoMeta),
      );
    } else if (isInserting) {
      context.missing(_siparisNoMeta);
    }
    if (data.containsKey('teslimat_tipi')) {
      context.handle(
        _teslimatTipiMeta,
        teslimatTipi.isAcceptableOrUnknown(
          data['teslimat_tipi']!,
          _teslimatTipiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_teslimatTipiMeta);
    }
    if (data.containsKey('durum')) {
      context.handle(
        _durumMeta,
        durum.isAcceptableOrUnknown(data['durum']!, _durumMeta),
      );
    } else if (isInserting) {
      context.missing(_durumMeta);
    }
    if (data.containsKey('olusturma_tarihi')) {
      context.handle(
        _olusturmaTarihiMeta,
        olusturmaTarihi.isAcceptableOrUnknown(
          data['olusturma_tarihi']!,
          _olusturmaTarihiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_olusturmaTarihiMeta);
    }
    if (data.containsKey('adres_metni')) {
      context.handle(
        _adresMetniMeta,
        adresMetni.isAcceptableOrUnknown(data['adres_metni']!, _adresMetniMeta),
      );
    }
    if (data.containsKey('teslimat_notu')) {
      context.handle(
        _teslimatNotuMeta,
        teslimatNotu.isAcceptableOrUnknown(
          data['teslimat_notu']!,
          _teslimatNotuMeta,
        ),
      );
    }
    if (data.containsKey('kurye_adi')) {
      context.handle(
        _kuryeAdiMeta,
        kuryeAdi.isAcceptableOrUnknown(data['kurye_adi']!, _kuryeAdiMeta),
      );
    }
    if (data.containsKey('paket_teslimat_durumu')) {
      context.handle(
        _paketTeslimatDurumuMeta,
        paketTeslimatDurumu.isAcceptableOrUnknown(
          data['paket_teslimat_durumu']!,
          _paketTeslimatDurumuMeta,
        ),
      );
    }
    if (data.containsKey('masa_no')) {
      context.handle(
        _masaNoMeta,
        masaNo.isAcceptableOrUnknown(data['masa_no']!, _masaNoMeta),
      );
    }
    if (data.containsKey('bolum_adi')) {
      context.handle(
        _bolumAdiMeta,
        bolumAdi.isAcceptableOrUnknown(data['bolum_adi']!, _bolumAdiMeta),
      );
    }
    if (data.containsKey('kaynak')) {
      context.handle(
        _kaynakMeta,
        kaynak.isAcceptableOrUnknown(data['kaynak']!, _kaynakMeta),
      );
    }
    if (data.containsKey('sahip_misafir')) {
      context.handle(
        _sahipMisafirMeta,
        sahipMisafir.isAcceptableOrUnknown(
          data['sahip_misafir']!,
          _sahipMisafirMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sahipMisafirMeta);
    }
    if (data.containsKey('sahip_ad_soyad')) {
      context.handle(
        _sahipAdSoyadMeta,
        sahipAdSoyad.isAcceptableOrUnknown(
          data['sahip_ad_soyad']!,
          _sahipAdSoyadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sahipAdSoyadMeta);
    }
    if (data.containsKey('sahip_telefon')) {
      context.handle(
        _sahipTelefonMeta,
        sahipTelefon.isAcceptableOrUnknown(
          data['sahip_telefon']!,
          _sahipTelefonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sahipTelefonMeta);
    }
    if (data.containsKey('sahip_eposta')) {
      context.handle(
        _sahipEpostaMeta,
        sahipEposta.isAcceptableOrUnknown(
          data['sahip_eposta']!,
          _sahipEpostaMeta,
        ),
      );
    }
    if (data.containsKey('sahip_adres')) {
      context.handle(
        _sahipAdresMeta,
        sahipAdres.isAcceptableOrUnknown(data['sahip_adres']!, _sahipAdresMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SiparisKayitlariData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SiparisKayitlariData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      siparisNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}siparis_no'],
      )!,
      teslimatTipi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}teslimat_tipi'],
      )!,
      durum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}durum'],
      )!,
      olusturmaTarihi: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}olusturma_tarihi'],
      )!,
      adresMetni: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adres_metni'],
      ),
      teslimatNotu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teslimat_notu'],
      ),
      kuryeAdi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kurye_adi'],
      ),
      paketTeslimatDurumu: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paket_teslimat_durumu'],
      ),
      masaNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}masa_no'],
      ),
      bolumAdi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bolum_adi'],
      ),
      kaynak: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kaynak'],
      ),
      sahipMisafir: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sahip_misafir'],
      )!,
      sahipAdSoyad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sahip_ad_soyad'],
      )!,
      sahipTelefon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sahip_telefon'],
      )!,
      sahipEposta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sahip_eposta'],
      ),
      sahipAdres: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sahip_adres'],
      ),
    );
  }

  @override
  $SiparisKayitlariTable createAlias(String alias) {
    return $SiparisKayitlariTable(attachedDatabase, alias);
  }
}

class SiparisKayitlariData extends DataClass
    implements Insertable<SiparisKayitlariData> {
  final String id;
  final String siparisNo;
  final int teslimatTipi;
  final int durum;
  final DateTime olusturmaTarihi;
  final String? adresMetni;
  final String? teslimatNotu;
  final String? kuryeAdi;
  final int? paketTeslimatDurumu;
  final String? masaNo;
  final String? bolumAdi;
  final String? kaynak;
  final bool sahipMisafir;
  final String sahipAdSoyad;
  final String sahipTelefon;
  final String? sahipEposta;
  final String? sahipAdres;
  const SiparisKayitlariData({
    required this.id,
    required this.siparisNo,
    required this.teslimatTipi,
    required this.durum,
    required this.olusturmaTarihi,
    this.adresMetni,
    this.teslimatNotu,
    this.kuryeAdi,
    this.paketTeslimatDurumu,
    this.masaNo,
    this.bolumAdi,
    this.kaynak,
    required this.sahipMisafir,
    required this.sahipAdSoyad,
    required this.sahipTelefon,
    this.sahipEposta,
    this.sahipAdres,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['siparis_no'] = Variable<String>(siparisNo);
    map['teslimat_tipi'] = Variable<int>(teslimatTipi);
    map['durum'] = Variable<int>(durum);
    map['olusturma_tarihi'] = Variable<DateTime>(olusturmaTarihi);
    if (!nullToAbsent || adresMetni != null) {
      map['adres_metni'] = Variable<String>(adresMetni);
    }
    if (!nullToAbsent || teslimatNotu != null) {
      map['teslimat_notu'] = Variable<String>(teslimatNotu);
    }
    if (!nullToAbsent || kuryeAdi != null) {
      map['kurye_adi'] = Variable<String>(kuryeAdi);
    }
    if (!nullToAbsent || paketTeslimatDurumu != null) {
      map['paket_teslimat_durumu'] = Variable<int>(paketTeslimatDurumu);
    }
    if (!nullToAbsent || masaNo != null) {
      map['masa_no'] = Variable<String>(masaNo);
    }
    if (!nullToAbsent || bolumAdi != null) {
      map['bolum_adi'] = Variable<String>(bolumAdi);
    }
    if (!nullToAbsent || kaynak != null) {
      map['kaynak'] = Variable<String>(kaynak);
    }
    map['sahip_misafir'] = Variable<bool>(sahipMisafir);
    map['sahip_ad_soyad'] = Variable<String>(sahipAdSoyad);
    map['sahip_telefon'] = Variable<String>(sahipTelefon);
    if (!nullToAbsent || sahipEposta != null) {
      map['sahip_eposta'] = Variable<String>(sahipEposta);
    }
    if (!nullToAbsent || sahipAdres != null) {
      map['sahip_adres'] = Variable<String>(sahipAdres);
    }
    return map;
  }

  SiparisKayitlariCompanion toCompanion(bool nullToAbsent) {
    return SiparisKayitlariCompanion(
      id: Value(id),
      siparisNo: Value(siparisNo),
      teslimatTipi: Value(teslimatTipi),
      durum: Value(durum),
      olusturmaTarihi: Value(olusturmaTarihi),
      adresMetni: adresMetni == null && nullToAbsent
          ? const Value.absent()
          : Value(adresMetni),
      teslimatNotu: teslimatNotu == null && nullToAbsent
          ? const Value.absent()
          : Value(teslimatNotu),
      kuryeAdi: kuryeAdi == null && nullToAbsent
          ? const Value.absent()
          : Value(kuryeAdi),
      paketTeslimatDurumu: paketTeslimatDurumu == null && nullToAbsent
          ? const Value.absent()
          : Value(paketTeslimatDurumu),
      masaNo: masaNo == null && nullToAbsent
          ? const Value.absent()
          : Value(masaNo),
      bolumAdi: bolumAdi == null && nullToAbsent
          ? const Value.absent()
          : Value(bolumAdi),
      kaynak: kaynak == null && nullToAbsent
          ? const Value.absent()
          : Value(kaynak),
      sahipMisafir: Value(sahipMisafir),
      sahipAdSoyad: Value(sahipAdSoyad),
      sahipTelefon: Value(sahipTelefon),
      sahipEposta: sahipEposta == null && nullToAbsent
          ? const Value.absent()
          : Value(sahipEposta),
      sahipAdres: sahipAdres == null && nullToAbsent
          ? const Value.absent()
          : Value(sahipAdres),
    );
  }

  factory SiparisKayitlariData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SiparisKayitlariData(
      id: serializer.fromJson<String>(json['id']),
      siparisNo: serializer.fromJson<String>(json['siparisNo']),
      teslimatTipi: serializer.fromJson<int>(json['teslimatTipi']),
      durum: serializer.fromJson<int>(json['durum']),
      olusturmaTarihi: serializer.fromJson<DateTime>(json['olusturmaTarihi']),
      adresMetni: serializer.fromJson<String?>(json['adresMetni']),
      teslimatNotu: serializer.fromJson<String?>(json['teslimatNotu']),
      kuryeAdi: serializer.fromJson<String?>(json['kuryeAdi']),
      paketTeslimatDurumu: serializer.fromJson<int?>(
        json['paketTeslimatDurumu'],
      ),
      masaNo: serializer.fromJson<String?>(json['masaNo']),
      bolumAdi: serializer.fromJson<String?>(json['bolumAdi']),
      kaynak: serializer.fromJson<String?>(json['kaynak']),
      sahipMisafir: serializer.fromJson<bool>(json['sahipMisafir']),
      sahipAdSoyad: serializer.fromJson<String>(json['sahipAdSoyad']),
      sahipTelefon: serializer.fromJson<String>(json['sahipTelefon']),
      sahipEposta: serializer.fromJson<String?>(json['sahipEposta']),
      sahipAdres: serializer.fromJson<String?>(json['sahipAdres']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'siparisNo': serializer.toJson<String>(siparisNo),
      'teslimatTipi': serializer.toJson<int>(teslimatTipi),
      'durum': serializer.toJson<int>(durum),
      'olusturmaTarihi': serializer.toJson<DateTime>(olusturmaTarihi),
      'adresMetni': serializer.toJson<String?>(adresMetni),
      'teslimatNotu': serializer.toJson<String?>(teslimatNotu),
      'kuryeAdi': serializer.toJson<String?>(kuryeAdi),
      'paketTeslimatDurumu': serializer.toJson<int?>(paketTeslimatDurumu),
      'masaNo': serializer.toJson<String?>(masaNo),
      'bolumAdi': serializer.toJson<String?>(bolumAdi),
      'kaynak': serializer.toJson<String?>(kaynak),
      'sahipMisafir': serializer.toJson<bool>(sahipMisafir),
      'sahipAdSoyad': serializer.toJson<String>(sahipAdSoyad),
      'sahipTelefon': serializer.toJson<String>(sahipTelefon),
      'sahipEposta': serializer.toJson<String?>(sahipEposta),
      'sahipAdres': serializer.toJson<String?>(sahipAdres),
    };
  }

  SiparisKayitlariData copyWith({
    String? id,
    String? siparisNo,
    int? teslimatTipi,
    int? durum,
    DateTime? olusturmaTarihi,
    Value<String?> adresMetni = const Value.absent(),
    Value<String?> teslimatNotu = const Value.absent(),
    Value<String?> kuryeAdi = const Value.absent(),
    Value<int?> paketTeslimatDurumu = const Value.absent(),
    Value<String?> masaNo = const Value.absent(),
    Value<String?> bolumAdi = const Value.absent(),
    Value<String?> kaynak = const Value.absent(),
    bool? sahipMisafir,
    String? sahipAdSoyad,
    String? sahipTelefon,
    Value<String?> sahipEposta = const Value.absent(),
    Value<String?> sahipAdres = const Value.absent(),
  }) => SiparisKayitlariData(
    id: id ?? this.id,
    siparisNo: siparisNo ?? this.siparisNo,
    teslimatTipi: teslimatTipi ?? this.teslimatTipi,
    durum: durum ?? this.durum,
    olusturmaTarihi: olusturmaTarihi ?? this.olusturmaTarihi,
    adresMetni: adresMetni.present ? adresMetni.value : this.adresMetni,
    teslimatNotu: teslimatNotu.present ? teslimatNotu.value : this.teslimatNotu,
    kuryeAdi: kuryeAdi.present ? kuryeAdi.value : this.kuryeAdi,
    paketTeslimatDurumu: paketTeslimatDurumu.present
        ? paketTeslimatDurumu.value
        : this.paketTeslimatDurumu,
    masaNo: masaNo.present ? masaNo.value : this.masaNo,
    bolumAdi: bolumAdi.present ? bolumAdi.value : this.bolumAdi,
    kaynak: kaynak.present ? kaynak.value : this.kaynak,
    sahipMisafir: sahipMisafir ?? this.sahipMisafir,
    sahipAdSoyad: sahipAdSoyad ?? this.sahipAdSoyad,
    sahipTelefon: sahipTelefon ?? this.sahipTelefon,
    sahipEposta: sahipEposta.present ? sahipEposta.value : this.sahipEposta,
    sahipAdres: sahipAdres.present ? sahipAdres.value : this.sahipAdres,
  );
  SiparisKayitlariData copyWithCompanion(SiparisKayitlariCompanion data) {
    return SiparisKayitlariData(
      id: data.id.present ? data.id.value : this.id,
      siparisNo: data.siparisNo.present ? data.siparisNo.value : this.siparisNo,
      teslimatTipi: data.teslimatTipi.present
          ? data.teslimatTipi.value
          : this.teslimatTipi,
      durum: data.durum.present ? data.durum.value : this.durum,
      olusturmaTarihi: data.olusturmaTarihi.present
          ? data.olusturmaTarihi.value
          : this.olusturmaTarihi,
      adresMetni: data.adresMetni.present
          ? data.adresMetni.value
          : this.adresMetni,
      teslimatNotu: data.teslimatNotu.present
          ? data.teslimatNotu.value
          : this.teslimatNotu,
      kuryeAdi: data.kuryeAdi.present ? data.kuryeAdi.value : this.kuryeAdi,
      paketTeslimatDurumu: data.paketTeslimatDurumu.present
          ? data.paketTeslimatDurumu.value
          : this.paketTeslimatDurumu,
      masaNo: data.masaNo.present ? data.masaNo.value : this.masaNo,
      bolumAdi: data.bolumAdi.present ? data.bolumAdi.value : this.bolumAdi,
      kaynak: data.kaynak.present ? data.kaynak.value : this.kaynak,
      sahipMisafir: data.sahipMisafir.present
          ? data.sahipMisafir.value
          : this.sahipMisafir,
      sahipAdSoyad: data.sahipAdSoyad.present
          ? data.sahipAdSoyad.value
          : this.sahipAdSoyad,
      sahipTelefon: data.sahipTelefon.present
          ? data.sahipTelefon.value
          : this.sahipTelefon,
      sahipEposta: data.sahipEposta.present
          ? data.sahipEposta.value
          : this.sahipEposta,
      sahipAdres: data.sahipAdres.present
          ? data.sahipAdres.value
          : this.sahipAdres,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SiparisKayitlariData(')
          ..write('id: $id, ')
          ..write('siparisNo: $siparisNo, ')
          ..write('teslimatTipi: $teslimatTipi, ')
          ..write('durum: $durum, ')
          ..write('olusturmaTarihi: $olusturmaTarihi, ')
          ..write('adresMetni: $adresMetni, ')
          ..write('teslimatNotu: $teslimatNotu, ')
          ..write('kuryeAdi: $kuryeAdi, ')
          ..write('paketTeslimatDurumu: $paketTeslimatDurumu, ')
          ..write('masaNo: $masaNo, ')
          ..write('bolumAdi: $bolumAdi, ')
          ..write('kaynak: $kaynak, ')
          ..write('sahipMisafir: $sahipMisafir, ')
          ..write('sahipAdSoyad: $sahipAdSoyad, ')
          ..write('sahipTelefon: $sahipTelefon, ')
          ..write('sahipEposta: $sahipEposta, ')
          ..write('sahipAdres: $sahipAdres')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    siparisNo,
    teslimatTipi,
    durum,
    olusturmaTarihi,
    adresMetni,
    teslimatNotu,
    kuryeAdi,
    paketTeslimatDurumu,
    masaNo,
    bolumAdi,
    kaynak,
    sahipMisafir,
    sahipAdSoyad,
    sahipTelefon,
    sahipEposta,
    sahipAdres,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SiparisKayitlariData &&
          other.id == this.id &&
          other.siparisNo == this.siparisNo &&
          other.teslimatTipi == this.teslimatTipi &&
          other.durum == this.durum &&
          other.olusturmaTarihi == this.olusturmaTarihi &&
          other.adresMetni == this.adresMetni &&
          other.teslimatNotu == this.teslimatNotu &&
          other.kuryeAdi == this.kuryeAdi &&
          other.paketTeslimatDurumu == this.paketTeslimatDurumu &&
          other.masaNo == this.masaNo &&
          other.bolumAdi == this.bolumAdi &&
          other.kaynak == this.kaynak &&
          other.sahipMisafir == this.sahipMisafir &&
          other.sahipAdSoyad == this.sahipAdSoyad &&
          other.sahipTelefon == this.sahipTelefon &&
          other.sahipEposta == this.sahipEposta &&
          other.sahipAdres == this.sahipAdres);
}

class SiparisKayitlariCompanion extends UpdateCompanion<SiparisKayitlariData> {
  final Value<String> id;
  final Value<String> siparisNo;
  final Value<int> teslimatTipi;
  final Value<int> durum;
  final Value<DateTime> olusturmaTarihi;
  final Value<String?> adresMetni;
  final Value<String?> teslimatNotu;
  final Value<String?> kuryeAdi;
  final Value<int?> paketTeslimatDurumu;
  final Value<String?> masaNo;
  final Value<String?> bolumAdi;
  final Value<String?> kaynak;
  final Value<bool> sahipMisafir;
  final Value<String> sahipAdSoyad;
  final Value<String> sahipTelefon;
  final Value<String?> sahipEposta;
  final Value<String?> sahipAdres;
  final Value<int> rowid;
  const SiparisKayitlariCompanion({
    this.id = const Value.absent(),
    this.siparisNo = const Value.absent(),
    this.teslimatTipi = const Value.absent(),
    this.durum = const Value.absent(),
    this.olusturmaTarihi = const Value.absent(),
    this.adresMetni = const Value.absent(),
    this.teslimatNotu = const Value.absent(),
    this.kuryeAdi = const Value.absent(),
    this.paketTeslimatDurumu = const Value.absent(),
    this.masaNo = const Value.absent(),
    this.bolumAdi = const Value.absent(),
    this.kaynak = const Value.absent(),
    this.sahipMisafir = const Value.absent(),
    this.sahipAdSoyad = const Value.absent(),
    this.sahipTelefon = const Value.absent(),
    this.sahipEposta = const Value.absent(),
    this.sahipAdres = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SiparisKayitlariCompanion.insert({
    required String id,
    required String siparisNo,
    required int teslimatTipi,
    required int durum,
    required DateTime olusturmaTarihi,
    this.adresMetni = const Value.absent(),
    this.teslimatNotu = const Value.absent(),
    this.kuryeAdi = const Value.absent(),
    this.paketTeslimatDurumu = const Value.absent(),
    this.masaNo = const Value.absent(),
    this.bolumAdi = const Value.absent(),
    this.kaynak = const Value.absent(),
    required bool sahipMisafir,
    required String sahipAdSoyad,
    required String sahipTelefon,
    this.sahipEposta = const Value.absent(),
    this.sahipAdres = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       siparisNo = Value(siparisNo),
       teslimatTipi = Value(teslimatTipi),
       durum = Value(durum),
       olusturmaTarihi = Value(olusturmaTarihi),
       sahipMisafir = Value(sahipMisafir),
       sahipAdSoyad = Value(sahipAdSoyad),
       sahipTelefon = Value(sahipTelefon);
  static Insertable<SiparisKayitlariData> custom({
    Expression<String>? id,
    Expression<String>? siparisNo,
    Expression<int>? teslimatTipi,
    Expression<int>? durum,
    Expression<DateTime>? olusturmaTarihi,
    Expression<String>? adresMetni,
    Expression<String>? teslimatNotu,
    Expression<String>? kuryeAdi,
    Expression<int>? paketTeslimatDurumu,
    Expression<String>? masaNo,
    Expression<String>? bolumAdi,
    Expression<String>? kaynak,
    Expression<bool>? sahipMisafir,
    Expression<String>? sahipAdSoyad,
    Expression<String>? sahipTelefon,
    Expression<String>? sahipEposta,
    Expression<String>? sahipAdres,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (siparisNo != null) 'siparis_no': siparisNo,
      if (teslimatTipi != null) 'teslimat_tipi': teslimatTipi,
      if (durum != null) 'durum': durum,
      if (olusturmaTarihi != null) 'olusturma_tarihi': olusturmaTarihi,
      if (adresMetni != null) 'adres_metni': adresMetni,
      if (teslimatNotu != null) 'teslimat_notu': teslimatNotu,
      if (kuryeAdi != null) 'kurye_adi': kuryeAdi,
      if (paketTeslimatDurumu != null)
        'paket_teslimat_durumu': paketTeslimatDurumu,
      if (masaNo != null) 'masa_no': masaNo,
      if (bolumAdi != null) 'bolum_adi': bolumAdi,
      if (kaynak != null) 'kaynak': kaynak,
      if (sahipMisafir != null) 'sahip_misafir': sahipMisafir,
      if (sahipAdSoyad != null) 'sahip_ad_soyad': sahipAdSoyad,
      if (sahipTelefon != null) 'sahip_telefon': sahipTelefon,
      if (sahipEposta != null) 'sahip_eposta': sahipEposta,
      if (sahipAdres != null) 'sahip_adres': sahipAdres,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SiparisKayitlariCompanion copyWith({
    Value<String>? id,
    Value<String>? siparisNo,
    Value<int>? teslimatTipi,
    Value<int>? durum,
    Value<DateTime>? olusturmaTarihi,
    Value<String?>? adresMetni,
    Value<String?>? teslimatNotu,
    Value<String?>? kuryeAdi,
    Value<int?>? paketTeslimatDurumu,
    Value<String?>? masaNo,
    Value<String?>? bolumAdi,
    Value<String?>? kaynak,
    Value<bool>? sahipMisafir,
    Value<String>? sahipAdSoyad,
    Value<String>? sahipTelefon,
    Value<String?>? sahipEposta,
    Value<String?>? sahipAdres,
    Value<int>? rowid,
  }) {
    return SiparisKayitlariCompanion(
      id: id ?? this.id,
      siparisNo: siparisNo ?? this.siparisNo,
      teslimatTipi: teslimatTipi ?? this.teslimatTipi,
      durum: durum ?? this.durum,
      olusturmaTarihi: olusturmaTarihi ?? this.olusturmaTarihi,
      adresMetni: adresMetni ?? this.adresMetni,
      teslimatNotu: teslimatNotu ?? this.teslimatNotu,
      kuryeAdi: kuryeAdi ?? this.kuryeAdi,
      paketTeslimatDurumu: paketTeslimatDurumu ?? this.paketTeslimatDurumu,
      masaNo: masaNo ?? this.masaNo,
      bolumAdi: bolumAdi ?? this.bolumAdi,
      kaynak: kaynak ?? this.kaynak,
      sahipMisafir: sahipMisafir ?? this.sahipMisafir,
      sahipAdSoyad: sahipAdSoyad ?? this.sahipAdSoyad,
      sahipTelefon: sahipTelefon ?? this.sahipTelefon,
      sahipEposta: sahipEposta ?? this.sahipEposta,
      sahipAdres: sahipAdres ?? this.sahipAdres,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (siparisNo.present) {
      map['siparis_no'] = Variable<String>(siparisNo.value);
    }
    if (teslimatTipi.present) {
      map['teslimat_tipi'] = Variable<int>(teslimatTipi.value);
    }
    if (durum.present) {
      map['durum'] = Variable<int>(durum.value);
    }
    if (olusturmaTarihi.present) {
      map['olusturma_tarihi'] = Variable<DateTime>(olusturmaTarihi.value);
    }
    if (adresMetni.present) {
      map['adres_metni'] = Variable<String>(adresMetni.value);
    }
    if (teslimatNotu.present) {
      map['teslimat_notu'] = Variable<String>(teslimatNotu.value);
    }
    if (kuryeAdi.present) {
      map['kurye_adi'] = Variable<String>(kuryeAdi.value);
    }
    if (paketTeslimatDurumu.present) {
      map['paket_teslimat_durumu'] = Variable<int>(paketTeslimatDurumu.value);
    }
    if (masaNo.present) {
      map['masa_no'] = Variable<String>(masaNo.value);
    }
    if (bolumAdi.present) {
      map['bolum_adi'] = Variable<String>(bolumAdi.value);
    }
    if (kaynak.present) {
      map['kaynak'] = Variable<String>(kaynak.value);
    }
    if (sahipMisafir.present) {
      map['sahip_misafir'] = Variable<bool>(sahipMisafir.value);
    }
    if (sahipAdSoyad.present) {
      map['sahip_ad_soyad'] = Variable<String>(sahipAdSoyad.value);
    }
    if (sahipTelefon.present) {
      map['sahip_telefon'] = Variable<String>(sahipTelefon.value);
    }
    if (sahipEposta.present) {
      map['sahip_eposta'] = Variable<String>(sahipEposta.value);
    }
    if (sahipAdres.present) {
      map['sahip_adres'] = Variable<String>(sahipAdres.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SiparisKayitlariCompanion(')
          ..write('id: $id, ')
          ..write('siparisNo: $siparisNo, ')
          ..write('teslimatTipi: $teslimatTipi, ')
          ..write('durum: $durum, ')
          ..write('olusturmaTarihi: $olusturmaTarihi, ')
          ..write('adresMetni: $adresMetni, ')
          ..write('teslimatNotu: $teslimatNotu, ')
          ..write('kuryeAdi: $kuryeAdi, ')
          ..write('paketTeslimatDurumu: $paketTeslimatDurumu, ')
          ..write('masaNo: $masaNo, ')
          ..write('bolumAdi: $bolumAdi, ')
          ..write('kaynak: $kaynak, ')
          ..write('sahipMisafir: $sahipMisafir, ')
          ..write('sahipAdSoyad: $sahipAdSoyad, ')
          ..write('sahipTelefon: $sahipTelefon, ')
          ..write('sahipEposta: $sahipEposta, ')
          ..write('sahipAdres: $sahipAdres, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SiparisKalemleriTable extends SiparisKalemleri
    with TableInfo<$SiparisKalemleriTable, SiparisKalemleriData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SiparisKalemleriTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siparisIdMeta = const VerificationMeta(
    'siparisId',
  );
  @override
  late final GeneratedColumn<String> siparisId = GeneratedColumn<String>(
    'siparis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urunIdMeta = const VerificationMeta('urunId');
  @override
  late final GeneratedColumn<String> urunId = GeneratedColumn<String>(
    'urun_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urunAdiMeta = const VerificationMeta(
    'urunAdi',
  );
  @override
  late final GeneratedColumn<String> urunAdi = GeneratedColumn<String>(
    'urun_adi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birimFiyatMeta = const VerificationMeta(
    'birimFiyat',
  );
  @override
  late final GeneratedColumn<double> birimFiyat = GeneratedColumn<double>(
    'birim_fiyat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adetMeta = const VerificationMeta('adet');
  @override
  late final GeneratedColumn<int> adet = GeneratedColumn<int>(
    'adet',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secenekAdiMeta = const VerificationMeta(
    'secenekAdi',
  );
  @override
  late final GeneratedColumn<String> secenekAdi = GeneratedColumn<String>(
    'secenek_adi',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notMetniMeta = const VerificationMeta(
    'notMetni',
  );
  @override
  late final GeneratedColumn<String> notMetni = GeneratedColumn<String>(
    'not_metni',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    siparisId,
    urunId,
    urunAdi,
    birimFiyat,
    adet,
    secenekAdi,
    notMetni,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'siparis_kalemleri';
  @override
  VerificationContext validateIntegrity(
    Insertable<SiparisKalemleriData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('siparis_id')) {
      context.handle(
        _siparisIdMeta,
        siparisId.isAcceptableOrUnknown(data['siparis_id']!, _siparisIdMeta),
      );
    } else if (isInserting) {
      context.missing(_siparisIdMeta);
    }
    if (data.containsKey('urun_id')) {
      context.handle(
        _urunIdMeta,
        urunId.isAcceptableOrUnknown(data['urun_id']!, _urunIdMeta),
      );
    } else if (isInserting) {
      context.missing(_urunIdMeta);
    }
    if (data.containsKey('urun_adi')) {
      context.handle(
        _urunAdiMeta,
        urunAdi.isAcceptableOrUnknown(data['urun_adi']!, _urunAdiMeta),
      );
    } else if (isInserting) {
      context.missing(_urunAdiMeta);
    }
    if (data.containsKey('birim_fiyat')) {
      context.handle(
        _birimFiyatMeta,
        birimFiyat.isAcceptableOrUnknown(data['birim_fiyat']!, _birimFiyatMeta),
      );
    } else if (isInserting) {
      context.missing(_birimFiyatMeta);
    }
    if (data.containsKey('adet')) {
      context.handle(
        _adetMeta,
        adet.isAcceptableOrUnknown(data['adet']!, _adetMeta),
      );
    } else if (isInserting) {
      context.missing(_adetMeta);
    }
    if (data.containsKey('secenek_adi')) {
      context.handle(
        _secenekAdiMeta,
        secenekAdi.isAcceptableOrUnknown(data['secenek_adi']!, _secenekAdiMeta),
      );
    }
    if (data.containsKey('not_metni')) {
      context.handle(
        _notMetniMeta,
        notMetni.isAcceptableOrUnknown(data['not_metni']!, _notMetniMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SiparisKalemleriData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SiparisKalemleriData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      siparisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}siparis_id'],
      )!,
      urunId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}urun_id'],
      )!,
      urunAdi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}urun_adi'],
      )!,
      birimFiyat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birim_fiyat'],
      )!,
      adet: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}adet'],
      )!,
      secenekAdi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secenek_adi'],
      ),
      notMetni: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}not_metni'],
      ),
    );
  }

  @override
  $SiparisKalemleriTable createAlias(String alias) {
    return $SiparisKalemleriTable(attachedDatabase, alias);
  }
}

class SiparisKalemleriData extends DataClass
    implements Insertable<SiparisKalemleriData> {
  final String id;
  final String siparisId;
  final String urunId;
  final String urunAdi;
  final double birimFiyat;
  final int adet;
  final String? secenekAdi;
  final String? notMetni;
  const SiparisKalemleriData({
    required this.id,
    required this.siparisId,
    required this.urunId,
    required this.urunAdi,
    required this.birimFiyat,
    required this.adet,
    this.secenekAdi,
    this.notMetni,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['siparis_id'] = Variable<String>(siparisId);
    map['urun_id'] = Variable<String>(urunId);
    map['urun_adi'] = Variable<String>(urunAdi);
    map['birim_fiyat'] = Variable<double>(birimFiyat);
    map['adet'] = Variable<int>(adet);
    if (!nullToAbsent || secenekAdi != null) {
      map['secenek_adi'] = Variable<String>(secenekAdi);
    }
    if (!nullToAbsent || notMetni != null) {
      map['not_metni'] = Variable<String>(notMetni);
    }
    return map;
  }

  SiparisKalemleriCompanion toCompanion(bool nullToAbsent) {
    return SiparisKalemleriCompanion(
      id: Value(id),
      siparisId: Value(siparisId),
      urunId: Value(urunId),
      urunAdi: Value(urunAdi),
      birimFiyat: Value(birimFiyat),
      adet: Value(adet),
      secenekAdi: secenekAdi == null && nullToAbsent
          ? const Value.absent()
          : Value(secenekAdi),
      notMetni: notMetni == null && nullToAbsent
          ? const Value.absent()
          : Value(notMetni),
    );
  }

  factory SiparisKalemleriData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SiparisKalemleriData(
      id: serializer.fromJson<String>(json['id']),
      siparisId: serializer.fromJson<String>(json['siparisId']),
      urunId: serializer.fromJson<String>(json['urunId']),
      urunAdi: serializer.fromJson<String>(json['urunAdi']),
      birimFiyat: serializer.fromJson<double>(json['birimFiyat']),
      adet: serializer.fromJson<int>(json['adet']),
      secenekAdi: serializer.fromJson<String?>(json['secenekAdi']),
      notMetni: serializer.fromJson<String?>(json['notMetni']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'siparisId': serializer.toJson<String>(siparisId),
      'urunId': serializer.toJson<String>(urunId),
      'urunAdi': serializer.toJson<String>(urunAdi),
      'birimFiyat': serializer.toJson<double>(birimFiyat),
      'adet': serializer.toJson<int>(adet),
      'secenekAdi': serializer.toJson<String?>(secenekAdi),
      'notMetni': serializer.toJson<String?>(notMetni),
    };
  }

  SiparisKalemleriData copyWith({
    String? id,
    String? siparisId,
    String? urunId,
    String? urunAdi,
    double? birimFiyat,
    int? adet,
    Value<String?> secenekAdi = const Value.absent(),
    Value<String?> notMetni = const Value.absent(),
  }) => SiparisKalemleriData(
    id: id ?? this.id,
    siparisId: siparisId ?? this.siparisId,
    urunId: urunId ?? this.urunId,
    urunAdi: urunAdi ?? this.urunAdi,
    birimFiyat: birimFiyat ?? this.birimFiyat,
    adet: adet ?? this.adet,
    secenekAdi: secenekAdi.present ? secenekAdi.value : this.secenekAdi,
    notMetni: notMetni.present ? notMetni.value : this.notMetni,
  );
  SiparisKalemleriData copyWithCompanion(SiparisKalemleriCompanion data) {
    return SiparisKalemleriData(
      id: data.id.present ? data.id.value : this.id,
      siparisId: data.siparisId.present ? data.siparisId.value : this.siparisId,
      urunId: data.urunId.present ? data.urunId.value : this.urunId,
      urunAdi: data.urunAdi.present ? data.urunAdi.value : this.urunAdi,
      birimFiyat: data.birimFiyat.present
          ? data.birimFiyat.value
          : this.birimFiyat,
      adet: data.adet.present ? data.adet.value : this.adet,
      secenekAdi: data.secenekAdi.present
          ? data.secenekAdi.value
          : this.secenekAdi,
      notMetni: data.notMetni.present ? data.notMetni.value : this.notMetni,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SiparisKalemleriData(')
          ..write('id: $id, ')
          ..write('siparisId: $siparisId, ')
          ..write('urunId: $urunId, ')
          ..write('urunAdi: $urunAdi, ')
          ..write('birimFiyat: $birimFiyat, ')
          ..write('adet: $adet, ')
          ..write('secenekAdi: $secenekAdi, ')
          ..write('notMetni: $notMetni')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    siparisId,
    urunId,
    urunAdi,
    birimFiyat,
    adet,
    secenekAdi,
    notMetni,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SiparisKalemleriData &&
          other.id == this.id &&
          other.siparisId == this.siparisId &&
          other.urunId == this.urunId &&
          other.urunAdi == this.urunAdi &&
          other.birimFiyat == this.birimFiyat &&
          other.adet == this.adet &&
          other.secenekAdi == this.secenekAdi &&
          other.notMetni == this.notMetni);
}

class SiparisKalemleriCompanion extends UpdateCompanion<SiparisKalemleriData> {
  final Value<String> id;
  final Value<String> siparisId;
  final Value<String> urunId;
  final Value<String> urunAdi;
  final Value<double> birimFiyat;
  final Value<int> adet;
  final Value<String?> secenekAdi;
  final Value<String?> notMetni;
  final Value<int> rowid;
  const SiparisKalemleriCompanion({
    this.id = const Value.absent(),
    this.siparisId = const Value.absent(),
    this.urunId = const Value.absent(),
    this.urunAdi = const Value.absent(),
    this.birimFiyat = const Value.absent(),
    this.adet = const Value.absent(),
    this.secenekAdi = const Value.absent(),
    this.notMetni = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SiparisKalemleriCompanion.insert({
    required String id,
    required String siparisId,
    required String urunId,
    required String urunAdi,
    required double birimFiyat,
    required int adet,
    this.secenekAdi = const Value.absent(),
    this.notMetni = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       siparisId = Value(siparisId),
       urunId = Value(urunId),
       urunAdi = Value(urunAdi),
       birimFiyat = Value(birimFiyat),
       adet = Value(adet);
  static Insertable<SiparisKalemleriData> custom({
    Expression<String>? id,
    Expression<String>? siparisId,
    Expression<String>? urunId,
    Expression<String>? urunAdi,
    Expression<double>? birimFiyat,
    Expression<int>? adet,
    Expression<String>? secenekAdi,
    Expression<String>? notMetni,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (siparisId != null) 'siparis_id': siparisId,
      if (urunId != null) 'urun_id': urunId,
      if (urunAdi != null) 'urun_adi': urunAdi,
      if (birimFiyat != null) 'birim_fiyat': birimFiyat,
      if (adet != null) 'adet': adet,
      if (secenekAdi != null) 'secenek_adi': secenekAdi,
      if (notMetni != null) 'not_metni': notMetni,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SiparisKalemleriCompanion copyWith({
    Value<String>? id,
    Value<String>? siparisId,
    Value<String>? urunId,
    Value<String>? urunAdi,
    Value<double>? birimFiyat,
    Value<int>? adet,
    Value<String?>? secenekAdi,
    Value<String?>? notMetni,
    Value<int>? rowid,
  }) {
    return SiparisKalemleriCompanion(
      id: id ?? this.id,
      siparisId: siparisId ?? this.siparisId,
      urunId: urunId ?? this.urunId,
      urunAdi: urunAdi ?? this.urunAdi,
      birimFiyat: birimFiyat ?? this.birimFiyat,
      adet: adet ?? this.adet,
      secenekAdi: secenekAdi ?? this.secenekAdi,
      notMetni: notMetni ?? this.notMetni,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (siparisId.present) {
      map['siparis_id'] = Variable<String>(siparisId.value);
    }
    if (urunId.present) {
      map['urun_id'] = Variable<String>(urunId.value);
    }
    if (urunAdi.present) {
      map['urun_adi'] = Variable<String>(urunAdi.value);
    }
    if (birimFiyat.present) {
      map['birim_fiyat'] = Variable<double>(birimFiyat.value);
    }
    if (adet.present) {
      map['adet'] = Variable<int>(adet.value);
    }
    if (secenekAdi.present) {
      map['secenek_adi'] = Variable<String>(secenekAdi.value);
    }
    if (notMetni.present) {
      map['not_metni'] = Variable<String>(notMetni.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SiparisKalemleriCompanion(')
          ..write('id: $id, ')
          ..write('siparisId: $siparisId, ')
          ..write('urunId: $urunId, ')
          ..write('urunAdi: $urunAdi, ')
          ..write('birimFiyat: $birimFiyat, ')
          ..write('adet: $adet, ')
          ..write('secenekAdi: $secenekAdi, ')
          ..write('notMetni: $notMetni, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UygulamaAyarlarTable extends UygulamaAyarlar
    with TableInfo<$UygulamaAyarlarTable, UygulamaAyarlarData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UygulamaAyarlarTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _anahtarMeta = const VerificationMeta(
    'anahtar',
  );
  @override
  late final GeneratedColumn<String> anahtar = GeneratedColumn<String>(
    'anahtar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _degerMeta = const VerificationMeta('deger');
  @override
  late final GeneratedColumn<String> deger = GeneratedColumn<String>(
    'deger',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [anahtar, deger];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'uygulama_ayarlar';
  @override
  VerificationContext validateIntegrity(
    Insertable<UygulamaAyarlarData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('anahtar')) {
      context.handle(
        _anahtarMeta,
        anahtar.isAcceptableOrUnknown(data['anahtar']!, _anahtarMeta),
      );
    } else if (isInserting) {
      context.missing(_anahtarMeta);
    }
    if (data.containsKey('deger')) {
      context.handle(
        _degerMeta,
        deger.isAcceptableOrUnknown(data['deger']!, _degerMeta),
      );
    } else if (isInserting) {
      context.missing(_degerMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {anahtar};
  @override
  UygulamaAyarlarData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UygulamaAyarlarData(
      anahtar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anahtar'],
      )!,
      deger: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deger'],
      )!,
    );
  }

  @override
  $UygulamaAyarlarTable createAlias(String alias) {
    return $UygulamaAyarlarTable(attachedDatabase, alias);
  }
}

class UygulamaAyarlarData extends DataClass
    implements Insertable<UygulamaAyarlarData> {
  final String anahtar;
  final String deger;
  const UygulamaAyarlarData({required this.anahtar, required this.deger});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['anahtar'] = Variable<String>(anahtar);
    map['deger'] = Variable<String>(deger);
    return map;
  }

  UygulamaAyarlarCompanion toCompanion(bool nullToAbsent) {
    return UygulamaAyarlarCompanion(
      anahtar: Value(anahtar),
      deger: Value(deger),
    );
  }

  factory UygulamaAyarlarData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UygulamaAyarlarData(
      anahtar: serializer.fromJson<String>(json['anahtar']),
      deger: serializer.fromJson<String>(json['deger']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'anahtar': serializer.toJson<String>(anahtar),
      'deger': serializer.toJson<String>(deger),
    };
  }

  UygulamaAyarlarData copyWith({String? anahtar, String? deger}) =>
      UygulamaAyarlarData(
        anahtar: anahtar ?? this.anahtar,
        deger: deger ?? this.deger,
      );
  UygulamaAyarlarData copyWithCompanion(UygulamaAyarlarCompanion data) {
    return UygulamaAyarlarData(
      anahtar: data.anahtar.present ? data.anahtar.value : this.anahtar,
      deger: data.deger.present ? data.deger.value : this.deger,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UygulamaAyarlarData(')
          ..write('anahtar: $anahtar, ')
          ..write('deger: $deger')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(anahtar, deger);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UygulamaAyarlarData &&
          other.anahtar == this.anahtar &&
          other.deger == this.deger);
}

class UygulamaAyarlarCompanion extends UpdateCompanion<UygulamaAyarlarData> {
  final Value<String> anahtar;
  final Value<String> deger;
  final Value<int> rowid;
  const UygulamaAyarlarCompanion({
    this.anahtar = const Value.absent(),
    this.deger = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UygulamaAyarlarCompanion.insert({
    required String anahtar,
    required String deger,
    this.rowid = const Value.absent(),
  }) : anahtar = Value(anahtar),
       deger = Value(deger);
  static Insertable<UygulamaAyarlarData> custom({
    Expression<String>? anahtar,
    Expression<String>? deger,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (anahtar != null) 'anahtar': anahtar,
      if (deger != null) 'deger': deger,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UygulamaAyarlarCompanion copyWith({
    Value<String>? anahtar,
    Value<String>? deger,
    Value<int>? rowid,
  }) {
    return UygulamaAyarlarCompanion(
      anahtar: anahtar ?? this.anahtar,
      deger: deger ?? this.deger,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (anahtar.present) {
      map['anahtar'] = Variable<String>(anahtar.value);
    }
    if (deger.present) {
      map['deger'] = Variable<String>(deger.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UygulamaAyarlarCompanion(')
          ..write('anahtar: $anahtar, ')
          ..write('deger: $deger, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$UygulamaVeritabani extends GeneratedDatabase {
  _$UygulamaVeritabani(QueryExecutor e) : super(e);
  $UygulamaVeritabaniManager get managers => $UygulamaVeritabaniManager(this);
  late final $KullaniciKayitlariTable kullaniciKayitlari =
      $KullaniciKayitlariTable(this);
  late final $MisafirKayitlariTable misafirKayitlari = $MisafirKayitlariTable(
    this,
  );
  late final $KategoriKayitlariTable kategoriKayitlari =
      $KategoriKayitlariTable(this);
  late final $UrunKayitlariTable urunKayitlari = $UrunKayitlariTable(this);
  late final $SepetKayitlariTable sepetKayitlari = $SepetKayitlariTable(this);
  late final $SepetKalemleriTable sepetKalemleri = $SepetKalemleriTable(this);
  late final $SiparisKayitlariTable siparisKayitlari = $SiparisKayitlariTable(
    this,
  );
  late final $SiparisKalemleriTable siparisKalemleri = $SiparisKalemleriTable(
    this,
  );
  late final $UygulamaAyarlarTable uygulamaAyarlar = $UygulamaAyarlarTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    kullaniciKayitlari,
    misafirKayitlari,
    kategoriKayitlari,
    urunKayitlari,
    sepetKayitlari,
    sepetKalemleri,
    siparisKayitlari,
    siparisKalemleri,
    uygulamaAyarlar,
  ];
}

typedef $$KullaniciKayitlariTableCreateCompanionBuilder =
    KullaniciKayitlariCompanion Function({
      required String id,
      required String adSoyad,
      required String telefon,
      Value<String?> eposta,
      required int rol,
      required bool aktifMi,
      Value<String?> adresMetni,
      Value<int> rowid,
    });
typedef $$KullaniciKayitlariTableUpdateCompanionBuilder =
    KullaniciKayitlariCompanion Function({
      Value<String> id,
      Value<String> adSoyad,
      Value<String> telefon,
      Value<String?> eposta,
      Value<int> rol,
      Value<bool> aktifMi,
      Value<String?> adresMetni,
      Value<int> rowid,
    });

class $$KullaniciKayitlariTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $KullaniciKayitlariTable> {
  $$KullaniciKayitlariTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adSoyad => $composableBuilder(
    column: $table.adSoyad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefon => $composableBuilder(
    column: $table.telefon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eposta => $composableBuilder(
    column: $table.eposta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get aktifMi => $composableBuilder(
    column: $table.aktifMi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adresMetni => $composableBuilder(
    column: $table.adresMetni,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KullaniciKayitlariTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $KullaniciKayitlariTable> {
  $$KullaniciKayitlariTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adSoyad => $composableBuilder(
    column: $table.adSoyad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefon => $composableBuilder(
    column: $table.telefon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eposta => $composableBuilder(
    column: $table.eposta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get aktifMi => $composableBuilder(
    column: $table.aktifMi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adresMetni => $composableBuilder(
    column: $table.adresMetni,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KullaniciKayitlariTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $KullaniciKayitlariTable> {
  $$KullaniciKayitlariTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get adSoyad =>
      $composableBuilder(column: $table.adSoyad, builder: (column) => column);

  GeneratedColumn<String> get telefon =>
      $composableBuilder(column: $table.telefon, builder: (column) => column);

  GeneratedColumn<String> get eposta =>
      $composableBuilder(column: $table.eposta, builder: (column) => column);

  GeneratedColumn<int> get rol =>
      $composableBuilder(column: $table.rol, builder: (column) => column);

  GeneratedColumn<bool> get aktifMi =>
      $composableBuilder(column: $table.aktifMi, builder: (column) => column);

  GeneratedColumn<String> get adresMetni => $composableBuilder(
    column: $table.adresMetni,
    builder: (column) => column,
  );
}

class $$KullaniciKayitlariTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $KullaniciKayitlariTable,
          KullaniciKayitlariData,
          $$KullaniciKayitlariTableFilterComposer,
          $$KullaniciKayitlariTableOrderingComposer,
          $$KullaniciKayitlariTableAnnotationComposer,
          $$KullaniciKayitlariTableCreateCompanionBuilder,
          $$KullaniciKayitlariTableUpdateCompanionBuilder,
          (
            KullaniciKayitlariData,
            BaseReferences<
              _$UygulamaVeritabani,
              $KullaniciKayitlariTable,
              KullaniciKayitlariData
            >,
          ),
          KullaniciKayitlariData,
          PrefetchHooks Function()
        > {
  $$KullaniciKayitlariTableTableManager(
    _$UygulamaVeritabani db,
    $KullaniciKayitlariTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KullaniciKayitlariTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KullaniciKayitlariTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KullaniciKayitlariTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> adSoyad = const Value.absent(),
                Value<String> telefon = const Value.absent(),
                Value<String?> eposta = const Value.absent(),
                Value<int> rol = const Value.absent(),
                Value<bool> aktifMi = const Value.absent(),
                Value<String?> adresMetni = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KullaniciKayitlariCompanion(
                id: id,
                adSoyad: adSoyad,
                telefon: telefon,
                eposta: eposta,
                rol: rol,
                aktifMi: aktifMi,
                adresMetni: adresMetni,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String adSoyad,
                required String telefon,
                Value<String?> eposta = const Value.absent(),
                required int rol,
                required bool aktifMi,
                Value<String?> adresMetni = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KullaniciKayitlariCompanion.insert(
                id: id,
                adSoyad: adSoyad,
                telefon: telefon,
                eposta: eposta,
                rol: rol,
                aktifMi: aktifMi,
                adresMetni: adresMetni,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KullaniciKayitlariTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $KullaniciKayitlariTable,
      KullaniciKayitlariData,
      $$KullaniciKayitlariTableFilterComposer,
      $$KullaniciKayitlariTableOrderingComposer,
      $$KullaniciKayitlariTableAnnotationComposer,
      $$KullaniciKayitlariTableCreateCompanionBuilder,
      $$KullaniciKayitlariTableUpdateCompanionBuilder,
      (
        KullaniciKayitlariData,
        BaseReferences<
          _$UygulamaVeritabani,
          $KullaniciKayitlariTable,
          KullaniciKayitlariData
        >,
      ),
      KullaniciKayitlariData,
      PrefetchHooks Function()
    >;
typedef $$MisafirKayitlariTableCreateCompanionBuilder =
    MisafirKayitlariCompanion Function({
      required String adSoyad,
      required String telefon,
      Value<String?> eposta,
      Value<String?> adres,
      Value<int> rowid,
    });
typedef $$MisafirKayitlariTableUpdateCompanionBuilder =
    MisafirKayitlariCompanion Function({
      Value<String> adSoyad,
      Value<String> telefon,
      Value<String?> eposta,
      Value<String?> adres,
      Value<int> rowid,
    });

class $$MisafirKayitlariTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $MisafirKayitlariTable> {
  $$MisafirKayitlariTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get adSoyad => $composableBuilder(
    column: $table.adSoyad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefon => $composableBuilder(
    column: $table.telefon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eposta => $composableBuilder(
    column: $table.eposta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adres => $composableBuilder(
    column: $table.adres,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MisafirKayitlariTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $MisafirKayitlariTable> {
  $$MisafirKayitlariTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get adSoyad => $composableBuilder(
    column: $table.adSoyad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefon => $composableBuilder(
    column: $table.telefon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eposta => $composableBuilder(
    column: $table.eposta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adres => $composableBuilder(
    column: $table.adres,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MisafirKayitlariTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $MisafirKayitlariTable> {
  $$MisafirKayitlariTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get adSoyad =>
      $composableBuilder(column: $table.adSoyad, builder: (column) => column);

  GeneratedColumn<String> get telefon =>
      $composableBuilder(column: $table.telefon, builder: (column) => column);

  GeneratedColumn<String> get eposta =>
      $composableBuilder(column: $table.eposta, builder: (column) => column);

  GeneratedColumn<String> get adres =>
      $composableBuilder(column: $table.adres, builder: (column) => column);
}

class $$MisafirKayitlariTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $MisafirKayitlariTable,
          MisafirKayitlariData,
          $$MisafirKayitlariTableFilterComposer,
          $$MisafirKayitlariTableOrderingComposer,
          $$MisafirKayitlariTableAnnotationComposer,
          $$MisafirKayitlariTableCreateCompanionBuilder,
          $$MisafirKayitlariTableUpdateCompanionBuilder,
          (
            MisafirKayitlariData,
            BaseReferences<
              _$UygulamaVeritabani,
              $MisafirKayitlariTable,
              MisafirKayitlariData
            >,
          ),
          MisafirKayitlariData,
          PrefetchHooks Function()
        > {
  $$MisafirKayitlariTableTableManager(
    _$UygulamaVeritabani db,
    $MisafirKayitlariTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MisafirKayitlariTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MisafirKayitlariTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MisafirKayitlariTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> adSoyad = const Value.absent(),
                Value<String> telefon = const Value.absent(),
                Value<String?> eposta = const Value.absent(),
                Value<String?> adres = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MisafirKayitlariCompanion(
                adSoyad: adSoyad,
                telefon: telefon,
                eposta: eposta,
                adres: adres,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String adSoyad,
                required String telefon,
                Value<String?> eposta = const Value.absent(),
                Value<String?> adres = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MisafirKayitlariCompanion.insert(
                adSoyad: adSoyad,
                telefon: telefon,
                eposta: eposta,
                adres: adres,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MisafirKayitlariTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $MisafirKayitlariTable,
      MisafirKayitlariData,
      $$MisafirKayitlariTableFilterComposer,
      $$MisafirKayitlariTableOrderingComposer,
      $$MisafirKayitlariTableAnnotationComposer,
      $$MisafirKayitlariTableCreateCompanionBuilder,
      $$MisafirKayitlariTableUpdateCompanionBuilder,
      (
        MisafirKayitlariData,
        BaseReferences<
          _$UygulamaVeritabani,
          $MisafirKayitlariTable,
          MisafirKayitlariData
        >,
      ),
      MisafirKayitlariData,
      PrefetchHooks Function()
    >;
typedef $$KategoriKayitlariTableCreateCompanionBuilder =
    KategoriKayitlariCompanion Function({
      required String id,
      required String ad,
      required int sira,
      required bool acikMi,
      Value<int> rowid,
    });
typedef $$KategoriKayitlariTableUpdateCompanionBuilder =
    KategoriKayitlariCompanion Function({
      Value<String> id,
      Value<String> ad,
      Value<int> sira,
      Value<bool> acikMi,
      Value<int> rowid,
    });

class $$KategoriKayitlariTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $KategoriKayitlariTable> {
  $$KategoriKayitlariTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ad => $composableBuilder(
    column: $table.ad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sira => $composableBuilder(
    column: $table.sira,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get acikMi => $composableBuilder(
    column: $table.acikMi,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KategoriKayitlariTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $KategoriKayitlariTable> {
  $$KategoriKayitlariTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ad => $composableBuilder(
    column: $table.ad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sira => $composableBuilder(
    column: $table.sira,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get acikMi => $composableBuilder(
    column: $table.acikMi,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KategoriKayitlariTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $KategoriKayitlariTable> {
  $$KategoriKayitlariTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ad =>
      $composableBuilder(column: $table.ad, builder: (column) => column);

  GeneratedColumn<int> get sira =>
      $composableBuilder(column: $table.sira, builder: (column) => column);

  GeneratedColumn<bool> get acikMi =>
      $composableBuilder(column: $table.acikMi, builder: (column) => column);
}

class $$KategoriKayitlariTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $KategoriKayitlariTable,
          KategoriKayitlariData,
          $$KategoriKayitlariTableFilterComposer,
          $$KategoriKayitlariTableOrderingComposer,
          $$KategoriKayitlariTableAnnotationComposer,
          $$KategoriKayitlariTableCreateCompanionBuilder,
          $$KategoriKayitlariTableUpdateCompanionBuilder,
          (
            KategoriKayitlariData,
            BaseReferences<
              _$UygulamaVeritabani,
              $KategoriKayitlariTable,
              KategoriKayitlariData
            >,
          ),
          KategoriKayitlariData,
          PrefetchHooks Function()
        > {
  $$KategoriKayitlariTableTableManager(
    _$UygulamaVeritabani db,
    $KategoriKayitlariTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KategoriKayitlariTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KategoriKayitlariTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KategoriKayitlariTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ad = const Value.absent(),
                Value<int> sira = const Value.absent(),
                Value<bool> acikMi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KategoriKayitlariCompanion(
                id: id,
                ad: ad,
                sira: sira,
                acikMi: acikMi,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ad,
                required int sira,
                required bool acikMi,
                Value<int> rowid = const Value.absent(),
              }) => KategoriKayitlariCompanion.insert(
                id: id,
                ad: ad,
                sira: sira,
                acikMi: acikMi,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KategoriKayitlariTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $KategoriKayitlariTable,
      KategoriKayitlariData,
      $$KategoriKayitlariTableFilterComposer,
      $$KategoriKayitlariTableOrderingComposer,
      $$KategoriKayitlariTableAnnotationComposer,
      $$KategoriKayitlariTableCreateCompanionBuilder,
      $$KategoriKayitlariTableUpdateCompanionBuilder,
      (
        KategoriKayitlariData,
        BaseReferences<
          _$UygulamaVeritabani,
          $KategoriKayitlariTable,
          KategoriKayitlariData
        >,
      ),
      KategoriKayitlariData,
      PrefetchHooks Function()
    >;
typedef $$UrunKayitlariTableCreateCompanionBuilder =
    UrunKayitlariCompanion Function({
      required String id,
      required String kategoriId,
      required String ad,
      required String aciklama,
      required double fiyat,
      Value<String?> gorselUrl,
      required bool stoktaMi,
      required bool oneCikanMi,
      required String seceneklerJson,
      Value<int> rowid,
    });
typedef $$UrunKayitlariTableUpdateCompanionBuilder =
    UrunKayitlariCompanion Function({
      Value<String> id,
      Value<String> kategoriId,
      Value<String> ad,
      Value<String> aciklama,
      Value<double> fiyat,
      Value<String?> gorselUrl,
      Value<bool> stoktaMi,
      Value<bool> oneCikanMi,
      Value<String> seceneklerJson,
      Value<int> rowid,
    });

class $$UrunKayitlariTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $UrunKayitlariTable> {
  $$UrunKayitlariTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kategoriId => $composableBuilder(
    column: $table.kategoriId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ad => $composableBuilder(
    column: $table.ad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aciklama => $composableBuilder(
    column: $table.aciklama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiyat => $composableBuilder(
    column: $table.fiyat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gorselUrl => $composableBuilder(
    column: $table.gorselUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get stoktaMi => $composableBuilder(
    column: $table.stoktaMi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get oneCikanMi => $composableBuilder(
    column: $table.oneCikanMi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seceneklerJson => $composableBuilder(
    column: $table.seceneklerJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UrunKayitlariTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $UrunKayitlariTable> {
  $$UrunKayitlariTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kategoriId => $composableBuilder(
    column: $table.kategoriId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ad => $composableBuilder(
    column: $table.ad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aciklama => $composableBuilder(
    column: $table.aciklama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiyat => $composableBuilder(
    column: $table.fiyat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gorselUrl => $composableBuilder(
    column: $table.gorselUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get stoktaMi => $composableBuilder(
    column: $table.stoktaMi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get oneCikanMi => $composableBuilder(
    column: $table.oneCikanMi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seceneklerJson => $composableBuilder(
    column: $table.seceneklerJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UrunKayitlariTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $UrunKayitlariTable> {
  $$UrunKayitlariTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kategoriId => $composableBuilder(
    column: $table.kategoriId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ad =>
      $composableBuilder(column: $table.ad, builder: (column) => column);

  GeneratedColumn<String> get aciklama =>
      $composableBuilder(column: $table.aciklama, builder: (column) => column);

  GeneratedColumn<double> get fiyat =>
      $composableBuilder(column: $table.fiyat, builder: (column) => column);

  GeneratedColumn<String> get gorselUrl =>
      $composableBuilder(column: $table.gorselUrl, builder: (column) => column);

  GeneratedColumn<bool> get stoktaMi =>
      $composableBuilder(column: $table.stoktaMi, builder: (column) => column);

  GeneratedColumn<bool> get oneCikanMi => $composableBuilder(
    column: $table.oneCikanMi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seceneklerJson => $composableBuilder(
    column: $table.seceneklerJson,
    builder: (column) => column,
  );
}

class $$UrunKayitlariTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $UrunKayitlariTable,
          UrunKayitlariData,
          $$UrunKayitlariTableFilterComposer,
          $$UrunKayitlariTableOrderingComposer,
          $$UrunKayitlariTableAnnotationComposer,
          $$UrunKayitlariTableCreateCompanionBuilder,
          $$UrunKayitlariTableUpdateCompanionBuilder,
          (
            UrunKayitlariData,
            BaseReferences<
              _$UygulamaVeritabani,
              $UrunKayitlariTable,
              UrunKayitlariData
            >,
          ),
          UrunKayitlariData,
          PrefetchHooks Function()
        > {
  $$UrunKayitlariTableTableManager(
    _$UygulamaVeritabani db,
    $UrunKayitlariTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UrunKayitlariTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UrunKayitlariTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UrunKayitlariTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kategoriId = const Value.absent(),
                Value<String> ad = const Value.absent(),
                Value<String> aciklama = const Value.absent(),
                Value<double> fiyat = const Value.absent(),
                Value<String?> gorselUrl = const Value.absent(),
                Value<bool> stoktaMi = const Value.absent(),
                Value<bool> oneCikanMi = const Value.absent(),
                Value<String> seceneklerJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UrunKayitlariCompanion(
                id: id,
                kategoriId: kategoriId,
                ad: ad,
                aciklama: aciklama,
                fiyat: fiyat,
                gorselUrl: gorselUrl,
                stoktaMi: stoktaMi,
                oneCikanMi: oneCikanMi,
                seceneklerJson: seceneklerJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kategoriId,
                required String ad,
                required String aciklama,
                required double fiyat,
                Value<String?> gorselUrl = const Value.absent(),
                required bool stoktaMi,
                required bool oneCikanMi,
                required String seceneklerJson,
                Value<int> rowid = const Value.absent(),
              }) => UrunKayitlariCompanion.insert(
                id: id,
                kategoriId: kategoriId,
                ad: ad,
                aciklama: aciklama,
                fiyat: fiyat,
                gorselUrl: gorselUrl,
                stoktaMi: stoktaMi,
                oneCikanMi: oneCikanMi,
                seceneklerJson: seceneklerJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UrunKayitlariTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $UrunKayitlariTable,
      UrunKayitlariData,
      $$UrunKayitlariTableFilterComposer,
      $$UrunKayitlariTableOrderingComposer,
      $$UrunKayitlariTableAnnotationComposer,
      $$UrunKayitlariTableCreateCompanionBuilder,
      $$UrunKayitlariTableUpdateCompanionBuilder,
      (
        UrunKayitlariData,
        BaseReferences<
          _$UygulamaVeritabani,
          $UrunKayitlariTable,
          UrunKayitlariData
        >,
      ),
      UrunKayitlariData,
      PrefetchHooks Function()
    >;
typedef $$SepetKayitlariTableCreateCompanionBuilder =
    SepetKayitlariCompanion Function({
      required String id,
      Value<String?> kuponKodu,
      Value<int> rowid,
    });
typedef $$SepetKayitlariTableUpdateCompanionBuilder =
    SepetKayitlariCompanion Function({
      Value<String> id,
      Value<String?> kuponKodu,
      Value<int> rowid,
    });

class $$SepetKayitlariTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $SepetKayitlariTable> {
  $$SepetKayitlariTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kuponKodu => $composableBuilder(
    column: $table.kuponKodu,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SepetKayitlariTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $SepetKayitlariTable> {
  $$SepetKayitlariTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kuponKodu => $composableBuilder(
    column: $table.kuponKodu,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SepetKayitlariTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $SepetKayitlariTable> {
  $$SepetKayitlariTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kuponKodu =>
      $composableBuilder(column: $table.kuponKodu, builder: (column) => column);
}

class $$SepetKayitlariTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $SepetKayitlariTable,
          SepetKayitlariData,
          $$SepetKayitlariTableFilterComposer,
          $$SepetKayitlariTableOrderingComposer,
          $$SepetKayitlariTableAnnotationComposer,
          $$SepetKayitlariTableCreateCompanionBuilder,
          $$SepetKayitlariTableUpdateCompanionBuilder,
          (
            SepetKayitlariData,
            BaseReferences<
              _$UygulamaVeritabani,
              $SepetKayitlariTable,
              SepetKayitlariData
            >,
          ),
          SepetKayitlariData,
          PrefetchHooks Function()
        > {
  $$SepetKayitlariTableTableManager(
    _$UygulamaVeritabani db,
    $SepetKayitlariTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SepetKayitlariTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SepetKayitlariTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SepetKayitlariTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> kuponKodu = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SepetKayitlariCompanion(
                id: id,
                kuponKodu: kuponKodu,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> kuponKodu = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SepetKayitlariCompanion.insert(
                id: id,
                kuponKodu: kuponKodu,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SepetKayitlariTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $SepetKayitlariTable,
      SepetKayitlariData,
      $$SepetKayitlariTableFilterComposer,
      $$SepetKayitlariTableOrderingComposer,
      $$SepetKayitlariTableAnnotationComposer,
      $$SepetKayitlariTableCreateCompanionBuilder,
      $$SepetKayitlariTableUpdateCompanionBuilder,
      (
        SepetKayitlariData,
        BaseReferences<
          _$UygulamaVeritabani,
          $SepetKayitlariTable,
          SepetKayitlariData
        >,
      ),
      SepetKayitlariData,
      PrefetchHooks Function()
    >;
typedef $$SepetKalemleriTableCreateCompanionBuilder =
    SepetKalemleriCompanion Function({
      required String id,
      required String sepetId,
      required String urunId,
      required double birimFiyat,
      required int adet,
      Value<String?> secenekAdi,
      Value<String?> notMetni,
      Value<int> rowid,
    });
typedef $$SepetKalemleriTableUpdateCompanionBuilder =
    SepetKalemleriCompanion Function({
      Value<String> id,
      Value<String> sepetId,
      Value<String> urunId,
      Value<double> birimFiyat,
      Value<int> adet,
      Value<String?> secenekAdi,
      Value<String?> notMetni,
      Value<int> rowid,
    });

class $$SepetKalemleriTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $SepetKalemleriTable> {
  $$SepetKalemleriTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sepetId => $composableBuilder(
    column: $table.sepetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get urunId => $composableBuilder(
    column: $table.urunId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birimFiyat => $composableBuilder(
    column: $table.birimFiyat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get adet => $composableBuilder(
    column: $table.adet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secenekAdi => $composableBuilder(
    column: $table.secenekAdi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notMetni => $composableBuilder(
    column: $table.notMetni,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SepetKalemleriTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $SepetKalemleriTable> {
  $$SepetKalemleriTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sepetId => $composableBuilder(
    column: $table.sepetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urunId => $composableBuilder(
    column: $table.urunId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birimFiyat => $composableBuilder(
    column: $table.birimFiyat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get adet => $composableBuilder(
    column: $table.adet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secenekAdi => $composableBuilder(
    column: $table.secenekAdi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notMetni => $composableBuilder(
    column: $table.notMetni,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SepetKalemleriTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $SepetKalemleriTable> {
  $$SepetKalemleriTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sepetId =>
      $composableBuilder(column: $table.sepetId, builder: (column) => column);

  GeneratedColumn<String> get urunId =>
      $composableBuilder(column: $table.urunId, builder: (column) => column);

  GeneratedColumn<double> get birimFiyat => $composableBuilder(
    column: $table.birimFiyat,
    builder: (column) => column,
  );

  GeneratedColumn<int> get adet =>
      $composableBuilder(column: $table.adet, builder: (column) => column);

  GeneratedColumn<String> get secenekAdi => $composableBuilder(
    column: $table.secenekAdi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notMetni =>
      $composableBuilder(column: $table.notMetni, builder: (column) => column);
}

class $$SepetKalemleriTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $SepetKalemleriTable,
          SepetKalemleriData,
          $$SepetKalemleriTableFilterComposer,
          $$SepetKalemleriTableOrderingComposer,
          $$SepetKalemleriTableAnnotationComposer,
          $$SepetKalemleriTableCreateCompanionBuilder,
          $$SepetKalemleriTableUpdateCompanionBuilder,
          (
            SepetKalemleriData,
            BaseReferences<
              _$UygulamaVeritabani,
              $SepetKalemleriTable,
              SepetKalemleriData
            >,
          ),
          SepetKalemleriData,
          PrefetchHooks Function()
        > {
  $$SepetKalemleriTableTableManager(
    _$UygulamaVeritabani db,
    $SepetKalemleriTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SepetKalemleriTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SepetKalemleriTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SepetKalemleriTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sepetId = const Value.absent(),
                Value<String> urunId = const Value.absent(),
                Value<double> birimFiyat = const Value.absent(),
                Value<int> adet = const Value.absent(),
                Value<String?> secenekAdi = const Value.absent(),
                Value<String?> notMetni = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SepetKalemleriCompanion(
                id: id,
                sepetId: sepetId,
                urunId: urunId,
                birimFiyat: birimFiyat,
                adet: adet,
                secenekAdi: secenekAdi,
                notMetni: notMetni,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sepetId,
                required String urunId,
                required double birimFiyat,
                required int adet,
                Value<String?> secenekAdi = const Value.absent(),
                Value<String?> notMetni = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SepetKalemleriCompanion.insert(
                id: id,
                sepetId: sepetId,
                urunId: urunId,
                birimFiyat: birimFiyat,
                adet: adet,
                secenekAdi: secenekAdi,
                notMetni: notMetni,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SepetKalemleriTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $SepetKalemleriTable,
      SepetKalemleriData,
      $$SepetKalemleriTableFilterComposer,
      $$SepetKalemleriTableOrderingComposer,
      $$SepetKalemleriTableAnnotationComposer,
      $$SepetKalemleriTableCreateCompanionBuilder,
      $$SepetKalemleriTableUpdateCompanionBuilder,
      (
        SepetKalemleriData,
        BaseReferences<
          _$UygulamaVeritabani,
          $SepetKalemleriTable,
          SepetKalemleriData
        >,
      ),
      SepetKalemleriData,
      PrefetchHooks Function()
    >;
typedef $$SiparisKayitlariTableCreateCompanionBuilder =
    SiparisKayitlariCompanion Function({
      required String id,
      required String siparisNo,
      required int teslimatTipi,
      required int durum,
      required DateTime olusturmaTarihi,
      Value<String?> adresMetni,
      Value<String?> teslimatNotu,
      Value<String?> kuryeAdi,
      Value<int?> paketTeslimatDurumu,
      Value<String?> masaNo,
      Value<String?> bolumAdi,
      Value<String?> kaynak,
      required bool sahipMisafir,
      required String sahipAdSoyad,
      required String sahipTelefon,
      Value<String?> sahipEposta,
      Value<String?> sahipAdres,
      Value<int> rowid,
    });
typedef $$SiparisKayitlariTableUpdateCompanionBuilder =
    SiparisKayitlariCompanion Function({
      Value<String> id,
      Value<String> siparisNo,
      Value<int> teslimatTipi,
      Value<int> durum,
      Value<DateTime> olusturmaTarihi,
      Value<String?> adresMetni,
      Value<String?> teslimatNotu,
      Value<String?> kuryeAdi,
      Value<int?> paketTeslimatDurumu,
      Value<String?> masaNo,
      Value<String?> bolumAdi,
      Value<String?> kaynak,
      Value<bool> sahipMisafir,
      Value<String> sahipAdSoyad,
      Value<String> sahipTelefon,
      Value<String?> sahipEposta,
      Value<String?> sahipAdres,
      Value<int> rowid,
    });

class $$SiparisKayitlariTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $SiparisKayitlariTable> {
  $$SiparisKayitlariTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siparisNo => $composableBuilder(
    column: $table.siparisNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get teslimatTipi => $composableBuilder(
    column: $table.teslimatTipi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durum => $composableBuilder(
    column: $table.durum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get olusturmaTarihi => $composableBuilder(
    column: $table.olusturmaTarihi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adresMetni => $composableBuilder(
    column: $table.adresMetni,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teslimatNotu => $composableBuilder(
    column: $table.teslimatNotu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kuryeAdi => $composableBuilder(
    column: $table.kuryeAdi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paketTeslimatDurumu => $composableBuilder(
    column: $table.paketTeslimatDurumu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get masaNo => $composableBuilder(
    column: $table.masaNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bolumAdi => $composableBuilder(
    column: $table.bolumAdi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kaynak => $composableBuilder(
    column: $table.kaynak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sahipMisafir => $composableBuilder(
    column: $table.sahipMisafir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sahipAdSoyad => $composableBuilder(
    column: $table.sahipAdSoyad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sahipTelefon => $composableBuilder(
    column: $table.sahipTelefon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sahipEposta => $composableBuilder(
    column: $table.sahipEposta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sahipAdres => $composableBuilder(
    column: $table.sahipAdres,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SiparisKayitlariTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $SiparisKayitlariTable> {
  $$SiparisKayitlariTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siparisNo => $composableBuilder(
    column: $table.siparisNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get teslimatTipi => $composableBuilder(
    column: $table.teslimatTipi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durum => $composableBuilder(
    column: $table.durum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get olusturmaTarihi => $composableBuilder(
    column: $table.olusturmaTarihi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adresMetni => $composableBuilder(
    column: $table.adresMetni,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teslimatNotu => $composableBuilder(
    column: $table.teslimatNotu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kuryeAdi => $composableBuilder(
    column: $table.kuryeAdi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paketTeslimatDurumu => $composableBuilder(
    column: $table.paketTeslimatDurumu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get masaNo => $composableBuilder(
    column: $table.masaNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bolumAdi => $composableBuilder(
    column: $table.bolumAdi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kaynak => $composableBuilder(
    column: $table.kaynak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sahipMisafir => $composableBuilder(
    column: $table.sahipMisafir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sahipAdSoyad => $composableBuilder(
    column: $table.sahipAdSoyad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sahipTelefon => $composableBuilder(
    column: $table.sahipTelefon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sahipEposta => $composableBuilder(
    column: $table.sahipEposta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sahipAdres => $composableBuilder(
    column: $table.sahipAdres,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SiparisKayitlariTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $SiparisKayitlariTable> {
  $$SiparisKayitlariTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get siparisNo =>
      $composableBuilder(column: $table.siparisNo, builder: (column) => column);

  GeneratedColumn<int> get teslimatTipi => $composableBuilder(
    column: $table.teslimatTipi,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durum =>
      $composableBuilder(column: $table.durum, builder: (column) => column);

  GeneratedColumn<DateTime> get olusturmaTarihi => $composableBuilder(
    column: $table.olusturmaTarihi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get adresMetni => $composableBuilder(
    column: $table.adresMetni,
    builder: (column) => column,
  );

  GeneratedColumn<String> get teslimatNotu => $composableBuilder(
    column: $table.teslimatNotu,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kuryeAdi =>
      $composableBuilder(column: $table.kuryeAdi, builder: (column) => column);

  GeneratedColumn<int> get paketTeslimatDurumu => $composableBuilder(
    column: $table.paketTeslimatDurumu,
    builder: (column) => column,
  );

  GeneratedColumn<String> get masaNo =>
      $composableBuilder(column: $table.masaNo, builder: (column) => column);

  GeneratedColumn<String> get bolumAdi =>
      $composableBuilder(column: $table.bolumAdi, builder: (column) => column);

  GeneratedColumn<String> get kaynak =>
      $composableBuilder(column: $table.kaynak, builder: (column) => column);

  GeneratedColumn<bool> get sahipMisafir => $composableBuilder(
    column: $table.sahipMisafir,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sahipAdSoyad => $composableBuilder(
    column: $table.sahipAdSoyad,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sahipTelefon => $composableBuilder(
    column: $table.sahipTelefon,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sahipEposta => $composableBuilder(
    column: $table.sahipEposta,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sahipAdres => $composableBuilder(
    column: $table.sahipAdres,
    builder: (column) => column,
  );
}

class $$SiparisKayitlariTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $SiparisKayitlariTable,
          SiparisKayitlariData,
          $$SiparisKayitlariTableFilterComposer,
          $$SiparisKayitlariTableOrderingComposer,
          $$SiparisKayitlariTableAnnotationComposer,
          $$SiparisKayitlariTableCreateCompanionBuilder,
          $$SiparisKayitlariTableUpdateCompanionBuilder,
          (
            SiparisKayitlariData,
            BaseReferences<
              _$UygulamaVeritabani,
              $SiparisKayitlariTable,
              SiparisKayitlariData
            >,
          ),
          SiparisKayitlariData,
          PrefetchHooks Function()
        > {
  $$SiparisKayitlariTableTableManager(
    _$UygulamaVeritabani db,
    $SiparisKayitlariTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SiparisKayitlariTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SiparisKayitlariTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SiparisKayitlariTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> siparisNo = const Value.absent(),
                Value<int> teslimatTipi = const Value.absent(),
                Value<int> durum = const Value.absent(),
                Value<DateTime> olusturmaTarihi = const Value.absent(),
                Value<String?> adresMetni = const Value.absent(),
                Value<String?> teslimatNotu = const Value.absent(),
                Value<String?> kuryeAdi = const Value.absent(),
                Value<int?> paketTeslimatDurumu = const Value.absent(),
                Value<String?> masaNo = const Value.absent(),
                Value<String?> bolumAdi = const Value.absent(),
                Value<String?> kaynak = const Value.absent(),
                Value<bool> sahipMisafir = const Value.absent(),
                Value<String> sahipAdSoyad = const Value.absent(),
                Value<String> sahipTelefon = const Value.absent(),
                Value<String?> sahipEposta = const Value.absent(),
                Value<String?> sahipAdres = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SiparisKayitlariCompanion(
                id: id,
                siparisNo: siparisNo,
                teslimatTipi: teslimatTipi,
                durum: durum,
                olusturmaTarihi: olusturmaTarihi,
                adresMetni: adresMetni,
                teslimatNotu: teslimatNotu,
                kuryeAdi: kuryeAdi,
                paketTeslimatDurumu: paketTeslimatDurumu,
                masaNo: masaNo,
                bolumAdi: bolumAdi,
                kaynak: kaynak,
                sahipMisafir: sahipMisafir,
                sahipAdSoyad: sahipAdSoyad,
                sahipTelefon: sahipTelefon,
                sahipEposta: sahipEposta,
                sahipAdres: sahipAdres,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String siparisNo,
                required int teslimatTipi,
                required int durum,
                required DateTime olusturmaTarihi,
                Value<String?> adresMetni = const Value.absent(),
                Value<String?> teslimatNotu = const Value.absent(),
                Value<String?> kuryeAdi = const Value.absent(),
                Value<int?> paketTeslimatDurumu = const Value.absent(),
                Value<String?> masaNo = const Value.absent(),
                Value<String?> bolumAdi = const Value.absent(),
                Value<String?> kaynak = const Value.absent(),
                required bool sahipMisafir,
                required String sahipAdSoyad,
                required String sahipTelefon,
                Value<String?> sahipEposta = const Value.absent(),
                Value<String?> sahipAdres = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SiparisKayitlariCompanion.insert(
                id: id,
                siparisNo: siparisNo,
                teslimatTipi: teslimatTipi,
                durum: durum,
                olusturmaTarihi: olusturmaTarihi,
                adresMetni: adresMetni,
                teslimatNotu: teslimatNotu,
                kuryeAdi: kuryeAdi,
                paketTeslimatDurumu: paketTeslimatDurumu,
                masaNo: masaNo,
                bolumAdi: bolumAdi,
                kaynak: kaynak,
                sahipMisafir: sahipMisafir,
                sahipAdSoyad: sahipAdSoyad,
                sahipTelefon: sahipTelefon,
                sahipEposta: sahipEposta,
                sahipAdres: sahipAdres,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SiparisKayitlariTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $SiparisKayitlariTable,
      SiparisKayitlariData,
      $$SiparisKayitlariTableFilterComposer,
      $$SiparisKayitlariTableOrderingComposer,
      $$SiparisKayitlariTableAnnotationComposer,
      $$SiparisKayitlariTableCreateCompanionBuilder,
      $$SiparisKayitlariTableUpdateCompanionBuilder,
      (
        SiparisKayitlariData,
        BaseReferences<
          _$UygulamaVeritabani,
          $SiparisKayitlariTable,
          SiparisKayitlariData
        >,
      ),
      SiparisKayitlariData,
      PrefetchHooks Function()
    >;
typedef $$SiparisKalemleriTableCreateCompanionBuilder =
    SiparisKalemleriCompanion Function({
      required String id,
      required String siparisId,
      required String urunId,
      required String urunAdi,
      required double birimFiyat,
      required int adet,
      Value<String?> secenekAdi,
      Value<String?> notMetni,
      Value<int> rowid,
    });
typedef $$SiparisKalemleriTableUpdateCompanionBuilder =
    SiparisKalemleriCompanion Function({
      Value<String> id,
      Value<String> siparisId,
      Value<String> urunId,
      Value<String> urunAdi,
      Value<double> birimFiyat,
      Value<int> adet,
      Value<String?> secenekAdi,
      Value<String?> notMetni,
      Value<int> rowid,
    });

class $$SiparisKalemleriTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $SiparisKalemleriTable> {
  $$SiparisKalemleriTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siparisId => $composableBuilder(
    column: $table.siparisId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get urunId => $composableBuilder(
    column: $table.urunId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get urunAdi => $composableBuilder(
    column: $table.urunAdi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birimFiyat => $composableBuilder(
    column: $table.birimFiyat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get adet => $composableBuilder(
    column: $table.adet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secenekAdi => $composableBuilder(
    column: $table.secenekAdi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notMetni => $composableBuilder(
    column: $table.notMetni,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SiparisKalemleriTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $SiparisKalemleriTable> {
  $$SiparisKalemleriTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siparisId => $composableBuilder(
    column: $table.siparisId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urunId => $composableBuilder(
    column: $table.urunId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urunAdi => $composableBuilder(
    column: $table.urunAdi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birimFiyat => $composableBuilder(
    column: $table.birimFiyat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get adet => $composableBuilder(
    column: $table.adet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secenekAdi => $composableBuilder(
    column: $table.secenekAdi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notMetni => $composableBuilder(
    column: $table.notMetni,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SiparisKalemleriTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $SiparisKalemleriTable> {
  $$SiparisKalemleriTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get siparisId =>
      $composableBuilder(column: $table.siparisId, builder: (column) => column);

  GeneratedColumn<String> get urunId =>
      $composableBuilder(column: $table.urunId, builder: (column) => column);

  GeneratedColumn<String> get urunAdi =>
      $composableBuilder(column: $table.urunAdi, builder: (column) => column);

  GeneratedColumn<double> get birimFiyat => $composableBuilder(
    column: $table.birimFiyat,
    builder: (column) => column,
  );

  GeneratedColumn<int> get adet =>
      $composableBuilder(column: $table.adet, builder: (column) => column);

  GeneratedColumn<String> get secenekAdi => $composableBuilder(
    column: $table.secenekAdi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notMetni =>
      $composableBuilder(column: $table.notMetni, builder: (column) => column);
}

class $$SiparisKalemleriTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $SiparisKalemleriTable,
          SiparisKalemleriData,
          $$SiparisKalemleriTableFilterComposer,
          $$SiparisKalemleriTableOrderingComposer,
          $$SiparisKalemleriTableAnnotationComposer,
          $$SiparisKalemleriTableCreateCompanionBuilder,
          $$SiparisKalemleriTableUpdateCompanionBuilder,
          (
            SiparisKalemleriData,
            BaseReferences<
              _$UygulamaVeritabani,
              $SiparisKalemleriTable,
              SiparisKalemleriData
            >,
          ),
          SiparisKalemleriData,
          PrefetchHooks Function()
        > {
  $$SiparisKalemleriTableTableManager(
    _$UygulamaVeritabani db,
    $SiparisKalemleriTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SiparisKalemleriTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SiparisKalemleriTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SiparisKalemleriTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> siparisId = const Value.absent(),
                Value<String> urunId = const Value.absent(),
                Value<String> urunAdi = const Value.absent(),
                Value<double> birimFiyat = const Value.absent(),
                Value<int> adet = const Value.absent(),
                Value<String?> secenekAdi = const Value.absent(),
                Value<String?> notMetni = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SiparisKalemleriCompanion(
                id: id,
                siparisId: siparisId,
                urunId: urunId,
                urunAdi: urunAdi,
                birimFiyat: birimFiyat,
                adet: adet,
                secenekAdi: secenekAdi,
                notMetni: notMetni,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String siparisId,
                required String urunId,
                required String urunAdi,
                required double birimFiyat,
                required int adet,
                Value<String?> secenekAdi = const Value.absent(),
                Value<String?> notMetni = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SiparisKalemleriCompanion.insert(
                id: id,
                siparisId: siparisId,
                urunId: urunId,
                urunAdi: urunAdi,
                birimFiyat: birimFiyat,
                adet: adet,
                secenekAdi: secenekAdi,
                notMetni: notMetni,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SiparisKalemleriTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $SiparisKalemleriTable,
      SiparisKalemleriData,
      $$SiparisKalemleriTableFilterComposer,
      $$SiparisKalemleriTableOrderingComposer,
      $$SiparisKalemleriTableAnnotationComposer,
      $$SiparisKalemleriTableCreateCompanionBuilder,
      $$SiparisKalemleriTableUpdateCompanionBuilder,
      (
        SiparisKalemleriData,
        BaseReferences<
          _$UygulamaVeritabani,
          $SiparisKalemleriTable,
          SiparisKalemleriData
        >,
      ),
      SiparisKalemleriData,
      PrefetchHooks Function()
    >;
typedef $$UygulamaAyarlarTableCreateCompanionBuilder =
    UygulamaAyarlarCompanion Function({
      required String anahtar,
      required String deger,
      Value<int> rowid,
    });
typedef $$UygulamaAyarlarTableUpdateCompanionBuilder =
    UygulamaAyarlarCompanion Function({
      Value<String> anahtar,
      Value<String> deger,
      Value<int> rowid,
    });

class $$UygulamaAyarlarTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $UygulamaAyarlarTable> {
  $$UygulamaAyarlarTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get anahtar => $composableBuilder(
    column: $table.anahtar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deger => $composableBuilder(
    column: $table.deger,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UygulamaAyarlarTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $UygulamaAyarlarTable> {
  $$UygulamaAyarlarTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get anahtar => $composableBuilder(
    column: $table.anahtar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deger => $composableBuilder(
    column: $table.deger,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UygulamaAyarlarTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $UygulamaAyarlarTable> {
  $$UygulamaAyarlarTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get anahtar =>
      $composableBuilder(column: $table.anahtar, builder: (column) => column);

  GeneratedColumn<String> get deger =>
      $composableBuilder(column: $table.deger, builder: (column) => column);
}

class $$UygulamaAyarlarTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $UygulamaAyarlarTable,
          UygulamaAyarlarData,
          $$UygulamaAyarlarTableFilterComposer,
          $$UygulamaAyarlarTableOrderingComposer,
          $$UygulamaAyarlarTableAnnotationComposer,
          $$UygulamaAyarlarTableCreateCompanionBuilder,
          $$UygulamaAyarlarTableUpdateCompanionBuilder,
          (
            UygulamaAyarlarData,
            BaseReferences<
              _$UygulamaVeritabani,
              $UygulamaAyarlarTable,
              UygulamaAyarlarData
            >,
          ),
          UygulamaAyarlarData,
          PrefetchHooks Function()
        > {
  $$UygulamaAyarlarTableTableManager(
    _$UygulamaVeritabani db,
    $UygulamaAyarlarTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UygulamaAyarlarTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UygulamaAyarlarTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UygulamaAyarlarTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> anahtar = const Value.absent(),
                Value<String> deger = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UygulamaAyarlarCompanion(
                anahtar: anahtar,
                deger: deger,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String anahtar,
                required String deger,
                Value<int> rowid = const Value.absent(),
              }) => UygulamaAyarlarCompanion.insert(
                anahtar: anahtar,
                deger: deger,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UygulamaAyarlarTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $UygulamaAyarlarTable,
      UygulamaAyarlarData,
      $$UygulamaAyarlarTableFilterComposer,
      $$UygulamaAyarlarTableOrderingComposer,
      $$UygulamaAyarlarTableAnnotationComposer,
      $$UygulamaAyarlarTableCreateCompanionBuilder,
      $$UygulamaAyarlarTableUpdateCompanionBuilder,
      (
        UygulamaAyarlarData,
        BaseReferences<
          _$UygulamaVeritabani,
          $UygulamaAyarlarTable,
          UygulamaAyarlarData
        >,
      ),
      UygulamaAyarlarData,
      PrefetchHooks Function()
    >;

class $UygulamaVeritabaniManager {
  final _$UygulamaVeritabani _db;
  $UygulamaVeritabaniManager(this._db);
  $$KullaniciKayitlariTableTableManager get kullaniciKayitlari =>
      $$KullaniciKayitlariTableTableManager(_db, _db.kullaniciKayitlari);
  $$MisafirKayitlariTableTableManager get misafirKayitlari =>
      $$MisafirKayitlariTableTableManager(_db, _db.misafirKayitlari);
  $$KategoriKayitlariTableTableManager get kategoriKayitlari =>
      $$KategoriKayitlariTableTableManager(_db, _db.kategoriKayitlari);
  $$UrunKayitlariTableTableManager get urunKayitlari =>
      $$UrunKayitlariTableTableManager(_db, _db.urunKayitlari);
  $$SepetKayitlariTableTableManager get sepetKayitlari =>
      $$SepetKayitlariTableTableManager(_db, _db.sepetKayitlari);
  $$SepetKalemleriTableTableManager get sepetKalemleri =>
      $$SepetKalemleriTableTableManager(_db, _db.sepetKalemleri);
  $$SiparisKayitlariTableTableManager get siparisKayitlari =>
      $$SiparisKayitlariTableTableManager(_db, _db.siparisKayitlari);
  $$SiparisKalemleriTableTableManager get siparisKalemleri =>
      $$SiparisKalemleriTableTableManager(_db, _db.siparisKalemleri);
  $$UygulamaAyarlarTableTableManager get uygulamaAyarlar =>
      $$UygulamaAyarlarTableTableManager(_db, _db.uygulamaAyarlar);
}
