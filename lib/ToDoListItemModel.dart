class ToDoListItemModel {
  ToDoListItemModel({this.id, this.titleId, this.itemName, this.isCompleted});

  int id;
  int titleId;
  String itemName;
  int isCompleted;

  ToDoListItemModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.titleId = json["titleId"];
    this.itemName = json["itemName"];
    this.isCompleted = json["isCompleted"];
  }

  Map<String, dynamic> toDoListItemToMap() {
    return {
      "id": id,
      "titleId": titleId,
      "itemName": itemName,
      "isCompleted": isCompleted,
    };
  }
}
