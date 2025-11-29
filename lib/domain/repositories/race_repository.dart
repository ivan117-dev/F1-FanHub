import 'package:f1_fanhub/domain/entities/race.dart';

abstract class RaceRepository {
  Future<List<Race>> getCurrentSeasonRaces({bool forceUpdate = false});
}
