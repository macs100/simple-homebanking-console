//Superclase de exitTerminalException.

class TerminalException implements Exception {
  String _message;
  TerminalException(this._message);  
  @override
  String toString() {
    return _message;
  }  
}


// Se usa para cerrar la terminal.
class ExitTerminalException extends TerminalException { 
  ExitTerminalException(String message): super(message); 
}