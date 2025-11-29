import 'package:f1_fanhub/core/constants/api_constants.dart';
import 'package:f1_fanhub/data/models/driver_result_progression_model.dart';
import 'package:dio/dio.dart';

class DriverStatsRemoteDataSource {
  final Dio dio;

  DriverStatsRemoteDataSource(this.dio);

  Future<List<DriverResultProgressionModel>> fetchSeasonResults(
    String driverId,
  ) async {
    try {
      final response = await dio.get(ApiConstants.driverResults(driverId));

      // Delegamos el parseo complejo de la lista al modelo
      return DriverResultProgressionModel.listFromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching driver season results: $e');
    }
  }
}
