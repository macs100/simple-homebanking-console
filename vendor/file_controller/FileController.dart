import 'dart:io';
import './FileControllerException.dart';

///usa filepath, no file.

class FileController {

  String content = '';
  
  String getDataFromFile(String filepath) {
    File file = File(filepath);
    try {
      content = file.readAsStringSync();
    } on FileSystemException catch (err) {
      throw FileControllerException("No fue posible leer el archivo. Motivo: $err");
    }
    return content;
  }

  void writeFile(String filepath, String content) {
    File file = File(filepath);
    file.writeAsStringSync('$content');
  }

  ///que el banco pueda usar file controller y obtener el contenido del archivo.

  void addToFile(String filepath, String content) {
    File file = File(filepath);
    String initialContent = file.readAsStringSync();
    if (initialContent.isEmpty) {
      file.writeAsStringSync('$content');
    } else {
      file.writeAsStringSync('$initialContent\n$content');
    }
  }

  ///File historialSuma = File ('./historialSuma.txt');

}