class ApiConstants {
  // Base URL de la API de Jolpica
  static const String baseUrl = 'https://api.jolpi.ca/ergast/f1';

  // Endpoints específicos
  static const String currentSeason = '/current.json';
  static const String currentDriverStandings = '/current/driverStandings.json';
  static const String currentConstructorStandings =
      '/current/constructorStandings.json';

  //Métodos para endpoints que requieren parámetros
  static String raceResults(String round) => '/current/$round/results.json';
  static String qualifyingResults(String round) =>
      '/current/$round/qualifying.json';
  static String sprintResults(String round) => '/current/$round/sprint.json';
  static String pitStops(String round) => '/current/$round/pitstops.json';
  static String driverResults(String driverId) =>
      '/current/drivers/$driverId/results.json';
}
