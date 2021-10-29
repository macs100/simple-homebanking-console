class TerminalException implements Exception {

  String _message;

  TerminalException(this._message);  
  
  @override
  String toString() {
    return _message;
  }  
  
}

class ExitTerminalException extends TerminalException { 
  ExitTerminalException(String message): super(message); 
}