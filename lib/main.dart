import 'package:flutter/material.dart';
import 'header.dart';     // body.dart をインポート
import 'footer.dart';   // footer.dart をインポート
import 'body.dart';     // body.dart をインポート





double width;
double height;


void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '鉄拳フレームデータ',
      home: Scaffold(
        appBar:Header(),
        body:Body(),
        bottomNavigationBar: Footer(),
        // bodyで表示したいウィジェットを別のメソッドに切り出す
      ),
    );
  }
}



