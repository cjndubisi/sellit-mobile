class ClientException implements Exception {
  ClientException(this.message, {this.exception});
  final String message;
  final Exception exception;
}
