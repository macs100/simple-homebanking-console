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


//Para cuando no puede loguear el usuario, no lo reconoce

class LoginClientesException extends ClientesException {
  LoginClientesException([String message = 'Error']) {
    this._message = message;
  }
}


//Para problemas con el json de los clientes. Solo se usa en Clientes.dart entre las lineas 37 y 50

class FatalClientesException extends ClientesException {
  FatalClientesException([String message = 'Error']) {
    this._message = message;
  }
}