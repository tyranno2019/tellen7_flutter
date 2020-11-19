import 'package:flutter/material.dart';
import 'main.dart';
import 'body.dart';
import 'file.dart';

// グローバル変数
_Header MyHeader = _Header();
class Header extends StatefulWidget with PreferredSizeWidget{

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _Header createState() => MyHeader;
}

class _Header extends State<Header> {

  String title="鉄拳フレーム";

  void setTitle(String _title){
    setState(() {title = _title;});
  }


  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.email, color: Colors.white,),
            onPressed: () {
              print("めもだすぜ");
              //----------------------
              if(MyBody.switch_id==1) {
                MyBody.switch_id = 3;
                MyBody.myController.text = "";
                try {
                  FileController().loadStringFile(
                      "${MyBody.characterId}_memo.txt").then((content) =>
                  MyBody.myController.text = content.toString());
                } catch (e) {
                  print(e);
                }
              }else if(MyBody.switch_id==2){
                return null;
              }else{
                MyBody.switch_id=1;
              }
              print("めもだすぜ2${MyBody.switch_id}");
              MyBody.setState(() {

              });
            }
        ),
      ]
    );
  }
}
