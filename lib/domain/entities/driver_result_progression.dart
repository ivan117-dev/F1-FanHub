import 'package:f1_fanhub/core/utils/status_translator.dart';

class DriverRaceProgression {
  final String raceName;
  final int round;
  final int position;
  final String status; // Ej: 'Finished', '+1 Lap', 'Collision'

  bool get isDNF => StatusTranslator.isDNF(status);

  DriverRaceProgression({
    required this.raceName,
    required this.round,
    required this.position,
    required this.status,
  });
}
