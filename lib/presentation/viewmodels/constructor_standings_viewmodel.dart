import 'package:f1_fanhub/domain/entities/standing.dart';
import 'package:f1_fanhub/domain/usecases/get_constructor_standings_usecase.dart';
import 'package:flutter/material.dart';

class ConstructorStandingsViewModel extends ChangeNotifier {
  final GetConstructorStandingsUseCase _getConstructorStandingsUseCase;

  ConstructorStandingsViewModel(this._getConstructorStandingsUseCase);

  // Estado
  List<ConstructorStanding> constructors = [];
  bool isLoading = false;
  String? errorMessage;

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
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      constructors = await _getConstructorStandingsUseCase(forceUpdate: force);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
