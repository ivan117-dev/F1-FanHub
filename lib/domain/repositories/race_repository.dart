import 'package:f1_fanhub/domain/common/result.dart';
import 'package:f1_fanhub/domain/entities/race.dart';

abstract class RaceRepository {
  Future<Result<List<Race>>> getCurrentSeasonRaces({bool forceUpdate = false});
}
