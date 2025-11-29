import 'package:f1_fanhub/domain/entities/standing.dart';
import 'package:f1_fanhub/domain/usecases/get_driver_standings_usecase.dart';
import 'package:flutter/material.dart';

class DriverStandingsViewModel extends ChangeNotifier {
  final GetDriverStandingsUseCase _getDriverStandingsUseCase;

  DriverStandingsViewModel(this._getDriverStandingsUseCase);

  // Estado
  List<DriverStanding> drivers = [];
  bool isLoading = false;
  String? errorMessage;

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
    isLoading = true;
    errorMessage = null; // Limpiamos errores previos
    notifyListeners();

    try {
      // Llamamos al UseCase (que ya maneja la lógica de repo/caché)
      drivers = await _getDriverStandingsUseCase(forceUpdate: force);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
