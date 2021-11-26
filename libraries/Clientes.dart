import 'dart:convert';
import '../vendor/file_controller/FileController.dart';
import '../vendor/file_controller/FileControllerException.dart';
import './Exceptions/ClientesExceptions.dart';

class Cliente {

  num? _nroCuenta;
  String? _nombre;

  static List<dynamic> _usuarios = [];
  
  ///constructor cliente
  Cliente(String nombreUsuario, String contrasena, [num? nroCuenta]) {
    _cargarUsuarios();

    List<dynamic> usuariosValidos = _usuarios;

    for (int i = 0; i < usuariosValidos.length; i++) {
      if (usuariosValidos[i]['nombre'] == nombreUsuario && usuariosValidos[i]['contrasena'] == contrasena) {
        _nombre = nombreUsuario;
        _nroCuenta = usuariosValidos[i]['nroCuenta'];
      }
    }

    if (_nroCuenta == null) {
      throw LoginClientesException('Usuario y/o contraseña no encontrados.');
    }
  }


  ///guarda los usuarios en  la variable '_usuarios' de esta clase.
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

  ///Crea y registra un nuevo cliente. Recibe todos los datos del cliente.
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

  ///Valida la existencia de un usuario recibiendo su numero de usuario.
  static bool verificaExistencia(num numero) {
    _cargarUsuarios();
    for (int i = 0; i < _usuarios.length; i++) {
      if (_usuarios[i]["nroCuenta"] == numero) {
        return true;
      }
    }
    return false;
  }

  ///retorna el nombre del cliente
  String getNombre() => _nombre!;


  ///Retorna el nombre de un usuario, recibe el numero de la cuenta del usuario a buscar.
  static String? conseguirNombre(num numeroDeCuenta) {
    _cargarUsuarios();
    for (int i = 0; i < _usuarios.length; i++) {
      if (_usuarios[i]['nroCuenta'] == numeroDeCuenta) {
        return _usuarios[i]['nombre'];
      }
    }
  }
  

  ///retorna el numero de cuenta del objeto actual.
  num getNroCuenta() => _nroCuenta!;

  ///genera y retorna un numero que se puede usar para darle numero de cuenta a un nuevo usuario.
  ///El numero es 1 mas que el último creado.
  static num ultimoNumeroDeCuenta() {
    _cargarUsuarios();
    num ultimaCuenta = _usuarios.length;
    return ultimaCuenta;
  }
}