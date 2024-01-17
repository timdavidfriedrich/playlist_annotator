abstract class DataState<T> {
  final T? _data;
  final Exception? _error;

  DataState({T? data, dynamic error})
      : _error = error,
        _data = data;
}

class DataStateSuccess<T> extends DataState<T> {
  DataStateSuccess(T data) : super(data: data);

  T? get data => super._data;
  bool get hasData => super._data != null;
}

class DataStateError<T> extends DataState<T> {
  DataStateError(Exception error) : super(error: error);

  Exception get error => super._error!;
  bool get hasError => super._error != null;
}
