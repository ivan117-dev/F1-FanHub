import 'package:dio/dio.dart';
import 'package:f1_fanhub/core/constants/api_constants.dart';
import 'package:f1_fanhub/data/models/standing_model.dart';

class StandingsRemoteDataSource {
  final Dio dio;
  StandingsRemoteDataSource(this.dio);

  Future<List<DriverStandingModel>> getDriverStandings() async {
    //endpoint: /current/driverstandings.json
    final response = await dio.get(ApiConstants.currentDriverStandings);
    final List<dynamic> list = response
        .data['MRData']['StandingsTable']['StandingsLists'][0]['DriverStandings'];
    return list.map((e) => DriverStandingModel.fromJson(e)).toList();
  }

  Future<List<ConstructorStandingModel>> getConstructorStandings() async {
    //endpoint: /current/constructorstandings.json
    final response = await dio.get(ApiConstants.currentConstructorStandings);
    final List<dynamic> list = response
        .data['MRData']['StandingsTable']['StandingsLists'][0]['ConstructorStandings'];
    return list.map((e) => ConstructorStandingModel.fromJson(e)).toList();
  }
}
