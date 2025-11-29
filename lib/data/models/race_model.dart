import 'package:f1_fanhub/domain/entities/race.dart';

class RaceModel extends Race {
  RaceModel({
    required super.id,
    required super.raceName,
    required super.date,
    required super.time,
    required super.circuitName,
    required super.locality,
    required super.country,
    super.firstPractice,
    super.secondPractice,
    super.thirdPractice,
    super.qualifying,
    super.sprint,
    super.sprintQualifying, // <--- No olvides pasarlo al super
  });

  // 1. LEER DE LA API (o del Caché)
  factory RaceModel.fromJson(Map<String, dynamic> json) {
    final circuit = json['Circuit'];
    final location = circuit['Location'];

    // Helper para parsear sesiones de forma segura
    Map<String, String>? parseSession(Map<String, dynamic>? sessionJson) {
      if (sessionJson == null) return null;
      return {
        'date': sessionJson['date']?.toString() ?? '',
        'time': sessionJson['time']?.toString() ?? '',
      };
    }

    return RaceModel(
      id: json['round'],
      raceName: json['raceName'],
      date: json['date'],
      time: json['time'] ?? '00:00:00Z',
      circuitName: circuit['circuitName'],
      locality: location['locality'],
      country: location['country'],

      // Mapeo de todas las sesiones según tu JSON
      firstPractice: parseSession(json['FirstPractice']),
      secondPractice: parseSession(json['SecondPractice']),
      thirdPractice: parseSession(json['ThirdPractice']),
      qualifying: parseSession(json['Qualifying']),
      sprint: parseSession(json['Sprint']),
      sprintQualifying: parseSession(
        json['SprintQualifying'],
      ), // <--- Lectura del JSON
    );
  }

  // 2. GUARDAR EN CACHÉ (Nuevo método necesario para Shared Preferences)
  Map<String, dynamic> toJson() {
    return {
      'round': id,
      'raceName': raceName,
      'date': date,
      'time': time,
      'Circuit': {
        'circuitName': circuitName,
        'Location': {'locality': locality, 'country': country},
      },
      // Guardamos todas las sesiones, incluyendo las de Sprint
      'FirstPractice': firstPractice,
      'SecondPractice': secondPractice,
      'ThirdPractice': thirdPractice,
      'Qualifying': qualifying,
      'Sprint': sprint,
      'SprintQualifying': sprintQualifying,
    };
  }
}
