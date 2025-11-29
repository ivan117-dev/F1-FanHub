import 'package:dio/dio.dart';
import 'package:f1_fanhub/core/errors/exceptions.dart';
import 'package:f1_fanhub/domain/entities/race.dart';
import 'package:f1_fanhub/domain/repositories/race_repository.dart';
import 'package:f1_fanhub/data/datasources/remote/race_remote_datasource.dart';
import 'package:f1_fanhub/data/datasources/local/race_local_datasource.dart';

class RaceRepositoryImpl implements RaceRepository {
  final RaceRemoteDataSource remoteDataSource;
  final RaceLocalDataSource localDataSource;

  RaceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Race>> getCurrentSeasonRaces({bool forceUpdate = false}) async {
    // ESTRATEGIA: Cache First (con expiración)

    // 1. Preguntamos: ¿Hay caché y es válido?
    if (!forceUpdate && localDataSource.isCacheValid()) {
      try {
        final localRaces = await localDataSource.getLastRaces();
        return localRaces;
      } on CacheException {
        // <--- Capturamos específicamente CacheException
        // Si no hay caché, no pasa nada grave, solo seguimos el flujo normal
      } catch (e) {
        // Si falla leer el caché, seguimos al remoto sin romper nada
      }
    }

    // 2. Si no hay caché válido, vamos a la red
    try {
      final remoteRaces = await remoteDataSource.getCurrentRaces();

      // 3. ¡Importante! Guardamos lo nuevo en caché para la próxima
      localDataSource.cacheRaces(remoteRaces);

      return remoteRaces;
      // ignore: unused_catch_clause
    } on DioException catch (e) {
      // 4. Si falla la red (ej. sin internet), intentamos mostrar el caché viejo como respaldo
      // aunque haya expirado, es mejor que mostrar un error vacío.
      try {
        return await localDataSource.getLastRaces();
      } catch (_) {
        // Si no hay red y tampoco caché, lanzamos el error original
        throw ServerException("No hay conexión y no hay datos guardados.");
      }
    }
  }
}
