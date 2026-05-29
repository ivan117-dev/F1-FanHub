import 'package:f1_fanhub/domain/common/result.dart';
import 'package:f1_fanhub/domain/entities/driver_result_progression.dart';

abstract class DriverStatsRepository {
  Future<Result<List<DriverRaceProgression>>> getSeasonProgression(
    String driverId,
  );
}
