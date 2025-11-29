import 'package:flutter/material.dart';
import 'package:f1_fanhub/domain/entities/race.dart';
import 'package:f1_fanhub/domain/usecases/get_current_races_usecase.dart';

class CalendarViewModel extends ChangeNotifier {
  final GetCurrentRacesUseCase getCurrentRacesUseCase;

  CalendarViewModel(this.getCurrentRacesUseCase);

  List<Race> races = [];
  bool isLoading = false;
  String? errorMessage;

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
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Pasamos el parámetro force al repositorio
      races = await getCurrentRacesUseCase(forceUpdate: force);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
