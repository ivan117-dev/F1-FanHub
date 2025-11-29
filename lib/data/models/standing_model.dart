import 'package:f1_fanhub/domain/entities/standing.dart';

class DriverStandingModel extends DriverStanding {
  DriverStandingModel({
    required super.position,
    required super.points,
    required super.wins,
    required super.driver,
    required super.constructor,
  });

  factory DriverStandingModel.fromJson(Map<String, dynamic> json) {
    final driverJson = json['Driver'];
    // El JSON trae una lista de constructores, tomamos el primero [cite: 126]
    final constructorJson = json['Constructors'][0];

    return DriverStandingModel(
      position: json['position'],
      points: json['points'],
      wins: json['wins'],
      driver: Driver(
        id: driverJson['driverId'],
        code: driverJson['code'] ?? '', // A veces rookie no tiene código
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
    );
  }

  // Para Caché
  Map<String, dynamic> toJson() => {
    'position': position,
    'points': points,
    'wins': wins,
    'Driver': {
      'driverId': driver.id,
      'code': driver.code,
      'permanentNumber': driver.number,
      'givenName': driver.givenName,
      'familyName': driver.familyName,
      'nationality': driver.nationality,
    },
    'Constructors': [
      {
        'constructorId': constructor.id,
        'name': constructor.name,
        'nationality': constructor.nationality,
      },
    ],
  };
}

class ConstructorStandingModel extends ConstructorStanding {
  ConstructorStandingModel({
    required super.position,
    required super.points,
    required super.wins,
    required super.constructor,
  });

  factory ConstructorStandingModel.fromJson(Map<String, dynamic> json) {
    final constJson = json['Constructor'];
    return ConstructorStandingModel(
      position: json['position'],
      points: json['points'],
      wins: json['wins'],
      constructor: Constructor(
        id: constJson['constructorId'],
        name: constJson['name'],
        nationality: constJson['nationality'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'position': position,
    'points': points,
    'wins': wins,
    'Constructor': {
      'constructorId': constructor.id,
      'name': constructor.name,
      'nationality': constructor.nationality,
    },
  };
}
