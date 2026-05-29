import 'package:f1_fanhub/domain/entities/standing.dart';
import 'package:f1_fanhub/domain/usecases/get_driver_standings_usecase.dart';
import 'package:f1_fanhub/presentation/common/view_state.dart';
import 'package:flutter/material.dart';

class DriverStandingsViewModel extends ChangeNotifier {
  final GetDriverStandingsUseCase _getDriverStandingsUseCase;

  DriverStandingsViewModel(this._getDriverStandingsUseCase);

  ViewState<List<DriverStanding>> state = const ViewState.idle();

  // Carga inicial (intenta usar caché primero)
  Future<void> loadStandings() async {
    await _loadData(force: false);
  }

  // Refrescar datos (fuerza la actualización desde la API)
  Future<void> refreshStandings() async {
    await _loadData(force: true);
  }

  // Lógica centralizada
  Future<void> _loadData({required bool force}) async {
    state = const ViewState.loading();
    notifyListeners();

    try {
      // Llamamos al UseCase (que ya maneja la lógica de repo/caché)
      final result = await _getDriverStandingsUseCase(forceUpdate: force);
      result.when(
        success: (data) {
          if (data.isEmpty) {
            state = const ViewState.empty('Sin datos de pilotos.');
          } else {
            state = ViewState.success(data);
          }
        },
        failure: (failure) {
          state = ViewState.error(failure.message);
        },
      );
    } catch (e) {
      state = ViewState.error(e.toString());
    }
    notifyListeners();
  }
}
