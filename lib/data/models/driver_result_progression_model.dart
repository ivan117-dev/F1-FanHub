import 'package:f1_fanhub/domain/entities/driver_result_progression.dart';

class DriverResultProgressionModel extends DriverRaceProgression {
  DriverResultProgressionModel({
    required super.raceName,
    required super.round,
    required super.position,
    required super.status,
  });

  static List<DriverResultProgressionModel> listFromJson(
    Map<String, dynamic> json,
  ) {
    // Validación básica
    if (json['MRData']['RaceTable']['Races'] == null) return [];

    final List<dynamic> racesJson = json['MRData']['RaceTable']['Races'];
    List<DriverResultProgressionModel> results = [];

    for (var race in racesJson) {
      final raceName = race['raceName'];
      final round = int.tryParse(race['round'] ?? '0') ?? 0;

      final resultList = race['Results'] as List<dynamic>?;

      if (resultList != null && resultList.isNotEmpty) {
        final result = resultList[0];
        final position = int.tryParse(result['position'] ?? '25') ?? 25;
        final status = result['status'] ?? 'Unknown';

        results.add(
          DriverResultProgressionModel(
            raceName: raceName,
            round: round,
            position: position,
            status: status,
          ),
        );
      }
    }
    return results;
  }
}
