class ToDo {
  String taskName;
  String taskContent;
  String category;
  bool isImportant;
  bool isCompleted;
  String createdDate;
  String? dueDate;

  ToDo({
    required this.taskName,
    required this.taskContent,
    required this.category,
    required this.isImportant,
    required this.isCompleted,
    required this.createdDate,
    this.dueDate,
  });

  ToDo.fromJson(Map<String, dynamic> json)
      : taskName = json["taskName"],
        taskContent = json["taskContent"],
        category = json["category"],
        isImportant = json["isImportant"],
        isCompleted = json["isCompleted"],
        createdDate = json["craetedDate"],
        dueDate = json["dueDate"];

  Map<String, dynamic> toJson() => {
        'taskName': taskName,
        'taskContent': taskContent,
        'category': category,
        'isImportant': isImportant,
        'isCompleted': isCompleted,
        'craetedDate': createdDate,
        'dueDate': dueDate,
      };

  @override
  String toString() {
    return "Task name: $taskName\nTask content: $taskContent\nCategory: $category\nImportant: $isImportant\nCompleted: $isCompleted\nDate: $createdDate\nDue date: $dueDate";
  }

  @override
  bool operator ==(Object other) {
    return other is ToDo &&
        other.taskName == taskName &&
        other.taskContent == taskContent &&
        other.category == category &&
        other.isImportant == isImportant &&
        other.isCompleted == isCompleted &&
        other.createdDate == createdDate &&
        other.dueDate == dueDate;
  }

  @override
  int get hashCode => Object.hash(taskName, taskContent, category, isImportant,
      isCompleted, createdDate, dueDate);

  // compare to
}
