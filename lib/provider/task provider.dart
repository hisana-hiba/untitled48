import 'package:flutter/material.dart';

import '../db/task database.dart';
import '../model/task model.dart';


class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  Future<void> fetchTasks() async {
    _tasks = await TaskDatabase.instance.fetchTasks();
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    await TaskDatabase.instance.insertTask(task);
    await fetchTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    await TaskDatabase.instance.updateTask(task);
    await fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await TaskDatabase.instance.deleteTask(id);
    await fetchTasks();
  }
}
