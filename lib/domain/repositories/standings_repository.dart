import 'package:f1_fanhub/domain/common/result.dart';
import 'package:f1_fanhub/domain/entities/standing.dart';

abstract class StandingsRepository {
  Future<Result<List<DriverStanding>>> getDriverStandings({
    bool forceUpdate = false,
  });
  Future<Result<List<ConstructorStanding>>> getConstructorStandings({
    bool forceUpdate = false,
  });
}
