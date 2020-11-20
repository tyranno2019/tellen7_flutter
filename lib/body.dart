import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'header.dart';
import 'footer.dart';
import 'content.dart';
import 'rect.dart';
import 'file.dart';
import 'httpController.dart';
import 'dart:io'; // 追加
import 'movie.dart'; // 追加

// グローバル変数
_Body MyBody = _Body();


class Body extends StatefulWidget{
  Body();
  @override
  _Body createState() => MyBody;
}

class _Body extends State<Body> {

  //  Bodyスイッチング
  int switch_id= 0;
  Widget Body_Widget;
  int characterId=0;
  List<Widget> Bodywidget = [];
  int getFlag=0;
  int wait=0;
  int dlCnt=0;
  int dlBaseCnt=0;

  @override
  void initState({int init}) {
    //httpController().getTitleData();
    //httpController().getCharacterData();
    //httpController().getcategoryData();

    _getCharacterData().then((content)
    => _getcategoryData().then((content2)=> _getTitleData()
    ));
    if(init==null) return null;

    switch_id=2;
    httpController().getTitleData().then((d){
      httpController().getCharacterData().then((c) {
        httpController().getcategoryData().then((e){
          _getTitleData();
          List UrlList=[];
          int cnt=0;

          _getCharacterData().then((content)
          => _getcategoryData().then((content2)
          {
            content.forEach((charaID) {
              content2.forEach((cateID) {
                //_getValueData(int.parse(charaID[0]), int.parse(cateID[0]), cateID[1]);
                //httpController().getValueData(int.parse(charaID[0]), int.parse(cateID[0]),0).then((a)=>print("end"));
                //UrlList.addAll({cnt++:[int.parse(charaID[0]), int.parse(cateID[0])]});
                List tmp = [int.parse(charaID[0]), int.parse(cateID[0])];
                UrlList.add(tmp);
                print([int.parse(charaID[0]), int.parse(cateID[0])]);
                //UrlList.addAll([int.parse(charaID[0]), int.parse(cateID[0])],httpController().getUr(int.parse(charaID[0]), int.parse(cateID[0])));
                //httpController().getValueData(int.parse(charaID[0]), int.parse(cateID[0])).then((a) {});
              });
            });
            dlBaseCnt = UrlList.length+1;
            dlCnt=0;
            //print(UrlList);
            httpController().getValueData2(UrlList,0);
          })
          );
        });
      });
    });


    //super.initState();
  }




