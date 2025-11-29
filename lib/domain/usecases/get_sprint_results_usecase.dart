import 'package:f1_fanhub/domain/entities/race_result.dart';
import 'package:f1_fanhub/domain/repositories/results_repository.dart';

class GetSprintResultsUseCase {
  final ResultsRepository repository;

  GetSprintResultsUseCase(this.repository);

  Future<List<RaceResult>> call(String round) {
    return repository.getSprintResults(round);
  }
}
