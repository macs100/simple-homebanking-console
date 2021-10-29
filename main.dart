import './libraries/Banco.dart';
import './libraries/Terminal.dart';
import './libraries/Exceptions/BancoExceptions.dart';

void main() {

  ///banco es el nombre del objeto banco de la clase Banco creada con la función Banco()
  Banco banco;

  try {
    banco = Banco();

    Terminal terminal = Terminal(banco);

    try {
      while (true) { 
        terminal.run();
      }
    } on CierreBancoException {
      print('SERVICIO FINALIZADO');
    }

  } on FatalBancoException catch(err) {

    // Propósito: loguear el error en un archivo de errores sin que
    // se entere el usuario
    print("Hubo un error:");
    print(err);
    print('BANCO FUERA DE SERVICIO');
  }



  /*
  print('TE DAMOS LA BIENVENIDA A');
  print(banco.getNombre());

  print('ingrese su nombre de usuario:');
  String nombreUsuario = stdin.readLineSync();
  print('ingrese su contraseña:');
  String contraseña = stdin.readLineSync();
  */

  // terminal.bienvenida(banco.getNombre());

  // Terminal terminal = Terminal();

	// print('Hello World!');

}