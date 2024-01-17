abstract class AppException implements Exception {
  const AppException([this.message]);

  final String? message;

  @override
  String toString() {
    return "${(runtimeType).toString()}${message is String ? ": $message" : ""}";
  }
}
