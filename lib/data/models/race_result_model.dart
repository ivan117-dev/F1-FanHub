import 'package:f1_fanhub/domain/entities/race_result.dart';
import 'package:f1_fanhub/domain/entities/standing.dart';

class RaceResultModel extends RaceResult {
  RaceResultModel({
    required super.position,
    required super.points,
    required super.driver,
    required super.constructor,
    required super.timeOrStatus,
    super.fastestLapTime,
    super.fastestLapRank,
  });

  factory RaceResultModel.fromJson(Map<String, dynamic> json) {
    final driverJson = json['Driver'];
    final constructorJson = json['Constructor'];

    // Lógica para el tiempo/estado
    String finalTimeOrStatus = json['savedTime'] ?? json['status'];
    if (json['savedTime'] == null &&
        json['Time'] != null &&
        json['Time']['time'] != null) {
      finalTimeOrStatus = json['Time']['time'];
    }

    return RaceResultModel(
      position: json['position'],
      points: json['points'],
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
      timeOrStatus: finalTimeOrStatus,

      // 2. ¡IMPORTANTE! Lectura híbrida (API vs Caché)
      // Si viene del caché (plano) usa 'fastestLapTime'.
      // Si viene de la API (anidado) busca dentro de ['FastestLap']['Time'].
      fastestLapTime:
          json['fastestLapTime'] ?? json['FastestLap']?['Time']?['time'],

      // Lo mismo para el rank. Si borraste la parte de la derecha (json['FastestLap']...),
      // la app deja de leer el dato cuando viene de internet.
      fastestLapRank: json['fastestLapRank'] ?? json['FastestLap']?['rank'],
    );
  }

  // 3. ¡IMPORTANTE! Guardado en Caché
  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'points': points,
      'savedTime': timeOrStatus,

      // Asegúrate de que estas dos líneas existan para guardar el dato
      'fastestLapTime': fastestLapTime,
      'fastestLapRank': fastestLapRank,

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
