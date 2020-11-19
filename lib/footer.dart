import 'package:flutter/material.dart';
import 'body.dart';     // body.dart をインポート
import 'footer.dart';     // body.dart をインポート
import 'main.dart';     // body.dart をインポート

// グローバル変数
_Footer MyFooter = _Footer();


class Footer extends StatefulWidget{
    Footer();

    @override
    _Footer createState() => MyFooter;
}

class _Footer extends State<Footer> {
    int _selectedIndex = 0;
    final _bottomNavigationBarItems =  <BottomNavigationBarItem>[];

    // アイコン情報
    static const _footerIcons = [
        Icons.home,
        Icons.textsms,
    ];

    // アイコン文字列
    static const _footerItemNames = [
        'キャラ',
        'フレーム',
    ];

    @override
    void initState() {
        super.initState();
        _bottomNavigationBarItems.add(_UpdateActiveState(0));
        for (var i = 1; i < _footerItemNames.length; i++) {
            _bottomNavigationBarItems.add(_UpdateDeactiveState(i));
        }
    }

    /// インデックスのアイテムをアクティベートする
    BottomNavigationBarItem _UpdateActiveState(int index) {
        return BottomNavigationBarItem(
                icon: Icon(
                _footerIcons[index],
                color: Colors.black87,
        ),
        title: Text(
        _footerItemNames[index],
        style: TextStyle(
        color: Colors.black87,
        ),
        )
        );
    }

    /// インデックスのアイテムをディアクティベートする
    BottomNavigationBarItem _UpdateDeactiveState(int index) {
        return BottomNavigationBarItem(
                icon: Icon(
                _footerIcons[index],
                color: Colors.black26,
        ),
        title: Text(
        _footerItemNames[index],
        style: TextStyle(
        color: Colors.black26,
        ),
        )
        );
    }

    void _onItemTapped(int index) {
        if(index==_selectedIndex||MyBody.switch_id==2){
            return null;
        }
        setState(() {
            _bottomNavigationBarItems[index] = _UpdateDeactiveState(index);
            _bottomNavigationBarItems[_selectedIndex] = _UpdateActiveState(_selectedIndex);
            _selectedIndex = index;
            MyBody.refresh(index);
        });
    }

    void ItemTapped(int index) {
        setState(() {
            _bottomNavigationBarItems[index] = _UpdateDeactiveState(index);
            _bottomNavigationBarItems[_selectedIndex] = _UpdateActiveState(_selectedIndex);
            _selectedIndex = index;
        });
    }

    @override
    Widget build(BuildContext context) {
        return BottomNavigationBar(
                type: BottomNavigationBarType.fixed, // これを書かないと3つまでしか表示されない
                items: _bottomNavigationBarItems,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
        );
    }
}