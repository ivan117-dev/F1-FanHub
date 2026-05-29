import 'package:f1_fanhub/core/errors/exceptions.dart';
import 'package:f1_fanhub/data/datasources/local/results_local_datasource.dart';
import 'package:f1_fanhub/data/datasources/remote/results_remote_datasource.dart';
import 'package:f1_fanhub/data/utils/failure_mapper.dart';
import 'package:f1_fanhub/domain/common/result.dart';
import 'package:f1_fanhub/domain/entities/pit_stop.dart';
import 'package:f1_fanhub/domain/entities/qualifying_result.dart';
import 'package:f1_fanhub/domain/entities/race_result.dart';
import 'package:f1_fanhub/domain/repositories/results_repository.dart';

class ResultsRepositoryImpl implements ResultsRepository {
  final ResultsRemoteDataSource remoteDataSource;
  final ResultsLocalDataSource localDataSource;

  ResultsRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Result<List<RaceResult>>> getRaceResults(String round) async {
    // 1. Intento leer del caché
    try {
      final cached = await localDataSource.getRaceResults(round);
      return Result.success(cached);
    } on CacheException {
      // Fallo silencioso, vamos a la red
    }

    // 2. Llamada a la API
    try {
      final remoteResults = await remoteDataSource.fetchRaceResults(round);

      // 3. Solo cachéamos si hay datos (la carrera ya pasó)
      if (remoteResults.isNotEmpty) {
        localDataSource.cacheRaceResults(round, remoteResults);
      }

      return Result.success(remoteResults);
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<QualifyingResult>>> getQualifyingResults(
    String round,
  ) async {
    try {
      final cached = await localDataSource.getQualifyingResults(round);
      return Result.success(cached);
    } on CacheException {
      // Continuar
    }

    try {
      final remoteResults = await remoteDataSource.fetchQualifyingResults(
        round,
      );
      if (remoteResults.isNotEmpty) {
        localDataSource.cacheQualifyingResults(round, remoteResults);
      }
      return Result.success(remoteResults);
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<RaceResult>>> getSprintResults(String round) async {
    try {
      final cached = await localDataSource.getSprintResults(round);
      return Result.success(cached);
    } on CacheException {
      // Continuar
    }

    try {
      final remoteResults = await remoteDataSource.fetchSprintResults(round);
      // Sprint es especial: A veces devuelve vacío porque NO hay sprint.
      // Aun así, si devuelve datos, los guardamos.
      if (remoteResults.isNotEmpty) {
        localDataSource.cacheSprintResults(round, remoteResults);
      }
      return Result.success(remoteResults);
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<PitStop>>> getPitStops(String round) async {
    try {
      final cached = await localDataSource.getPitStops(round);
      return Result.success(cached);
    } on CacheException {
      // Si no hay caché, continuamos a la red sin hacer nada
    }

    try {
      final remoteData = await remoteDataSource.fetchPitStops(round);

      if (remoteData.isNotEmpty) {
        localDataSource.cachePitStops(round, remoteData);
      }

      return Result.success(remoteData);
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }
}
