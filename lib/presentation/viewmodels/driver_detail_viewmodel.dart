import 'package:f1_fanhub/domain/entities/driver_result_progression.dart';
import 'package:f1_fanhub/domain/usecases/get_driver_season_progression_usecase.dart';
import 'package:flutter/material.dart';

class DriverDetailViewModel extends ChangeNotifier {
  final GetDriverSeasonProgressionUseCase _getProgressionUseCase;

  final String driverId;

  // Bandera de estado de disposición
  bool _isDisposed = false;

  DriverDetailViewModel(this._getProgressionUseCase, this.driverId);

  bool isLoading = false;
  String? errorMessage;
  List<DriverRaceProgression> progression = [];

  // 1. Método para marcar la clase como dispuesta
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> loadProgression() async {
    isLoading = true;

    // Verificamos si estamos dispuestos antes de empezar la carga
    if (!_isDisposed) notifyListeners();

    try {
      final results = await _getProgressionUseCase(driverId);

      // 2. VERIFICACIÓN: Ignoramos la respuesta si ya salimos de la pantalla
      if (_isDisposed) return;

      progression = results;
    } catch (e) {
      if (_isDisposed) return;
      errorMessage = e.toString();
    } finally {
      // Verificamos la condición INVERSA: si NO está dispuesto, limpiamos.
      if (!_isDisposed) {
        isLoading = false;
        notifyListeners();
      }
      // El método finaliza naturalmente aquí, sin el 'return' problemático.
    }
  }
}
