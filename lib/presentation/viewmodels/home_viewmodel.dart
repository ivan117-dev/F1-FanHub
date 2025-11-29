import 'package:f1_fanhub/domain/entities/race.dart';
import 'package:f1_fanhub/domain/entities/race_result.dart';
import 'package:f1_fanhub/domain/entities/standing.dart';
import 'package:f1_fanhub/domain/usecases/get_constructor_standings_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_current_races_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_driver_standings_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_race_results_usecase.dart';
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

  bool isLoading = true;
  String? errorMessage;

  Race? nextRace;
  Race? lastRace; // Para mostrar quién ganó la anterior
  RaceResult? lastRaceWinner;
  List<DriverStanding> topDrivers = [];
  List<ConstructorStanding> topConstructors = [];

  Future<void> loadDashboard() async {
    isLoading = true;
    notifyListeners();

    try {
      // 1. Ejecutamos las 3 peticiones en paralelo para que cargue rápido
      final results = await Future.wait([
        _getRacesUseCase(),
        _getDriversUseCase(),
        _getConstructorsUseCase(),
      ]);

      final allRaces = results[0] as List<Race>;
      final allDrivers = results[1] as List<DriverStanding>;
      final allConstructors = results[2] as List<ConstructorStanding>;

      // 2. Lógica para encontrar la Próxima Carrera
      final now = DateTime.now();
      int nextRaceIndex = -1;

      try {
        // Encontramos la carrera y guardamos su índice
        nextRace = allRaces.firstWhere((race) {
          final raceDate = DateTime.parse(
            race.date,
          ).add(const Duration(hours: 4));
          return raceDate.isAfter(now);
        });
        nextRaceIndex = allRaces.indexOf(nextRace!);
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
          final results = await _getRaceResultsUseCase(lastRace!.id);
          if (results.isNotEmpty) {
            // El primero de la lista siempre es el ganador (Posición 1)
            lastRaceWinner = results.first;
          }
        } catch (e) {
          debugPrint("No se pudo cargar el ganador: $e");
        }
      }

      // 3. Top 5 Drivers y Constructores
      topDrivers = allDrivers.take(5).toList();
      topConstructors = allConstructors.take(5).toList();
    } catch (e) {
      errorMessage = "Error cargando el dashboard: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
