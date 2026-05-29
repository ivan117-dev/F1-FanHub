import 'package:f1_fanhub/domain/common/result.dart';
import 'package:f1_fanhub/domain/entities/pit_stop.dart';
import 'package:f1_fanhub/domain/entities/race_result.dart';
import 'package:f1_fanhub/domain/entities/qualifying_result.dart';

abstract class ResultsRepository {
  Future<Result<List<RaceResult>>> getRaceResults(String round);
  Future<Result<List<QualifyingResult>>> getQualifyingResults(String round);
  Future<Result<List<RaceResult>>> getSprintResults(String round);
  Future<Result<List<PitStop>>> getPitStops(String round);
}
