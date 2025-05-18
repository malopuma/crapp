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
    this.year
  });

  // Factory constructor to create a CrystalInfo instance from a JSON map
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
      year: json['year']
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
    ----------------------------------
    ''';
  }
}