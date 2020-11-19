import 'package:flutter/material.dart';
import 'header.dart';     // body.dart をインポート
import 'footer.dart';   // footer.dart をインポート
import 'body.dart';     // body.dart をインポート

class Content{

  Widget getRowContents(List<Widget> widget, int _type){
      return
        Row(
          children:widget,
        );
  }
  Widget getColumnContents(List<Widget> widget, int _type){
    return
      Column(
        children : widget,
      );
  }

  /*
  下記
   */

  Widget ajestDiv(String _data,[int type]){
    //イメージ判定
    List<String> b = _data.split('"');
    //注釈判定
    List<String> c = _data.split('※');

    if(c.length>1) {

      return InkWell(
        child: Text(c[0]+"※"),
        onTap: () {
            MyBody.popup("説明",c[1]);
            print("value of your text");
          },
      );
    }

    List<Widget> tmpWidget = [];
    b = spritSpace(b);
    if(b.length<=1) {
      if(_data.contains('.bmp')) {
        return Align(
            alignment : Alignment.topLeft,
            child: Image.asset(_data.replaceAll('"','').replaceAll('../','assets/img/'))
        );
      }
      return Align(
          alignment : Alignment.topLeft,
          child: Text(_data),
      );
    }

    /*
    複数に分かれる場合
     */
    for (int i = 0; i < b.length; i++) {
      if(b[i].contains('.bmp')) {
        tmpWidget.add(Image.asset(b[i].replaceAll('../','assets/img/')));
      }else {
        tmpWidget.add(Expanded(child:Text(b[i])));
      }
    }


    if(type==1){
      return Wrap(
        children:tmpWidget,
      );
    }
    return Row(
      children:tmpWidget,
    );
  }


  List spritSpace(List b){
    for (int i = 0; i < b.length; i++) {
      if(b[i]==""){
        b.removeAt(i);
        return spritSpace(b);
      }
    }
    return b;
  }
}