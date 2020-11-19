import 'dart:async';
import 'dart:io'; // 追加
import 'package:path_provider/path_provider.dart';

class FileController {

  // ドキュメントのパスを取得
  Future<File> getFilePath(String _fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File(directory.path + '/' + _fileName);
  }

  // 画像をドキュメントへ保存する。
  // 引数にはカメラ撮影時にreturnされるFileオブジェクトを持たせる。
  Future<String> loadStringFile(String _fileName) async {
    final file = await getFilePath(_fileName);
    return file.readAsString();
  }

  void saveStringFile(String _data,String _fileName) async {
    final path = await getApplicationDocumentsDirectory();
    final filePath = path.path+'/$_fileName';
    File stringFile = File(filePath);
    // カメラで撮影した画像は撮影時用の一時的フォルダパスに保存されるため、
    // その画像をドキュメントへ保存し直す。
    await stringFile.writeAsString(_data);
  }

  Future<int> checkFile(String _fileName) async {
    final file = await getFilePath(_fileName);
    try {
      File(file.path).exists();
      return 1;
    } catch (e, s) {
      return 0;
    }
  }
}