class Race {
  final String id;
  final String raceName;
  final String date;
  final String time;
  final String circuitName;
  final String locality;
  final String country;

  // Sesiones posibles (todas pueden ser nulas dependiendo del tipo de carrera)
  final Map<String, String>? firstPractice;
  final Map<String, String>? secondPractice;
  final Map<String, String>? thirdPractice;
  final Map<String, String>? qualifying;
  final Map<String, String>? sprint;
  final Map<String, String>? sprintQualifying; // <--- NUEVO CAMPO

  Race({
    required this.id,
    required this.raceName,
    required this.date,
    required this.time,
    required this.circuitName,
    required this.locality,
    required this.country,
    this.firstPractice,
    this.secondPractice,
    this.thirdPractice,
    this.qualifying,
    this.sprint,
    this.sprintQualifying,
  });

  // LOGICA DE NEGOCIO: Getter para saber si es formato Sprint
  // Si tiene sesión de "Sprint", asumimos que es fin de semana Sprint.
  bool get isSprintWeekend => sprint != null;
}
