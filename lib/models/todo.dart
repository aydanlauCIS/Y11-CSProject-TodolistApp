import 'package:flutter/material.dart';

enum TaskState { current, overdue, archived }

class Todo {
  Todo({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isOverdue,
    this.archived = false,
    this.state = TaskState.current,
  });

  final String title;
  final String description;
  final DateTime dueDate;
  bool isOverdue;
  bool archived;
  TaskState state;

  static bool isDateOverdue(date) {
    return DateUtils.dateOnly(DateTime.now()).compareTo(date) > 0;
  }

  static Todo createTodoFromMap(Map map) {
    return Todo(
      title: map["title"],
      description: map["description"],
      dueDate: DateTime.parse(map["dueDate"].toString()),
      isOverdue: map["isOverdue"],
      archived: map["archived"],
      state: TaskState.values[map["state"]],
    );
  }

  Map createMapFromTodo() {
    return {
      "title": title,
      "description": description,
      "dueDate": dueDate.toString(),
      "isOverdue": isOverdue,
      "archived": archived,
      "state": state.index,
    };
  }

  void toggleArchived() {
    archived = !archived;
    isOverdue = isDateOverdue(dueDate);
    updateState();
  }

  void updateState() {
    if (archived) {
      state = TaskState.archived;
    } else if (isDateOverdue(dueDate)) {
      state = TaskState.overdue;
    } else {
      state = TaskState.current;
    }
  }
}
