import 'dart:io';
import './FileControllerException.dart';

///usa filepath, no file.


class FileController {

  String content = '';
  
  ///retorna un String con el contenido de un archivo recibiendo la ubicación del archivo
  String getDataFromFile(String filepath) {
    File file = File(filepath);
    try {
      content = file.readAsStringSync();
    } on FileSystemException catch (err) {
      throw FileControllerException("No fue posible leer el archivo. Motivo: $err");
    }
    return content;
  }


  ///escribe un archivo recibiendo la ubicación del archivo y lo que tiene que escribir
  void writeFile(String filepath, String content) {
    File file = File(filepath);
    file.writeAsStringSync('$content');
  }
  

  ///Agrega a un archivo una data, si ya tenía data escrita, no la borra, sino que escribe a continuación.
  void addToFile(String filepath, String content) {
    File file = File(filepath);
    String initialContent = file.readAsStringSync();
    if (initialContent.isEmpty) {
      file.writeAsStringSync('$content');
    } else {
      file.writeAsStringSync('$initialContent\n$content');
    }
  }
}
