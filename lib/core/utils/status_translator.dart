class StatusTranslator {
  static final Map<String, String> _map = {
    'Finished': 'Finalizado',
    'Disqualified': 'Descalificado',
    'Accident': 'Accidente',
    'Collision': 'Colisión',
    'Collision damage': 'Daños por choque',
    'Spun off': 'Salida de pista',
    'Engine': 'Falla de Motor',
    'Gearbox': 'Caja de cambios',
    'Transmission': 'Transmisión',
    'Suspension': 'Suspensión',
    'Brakes': 'Frenos',
    'Hydraulics': 'Hidráulica',
    'Electrical': 'Eléctrico',
    'Electronics': 'Electrónica',
    'Power Unit': 'Unidad de Potencia',
    'Radiator': 'Radiador',
    'Exhaust': 'Escape',
    'Oil leak': 'Fuga de aceite',
    'Water pressure': 'Presión de agua',
    'Fuel pressure': 'Presión de combustible',
    'Wheel': 'Rueda',
    'Tyre': 'Neumático',
    'Retired': 'Retirado',
    'Withdrew': 'Retirado (WD)',
  };

  static String translate(String status) {
    // 1. Buscamos traducción directa
    if (_map.containsKey(status)) return _map[status]!;

    // 2. Manejo de vueltas perdidas (+1 Lap)
    if (status.contains('Lap')) {
      return status.replaceAll('Laps', 'Vueltas').replaceAll('Lap', 'Vuelta');
    }

    // 3. Si no hay traducción, devolvemos el original
    return status;
  }

  /// Determina si el status corresponde a un Abandono real
  static bool isDNF(String status) {
    // Consideramos DNF todo lo que NO sea terminar o perder vueltas
    // (Finished, +1 Lap, +2 Laps... no son DNF)
    final isFinished = status == 'Finished' || status.startsWith('+');
    return !isFinished;
  }
}
