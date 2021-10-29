//import 'dart:html';
import 'dart:io';
import './Banco.dart';
import './Exceptions/TerminalExceptions.dart';
import './Clientes.dart';
import './Exceptions/ClientesExceptions.dart';

class Terminal {


  /// regex101.com
  /// expresiones regulares


  ///numero de terminal, para saber dónde se hace la transferencia.
  num _idTerminal = 0;
  Banco _banco = Banco();
  Cliente? _cliente;
  
  
  ///constructor del terminal
  Terminal(Banco banco){
    
    _idTerminal = 1;//crearTerminal();
    _banco = banco;

  }


  /// inicio de ejecución.
  void run() {

    try {
      bienvenida();
      
      switch (inicio()) {
        case 1: 
          runCliente();
          break;
        case 2: 
          registrarCliente();
          break;
        case 3:
          runInvitado();
          break;
      }
    } on ExitTerminalException {
      _success("¡GRACIAS POR VISITARNOS!");
      sleep(Duration(seconds:5));
      clear();
    } catch (err) {
      _showError(err.toString());
      rethrow;
    }
  }


  /// logear, registrar o entrar como incognito
  int inicio() {
    _titulo('¿Qué desea hacer?');
    _opcion(1, 'Iniciar Sesión');
    _opcion(2, 'Registrarte');
    _opcion(3, 'Continuar como invitado');
    return _elegirOpcionInt(3);
  }

  /// Muestra por pantalla un mensaje de bienvenida.
  void bienvenida() {

    _info('TE DAMOS LA BIENVENIDA A');
    _info(_banco.getNombre());

  }

  void runCliente() {

    _cliente = logIn()!;
    _success('Hola ${_cliente!.getNombre()}');
    
    while(true) {
      switch (seleccionOpcion()) {
        case 1:
          consultarSaldo();
          break;
        case 2:
          depositarEfectivo();
          break;
        case 3:
          extraerEfectivo();
          break;
        case 4://sin codear
          //depositarCheque();
          //break;
        case 5://sin codear
          realizarTransferencia();
          break;
        case 6://sin codear
          //configurarCuenta();
          //break;
        case 7:
          //por ahora nada
        case 8:
          throw ExitTerminalException('error');
      }
    }   

  }

  
  /// Inicio de sesión.
  /// puedo ir como anónimo a depositar a la cuenta de otra persona o puedo ir y logearme.
  Cliente? logIn() {
    Cliente? cliente;
    bool logged = false;
    while (!logged) {
      try {
        String nombreUsuario = _consulta('Ingrese su nombre de usuario:');
        String contrasena = _consulta('Ingrese su contraseña:');
        cliente = Cliente(nombreUsuario, contrasena);
        logged = true;
      } on LoginClientesException catch (err) {

        _danger("El usuario y/o contraseña no son válidos.");
        
        _titulo('¿Qué desea hacer?');
        _opcion(1, 'Volver a intentar');
        _opcion(2, 'Salir');
        
        if (_elegirOpcionInt(2) == 2) {
          throw ExitTerminalException('');
        }
      }
    }

    return cliente;
  }

  void registrarCliente() {
   
    String? nombre;
    String? contrasena;
    String? nacimiento;
    
      nombre = _consulta('ingrese su nombre');
      contrasena = _consulta('ingrese su contraseña');
      nacimiento = _consulta('ingrese su fecha de nacimiento');


    num? cantTelefonos;
    do{
      cantTelefonos = num.tryParse(_consulta('cuantos numeros de teléfono posee?'));
    } while (cantTelefonos == null);
    List<num> telefonos = [];
    num? numeroActual;
    for (int i=0; i<cantTelefonos; i++){
      do {
        numeroActual = num.tryParse(_consulta('ingrese su numero de teléfono'));
      } while (numeroActual == null);
      telefonos.add(numeroActual);
    }

    num nroCuenta = Cliente.nuevoCliente(nombre, contrasena, nacimiento, telefonos);

    _success('usuario creado correctamente, nuevo numero de usuario: $nroCuenta');
  }

  

  void runInvitado(){

    invitado();
    do{
      _info('deséa depositar efectivo?');
      _info('1. Si');
      _info('2. No');
      switch(num.tryParse(_consulta(''))){
        case 1:
          realizarDepositoInvitado();
          break;
        case 2:
          if(_consulta('deséa salir del modo invitado? \n 1.Si \n 2.No') == 1){
            throw ExitTerminalException('');
          } 
          break;
      }
    }while(true);
    

  }

  void invitado() {
    
    try{
      _cliente = Cliente('invitado', 'abcdefghijklmnopqrstuvwxyz');
    } catch (err) {
      print(err);
    }
  }
  

  void getId() {
    _info( "$_idTerminal" );
  }
  
