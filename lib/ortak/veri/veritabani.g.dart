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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kategori_kayitlari (id) ON DELETE CASCADE',
    ),
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sepet_kayitlari (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _urunIdMeta = const VerificationMeta('urunId');
  @override
  late final GeneratedColumn<String> urunId = GeneratedColumn<String>(
    'urun_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES urun_kayitlari (id) ON DELETE CASCADE',
    ),
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
  static const VerificationMeta _indirimTutariMeta = const VerificationMeta(
    'indirimTutari',
  );
  @override
  late final GeneratedColumn<double> indirimTutari = GeneratedColumn<double>(
    'indirim_tutari',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _aydinlatmaOnayiMeta = const VerificationMeta(
    'aydinlatmaOnayi',
  );
  @override
  late final GeneratedColumn<bool> aydinlatmaOnayi = GeneratedColumn<bool>(
    'aydinlatma_onayi',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("aydinlatma_onayi" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ticariIletisimOnayiMeta =
      const VerificationMeta('ticariIletisimOnayi');
  @override
  late final GeneratedColumn<bool> ticariIletisimOnayi = GeneratedColumn<bool>(
    'ticari_iletisim_onayi',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ticari_iletisim_onayi" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    kuponKodu,
    indirimTutari,
    aydinlatmaOnayi,
    ticariIletisimOnayi,
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
    if (data.containsKey('kupon_kodu')) {
      context.handle(
        _kuponKoduMeta,
        kuponKodu.isAcceptableOrUnknown(data['kupon_kodu']!, _kuponKoduMeta),
      );
    }
    if (data.containsKey('indirim_tutari')) {
      context.handle(
        _indirimTutariMeta,
        indirimTutari.isAcceptableOrUnknown(
          data['indirim_tutari']!,
          _indirimTutariMeta,
        ),
      );
    }
    if (data.containsKey('aydinlatma_onayi')) {
      context.handle(
        _aydinlatmaOnayiMeta,
        aydinlatmaOnayi.isAcceptableOrUnknown(
          data['aydinlatma_onayi']!,
          _aydinlatmaOnayiMeta,
        ),
      );
    }
    if (data.containsKey('ticari_iletisim_onayi')) {
      context.handle(
        _ticariIletisimOnayiMeta,
        ticariIletisimOnayi.isAcceptableOrUnknown(
          data['ticari_iletisim_onayi']!,
          _ticariIletisimOnayiMeta,
        ),
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
      kuponKodu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kupon_kodu'],
      ),
      indirimTutari: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}indirim_tutari'],
      )!,
      aydinlatmaOnayi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}aydinlatma_onayi'],
      )!,
      ticariIletisimOnayi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ticari_iletisim_onayi'],
      )!,
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
  final String? kuponKodu;
  final double indirimTutari;
  final bool aydinlatmaOnayi;
  final bool ticariIletisimOnayi;
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
    this.kuponKodu,
    required this.indirimTutari,
    required this.aydinlatmaOnayi,
    required this.ticariIletisimOnayi,
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
    if (!nullToAbsent || kuponKodu != null) {
      map['kupon_kodu'] = Variable<String>(kuponKodu);
    }
    map['indirim_tutari'] = Variable<double>(indirimTutari);
    map['aydinlatma_onayi'] = Variable<bool>(aydinlatmaOnayi);
    map['ticari_iletisim_onayi'] = Variable<bool>(ticariIletisimOnayi);
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
      kuponKodu: kuponKodu == null && nullToAbsent
          ? const Value.absent()
          : Value(kuponKodu),
      indirimTutari: Value(indirimTutari),
      aydinlatmaOnayi: Value(aydinlatmaOnayi),
      ticariIletisimOnayi: Value(ticariIletisimOnayi),
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
      kuponKodu: serializer.fromJson<String?>(json['kuponKodu']),
      indirimTutari: serializer.fromJson<double>(json['indirimTutari']),
      aydinlatmaOnayi: serializer.fromJson<bool>(json['aydinlatmaOnayi']),
      ticariIletisimOnayi: serializer.fromJson<bool>(
        json['ticariIletisimOnayi'],
      ),
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
      'kuponKodu': serializer.toJson<String?>(kuponKodu),
      'indirimTutari': serializer.toJson<double>(indirimTutari),
      'aydinlatmaOnayi': serializer.toJson<bool>(aydinlatmaOnayi),
      'ticariIletisimOnayi': serializer.toJson<bool>(ticariIletisimOnayi),
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
    Value<String?> kuponKodu = const Value.absent(),
    double? indirimTutari,
    bool? aydinlatmaOnayi,
    bool? ticariIletisimOnayi,
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
    kuponKodu: kuponKodu.present ? kuponKodu.value : this.kuponKodu,
    indirimTutari: indirimTutari ?? this.indirimTutari,
    aydinlatmaOnayi: aydinlatmaOnayi ?? this.aydinlatmaOnayi,
    ticariIletisimOnayi: ticariIletisimOnayi ?? this.ticariIletisimOnayi,
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
      kuponKodu: data.kuponKodu.present ? data.kuponKodu.value : this.kuponKodu,
      indirimTutari: data.indirimTutari.present
          ? data.indirimTutari.value
          : this.indirimTutari,
      aydinlatmaOnayi: data.aydinlatmaOnayi.present
          ? data.aydinlatmaOnayi.value
          : this.aydinlatmaOnayi,
      ticariIletisimOnayi: data.ticariIletisimOnayi.present
          ? data.ticariIletisimOnayi.value
          : this.ticariIletisimOnayi,
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
          ..write('kuponKodu: $kuponKodu, ')
          ..write('indirimTutari: $indirimTutari, ')
          ..write('aydinlatmaOnayi: $aydinlatmaOnayi, ')
          ..write('ticariIletisimOnayi: $ticariIletisimOnayi, ')
          ..write('sahipMisafir: $sahipMisafir, ')
          ..write('sahipAdSoyad: $sahipAdSoyad, ')
          ..write('sahipTelefon: $sahipTelefon, ')
          ..write('sahipEposta: $sahipEposta, ')
          ..write('sahipAdres: $sahipAdres')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
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
    kuponKodu,
    indirimTutari,
    aydinlatmaOnayi,
    ticariIletisimOnayi,
    sahipMisafir,
    sahipAdSoyad,
    sahipTelefon,
    sahipEposta,
    sahipAdres,
  ]);
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
          other.kuponKodu == this.kuponKodu &&
          other.indirimTutari == this.indirimTutari &&
          other.aydinlatmaOnayi == this.aydinlatmaOnayi &&
          other.ticariIletisimOnayi == this.ticariIletisimOnayi &&
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
  final Value<String?> kuponKodu;
  final Value<double> indirimTutari;
  final Value<bool> aydinlatmaOnayi;
  final Value<bool> ticariIletisimOnayi;
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
    this.kuponKodu = const Value.absent(),
    this.indirimTutari = const Value.absent(),
    this.aydinlatmaOnayi = const Value.absent(),
    this.ticariIletisimOnayi = const Value.absent(),
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
    this.kuponKodu = const Value.absent(),
    this.indirimTutari = const Value.absent(),
    this.aydinlatmaOnayi = const Value.absent(),
    this.ticariIletisimOnayi = const Value.absent(),
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
    Expression<String>? kuponKodu,
    Expression<double>? indirimTutari,
    Expression<bool>? aydinlatmaOnayi,
    Expression<bool>? ticariIletisimOnayi,
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
      if (kuponKodu != null) 'kupon_kodu': kuponKodu,
      if (indirimTutari != null) 'indirim_tutari': indirimTutari,
      if (aydinlatmaOnayi != null) 'aydinlatma_onayi': aydinlatmaOnayi,
      if (ticariIletisimOnayi != null)
        'ticari_iletisim_onayi': ticariIletisimOnayi,
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
    Value<String?>? kuponKodu,
    Value<double>? indirimTutari,
    Value<bool>? aydinlatmaOnayi,
    Value<bool>? ticariIletisimOnayi,
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
      kuponKodu: kuponKodu ?? this.kuponKodu,
      indirimTutari: indirimTutari ?? this.indirimTutari,
      aydinlatmaOnayi: aydinlatmaOnayi ?? this.aydinlatmaOnayi,
      ticariIletisimOnayi: ticariIletisimOnayi ?? this.ticariIletisimOnayi,
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
    if (kuponKodu.present) {
      map['kupon_kodu'] = Variable<String>(kuponKodu.value);
    }
    if (indirimTutari.present) {
      map['indirim_tutari'] = Variable<double>(indirimTutari.value);
    }
    if (aydinlatmaOnayi.present) {
      map['aydinlatma_onayi'] = Variable<bool>(aydinlatmaOnayi.value);
    }
    if (ticariIletisimOnayi.present) {
      map['ticari_iletisim_onayi'] = Variable<bool>(ticariIletisimOnayi.value);
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
          ..write('kuponKodu: $kuponKodu, ')
          ..write('indirimTutari: $indirimTutari, ')
          ..write('aydinlatmaOnayi: $aydinlatmaOnayi, ')
          ..write('ticariIletisimOnayi: $ticariIletisimOnayi, ')
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES siparis_kayitlari (id) ON DELETE CASCADE',
    ),
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

class $YaziciKayitlariTable extends YaziciKayitlari
    with TableInfo<$YaziciKayitlariTable, YaziciKayitlariData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $YaziciKayitlariTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _rolEtiketiMeta = const VerificationMeta(
    'rolEtiketi',
  );
  @override
  late final GeneratedColumn<String> rolEtiketi = GeneratedColumn<String>(
    'rol_etiketi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baglantiNoktasiMeta = const VerificationMeta(
    'baglantiNoktasi',
  );
  @override
  late final GeneratedColumn<String> baglantiNoktasi = GeneratedColumn<String>(
    'baglanti_noktasi',
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
  static const VerificationMeta _durumMeta = const VerificationMeta('durum');
  @override
  late final GeneratedColumn<int> durum = GeneratedColumn<int>(
    'durum',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ad,
    rolEtiketi,
    baglantiNoktasi,
    aciklama,
    durum,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'yazici_kayitlari';
  @override
  VerificationContext validateIntegrity(
    Insertable<YaziciKayitlariData> instance, {
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
    if (data.containsKey('rol_etiketi')) {
      context.handle(
        _rolEtiketiMeta,
        rolEtiketi.isAcceptableOrUnknown(data['rol_etiketi']!, _rolEtiketiMeta),
      );
    } else if (isInserting) {
      context.missing(_rolEtiketiMeta);
    }
    if (data.containsKey('baglanti_noktasi')) {
      context.handle(
        _baglantiNoktasiMeta,
        baglantiNoktasi.isAcceptableOrUnknown(
          data['baglanti_noktasi']!,
          _baglantiNoktasiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baglantiNoktasiMeta);
    }
    if (data.containsKey('aciklama')) {
      context.handle(
        _aciklamaMeta,
        aciklama.isAcceptableOrUnknown(data['aciklama']!, _aciklamaMeta),
      );
    } else if (isInserting) {
      context.missing(_aciklamaMeta);
    }
    if (data.containsKey('durum')) {
      context.handle(
        _durumMeta,
        durum.isAcceptableOrUnknown(data['durum']!, _durumMeta),
      );
    } else if (isInserting) {
      context.missing(_durumMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  YaziciKayitlariData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return YaziciKayitlariData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ad'],
      )!,
      rolEtiketi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rol_etiketi'],
      )!,
      baglantiNoktasi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}baglanti_noktasi'],
      )!,
      aciklama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aciklama'],
      )!,
      durum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}durum'],
      )!,
    );
  }

  @override
  $YaziciKayitlariTable createAlias(String alias) {
    return $YaziciKayitlariTable(attachedDatabase, alias);
  }
}

