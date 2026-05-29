import 'package:f1_fanhub/domain/common/result.dart';
import 'package:f1_fanhub/domain/entities/pit_stop.dart';
import 'package:f1_fanhub/domain/entities/qualifying_result.dart';
import 'package:f1_fanhub/domain/entities/race_result.dart';
import 'package:f1_fanhub/domain/usecases/get_pit_stops_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_qualifying_results_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_race_results_usecase.dart';
import 'package:f1_fanhub/domain/usecases/get_sprint_results_usecase.dart';
import 'package:f1_fanhub/presentation/common/view_state.dart';
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

  ViewState<RaceResultsData> state = const ViewState.idle();

  // Método principal que llamará la UI al iniciar
  Future<void> loadResults(String round) async {
    state = const ViewState.loading();
    notifyListeners();

    try {
      // Hacemos las peticiones en paralelo para ganar velocidad
      final results = await Future.wait([
        _getRaceResults(round),
        _getQualifyingResults(round),
        _getSprintResults(round),
        _getPitStops(round),
      ]);

      final raceResult = results[0] as Result<List<RaceResult>>;
      final qualifyingResult = results[1] as Result<List<QualifyingResult>>;
      final sprintResult = results[2] as Result<List<RaceResult>>;
      final pitStopResult = results[3] as Result<List<PitStop>>;

      String? failureMessage;
      List<RaceResult> raceResults = [];
      List<QualifyingResult> qualifyingResults = [];
      List<RaceResult> sprintResults = [];
      List<PitStop> pitStops = [];

      raceResult.when(
        success: (data) => raceResults = data,
        failure: (failure) => failureMessage ??= failure.message,
      );
      qualifyingResult.when(
        success: (data) => qualifyingResults = data,
        failure: (failure) => failureMessage ??= failure.message,
      );
      sprintResult.when(
        success: (data) => sprintResults = data,
        failure: (failure) => failureMessage ??= failure.message,
      );
      pitStopResult.when(
        success: (data) => pitStops = data,
        failure: (failure) => failureMessage ??= failure.message,
      );

      if (failureMessage != null) {
        state = ViewState.error(failureMessage!);
      } else if (raceResults.isEmpty && qualifyingResults.isEmpty) {
        state = const ViewState.empty('Resultados aun no disponibles.');
      } else {
        state = ViewState.success(
          RaceResultsData(
            raceResults: raceResults,
            qualifyingResults: qualifyingResults,
            sprintResults: sprintResults,
            pitStops: pitStops,
          ),
        );
      }
    } catch (e) {
      state = ViewState.error(
        "No se pudieron cargar los resultados o la carrera aun no ocurre.",
      );
      debugPrint(e.toString());
    }
    notifyListeners();
  }
}

class RaceResultsData {
  final List<RaceResult> raceResults;
  final List<QualifyingResult> qualifyingResults;
  final List<RaceResult> sprintResults;
  final List<PitStop> pitStops;

  RaceResultsData({
    required this.raceResults,
    required this.qualifyingResults,
    required this.sprintResults,
    required this.pitStops,
  });
}
