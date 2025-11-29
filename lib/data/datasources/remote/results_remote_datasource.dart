import 'package:dio/dio.dart';
import 'package:f1_fanhub/core/constants/api_constants.dart';
import 'package:f1_fanhub/data/models/pit_stop_model.dart';
import 'package:f1_fanhub/data/models/qualifying_result_model.dart';
import 'package:f1_fanhub/data/models/race_result_model.dart';

class ResultsRemoteDataSource {
  final Dio dio;

  ResultsRemoteDataSource(this.dio);

  Future<List<RaceResultModel>> fetchRaceResults(String round) async {
    try {
      final response = await dio.get(ApiConstants.raceResults(round));
      // Estructura: MRData -> RaceTable -> Races[0] -> Results
      final List<dynamic> races = response.data['MRData']['RaceTable']['Races'];
      if (races.isEmpty) return []; // Aún no se ha corrido

      final List<dynamic> results = races[0]['Results'];
      return results.map((e) => RaceResultModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error fetching race results: $e');
    }
  }

  Future<List<QualifyingResultModel>> fetchQualifyingResults(
    String round,
  ) async {
    try {
      final response = await dio.get(ApiConstants.qualifyingResults(round));
      final List<dynamic> races = response.data['MRData']['RaceTable']['Races'];
      if (races.isEmpty) return [];

      final List<dynamic> results = races[0]['QualifyingResults'];
      return results.map((e) => QualifyingResultModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error fetching qualifying results: $e');
    }
  }

  Future<List<RaceResultModel>> fetchSprintResults(String round) async {
    try {
      final response = await dio.get(ApiConstants.sprintResults(round));
      final List<dynamic> races = response.data['MRData']['RaceTable']['Races'];
      if (races.isEmpty) return [];

      final List<dynamic> results = races[0]['SprintResults'];
      // SprintResults tiene la misma estructura básica que Results, reusamos el modelo
      return results.map((e) => RaceResultModel.fromJson(e)).toList();
    } catch (e) {
      // Si la carrera no tiene Sprint, la API puede devolver error o lista vacía
      return [];
    }
  }

  Future<List<PitStopModel>> fetchPitStops(String round) async {
    try {
      // Usamos la constante correcta
      final response = await dio.get(ApiConstants.pitStops(round));

      final List<dynamic> races = response.data['MRData']['RaceTable']['Races'];

      if (races.isEmpty) return [];

      final List<dynamic> pitstops = races[0]['PitStops'] ?? [];
      return pitstops.map((e) => PitStopModel.fromJson(e)).toList();
    } catch (e) {
      // Si la carrera no tiene datos de pitstops o falla, retornamos lista vacía
      return [];
    }
  }
}
