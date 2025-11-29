import 'package:f1_fanhub/domain/entities/pit_stop.dart';
import 'package:f1_fanhub/domain/entities/race_result.dart';
import 'package:f1_fanhub/domain/entities/qualifying_result.dart';

abstract class ResultsRepository {
  Future<List<RaceResult>> getRaceResults(String round);
  Future<List<QualifyingResult>> getQualifyingResults(String round);
  Future<List<RaceResult>> getSprintResults(String round);
  Future<List<PitStop>> getPitStops(String round);
}
