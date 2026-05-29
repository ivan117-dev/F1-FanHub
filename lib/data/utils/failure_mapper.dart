import 'package:dio/dio.dart';
import 'package:f1_fanhub/core/errors/exceptions.dart';
import 'package:f1_fanhub/domain/common/failures.dart';

Failure mapExceptionToFailure(Object error) {
  if (error is ServerException) {
    return ServerFailure(error.message);
  }
  if (error is DioException) {
    return const NetworkFailure('No hay conexion.');
  }
  if (error is CacheException) {
    return const CacheFailure('No hay datos guardados.');
  }
  return const UnknownFailure('Error inesperado.');
}
