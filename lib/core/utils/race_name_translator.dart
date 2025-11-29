class RaceNameTranslator {
  static const Map<String, String> _map = {
    'Australian Grand Prix': 'Gran Premio de Australia',
    'Chinese Grand Prix': 'Gran Premio de China',
    'Japanese Grand Prix': 'Gran Premio de Japón',
    'Bahrain Grand Prix': 'Gran Premio de Baréin',
    'Saudi Arabian Grand Prix': 'Gran Premio de Arabia Saudita',
    'Miami Grand Prix': 'Gran Premio de Miami',
    'Emilia Romagna Grand Prix': 'Gran Premio de Emilia-Romaña',
    'Monaco Grand Prix': 'Gran Premio de Mónaco',
    'Spanish Grand Prix': 'Gran Premio de España',
    'Canadian Grand Prix': 'Gran Premio de Canadá',
    'Austrian Grand Prix': 'Gran Premio de Austria',
    'British Grand Prix': 'Gran Premio de Gran Bretaña',
    'Belgian Grand Prix': 'Gran Premio de Bélgica',
    'Hungarian Grand Prix': 'Gran Premio de Hungría',
    'Dutch Grand Prix': 'Gran Premio de los Países Bajos',
    'Italian Grand Prix': 'Gran Premio de Italia',
    'Azerbaijan Grand Prix': 'Gran Premio de Azerbaiyán',
    'Singapore Grand Prix': 'Gran Premio de Singapur',
    'United States Grand Prix': 'Gran Premio de Estados Unidos',
    'Mexico City Grand Prix': 'Gran Premio de la Ciudad de México',
    'São Paulo Grand Prix': 'Gran Premio de São Paulo',
    'Las Vegas Grand Prix': 'Gran Premio de Las Vegas',
    'Qatar Grand Prix': 'Gran Premio de Qatar',
    'Abu Dhabi Grand Prix': 'Gran Premio de Abu Dabi',
  };

  static String translate(String originalName) {
    // Si la carrera no está en la lista, intentamos una traducción genérica
    // Reemplazando "Grand Prix" por "Gran Premio"
    if (_map.containsKey(originalName)) {
      return _map[originalName]!;
    }
    return originalName.replaceFirst('Grand Prix', 'Gran Premio');
  }
}
