import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toolbag/Enums.dart';
import 'package:toolbag/ToDoListTitleModel.dart';
import 'package:toolbag/ToDoListManager.dart';
import 'AppSettings.dart';
import 'ToDoListItemModel.dart';
import 'ToDoListManager.dart';

class ToDoListItemRoute extends StatefulWidget{
  ToDoListTitleModel toDoListTitleObject;
  ToDoListItemRoute(this.toDoListTitleObject);

  @override
  State<StatefulWidget> createState() {
    return _ToDoListItemRouteState();
  }
}

class _ToDoListItemRouteState extends State<ToDoListItemRoute>{
  Future<List<ToDoListItemModel>> _future;
  final textFieldControllerForItem = TextEditingController();
  bool _isDarkTheme;

  @override
  initState()  {
    _future = ToDoListManager.getToDoListItemsByTitleId(widget.toDoListTitleObject.id);
    _isDarkTheme = isDarkTheme;
    super.initState();
  }

  Card buildItem(ToDoListItemModel toDoListItemModel) {
    TextEditingController textFieldControllerForEditingItemName = TextEditingController();
    textFieldControllerForEditingItemName.text = toDoListItemModel.itemName;

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
                    "${toDoListItemModel.itemName}",
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    showDialog(
                        child: Dialog(
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "${toDoListItemModel.itemName}",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                child: RaisedButton(
                                  color: _isDarkTheme ? Colors.black : Colors.blue,
                                  textColor: Colors.white,
                                  child: Text("Close"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        context: context,
                    );
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
                                controller: textFieldControllerForEditingItemName,
                              ),
                              RaisedButton(
                                  color: _isDarkTheme ? Colors.black : Colors.blue,
                                  textColor: Colors.white,
                                  child: Text("Save"),
                                  onPressed: () async {
                                    if(toDoListItemModel.itemName != textFieldControllerForEditingItemName.text){
                                      ToDoListManager.updateToDoListItem(
                                          ToDoListItemModel(
                                            id: toDoListItemModel.id,
                                            titleId: toDoListItemModel.titleId,
                                            itemName: textFieldControllerForEditingItemName.text.toString(),
                                            isCompleted: toDoListItemModel.isCompleted,
                                          )
                                      );
                                      setState(() {
                                        _future = ToDoListManager.getToDoListItemsByTitleId(toDoListItemModel.titleId);
                                      });
                                      textFieldControllerForEditingItemName.clear();
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
                                        ToDoListManager.deleteToDoListItem(toDoListItemModel.id);
                                        setState(() {
                                          _future = ToDoListManager.getToDoListItemsByTitleId(widget.toDoListTitleObject.id);
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _isDarkTheme ? Colors.black : Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.popUntil(context, ModalRoute.withName("/toDoList")
            )
        ),
        title: Text("${widget.toDoListTitleObject.title}"),
        backgroundColor: _isDarkTheme ? Colors.black : Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(3),
        children: <Widget>[
          FutureBuilder<List<ToDoListItemModel>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data.map((toDoListItemModel) => buildItem(toDoListItemModel)).toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton.extended(
                backgroundColor: _isDarkTheme ? Colors.grey[800] : Colors.blue,
                heroTag: "addItemButton",
                label: Text("Add Item"),
                icon: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    child: Dialog(
                      child: ListView(
                        padding: EdgeInsets.all(5),
                        shrinkWrap: true,
                        children: <Widget>[
                          TextField(
                            controller: textFieldControllerForItem,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter a item.",
                            ),
                          ),
                          RaisedButton(
                              color: _isDarkTheme ? Colors.black : Colors.blue,
                              textColor: Colors.white,
                              child: Text("Add Item"),
                              onPressed: () async {
                                await ToDoListManager.insertToDoListItem(
                                    ToDoListItemModel(
                                        id: null,
                                        titleId: widget.toDoListTitleObject.id,
                                        itemName: textFieldControllerForItem.text.toString(),
                                        isCompleted: isTaskCompleted.no.index,
                                      )
                                    );
                                setState(() {
                                  _future = ToDoListManager.getToDoListItemsByTitleId(widget.toDoListTitleObject.id);
                                });
                                textFieldControllerForItem.clear();
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
              FloatingActionButton.extended(
                backgroundColor: _isDarkTheme ? Colors.grey[800] : Colors.blue,
                heroTag: "deleteTitleButton",
                label: Text("Delete All Items"),
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    child: Dialog(
                      child: ListView(
                        padding: EdgeInsets.all(5),
                        shrinkWrap: true,
                        children: <Widget>[
                          Text("Do you want to delete all items?"),
                          RaisedButton(
                              color: _isDarkTheme ? Colors.black : Colors.blue,
                              textColor: Colors.white,
                              child: Text("Yes"),
                              onPressed: () async {
                                ToDoListManager.deleteAllToDoListItemsByTitleId(widget.toDoListTitleObject.id);
                                Navigator.popUntil(context, ModalRoute.withName("/toDoList"));
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
            ],
          ),
        )
    );
  }
}