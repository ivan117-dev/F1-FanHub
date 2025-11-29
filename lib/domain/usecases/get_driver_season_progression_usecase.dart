import 'package:f1_fanhub/domain/entities/driver_result_progression.dart';
import 'package:f1_fanhub/domain/repositories/driver_stats_repository.dart';

class GetDriverSeasonProgressionUseCase {
  final DriverStatsRepository repository;
  GetDriverSeasonProgressionUseCase(this.repository);

  Future<List<DriverRaceProgression>> call(String driverId) {
    return repository.getSeasonProgression(driverId);
  }
}
