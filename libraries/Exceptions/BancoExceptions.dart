///import '.../vendor/file_controller/FileControllerException';

class BancoException implements Exception {

  String message;
  
  BancoException(this.message);
  
  @override
  String toString() {
    return message;
  }

  debug() => message;
}

class FatalBancoException extends BancoException {
  FatalBancoException(String message) : super(message);

  debug() => 'Fatal: ' + super.debug();
}



class CierreBancoException extends BancoException {

  CierreBancoException(String message) : super(message);

}

