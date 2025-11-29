import 'package:dio/dio.dart';
import 'package:f1_fanhub/core/constants/api_constants.dart';
import 'package:f1_fanhub/data/models/race_model.dart';

class RaceRemoteDataSource {
  final Dio dio;

  RaceRemoteDataSource(this.dio);

  Future<List<RaceModel>> getCurrentRaces() async {
    final response = await dio.get(ApiConstants.currentSeason);

    if (response.statusCode == 200) {
      final data = response.data;
      final List<dynamic> racesJson = data['MRData']['RaceTable']['Races'];
      return racesJson.map((json) => RaceModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar el calendario');
    }
  }
}
