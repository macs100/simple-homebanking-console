class ClientesException implements Exception {

  String _message = '';

  ClientesException([String message = 'Error']) {
    this._message = message;
  }
  
  @override
  String toString() {
    return _message;
  }

}

class LoginClientesException extends ClientesException {
  LoginClientesException([String message = 'Error']) {
    this._message = message;
  }
}

class FatalClientesException extends ClientesException {
  FatalClientesException([String message = 'Error']) {
    this._message = message;
  }
}