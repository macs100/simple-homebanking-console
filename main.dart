import './libraries/Banco.dart';
import './libraries/Terminal.dart';
import './libraries/Exceptions/BancoExceptions.dart';

void main() {

  Banco banco;
  try {
    banco = Banco();
    Terminal terminal = Terminal(banco);
    while (true) {   //lleva a cabo todo el proceso llevado a cabo por la terminal hasta que se le 
      terminal.run();//indique apagarse
    }
  } on CierreBancoException {
    print('SERVICIO FINALIZADO');
  } on FatalBancoException catch(err) {
    print("Hubo un error:");
    print(err);
    print('BANCO FUERA DE SERVICIO');
  }
}