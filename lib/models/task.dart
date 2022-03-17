class Task {
  String id, name, userId;

  bool completed = false;

  num createdAt, completedAt;

  static Task fromMap(var data) {
    return Task()
      ..id = data["id"]
      ..name = data["name"]
      ..completed = data["completed"]
      ..completedAt = data["completedAt"]
      ..createdAt = data["createdAt"]
      ..userId = data["userId"];
  }

  toMap() {
    return {
      "id": id,
      "name": name,
      "completed": completed,
      "completedAt": completedAt,
      "createdAt": createdAt,
      "userId": userId,
    };
  }
}
