import 'package:f1_fanhub/data/datasources/local/results_local_datasource.dart';
import 'package:f1_fanhub/data/datasources/local/standings_local_datasource.dart';
import 'package:f1_fanhub/data/datasources/local/race_local_datasource.dart';
import 'package:f1_fanhub/data/datasources/remote/driver_stats_remote_datasource.dart';
import 'package:f1_fanhub/data/datasources/remote/results_remote_datasource.dart';
import 'package:f1_fanhub/data/datasources/remote/standings_remote_datasource.dart';
import 'package:f1_fanhub/data/datasources/remote/race_remote_datasource.dart';
import 'package:f1_fanhub/data/repositories/driver_stats_repository_impl.dart';
import 'package:f1_fanhub/data/repositories/race_repository_impl.dart';
import 'package:f1_fanhub/data/repositories/results_repository_impl.dart';
import 'package:f1_fanhub/data/repositories/standings_repository_impl.dart';
import 'package:f1_fanhub/domain/repositories/driver_stats_repository.dart';
import 'package:f1_fanhub/domain/repositories/race_repository.dart';
import 'package:f1_fanhub/domain/repositories/results_repository.dart';
import 'package:f1_fanhub/domain/repositories/standings_repository.dart';
import 'package:f1_fanhub/domain/usecases/get_constructor_standings_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_current_races_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_driver_season_progression_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_driver_standings_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_pit_stops_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_qualifying_results_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_race_results_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_sprint_results_usecase.dart';
import 'package:f1_fanhub/presentation/viewmodels/calendar_viewmodel.dart';
import 'package:f1_fanhub/presentation/viewmodels/constructor_standings_viewmodel.dart';
import 'package:f1_fanhub/presentation/viewmodels/driver_detail_viewmodel.dart';
import 'package:f1_fanhub/presentation/viewmodels/driver_standings_viewmodel.dart';
import 'package:f1_fanhub/core/network/dio_client.dart';
import 'package:f1_fanhub/presentation/viewmodels/home_viewmodel.dart';
import 'package:f1_fanhub/presentation/viewmodels/race_results_viewmodel.dart';
import 'package:f1_fanhub/presentation/viewmodels/theme_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Instancia global del locator
final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1. External (Librerías de terceros)
  // SharedPreferences requiere await, por eso el setup es async
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // DioClient
  sl.registerLazySingleton(() => DioClient());

  // 2. Data Sources
  // Remote
  sl.registerLazySingleton<RaceRemoteDataSource>(
    () => RaceRemoteDataSource(sl<DioClient>().dio),
  );
  sl.registerLazySingleton(
    () => StandingsRemoteDataSource(sl<DioClient>().dio),
  );
  sl.registerLazySingleton(() => ResultsRemoteDataSource(sl<DioClient>().dio));
  sl.registerLazySingleton(
    () => DriverStatsRemoteDataSource(sl<DioClient>().dio),
  );

  // Local
  sl.registerLazySingleton<RaceLocalDataSource>(
    () => RaceLocalDataSource(sl()),
  );
  sl.registerLazySingleton(() => StandingsLocalDataSource(sl()));
  sl.registerLazySingleton(() => ResultsLocalDataSource(sl()));

  // 3. Repository
  // Registramos la interfaz (RaceRepository) para que devuelva la implementación
  sl.registerLazySingleton<RaceRepository>(
    () => RaceRepositoryImpl(
      remoteDataSource: sl(), // sl() busca RaceRemoteDataSource
      localDataSource: sl(), // sl() busca RaceLocalDataSource
    ),
  );
  sl.registerLazySingleton<StandingsRepository>(
    () => StandingsRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<ResultsRepository>(
    () => ResultsRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<DriverStatsRepository>(
    () => DriverStatsRepositoryImpl(sl()),
  );

  // 4. Use Cases
  sl.registerLazySingleton(() => GetCurrentRacesUseCase(sl()));
  sl.registerLazySingleton(() => GetDriverStandingsUseCase(sl()));
  sl.registerLazySingleton(() => GetConstructorStandingsUseCase(sl()));
  sl.registerLazySingleton(() => GetRaceResultsUseCase(sl()));
  sl.registerLazySingleton(() => GetQualifyingResultsUseCase(sl()));
  sl.registerLazySingleton(() => GetSprintResultsUseCase(sl()));
  sl.registerLazySingleton(() => GetPitStopsUseCase(sl()));
  sl.registerLazySingleton(() => GetDriverSeasonProgressionUseCase(sl()));

  // 4. ViewModels
  // Usamos 'registerFactory' para que cree una instancia nueva cada vez que se pida
  sl.registerFactory(() => CalendarViewModel(sl()));
  sl.registerFactory(() => DriverStandingsViewModel(sl()));
  sl.registerFactory(() => ConstructorStandingsViewModel(sl()));
  sl.registerFactory(() => RaceResultsViewModel(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => HomeViewModel(sl(), sl(), sl(), sl()));
  sl.registerFactoryParam<DriverDetailViewModel, String, void>(
    (driverId, _) => DriverDetailViewModel(sl(), driverId),
  );
  sl.registerFactory(() => ThemeViewModel(sl()));
}
