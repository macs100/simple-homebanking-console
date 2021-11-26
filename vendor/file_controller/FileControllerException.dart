
///Solo usado para cuando se intenta leer archivos vacíos.
class FileControllerException implements Exception {
  String _message;
  FileControllerException(this._message);
  @override
  String toString() {
    return _message;
  }  
}