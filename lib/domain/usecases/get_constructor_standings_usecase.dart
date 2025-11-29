import 'package:f1_fanhub/domain/entities/standing.dart';
import 'package:f1_fanhub/domain/repositories/standings_repository.dart';

class GetConstructorStandingsUseCase {
  final StandingsRepository repository;
  GetConstructorStandingsUseCase(this.repository);

  Future<List<ConstructorStanding>> call({bool forceUpdate = false}) {
    return repository.getConstructorStandings(forceUpdate: forceUpdate);
  }
}
