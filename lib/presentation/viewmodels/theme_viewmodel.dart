import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeViewModel extends ChangeNotifier {
  final SharedPreferences _prefs;
  static const String _themeKey = 'is_dark_mode';

  // Estado inicial (por defecto Claro)
  bool _isDarkMode = false;

  // Getter para que la UI sepa cuál es el estado actual
  bool get isDarkMode => _isDarkMode;

  ThemeViewModel(this._prefs) {
    // Al iniciar, leemos la memoria del teléfono
    _isDarkMode = _prefs.getBool(_themeKey) ?? false;
  }

  // Método para cambiar el tema
  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    // Guardamos la preferencia en el teléfono
    _prefs.setBool(_themeKey, isDark);
    // Avisamos a toda la app que se redibuje
    notifyListeners();
  }
}
