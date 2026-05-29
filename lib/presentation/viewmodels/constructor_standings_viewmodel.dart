import 'package:f1_fanhub/domain/entities/standing.dart';
import 'package:f1_fanhub/domain/usecases/get_constructor_standings_usecase.dart';
import 'package:f1_fanhub/presentation/common/view_state.dart';
import 'package:flutter/material.dart';

class ConstructorStandingsViewModel extends ChangeNotifier {
  final GetConstructorStandingsUseCase _getConstructorStandingsUseCase;

  ConstructorStandingsViewModel(this._getConstructorStandingsUseCase);

  ViewState<List<ConstructorStanding>> state = const ViewState.idle();

  // Carga inicial
  Future<void> loadStandings() async {
    await _loadData(force: false);
  }

  // Refrescar datos
  Future<void> refreshStandings() async {
    await _loadData(force: true);
  }

  // Lógica centralizada
  Future<void> _loadData({required bool force}) async {
    state = const ViewState.loading();
    notifyListeners();

    try {
      final result = await _getConstructorStandingsUseCase(forceUpdate: force);
      result.when(
        success: (data) {
          if (data.isEmpty) {
            state = const ViewState.empty('Sin datos de constructores.');
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
