import 'package:f1_fanhub/data/datasources/remote/driver_stats_remote_datasource.dart';
import 'package:f1_fanhub/domain/entities/driver_result_progression.dart';
import 'package:f1_fanhub/domain/repositories/driver_stats_repository.dart';

class DriverStatsRepositoryImpl implements DriverStatsRepository {
  final DriverStatsRemoteDataSource remoteDataSource;

  DriverStatsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<DriverRaceProgression>> getSeasonProgression(
    String driverId,
  ) async {
    try {
      return await remoteDataSource.fetchSeasonResults(driverId);
    } catch (e) {
      throw Exception('Error al obtener la progresión del piloto: $e');
    }
  }
}
