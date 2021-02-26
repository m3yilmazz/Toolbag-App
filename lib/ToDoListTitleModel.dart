class ToDoListTitleModel {
  ToDoListTitleModel({this.id, this.title, this.isCompleted});

  int id;
  String title;
  int isCompleted;

  ToDoListTitleModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.title = json["title"];
    this.isCompleted = json["isCompleted"];
  }

  Map<String, dynamic> toDoListTitleToMap() {
    return {
      "id": id,
      "title": title,
      "isCompleted": isCompleted,
    };
  }
}
