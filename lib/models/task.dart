class Task {
  int? id;
  String? name;
  String? description;

  // Init
  Task(this.id, this.name, this.description);

  // FromMap
  Task.fromMap(Map<String, dynamic> taskInfo) {
    id = taskInfo['id'];
    name = taskInfo['name'];
    description = taskInfo['description'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> taskInfo = {
      'name': name,
      'description': description,
    };

    if (id != null) {
      taskInfo['id'] = id;
    }

    return taskInfo;
  }
}