  /// El usuario indica lo que desea hacer.
  int seleccionOpcion() {

    _titulo('¿Qué desea hacer?');
    int i = 1;
    _opcion(i++, 'Consulta de saldo');
    _opcion(i++, 'Depositar efectivo');
    _opcion(i++, 'Extraer efectivo');
    _opcion(i++, 'Depositar un cheque');
    _opcion(i++, 'Realizar una transferencia');
    _opcion(i++, 'configurar cuenta.');
    _opcion(i++, '');
    _opcion(i++, 'Salir');//9

    return _elegirOpcionInt(9);

    ///depositar cheque, depositar efectivo, retirar, 
  }
  /// Alt+flechas mueve un renglón

  /// Se le indica en pantalla el saldo actual al usuario.
  void consultarSaldo() {
    _info('Su saldo es de: ');
    num saldo = _banco.getSaldo(_cliente!.getNroCuenta());
    if (saldo < 0){
      _danger("\$${saldo}");
    } else {
      _success("\$${saldo}");
    }
  }

  /// El usuario ingresa dinero en efectivo al cajero.
  void depositarEfectivo() {

    num monto;
    String fecha = '';
    String causa = '';
    
    try{
      _cliente!.getNroCuenta();
    } catch(e){
      _consulta('a qué numero de cuenta deséa enviar el dinero?');
    }
      monto = _consultaNumerica('cuánto dinero desea ingresar?', 1);
    
      causa = _consulta('cual es la causa de la transacción?');

    try{
      monto = _banco.nuevoMovimiento(0, _cliente!.getNroCuenta(), monto, fecha, causa);
      //numeroDeCuentaOrigen, numeroDeCuentaDestino, monto, String fecha, String causa
    } catch(err) {
      print(err);
    }
    //monto = Banco.nuevoMovimiento(0, _cliente.getNroCuenta(), monto, fecha, causa);
    //num numeroDeCuentaOrigen, num numeroDeCuentaDestino, num monto, String fecha, String causa
    _success('depósito realizado con éxito.');
    _success('        Monto: $monto');

    //banco.setSaldo(_consulta("Cuánto dinero desea ingresar?")); 
  }

  void extraerEfectivo() {
    
    num monto;
    String fecha = '';
    String causa = '';

    monto = _consultaNumerica('cuánto dinero desea extraer?', 1);
    
    num cuentaCliente = _cliente!.getNroCuenta();
    
    if (monto <= _banco.getSaldo(cuentaCliente)){
      
      causa = _consulta('cual es la causa de la extracción?');
      
      try{
        monto = _banco.nuevoMovimiento(_cliente!.getNroCuenta(), 0, monto, fecha, causa);
        //numeroDeCuentaOrigen, numeroDeCuentaDestino, monto, String fecha, String causa
      } catch(err) {
        print(err);
      }
      //monto = Banco.nuevoMovimiento(0, _cliente.getNroCuenta(), monto, fecha, causa);
      //num numeroDeCuentaOrigen, num numeroDeCuentaDestino, num monto, String fecha, String causa
      _success('extracción realizada con éxito.');
      _success('         Monto: $monto');
    }


    //banco.setSaldo(_consulta("Cuánto dinero desea ingresar?")); 
  }

    void realizarDepositoInvitado() {

    num monto;
    String fecha = '';
    String causa = '';

      monto = _consultaNumerica('cuánto dinero desea depositar?', 1);
    
    num cuentaCliente = 3;
    if (monto > 0){
      _info('cuál es la causa del depósito?');
      causa = _consulta('');
      bool repetir = true;
      num nroCuentaDestino;
      String nombreCuentaDestino;
      num seRepite = 0;
      do{
        
        do{
          nroCuentaDestino = _consultaNumerica('indique el nro de cuenta donde desea depositar el dinero', 1);
        } while(!_cliente!.verificaExistencia(nroCuentaDestino));
        
        nombreCuentaDestino = _cliente!.conseguirNombre(nroCuentaDestino)!;

        seRepite = num.tryParse(_consulta('desea realizar la transferencia a $nombreCuentaDestino?\n 1.Si \n 2.No'))!;
        
        if(seRepite == 1){

          repetir = false;
          break;

        } else {

          continue;

        }
        
      } while(repetir!=true);

      try{
        monto = _banco.nuevoMovimiento(3, nroCuentaDestino, monto, fecha, causa);

      } catch(err) {
        print(err);
      }
      //monto = Banco.nuevoMovimiento(0, _cliente.getNroCuenta(), monto, fecha, causa);
      //num numeroDeCuentaOrigen, num numeroDeCuentaDestino, num monto, String fecha, String causa
      _success('depósito realizado con éxito a $nombreCuentaDestino.');
      _success('           Monto: $monto');
    }

  }


