class Response {
  ResponseStatus status;
  Object? value;

  Response({this.status = ResponseStatus.failure, this.value});
}

enum ResponseStatus {
  success(0),
  failure(1);

  final int value;

  const ResponseStatus(this.value);
}
