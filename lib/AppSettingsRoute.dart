import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toolbag/AppSettings.dart';

class AppSettingsRoute extends StatefulWidget {
  final ValueChanged<bool> parentAction;
  const AppSettingsRoute({Key key, this.parentAction}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AppSettingsRouteState();
  }
}

class _AppSettingsRouteState extends State<AppSettingsRoute> {
  bool _isDarkTheme;

  @override
  void initState() {
    _isDarkTheme = isDarkTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkTheme ? Colors.black : Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.popUntil(context, ModalRoute.withName("/")
            )
        ),
        title: Text("Settings"),
        backgroundColor: _isDarkTheme ? Colors.black : Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(3),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Change Theme", style: TextStyle(fontSize: 20, color: _isDarkTheme ? Colors.white : Colors.black,),),
              FlatButton(
                color: isDarkTheme ? Colors.grey[800] : Colors.blue,
                textColor: Colors.white,
                child: Text(_isDarkTheme ? "Dark Theme" : "Light Theme"),
                onPressed: () {
                  AppSettings.AppThemeChanger();
                  setState(() async {
                    await widget.parentAction(isDarkTheme);
                    _isDarkTheme = isDarkTheme;
                    await (context as Element).reassemble();
                  });
                  },
              )
            ],
          ),
        ],
      ),
    );
  }
}