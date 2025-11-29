import 'standing.dart';

class RaceResult {
  final String position;
  final String points;
  final Driver driver;
  final Constructor constructor;
  final String timeOrStatus; // Tiempo o el estado ("+1 Lap", "DNF")
  final String? fastestLapTime; // Tiempo de la vuelta rápida, si existe
  final String? fastestLapRank;
  RaceResult({
    required this.position,
    required this.points,
    required this.driver,
    required this.constructor,
    required this.timeOrStatus,
    this.fastestLapTime,
    this.fastestLapRank,
  });
}
