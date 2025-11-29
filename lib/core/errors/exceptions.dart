class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  // Generalmente no necesita mensaje porque solo indica "no encontré nada"
}
