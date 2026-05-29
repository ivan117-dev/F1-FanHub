import 'package:f1_fanhub/data/datasources/remote/driver_stats_remote_datasource.dart';
import 'package:f1_fanhub/data/utils/failure_mapper.dart';
import 'package:f1_fanhub/domain/common/result.dart';
import 'package:f1_fanhub/domain/entities/driver_result_progression.dart';
import 'package:f1_fanhub/domain/repositories/driver_stats_repository.dart';

class DriverStatsRepositoryImpl implements DriverStatsRepository {
  final DriverStatsRemoteDataSource remoteDataSource;

  DriverStatsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<DriverRaceProgression>>> getSeasonProgression(
    String driverId,
  ) async {
    try {
      final results = await remoteDataSource.fetchSeasonResults(driverId);
      return Result.success(results);
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }
}
