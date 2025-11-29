import 'package:dio/dio.dart';
import 'package:f1_fanhub/core/constants/api_constants.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10), // Tiempo máx para conectar
        receiveTimeout: const Duration(
          seconds: 10,
        ), // Tiempo máx para recibir datos
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Opcional: Agregar interceptors para ver logs en consola
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    );
  }

  // Getter para acceder a la instancia configurada
  Dio get dio => _dio;
}
