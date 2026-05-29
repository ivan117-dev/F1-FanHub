import 'package:dio/dio.dart';
import 'package:f1_fanhub/core/errors/exceptions.dart';
import 'package:f1_fanhub/data/datasources/local/standings_local_datasource.dart';
import 'package:f1_fanhub/data/datasources/remote/standings_remote_datasource.dart';
import 'package:f1_fanhub/data/utils/failure_mapper.dart';
import 'package:f1_fanhub/domain/common/result.dart';
import 'package:f1_fanhub/domain/entities/standing.dart';
import 'package:f1_fanhub/domain/repositories/standings_repository.dart';

class StandingsRepositoryImpl implements StandingsRepository {
  final StandingsRemoteDataSource remoteDataSource;
  final StandingsLocalDataSource localDataSource;

  StandingsRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Result<List<DriverStanding>>> getDriverStandings({
    bool forceUpdate = false,
  }) async {
    // 1. Verificar caché (con lógica de fin de semana)
    if (!forceUpdate && localDataSource.isCacheValid(driversTimestamp)) {
      try {
        final cached = await localDataSource.getLastDriverStandings();
        return Result.success(cached);
      } on CacheException {
        // <--- Capturamos específicamente CacheException
        // Si no hay caché, no pasa nada grave, solo seguimos el flujo normal
      }
    }

    // 2. Buscar remoto
    try {
      final remoteData = await remoteDataSource.getDriverStandings();
      localDataSource.cacheDriverStandings(remoteData);
      return Result.success(remoteData);
    } on DioException catch (e) {
      try {
        final cached = await localDataSource.getLastDriverStandings();
        return Result.success(cached);
      } catch (_) {
        return Result.failure(mapExceptionToFailure(e));
      }
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<ConstructorStanding>>> getConstructorStandings({
    bool forceUpdate = false,
  }) async {
    // Misma lógica para constructores
    if (!forceUpdate && localDataSource.isCacheValid(constructorsTimestamp)) {
      try {
        final cached = await localDataSource.getLastConstructorStandings();
        return Result.success(cached);
      } on CacheException {
        // <--- Capturamos específicamente CacheException
        // Si no hay caché, no pasa nada grave, solo seguimos el flujo normal
      }
    }

    try {
      final remoteData = await remoteDataSource.getConstructorStandings();
      localDataSource.cacheConstructorStandings(remoteData);
      return Result.success(remoteData);
    } on DioException catch (e) {
      try {
        final cached = await localDataSource.getLastConstructorStandings();
        return Result.success(cached);
      } catch (_) {
        return Result.failure(mapExceptionToFailure(e));
      }
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }
}
