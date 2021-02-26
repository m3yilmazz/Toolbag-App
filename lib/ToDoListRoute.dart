import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toolbag/AppSettings.dart';
import 'package:toolbag/Enums.dart';
import 'package:toolbag/ToDoListItemRoute.dart';
import 'ToDoListManager.dart';
import 'ToDoListTitleModel.dart';

ToDoListTitleModel globalToDoListTitleModel = new ToDoListTitleModel();

class ToDoListRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ToDoListRouteState();
  }
}

class _ToDoListRouteState extends State<ToDoListRoute>{
  Future<List<ToDoListTitleModel>> _future;
  final textFieldController = TextEditingController();
  bool _isDarkTheme;

  @override
  initState()  {
    _future = ToDoListManager.getAllToDoListTitles();
    _isDarkTheme = isDarkTheme;
    super.initState();
  }

  Card buildItem(ToDoListTitleModel toDoListTitleModel) {
    TextEditingController textFieldControllerForEditingTitle = TextEditingController();
    textFieldControllerForEditingTitle.text = toDoListTitleModel.title;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Flexible(
                child: GestureDetector(
                  child: Text(
                    "${toDoListTitleModel.title}",
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    globalToDoListTitleModel = toDoListTitleModel;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ToDoListItemRoute(toDoListTitleModel)));
                  },
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    child: Container(
                        width: 50,
                        child: Icon(Icons.edit)
                    ),
                    onTap: () {
                      showDialog(
                        child: Dialog(
                          child: ListView(
                            padding: EdgeInsets.all(5),
                            shrinkWrap: true,
                            children: <Widget>[
                              Text("Do you want to edit this title?"),
                              TextFormField(
                                controller: textFieldControllerForEditingTitle,
                              ),
                              RaisedButton(
                                  color: _isDarkTheme ? Colors.black : Colors.blue,
                                  textColor: Colors.white,
                                  child: Text("Save"),
                                  onPressed: () async {
                                    if(toDoListTitleModel.title != textFieldControllerForEditingTitle.text){
                                      ToDoListManager.updateToDoListTitle(
                                          ToDoListTitleModel(
                                            id: toDoListTitleModel.id,
                                            title: textFieldControllerForEditingTitle.text.toString(),
                                            isCompleted: toDoListTitleModel.isCompleted,
                                          )
                                      );
                                      setState(() {
                                        _future = ToDoListManager.getAllToDoListTitles();
                                      });
                                      textFieldControllerForEditingTitle.clear();
                                    }
                                    Navigator.pop(context);
                                  }
                              ),
                              RaisedButton(
                                color: _isDarkTheme ? Colors.black : Colors.blue,
                                textColor: Colors.white,
                                child: Text("Discard"),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                        context: context,
                      );
                    },
                  ),
                ),
                Container(
                  child: GestureDetector(
                    child: Icon(Icons.clear),
                    onTap: () {
                      showDialog(
                        child: Dialog(
                          child: ListView(
                            padding: EdgeInsets.all(5),
                            shrinkWrap: true,
                            children: <Widget>[
                              Text("Do you want to delete this item?"),
                              RaisedButton(
                                  color: _isDarkTheme ? Colors.black : Colors.blue,
                                  textColor: Colors.white,
                                  child: Text("Yes"),
                                  onPressed: () async {
                                    ToDoListManager.deleteAllToDoListItemsByTitleId(toDoListTitleModel.id);
                                    ToDoListManager.deleteToDoListTitle(toDoListTitleModel.id);
                                    setState(() {
                                      _future = ToDoListManager.getAllToDoListTitles();
                                    });
                                    Navigator.pop(context);
                                  }
                              ),
                              RaisedButton(
                                color: _isDarkTheme ? Colors.black : Colors.blue,
                                textColor: Colors.white,
                                child: Text("No"),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                        context: context,
                      );
                    },
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkTheme ? Colors.black : Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
                Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.popUntil(context, ModalRoute.withName("/")
            )
        ),
        title: Text("ToDo List"),
        backgroundColor: _isDarkTheme ? Colors.black : Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(3),
        children: <Widget>[
          FutureBuilder<List<ToDoListTitleModel>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data.map((toDoListTitleModel) => buildItem(toDoListTitleModel)).toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _isDarkTheme ? Colors.grey[800] : Colors.blue,
        heroTag: "addTitleButton",
        label: Text("Add Title"),
        icon: Icon(Icons.add),
        onPressed: () {
          showDialog(
            child: Dialog(
              child: ListView(
                padding: EdgeInsets.all(5),
                shrinkWrap: true,
                children: <Widget>[
                  TextField(
                    controller: textFieldController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter a title",
                    ),
                  ),
                  RaisedButton(
                      color: _isDarkTheme ? Colors.black : Colors.blue,
                      textColor: Colors.white,
                      child: Text("Add Title"),
                      onPressed: () async {
                        ToDoListManager.insertToDoListTitle(new ToDoListTitleModel(
                            id: null,
                            title: textFieldController.text.toString(),
                            isCompleted: isTaskCompleted.no.index
                        ));
                        setState(()  {
                          _future = ToDoListManager.getAllToDoListTitles();
                        });
                        textFieldController.clear();
                        Navigator.pop(context);
                      }
                  ),
                ],
              ),
            ),
            context: context,
          );
        },
      ),
    );
  }
}