  void refresh(int index) {
    setState(() {
        switch_id = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    Content content = Content();
    if(_categoryData != null && getFlag>=1) {
      _getValueData(characterId, int.parse(_categoryData[getFlag-1][0]), _categoryData[getFlag-1][1]);
      if(getFlag==_categoryData.length){
        getFlag=0;
        switch_id = 1;
      }else{
        getFlag++;
      }
    }

    if(switch_id==0) {
      Body_Widget = Container(
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // グリッド横方向のウィジェット数
              crossAxisCount: 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              // グリッド表示するウィジェットの縦横比
              childAspectRatio: 4,
            ), // グリッドに表示したいウィジェットの数
            itemCount: _data.length,
            itemBuilder: (context, index) {
              return
                GestureDetector(
                  child:
                  Container(
                    color: Colors.grey,
                    child: Image.asset("assets/img/character/${_data[index][0]}.png"),
                    margin: EdgeInsets.all(0),
                  ),
                  onTap: () {
                    setState(() {
                      MyHeader.setTitle(_data[index][1]);
                      characterId=int.parse(_data[index][0]);
                      switch_id = 2;
                      Bodywidget = [];
                      getFlag=1;
                    });
                    MyFooter.ItemTapped(1);
                  },
                );
            }),
      );
    }else if(switch_id==1){
      Body_Widget = Container(
          child:
          GridView.builder(

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // グリッド横方向のウィジェット数
              crossAxisCount: 1,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              // グリッド表示するウィジェットの縦横比
              childAspectRatio: 5,
            ), // グリッドに表示したいウィジェットの数
            itemCount: Bodywidget.length,
            itemBuilder: (context, index) {
            return
              GestureDetector(
                child: Bodywidget[index],
              );
          }),
      );
    }else if(switch_id==2) {
      if(dlCnt==dlBaseCnt) {
        Body_Widget = Center( child: Text("ロード中") );
      }else{
        Body_Widget = Center( child: Text("ダウンロード中 ${dlCnt}/${dlBaseCnt}") );
      }
    }else if(switch_id==3) {
      Body_Widget = textArea(characterId);
    }
    return Body_Widget;
  }

  //  キャラクターリスト取得
  List _data=[];
  Future<List> _getCharacterData() async {

    Future rest = FileController().loadStringFile("getCharacterList.txt");
    await  rest.then((content)=>
        setState(() {
          List<String> t_data =  content.toString().split("\n");
          for (int i = 0; i < t_data.length; i++) {
            _data.add(t_data[i].split("|"));
          }
        })
    );
    return _data;
  }



  List _categoryData =[];
  Future<List> _getcategoryData() async {
    if(_categoryData.isNotEmpty) _categoryData=[];

    Future rest = FileController().loadStringFile("getCategoryList.txt");
    await rest.then((content)=>
        setState(() {
          List t_categoryData =  content.toString().split("\n");
          for (int i = 0; i < t_categoryData.length; i++){
            _categoryData.add(t_categoryData[i].split("|"));
          }
/*          setState(() {
            getFlag = 1;
          });*/
        })
    );
    return _categoryData;
  }

  Map<int, Map> _valueData=Map();
  void _getValueData(int characterId, int flameCategoryId,String categoryTitle) {
    try {
      //print("getValueDataList_${characterId}_${flameCategoryId}.txt");
      Future rest = FileController().loadStringFile(
          "getValueDataList_${characterId}_${flameCategoryId}.txt");
      rest.then((content) => _getValueData2(characterId,flameCategoryId,categoryTitle, content.toString()));
    }catch(e){
    }
  }

  void _getValueData2(int characterId, int flameCategoryId,String categoryTitle,String content) {

        List t_valueData =  content.split("@@@");
        if(t_valueData.length>1) {
          for (int i = 0; i < t_valueData.length; i++) {
            List tmp = t_valueData[i].split("|");
            if (_valueData[flameCategoryId] == null) {
              _valueData.addAll({
                flameCategoryId: Map()
              });
              _valueData[flameCategoryId].addAll({
                int.parse(tmp[2]): Map()
              });
              _valueData[flameCategoryId][int.parse(tmp[2])].addAll(
                  { int.parse(tmp[0]): [int.parse(tmp[0]), tmp[1]]});
            } else {
              if (_valueData[flameCategoryId][int.parse(tmp[2])] == null) {
                _valueData[flameCategoryId].addAll({
                  int.parse(tmp[2]): Map()
                });
                _valueData[flameCategoryId][int.parse(tmp[2])].addAll(
                    { int.parse(tmp[0]): [int.parse(tmp[0]), tmp[1]]});
              } else {
                _valueData[flameCategoryId][int.parse(tmp[2])].addAll(
                    { int.parse(tmp[0]): [int.parse(tmp[0]), tmp[1]]});
              }
            }
          }

          //print( _valueData[flameCategoryId]);
          Content content = Content();

          //  カテゴリー追加
          Bodywidget.add(
            Text(categoryTitle),
          );



          RectNormal RN = RectNormal();
          int first = 1;
          _valueData[flameCategoryId].forEach((key, value) {
            List<Widget> tmpWidgets = [];
            List<Widget> tmpTitleWidgets = [];
            Widget tmpWidget;
            value.forEach((key2, value2) {
              if(key2<=RN.titleColumn) {
                  if (key2 == 1) {
                  tmpTitleWidgets.add(
                      Expanded(
                        flex:RN.flex[1],
                        child:
                        Container(color: Colors.blue,
                          margin: EdgeInsets.all(1),
                          height: 300,
                          child:
                          SingleChildScrollView(
                            child: Column(
                                children:
                                [
                                  content.ajestDiv(_dataTitle[value[1][0]]),
                                  content.ajestDiv(_dataTitle[value[2][0]]),
                                  content.ajestDiv(_dataTitle[value[3][0]]),
                                ]
                            ),
                          ),
                        ),
                      ),
                  );

                  tmpWidgets.add(
                      Expanded(
                        flex:RN.flex[1],
                        child:
                        Container(color: Colors.blue,
                          margin: EdgeInsets.all(1),
                          height: 300,
                          child:
                          SingleChildScrollView(
                            child: Column(
                                children:
                                [
                                  content.ajestDiv(value[1][1]),
                                  content.ajestDiv(value[2][1]),
                                  content.ajestDiv(value[3][1]),
                                ]
                            ),
                          ),
                        ),
                      ),
                  );
                }
              }else if(key2==RN.lastColumnkey){
                tmpTitleWidgets.add(
                  Expanded (
                    flex:RN.flex[key2],
                    child:
                    Container(
                        margin: EdgeInsets.all(1),
                        color: Colors.red,
                        height: 300,
                        child:
                        SingleChildScrollView(
                          child: content.ajestDiv(_dataTitle[value2[0]]),
                        )
                    ),
                  ),
                );

                tmpWidget =content.ajestDiv(value2[1],1);
                tmpWidgets.add(
                  Expanded (
                   flex:RN.flex[key2],
                   child:
                  Container(
                    margin: EdgeInsets.all(1),
                    color: Colors.red,
                    height: 300,
                    child:
                      SingleChildScrollView(
                        child: tmpWidget,
                    )
                  ),
                 ),
                );

              }else{
                tmpTitleWidgets.add(
                  Expanded (
                    flex:RN.flex[key2],
                    child:
                    Container(
                        margin: EdgeInsets.all(1),
                        color: Colors.red,
                        height: 300,
                        child:
                        SingleChildScrollView(
                          child: content.ajestDiv(_dataTitle[value2[0]]),
                        )
                    ),
                  ),
                );

                tmpWidget =content.ajestDiv(value2[1]);
                tmpWidgets.add(
                    Expanded(
                      flex:RN.flex[key2],
                      child:
                      Container(
                        margin: EdgeInsets.all(1),
                        color: Colors.blue,
                        height: 300,
                        child:
                          SingleChildScrollView(
                            child: tmpWidget,
                          )
                      ),
                  ),
                );
              }
            });
            if(first==1) {
              Bodywidget.add(
                  content.getRowContents(tmpTitleWidgets, 1)
              );
              first=0;
            }
            Bodywidget.add(
                content.getRowContents(tmpWidgets, 1)
            );
            setState(() {
            });
          });
        }else{
          setState(() {});
        }

  }



  //  キャラクターリスト取得
  Map<int,String> _dataTitle=Map();
  void _getTitleData() async {
    Future rest = FileController().loadStringFile("getTitleList.txt");
    rest.then((content)=>
        setState(() {
          List<String> t_data =  content.toString().split("@@@");
          for (int i = 0; i < t_data.length; i++) {
            List t = t_data[i].split("|");

            _dataTitle.addAll(
                {int.parse(t[0]) : t[1]}
            );
          }
        })
    );
  }

  void popup(String _title,String _text){
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(_title),
          content: Text(_text),
          actions: <Widget>[
            // ボタン領域
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void popup2(){
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: VideoPlayerPage(),
          actions: <Widget>[
            // ボタン領域
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  final myController  = new TextEditingController(text: "");
  String _text='';
  Widget textArea(int characterId){
    return Container(
        padding: const EdgeInsets.all(50.0),
        child:
            new TextFormField(
                autofocus: false,
                controller: myController,
                maxLength: null,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: _handleText,
            ),
        );
  }
  void _handleText(String e) {
    setState(() {
      FileController fcontroller = FileController();
      fcontroller.saveStringFile(e, "${characterId}_memo.txt");

    });
  }

}
