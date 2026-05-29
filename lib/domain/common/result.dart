import 'package:f1_fanhub/domain/common/failures.dart';

class Result<T> {
  final T? data;
  final Failure? failure;

  const Result._({this.data, this.failure});

  bool get isSuccess => failure == null;
  bool get isFailure => failure != null;

  factory Result.success(T data) => Result._(data: data);
  factory Result.failure(Failure failure) => Result._(failure: failure);

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    if (isSuccess) {
      return success(data as T);
    }
    return failure(this.failure as Failure);
  }
}
