import 'dart:convert';
import '../vendor/file_controller/FileController.dart';
import '../vendor/file_controller/FileControllerException.dart';
import './Exceptions/ClientesExceptions.dart';

class Cliente {

  num? _nroCuenta;
  String? _nombre;
  // ignore: unused_field
  String? _contrasena;

  static List<dynamic> _usuarios = [];
  
  ///constructor cliente
  Cliente(String nombreUsuario, String contrasena, [num? nroCuenta]) {
    _cargarUsuarios();

    List<dynamic> usuariosValidos = _usuarios;

    for (int i = 0; i < usuariosValidos.length; i++) {
      if (usuariosValidos[i]['nombre'] == nombreUsuario && usuariosValidos[i]['contrasena'] == contrasena) {
        _nombre = nombreUsuario;
        _contrasena = contrasena;
        _nroCuenta = _nroCuenta;
      }
    }
    if (nombreUsuario == 'invitado' && contrasena == 'abcdefghijklmnopqrstuvwxyz'){
      _nombre = 'invitado';
      _contrasena = 'abcdefghijklmnopqrstuvwxyz';
      _nroCuenta = 3;
    }else if (_nroCuenta == null) {//(!_nroCuenta)
      throw LoginClientesException('Usuario y/o contraseña no encontrados.');
    }

  }

  static void _cargarUsuarios() {
    if (_usuarios.isEmpty) {
      FileController fileController = FileController();

      String clientesJSON;

      try {
        clientesJSON = fileController.getDataFromFile('./db/Clientes.json');
      } on FileControllerException catch(err) {
        throw FatalClientesException(err.toString());
      }

      List<dynamic> usuariosValidos;

      try {
        usuariosValidos = jsonDecode(clientesJSON);
      } catch (err) {
        throw FatalClientesException(err.toString());
      }

      _usuarios = usuariosValidos;
    }
  }

  static num nuevoCliente(String nombre, String contrasena, String fechaNacimiento, List<num> telefonos) {
    _cargarUsuarios();

    num nroCuenta = ultimoNumeroDeCuenta();

    _usuarios.add({
      'nombre' : '$nombre',
      'contrasena' : '$contrasena',
      'nroCuenta' : nroCuenta,
      'nacimiento' : '$fechaNacimiento',
      'telefonos' : telefonos,
    });

    FileController fileController = FileController();

    fileController.writeFile('./db/Clientes.json', jsonEncode(_usuarios));
    
    return nroCuenta;    
  }

  bool verificaExistencia(num numero){

    for(int i = 0; i < _usuarios.length; i++){

      if(_usuarios[i]["nroCuenta"] == numero){
        return true;
      }

    }
    return false;

  }

  String getNombre() => _nombre!;

  /// Muestra al usuario su historial de transacciones
  getHistorial() {}

  /// El usuario crea un pago que debe tener un remitente,un monto y un receptor. 
  nuevoPago() {}

  String? conseguirNombre(num numeroDeCuenta){

    for(int i = 0; i < _usuarios.length; i++){
      if (_usuarios[i]['nroCuenta'] == numeroDeCuenta){
        return _usuarios[i]['nombre'];
      }
    }

  }

  ///
  num getNroCuenta() => _nroCuenta!;

  /// ???
  nuevaTransferencia() {}


  static num ultimoNumeroDeCuenta() {

    _cargarUsuarios();
    //_usuarios
    num ultimaCuenta = _usuarios.length;
    return ultimaCuenta;
  }


}