import 'package:f1_fanhub/domain/entities/qualifying_result.dart';
import 'package:f1_fanhub/domain/entities/standing.dart';

class QualifyingResultModel extends QualifyingResult {
  QualifyingResultModel({
    required super.position,
    required super.driver,
    required super.constructor,
    required super.q1,
    super.q2,
    super.q3,
  });

  factory QualifyingResultModel.fromJson(Map<String, dynamic> json) {
    final driverJson = json['Driver'];
    final constructorJson = json['Constructor'];

    return QualifyingResultModel(
      position: json['position'],
      driver: Driver(
        id: driverJson['driverId'],
        code: driverJson['code'] ?? '',
        number: driverJson['permanentNumber'] ?? '',
        givenName: driverJson['givenName'],
        familyName: driverJson['familyName'],
        nationality: driverJson['nationality'],
      ),
      constructor: Constructor(
        id: constructorJson['constructorId'],
        name: constructorJson['name'],
        nationality: constructorJson['nationality'],
      ),
      q1: json['Q1'] ?? '-', // A veces si chocan en práctica no marcan tiempo
      q2: json['Q2'],
      q3: json['Q3'],
    );
  }

  // -- MÉTODO toJson (Para guardar en caché) ---
  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'Q1': q1,
      'Q2': q2,
      'Q3': q3,
      'Driver': {
        'driverId': driver.id,
        'code': driver.code,
        'permanentNumber': driver.number,
        'givenName': driver.givenName,
        'familyName': driver.familyName,
        'nationality': driver.nationality,
      },
      'Constructor': {
        'constructorId': constructor.id,
        'name': constructor.name,
        'nationality': constructor.nationality,
      },
    };
  }
}
