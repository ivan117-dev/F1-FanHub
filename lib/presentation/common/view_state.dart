enum ViewStatus { idle, loading, success, empty, error }

class ViewState<T> {
  final ViewStatus status;
  final T? data;
  final String? message;

  const ViewState._({required this.status, this.data, this.message});

  const ViewState.idle() : this._(status: ViewStatus.idle);
  const ViewState.loading() : this._(status: ViewStatus.loading);
  const ViewState.success(T data)
    : this._(status: ViewStatus.success, data: data);
  const ViewState.empty([String? message])
    : this._(status: ViewStatus.empty, message: message);
  const ViewState.error(String message)
    : this._(status: ViewStatus.error, message: message);

  bool get isLoading => status == ViewStatus.loading;
  bool get hasError => status == ViewStatus.error;
  bool get isEmpty => status == ViewStatus.empty;
  bool get isSuccess => status == ViewStatus.success;
  bool get isIdle => status == ViewStatus.idle;
}
