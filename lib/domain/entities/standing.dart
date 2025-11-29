class DriverStanding {
  final String position;
  final String points;
  final String wins;
  final Driver driver;
  final Constructor constructor; // Equipo principal

  DriverStanding({
    required this.position,
    required this.points,
    required this.wins,
    required this.driver,
    required this.constructor,
  });
}

class ConstructorStanding {
  final String position;
  final String points;
  final String wins;
  final Constructor constructor;

  ConstructorStanding({
    required this.position,
    required this.points,
    required this.wins,
    required this.constructor,
  });
}

// Sub-entidades necesarias
class Driver {
  final String id;
  final String code; // Ej. "VER"
  final String number;
  final String givenName;
  final String familyName;
  final String nationality;

  Driver({
    required this.id,
    required this.code,
    required this.number,
    required this.givenName,
    required this.familyName,
    required this.nationality,
  });
}

class Constructor {
  final String id;
  final String name; // Ej. "McLaren"
  final String nationality;

  Constructor({
    required this.id,
    required this.name,
    required this.nationality,
  });
}
