import 'package:f1_fanhub/domain/entities/qualifying_result.dart';
import 'package:f1_fanhub/domain/repositories/results_repository.dart';

class GetQualifyingResultsUseCase {
  final ResultsRepository repository;

  GetQualifyingResultsUseCase(this.repository);

  Future<List<QualifyingResult>> call(String round) {
    return repository.getQualifyingResults(round);
  }
}