  void realizarTransferencia() {

    num monto;
    String fecha = '';
    String causa = '';

      monto = _consultaNumerica('cuánto dinero desea enviar?', 1);
    
    num cuentaCliente = _cliente!.getNroCuenta();
    if (monto <= _banco.getSaldo(cuentaCliente)){

      causa = _consulta('cual es la causa de la transferencia?');

      bool repetir = true;
      num nroCuentaDestino;
      String nombreCuentaDestino;
      num seRepite = 0;
      do{
        
        do{
          nroCuentaDestino = _consultaNumerica('indique el nro de cuenta de la persona a la que quiere realizar la transacción', 1);
        } while(!_cliente!.verificaExistencia(nroCuentaDestino));
        
        nombreCuentaDestino = _cliente!.conseguirNombre(nroCuentaDestino)!;

        seRepite = num.tryParse(_consulta('desea realizar la transferencia a $nombreCuentaDestino?\n 1.Si \n 2.No'))!;
        
        if(seRepite == 1){

          repetir = false;
          break;

        } else {

          continue;

        }
        
      } while(repetir!=true);

      try{
        monto = _banco.nuevoMovimiento(_cliente!.getNroCuenta(),nroCuentaDestino , monto, fecha, causa);

      } catch(err) {
        print(err);
      }
      //monto = Banco.nuevoMovimiento(0, _cliente.getNroCuenta(), monto, fecha, causa);
      //num numeroDeCuentaOrigen, num numeroDeCuentaDestino, num monto, String fecha, String causa
      _success('extracción realizada con éxito.');
      _success('         Monto: $monto');
    }

  }


  /// El usuario retira en efectivo cierta cantidad de dinero de su cuenta.
  void retirarEfectivo() {
  }

  /// El usuario envía cierta cantidad de dinero a otro.
  void transferir() {
  }

  /// COMPONENTES VISUALES
  void _titulo(String titulo) {
    print('$titulo');
  }

  void _opcion(int numero, String texto) {
    print('${_colors['magenta']}$numero.${_colors['reset']} $texto');
  }

  int _elegirOpcionInt (num max) {

    int ingreso = 0;
    while (ingreso == 0) {
      ingreso = int.tryParse(stdin.readLineSync()!)!;
      if (ingreso > max) {
        _warning('La opción ingresada no es correcta. Por favor, ingrese una de las opciones.');
        ingreso = 0;
      }
    }
    return ingreso;
  }

  String _consulta(String mensaje) {

    bool again = true;
    String rta = '';
    while(again) {


      print(mensaje);
      rta = stdin.readLineSync()!;
      if (rta != '') {
        again = false;
      } else {
        _warning('Por favor, ingrese un texto válido.');
      }

    }
    return rta;

  }

  num _consultaNumerica(String text, num tipo) {
    _info('$text');
    num dineroCliente = _banco.getSaldo(_cliente!.getNroCuenta());

    num? monto = 0;
    do{
      monto = num.tryParse(stdin.readLineSync()!)!;
      if (monto <= 0){
        _warning('el monto ingresado no es válido');
      } else {
        if(tipo == 0) {//tipo 0 es para transacciones, tipo 1 es para depósitos
          if(monto > dineroCliente) {
            _warning('el monto ingresado es mayor al saldo del usuario');
            monto = null;
          } else {
            return monto;
          }
        } else if (tipo == 1){
          return monto;
        }
      }
    }while (monto == null);
    return monto;
  }


  /// Celeste
  void _info(String mensaje) {
    print("${_colors['azul']}$mensaje ${_colors['reset']}");
  }

  /// Verde
  void _success(String mensaje) {
    print("${_colors['verde']}$mensaje ${_colors['reset']}");
  }

  /// Amarillo
  void _warning(String mensaje) {
    print("${_colors['amarillo']}$mensaje ${_colors['reset']}");
  }

  /// Rojo
  void _danger(String mensaje) {
    print("${_colors['rojo']}$mensaje ${_colors['reset']}");
  }

  void _showError(String mensaje) {
    _danger("--------------------------------------------------");
    _danger(mensaje);
    _danger("--------------------------------------------------");
  }

  static const _colors = {
    'reset': '\x1B[0m',
    'azul': '\x1B[36m',
    'amarillo': '\x1B[33m',
    'verde': '\x1B[32m',
    'rojo': '\x1B[31m',
    'magenta': '\x1B[35m'
  };

  void clear() {
    print(Process.runSync("clear", [], runInShell: true).stdout);
  }

}




/****************
Black:   \x1B[30m
Red:     \x1B[31m
Green:   \x1B[32m
Yellow:  \x1B[33m
Blue:    \x1B[34m
Magenta: \x1B[35m
Cyan:    \x1B[36m
White:   \x1B[37m
Reset:   \x1B[0m
****************/

///besto color #26E5CC