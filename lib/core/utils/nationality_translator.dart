class NationalityTranslator {
  static const Map<String, String> _map = {
    // --- PILOTOS (Gentilicios) ---
    'British': 'Reino Unido',
    'Dutch': 'Países Bajos',
    'Monegasque': 'Mónaco',
    'Italian': 'Italia',
    'Thai': 'Tailandia',
    'French': 'Francia',
    'German': 'Alemania',
    'Spanish': 'España',
    'American': 'Estados Unidos',
    'New Zealander': 'Nueva Zelanda',
    'Canadian': 'Canadá',
    'Japanese': 'Japón',
    'Brazilian': 'Brasil',
    'Argentine': 'Argentina',
    'Australian': 'Australia',
    'Chinese': 'China',
    'Finnish': 'Finlandia',
    'Danish': 'Dinamarca',
    'Mexican': 'México',
    'Swiss': 'Suiza',

    // --- CONSTRUCTORES (Países) ---
    'Austrian': 'Austria',
  };

  static String translate(String original) {
    // Si existe la traducción, la devolvemos. Si no, devolvemos el original en Inglés.
    return _map[original] ?? original;
  }
}
