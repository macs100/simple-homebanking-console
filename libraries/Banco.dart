import 'dart:convert';
import './Exceptions/BancoExceptions.dart';
import './Exceptions/MovimientosExceptions.dart';
import './Exceptions/ClientesExceptions.dart';
import '../vendor/file_controller/FileController.dart';
import '../vendor/file_controller/FileControllerException.dart';


class Banco {
  
  /// Nombre del Banco
  String? _nombre;

  /// Ruta al archivo de DB de movimientos 
  String? _origenMovimientos;
  
  ///Lista de movimientos que uso en el getSaldo.
  List<dynamic> _movimientos = [];

  /// Objeto file controller
  FileController fileController = FileController();

  /// Cargar configuración inicial del banco, iniciar 
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

  /// Obtener el nombre del banco
  String getNombre() {
    return this._nombre!;
  }

  /// retorna el saldo del usuario
  num getSaldo(num nroDeCuenta) {
    num contador = 0;
    for (int i = 0; i < _movimientos.length; i++) {
      if (_movimientos[i]['destino'] == nroDeCuenta) {
        contador += _movimientos[i]['monto'];
      }
      if (_movimientos[i]['origen'] == nroDeCuenta) {
        contador -= _movimientos[i]['monto'];
      }
    }
    return contador;
  }
  
  /// Crea un movimiento y graba la transacción
  num nuevoMovimiento(num numeroDeCuentaOrigen, num numeroDeCuentaDestino, num monto, String fecha, String causa) {
    _movimientos.add({
      'origen': numeroDeCuentaOrigen == 0 ? 'depósito' : numeroDeCuentaOrigen,
      'monto': monto,
      'destino': numeroDeCuentaDestino,
      'fecha': fecha,
      'causa': causa,
    });
    fileController.writeFile('./db/Movimientos.json', jsonEncode(_movimientos));
    return monto;
  }
}

