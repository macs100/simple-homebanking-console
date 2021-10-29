import 'dart:convert';
import './Exceptions/BancoExceptions.dart';
import './Exceptions/MovimientosExceptions.dart';
import './Exceptions/ClientesExceptions.dart';
import '../vendor/file_controller/FileController.dart';
import '../vendor/file_controller/FileControllerException.dart';
/*import 'dart:convert';*/
/*
 Map json = {
    'name' : 'Kasper Peulen',
    'best_language': 'dart',
    'best_chat': 'https://dartlang.slack.com'
  };
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String prettyprint = encoder.convert(json);
  print(prettyprint);
*/


class Banco {
  
  /// Nombre del Banco
  String? _nombre;

  /// Ruta al archivo de DB de movimientos 
  String? _origenMovimientos;

  String? _origenUsuarios;
  
  ///Lista de movimientos que uso en el getSaldo.
  List<dynamic> _movimientos = [];

  /// Objeto file controller
  FileController fileController = FileController();

  /// Cargar configuración inicial
  Banco() {

    String configBancoJSON;
    try {
      configBancoJSON = this.fileController.getDataFromFile('./env/config.json');
    } on FileControllerException catch(err) {
      throw FatalBancoException(err.toString());
    }
    
    Map<String, dynamic> configBanco;
    try {
      configBanco = jsonDecode(configBancoJSON);
    } catch (err) {
      throw FatalBancoException(err.toString());
    }
    
    this._nombre = configBanco['nombreBanco'];
    this._origenUsuarios = configBanco['origenUsuarios'];
    this._origenMovimientos = configBanco['origenMovimientos'];


    FileController fileController = FileController();

    String _movimientosJSON;

    try{
      _movimientosJSON = fileController.getDataFromFile(_origenMovimientos!);
    } on FileControllerException {
      throw FatalBancoMovimientosException();
    }
    

    try {
      _movimientos = jsonDecode(_movimientosJSON);
    } catch (err) {
      throw FatalBancoMovimientosException();
    }


  }
  ///es buena costumbre tener el nombre de la clase en el nombre de la exception.
  
  /// Setear nombre del banco
  setNombre() {}

  /// Obtener el nombre del banco
  String getNombre() {
    return this._nombre!;
  }

  /// muestra en pantalla todo el historial de movimientos
  List listaMovimientos(num nroDeCuenta) { //por ahora no se usa
    List userMovimientos = [];

    for(int i = 0; i < _movimientos.length; i++) {
      if (_movimientos[i]['destino'] == nroDeCuenta || _movimientos[i]['origen'] == nroDeCuenta) {
        userMovimientos.add(_movimientos[i]);
      }
    }

    return userMovimientos;
  }

  

  /// muestra en pantalla todos los clientes
  listaClientes() {


    String clientesJSON;
    try {
      clientesJSON = fileController.getDataFromFile('./db/Clientes.json');
    } on FileControllerException catch(err) {
      throw FatalClientesException(err.toString());
    }

    List<dynamic> listaUsuarios;
    try {
      listaUsuarios = jsonDecode(clientesJSON);
    } catch (err) {
      throw FatalClientesException(err.toString());//ya existe
    }


    List clientesRetornables = [];
    for(int i = 0; i < listaUsuarios.length; i++) {
      clientesRetornables.add(listaUsuarios[i]);
    }
    return clientesRetornables;
  }

  /// Una persona confirma la transacción que el cajero espera.
  //_confirmarTransaccion() {}

  /// 
  getSaldo(num nroDeCuenta) {
    num contador = 0;
    for (int i = 0; i < _movimientos.length; i++) {
      if(_movimientos[i]['destino'] == nroDeCuenta){
        contador += _movimientos[i]['monto'];
      }
      if(_movimientos[i]['origen'] == nroDeCuenta){
        contador -= _movimientos[i]['monto'];
      }
    }
    return contador;
  
  }
  
  /*static _cargarMovimientos() {
    FileController fileController = FileController();
    String _movimientosJSON = fileController.getDataFromFile("./db/Movimientos.json");
    List<dynamic> movimientosCargados = jsonDecode(_movimientosJSON);
  }*/
  
  /// Crea un movimiento
  num nuevoMovimiento(num numeroDeCuentaOrigen, num numeroDeCuentaDestino, num monto, String fecha, String causa) {


    if (numeroDeCuentaOrigen == 0){

      _movimientos.add({
        'origen':'depósito',
        'monto':monto,
        'destino':numeroDeCuentaDestino,
        'fecha':'$fecha',
        'causa':'$causa',
      });

    } else {
      
      _movimientos.add({
        'origen' : numeroDeCuentaOrigen,
        'monto' : monto,
        'destino' : numeroDeCuentaDestino,
        'fecha' : '$fecha',
        'causa' : '$causa',
      });
      
    }
    fileController.writeFile('./db/Movimientos.json', jsonEncode(_movimientos));
    return monto;
  }


  

  /// confirma la creación de un movimiento y lo guarda en movimientos.txt
  /*_guardarMovimiento() {
    
  }*/
  
  /// confirma la creación de un usuario y lo guarda en clientes.txt
  /*_guardarCliente() {}*/




}

