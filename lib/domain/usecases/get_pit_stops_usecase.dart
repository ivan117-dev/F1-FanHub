import 'package:f1_fanhub/domain/entities/pit_stop.dart';
import 'package:f1_fanhub/domain/repositories/results_repository.dart';

class GetPitStopsUseCase {
  final ResultsRepository repository;
  GetPitStopsUseCase(this.repository);

  Future<List<PitStop>> call(String round) {
    return repository.getPitStops(round);
  }
}
