import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'file.dart';
import 'body.dart';

class httpController {
  //String urlBase = "http://matome2009.php.xdomain.jp/tekken7/app/";
  String urlBase = "http://192.168.2.114/tekken7/app/";

  //  キャラクターリスト取得
  Future getTitleData() async {
    String url = '${urlBase}getTitleList.php';

    http.get(url)
        .then((response) {
      FileController().saveStringFile(response.body,"getTitleList.txt");
      });
  }

  //  キャラクターリスト取得
  Future getCharacterData() async {
    String url = '${urlBase}getCharacterList.php';
    await http.get(url)
        .then((response) {
        FileController().saveStringFile(response.body,"getCharacterList.txt");
    });
  }

  Future getcategoryData() async {
    String url = '${urlBase}getCategoryList.php';
    await http.get(url)
        .then((response) {
      FileController().saveStringFile(response.body, "getCategoryList.txt");
    });
  }

  Future getValueData(List _data,int index) async {
    String url = "${urlBase}getValueList.php?c=${_data[index][0]}&f=${_data[index][1]}";
    await new Future.delayed(new Duration(milliseconds: 1));
    await http.get(url)
        .then((response) {
      print("getValueDataList_${_data[index][0]}_${_data[index][1]}.txt");
      FileController().saveStringFile(response.body, "getValueDataList_${_data[index][0]}_${_data[index][1]}.txt");
    });
    return index;
  }

  void getValueData2(List _data,int index){
    httpController().getValueData(_data,index).then((a) {
      if(_data.length>index){
        MyBody.dlCnt=index;
        this.getValueData2(_data,index+1);
        MyBody.refresh(2);
      }else {
        MyBody.refresh(0);
      }
    });
  }


}