import 'package:f1_fanhub/domain/entities/standing.dart';

abstract class StandingsRepository {
  Future<List<DriverStanding>> getDriverStandings({bool forceUpdate = false});
  Future<List<ConstructorStanding>> getConstructorStandings({
    bool forceUpdate = false,
  });
}
