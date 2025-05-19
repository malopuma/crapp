// lib/crystal_info.dart

class CrystalInfo {
  final String codId;         // From "file"
  final String? chemicalName; // From "chemname"
  final String? mineral;
  final String? spaceGroup;   // From "sg"
  final String? a;
  final String? b;
  final String? c;
  final String? alpha;
  final String? beta;
  final String? gamma;
  final String? title;
  final String? doi;
  final String? year;

  // New User-Editable Fields
  String? crystalSystem;
  String? solubility;
  String? cleavagePlanes;
  String? appearance;
  double? laueExposureTime; // Changed to double for numerical value

  CrystalInfo({
    required this.codId,
    this.chemicalName,
    this.mineral,
    this.spaceGroup,
    this.a,
    this.b,
    this.c,
    this.alpha,
    this.beta,
    this.gamma,
    this.title,
    this.doi,
    this.year,
    // Initialize new fields
    this.crystalSystem,
    this.solubility,
    this.cleavagePlanes,
    this.appearance,
    this.laueExposureTime,
  });

  // Factory constructor to create a CrystalInfo instance from a JSON map (from COD)
  // This constructor will primarily populate fields from the COD database.
  factory CrystalInfo.fromJson(Map<String, dynamic> json) {
    return CrystalInfo(
      codId: json['file'] ?? 'N/A', // 'file' is the key for COD ID
      chemicalName: json['chemname'],
      mineral: json['mineral'],
      spaceGroup: json['sg'],
      a: json['a'],
      b: json['b'],
      c: json['c'],
      alpha: json['alpha'],
      beta: json['beta'],
      gamma: json['gamma'],
      title: json['title'],
      doi: json['doi'],
      year: json['year'],
      
      // New fields will typically be null when fetched from COD
      crystalSystem: null,
      solubility: null,
      cleavagePlanes: null,
      appearance: null,
      laueExposureTime: null,
    );
  }

  // --- IMPORTANT NEW PART FOR DATABASE INTERACTION ---
  // Method to convert a CrystalInfo instance into a Map for database insertion/update
  // This is crucial for sqflite.
  Map<String, dynamic> toMap() {
    return {
      'codId': codId,
      'chemicalName': chemicalName,
      'mineral': mineral,
      'spaceGroup': spaceGroup,
      'a': a,
      'b': b,
      'c': c,
      'alpha': alpha,
      'beta': beta,
      'gamma': gamma,
      'title': title,
      'doi': doi,
      'year': year,
      
      // Include new user-editable fields
      'crystalSystem': crystalSystem,
      'solubility': solubility,
      'cleavagePlanes': cleavagePlanes,
      'appearance': appearance,
      'laueExposureTime': laueExposureTime,
    };
  }

  // Factory constructor to create a CrystalInfo instance from a Map (from database)
  // This is crucial for sqflite to read data back.
  factory CrystalInfo.fromMap(Map<String, dynamic> map) {
    return CrystalInfo(
      codId: map['codId'],
      chemicalName: map['chemicalName'],
      mineral: map['mineral'],
      spaceGroup: map['spaceGroup'],
      a: map['a'],
      b: map['b'],
      c: map['c'],
      alpha: map['alpha'],
      beta: map['beta'],
      gamma: map['gamma'],
      title: map['title'],
      doi: map['doi'],
      year: map['year'],

      // Populate new user-editable fields from the database map
      crystalSystem: map['crystalSystem'],
      solubility: map['solubility'],
      cleavagePlanes: map['cleavagePlanes'],
      appearance: map['appearance'],
      laueExposureTime: map['laueExposureTime'],
    );
  }

  // Override toString for easy printing of CrystalInfo objects
  @override
  String toString() {
    return '''
    ----------------------------------
    Crystal ID: $codId
    Chemical Name: ${chemicalName ?? 'N/A'}
    Mineral: ${mineral ?? 'N/A'}
    Space Group: ${spaceGroup ?? 'N/A'}
    Cell Parameters:
      a: ${a ?? 'N/A'}, b: ${b ?? 'N/A'}, c: ${c ?? 'N/A'}
      alpha: ${alpha ?? 'N/A'}, beta: ${beta ?? 'N/A'}, gamma: ${gamma ?? 'N/A'}
    Title: ${title ?? 'N/A'}
    DOI: ${doi ?? 'N/A'}
    Year: ${year ?? 'N/A'}
    --- User Notes ---
    Crystal System: ${crystalSystem ?? 'N/A'}
    Solubility: ${solubility ?? 'N/A'}
    Cleavage Planes: ${cleavagePlanes ?? 'N/A'}
    Appearance: ${appearance ?? 'N/A'}
    Laue Exposure Time: ${laueExposureTime != null ? '${laueExposureTime} units' : 'N/A'}
    ----------------------------------
    ''';
  }
}