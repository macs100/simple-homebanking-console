///import '.../vendor/file_controller/FileControllerException';

//clase de objeto usada para errores del banco.

class BancoException implements Exception {
  String message;
  BancoException(this.message);
  @override
  String toString() {
    return message;
  }
  debug() => message;
}


//Para problemas de inicialización del banco
class FatalBancoException extends BancoException {
  FatalBancoException(String message) : super(message);
  debug() => 'Fatal: ' + super.debug();
}


//Para cerrar el banco cuando el usuario desea, se lo hace flotar
//hasta el main

class CierreBancoException extends BancoException {
  CierreBancoException(String message) : super(message);
}

