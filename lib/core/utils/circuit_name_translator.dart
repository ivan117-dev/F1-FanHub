class CircuitNameTranslator {
  static const Map<String, String> _map = {
    // --- AMÉRICA ---
    'Autódromo Hermanos Rodríguez':
        'Autódromo Hermanos Rodríguez', // Ya está en español
    'Miami International Autodrome': 'Autódromo Internacional de Miami',
    'Circuit of the Americas': 'Circuito de las Américas',
    'Autódromo José Carlos Pace': 'Autódromo José Carlos Pace (Interlagos)',
    'Las Vegas Strip Street Circuit': 'Circuito Callejero de Las Vegas',
    'Circuit Gilles Villeneuve': 'Circuito Gilles Villeneuve',

    // --- EUROPA ---
    'Circuit de Monaco': 'Circuito de Mónaco',
    'Circuit de Barcelona-Catalunya': 'Circuito de Barcelona-Cataluña',
    'Red Bull Ring': 'Red Bull Ring', // Se suele dejar igual
    'Silverstone Circuit': 'Circuito de Silverstone',
    'Hungaroring': 'Hungaroring', // Se suele dejar igual
    'Circuit de Spa-Francorchamps': 'Circuito de Spa-Francorchamps',
    'Circuit Park Zandvoort': 'Circuito de Zandvoort',
    'Autodromo Nazionale di Monza': 'Autódromo Nacional de Monza',
    'Autodromo Enzo e Dino Ferrari': 'Autódromo Enzo e Dino Ferrari (Imola)',

    // --- ASIA / OCEANÍA / MEDIO ORIENTE ---
    'Bahrain International Circuit': 'Circuito Internacional de Baréin',
    'Jeddah Corniche Circuit': 'Circuito de la Corniche de Yeda',
    'Albert Park Grand Prix Circuit': 'Circuito de Albert Park',
    'Suzuka Circuit': 'Circuito de Suzuka',
    'Shanghai International Circuit': 'Circuito Internacional de Shanghái',
    'Marina Bay Street Circuit': 'Circuito Urbano Marina Bay',
    'Baku City Circuit': 'Circuito Callejero de Bakú',
    'Losail International Circuit': 'Circuito Internacional de Lusail',
    'Yas Marina Circuit': 'Circuito de Yas Marina',
  };

  static String translate(String originalName) {
    return _map[originalName] ?? originalName;
  }
}
