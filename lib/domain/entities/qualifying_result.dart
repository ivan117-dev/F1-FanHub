import 'standing.dart';

class QualifyingResult {
  final String position;
  final Driver driver;
  final Constructor constructor;
  final String q1;
  final String? q2; // Puede ser nulo si quedó eliminado
  final String? q3;

  QualifyingResult({
    required this.position,
    required this.driver,
    required this.constructor,
    required this.q1,
    this.q2,
    this.q3,
  });
}
