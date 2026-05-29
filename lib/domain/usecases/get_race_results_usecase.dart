import 'package:f1_fanhub/domain/common/result.dart';
import 'package:f1_fanhub/domain/entities/race_result.dart';
import 'package:f1_fanhub/domain/repositories/results_repository.dart';

class GetRaceResultsUseCase {
  final ResultsRepository repository;

  GetRaceResultsUseCase(this.repository);

  Future<Result<List<RaceResult>>> call(String round) {
    return repository.getRaceResults(round);
  }
}
