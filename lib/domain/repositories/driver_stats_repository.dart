import 'package:f1_fanhub/domain/entities/driver_result_progression.dart';

abstract class DriverStatsRepository {
  Future<List<DriverRaceProgression>> getSeasonProgression(String driverId);
}
