import 'package:flutter/material.dart';
import 'package:toolbag/AppSettingsRoute.dart';
import 'package:toolbag/ToDoListRoute.dart';
import 'package:toolbag/AppSettings.dart';
import 'Calculator.dart';
import 'ToDoListManager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ToDoListManager toDoListManager = new ToDoListManager();
  await AppSettings.AppThemeReader();
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => HomeRoute(),
      "/toDoList": (context) => ToDoListRoute(),
      "/calculator": (context) => Calculator(),
    },
  ));
}
class HomeRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
   return _HomeRouteState();
  }
}

class _HomeRouteState extends State<HomeRoute> {
  bool _isDarkTheme;

  void updateTheme(bool value) async{
    setState(() {
      _isDarkTheme = !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text("Toolbag App"),
        backgroundColor: isDarkTheme ? Colors.black : Colors.blue,
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        crossAxisCount: 1,
        childAspectRatio: 2.5,
        children: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[
                Icon(Icons.fact_check_outlined, size: 40,),
                SizedBox(width: 20,),
                Text("ToDo List", style: TextStyle(fontSize: 25),),
              ],
            ),
            onPressed: () => Navigator.pushNamed(context, "/toDoList"),
            color: isDarkTheme ? Colors.grey[800] : Colors.blue,
            textColor: Colors.white,
          ),
          FlatButton(
            child: Row(
              children: <Widget>[
                Icon(Icons.calculate_outlined, size: 40,),
                SizedBox(width: 20,),
                Text("Calculator", style: TextStyle(fontSize: 25),),
              ],
            ),
            onPressed: () => Navigator.pushNamed(context, "/calculator"),
            color: isDarkTheme ? Colors.grey[800] : Colors.blue,
            textColor: Colors.white,
          ),
          FlatButton(
            child: Row(
              children: <Widget>[
                Icon(Icons.settings, size: 40,),
                SizedBox(width: 20,),
                Text("Settings", style: TextStyle(fontSize: 25),),
              ],
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AppSettingsRoute(parentAction: updateTheme))),
            color: isDarkTheme ? Colors.grey[800] : Colors.blue,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}