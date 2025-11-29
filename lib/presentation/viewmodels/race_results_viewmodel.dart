import 'package:f1_fanhub/domain/entities/pit_stop.dart';
import 'package:f1_fanhub/domain/entities/qualifying_result.dart';
import 'package:f1_fanhub/domain/entities/race_result.dart';
import 'package:f1_fanhub/domain/usecases/get_pit_stops_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_qualifying_results_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_race_results_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_sprint_results_usecase.dart';
import 'package:flutter/material.dart';

class RaceResultsViewModel extends ChangeNotifier {
  final GetRaceResultsUseCase _getRaceResults;
  final GetQualifyingResultsUseCase _getQualifyingResults;
  final GetSprintResultsUseCase _getSprintResults;
  final GetPitStopsUseCase _getPitStops;

  RaceResultsViewModel(
    this._getRaceResults,
    this._getQualifyingResults,
    this._getSprintResults,
    this._getPitStops,
  );

  // Estados
  bool isLoading = false;
  String? errorMessage;

  // Datos
  List<RaceResult> raceResults = [];
  List<QualifyingResult> qualifyingResults = [];
  List<RaceResult> sprintResults = [];
  List<PitStop> pitStops = [];

  // Método principal que llamará la UI al iniciar
  Future<void> loadResults(String round) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Hacemos las peticiones en paralelo para ganar velocidad
      final results = await Future.wait([
        _getRaceResults(round),
        _getQualifyingResults(round),
        _getSprintResults(round),
        _getPitStops(round),
      ]);

      // Asignamos resultados
      raceResults = results[0] as List<RaceResult>;
      qualifyingResults = results[1] as List<QualifyingResult>;
      sprintResults = results[2] as List<RaceResult>;
      pitStops = results[3] as List<PitStop>;
    } catch (e) {
      errorMessage =
          "No se pudieron cargar los resultados o la carrera aún no ocurre.";
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
