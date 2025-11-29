class PitStop {
  final String driverId;
  final String lap;
  final String stop; // Número de parada (1, 2, 3...)
  final String time; // Hora del día
  final String duration; // Tiempo detenido (ej "2.4")

  PitStop({
    required this.driverId,
    required this.lap,
    required this.stop,
    required this.time,
    required this.duration,
  });
}
