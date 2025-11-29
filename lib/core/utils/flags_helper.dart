class FlagHelper {
  static String getFlagPath(String nationalityOrCountry) {
    // 1. Normalizar: quitar espacios y pasar a minúsculas
    String formattedName = nationalityOrCountry.trim().toLowerCase();

    // 2. Diccionario de Mapeo (Gentilicio/Alias -> Nombre de archivo existente)
    // Aquí conectamos lo que dice la API con el archivo .png que tú tienes.
    const Map<String, String> nationalityMap = {
      // -- GENTILICIOS (Drivers/Constructors) --
      'british': 'uk',
      'english': 'uk',
      'dutch': 'netherlands',
      'german': 'germany',
      'french': 'france',
      'italian': 'italy',
      'spanish': 'spain',
      'american': 'usa',
      'japanese': 'japan',
      'australian': 'australia',
      'canadian': 'canada',
      'brazilian': 'brazil',
      'austrian': 'austria',
      'mexican': 'mexico',
      'monegasque': 'monaco',
      'swiss': 'switzerland',
      'thai': 'thailand',
      'new zealander': 'new_zealand',
      'argentine': 'argentina',
      'chinese': 'china',
      'danish': 'denmark', // Por si acaso (Magnussen/Vesti)
      'finnish': 'finland', // Por si acaso (Bottas)
      // -- ALIAS DE PAÍSES (Calendar) --
      'united states': 'usa',
      'united kingdom': 'uk',
      'united arab emirates': 'uae',
      'korea': 'south_korea',
    };

    // 3. Verificamos si existe en el mapa
    if (nationalityMap.containsKey(formattedName)) {
      formattedName = nationalityMap[formattedName]!;
    } else {
      // Si no está en el mapa, solo reemplazamos espacios por guiones bajos
      // Ej: "Saudi Arabia" -> "saudi_arabia"
      formattedName = formattedName.replaceAll(' ', '_');
    }

    return 'assets/flags/$formattedName.png';
  }
}