class YaziciKayitlariData extends DataClass
    implements Insertable<YaziciKayitlariData> {
  final String id;
  final String ad;
  final String rolEtiketi;
  final String baglantiNoktasi;
  final String aciklama;
  final int durum;
  const YaziciKayitlariData({
    required this.id,
    required this.ad,
    required this.rolEtiketi,
    required this.baglantiNoktasi,
    required this.aciklama,
    required this.durum,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ad'] = Variable<String>(ad);
    map['rol_etiketi'] = Variable<String>(rolEtiketi);
    map['baglanti_noktasi'] = Variable<String>(baglantiNoktasi);
    map['aciklama'] = Variable<String>(aciklama);
    map['durum'] = Variable<int>(durum);
    return map;
  }

  YaziciKayitlariCompanion toCompanion(bool nullToAbsent) {
    return YaziciKayitlariCompanion(
      id: Value(id),
      ad: Value(ad),
      rolEtiketi: Value(rolEtiketi),
      baglantiNoktasi: Value(baglantiNoktasi),
      aciklama: Value(aciklama),
      durum: Value(durum),
    );
  }

  factory YaziciKayitlariData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return YaziciKayitlariData(
      id: serializer.fromJson<String>(json['id']),
      ad: serializer.fromJson<String>(json['ad']),
      rolEtiketi: serializer.fromJson<String>(json['rolEtiketi']),
      baglantiNoktasi: serializer.fromJson<String>(json['baglantiNoktasi']),
      aciklama: serializer.fromJson<String>(json['aciklama']),
      durum: serializer.fromJson<int>(json['durum']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ad': serializer.toJson<String>(ad),
      'rolEtiketi': serializer.toJson<String>(rolEtiketi),
      'baglantiNoktasi': serializer.toJson<String>(baglantiNoktasi),
      'aciklama': serializer.toJson<String>(aciklama),
      'durum': serializer.toJson<int>(durum),
    };
  }

  YaziciKayitlariData copyWith({
    String? id,
    String? ad,
    String? rolEtiketi,
    String? baglantiNoktasi,
    String? aciklama,
    int? durum,
  }) => YaziciKayitlariData(
    id: id ?? this.id,
    ad: ad ?? this.ad,
    rolEtiketi: rolEtiketi ?? this.rolEtiketi,
    baglantiNoktasi: baglantiNoktasi ?? this.baglantiNoktasi,
    aciklama: aciklama ?? this.aciklama,
    durum: durum ?? this.durum,
  );
  YaziciKayitlariData copyWithCompanion(YaziciKayitlariCompanion data) {
    return YaziciKayitlariData(
      id: data.id.present ? data.id.value : this.id,
      ad: data.ad.present ? data.ad.value : this.ad,
      rolEtiketi: data.rolEtiketi.present
          ? data.rolEtiketi.value
          : this.rolEtiketi,
      baglantiNoktasi: data.baglantiNoktasi.present
          ? data.baglantiNoktasi.value
          : this.baglantiNoktasi,
      aciklama: data.aciklama.present ? data.aciklama.value : this.aciklama,
      durum: data.durum.present ? data.durum.value : this.durum,
    );
  }

  @override
  String toString() {
    return (StringBuffer('YaziciKayitlariData(')
          ..write('id: $id, ')
          ..write('ad: $ad, ')
          ..write('rolEtiketi: $rolEtiketi, ')
          ..write('baglantiNoktasi: $baglantiNoktasi, ')
          ..write('aciklama: $aciklama, ')
          ..write('durum: $durum')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ad, rolEtiketi, baglantiNoktasi, aciklama, durum);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is YaziciKayitlariData &&
          other.id == this.id &&
          other.ad == this.ad &&
          other.rolEtiketi == this.rolEtiketi &&
          other.baglantiNoktasi == this.baglantiNoktasi &&
          other.aciklama == this.aciklama &&
          other.durum == this.durum);
}

class YaziciKayitlariCompanion extends UpdateCompanion<YaziciKayitlariData> {
  final Value<String> id;
  final Value<String> ad;
  final Value<String> rolEtiketi;
  final Value<String> baglantiNoktasi;
  final Value<String> aciklama;
  final Value<int> durum;
  final Value<int> rowid;
  const YaziciKayitlariCompanion({
    this.id = const Value.absent(),
    this.ad = const Value.absent(),
    this.rolEtiketi = const Value.absent(),
    this.baglantiNoktasi = const Value.absent(),
    this.aciklama = const Value.absent(),
    this.durum = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  YaziciKayitlariCompanion.insert({
    required String id,
    required String ad,
    required String rolEtiketi,
    required String baglantiNoktasi,
    required String aciklama,
    required int durum,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ad = Value(ad),
       rolEtiketi = Value(rolEtiketi),
       baglantiNoktasi = Value(baglantiNoktasi),
       aciklama = Value(aciklama),
       durum = Value(durum);
  static Insertable<YaziciKayitlariData> custom({
    Expression<String>? id,
    Expression<String>? ad,
    Expression<String>? rolEtiketi,
    Expression<String>? baglantiNoktasi,
    Expression<String>? aciklama,
    Expression<int>? durum,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ad != null) 'ad': ad,
      if (rolEtiketi != null) 'rol_etiketi': rolEtiketi,
      if (baglantiNoktasi != null) 'baglanti_noktasi': baglantiNoktasi,
      if (aciklama != null) 'aciklama': aciklama,
      if (durum != null) 'durum': durum,
      if (rowid != null) 'rowid': rowid,
    });
  }

  YaziciKayitlariCompanion copyWith({
    Value<String>? id,
    Value<String>? ad,
    Value<String>? rolEtiketi,
    Value<String>? baglantiNoktasi,
    Value<String>? aciklama,
    Value<int>? durum,
    Value<int>? rowid,
  }) {
    return YaziciKayitlariCompanion(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      rolEtiketi: rolEtiketi ?? this.rolEtiketi,
      baglantiNoktasi: baglantiNoktasi ?? this.baglantiNoktasi,
      aciklama: aciklama ?? this.aciklama,
      durum: durum ?? this.durum,
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
    if (rolEtiketi.present) {
      map['rol_etiketi'] = Variable<String>(rolEtiketi.value);
    }
    if (baglantiNoktasi.present) {
      map['baglanti_noktasi'] = Variable<String>(baglantiNoktasi.value);
    }
    if (aciklama.present) {
      map['aciklama'] = Variable<String>(aciklama.value);
    }
    if (durum.present) {
      map['durum'] = Variable<int>(durum.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('YaziciKayitlariCompanion(')
          ..write('id: $id, ')
          ..write('ad: $ad, ')
          ..write('rolEtiketi: $rolEtiketi, ')
          ..write('baglantiNoktasi: $baglantiNoktasi, ')
          ..write('aciklama: $aciklama, ')
          ..write('durum: $durum, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonelKayitlariTable extends PersonelKayitlari
    with TableInfo<$PersonelKayitlariTable, PersonelKayitlariData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonelKayitlariTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kimlikMeta = const VerificationMeta('kimlik');
  @override
  late final GeneratedColumn<String> kimlik = GeneratedColumn<String>(
    'kimlik',
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
  static const VerificationMeta _rolEtiketiMeta = const VerificationMeta(
    'rolEtiketi',
  );
  @override
  late final GeneratedColumn<String> rolEtiketi = GeneratedColumn<String>(
    'rol_etiketi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bolgeMeta = const VerificationMeta('bolge');
  @override
  late final GeneratedColumn<String> bolge = GeneratedColumn<String>(
    'bolge',
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
  static const VerificationMeta _durumMeta = const VerificationMeta('durum');
  @override
  late final GeneratedColumn<int> durum = GeneratedColumn<int>(
    'durum',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    kimlik,
    adSoyad,
    rolEtiketi,
    bolge,
    aciklama,
    durum,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personel_kayitlari';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonelKayitlariData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kimlik')) {
      context.handle(
        _kimlikMeta,
        kimlik.isAcceptableOrUnknown(data['kimlik']!, _kimlikMeta),
      );
    } else if (isInserting) {
      context.missing(_kimlikMeta);
    }
    if (data.containsKey('ad_soyad')) {
      context.handle(
        _adSoyadMeta,
        adSoyad.isAcceptableOrUnknown(data['ad_soyad']!, _adSoyadMeta),
      );
    } else if (isInserting) {
      context.missing(_adSoyadMeta);
    }
    if (data.containsKey('rol_etiketi')) {
      context.handle(
        _rolEtiketiMeta,
        rolEtiketi.isAcceptableOrUnknown(data['rol_etiketi']!, _rolEtiketiMeta),
      );
    } else if (isInserting) {
      context.missing(_rolEtiketiMeta);
    }
    if (data.containsKey('bolge')) {
      context.handle(
        _bolgeMeta,
        bolge.isAcceptableOrUnknown(data['bolge']!, _bolgeMeta),
      );
    } else if (isInserting) {
      context.missing(_bolgeMeta);
    }
    if (data.containsKey('aciklama')) {
      context.handle(
        _aciklamaMeta,
        aciklama.isAcceptableOrUnknown(data['aciklama']!, _aciklamaMeta),
      );
    } else if (isInserting) {
      context.missing(_aciklamaMeta);
    }
    if (data.containsKey('durum')) {
      context.handle(
        _durumMeta,
        durum.isAcceptableOrUnknown(data['durum']!, _durumMeta),
      );
    } else if (isInserting) {
      context.missing(_durumMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {kimlik};
  @override
  PersonelKayitlariData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonelKayitlariData(
      kimlik: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kimlik'],
      )!,
      adSoyad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ad_soyad'],
      )!,
      rolEtiketi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rol_etiketi'],
      )!,
      bolge: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bolge'],
      )!,
      aciklama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aciklama'],
      )!,
      durum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}durum'],
      )!,
    );
  }

  @override
  $PersonelKayitlariTable createAlias(String alias) {
    return $PersonelKayitlariTable(attachedDatabase, alias);
  }
}

class PersonelKayitlariData extends DataClass
    implements Insertable<PersonelKayitlariData> {
  final String kimlik;
  final String adSoyad;
  final String rolEtiketi;
  final String bolge;
  final String aciklama;
  final int durum;
  const PersonelKayitlariData({
    required this.kimlik,
    required this.adSoyad,
    required this.rolEtiketi,
    required this.bolge,
    required this.aciklama,
    required this.durum,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['kimlik'] = Variable<String>(kimlik);
    map['ad_soyad'] = Variable<String>(adSoyad);
    map['rol_etiketi'] = Variable<String>(rolEtiketi);
    map['bolge'] = Variable<String>(bolge);
    map['aciklama'] = Variable<String>(aciklama);
    map['durum'] = Variable<int>(durum);
    return map;
  }

  PersonelKayitlariCompanion toCompanion(bool nullToAbsent) {
    return PersonelKayitlariCompanion(
      kimlik: Value(kimlik),
      adSoyad: Value(adSoyad),
      rolEtiketi: Value(rolEtiketi),
      bolge: Value(bolge),
      aciklama: Value(aciklama),
      durum: Value(durum),
    );
  }

  factory PersonelKayitlariData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonelKayitlariData(
      kimlik: serializer.fromJson<String>(json['kimlik']),
      adSoyad: serializer.fromJson<String>(json['adSoyad']),
      rolEtiketi: serializer.fromJson<String>(json['rolEtiketi']),
      bolge: serializer.fromJson<String>(json['bolge']),
      aciklama: serializer.fromJson<String>(json['aciklama']),
      durum: serializer.fromJson<int>(json['durum']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'kimlik': serializer.toJson<String>(kimlik),
      'adSoyad': serializer.toJson<String>(adSoyad),
      'rolEtiketi': serializer.toJson<String>(rolEtiketi),
      'bolge': serializer.toJson<String>(bolge),
      'aciklama': serializer.toJson<String>(aciklama),
      'durum': serializer.toJson<int>(durum),
    };
  }

  PersonelKayitlariData copyWith({
    String? kimlik,
    String? adSoyad,
    String? rolEtiketi,
    String? bolge,
    String? aciklama,
    int? durum,
  }) => PersonelKayitlariData(
    kimlik: kimlik ?? this.kimlik,
    adSoyad: adSoyad ?? this.adSoyad,
    rolEtiketi: rolEtiketi ?? this.rolEtiketi,
    bolge: bolge ?? this.bolge,
    aciklama: aciklama ?? this.aciklama,
    durum: durum ?? this.durum,
  );
  PersonelKayitlariData copyWithCompanion(PersonelKayitlariCompanion data) {
    return PersonelKayitlariData(
      kimlik: data.kimlik.present ? data.kimlik.value : this.kimlik,
      adSoyad: data.adSoyad.present ? data.adSoyad.value : this.adSoyad,
      rolEtiketi: data.rolEtiketi.present
          ? data.rolEtiketi.value
          : this.rolEtiketi,
      bolge: data.bolge.present ? data.bolge.value : this.bolge,
      aciklama: data.aciklama.present ? data.aciklama.value : this.aciklama,
      durum: data.durum.present ? data.durum.value : this.durum,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonelKayitlariData(')
          ..write('kimlik: $kimlik, ')
          ..write('adSoyad: $adSoyad, ')
          ..write('rolEtiketi: $rolEtiketi, ')
          ..write('bolge: $bolge, ')
          ..write('aciklama: $aciklama, ')
          ..write('durum: $durum')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(kimlik, adSoyad, rolEtiketi, bolge, aciklama, durum);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonelKayitlariData &&
          other.kimlik == this.kimlik &&
          other.adSoyad == this.adSoyad &&
          other.rolEtiketi == this.rolEtiketi &&
          other.bolge == this.bolge &&
          other.aciklama == this.aciklama &&
          other.durum == this.durum);
}

class PersonelKayitlariCompanion
    extends UpdateCompanion<PersonelKayitlariData> {
  final Value<String> kimlik;
  final Value<String> adSoyad;
  final Value<String> rolEtiketi;
  final Value<String> bolge;
  final Value<String> aciklama;
  final Value<int> durum;
  final Value<int> rowid;
  const PersonelKayitlariCompanion({
    this.kimlik = const Value.absent(),
    this.adSoyad = const Value.absent(),
    this.rolEtiketi = const Value.absent(),
    this.bolge = const Value.absent(),
    this.aciklama = const Value.absent(),
    this.durum = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonelKayitlariCompanion.insert({
    required String kimlik,
    required String adSoyad,
    required String rolEtiketi,
    required String bolge,
    required String aciklama,
    required int durum,
    this.rowid = const Value.absent(),
  }) : kimlik = Value(kimlik),
       adSoyad = Value(adSoyad),
       rolEtiketi = Value(rolEtiketi),
       bolge = Value(bolge),
       aciklama = Value(aciklama),
       durum = Value(durum);
  static Insertable<PersonelKayitlariData> custom({
    Expression<String>? kimlik,
    Expression<String>? adSoyad,
    Expression<String>? rolEtiketi,
    Expression<String>? bolge,
    Expression<String>? aciklama,
    Expression<int>? durum,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (kimlik != null) 'kimlik': kimlik,
      if (adSoyad != null) 'ad_soyad': adSoyad,
      if (rolEtiketi != null) 'rol_etiketi': rolEtiketi,
      if (bolge != null) 'bolge': bolge,
      if (aciklama != null) 'aciklama': aciklama,
      if (durum != null) 'durum': durum,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonelKayitlariCompanion copyWith({
    Value<String>? kimlik,
    Value<String>? adSoyad,
    Value<String>? rolEtiketi,
    Value<String>? bolge,
    Value<String>? aciklama,
    Value<int>? durum,
    Value<int>? rowid,
  }) {
    return PersonelKayitlariCompanion(
      kimlik: kimlik ?? this.kimlik,
      adSoyad: adSoyad ?? this.adSoyad,
      rolEtiketi: rolEtiketi ?? this.rolEtiketi,
      bolge: bolge ?? this.bolge,
      aciklama: aciklama ?? this.aciklama,
      durum: durum ?? this.durum,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (kimlik.present) {
      map['kimlik'] = Variable<String>(kimlik.value);
    }
    if (adSoyad.present) {
      map['ad_soyad'] = Variable<String>(adSoyad.value);
    }
    if (rolEtiketi.present) {
      map['rol_etiketi'] = Variable<String>(rolEtiketi.value);
    }
    if (bolge.present) {
      map['bolge'] = Variable<String>(bolge.value);
    }
    if (aciklama.present) {
      map['aciklama'] = Variable<String>(aciklama.value);
    }
    if (durum.present) {
      map['durum'] = Variable<int>(durum.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonelKayitlariCompanion(')
          ..write('kimlik: $kimlik, ')
          ..write('adSoyad: $adSoyad, ')
          ..write('rolEtiketi: $rolEtiketi, ')
          ..write('bolge: $bolge, ')
          ..write('aciklama: $aciklama, ')
          ..write('durum: $durum, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalonBolumKayitlariTable extends SalonBolumKayitlari
    with TableInfo<$SalonBolumKayitlariTable, SalonBolumKayitlariData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalonBolumKayitlariTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, ad, aciklama];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'salon_bolum_kayitlari';
  @override
  VerificationContext validateIntegrity(
    Insertable<SalonBolumKayitlariData> instance, {
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
    if (data.containsKey('aciklama')) {
      context.handle(
        _aciklamaMeta,
        aciklama.isAcceptableOrUnknown(data['aciklama']!, _aciklamaMeta),
      );
    } else if (isInserting) {
      context.missing(_aciklamaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SalonBolumKayitlariData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalonBolumKayitlariData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ad'],
      )!,
      aciklama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aciklama'],
      )!,
    );
  }

  @override
  $SalonBolumKayitlariTable createAlias(String alias) {
    return $SalonBolumKayitlariTable(attachedDatabase, alias);
  }
}

class SalonBolumKayitlariData extends DataClass
    implements Insertable<SalonBolumKayitlariData> {
  final String id;
  final String ad;
  final String aciklama;
  const SalonBolumKayitlariData({
    required this.id,
    required this.ad,
    required this.aciklama,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ad'] = Variable<String>(ad);
    map['aciklama'] = Variable<String>(aciklama);
    return map;
  }

  SalonBolumKayitlariCompanion toCompanion(bool nullToAbsent) {
    return SalonBolumKayitlariCompanion(
      id: Value(id),
      ad: Value(ad),
      aciklama: Value(aciklama),
    );
  }

  factory SalonBolumKayitlariData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalonBolumKayitlariData(
      id: serializer.fromJson<String>(json['id']),
      ad: serializer.fromJson<String>(json['ad']),
      aciklama: serializer.fromJson<String>(json['aciklama']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ad': serializer.toJson<String>(ad),
      'aciklama': serializer.toJson<String>(aciklama),
    };
  }

  SalonBolumKayitlariData copyWith({
    String? id,
    String? ad,
    String? aciklama,
  }) => SalonBolumKayitlariData(
    id: id ?? this.id,
    ad: ad ?? this.ad,
    aciklama: aciklama ?? this.aciklama,
  );
  SalonBolumKayitlariData copyWithCompanion(SalonBolumKayitlariCompanion data) {
    return SalonBolumKayitlariData(
      id: data.id.present ? data.id.value : this.id,
      ad: data.ad.present ? data.ad.value : this.ad,
      aciklama: data.aciklama.present ? data.aciklama.value : this.aciklama,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalonBolumKayitlariData(')
          ..write('id: $id, ')
          ..write('ad: $ad, ')
          ..write('aciklama: $aciklama')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ad, aciklama);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalonBolumKayitlariData &&
          other.id == this.id &&
          other.ad == this.ad &&
          other.aciklama == this.aciklama);
}

class SalonBolumKayitlariCompanion
    extends UpdateCompanion<SalonBolumKayitlariData> {
  final Value<String> id;
  final Value<String> ad;
  final Value<String> aciklama;
  final Value<int> rowid;
  const SalonBolumKayitlariCompanion({
    this.id = const Value.absent(),
    this.ad = const Value.absent(),
    this.aciklama = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalonBolumKayitlariCompanion.insert({
    required String id,
    required String ad,
    required String aciklama,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ad = Value(ad),
       aciklama = Value(aciklama);
  static Insertable<SalonBolumKayitlariData> custom({
    Expression<String>? id,
    Expression<String>? ad,
    Expression<String>? aciklama,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ad != null) 'ad': ad,
      if (aciklama != null) 'aciklama': aciklama,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalonBolumKayitlariCompanion copyWith({
    Value<String>? id,
    Value<String>? ad,
    Value<String>? aciklama,
    Value<int>? rowid,
  }) {
    return SalonBolumKayitlariCompanion(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      aciklama: aciklama ?? this.aciklama,
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
    if (aciklama.present) {
      map['aciklama'] = Variable<String>(aciklama.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalonBolumKayitlariCompanion(')
          ..write('id: $id, ')
          ..write('ad: $ad, ')
          ..write('aciklama: $aciklama, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MasaKayitlariTable extends MasaKayitlari
    with TableInfo<$MasaKayitlariTable, MasaKayitlariData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MasaKayitlariTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bolumIdMeta = const VerificationMeta(
    'bolumId',
  );
  @override
  late final GeneratedColumn<String> bolumId = GeneratedColumn<String>(
    'bolum_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES salon_bolum_kayitlari (id) ON DELETE CASCADE',
    ),
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
  static const VerificationMeta _kapasiteMeta = const VerificationMeta(
    'kapasite',
  );
  @override
  late final GeneratedColumn<int> kapasite = GeneratedColumn<int>(
    'kapasite',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, bolumId, ad, kapasite];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'masa_kayitlari';
  @override
  VerificationContext validateIntegrity(
    Insertable<MasaKayitlariData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bolum_id')) {
      context.handle(
        _bolumIdMeta,
        bolumId.isAcceptableOrUnknown(data['bolum_id']!, _bolumIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bolumIdMeta);
    }
    if (data.containsKey('ad')) {
      context.handle(_adMeta, ad.isAcceptableOrUnknown(data['ad']!, _adMeta));
    } else if (isInserting) {
      context.missing(_adMeta);
    }
    if (data.containsKey('kapasite')) {
      context.handle(
        _kapasiteMeta,
        kapasite.isAcceptableOrUnknown(data['kapasite']!, _kapasiteMeta),
      );
    } else if (isInserting) {
      context.missing(_kapasiteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MasaKayitlariData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MasaKayitlariData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bolumId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bolum_id'],
      )!,
      ad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ad'],
      )!,
      kapasite: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kapasite'],
      )!,
    );
  }

  @override
  $MasaKayitlariTable createAlias(String alias) {
    return $MasaKayitlariTable(attachedDatabase, alias);
  }
}

class MasaKayitlariData extends DataClass
    implements Insertable<MasaKayitlariData> {
  final String id;
  final String bolumId;
  final String ad;
  final int kapasite;
  const MasaKayitlariData({
    required this.id,
    required this.bolumId,
    required this.ad,
    required this.kapasite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bolum_id'] = Variable<String>(bolumId);
    map['ad'] = Variable<String>(ad);
    map['kapasite'] = Variable<int>(kapasite);
    return map;
  }

  MasaKayitlariCompanion toCompanion(bool nullToAbsent) {
    return MasaKayitlariCompanion(
      id: Value(id),
      bolumId: Value(bolumId),
      ad: Value(ad),
      kapasite: Value(kapasite),
    );
  }

  factory MasaKayitlariData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MasaKayitlariData(
      id: serializer.fromJson<String>(json['id']),
      bolumId: serializer.fromJson<String>(json['bolumId']),
      ad: serializer.fromJson<String>(json['ad']),
      kapasite: serializer.fromJson<int>(json['kapasite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bolumId': serializer.toJson<String>(bolumId),
      'ad': serializer.toJson<String>(ad),
      'kapasite': serializer.toJson<int>(kapasite),
    };
  }

  MasaKayitlariData copyWith({
    String? id,
    String? bolumId,
    String? ad,
    int? kapasite,
  }) => MasaKayitlariData(
    id: id ?? this.id,
    bolumId: bolumId ?? this.bolumId,
    ad: ad ?? this.ad,
    kapasite: kapasite ?? this.kapasite,
  );
  MasaKayitlariData copyWithCompanion(MasaKayitlariCompanion data) {
    return MasaKayitlariData(
      id: data.id.present ? data.id.value : this.id,
      bolumId: data.bolumId.present ? data.bolumId.value : this.bolumId,
      ad: data.ad.present ? data.ad.value : this.ad,
      kapasite: data.kapasite.present ? data.kapasite.value : this.kapasite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MasaKayitlariData(')
          ..write('id: $id, ')
          ..write('bolumId: $bolumId, ')
          ..write('ad: $ad, ')
          ..write('kapasite: $kapasite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bolumId, ad, kapasite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MasaKayitlariData &&
          other.id == this.id &&
          other.bolumId == this.bolumId &&
          other.ad == this.ad &&
          other.kapasite == this.kapasite);
}

class MasaKayitlariCompanion extends UpdateCompanion<MasaKayitlariData> {
  final Value<String> id;
  final Value<String> bolumId;
  final Value<String> ad;
  final Value<int> kapasite;
  final Value<int> rowid;
  const MasaKayitlariCompanion({
    this.id = const Value.absent(),
    this.bolumId = const Value.absent(),
    this.ad = const Value.absent(),
    this.kapasite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MasaKayitlariCompanion.insert({
    required String id,
    required String bolumId,
    required String ad,
    required int kapasite,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bolumId = Value(bolumId),
       ad = Value(ad),
       kapasite = Value(kapasite);
  static Insertable<MasaKayitlariData> custom({
    Expression<String>? id,
    Expression<String>? bolumId,
    Expression<String>? ad,
    Expression<int>? kapasite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bolumId != null) 'bolum_id': bolumId,
      if (ad != null) 'ad': ad,
      if (kapasite != null) 'kapasite': kapasite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MasaKayitlariCompanion copyWith({
    Value<String>? id,
    Value<String>? bolumId,
    Value<String>? ad,
    Value<int>? kapasite,
    Value<int>? rowid,
  }) {
    return MasaKayitlariCompanion(
      id: id ?? this.id,
      bolumId: bolumId ?? this.bolumId,
      ad: ad ?? this.ad,
      kapasite: kapasite ?? this.kapasite,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bolumId.present) {
      map['bolum_id'] = Variable<String>(bolumId.value);
    }
    if (ad.present) {
      map['ad'] = Variable<String>(ad.value);
    }
    if (kapasite.present) {
      map['kapasite'] = Variable<int>(kapasite.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MasaKayitlariCompanion(')
          ..write('id: $id, ')
          ..write('bolumId: $bolumId, ')
          ..write('ad: $ad, ')
          ..write('kapasite: $kapasite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HammaddeKayitlariTable extends HammaddeKayitlari
    with TableInfo<$HammaddeKayitlariTable, HammaddeKayitlariData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HammaddeKayitlariTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _birimMeta = const VerificationMeta('birim');
  @override
  late final GeneratedColumn<String> birim = GeneratedColumn<String>(
    'birim',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mevcutMiktarMeta = const VerificationMeta(
    'mevcutMiktar',
  );
  @override
  late final GeneratedColumn<double> mevcutMiktar = GeneratedColumn<double>(
    'mevcut_miktar',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uyariEsigiMeta = const VerificationMeta(
    'uyariEsigi',
  );
  @override
  late final GeneratedColumn<double> uyariEsigi = GeneratedColumn<double>(
    'uyari_esigi',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _kritikEsikMeta = const VerificationMeta(
    'kritikEsik',
  );
  @override
  late final GeneratedColumn<double> kritikEsik = GeneratedColumn<double>(
    'kritik_esik',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birimMaliyetMeta = const VerificationMeta(
    'birimMaliyet',
  );
  @override
  late final GeneratedColumn<double> birimMaliyet = GeneratedColumn<double>(
    'birim_maliyet',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ad,
    birim,
    mevcutMiktar,
    uyariEsigi,
    kritikEsik,
    birimMaliyet,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hammadde_kayitlari';
  @override
  VerificationContext validateIntegrity(
    Insertable<HammaddeKayitlariData> instance, {
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
    if (data.containsKey('birim')) {
      context.handle(
        _birimMeta,
        birim.isAcceptableOrUnknown(data['birim']!, _birimMeta),
      );
    } else if (isInserting) {
      context.missing(_birimMeta);
    }
    if (data.containsKey('mevcut_miktar')) {
      context.handle(
        _mevcutMiktarMeta,
        mevcutMiktar.isAcceptableOrUnknown(
          data['mevcut_miktar']!,
          _mevcutMiktarMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mevcutMiktarMeta);
    }
    if (data.containsKey('uyari_esigi')) {
      context.handle(
        _uyariEsigiMeta,
        uyariEsigi.isAcceptableOrUnknown(data['uyari_esigi']!, _uyariEsigiMeta),
      );
    }
    if (data.containsKey('kritik_esik')) {
      context.handle(
        _kritikEsikMeta,
        kritikEsik.isAcceptableOrUnknown(data['kritik_esik']!, _kritikEsikMeta),
      );
    } else if (isInserting) {
      context.missing(_kritikEsikMeta);
    }
    if (data.containsKey('birim_maliyet')) {
      context.handle(
        _birimMaliyetMeta,
        birimMaliyet.isAcceptableOrUnknown(
          data['birim_maliyet']!,
          _birimMaliyetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_birimMaliyetMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HammaddeKayitlariData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HammaddeKayitlariData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ad'],
      )!,
      birim: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birim'],
      )!,
      mevcutMiktar: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mevcut_miktar'],
      )!,
      uyariEsigi: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}uyari_esigi'],
      )!,
      kritikEsik: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kritik_esik'],
      )!,
      birimMaliyet: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birim_maliyet'],
      )!,
    );
  }

  @override
  $HammaddeKayitlariTable createAlias(String alias) {
    return $HammaddeKayitlariTable(attachedDatabase, alias);
  }
}

class HammaddeKayitlariData extends DataClass
    implements Insertable<HammaddeKayitlariData> {
  final String id;
  final String ad;
  final String birim;
  final double mevcutMiktar;
  final double uyariEsigi;
  final double kritikEsik;
  final double birimMaliyet;
  const HammaddeKayitlariData({
    required this.id,
    required this.ad,
    required this.birim,
    required this.mevcutMiktar,
    required this.uyariEsigi,
    required this.kritikEsik,
    required this.birimMaliyet,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ad'] = Variable<String>(ad);
    map['birim'] = Variable<String>(birim);
    map['mevcut_miktar'] = Variable<double>(mevcutMiktar);
    map['uyari_esigi'] = Variable<double>(uyariEsigi);
    map['kritik_esik'] = Variable<double>(kritikEsik);
    map['birim_maliyet'] = Variable<double>(birimMaliyet);
    return map;
  }

  HammaddeKayitlariCompanion toCompanion(bool nullToAbsent) {
    return HammaddeKayitlariCompanion(
      id: Value(id),
      ad: Value(ad),
      birim: Value(birim),
      mevcutMiktar: Value(mevcutMiktar),
      uyariEsigi: Value(uyariEsigi),
      kritikEsik: Value(kritikEsik),
      birimMaliyet: Value(birimMaliyet),
    );
  }

  factory HammaddeKayitlariData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HammaddeKayitlariData(
      id: serializer.fromJson<String>(json['id']),
      ad: serializer.fromJson<String>(json['ad']),
      birim: serializer.fromJson<String>(json['birim']),
      mevcutMiktar: serializer.fromJson<double>(json['mevcutMiktar']),
      uyariEsigi: serializer.fromJson<double>(json['uyariEsigi']),
      kritikEsik: serializer.fromJson<double>(json['kritikEsik']),
      birimMaliyet: serializer.fromJson<double>(json['birimMaliyet']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ad': serializer.toJson<String>(ad),
      'birim': serializer.toJson<String>(birim),
      'mevcutMiktar': serializer.toJson<double>(mevcutMiktar),
      'uyariEsigi': serializer.toJson<double>(uyariEsigi),
      'kritikEsik': serializer.toJson<double>(kritikEsik),
      'birimMaliyet': serializer.toJson<double>(birimMaliyet),
    };
  }

  HammaddeKayitlariData copyWith({
    String? id,
    String? ad,
    String? birim,
    double? mevcutMiktar,
    double? uyariEsigi,
    double? kritikEsik,
    double? birimMaliyet,
  }) => HammaddeKayitlariData(
    id: id ?? this.id,
    ad: ad ?? this.ad,
    birim: birim ?? this.birim,
    mevcutMiktar: mevcutMiktar ?? this.mevcutMiktar,
    uyariEsigi: uyariEsigi ?? this.uyariEsigi,
    kritikEsik: kritikEsik ?? this.kritikEsik,
    birimMaliyet: birimMaliyet ?? this.birimMaliyet,
  );
  HammaddeKayitlariData copyWithCompanion(HammaddeKayitlariCompanion data) {
    return HammaddeKayitlariData(
      id: data.id.present ? data.id.value : this.id,
      ad: data.ad.present ? data.ad.value : this.ad,
      birim: data.birim.present ? data.birim.value : this.birim,
      mevcutMiktar: data.mevcutMiktar.present
          ? data.mevcutMiktar.value
          : this.mevcutMiktar,
      uyariEsigi: data.uyariEsigi.present
          ? data.uyariEsigi.value
          : this.uyariEsigi,
      kritikEsik: data.kritikEsik.present
          ? data.kritikEsik.value
          : this.kritikEsik,
      birimMaliyet: data.birimMaliyet.present
          ? data.birimMaliyet.value
          : this.birimMaliyet,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HammaddeKayitlariData(')
          ..write('id: $id, ')
          ..write('ad: $ad, ')
          ..write('birim: $birim, ')
          ..write('mevcutMiktar: $mevcutMiktar, ')
          ..write('uyariEsigi: $uyariEsigi, ')
          ..write('kritikEsik: $kritikEsik, ')
          ..write('birimMaliyet: $birimMaliyet')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ad,
    birim,
    mevcutMiktar,
    uyariEsigi,
    kritikEsik,
    birimMaliyet,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HammaddeKayitlariData &&
          other.id == this.id &&
          other.ad == this.ad &&
          other.birim == this.birim &&
          other.mevcutMiktar == this.mevcutMiktar &&
          other.uyariEsigi == this.uyariEsigi &&
          other.kritikEsik == this.kritikEsik &&
          other.birimMaliyet == this.birimMaliyet);
}

class HammaddeKayitlariCompanion
    extends UpdateCompanion<HammaddeKayitlariData> {
  final Value<String> id;
  final Value<String> ad;
  final Value<String> birim;
  final Value<double> mevcutMiktar;
  final Value<double> uyariEsigi;
  final Value<double> kritikEsik;
  final Value<double> birimMaliyet;
  final Value<int> rowid;
  const HammaddeKayitlariCompanion({
    this.id = const Value.absent(),
    this.ad = const Value.absent(),
    this.birim = const Value.absent(),
    this.mevcutMiktar = const Value.absent(),
    this.uyariEsigi = const Value.absent(),
    this.kritikEsik = const Value.absent(),
    this.birimMaliyet = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HammaddeKayitlariCompanion.insert({
    required String id,
    required String ad,
    required String birim,
    required double mevcutMiktar,
    this.uyariEsigi = const Value.absent(),
    required double kritikEsik,
    required double birimMaliyet,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ad = Value(ad),
       birim = Value(birim),
       mevcutMiktar = Value(mevcutMiktar),
       kritikEsik = Value(kritikEsik),
       birimMaliyet = Value(birimMaliyet);
  static Insertable<HammaddeKayitlariData> custom({
    Expression<String>? id,
    Expression<String>? ad,
    Expression<String>? birim,
    Expression<double>? mevcutMiktar,
    Expression<double>? uyariEsigi,
    Expression<double>? kritikEsik,
    Expression<double>? birimMaliyet,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ad != null) 'ad': ad,
      if (birim != null) 'birim': birim,
      if (mevcutMiktar != null) 'mevcut_miktar': mevcutMiktar,
      if (uyariEsigi != null) 'uyari_esigi': uyariEsigi,
      if (kritikEsik != null) 'kritik_esik': kritikEsik,
      if (birimMaliyet != null) 'birim_maliyet': birimMaliyet,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HammaddeKayitlariCompanion copyWith({
    Value<String>? id,
    Value<String>? ad,
    Value<String>? birim,
    Value<double>? mevcutMiktar,
    Value<double>? uyariEsigi,
    Value<double>? kritikEsik,
    Value<double>? birimMaliyet,
    Value<int>? rowid,
  }) {
    return HammaddeKayitlariCompanion(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      birim: birim ?? this.birim,
      mevcutMiktar: mevcutMiktar ?? this.mevcutMiktar,
      uyariEsigi: uyariEsigi ?? this.uyariEsigi,
      kritikEsik: kritikEsik ?? this.kritikEsik,
      birimMaliyet: birimMaliyet ?? this.birimMaliyet,
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
    if (birim.present) {
      map['birim'] = Variable<String>(birim.value);
    }
    if (mevcutMiktar.present) {
      map['mevcut_miktar'] = Variable<double>(mevcutMiktar.value);
    }
    if (uyariEsigi.present) {
      map['uyari_esigi'] = Variable<double>(uyariEsigi.value);
    }
    if (kritikEsik.present) {
      map['kritik_esik'] = Variable<double>(kritikEsik.value);
    }
    if (birimMaliyet.present) {
      map['birim_maliyet'] = Variable<double>(birimMaliyet.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HammaddeKayitlariCompanion(')
          ..write('id: $id, ')
          ..write('ad: $ad, ')
          ..write('birim: $birim, ')
          ..write('mevcutMiktar: $mevcutMiktar, ')
          ..write('uyariEsigi: $uyariEsigi, ')
          ..write('kritikEsik: $kritikEsik, ')
          ..write('birimMaliyet: $birimMaliyet, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StokAlarmGecmisKayitlariTable extends StokAlarmGecmisKayitlari
    with
        TableInfo<
          $StokAlarmGecmisKayitlariTable,
          StokAlarmGecmisKayitlariData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StokAlarmGecmisKayitlariTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zamanMeta = const VerificationMeta('zaman');
  @override
  late final GeneratedColumn<DateTime> zaman = GeneratedColumn<DateTime>(
    'zaman',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hammaddeIdMeta = const VerificationMeta(
    'hammaddeId',
  );
  @override
  late final GeneratedColumn<String> hammaddeId = GeneratedColumn<String>(
    'hammadde_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hammaddeAdiMeta = const VerificationMeta(
    'hammaddeAdi',
  );
  @override
  late final GeneratedColumn<String> hammaddeAdi = GeneratedColumn<String>(
    'hammadde_adi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _oncekiMiktarMeta = const VerificationMeta(
    'oncekiMiktar',
  );
  @override
  late final GeneratedColumn<double> oncekiMiktar = GeneratedColumn<double>(
    'onceki_miktar',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yeniMiktarMeta = const VerificationMeta(
    'yeniMiktar',
  );
  @override
  late final GeneratedColumn<double> yeniMiktar = GeneratedColumn<double>(
    'yeni_miktar',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _oncekiDurumMeta = const VerificationMeta(
    'oncekiDurum',
  );
  @override
  late final GeneratedColumn<int> oncekiDurum = GeneratedColumn<int>(
    'onceki_durum',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yeniDurumMeta = const VerificationMeta(
    'yeniDurum',
  );
  @override
  late final GeneratedColumn<int> yeniDurum = GeneratedColumn<int>(
    'yeni_durum',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tetikleyenIslemMeta = const VerificationMeta(
    'tetikleyenIslem',
  );
  @override
  late final GeneratedColumn<String> tetikleyenIslem = GeneratedColumn<String>(
    'tetikleyen_islem',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    zaman,
    hammaddeId,
    hammaddeAdi,
    oncekiMiktar,
    yeniMiktar,
    oncekiDurum,
    yeniDurum,
    tetikleyenIslem,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stok_alarm_gecmis_kayitlari';
  @override
  VerificationContext validateIntegrity(
    Insertable<StokAlarmGecmisKayitlariData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('zaman')) {
      context.handle(
        _zamanMeta,
        zaman.isAcceptableOrUnknown(data['zaman']!, _zamanMeta),
      );
    } else if (isInserting) {
      context.missing(_zamanMeta);
    }
    if (data.containsKey('hammadde_id')) {
      context.handle(
        _hammaddeIdMeta,
        hammaddeId.isAcceptableOrUnknown(data['hammadde_id']!, _hammaddeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hammaddeIdMeta);
    }
    if (data.containsKey('hammadde_adi')) {
      context.handle(
        _hammaddeAdiMeta,
        hammaddeAdi.isAcceptableOrUnknown(
          data['hammadde_adi']!,
          _hammaddeAdiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hammaddeAdiMeta);
    }
    if (data.containsKey('onceki_miktar')) {
      context.handle(
        _oncekiMiktarMeta,
        oncekiMiktar.isAcceptableOrUnknown(
          data['onceki_miktar']!,
          _oncekiMiktarMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_oncekiMiktarMeta);
    }
    if (data.containsKey('yeni_miktar')) {
      context.handle(
        _yeniMiktarMeta,
        yeniMiktar.isAcceptableOrUnknown(data['yeni_miktar']!, _yeniMiktarMeta),
      );
    } else if (isInserting) {
      context.missing(_yeniMiktarMeta);
    }
    if (data.containsKey('onceki_durum')) {
      context.handle(
        _oncekiDurumMeta,
        oncekiDurum.isAcceptableOrUnknown(
          data['onceki_durum']!,
          _oncekiDurumMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_oncekiDurumMeta);
    }
    if (data.containsKey('yeni_durum')) {
      context.handle(
        _yeniDurumMeta,
        yeniDurum.isAcceptableOrUnknown(data['yeni_durum']!, _yeniDurumMeta),
      );
    } else if (isInserting) {
      context.missing(_yeniDurumMeta);
    }
    if (data.containsKey('tetikleyen_islem')) {
      context.handle(
        _tetikleyenIslemMeta,
        tetikleyenIslem.isAcceptableOrUnknown(
          data['tetikleyen_islem']!,
          _tetikleyenIslemMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tetikleyenIslemMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StokAlarmGecmisKayitlariData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StokAlarmGecmisKayitlariData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      zaman: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}zaman'],
      )!,
      hammaddeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hammadde_id'],
      )!,
      hammaddeAdi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hammadde_adi'],
      )!,
      oncekiMiktar: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}onceki_miktar'],
      )!,
      yeniMiktar: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}yeni_miktar'],
      )!,
      oncekiDurum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}onceki_durum'],
      )!,
      yeniDurum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}yeni_durum'],
      )!,
      tetikleyenIslem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tetikleyen_islem'],
      )!,
    );
  }

  @override
  $StokAlarmGecmisKayitlariTable createAlias(String alias) {
    return $StokAlarmGecmisKayitlariTable(attachedDatabase, alias);
  }
}

class StokAlarmGecmisKayitlariData extends DataClass
    implements Insertable<StokAlarmGecmisKayitlariData> {
  final String id;
  final DateTime zaman;
  final String hammaddeId;
  final String hammaddeAdi;
  final double oncekiMiktar;
  final double yeniMiktar;
  final int oncekiDurum;
  final int yeniDurum;
  final String tetikleyenIslem;
  const StokAlarmGecmisKayitlariData({
    required this.id,
    required this.zaman,
    required this.hammaddeId,
    required this.hammaddeAdi,
    required this.oncekiMiktar,
    required this.yeniMiktar,
    required this.oncekiDurum,
    required this.yeniDurum,
    required this.tetikleyenIslem,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['zaman'] = Variable<DateTime>(zaman);
    map['hammadde_id'] = Variable<String>(hammaddeId);
    map['hammadde_adi'] = Variable<String>(hammaddeAdi);
    map['onceki_miktar'] = Variable<double>(oncekiMiktar);
    map['yeni_miktar'] = Variable<double>(yeniMiktar);
    map['onceki_durum'] = Variable<int>(oncekiDurum);
    map['yeni_durum'] = Variable<int>(yeniDurum);
    map['tetikleyen_islem'] = Variable<String>(tetikleyenIslem);
    return map;
  }

  StokAlarmGecmisKayitlariCompanion toCompanion(bool nullToAbsent) {
    return StokAlarmGecmisKayitlariCompanion(
      id: Value(id),
      zaman: Value(zaman),
      hammaddeId: Value(hammaddeId),
      hammaddeAdi: Value(hammaddeAdi),
      oncekiMiktar: Value(oncekiMiktar),
      yeniMiktar: Value(yeniMiktar),
      oncekiDurum: Value(oncekiDurum),
      yeniDurum: Value(yeniDurum),
      tetikleyenIslem: Value(tetikleyenIslem),
    );
  }

  factory StokAlarmGecmisKayitlariData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StokAlarmGecmisKayitlariData(
      id: serializer.fromJson<String>(json['id']),
      zaman: serializer.fromJson<DateTime>(json['zaman']),
      hammaddeId: serializer.fromJson<String>(json['hammaddeId']),
      hammaddeAdi: serializer.fromJson<String>(json['hammaddeAdi']),
      oncekiMiktar: serializer.fromJson<double>(json['oncekiMiktar']),
      yeniMiktar: serializer.fromJson<double>(json['yeniMiktar']),
      oncekiDurum: serializer.fromJson<int>(json['oncekiDurum']),
      yeniDurum: serializer.fromJson<int>(json['yeniDurum']),
      tetikleyenIslem: serializer.fromJson<String>(json['tetikleyenIslem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'zaman': serializer.toJson<DateTime>(zaman),
      'hammaddeId': serializer.toJson<String>(hammaddeId),
      'hammaddeAdi': serializer.toJson<String>(hammaddeAdi),
      'oncekiMiktar': serializer.toJson<double>(oncekiMiktar),
      'yeniMiktar': serializer.toJson<double>(yeniMiktar),
      'oncekiDurum': serializer.toJson<int>(oncekiDurum),
      'yeniDurum': serializer.toJson<int>(yeniDurum),
      'tetikleyenIslem': serializer.toJson<String>(tetikleyenIslem),
    };
  }

  StokAlarmGecmisKayitlariData copyWith({
    String? id,
    DateTime? zaman,
    String? hammaddeId,
    String? hammaddeAdi,
    double? oncekiMiktar,
    double? yeniMiktar,
    int? oncekiDurum,
    int? yeniDurum,
    String? tetikleyenIslem,
  }) => StokAlarmGecmisKayitlariData(
    id: id ?? this.id,
    zaman: zaman ?? this.zaman,
    hammaddeId: hammaddeId ?? this.hammaddeId,
    hammaddeAdi: hammaddeAdi ?? this.hammaddeAdi,
    oncekiMiktar: oncekiMiktar ?? this.oncekiMiktar,
    yeniMiktar: yeniMiktar ?? this.yeniMiktar,
    oncekiDurum: oncekiDurum ?? this.oncekiDurum,
    yeniDurum: yeniDurum ?? this.yeniDurum,
    tetikleyenIslem: tetikleyenIslem ?? this.tetikleyenIslem,
  );
  StokAlarmGecmisKayitlariData copyWithCompanion(
    StokAlarmGecmisKayitlariCompanion data,
  ) {
    return StokAlarmGecmisKayitlariData(
      id: data.id.present ? data.id.value : this.id,
      zaman: data.zaman.present ? data.zaman.value : this.zaman,
      hammaddeId: data.hammaddeId.present
          ? data.hammaddeId.value
          : this.hammaddeId,
      hammaddeAdi: data.hammaddeAdi.present
          ? data.hammaddeAdi.value
          : this.hammaddeAdi,
      oncekiMiktar: data.oncekiMiktar.present
          ? data.oncekiMiktar.value
          : this.oncekiMiktar,
      yeniMiktar: data.yeniMiktar.present
          ? data.yeniMiktar.value
          : this.yeniMiktar,
      oncekiDurum: data.oncekiDurum.present
          ? data.oncekiDurum.value
          : this.oncekiDurum,
      yeniDurum: data.yeniDurum.present ? data.yeniDurum.value : this.yeniDurum,
      tetikleyenIslem: data.tetikleyenIslem.present
          ? data.tetikleyenIslem.value
          : this.tetikleyenIslem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StokAlarmGecmisKayitlariData(')
          ..write('id: $id, ')
          ..write('zaman: $zaman, ')
          ..write('hammaddeId: $hammaddeId, ')
          ..write('hammaddeAdi: $hammaddeAdi, ')
          ..write('oncekiMiktar: $oncekiMiktar, ')
          ..write('yeniMiktar: $yeniMiktar, ')
          ..write('oncekiDurum: $oncekiDurum, ')
          ..write('yeniDurum: $yeniDurum, ')
          ..write('tetikleyenIslem: $tetikleyenIslem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    zaman,
    hammaddeId,
    hammaddeAdi,
    oncekiMiktar,
    yeniMiktar,
    oncekiDurum,
    yeniDurum,
    tetikleyenIslem,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StokAlarmGecmisKayitlariData &&
          other.id == this.id &&
          other.zaman == this.zaman &&
          other.hammaddeId == this.hammaddeId &&
          other.hammaddeAdi == this.hammaddeAdi &&
          other.oncekiMiktar == this.oncekiMiktar &&
          other.yeniMiktar == this.yeniMiktar &&
          other.oncekiDurum == this.oncekiDurum &&
          other.yeniDurum == this.yeniDurum &&
          other.tetikleyenIslem == this.tetikleyenIslem);
}

class StokAlarmGecmisKayitlariCompanion
    extends UpdateCompanion<StokAlarmGecmisKayitlariData> {
  final Value<String> id;
  final Value<DateTime> zaman;
  final Value<String> hammaddeId;
  final Value<String> hammaddeAdi;
  final Value<double> oncekiMiktar;
  final Value<double> yeniMiktar;
  final Value<int> oncekiDurum;
  final Value<int> yeniDurum;
  final Value<String> tetikleyenIslem;
  final Value<int> rowid;
  const StokAlarmGecmisKayitlariCompanion({
    this.id = const Value.absent(),
    this.zaman = const Value.absent(),
    this.hammaddeId = const Value.absent(),
    this.hammaddeAdi = const Value.absent(),
    this.oncekiMiktar = const Value.absent(),
    this.yeniMiktar = const Value.absent(),
    this.oncekiDurum = const Value.absent(),
    this.yeniDurum = const Value.absent(),
    this.tetikleyenIslem = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StokAlarmGecmisKayitlariCompanion.insert({
    required String id,
    required DateTime zaman,
    required String hammaddeId,
    required String hammaddeAdi,
    required double oncekiMiktar,
    required double yeniMiktar,
    required int oncekiDurum,
    required int yeniDurum,
    required String tetikleyenIslem,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       zaman = Value(zaman),
       hammaddeId = Value(hammaddeId),
       hammaddeAdi = Value(hammaddeAdi),
       oncekiMiktar = Value(oncekiMiktar),
       yeniMiktar = Value(yeniMiktar),
       oncekiDurum = Value(oncekiDurum),
       yeniDurum = Value(yeniDurum),
       tetikleyenIslem = Value(tetikleyenIslem);
  static Insertable<StokAlarmGecmisKayitlariData> custom({
    Expression<String>? id,
    Expression<DateTime>? zaman,
    Expression<String>? hammaddeId,
    Expression<String>? hammaddeAdi,
    Expression<double>? oncekiMiktar,
    Expression<double>? yeniMiktar,
    Expression<int>? oncekiDurum,
    Expression<int>? yeniDurum,
    Expression<String>? tetikleyenIslem,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (zaman != null) 'zaman': zaman,
      if (hammaddeId != null) 'hammadde_id': hammaddeId,
      if (hammaddeAdi != null) 'hammadde_adi': hammaddeAdi,
      if (oncekiMiktar != null) 'onceki_miktar': oncekiMiktar,
      if (yeniMiktar != null) 'yeni_miktar': yeniMiktar,
      if (oncekiDurum != null) 'onceki_durum': oncekiDurum,
      if (yeniDurum != null) 'yeni_durum': yeniDurum,
      if (tetikleyenIslem != null) 'tetikleyen_islem': tetikleyenIslem,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StokAlarmGecmisKayitlariCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? zaman,
    Value<String>? hammaddeId,
    Value<String>? hammaddeAdi,
    Value<double>? oncekiMiktar,
    Value<double>? yeniMiktar,
    Value<int>? oncekiDurum,
    Value<int>? yeniDurum,
    Value<String>? tetikleyenIslem,
    Value<int>? rowid,
  }) {
    return StokAlarmGecmisKayitlariCompanion(
      id: id ?? this.id,
      zaman: zaman ?? this.zaman,
      hammaddeId: hammaddeId ?? this.hammaddeId,
      hammaddeAdi: hammaddeAdi ?? this.hammaddeAdi,
      oncekiMiktar: oncekiMiktar ?? this.oncekiMiktar,
      yeniMiktar: yeniMiktar ?? this.yeniMiktar,
      oncekiDurum: oncekiDurum ?? this.oncekiDurum,
      yeniDurum: yeniDurum ?? this.yeniDurum,
      tetikleyenIslem: tetikleyenIslem ?? this.tetikleyenIslem,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (zaman.present) {
      map['zaman'] = Variable<DateTime>(zaman.value);
    }
    if (hammaddeId.present) {
      map['hammadde_id'] = Variable<String>(hammaddeId.value);
    }
    if (hammaddeAdi.present) {
      map['hammadde_adi'] = Variable<String>(hammaddeAdi.value);
    }
    if (oncekiMiktar.present) {
      map['onceki_miktar'] = Variable<double>(oncekiMiktar.value);
    }
    if (yeniMiktar.present) {
      map['yeni_miktar'] = Variable<double>(yeniMiktar.value);
    }
    if (oncekiDurum.present) {
      map['onceki_durum'] = Variable<int>(oncekiDurum.value);
    }
    if (yeniDurum.present) {
      map['yeni_durum'] = Variable<int>(yeniDurum.value);
    }
    if (tetikleyenIslem.present) {
      map['tetikleyen_islem'] = Variable<String>(tetikleyenIslem.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StokAlarmGecmisKayitlariCompanion(')
          ..write('id: $id, ')
          ..write('zaman: $zaman, ')
          ..write('hammaddeId: $hammaddeId, ')
          ..write('hammaddeAdi: $hammaddeAdi, ')
          ..write('oncekiMiktar: $oncekiMiktar, ')
          ..write('yeniMiktar: $yeniMiktar, ')
          ..write('oncekiDurum: $oncekiDurum, ')
          ..write('yeniDurum: $yeniDurum, ')
          ..write('tetikleyenIslem: $tetikleyenIslem, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReceteKalemKayitlariTable extends ReceteKalemKayitlari
    with TableInfo<$ReceteKalemKayitlariTable, ReceteKalemKayitlariData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceteKalemKayitlariTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _urunIdMeta = const VerificationMeta('urunId');
  @override
  late final GeneratedColumn<String> urunId = GeneratedColumn<String>(
    'urun_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES urun_kayitlari (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _hammaddeIdMeta = const VerificationMeta(
    'hammaddeId',
  );
  @override
  late final GeneratedColumn<String> hammaddeId = GeneratedColumn<String>(
    'hammadde_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES hammadde_kayitlari (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _miktarMeta = const VerificationMeta('miktar');
  @override
  late final GeneratedColumn<double> miktar = GeneratedColumn<double>(
    'miktar',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [urunId, hammaddeId, miktar];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recete_kalem_kayitlari';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReceteKalemKayitlariData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('urun_id')) {
      context.handle(
        _urunIdMeta,
        urunId.isAcceptableOrUnknown(data['urun_id']!, _urunIdMeta),
      );
    } else if (isInserting) {
      context.missing(_urunIdMeta);
    }
    if (data.containsKey('hammadde_id')) {
      context.handle(
        _hammaddeIdMeta,
        hammaddeId.isAcceptableOrUnknown(data['hammadde_id']!, _hammaddeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hammaddeIdMeta);
    }
    if (data.containsKey('miktar')) {
      context.handle(
        _miktarMeta,
        miktar.isAcceptableOrUnknown(data['miktar']!, _miktarMeta),
      );
    } else if (isInserting) {
      context.missing(_miktarMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {urunId, hammaddeId};
  @override
  ReceteKalemKayitlariData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReceteKalemKayitlariData(
      urunId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}urun_id'],
      )!,
      hammaddeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hammadde_id'],
      )!,
      miktar: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}miktar'],
      )!,
    );
  }

  @override
  $ReceteKalemKayitlariTable createAlias(String alias) {
    return $ReceteKalemKayitlariTable(attachedDatabase, alias);
  }
}

class ReceteKalemKayitlariData extends DataClass
    implements Insertable<ReceteKalemKayitlariData> {
  final String urunId;
  final String hammaddeId;
  final double miktar;
  const ReceteKalemKayitlariData({
    required this.urunId,
    required this.hammaddeId,
    required this.miktar,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['urun_id'] = Variable<String>(urunId);
    map['hammadde_id'] = Variable<String>(hammaddeId);
    map['miktar'] = Variable<double>(miktar);
    return map;
  }

  ReceteKalemKayitlariCompanion toCompanion(bool nullToAbsent) {
    return ReceteKalemKayitlariCompanion(
      urunId: Value(urunId),
      hammaddeId: Value(hammaddeId),
      miktar: Value(miktar),
    );
  }

  factory ReceteKalemKayitlariData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReceteKalemKayitlariData(
      urunId: serializer.fromJson<String>(json['urunId']),
      hammaddeId: serializer.fromJson<String>(json['hammaddeId']),
      miktar: serializer.fromJson<double>(json['miktar']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'urunId': serializer.toJson<String>(urunId),
      'hammaddeId': serializer.toJson<String>(hammaddeId),
      'miktar': serializer.toJson<double>(miktar),
    };
  }

  ReceteKalemKayitlariData copyWith({
    String? urunId,
    String? hammaddeId,
    double? miktar,
  }) => ReceteKalemKayitlariData(
    urunId: urunId ?? this.urunId,
    hammaddeId: hammaddeId ?? this.hammaddeId,
    miktar: miktar ?? this.miktar,
  );
  ReceteKalemKayitlariData copyWithCompanion(
    ReceteKalemKayitlariCompanion data,
  ) {
    return ReceteKalemKayitlariData(
      urunId: data.urunId.present ? data.urunId.value : this.urunId,
      hammaddeId: data.hammaddeId.present
          ? data.hammaddeId.value
          : this.hammaddeId,
      miktar: data.miktar.present ? data.miktar.value : this.miktar,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReceteKalemKayitlariData(')
          ..write('urunId: $urunId, ')
          ..write('hammaddeId: $hammaddeId, ')
          ..write('miktar: $miktar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(urunId, hammaddeId, miktar);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceteKalemKayitlariData &&
          other.urunId == this.urunId &&
          other.hammaddeId == this.hammaddeId &&
          other.miktar == this.miktar);
}

class ReceteKalemKayitlariCompanion
    extends UpdateCompanion<ReceteKalemKayitlariData> {
  final Value<String> urunId;
  final Value<String> hammaddeId;
  final Value<double> miktar;
  final Value<int> rowid;
  const ReceteKalemKayitlariCompanion({
    this.urunId = const Value.absent(),
    this.hammaddeId = const Value.absent(),
    this.miktar = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReceteKalemKayitlariCompanion.insert({
    required String urunId,
    required String hammaddeId,
    required double miktar,
    this.rowid = const Value.absent(),
  }) : urunId = Value(urunId),
       hammaddeId = Value(hammaddeId),
       miktar = Value(miktar);
  static Insertable<ReceteKalemKayitlariData> custom({
    Expression<String>? urunId,
    Expression<String>? hammaddeId,
    Expression<double>? miktar,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (urunId != null) 'urun_id': urunId,
      if (hammaddeId != null) 'hammadde_id': hammaddeId,
      if (miktar != null) 'miktar': miktar,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReceteKalemKayitlariCompanion copyWith({
    Value<String>? urunId,
    Value<String>? hammaddeId,
    Value<double>? miktar,
    Value<int>? rowid,
  }) {
    return ReceteKalemKayitlariCompanion(
      urunId: urunId ?? this.urunId,
      hammaddeId: hammaddeId ?? this.hammaddeId,
      miktar: miktar ?? this.miktar,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (urunId.present) {
      map['urun_id'] = Variable<String>(urunId.value);
    }
    if (hammaddeId.present) {
      map['hammadde_id'] = Variable<String>(hammaddeId.value);
    }
    if (miktar.present) {
      map['miktar'] = Variable<double>(miktar.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceteKalemKayitlariCompanion(')
          ..write('urunId: $urunId, ')
          ..write('hammaddeId: $hammaddeId, ')
          ..write('miktar: $miktar, ')
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
  late final $YaziciKayitlariTable yaziciKayitlari = $YaziciKayitlariTable(
    this,
  );
  late final $PersonelKayitlariTable personelKayitlari =
      $PersonelKayitlariTable(this);
  late final $SalonBolumKayitlariTable salonBolumKayitlari =
      $SalonBolumKayitlariTable(this);
  late final $MasaKayitlariTable masaKayitlari = $MasaKayitlariTable(this);
  late final $HammaddeKayitlariTable hammaddeKayitlari =
      $HammaddeKayitlariTable(this);
  late final $StokAlarmGecmisKayitlariTable stokAlarmGecmisKayitlari =
      $StokAlarmGecmisKayitlariTable(this);
  late final $ReceteKalemKayitlariTable receteKalemKayitlari =
      $ReceteKalemKayitlariTable(this);
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
    yaziciKayitlari,
    personelKayitlari,
    salonBolumKayitlari,
    masaKayitlari,
    hammaddeKayitlari,
    stokAlarmGecmisKayitlari,
    receteKalemKayitlari,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'kategori_kayitlari',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('urun_kayitlari', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sepet_kayitlari',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sepet_kalemleri', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'urun_kayitlari',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sepet_kalemleri', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'siparis_kayitlari',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('siparis_kalemleri', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'salon_bolum_kayitlari',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('masa_kayitlari', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'urun_kayitlari',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recete_kalem_kayitlari', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'hammadde_kayitlari',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recete_kalem_kayitlari', kind: UpdateKind.delete)],
    ),
  ]);
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

final class $$KategoriKayitlariTableReferences
    extends
        BaseReferences<
          _$UygulamaVeritabani,
          $KategoriKayitlariTable,
          KategoriKayitlariData
        > {
  $$KategoriKayitlariTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$UrunKayitlariTable, List<UrunKayitlariData>>
  _urunKayitlariRefsTable(_$UygulamaVeritabani db) =>
      MultiTypedResultKey.fromTable(
        db.urunKayitlari,
        aliasName: $_aliasNameGenerator(
          db.kategoriKayitlari.id,
          db.urunKayitlari.kategoriId,
        ),
      );

  $$UrunKayitlariTableProcessedTableManager get urunKayitlariRefs {
    final manager = $$UrunKayitlariTableTableManager(
      $_db,
      $_db.urunKayitlari,
    ).filter((f) => f.kategoriId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_urunKayitlariRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  Expression<bool> urunKayitlariRefs(
    Expression<bool> Function($$UrunKayitlariTableFilterComposer f) f,
  ) {
    final $$UrunKayitlariTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.urunKayitlari,
      getReferencedColumn: (t) => t.kategoriId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UrunKayitlariTableFilterComposer(
            $db: $db,
            $table: $db.urunKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  Expression<T> urunKayitlariRefs<T extends Object>(
    Expression<T> Function($$UrunKayitlariTableAnnotationComposer a) f,
  ) {
    final $$UrunKayitlariTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.urunKayitlari,
      getReferencedColumn: (t) => t.kategoriId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UrunKayitlariTableAnnotationComposer(
            $db: $db,
            $table: $db.urunKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (KategoriKayitlariData, $$KategoriKayitlariTableReferences),
          KategoriKayitlariData,
          PrefetchHooks Function({bool urunKayitlariRefs})
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$KategoriKayitlariTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({urunKayitlariRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (urunKayitlariRefs) db.urunKayitlari,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (urunKayitlariRefs)
                    await $_getPrefetchedData<
                      KategoriKayitlariData,
                      $KategoriKayitlariTable,
                      UrunKayitlariData
                    >(
                      currentTable: table,
                      referencedTable: $$KategoriKayitlariTableReferences
                          ._urunKayitlariRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$KategoriKayitlariTableReferences(
                            db,
                            table,
                            p0,
                          ).urunKayitlariRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.kategoriId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (KategoriKayitlariData, $$KategoriKayitlariTableReferences),
      KategoriKayitlariData,
      PrefetchHooks Function({bool urunKayitlariRefs})
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

final class $$UrunKayitlariTableReferences
    extends
        BaseReferences<
          _$UygulamaVeritabani,
          $UrunKayitlariTable,
          UrunKayitlariData
        > {
  $$UrunKayitlariTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $KategoriKayitlariTable _kategoriIdTable(_$UygulamaVeritabani db) =>
      db.kategoriKayitlari.createAlias(
        $_aliasNameGenerator(
          db.urunKayitlari.kategoriId,
          db.kategoriKayitlari.id,
        ),
      );

  $$KategoriKayitlariTableProcessedTableManager get kategoriId {
    final $_column = $_itemColumn<String>('kategori_id')!;

    final manager = $$KategoriKayitlariTableTableManager(
      $_db,
      $_db.kategoriKayitlari,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kategoriIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SepetKalemleriTable, List<SepetKalemleriData>>
  _sepetKalemleriRefsTable(_$UygulamaVeritabani db) =>
      MultiTypedResultKey.fromTable(
        db.sepetKalemleri,
        aliasName: $_aliasNameGenerator(
          db.urunKayitlari.id,
          db.sepetKalemleri.urunId,
        ),
      );

  $$SepetKalemleriTableProcessedTableManager get sepetKalemleriRefs {
    final manager = $$SepetKalemleriTableTableManager(
      $_db,
      $_db.sepetKalemleri,
    ).filter((f) => f.urunId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sepetKalemleriRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ReceteKalemKayitlariTable,
    List<ReceteKalemKayitlariData>
  >
  _receteKalemKayitlariRefsTable(_$UygulamaVeritabani db) =>
      MultiTypedResultKey.fromTable(
        db.receteKalemKayitlari,
        aliasName: $_aliasNameGenerator(
          db.urunKayitlari.id,
          db.receteKalemKayitlari.urunId,
        ),
      );

  $$ReceteKalemKayitlariTableProcessedTableManager
  get receteKalemKayitlariRefs {
    final manager = $$ReceteKalemKayitlariTableTableManager(
      $_db,
      $_db.receteKalemKayitlari,
    ).filter((f) => f.urunId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _receteKalemKayitlariRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  $$KategoriKayitlariTableFilterComposer get kategoriId {
    final $$KategoriKayitlariTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kategoriId,
      referencedTable: $db.kategoriKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KategoriKayitlariTableFilterComposer(
            $db: $db,
            $table: $db.kategoriKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sepetKalemleriRefs(
    Expression<bool> Function($$SepetKalemleriTableFilterComposer f) f,
  ) {
    final $$SepetKalemleriTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sepetKalemleri,
      getReferencedColumn: (t) => t.urunId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SepetKalemleriTableFilterComposer(
            $db: $db,
            $table: $db.sepetKalemleri,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> receteKalemKayitlariRefs(
    Expression<bool> Function($$ReceteKalemKayitlariTableFilterComposer f) f,
  ) {
    final $$ReceteKalemKayitlariTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.receteKalemKayitlari,
      getReferencedColumn: (t) => t.urunId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceteKalemKayitlariTableFilterComposer(
            $db: $db,
            $table: $db.receteKalemKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  $$KategoriKayitlariTableOrderingComposer get kategoriId {
    final $$KategoriKayitlariTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kategoriId,
      referencedTable: $db.kategoriKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KategoriKayitlariTableOrderingComposer(
            $db: $db,
            $table: $db.kategoriKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  $$KategoriKayitlariTableAnnotationComposer get kategoriId {
    final $$KategoriKayitlariTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.kategoriId,
          referencedTable: $db.kategoriKayitlari,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$KategoriKayitlariTableAnnotationComposer(
                $db: $db,
                $table: $db.kategoriKayitlari,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> sepetKalemleriRefs<T extends Object>(
    Expression<T> Function($$SepetKalemleriTableAnnotationComposer a) f,
  ) {
    final $$SepetKalemleriTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sepetKalemleri,
      getReferencedColumn: (t) => t.urunId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SepetKalemleriTableAnnotationComposer(
            $db: $db,
            $table: $db.sepetKalemleri,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> receteKalemKayitlariRefs<T extends Object>(
    Expression<T> Function($$ReceteKalemKayitlariTableAnnotationComposer a) f,
  ) {
    final $$ReceteKalemKayitlariTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.receteKalemKayitlari,
          getReferencedColumn: (t) => t.urunId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReceteKalemKayitlariTableAnnotationComposer(
                $db: $db,
                $table: $db.receteKalemKayitlari,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
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
          (UrunKayitlariData, $$UrunKayitlariTableReferences),
          UrunKayitlariData,
          PrefetchHooks Function({
            bool kategoriId,
            bool sepetKalemleriRefs,
            bool receteKalemKayitlariRefs,
          })
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$UrunKayitlariTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                kategoriId = false,
                sepetKalemleriRefs = false,
                receteKalemKayitlariRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sepetKalemleriRefs) db.sepetKalemleri,
                    if (receteKalemKayitlariRefs) db.receteKalemKayitlari,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (kategoriId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.kategoriId,
                                    referencedTable:
                                        $$UrunKayitlariTableReferences
                                            ._kategoriIdTable(db),
                                    referencedColumn:
                                        $$UrunKayitlariTableReferences
                                            ._kategoriIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sepetKalemleriRefs)
                        await $_getPrefetchedData<
                          UrunKayitlariData,
                          $UrunKayitlariTable,
                          SepetKalemleriData
                        >(
                          currentTable: table,
                          referencedTable: $$UrunKayitlariTableReferences
                              ._sepetKalemleriRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UrunKayitlariTableReferences(
                                db,
                                table,
                                p0,
                              ).sepetKalemleriRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.urunId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (receteKalemKayitlariRefs)
                        await $_getPrefetchedData<
                          UrunKayitlariData,
                          $UrunKayitlariTable,
                          ReceteKalemKayitlariData
                        >(
                          currentTable: table,
                          referencedTable: $$UrunKayitlariTableReferences
                              ._receteKalemKayitlariRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UrunKayitlariTableReferences(
                                db,
                                table,
                                p0,
                              ).receteKalemKayitlariRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.urunId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
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
      (UrunKayitlariData, $$UrunKayitlariTableReferences),
      UrunKayitlariData,
      PrefetchHooks Function({
        bool kategoriId,
        bool sepetKalemleriRefs,
        bool receteKalemKayitlariRefs,
      })
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

final class $$SepetKayitlariTableReferences
    extends
        BaseReferences<
          _$UygulamaVeritabani,
          $SepetKayitlariTable,
          SepetKayitlariData
        > {
  $$SepetKayitlariTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SepetKalemleriTable, List<SepetKalemleriData>>
  _sepetKalemleriRefsTable(_$UygulamaVeritabani db) =>
      MultiTypedResultKey.fromTable(
        db.sepetKalemleri,
        aliasName: $_aliasNameGenerator(
          db.sepetKayitlari.id,
          db.sepetKalemleri.sepetId,
        ),
      );

  $$SepetKalemleriTableProcessedTableManager get sepetKalemleriRefs {
    final manager = $$SepetKalemleriTableTableManager(
      $_db,
      $_db.sepetKalemleri,
    ).filter((f) => f.sepetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sepetKalemleriRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  Expression<bool> sepetKalemleriRefs(
    Expression<bool> Function($$SepetKalemleriTableFilterComposer f) f,
  ) {
    final $$SepetKalemleriTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sepetKalemleri,
      getReferencedColumn: (t) => t.sepetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SepetKalemleriTableFilterComposer(
            $db: $db,
            $table: $db.sepetKalemleri,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  Expression<T> sepetKalemleriRefs<T extends Object>(
    Expression<T> Function($$SepetKalemleriTableAnnotationComposer a) f,
  ) {
    final $$SepetKalemleriTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sepetKalemleri,
      getReferencedColumn: (t) => t.sepetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SepetKalemleriTableAnnotationComposer(
            $db: $db,
            $table: $db.sepetKalemleri,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (SepetKayitlariData, $$SepetKayitlariTableReferences),
          SepetKayitlariData,
          PrefetchHooks Function({bool sepetKalemleriRefs})
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$SepetKayitlariTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sepetKalemleriRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sepetKalemleriRefs) db.sepetKalemleri,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sepetKalemleriRefs)
                    await $_getPrefetchedData<
                      SepetKayitlariData,
                      $SepetKayitlariTable,
                      SepetKalemleriData
                    >(
                      currentTable: table,
                      referencedTable: $$SepetKayitlariTableReferences
                          ._sepetKalemleriRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SepetKayitlariTableReferences(
                            db,
                            table,
                            p0,
                          ).sepetKalemleriRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sepetId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (SepetKayitlariData, $$SepetKayitlariTableReferences),
      SepetKayitlariData,
      PrefetchHooks Function({bool sepetKalemleriRefs})
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

final class $$SepetKalemleriTableReferences
    extends
        BaseReferences<
          _$UygulamaVeritabani,
          $SepetKalemleriTable,
          SepetKalemleriData
        > {
  $$SepetKalemleriTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SepetKayitlariTable _sepetIdTable(_$UygulamaVeritabani db) =>
      db.sepetKayitlari.createAlias(
        $_aliasNameGenerator(db.sepetKalemleri.sepetId, db.sepetKayitlari.id),
      );

  $$SepetKayitlariTableProcessedTableManager get sepetId {
    final $_column = $_itemColumn<String>('sepet_id')!;

    final manager = $$SepetKayitlariTableTableManager(
      $_db,
      $_db.sepetKayitlari,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sepetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UrunKayitlariTable _urunIdTable(_$UygulamaVeritabani db) =>
      db.urunKayitlari.createAlias(
        $_aliasNameGenerator(db.sepetKalemleri.urunId, db.urunKayitlari.id),
      );

  $$UrunKayitlariTableProcessedTableManager get urunId {
    final $_column = $_itemColumn<String>('urun_id')!;

    final manager = $$UrunKayitlariTableTableManager(
      $_db,
      $_db.urunKayitlari,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_urunIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

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

  $$SepetKayitlariTableFilterComposer get sepetId {
    final $$SepetKayitlariTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sepetId,
      referencedTable: $db.sepetKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SepetKayitlariTableFilterComposer(
            $db: $db,
            $table: $db.sepetKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UrunKayitlariTableFilterComposer get urunId {
    final $$UrunKayitlariTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.urunId,
      referencedTable: $db.urunKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UrunKayitlariTableFilterComposer(
            $db: $db,
            $table: $db.urunKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  $$SepetKayitlariTableOrderingComposer get sepetId {
    final $$SepetKayitlariTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sepetId,
      referencedTable: $db.sepetKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SepetKayitlariTableOrderingComposer(
            $db: $db,
            $table: $db.sepetKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UrunKayitlariTableOrderingComposer get urunId {
    final $$UrunKayitlariTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.urunId,
      referencedTable: $db.urunKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UrunKayitlariTableOrderingComposer(
            $db: $db,
            $table: $db.urunKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  $$SepetKayitlariTableAnnotationComposer get sepetId {
    final $$SepetKayitlariTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sepetId,
      referencedTable: $db.sepetKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SepetKayitlariTableAnnotationComposer(
            $db: $db,
            $table: $db.sepetKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UrunKayitlariTableAnnotationComposer get urunId {
    final $$UrunKayitlariTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.urunId,
      referencedTable: $db.urunKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UrunKayitlariTableAnnotationComposer(
            $db: $db,
            $table: $db.urunKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
          (SepetKalemleriData, $$SepetKalemleriTableReferences),
          SepetKalemleriData,
          PrefetchHooks Function({bool sepetId, bool urunId})
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$SepetKalemleriTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sepetId = false, urunId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sepetId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sepetId,
                                referencedTable: $$SepetKalemleriTableReferences
                                    ._sepetIdTable(db),
                                referencedColumn:
                                    $$SepetKalemleriTableReferences
                                        ._sepetIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (urunId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.urunId,
                                referencedTable: $$SepetKalemleriTableReferences
                                    ._urunIdTable(db),
                                referencedColumn:
                                    $$SepetKalemleriTableReferences
                                        ._urunIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
      (SepetKalemleriData, $$SepetKalemleriTableReferences),
      SepetKalemleriData,
      PrefetchHooks Function({bool sepetId, bool urunId})
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
      Value<String?> kuponKodu,
      Value<double> indirimTutari,
      Value<bool> aydinlatmaOnayi,
      Value<bool> ticariIletisimOnayi,
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
      Value<String?> kuponKodu,
      Value<double> indirimTutari,
      Value<bool> aydinlatmaOnayi,
      Value<bool> ticariIletisimOnayi,
      Value<bool> sahipMisafir,
      Value<String> sahipAdSoyad,
      Value<String> sahipTelefon,
      Value<String?> sahipEposta,
      Value<String?> sahipAdres,
      Value<int> rowid,
    });

final class $$SiparisKayitlariTableReferences
    extends
        BaseReferences<
          _$UygulamaVeritabani,
          $SiparisKayitlariTable,
          SiparisKayitlariData
        > {
  $$SiparisKayitlariTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SiparisKalemleriTable, List<SiparisKalemleriData>>
  _siparisKalemleriRefsTable(_$UygulamaVeritabani db) =>
      MultiTypedResultKey.fromTable(
        db.siparisKalemleri,
        aliasName: $_aliasNameGenerator(
          db.siparisKayitlari.id,
          db.siparisKalemleri.siparisId,
        ),
      );

  $$SiparisKalemleriTableProcessedTableManager get siparisKalemleriRefs {
    final manager = $$SiparisKalemleriTableTableManager(
      $_db,
      $_db.siparisKalemleri,
    ).filter((f) => f.siparisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _siparisKalemleriRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<String> get kuponKodu => $composableBuilder(
    column: $table.kuponKodu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get indirimTutari => $composableBuilder(
    column: $table.indirimTutari,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get aydinlatmaOnayi => $composableBuilder(
    column: $table.aydinlatmaOnayi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ticariIletisimOnayi => $composableBuilder(
    column: $table.ticariIletisimOnayi,
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

  Expression<bool> siparisKalemleriRefs(
    Expression<bool> Function($$SiparisKalemleriTableFilterComposer f) f,
  ) {
    final $$SiparisKalemleriTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.siparisKalemleri,
      getReferencedColumn: (t) => t.siparisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiparisKalemleriTableFilterComposer(
            $db: $db,
            $table: $db.siparisKalemleri,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<String> get kuponKodu => $composableBuilder(
    column: $table.kuponKodu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get indirimTutari => $composableBuilder(
    column: $table.indirimTutari,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get aydinlatmaOnayi => $composableBuilder(
    column: $table.aydinlatmaOnayi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ticariIletisimOnayi => $composableBuilder(
    column: $table.ticariIletisimOnayi,
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

  GeneratedColumn<String> get kuponKodu =>
      $composableBuilder(column: $table.kuponKodu, builder: (column) => column);

  GeneratedColumn<double> get indirimTutari => $composableBuilder(
    column: $table.indirimTutari,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get aydinlatmaOnayi => $composableBuilder(
    column: $table.aydinlatmaOnayi,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ticariIletisimOnayi => $composableBuilder(
    column: $table.ticariIletisimOnayi,
    builder: (column) => column,
  );

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

  Expression<T> siparisKalemleriRefs<T extends Object>(
    Expression<T> Function($$SiparisKalemleriTableAnnotationComposer a) f,
  ) {
    final $$SiparisKalemleriTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.siparisKalemleri,
      getReferencedColumn: (t) => t.siparisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiparisKalemleriTableAnnotationComposer(
            $db: $db,
            $table: $db.siparisKalemleri,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (SiparisKayitlariData, $$SiparisKayitlariTableReferences),
          SiparisKayitlariData,
          PrefetchHooks Function({bool siparisKalemleriRefs})
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
                Value<String?> kuponKodu = const Value.absent(),
                Value<double> indirimTutari = const Value.absent(),
                Value<bool> aydinlatmaOnayi = const Value.absent(),
                Value<bool> ticariIletisimOnayi = const Value.absent(),
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
                kuponKodu: kuponKodu,
                indirimTutari: indirimTutari,
                aydinlatmaOnayi: aydinlatmaOnayi,
                ticariIletisimOnayi: ticariIletisimOnayi,
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
                Value<String?> kuponKodu = const Value.absent(),
                Value<double> indirimTutari = const Value.absent(),
                Value<bool> aydinlatmaOnayi = const Value.absent(),
                Value<bool> ticariIletisimOnayi = const Value.absent(),
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
                kuponKodu: kuponKodu,
                indirimTutari: indirimTutari,
                aydinlatmaOnayi: aydinlatmaOnayi,
                ticariIletisimOnayi: ticariIletisimOnayi,
                sahipMisafir: sahipMisafir,
                sahipAdSoyad: sahipAdSoyad,
                sahipTelefon: sahipTelefon,
                sahipEposta: sahipEposta,
                sahipAdres: sahipAdres,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SiparisKayitlariTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({siparisKalemleriRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (siparisKalemleriRefs) db.siparisKalemleri,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (siparisKalemleriRefs)
                    await $_getPrefetchedData<
                      SiparisKayitlariData,
                      $SiparisKayitlariTable,
                      SiparisKalemleriData
                    >(
                      currentTable: table,
                      referencedTable: $$SiparisKayitlariTableReferences
                          ._siparisKalemleriRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SiparisKayitlariTableReferences(
                            db,
                            table,
                            p0,
                          ).siparisKalemleriRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.siparisId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (SiparisKayitlariData, $$SiparisKayitlariTableReferences),
      SiparisKayitlariData,
      PrefetchHooks Function({bool siparisKalemleriRefs})
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

final class $$SiparisKalemleriTableReferences
    extends
        BaseReferences<
          _$UygulamaVeritabani,
          $SiparisKalemleriTable,
          SiparisKalemleriData
        > {
  $$SiparisKalemleriTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SiparisKayitlariTable _siparisIdTable(_$UygulamaVeritabani db) =>
      db.siparisKayitlari.createAlias(
        $_aliasNameGenerator(
          db.siparisKalemleri.siparisId,
          db.siparisKayitlari.id,
        ),
      );

  $$SiparisKayitlariTableProcessedTableManager get siparisId {
    final $_column = $_itemColumn<String>('siparis_id')!;

    final manager = $$SiparisKayitlariTableTableManager(
      $_db,
      $_db.siparisKayitlari,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_siparisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

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

  $$SiparisKayitlariTableFilterComposer get siparisId {
    final $$SiparisKayitlariTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siparisId,
      referencedTable: $db.siparisKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiparisKayitlariTableFilterComposer(
            $db: $db,
            $table: $db.siparisKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  $$SiparisKayitlariTableOrderingComposer get siparisId {
    final $$SiparisKayitlariTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siparisId,
      referencedTable: $db.siparisKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiparisKayitlariTableOrderingComposer(
            $db: $db,
            $table: $db.siparisKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  $$SiparisKayitlariTableAnnotationComposer get siparisId {
    final $$SiparisKayitlariTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siparisId,
      referencedTable: $db.siparisKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiparisKayitlariTableAnnotationComposer(
            $db: $db,
            $table: $db.siparisKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
          (SiparisKalemleriData, $$SiparisKalemleriTableReferences),
          SiparisKalemleriData,
          PrefetchHooks Function({bool siparisId})
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$SiparisKalemleriTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({siparisId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (siparisId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.siparisId,
                                referencedTable:
                                    $$SiparisKalemleriTableReferences
                                        ._siparisIdTable(db),
                                referencedColumn:
                                    $$SiparisKalemleriTableReferences
                                        ._siparisIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
      (SiparisKalemleriData, $$SiparisKalemleriTableReferences),
      SiparisKalemleriData,
      PrefetchHooks Function({bool siparisId})
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
typedef $$YaziciKayitlariTableCreateCompanionBuilder =
    YaziciKayitlariCompanion Function({
      required String id,
      required String ad,
      required String rolEtiketi,
      required String baglantiNoktasi,
      required String aciklama,
      required int durum,
      Value<int> rowid,
    });
typedef $$YaziciKayitlariTableUpdateCompanionBuilder =
    YaziciKayitlariCompanion Function({
      Value<String> id,
      Value<String> ad,
      Value<String> rolEtiketi,
      Value<String> baglantiNoktasi,
      Value<String> aciklama,
      Value<int> durum,
      Value<int> rowid,
    });

class $$YaziciKayitlariTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $YaziciKayitlariTable> {
  $$YaziciKayitlariTableFilterComposer({
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

  ColumnFilters<String> get rolEtiketi => $composableBuilder(
    column: $table.rolEtiketi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baglantiNoktasi => $composableBuilder(
    column: $table.baglantiNoktasi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aciklama => $composableBuilder(
    column: $table.aciklama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durum => $composableBuilder(
    column: $table.durum,
    builder: (column) => ColumnFilters(column),
  );
}

class $$YaziciKayitlariTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $YaziciKayitlariTable> {
  $$YaziciKayitlariTableOrderingComposer({
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

  ColumnOrderings<String> get rolEtiketi => $composableBuilder(
    column: $table.rolEtiketi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baglantiNoktasi => $composableBuilder(
    column: $table.baglantiNoktasi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aciklama => $composableBuilder(
    column: $table.aciklama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durum => $composableBuilder(
    column: $table.durum,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$YaziciKayitlariTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $YaziciKayitlariTable> {
  $$YaziciKayitlariTableAnnotationComposer({
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

  GeneratedColumn<String> get rolEtiketi => $composableBuilder(
    column: $table.rolEtiketi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baglantiNoktasi => $composableBuilder(
    column: $table.baglantiNoktasi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aciklama =>
      $composableBuilder(column: $table.aciklama, builder: (column) => column);

  GeneratedColumn<int> get durum =>
      $composableBuilder(column: $table.durum, builder: (column) => column);
}

class $$YaziciKayitlariTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $YaziciKayitlariTable,
          YaziciKayitlariData,
          $$YaziciKayitlariTableFilterComposer,
          $$YaziciKayitlariTableOrderingComposer,
          $$YaziciKayitlariTableAnnotationComposer,
          $$YaziciKayitlariTableCreateCompanionBuilder,
          $$YaziciKayitlariTableUpdateCompanionBuilder,
          (
            YaziciKayitlariData,
            BaseReferences<
              _$UygulamaVeritabani,
              $YaziciKayitlariTable,
              YaziciKayitlariData
            >,
          ),
          YaziciKayitlariData,
          PrefetchHooks Function()
        > {
  $$YaziciKayitlariTableTableManager(
    _$UygulamaVeritabani db,
    $YaziciKayitlariTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$YaziciKayitlariTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$YaziciKayitlariTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$YaziciKayitlariTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ad = const Value.absent(),
                Value<String> rolEtiketi = const Value.absent(),
                Value<String> baglantiNoktasi = const Value.absent(),
                Value<String> aciklama = const Value.absent(),
                Value<int> durum = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => YaziciKayitlariCompanion(
                id: id,
                ad: ad,
                rolEtiketi: rolEtiketi,
                baglantiNoktasi: baglantiNoktasi,
                aciklama: aciklama,
                durum: durum,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ad,
                required String rolEtiketi,
                required String baglantiNoktasi,
                required String aciklama,
                required int durum,
                Value<int> rowid = const Value.absent(),
              }) => YaziciKayitlariCompanion.insert(
                id: id,
                ad: ad,
                rolEtiketi: rolEtiketi,
                baglantiNoktasi: baglantiNoktasi,
                aciklama: aciklama,
                durum: durum,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$YaziciKayitlariTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $YaziciKayitlariTable,
      YaziciKayitlariData,
      $$YaziciKayitlariTableFilterComposer,
      $$YaziciKayitlariTableOrderingComposer,
      $$YaziciKayitlariTableAnnotationComposer,
      $$YaziciKayitlariTableCreateCompanionBuilder,
      $$YaziciKayitlariTableUpdateCompanionBuilder,
      (
        YaziciKayitlariData,
        BaseReferences<
          _$UygulamaVeritabani,
          $YaziciKayitlariTable,
          YaziciKayitlariData
        >,
      ),
      YaziciKayitlariData,
      PrefetchHooks Function()
    >;
typedef $$PersonelKayitlariTableCreateCompanionBuilder =
    PersonelKayitlariCompanion Function({
      required String kimlik,
      required String adSoyad,
      required String rolEtiketi,
      required String bolge,
      required String aciklama,
      required int durum,
      Value<int> rowid,
    });
typedef $$PersonelKayitlariTableUpdateCompanionBuilder =
    PersonelKayitlariCompanion Function({
      Value<String> kimlik,
      Value<String> adSoyad,
      Value<String> rolEtiketi,
      Value<String> bolge,
      Value<String> aciklama,
      Value<int> durum,
      Value<int> rowid,
    });

class $$PersonelKayitlariTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $PersonelKayitlariTable> {
  $$PersonelKayitlariTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get kimlik => $composableBuilder(
    column: $table.kimlik,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adSoyad => $composableBuilder(
    column: $table.adSoyad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rolEtiketi => $composableBuilder(
    column: $table.rolEtiketi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bolge => $composableBuilder(
    column: $table.bolge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aciklama => $composableBuilder(
    column: $table.aciklama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durum => $composableBuilder(
    column: $table.durum,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PersonelKayitlariTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $PersonelKayitlariTable> {
  $$PersonelKayitlariTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get kimlik => $composableBuilder(
    column: $table.kimlik,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adSoyad => $composableBuilder(
    column: $table.adSoyad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rolEtiketi => $composableBuilder(
    column: $table.rolEtiketi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bolge => $composableBuilder(
    column: $table.bolge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aciklama => $composableBuilder(
    column: $table.aciklama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durum => $composableBuilder(
    column: $table.durum,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonelKayitlariTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $PersonelKayitlariTable> {
  $$PersonelKayitlariTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get kimlik =>
      $composableBuilder(column: $table.kimlik, builder: (column) => column);

  GeneratedColumn<String> get adSoyad =>
      $composableBuilder(column: $table.adSoyad, builder: (column) => column);

  GeneratedColumn<String> get rolEtiketi => $composableBuilder(
    column: $table.rolEtiketi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bolge =>
      $composableBuilder(column: $table.bolge, builder: (column) => column);

  GeneratedColumn<String> get aciklama =>
      $composableBuilder(column: $table.aciklama, builder: (column) => column);

  GeneratedColumn<int> get durum =>
      $composableBuilder(column: $table.durum, builder: (column) => column);
}

class $$PersonelKayitlariTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $PersonelKayitlariTable,
          PersonelKayitlariData,
          $$PersonelKayitlariTableFilterComposer,
          $$PersonelKayitlariTableOrderingComposer,
          $$PersonelKayitlariTableAnnotationComposer,
          $$PersonelKayitlariTableCreateCompanionBuilder,
          $$PersonelKayitlariTableUpdateCompanionBuilder,
          (
            PersonelKayitlariData,
            BaseReferences<
              _$UygulamaVeritabani,
              $PersonelKayitlariTable,
              PersonelKayitlariData
            >,
          ),
          PersonelKayitlariData,
          PrefetchHooks Function()
        > {
  $$PersonelKayitlariTableTableManager(
    _$UygulamaVeritabani db,
    $PersonelKayitlariTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonelKayitlariTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonelKayitlariTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonelKayitlariTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> kimlik = const Value.absent(),
                Value<String> adSoyad = const Value.absent(),
                Value<String> rolEtiketi = const Value.absent(),
                Value<String> bolge = const Value.absent(),
                Value<String> aciklama = const Value.absent(),
                Value<int> durum = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonelKayitlariCompanion(
                kimlik: kimlik,
                adSoyad: adSoyad,
                rolEtiketi: rolEtiketi,
                bolge: bolge,
                aciklama: aciklama,
                durum: durum,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String kimlik,
                required String adSoyad,
                required String rolEtiketi,
                required String bolge,
                required String aciklama,
                required int durum,
                Value<int> rowid = const Value.absent(),
              }) => PersonelKayitlariCompanion.insert(
                kimlik: kimlik,
                adSoyad: adSoyad,
                rolEtiketi: rolEtiketi,
                bolge: bolge,
                aciklama: aciklama,
                durum: durum,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PersonelKayitlariTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $PersonelKayitlariTable,
      PersonelKayitlariData,
      $$PersonelKayitlariTableFilterComposer,
      $$PersonelKayitlariTableOrderingComposer,
      $$PersonelKayitlariTableAnnotationComposer,
      $$PersonelKayitlariTableCreateCompanionBuilder,
      $$PersonelKayitlariTableUpdateCompanionBuilder,
      (
        PersonelKayitlariData,
        BaseReferences<
          _$UygulamaVeritabani,
          $PersonelKayitlariTable,
          PersonelKayitlariData
        >,
      ),
      PersonelKayitlariData,
      PrefetchHooks Function()
    >;
typedef $$SalonBolumKayitlariTableCreateCompanionBuilder =
    SalonBolumKayitlariCompanion Function({
      required String id,
      required String ad,
      required String aciklama,
      Value<int> rowid,
    });
typedef $$SalonBolumKayitlariTableUpdateCompanionBuilder =
    SalonBolumKayitlariCompanion Function({
      Value<String> id,
      Value<String> ad,
      Value<String> aciklama,
      Value<int> rowid,
    });

final class $$SalonBolumKayitlariTableReferences
    extends
        BaseReferences<
          _$UygulamaVeritabani,
          $SalonBolumKayitlariTable,
          SalonBolumKayitlariData
        > {
  $$SalonBolumKayitlariTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$MasaKayitlariTable, List<MasaKayitlariData>>
  _masaKayitlariRefsTable(_$UygulamaVeritabani db) =>
      MultiTypedResultKey.fromTable(
        db.masaKayitlari,
        aliasName: $_aliasNameGenerator(
          db.salonBolumKayitlari.id,
          db.masaKayitlari.bolumId,
        ),
      );

  $$MasaKayitlariTableProcessedTableManager get masaKayitlariRefs {
    final manager = $$MasaKayitlariTableTableManager(
      $_db,
      $_db.masaKayitlari,
    ).filter((f) => f.bolumId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_masaKayitlariRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SalonBolumKayitlariTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $SalonBolumKayitlariTable> {
  $$SalonBolumKayitlariTableFilterComposer({
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

  ColumnFilters<String> get aciklama => $composableBuilder(
    column: $table.aciklama,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> masaKayitlariRefs(
    Expression<bool> Function($$MasaKayitlariTableFilterComposer f) f,
  ) {
    final $$MasaKayitlariTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.masaKayitlari,
      getReferencedColumn: (t) => t.bolumId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MasaKayitlariTableFilterComposer(
            $db: $db,
            $table: $db.masaKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalonBolumKayitlariTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $SalonBolumKayitlariTable> {
  $$SalonBolumKayitlariTableOrderingComposer({
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

  ColumnOrderings<String> get aciklama => $composableBuilder(
    column: $table.aciklama,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalonBolumKayitlariTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $SalonBolumKayitlariTable> {
  $$SalonBolumKayitlariTableAnnotationComposer({
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

  GeneratedColumn<String> get aciklama =>
      $composableBuilder(column: $table.aciklama, builder: (column) => column);

  Expression<T> masaKayitlariRefs<T extends Object>(
    Expression<T> Function($$MasaKayitlariTableAnnotationComposer a) f,
  ) {
    final $$MasaKayitlariTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.masaKayitlari,
      getReferencedColumn: (t) => t.bolumId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MasaKayitlariTableAnnotationComposer(
            $db: $db,
            $table: $db.masaKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalonBolumKayitlariTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $SalonBolumKayitlariTable,
          SalonBolumKayitlariData,
          $$SalonBolumKayitlariTableFilterComposer,
          $$SalonBolumKayitlariTableOrderingComposer,
          $$SalonBolumKayitlariTableAnnotationComposer,
          $$SalonBolumKayitlariTableCreateCompanionBuilder,
          $$SalonBolumKayitlariTableUpdateCompanionBuilder,
          (SalonBolumKayitlariData, $$SalonBolumKayitlariTableReferences),
          SalonBolumKayitlariData,
          PrefetchHooks Function({bool masaKayitlariRefs})
        > {
  $$SalonBolumKayitlariTableTableManager(
    _$UygulamaVeritabani db,
    $SalonBolumKayitlariTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalonBolumKayitlariTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalonBolumKayitlariTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SalonBolumKayitlariTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ad = const Value.absent(),
                Value<String> aciklama = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalonBolumKayitlariCompanion(
                id: id,
                ad: ad,
                aciklama: aciklama,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ad,
                required String aciklama,
                Value<int> rowid = const Value.absent(),
              }) => SalonBolumKayitlariCompanion.insert(
                id: id,
                ad: ad,
                aciklama: aciklama,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SalonBolumKayitlariTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({masaKayitlariRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (masaKayitlariRefs) db.masaKayitlari,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (masaKayitlariRefs)
                    await $_getPrefetchedData<
                      SalonBolumKayitlariData,
                      $SalonBolumKayitlariTable,
                      MasaKayitlariData
                    >(
                      currentTable: table,
                      referencedTable: $$SalonBolumKayitlariTableReferences
                          ._masaKayitlariRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SalonBolumKayitlariTableReferences(
                            db,
                            table,
                            p0,
                          ).masaKayitlariRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.bolumId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SalonBolumKayitlariTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $SalonBolumKayitlariTable,
      SalonBolumKayitlariData,
      $$SalonBolumKayitlariTableFilterComposer,
      $$SalonBolumKayitlariTableOrderingComposer,
      $$SalonBolumKayitlariTableAnnotationComposer,
      $$SalonBolumKayitlariTableCreateCompanionBuilder,
      $$SalonBolumKayitlariTableUpdateCompanionBuilder,
      (SalonBolumKayitlariData, $$SalonBolumKayitlariTableReferences),
      SalonBolumKayitlariData,
      PrefetchHooks Function({bool masaKayitlariRefs})
    >;
typedef $$MasaKayitlariTableCreateCompanionBuilder =
    MasaKayitlariCompanion Function({
      required String id,
      required String bolumId,
      required String ad,
      required int kapasite,
      Value<int> rowid,
    });
typedef $$MasaKayitlariTableUpdateCompanionBuilder =
    MasaKayitlariCompanion Function({
      Value<String> id,
      Value<String> bolumId,
      Value<String> ad,
      Value<int> kapasite,
      Value<int> rowid,
    });

final class $$MasaKayitlariTableReferences
    extends
        BaseReferences<
          _$UygulamaVeritabani,
          $MasaKayitlariTable,
          MasaKayitlariData
        > {
  $$MasaKayitlariTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SalonBolumKayitlariTable _bolumIdTable(_$UygulamaVeritabani db) =>
      db.salonBolumKayitlari.createAlias(
        $_aliasNameGenerator(
          db.masaKayitlari.bolumId,
          db.salonBolumKayitlari.id,
        ),
      );

  $$SalonBolumKayitlariTableProcessedTableManager get bolumId {
    final $_column = $_itemColumn<String>('bolum_id')!;

    final manager = $$SalonBolumKayitlariTableTableManager(
      $_db,
      $_db.salonBolumKayitlari,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bolumIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MasaKayitlariTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $MasaKayitlariTable> {
  $$MasaKayitlariTableFilterComposer({
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

  ColumnFilters<int> get kapasite => $composableBuilder(
    column: $table.kapasite,
    builder: (column) => ColumnFilters(column),
  );

  $$SalonBolumKayitlariTableFilterComposer get bolumId {
    final $$SalonBolumKayitlariTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bolumId,
      referencedTable: $db.salonBolumKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalonBolumKayitlariTableFilterComposer(
            $db: $db,
            $table: $db.salonBolumKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MasaKayitlariTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $MasaKayitlariTable> {
  $$MasaKayitlariTableOrderingComposer({
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

  ColumnOrderings<int> get kapasite => $composableBuilder(
    column: $table.kapasite,
    builder: (column) => ColumnOrderings(column),
  );

  $$SalonBolumKayitlariTableOrderingComposer get bolumId {
    final $$SalonBolumKayitlariTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.bolumId,
          referencedTable: $db.salonBolumKayitlari,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SalonBolumKayitlariTableOrderingComposer(
                $db: $db,
                $table: $db.salonBolumKayitlari,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$MasaKayitlariTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $MasaKayitlariTable> {
  $$MasaKayitlariTableAnnotationComposer({
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

  GeneratedColumn<int> get kapasite =>
      $composableBuilder(column: $table.kapasite, builder: (column) => column);

  $$SalonBolumKayitlariTableAnnotationComposer get bolumId {
    final $$SalonBolumKayitlariTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.bolumId,
          referencedTable: $db.salonBolumKayitlari,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SalonBolumKayitlariTableAnnotationComposer(
                $db: $db,
                $table: $db.salonBolumKayitlari,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$MasaKayitlariTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $MasaKayitlariTable,
          MasaKayitlariData,
          $$MasaKayitlariTableFilterComposer,
          $$MasaKayitlariTableOrderingComposer,
          $$MasaKayitlariTableAnnotationComposer,
          $$MasaKayitlariTableCreateCompanionBuilder,
          $$MasaKayitlariTableUpdateCompanionBuilder,
          (MasaKayitlariData, $$MasaKayitlariTableReferences),
          MasaKayitlariData,
          PrefetchHooks Function({bool bolumId})
        > {
  $$MasaKayitlariTableTableManager(
    _$UygulamaVeritabani db,
    $MasaKayitlariTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MasaKayitlariTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MasaKayitlariTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MasaKayitlariTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bolumId = const Value.absent(),
                Value<String> ad = const Value.absent(),
                Value<int> kapasite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MasaKayitlariCompanion(
                id: id,
                bolumId: bolumId,
                ad: ad,
                kapasite: kapasite,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bolumId,
                required String ad,
                required int kapasite,
                Value<int> rowid = const Value.absent(),
              }) => MasaKayitlariCompanion.insert(
                id: id,
                bolumId: bolumId,
                ad: ad,
                kapasite: kapasite,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MasaKayitlariTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bolumId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bolumId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bolumId,
                                referencedTable: $$MasaKayitlariTableReferences
                                    ._bolumIdTable(db),
                                referencedColumn: $$MasaKayitlariTableReferences
                                    ._bolumIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MasaKayitlariTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $MasaKayitlariTable,
      MasaKayitlariData,
      $$MasaKayitlariTableFilterComposer,
      $$MasaKayitlariTableOrderingComposer,
      $$MasaKayitlariTableAnnotationComposer,
      $$MasaKayitlariTableCreateCompanionBuilder,
      $$MasaKayitlariTableUpdateCompanionBuilder,
      (MasaKayitlariData, $$MasaKayitlariTableReferences),
      MasaKayitlariData,
      PrefetchHooks Function({bool bolumId})
    >;
typedef $$HammaddeKayitlariTableCreateCompanionBuilder =
    HammaddeKayitlariCompanion Function({
      required String id,
      required String ad,
      required String birim,
      required double mevcutMiktar,
      Value<double> uyariEsigi,
      required double kritikEsik,
      required double birimMaliyet,
      Value<int> rowid,
    });
typedef $$HammaddeKayitlariTableUpdateCompanionBuilder =
    HammaddeKayitlariCompanion Function({
      Value<String> id,
      Value<String> ad,
      Value<String> birim,
      Value<double> mevcutMiktar,
      Value<double> uyariEsigi,
      Value<double> kritikEsik,
      Value<double> birimMaliyet,
      Value<int> rowid,
    });

final class $$HammaddeKayitlariTableReferences
    extends
        BaseReferences<
          _$UygulamaVeritabani,
          $HammaddeKayitlariTable,
          HammaddeKayitlariData
        > {
  $$HammaddeKayitlariTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $ReceteKalemKayitlariTable,
    List<ReceteKalemKayitlariData>
  >
  _receteKalemKayitlariRefsTable(_$UygulamaVeritabani db) =>
      MultiTypedResultKey.fromTable(
        db.receteKalemKayitlari,
        aliasName: $_aliasNameGenerator(
          db.hammaddeKayitlari.id,
          db.receteKalemKayitlari.hammaddeId,
        ),
      );

  $$ReceteKalemKayitlariTableProcessedTableManager
  get receteKalemKayitlariRefs {
    final manager = $$ReceteKalemKayitlariTableTableManager(
      $_db,
      $_db.receteKalemKayitlari,
    ).filter((f) => f.hammaddeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _receteKalemKayitlariRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HammaddeKayitlariTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $HammaddeKayitlariTable> {
  $$HammaddeKayitlariTableFilterComposer({
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

  ColumnFilters<String> get birim => $composableBuilder(
    column: $table.birim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get mevcutMiktar => $composableBuilder(
    column: $table.mevcutMiktar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get uyariEsigi => $composableBuilder(
    column: $table.uyariEsigi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kritikEsik => $composableBuilder(
    column: $table.kritikEsik,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birimMaliyet => $composableBuilder(
    column: $table.birimMaliyet,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> receteKalemKayitlariRefs(
    Expression<bool> Function($$ReceteKalemKayitlariTableFilterComposer f) f,
  ) {
    final $$ReceteKalemKayitlariTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.receteKalemKayitlari,
      getReferencedColumn: (t) => t.hammaddeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceteKalemKayitlariTableFilterComposer(
            $db: $db,
            $table: $db.receteKalemKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HammaddeKayitlariTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $HammaddeKayitlariTable> {
  $$HammaddeKayitlariTableOrderingComposer({
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

  ColumnOrderings<String> get birim => $composableBuilder(
    column: $table.birim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get mevcutMiktar => $composableBuilder(
    column: $table.mevcutMiktar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get uyariEsigi => $composableBuilder(
    column: $table.uyariEsigi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kritikEsik => $composableBuilder(
    column: $table.kritikEsik,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birimMaliyet => $composableBuilder(
    column: $table.birimMaliyet,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HammaddeKayitlariTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $HammaddeKayitlariTable> {
  $$HammaddeKayitlariTableAnnotationComposer({
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

  GeneratedColumn<String> get birim =>
      $composableBuilder(column: $table.birim, builder: (column) => column);

  GeneratedColumn<double> get mevcutMiktar => $composableBuilder(
    column: $table.mevcutMiktar,
    builder: (column) => column,
  );

  GeneratedColumn<double> get uyariEsigi => $composableBuilder(
    column: $table.uyariEsigi,
    builder: (column) => column,
  );

  GeneratedColumn<double> get kritikEsik => $composableBuilder(
    column: $table.kritikEsik,
    builder: (column) => column,
  );

  GeneratedColumn<double> get birimMaliyet => $composableBuilder(
    column: $table.birimMaliyet,
    builder: (column) => column,
  );

  Expression<T> receteKalemKayitlariRefs<T extends Object>(
    Expression<T> Function($$ReceteKalemKayitlariTableAnnotationComposer a) f,
  ) {
    final $$ReceteKalemKayitlariTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.receteKalemKayitlari,
          getReferencedColumn: (t) => t.hammaddeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReceteKalemKayitlariTableAnnotationComposer(
                $db: $db,
                $table: $db.receteKalemKayitlari,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$HammaddeKayitlariTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $HammaddeKayitlariTable,
          HammaddeKayitlariData,
          $$HammaddeKayitlariTableFilterComposer,
          $$HammaddeKayitlariTableOrderingComposer,
          $$HammaddeKayitlariTableAnnotationComposer,
          $$HammaddeKayitlariTableCreateCompanionBuilder,
          $$HammaddeKayitlariTableUpdateCompanionBuilder,
          (HammaddeKayitlariData, $$HammaddeKayitlariTableReferences),
          HammaddeKayitlariData,
          PrefetchHooks Function({bool receteKalemKayitlariRefs})
        > {
  $$HammaddeKayitlariTableTableManager(
    _$UygulamaVeritabani db,
    $HammaddeKayitlariTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HammaddeKayitlariTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HammaddeKayitlariTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HammaddeKayitlariTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ad = const Value.absent(),
                Value<String> birim = const Value.absent(),
                Value<double> mevcutMiktar = const Value.absent(),
                Value<double> uyariEsigi = const Value.absent(),
                Value<double> kritikEsik = const Value.absent(),
                Value<double> birimMaliyet = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HammaddeKayitlariCompanion(
                id: id,
                ad: ad,
                birim: birim,
                mevcutMiktar: mevcutMiktar,
                uyariEsigi: uyariEsigi,
                kritikEsik: kritikEsik,
                birimMaliyet: birimMaliyet,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ad,
                required String birim,
                required double mevcutMiktar,
                Value<double> uyariEsigi = const Value.absent(),
                required double kritikEsik,
                required double birimMaliyet,
                Value<int> rowid = const Value.absent(),
              }) => HammaddeKayitlariCompanion.insert(
                id: id,
                ad: ad,
                birim: birim,
                mevcutMiktar: mevcutMiktar,
                uyariEsigi: uyariEsigi,
                kritikEsik: kritikEsik,
                birimMaliyet: birimMaliyet,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HammaddeKayitlariTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({receteKalemKayitlariRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (receteKalemKayitlariRefs) db.receteKalemKayitlari,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (receteKalemKayitlariRefs)
                    await $_getPrefetchedData<
                      HammaddeKayitlariData,
                      $HammaddeKayitlariTable,
                      ReceteKalemKayitlariData
                    >(
                      currentTable: table,
                      referencedTable: $$HammaddeKayitlariTableReferences
                          ._receteKalemKayitlariRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$HammaddeKayitlariTableReferences(
                            db,
                            table,
                            p0,
                          ).receteKalemKayitlariRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.hammaddeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HammaddeKayitlariTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $HammaddeKayitlariTable,
      HammaddeKayitlariData,
      $$HammaddeKayitlariTableFilterComposer,
      $$HammaddeKayitlariTableOrderingComposer,
      $$HammaddeKayitlariTableAnnotationComposer,
      $$HammaddeKayitlariTableCreateCompanionBuilder,
      $$HammaddeKayitlariTableUpdateCompanionBuilder,
      (HammaddeKayitlariData, $$HammaddeKayitlariTableReferences),
      HammaddeKayitlariData,
      PrefetchHooks Function({bool receteKalemKayitlariRefs})
    >;
typedef $$StokAlarmGecmisKayitlariTableCreateCompanionBuilder =
    StokAlarmGecmisKayitlariCompanion Function({
      required String id,
      required DateTime zaman,
      required String hammaddeId,
      required String hammaddeAdi,
      required double oncekiMiktar,
      required double yeniMiktar,
      required int oncekiDurum,
      required int yeniDurum,
      required String tetikleyenIslem,
      Value<int> rowid,
    });
typedef $$StokAlarmGecmisKayitlariTableUpdateCompanionBuilder =
    StokAlarmGecmisKayitlariCompanion Function({
      Value<String> id,
      Value<DateTime> zaman,
      Value<String> hammaddeId,
      Value<String> hammaddeAdi,
      Value<double> oncekiMiktar,
      Value<double> yeniMiktar,
      Value<int> oncekiDurum,
      Value<int> yeniDurum,
      Value<String> tetikleyenIslem,
      Value<int> rowid,
    });

class $$StokAlarmGecmisKayitlariTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $StokAlarmGecmisKayitlariTable> {
  $$StokAlarmGecmisKayitlariTableFilterComposer({
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

  ColumnFilters<DateTime> get zaman => $composableBuilder(
    column: $table.zaman,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hammaddeId => $composableBuilder(
    column: $table.hammaddeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hammaddeAdi => $composableBuilder(
    column: $table.hammaddeAdi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get oncekiMiktar => $composableBuilder(
    column: $table.oncekiMiktar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get yeniMiktar => $composableBuilder(
    column: $table.yeniMiktar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get oncekiDurum => $composableBuilder(
    column: $table.oncekiDurum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yeniDurum => $composableBuilder(
    column: $table.yeniDurum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tetikleyenIslem => $composableBuilder(
    column: $table.tetikleyenIslem,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StokAlarmGecmisKayitlariTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $StokAlarmGecmisKayitlariTable> {
  $$StokAlarmGecmisKayitlariTableOrderingComposer({
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

  ColumnOrderings<DateTime> get zaman => $composableBuilder(
    column: $table.zaman,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hammaddeId => $composableBuilder(
    column: $table.hammaddeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hammaddeAdi => $composableBuilder(
    column: $table.hammaddeAdi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get oncekiMiktar => $composableBuilder(
    column: $table.oncekiMiktar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get yeniMiktar => $composableBuilder(
    column: $table.yeniMiktar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get oncekiDurum => $composableBuilder(
    column: $table.oncekiDurum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yeniDurum => $composableBuilder(
    column: $table.yeniDurum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tetikleyenIslem => $composableBuilder(
    column: $table.tetikleyenIslem,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StokAlarmGecmisKayitlariTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $StokAlarmGecmisKayitlariTable> {
  $$StokAlarmGecmisKayitlariTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get zaman =>
      $composableBuilder(column: $table.zaman, builder: (column) => column);

  GeneratedColumn<String> get hammaddeId => $composableBuilder(
    column: $table.hammaddeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hammaddeAdi => $composableBuilder(
    column: $table.hammaddeAdi,
    builder: (column) => column,
  );

  GeneratedColumn<double> get oncekiMiktar => $composableBuilder(
    column: $table.oncekiMiktar,
    builder: (column) => column,
  );

  GeneratedColumn<double> get yeniMiktar => $composableBuilder(
    column: $table.yeniMiktar,
    builder: (column) => column,
  );

  GeneratedColumn<int> get oncekiDurum => $composableBuilder(
    column: $table.oncekiDurum,
    builder: (column) => column,
  );

  GeneratedColumn<int> get yeniDurum =>
      $composableBuilder(column: $table.yeniDurum, builder: (column) => column);

  GeneratedColumn<String> get tetikleyenIslem => $composableBuilder(
    column: $table.tetikleyenIslem,
    builder: (column) => column,
  );
}

class $$StokAlarmGecmisKayitlariTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $StokAlarmGecmisKayitlariTable,
          StokAlarmGecmisKayitlariData,
          $$StokAlarmGecmisKayitlariTableFilterComposer,
          $$StokAlarmGecmisKayitlariTableOrderingComposer,
          $$StokAlarmGecmisKayitlariTableAnnotationComposer,
          $$StokAlarmGecmisKayitlariTableCreateCompanionBuilder,
          $$StokAlarmGecmisKayitlariTableUpdateCompanionBuilder,
          (
            StokAlarmGecmisKayitlariData,
            BaseReferences<
              _$UygulamaVeritabani,
              $StokAlarmGecmisKayitlariTable,
              StokAlarmGecmisKayitlariData
            >,
          ),
          StokAlarmGecmisKayitlariData,
          PrefetchHooks Function()
        > {
  $$StokAlarmGecmisKayitlariTableTableManager(
    _$UygulamaVeritabani db,
    $StokAlarmGecmisKayitlariTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StokAlarmGecmisKayitlariTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$StokAlarmGecmisKayitlariTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StokAlarmGecmisKayitlariTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> zaman = const Value.absent(),
                Value<String> hammaddeId = const Value.absent(),
                Value<String> hammaddeAdi = const Value.absent(),
                Value<double> oncekiMiktar = const Value.absent(),
                Value<double> yeniMiktar = const Value.absent(),
                Value<int> oncekiDurum = const Value.absent(),
                Value<int> yeniDurum = const Value.absent(),
                Value<String> tetikleyenIslem = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StokAlarmGecmisKayitlariCompanion(
                id: id,
                zaman: zaman,
                hammaddeId: hammaddeId,
                hammaddeAdi: hammaddeAdi,
                oncekiMiktar: oncekiMiktar,
                yeniMiktar: yeniMiktar,
                oncekiDurum: oncekiDurum,
                yeniDurum: yeniDurum,
                tetikleyenIslem: tetikleyenIslem,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime zaman,
                required String hammaddeId,
                required String hammaddeAdi,
                required double oncekiMiktar,
                required double yeniMiktar,
                required int oncekiDurum,
                required int yeniDurum,
                required String tetikleyenIslem,
                Value<int> rowid = const Value.absent(),
              }) => StokAlarmGecmisKayitlariCompanion.insert(
                id: id,
                zaman: zaman,
                hammaddeId: hammaddeId,
                hammaddeAdi: hammaddeAdi,
                oncekiMiktar: oncekiMiktar,
                yeniMiktar: yeniMiktar,
                oncekiDurum: oncekiDurum,
                yeniDurum: yeniDurum,
                tetikleyenIslem: tetikleyenIslem,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StokAlarmGecmisKayitlariTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $StokAlarmGecmisKayitlariTable,
      StokAlarmGecmisKayitlariData,
      $$StokAlarmGecmisKayitlariTableFilterComposer,
      $$StokAlarmGecmisKayitlariTableOrderingComposer,
      $$StokAlarmGecmisKayitlariTableAnnotationComposer,
      $$StokAlarmGecmisKayitlariTableCreateCompanionBuilder,
      $$StokAlarmGecmisKayitlariTableUpdateCompanionBuilder,
      (
        StokAlarmGecmisKayitlariData,
        BaseReferences<
          _$UygulamaVeritabani,
          $StokAlarmGecmisKayitlariTable,
          StokAlarmGecmisKayitlariData
        >,
      ),
      StokAlarmGecmisKayitlariData,
      PrefetchHooks Function()
    >;
typedef $$ReceteKalemKayitlariTableCreateCompanionBuilder =
    ReceteKalemKayitlariCompanion Function({
      required String urunId,
      required String hammaddeId,
      required double miktar,
      Value<int> rowid,
    });
typedef $$ReceteKalemKayitlariTableUpdateCompanionBuilder =
    ReceteKalemKayitlariCompanion Function({
      Value<String> urunId,
      Value<String> hammaddeId,
      Value<double> miktar,
      Value<int> rowid,
    });

final class $$ReceteKalemKayitlariTableReferences
    extends
        BaseReferences<
          _$UygulamaVeritabani,
          $ReceteKalemKayitlariTable,
          ReceteKalemKayitlariData
        > {
  $$ReceteKalemKayitlariTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UrunKayitlariTable _urunIdTable(_$UygulamaVeritabani db) =>
      db.urunKayitlari.createAlias(
        $_aliasNameGenerator(
          db.receteKalemKayitlari.urunId,
          db.urunKayitlari.id,
        ),
      );

  $$UrunKayitlariTableProcessedTableManager get urunId {
    final $_column = $_itemColumn<String>('urun_id')!;

    final manager = $$UrunKayitlariTableTableManager(
      $_db,
      $_db.urunKayitlari,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_urunIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $HammaddeKayitlariTable _hammaddeIdTable(_$UygulamaVeritabani db) =>
      db.hammaddeKayitlari.createAlias(
        $_aliasNameGenerator(
          db.receteKalemKayitlari.hammaddeId,
          db.hammaddeKayitlari.id,
        ),
      );

  $$HammaddeKayitlariTableProcessedTableManager get hammaddeId {
    final $_column = $_itemColumn<String>('hammadde_id')!;

    final manager = $$HammaddeKayitlariTableTableManager(
      $_db,
      $_db.hammaddeKayitlari,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hammaddeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReceteKalemKayitlariTableFilterComposer
    extends Composer<_$UygulamaVeritabani, $ReceteKalemKayitlariTable> {
  $$ReceteKalemKayitlariTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get miktar => $composableBuilder(
    column: $table.miktar,
    builder: (column) => ColumnFilters(column),
  );

  $$UrunKayitlariTableFilterComposer get urunId {
    final $$UrunKayitlariTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.urunId,
      referencedTable: $db.urunKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UrunKayitlariTableFilterComposer(
            $db: $db,
            $table: $db.urunKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HammaddeKayitlariTableFilterComposer get hammaddeId {
    final $$HammaddeKayitlariTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hammaddeId,
      referencedTable: $db.hammaddeKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HammaddeKayitlariTableFilterComposer(
            $db: $db,
            $table: $db.hammaddeKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReceteKalemKayitlariTableOrderingComposer
    extends Composer<_$UygulamaVeritabani, $ReceteKalemKayitlariTable> {
  $$ReceteKalemKayitlariTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get miktar => $composableBuilder(
    column: $table.miktar,
    builder: (column) => ColumnOrderings(column),
  );

  $$UrunKayitlariTableOrderingComposer get urunId {
    final $$UrunKayitlariTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.urunId,
      referencedTable: $db.urunKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UrunKayitlariTableOrderingComposer(
            $db: $db,
            $table: $db.urunKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HammaddeKayitlariTableOrderingComposer get hammaddeId {
    final $$HammaddeKayitlariTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hammaddeId,
      referencedTable: $db.hammaddeKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HammaddeKayitlariTableOrderingComposer(
            $db: $db,
            $table: $db.hammaddeKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReceteKalemKayitlariTableAnnotationComposer
    extends Composer<_$UygulamaVeritabani, $ReceteKalemKayitlariTable> {
  $$ReceteKalemKayitlariTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get miktar =>
      $composableBuilder(column: $table.miktar, builder: (column) => column);

  $$UrunKayitlariTableAnnotationComposer get urunId {
    final $$UrunKayitlariTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.urunId,
      referencedTable: $db.urunKayitlari,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UrunKayitlariTableAnnotationComposer(
            $db: $db,
            $table: $db.urunKayitlari,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HammaddeKayitlariTableAnnotationComposer get hammaddeId {
    final $$HammaddeKayitlariTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.hammaddeId,
          referencedTable: $db.hammaddeKayitlari,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HammaddeKayitlariTableAnnotationComposer(
                $db: $db,
                $table: $db.hammaddeKayitlari,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ReceteKalemKayitlariTableTableManager
    extends
        RootTableManager<
          _$UygulamaVeritabani,
          $ReceteKalemKayitlariTable,
          ReceteKalemKayitlariData,
          $$ReceteKalemKayitlariTableFilterComposer,
          $$ReceteKalemKayitlariTableOrderingComposer,
          $$ReceteKalemKayitlariTableAnnotationComposer,
          $$ReceteKalemKayitlariTableCreateCompanionBuilder,
          $$ReceteKalemKayitlariTableUpdateCompanionBuilder,
          (ReceteKalemKayitlariData, $$ReceteKalemKayitlariTableReferences),
          ReceteKalemKayitlariData,
          PrefetchHooks Function({bool urunId, bool hammaddeId})
        > {
  $$ReceteKalemKayitlariTableTableManager(
    _$UygulamaVeritabani db,
    $ReceteKalemKayitlariTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceteKalemKayitlariTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceteKalemKayitlariTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ReceteKalemKayitlariTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> urunId = const Value.absent(),
                Value<String> hammaddeId = const Value.absent(),
                Value<double> miktar = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReceteKalemKayitlariCompanion(
                urunId: urunId,
                hammaddeId: hammaddeId,
                miktar: miktar,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String urunId,
                required String hammaddeId,
                required double miktar,
                Value<int> rowid = const Value.absent(),
              }) => ReceteKalemKayitlariCompanion.insert(
                urunId: urunId,
                hammaddeId: hammaddeId,
                miktar: miktar,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReceteKalemKayitlariTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({urunId = false, hammaddeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (urunId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.urunId,
                                referencedTable:
                                    $$ReceteKalemKayitlariTableReferences
                                        ._urunIdTable(db),
                                referencedColumn:
                                    $$ReceteKalemKayitlariTableReferences
                                        ._urunIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (hammaddeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.hammaddeId,
                                referencedTable:
                                    $$ReceteKalemKayitlariTableReferences
                                        ._hammaddeIdTable(db),
                                referencedColumn:
                                    $$ReceteKalemKayitlariTableReferences
                                        ._hammaddeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReceteKalemKayitlariTableProcessedTableManager =
    ProcessedTableManager<
      _$UygulamaVeritabani,
      $ReceteKalemKayitlariTable,
      ReceteKalemKayitlariData,
      $$ReceteKalemKayitlariTableFilterComposer,
      $$ReceteKalemKayitlariTableOrderingComposer,
      $$ReceteKalemKayitlariTableAnnotationComposer,
      $$ReceteKalemKayitlariTableCreateCompanionBuilder,
      $$ReceteKalemKayitlariTableUpdateCompanionBuilder,
      (ReceteKalemKayitlariData, $$ReceteKalemKayitlariTableReferences),
      ReceteKalemKayitlariData,
      PrefetchHooks Function({bool urunId, bool hammaddeId})
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
  $$YaziciKayitlariTableTableManager get yaziciKayitlari =>
      $$YaziciKayitlariTableTableManager(_db, _db.yaziciKayitlari);
  $$PersonelKayitlariTableTableManager get personelKayitlari =>
      $$PersonelKayitlariTableTableManager(_db, _db.personelKayitlari);
  $$SalonBolumKayitlariTableTableManager get salonBolumKayitlari =>
      $$SalonBolumKayitlariTableTableManager(_db, _db.salonBolumKayitlari);
  $$MasaKayitlariTableTableManager get masaKayitlari =>
      $$MasaKayitlariTableTableManager(_db, _db.masaKayitlari);
  $$HammaddeKayitlariTableTableManager get hammaddeKayitlari =>
      $$HammaddeKayitlariTableTableManager(_db, _db.hammaddeKayitlari);
  $$StokAlarmGecmisKayitlariTableTableManager get stokAlarmGecmisKayitlari =>
      $$StokAlarmGecmisKayitlariTableTableManager(
        _db,
        _db.stokAlarmGecmisKayitlari,
      );
  $$ReceteKalemKayitlariTableTableManager get receteKalemKayitlari =>
      $$ReceteKalemKayitlariTableTableManager(_db, _db.receteKalemKayitlari);
}
