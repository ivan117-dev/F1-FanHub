import 'package:f1_fanhub/domain/entities/race.dart';
import 'package:f1_fanhub/domain/repositories/race_repository.dart';

class GetCurrentRacesUseCase {
  final RaceRepository repository;

  GetCurrentRacesUseCase(this.repository);

  Future<List<Race>> call({bool forceUpdate = false}) async {
    return await repository.getCurrentSeasonRaces(forceUpdate: forceUpdate);
  }
}
