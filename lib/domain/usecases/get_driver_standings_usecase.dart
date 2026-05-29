import 'package:f1_fanhub/domain/common/result.dart';
import 'package:f1_fanhub/domain/entities/standing.dart';
import 'package:f1_fanhub/domain/repositories/standings_repository.dart';

class GetDriverStandingsUseCase {
  final StandingsRepository repository;
  GetDriverStandingsUseCase(this.repository);

  Future<Result<List<DriverStanding>>> call({bool forceUpdate = false}) {
    return repository.getDriverStandings(forceUpdate: forceUpdate);
  }
}
