import 'package:flutter/material.dart';
import 'package:f1_fanhub/domain/entities/race.dart';
import 'package:f1_fanhub/domain/usecases/get_current_races_usecase.dart';
import 'package:f1_fanhub/presentation/common/view_state.dart';

class CalendarViewModel extends ChangeNotifier {
  final GetCurrentRacesUseCase getCurrentRacesUseCase;

  CalendarViewModel(this.getCurrentRacesUseCase);

  ViewState<List<Race>> state = const ViewState.idle();

  // Método normal (usa caché si existe)
  Future<void> getSchedule() async {
    await _loadData(force: false);
  }

  // Método para forzar actualización (Pull-to-Refresh)
  Future<void> refreshSchedule() async {
    await _loadData(force: true);
  }

  // Lógica centralizada privada
  Future<void> _loadData({required bool force}) async {
    state = const ViewState.loading();
    notifyListeners();

    try {
      // Pasamos el parámetro force al repositorio
      final result = await getCurrentRacesUseCase(forceUpdate: force);
      result.when(
        success: (data) {
          if (data.isEmpty) {
            state = const ViewState.empty('No hay carreras disponibles.');
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
