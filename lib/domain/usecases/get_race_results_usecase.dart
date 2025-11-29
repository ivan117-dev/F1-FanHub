import 'package:f1_fanhub/domain/entities/race_result.dart';
import 'package:f1_fanhub/domain/repositories/results_repository.dart';

class GetRaceResultsUseCase {
  final ResultsRepository repository;

  GetRaceResultsUseCase(this.repository);

  Future<List<RaceResult>> call(String round) {
    return repository.getRaceResults(round);
  }
}
