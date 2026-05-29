import 'package:f1_fanhub/domain/common/result.dart';
import 'package:f1_fanhub/domain/entities/race.dart';
import 'package:f1_fanhub/domain/entities/race_result.dart';
import 'package:f1_fanhub/domain/entities/standing.dart';
import 'package:f1_fanhub/domain/usecases/get_constructor_standings_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_current_races_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_driver_standings_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_race_results_usecase.dart';
import 'package:f1_fanhub/presentation/common/view_state.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final GetCurrentRacesUseCase _getRacesUseCase;
  final GetDriverStandingsUseCase _getDriversUseCase;
  final GetConstructorStandingsUseCase _getConstructorsUseCase;
  final GetRaceResultsUseCase _getRaceResultsUseCase;

  HomeViewModel(
    this._getRacesUseCase,
    this._getDriversUseCase,
    this._getConstructorsUseCase,
    this._getRaceResultsUseCase,
  );

  ViewState<HomeDashboard> state = const ViewState.idle();

  Future<void> loadDashboard() async {
    state = const ViewState.loading();
    notifyListeners();

    try {
      // 1. Ejecutamos las 3 peticiones en paralelo para que cargue rápido
      final results = await Future.wait([
        _getRacesUseCase(),
        _getDriversUseCase(),
        _getConstructorsUseCase(),
      ]);

      final racesResult = results[0] as Result<List<Race>>;
      final driversResult = results[1] as Result<List<DriverStanding>>;
      final constructorsResult =
          results[2] as Result<List<ConstructorStanding>>;

      List<Race> allRaces = [];
      List<DriverStanding> allDrivers = [];
      List<ConstructorStanding> allConstructors = [];

      String? failureMessage;
      racesResult.when(
        success: (data) => allRaces = data,
        failure: (failure) => failureMessage = failure.message,
      );
      if (failureMessage != null) {
        state = ViewState.error(failureMessage!);
        notifyListeners();
        return;
      }

      driversResult.when(
        success: (data) => allDrivers = data,
        failure: (failure) => failureMessage = failure.message,
      );
      if (failureMessage != null) {
        state = ViewState.error(failureMessage!);
        notifyListeners();
        return;
      }

      constructorsResult.when(
        success: (data) => allConstructors = data,
        failure: (failure) => failureMessage = failure.message,
      );
      if (failureMessage != null) {
        state = ViewState.error(failureMessage!);
        notifyListeners();
        return;
      }

      // 2. Lógica para encontrar la Próxima Carrera
      final now = DateTime.now();
      int nextRaceIndex = -1;

      Race? nextRace;
      Race? lastRace;
      RaceResult? lastRaceWinner;

      try {
        // Encontramos la carrera y guardamos su índice
        nextRace = allRaces.firstWhere((race) {
          final raceDate = DateTime.parse(
            race.date,
          ).add(const Duration(hours: 4));
          return raceDate.isAfter(now);
        });
        nextRaceIndex = allRaces.indexOf(nextRace);
      } catch (e) {
        // Si no encuentra (fin de temporada), nextRace es null
        nextRace = null;
        nextRaceIndex = -1;
      }

      // --- LÓGICA PARA LA CARRERA ANTERIOR (lastRace) ---
      if (nextRaceIndex > 0) {
        // Si la próxima es la 5, la anterior es la 4
        lastRace = allRaces[nextRaceIndex - 1];
      } else if (nextRaceIndex == -1 && allRaces.isNotEmpty) {
        // Si ya no hay próxima (fin de temporada), la última fue la final
        lastRace = allRaces.last;
      } else {
        // Si la próxima es la primera (índice 0), no hay anterior
        lastRace = null;
      }

      // --- NUEVA LÓGICA: BUSCAR AL GANADOR ---
      if (lastRace != null) {
        try {
          // Pedimos los resultados de esa ronda específica
          final results = await _getRaceResultsUseCase(lastRace.id);
          results.when(
            success: (data) {
              if (data.isNotEmpty) {
                // El primero de la lista siempre es el ganador (Posición 1)
                lastRaceWinner = data.first;
              }
            },
            failure: (failure) {
              debugPrint("No se pudo cargar el ganador: ${failure.message}");
            },
          );
        } catch (e) {
          debugPrint("No se pudo cargar el ganador: $e");
        }
      }

      // 3. Top 5 Drivers y Constructores
      final topDrivers = allDrivers.take(5).toList();
      final topConstructors = allConstructors.take(5).toList();

      if (allRaces.isEmpty && allDrivers.isEmpty && allConstructors.isEmpty) {
        state = const ViewState.empty('No hay datos del dashboard.');
      } else {
        state = ViewState.success(
          HomeDashboard(
            nextRace: nextRace,
            lastRace: lastRace,
            lastRaceWinner: lastRaceWinner,
            topDrivers: topDrivers,
            topConstructors: topConstructors,
          ),
        );
      }
    } catch (e) {
      state = ViewState.error("Error cargando el dashboard: $e");
    }
    notifyListeners();
  }
}

class HomeDashboard {
  final Race? nextRace;
  final Race? lastRace;
  final RaceResult? lastRaceWinner;
  final List<DriverStanding> topDrivers;
  final List<ConstructorStanding> topConstructors;

  HomeDashboard({
    required this.nextRace,
    required this.lastRace,
    required this.lastRaceWinner,
    required this.topDrivers,
    required this.topConstructors,
  });
}
